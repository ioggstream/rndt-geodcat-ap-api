<?php
require('./lib/composer/vendor/autoload.php');

define("FILE_OUTPUT_DEBUG",DEBUG ? "debug.php":"index.php");
if(DEBUG){
    $time_start = microtime(true);
    global $ARRAY_DOWNLOADFILE;
    $ARRAY_DOWNLOADFILE = array();

    global $part;
    $part = "/debug/".date('Y-m-d H_i_s',time())."/";

    global $DIR;
    $parthDir = dirname(dirname(__FILE__));
    $DIR = $parthDir.$part;
    ini_set('display_errors', 1);
    ini_set('display_startup_errors', 1);
    error_reporting(E_ALL);

    if(DEBUG){
        global $DIR;
        mkdir($DIR, 0777,true);

    }
}

require('utility.php');

if($_REQUEST){
    $retVal = getSchemaFormat($_REQUEST['outputTransformation'], $_REQUEST['outputFormat'], $defaultOutputFormat, $outputFormats, $outputFormatDecoder, $invisibleSchemas, $outputSchemas, $outputSchemaDecoder);

    if ($retVal['err'] == 1) {
        returnHttpError(400);
    }else{
        if(isset($_REQUEST['src_xml']) or isset($_REQUEST['src_xml'])) elaborateRequestSRC_XML($retVal,$URL_POST, $yesterday,$outputSchemas);
        else if(isset($_REQUEST['src'])) elaborateRequestSRC($retVal,
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
            $apiSrcRep);
    }
}


if(DEBUG){
    global $execution_time;
    $time_end = microtime(true);

    $execution_time = number_format(($time_end - $time_start), 2, '.', '');
}


