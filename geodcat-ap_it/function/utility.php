<?php
global $errorCountReturnHTTP;
$errorCountReturnHTTP = false;

if (isset($outputSchemas[$DEFAULT_OUTSCHEMA])) {
    $defaultOutputSchema = $DEFAULT_OUTSCHEMA;
}
else if (isset($outputSchemaDecoder[$DEFAULT_OUTSCHEMA])) {
    $defaultOutputSchema = $outputSchemaDecoder[$DEFAULT_OUTSCHEMA];
} else {
    $defaultOutputSchema = $DEFAULT_OUTSCHEMA;
}

$outputFormats = array();
$outputFormats['application/rdf+xml'] = array('RDF/XML','rdf');
$outputFormats['application/ld+json'] = array('JSON-LD','jsonld');
$defaultOutputFormat = 'application/rdf+xml';

$yesterday = date('Y-m-d',strtotime("-1 days"));

function getSchemaFormat($out_schema, $out_format, $defOutFor, $outputFormats, $outputFormatDecoder, $invisibleSchemas, $outputSchemas, $outputSchemaDecoder){
    $err_combination = 0;
    if (isset($outputFormats[$out_format])) {
        $outputFormat = $out_format;
    } else if (isset($outputFormatDecoder[$out_format])) {
        $outputFormat = $outputFormatDecoder[$out_format];
    } else {
        $outputFormat = $defOutFor;
    }

    if (isset($invisibleSchemas[$out_schema])){
        $ret_schema = $invisibleSchemas[$out_schema];
        if ($outputFormat != 'application/ld+json'){
            $err_combination = 1;
        }
    } else if (isset($outputSchemas[$out_schema])) {
        $ret_schema = $outputSchemas[$out_schema];
    } else if (isset($outputSchemaDecoder[$out_schema])) {
        $outputSchema = $outputSchemaDecoder[$out_schema];
        $ret_schema = $outputSchemas[$outputSchema];
    } else {
        $outputSchema = $defOutFor;
        $ret_schema = $outputSchemaDecoder[$outputSchema];
    }
    $retVal = array(
        'err' => $err_combination,
        'out_schema' => $ret_schema,
        'out_format' => $outputFormat
    );
    return $retVal;
}

function returnHttpError($code) {
    //global $errorCountReturnHTTP;
    //if($errorCountReturnHTTP) $errorCountReturnHTTP++;
    //else return;
    $title =  $_SERVER["SERVER_PROTOCOL"] . ' ' . $code;
    $content = '';

    switch ($code) {
        case 204 :
            $title .= ' Nessun contenuto';
            $content = 'La URL richiesta <code>' . $_SERVER["REQUEST_URI"] . '</code> presenta un contenuto vuoto.';
            break;
        case 300:
            $title .= ' Multiple Choices';
            $content = '';
            break;
        case 400:
            $title .= ' Parametri insufficienti o non corretti';
            $content = 'I parametri nella richiesta al server <code>' . $_SERVER["REQUEST_URI"] . '</code> non sono corretti. Ad esempio non è possibile fare una richiesta REST e trasformare i dati in GeoDCAT-AP o DCAT-AP. Verificare.';
            break;
        case 404:
            $title .= ' Non trovato';
            $content = 'La URL richiesta <code>' . $_SERVER["REQUEST_URI"] . '</code> non è presente sul server.';
            break;
        case 415:
            $title .= ' Unsupported Media Type';
            $content = 'The server does not support the media type transmitted in the request.';
            break;
    }
    //http_response_code($code);
    echo '<!DOCTYPE html><html><head><title>' . $title . '</title><link rel="stylesheet" type="text/css" href="./assets/css/style.css"/></head><body><header><h1>' . $title . '</h1></header><section><p>' . $content . '</p></section></body></html>';
    if(!DEBUG) exit;
}

