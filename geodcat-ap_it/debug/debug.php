<?php

include 'function/config.properties';
?>
<!DOCTYPE html>
<html lang=it>
<head>
    <title><?php echo $title;?></title>
    <meta http-equiv=Content-Type content="text/html; charset=utf-8"/>
    <meta name=viewport content="width=device-width, initial-scale=1" />
    <meta http-equiv=content-type content="text/html; charset=utf-8" />
    <meta name=author content="Amministratore Sistema admin" />
    <meta name=generator content="Joomla! - Open Source Content Management" />
    <style type=text/css>div.mod_search40 input[type="search"]{width:auto}</style>
    <script src="./assets/js/jquery_3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="./assets/css/style.css"/>
    <style>#description{margin-bottom:25px}

        .simpleXML {
            font-family: 'Courier New';
            background-color: white;
            font-size: 12px!important;
            padding: 7px;
            display: block;
        }

        #code{

        }
        #pathXML{
            border: 1px solid;
            display: block;
            padding: 25px;
        }
    </style>
    <script src="./assets/lib/tree-xml-viewer-formatter/js/simpleXML.js"></script>
    <link rel="stylesheet" href="./assets/lib/tree-xml-viewer-formatter/css/simpleXML.css" />
    <script language="javascript">
        $(document).ready(function () {
            $("#UlelementXML").appendTo("#pathXML");
            $("#timePut").appendTo("#timePutV");

            if( $("code_convert").length !== 0 && $("code").html() !== ""){
                var xml = $("code_convert").html();
                try {
                    $("#code").empty().simpleXML({ xmlString: xml });
                } catch (e) {
                    $("#code").empty().append("Exception caught running plugin : " + ex);
                    alert(e);
                }
            }
        });
    </script>
</head>

<body>

<div id="timePutV"></div>
<div id="pathXML"></div>
<div id="code">
    <?php include 'function/function.php'; ?>
</div>

<ul id="UlelementXML">
    <?php
    if(DEBUG){
        global $ARRAY_DOWNLOADFILE;
        if(count($ARRAY_DOWNLOADFILE) !== 0){
            foreach ($ARRAY_DOWNLOADFILE as $item){
                echo "<li><a href='./".$item["path"]."' target='_blank' download>".$item["name"]."</a></li>";
            }
        }
    }
    ?>
</ul>
<div id="timePut">
    <?php
    global $execution_time;
    echo '<b>Total Execution Time:</b> '.$execution_time.' seconds';
    ?>
</div>



</body>