function elaborateRequestSRC_XML($retVal, $URL_POST, $yesterday, $outputSchemas){
    $xsluri = $retVal['out_schema']['xslt'];
    $outputFormat = $retVal['out_format'];
    $outputSchema = $retVal['out_schema']['params']['profile'];

    if (isset($_REQUEST['src_xml'])){
        $xml_data = $_REQUEST['src_xml'];
    }
    else if (isset($_FILES['src_xml'])){
        $xml_data = file_get_contents($_FILES['src_xml']['tmp_name']);
    }
    //$url = $URL_POST;


    $xml = new DOMDocument;
    $xml = multiCallCSWPost($xml,$URL_POST,$xml_data);
    if(empty($xml)) return;

    /*$page = "/geoportalRNDTPA/csw";
    $headers = array(
        "POST ".$page." HTTP/1.0",
        "Content-type: text/xml;charset=\"utf-8\"",
        "Accept: text/xml",
        "Cache-Control: no-cache",
        "Pragma: no-cache",
        "SOAPAction: \"run\"",
        "Content-length: ".strlen($xml_data)
    );

    $ch = curl_init();

    curl_setopt($ch, CURLOPT_URL,$url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_TIMEOUT, 60);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);

    // Apply the XML to our curl call
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $xml_data);
    $data = curl_exec($ch);
    if (curl_errno($ch)) {
        returnHttpError(400);
    } else {
        curl_close($ch);*/
        // Set headers and show me the result
        $link[] = array(
            "href" => $outputSchema,
            "rel" => "profile",
            "type" => $outputFormat,
            "title" => $outputSchema
        );
        $linkHTTP = array();
        foreach ($link as $v) {
            $linkHTTP[] = '<' . $v["href"] . '>; rel="' . $v["rel"] . '"; type="' . $v["type"] . '"; title="' . $v["title"] . '"';}

        //$xml = simplexml_load_string($data);
        $xsl = new DOMDocument;
        if (!$xsl->load($xsluri)) {
            returnHttpError(404);
        }

        // Transforming the source document into RDF/XML oppure json

        $proc = new XSLTProcessor();
        $proc->importStyleSheet($xsl);

        foreach ($outputSchemas[$outputSchema]['params'] as $k => $v) {
            $proc->setParameter("", $k, $v);
        }
        if (($outputSchema == 'dcatap_it') or ($outputSchema == 'geodcatap_it')) {
            $proc->setParameter("", 'foutput', $outputFormat);
            $proc->setParameter("", "yesterday", $yesterday);
        }

        if (!$rdf = $proc->transformToXML($xml)) {
            if(DEBUG) libxml_get_last_error();
            returnHttpError(404);
        } else  if ((($outputSchema == 'dcatap_it') or ($outputSchema == 'geodcatap_it')) ){
            $outputExt = '.rdf';
            if ($outputFormat == 'application/ld+json'){
                $rdf = str_replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "", $rdf);
                $outputExt = '.json';
            }
        }
        if(DEBUG){
            if(VISIBLE_OUTPUT_DEBUG){
                $rdf = "<code_convert>".$rdf."</code_convert>";
            }else{
                global $part;
                global $ARRAY_DOWNLOADFILE;
                $name = "output.xml";
                array_push($ARRAY_DOWNLOADFILE,array(
                    "name"=>$name,
                    "path"=>$part.$name
                ));

                global $DIR;
                $fp = fopen($DIR.$name,"w");
                fwrite($fp, $rdf);
                fclose($fp);
                return;
            }

        }else{
            header("Content-type: " . $outputFormat );
            header('Link: ' . join(', ', $linkHTTP));
            header('Content-Disposition: attachment; filename="dati'.$outputExt.'"');
            header('Expires: 0');
            header('Cache-Control: must-revalidate');
        }

        echo $rdf;
        if(!DEBUG) exit; else return;
    //}
}

function elaborateRequestSRC(
    $retVal,
    $URL_REST,
    $URL_POST,
    $URL_SINGLE_FILE,
    $yesterday,
    $outputSchemas,
    $defaultOutputFormat,
    $outputFormatDecoder,
    $outputFormats,
    $XSLT_RDF2RDFA,
    $title,
    $apiSrcRep){


    $xmluri = $_REQUEST['src'];

    $xml = new DOMDocument;

    // sono in presenza di una richiesta REST?
    if (isset($_REQUEST['inputFormat']) and ($_REQUEST['inputFormat'] == 'REST')){
        if ((isset($_REQUEST['outputTransformation'])) and (($_REQUEST['outputTransformation'] == 'core') or ($_REQUEST['outputTransformation'] == 'extended'))){
            returnHttpError(400);
        }
        if($_GET){
            $xmluri = str_replace(" ", "%20", rawurldecode ($xmluri));
            $xmluri = str_replace("+", "%20", $xmluri);
            $xmluri = str_replace('"', '%22', $xmluri);
        }


        // controllo che l'URI per la chiamata REST contenga il parametro obbligatorio formato json
        $pos = strpos($xmluri, '&f=json'); // valore fisso obbligatorio. se manca lo metto, se è diverso lo cambio.
        if ($pos == ''){
            $pos = strpos($xmluri, '&f=');
            if ($pos == ''){$xmluri = $xmluri . '&f=json';}
            else{
                $pos2 = strpos($xmluri, '&', $pos+1);
                if ($pos2 == ''){$xmluri = substr($xmluri, 0, $pos).'&f=json';}
                else {$xmluri = substr($xmluri, 0, $pos).'&f=json'.substr($xmluri, $pos2, strlen($xmluri)-$pos2);}
            }
        }
        $xmluri = $URL_REST.$xmluri;

        if (!$js = file_get_contents($xmluri)) {
            returnHttpError(404);
        }

        $json_decoded = json_decode($js);
        $bubble = '';
        $nRecMat = $json_decoded->{'totalResults'};
        $startIndex = $json_decoded->{'startIndex'};
        $itemsPerPage = $json_decoded->{'itemsPerPage'};
        $updated = $json_decoded->{'updated'};
        $tempXml = new DOMDocument; // test su eventuali xml non corretti
        for ($i = 0; $i < count($json_decoded->{'records'}); $i++) {
//            echo $i.",";
//echo $json_decoded->{'records'}[$i]->{'id'} . ' ';
            $tmpStr = file_get_contents($URL_SINGLE_FILE.$json_decoded->{'records'}[$i]->{'id'});
            // rimpiazzo una url per l'attuale crisi degli standard in corso
            $tmpStr = str_replace("http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/gmd/gmd.xsd","https://www.ngdc.noaa.gov/metadata/published/xsd/schema.xsd", $tmpStr);
            try {
#                $tempXml = simplexml_load_string($tmpStr); // se fallisce è un xml problematico
                $pos = strpos($tmpStr, '>');
                $tmpStr = substr ( $tmpStr , $pos+1); // questo serve ad eliminare <?xml version ...> in testa ai singoli file
                $bubble = $bubble . $tmpStr;
//                echo $i."#, ";
            } catch (Exception $e) {
                echo $json_decoded->{'records'}[$i]->{'id'} . ' err ';
            }
        }

        $bubble ='<?xml version="1.0" encoding="UTF-8"?><csw:GetRecordsResponse xmlns:csw="http://www.opengis.net/cat/csw/2.0.2">
<csw:SearchStatus timestamp="'.$updated.'"/>
<csw:SearchResults elementSet="full" nextRecord="'.($startIndex+$itemsPerPage).'" numberOfRecordsMatched="'.$nRecMat.'" numberOfRecordsReturned="'.$itemsPerPage.'" recordSchema="http://www.isotc211.org/2005/gmd">'.$bubble."</csw:SearchResults></csw:GetRecordsResponse>";

        $xml = simplexml_load_string($bubble);
    } else {
        // non sono in presenza di una richiesta REST, quindi è una richiesta CSW. Inserisco l'URL del server dalle properties:
        //$pos = strpos($xmluri, '/', 10);
        //$xmluri = $URL_CSW.substr ($xmluri , $pos);

        //$xmluri = $URL_POST.'?'.rawurldecode($xmluri);
        //$xml = multiCallCSW($xml,$xmluri);
        $xml = multiCallCSWPost($xml,$URL_POST,rawurldecode($xmluri));
        if(empty($xml)) return;
        /*
         * if (!$xml->load($url)) {
            returnHttpError(404);
        }
         */
    }


    $xsluri = $retVal['out_schema']['xslt'];
    $outputFormat = $retVal['out_format'];
    $outputSchema = $retVal['out_schema']['params']['profile'];




    // Loading the XSLT to transform the source document into RDF/XML

    $xsl = new DOMDocument;
    if (!$xsl->load($xsluri)) {
        returnHttpError(404);
    }

// Transforming the source document into RDF/XML

    $proc = new XSLTProcessor();
    $proc->importStyleSheet($xsl);

    foreach ($outputSchemas[$outputSchema]['params'] as $k => $v) {
        $proc->setParameter("", $k, $v);
    }
    if (($outputSchema == 'dcatap_it') or ($outputSchema == 'geodcatap_it')){
        $proc->setParameter("", "yesterday", $yesterday);
    }

//    echo " messi i parametri ".$outputSchemas[$outputSchema]['params'];

// Setting the output format

    $outputFormat = $defaultOutputFormat;
    if (isset($_REQUEST['outputFormat'])) {
//echo " il formato di uscita ".$_REQUEST['outputFormat'];
        if (isset($outputFormatDecoder[$_REQUEST['outputFormat']])) {
            $outputFormat = $outputFormatDecoder[$_REQUEST['outputFormat']];
        }
        else if (!isset($outputFormats[$_REQUEST['outputFormat']])) {
            returnHttpError(415);
        }
        else {
            $outputFormat = $_REQUEST['outputFormat'];
        }
    }
    else {
        preg_match_all("/[a-zA-Z0-9]+\/[a-zA-Z0-9\!\#\$\&\-\^_\.\+]+/",$_SERVER['HTTP_ACCEPT'],$matches);
        if (count($matches[0]) == 0) {
            returnHttpError(415);
        }
        else {
            $acceptedFormats = $matches[0];
            $supportedFormats = array_keys($outputFormats);
            $candidateFormats = array_values(array_intersect($supportedFormats, $acceptedFormats));
            switch (count($candidateFormats)) {
                case 0:
                    returnHttpError(415);
                    break;
                case 1:
                    $outputFormat = $candidateFormats[0];
                    break;
                default:
                    returnHttpError(300);
                    break;
            }
        }
    }

// l'output format rdf o json, in GeoDCATAP_IT e DCATAP_IT è già nell'xslt.
// per questi due protocolli impongo il formato nei parametri

    if (($outputSchema == 'dcatap_it') or ($outputSchema == 'geodcatap_it'))  {
        $proc->setParameter("", "yesterday", $yesterday);
        if ($outputFormat == 'application/ld+json'){
            $proc->setParameter("", 'foutput', $outputFormat);
        }
    }

// ora posso fare la trasformazione


    if (!$rdf = $proc->transformToXML($xml)) {
        returnHttpError(404);
    } else  if ((($outputSchema == 'dcatap_it') or ($outputSchema == 'geodcatap_it')) ){// and ($outputFormat == 'application/ld+json')){
        $outputExt = '';
        if ($outputFormat == 'application/ld+json'){
            $rdf = str_replace("<?xml version=\"1.0\" encoding=\"utf-8\"?>", "", $rdf);
            $outputExt = '.json';
        } else {
            $outputExt = '.rdf';
        }


        if(DEBUG){
            if(VISIBLE_OUTPUT_DEBUG){
                $rdf = "<code_convert>".$rdf."</code_convert>";
            }else{
                global $part;
                global $ARRAY_DOWNLOADFILE;
                $name = "output.xml";
                array_push($ARRAY_DOWNLOADFILE,array(
                    "name"=>$name,
                    "path"=>$part.$name
                ));

                global $DIR;
                $fp = fopen($DIR.$name,"w");
                fwrite($fp, $rdf);
                fclose($fp);
                return;
            }
        }else{
            header("Content-type: " . $outputFormat);
            header('Content-Disposition: attachment; filename="dati'.$outputExt.'"');
            header('Expires: 0');
            header('Cache-Control: must-revalidate');
        }

        echo $rdf;

        if(!DEBUG) exit; else return;
    }


// Related resources

// The metadata profile of the output resource (output schema)
    $link[] = array(
        "href" => $outputSchema,
        "rel" => "profile",
        "type" => $outputFormat,
        "title" => $outputSchemas[$outputSchema]["label"]
    );
// The input resource
    $link[] = array(
        "href" => $xmluri,
        "rel" => "derivedfrom",
        "type" => "application/xml",
        "title" => "ISO 19139"
    );
// The available serialisations of the output resource (output format)
    foreach ($outputFormats as $k => $v) {
        $uri = str_replace($_SERVER['QUERY_STRING'], '', $_SERVER['REQUEST_URI']) . 'outputSchema=' . rawurlencode($outputSchema) . '&src=' . rawurlencode($xmluri) . '&outputFormat=' . rawurlencode($k);
        $rel = 'alternate';
        if ($k == $outputFormat) {
            $rel = 'self';
        }
        $link[] = array(
            "href" => $uri,
            "rel" => $rel,
            "type" => $k,
            "title" => $v[0]
        );
        $outputFormats[$k][] = $uri;
    }

// Building HTTP "Link" headers and HTML "link" elements pointing to the related resources

    $linkHTTP = array();
    $linkHTML = array();
    foreach ($link as $v) {
        $linkHTTP[] = '<' . $v["href"] . '>; rel="' . $v["rel"] . '"; type="' . $v["type"] . '"; title="' . $v["title"] . '"';
        $linkHTML[] = '<link href="' . $v["href"] . '" rel="' . $v["rel"] . '" type="' . $v["type"] . '" title="' . $v["title"] . '"/>';
    }

// Setting namespace prefixes

    EasyRdf_Namespace::set('adms', 'http://www.w3.org/ns/adms#');
    EasyRdf_Namespace::set('cnt', 'http://www.w3.org/2011/content#');
    EasyRdf_Namespace::set('dc', 'http://purl.org/dc/elements/1.1/');
    EasyRdf_Namespace::set('dcat', 'http://www.w3.org/ns/dcat#');
    EasyRdf_Namespace::set('gsp', 'http://www.opengis.net/ont/geosparql#');
    EasyRdf_Namespace::set('locn', 'http://www.w3.org/ns/locn#');
    EasyRdf_Namespace::set('prov', 'http://www.w3.org/ns/prov#');

// Creating the RDF graph from the RDF/XML serialisation

    $graph = new EasyRdf_Graph;
    $graph->parse($rdf);

// Sending HTTP headers

    header("Content-type: " . $outputFormat);
    header('Link: ' . join(', ', $linkHTTP));

// Returning the resulting document

    if ($outputFormat == 'text/html') {
        $xml = new DOMDocument;
// From the raw RDF/XML output of the XSLT
        $xml->loadXML($rdf) or die();
// From the re-serialised RDF/XML output of the XSLT
//      $xml->loadXML($graph->serialise("rdfxml")) or die();
        $xsl = new DOMDocument;
        $xsl->load($XSLT_RDF2RDFA);
        $proc = new XSLTProcessor();
        $proc->importStyleSheet($xsl);
// The title of the HTML+RDFa
        $proc->setParameter('', 'title', $title);
// The URL of the repository
        $proc->setParameter('', 'home', $apiSrcRep);
// All what needs to be added in the HEAD of the HTML+RDFa document
        $head = '<link rel="stylesheet" type="text/css" href="./css/style.css"/>\n'.join("\n", $linkHTML) . "\n";//
        $proc->setParameter('', 'head', $head);
        echo $proc->transformToXML($xml);
        return;
    }
    else {
// Block added to enable pretty-print output of the JSON-LD serialisation, not supported in the current version of EasyRdf
// Predefined constants are as per ML/JsonLD - see: https://github.com/lanthaler/JsonLD/blob/master/JsonLD.php
        if ($outputFormat == 'application/ld+json') {
            if ($outputSchema == 'core' or $outputSchema == 'extended') {
                echo json_encode(json_decode($graph->serialise($outputFormats[$outputFormat][1])), JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
            } else if ($outputSchema == 'geodcatap_it' or $outputSchema == 'dcatap_it') {
                // mostrare l'output talquale
                echo $rdf;
                //echo $graph->serialise($outputFormats[$outputFormat][1]);
            }
        }
        else {
            echo $graph->serialise($outputFormats[$outputFormat][1]);
        }
// To be used when JSON-LD pretty-print will be supported in EasyRdf (see previous comment)
//      echo $graph->serialise($outputFormats[$outputFormat][1]);
        return;
    }
}

function array_search_partial($arr, $keyword) {
    foreach($arr as $index => $string) {
        if (strpos($string, $keyword) !== FALSE)
            return $index;
    }
}



function multiCallCSW($xml,$url){

    $arrayPart = explode("&",parse_url($url)["query"]);

    $startPosition = 0;
    $maxRecords = 0;

    if(count($arrayPart) !== 0){
        foreach ($arrayPart as $value) {

            $exp = explode("=",$value);
            if (strpos($value, 'startPosition') !== false) {
                if(count($exp) > 1) $startPosition = intval($exp[1]);
            } else if (strpos($value, 'maxRecords') !== false) {
                if(count($exp) > 1) $maxRecords = intval($exp[1]);
            }

        }

    }

    if($startPosition !== 0 && $maxRecords !== 0){

        $maxItems = MAX_ITEMS_FOR_REQUEST > $maxRecords ? $maxRecords : MAX_ITEMS_FOR_REQUEST;

        $arrayElemMD_Metadata = array();
        for($i = $startPosition;$i<=($maxRecords+$startPosition);$i+=$maxItems){


            if($i+$maxItems > $maxRecords){
                if($maxRecords % $maxItems != 0){
                    $maxItems = $maxRecords % $maxItems;
                }
            }

            $newUrl = str_replace("startPosition=".$startPosition,"startPosition=".$i,$url);
            $newUrl = str_replace("maxRecords=".$maxRecords,"maxRecords=".$maxItems,$newUrl);

            $opts = array(
                "ssl"=>array(
                    "verify_peer"=>false,
                    "verify_peer_name"=>false,
                )
            );
            $context = stream_context_create($opts);

            //todo
            //if($_GET) $newUrl = rawurlencode($newUrl);

            $file = file_get_contents($newUrl,false,$context);

            if(empty($file)){

                returnHttpError(204);
                return;
            }else{
                //var_dump($file);
                $xmlNew = new DOMDocument();
                $xmlNew->loadXML($file);
                $elements = $xmlNew->getElementsByTagName('MD_Metadata');
                foreach($elements as $element){
                    array_push($arrayElemMD_Metadata,$element);
                }

                if(DEBUG){
                    global $part;
                    $patN = $maxItems+$i-1;
                    $name = "request_".$maxItems."_".$i."_".$patN.".xml";
                    global $ARRAY_DOWNLOADFILE;
                    array_push($ARRAY_DOWNLOADFILE,array(
                        "name"=>$name,
                        "path"=>$part.$name
                    ));

                    global $DIR;
                    $fp = fopen($DIR.$name,"w");
                    fwrite($fp, $file);
                    fclose($fp);
                }


                sleep(0.5);
            }


        }
        $elements = $xmlNew->getElementsByTagName('SearchResults')->item(0);



        $elements->setAttribute('numberOfRecordsReturned', count($arrayElemMD_Metadata));
        $elements->setAttribute('nextRecord', count($arrayElemMD_Metadata)+1);


        function deleteChildren($node) {
            while (isset($node->firstChild)) {
                deleteChildren($node->firstChild);
                $node->removeChild($node->firstChild);
            }
        }

        deleteChildren($elements);


        foreach ($arrayElemMD_Metadata as $elementsAdd){
            $elements->appendChild($xmlNew->importNode($elementsAdd,true));
        }
        $xmlStr = $xmlNew->saveXML();

        $xml->loadXML($xmlStr);

        if(DEBUG){
            global $part;
            global $ARRAY_DOWNLOADFILE;
            $name = "request_total.xml";
            array_push($ARRAY_DOWNLOADFILE,array(
                "name"=>$name,
                "path"=>$part.$name
            ));

            global $DIR;
            $fp = fopen($DIR.$name,"w");
            fwrite($fp, $xmlStr);
            fclose($fp);
        }



        return $xml;


    }else{
        if (!$xml->load($url)) {
            returnHttpError(404);
        }
        return $xml;
    }

}
function multiCallCSWPost($xml,$url,$xml_data){

    $arrayPart = explode("&",$xml_data);

    $startPosition = 0;
    $maxRecords = 0;

    if(count($arrayPart) !== 0){
        foreach ($arrayPart as $value) {

            $exp = explode("=",$value);
            if (strpos($value, 'startPosition') !== false) {
                if(count($exp) > 1) $startPosition = intval($exp[1]);
            } else if (strpos($value, 'maxRecords') !== false) {
                if(count($exp) > 1) $maxRecords = intval($exp[1]);
            }

        }

    }

    if($startPosition !== 0 && $maxRecords !== 0){

        $maxItems = MAX_ITEMS_FOR_REQUEST > $maxRecords ? $maxRecords : MAX_ITEMS_FOR_REQUEST;

        $arrayElemMD_Metadata = array();

        for($i = $startPosition;$i<=($maxRecords+$startPosition);$i+=$maxItems){

            if($i+$maxItems > $maxRecords){
                if($maxRecords % $maxItems != 0){
                    $maxItems = $maxRecords % $maxItems;
                }
            }

            $new_xml_data = str_replace("startPosition=".$startPosition,"startPosition=".$i,$xml_data);
            $new_xml_data = str_replace("maxRecords=".$maxRecords,"maxRecords=".$maxItems,$new_xml_data);

            if (strpos($new_xml_data, 'Constraint=') !== false) {
                $ar = explode("Constraint=",$new_xml_data);
                $new_xml_data = $ar[0]."&Constraint=".urlencode($ar[1]);
            }

            $opts = array(
                "ssl"=>array(
                    "verify_peer"=>false,
                    "verify_peer_name"=>false,
                )
            );
            $context = stream_context_create($opts);

            $newUrl = $url."?".$new_xml_data;

            $file = file_get_contents($newUrl,false,$context);

            if(empty($file)){

                returnHttpError(204);
                return;
            }else{
                //var_dump($file);
                $xmlNew = new DOMDocument();
                $xmlNew->loadXML($file);
                $elements = $xmlNew->getElementsByTagName('MD_Metadata');
                foreach($elements as $element){
                    array_push($arrayElemMD_Metadata,$element);
                }

                if(DEBUG){
                    global $part;
                    $patN = $maxItems+$i-1;
                    $name = "request_".$maxItems."_".$i."_".$patN.".xml";
                    global $ARRAY_DOWNLOADFILE;
                    array_push($ARRAY_DOWNLOADFILE,array(
                        "name"=>$name,
                        "path"=>$part.$name
                    ));

                    global $DIR;
                    $fp = fopen($DIR.$name,"w");
                    fwrite($fp, $file);
                    fclose($fp);
                }


                sleep(0.5);
            }


        }
        if(empty($xmlNew)) return returnHttpError(404);

        $elements = $xmlNew->getElementsByTagName('SearchResults')->item(0);

        $elements->setAttribute('numberOfRecordsReturned', count($arrayElemMD_Metadata));
        $elements->setAttribute('nextRecord', count($arrayElemMD_Metadata)+1);


        function deleteChildren($node) {
            while (isset($node->firstChild)) {
                deleteChildren($node->firstChild);
                $node->removeChild($node->firstChild);
            }
        }

        deleteChildren($elements);


        foreach ($arrayElemMD_Metadata as $elementsAdd){
            $elements->appendChild($xmlNew->importNode($elementsAdd,true));
        }
        $xmlStr = $xmlNew->saveXML();

        $xml->loadXML($xmlStr, LIBXML_COMPACT|LIBXML_PARSEHUGE);

        if(DEBUG){
            global $part;
            global $ARRAY_DOWNLOADFILE;
            $name = "request_total.xml";
            array_push($ARRAY_DOWNLOADFILE,array(
                "name"=>$name,
                "path"=>$part.$name
            ));

            global $DIR;
            $fp = fopen($DIR.$name,"w");
            fwrite($fp, $xmlStr);
            fclose($fp);
        }



        return $xml;


    }else{
        if (!$xml->load($url)) {
            returnHttpError(404);
        }
        return $xml;
    }

}
