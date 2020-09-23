<?php

include 'function/config.properties';
include 'function/function.php';

?>

<!DOCTYPE html>
<html lang=it>
<head>
    <title><?php echo $title;?></title>
    <meta http-equiv=Content-Type content="text/html; charset=utf-8"/>
    <meta name=viewport content="width=device-width, initial-scale=1" />
    <meta http-equiv=content-type content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="assets/css/style.css"/>
    <style type=text/css>div.mod_search40 input[type="search"]{width:auto}</style>
    <style>#description{margin-bottom:25px}</style>
    <script src="assets/js/jquery_3.5.1/jquery.min.js"></script>
</head>
<body>
<header>
	<div class="logo"><img src="assets/img/rndt-logo.png" title="RNDT md converter" width="90" height="90"/></a></div>
    <h1><?php echo $title?></h1>
</header>
<div id=page-wrapper class=container-fluid>
    <div id=page>

        <div class="top25 bottom25">
            <div class="col-md-offset-3 col-md-6">
                <script>
                    function tellme(){
                        var a = "https://<?php echo $_SERVER['SERVER_NAME'];?>/geodcat-ap_it/<?php echo FILE_OUTPUT_DEBUG;?>?";
                        a += "outputTransformation=" + document.getElementById("outputTransformation").value;
                        a += "&inputFormat=" + document.getElementById("inputFormat").value;
                        a += "&outputFormat=" + (document.getElementById("outputFormat").value.replace("application/ld+json", "JSON").replace("application/rdf+xml", "XML"));
                        a += "&src=" + encodeURIComponent(document.getElementById("src").value);
                        document.getElementById("tell").innerHTML = a
                    };
                    $(document).ready(function(){
                        $( "#api" ).submit(function( event ) {
                            if($("#src").val().length > 2083){//2,083 max internet explorer get
                                alert("ATTENZIONE: la lunghezza del parametro di input è superiore a 2083 caratteri (limite per la chiamata GET); effettuare la chiamata in POST.");
                                event.preventDefault();
                            }


                        });
                    });


                </script>
                <nav>
                </nav>
                <?php if(!empty($Description)):?>
                    <section id=description class=p25>
                        <?php echo $Description;?>
                    </section>
                <?php endif;?>
                <section id=input-box class=p25>
                    <form id=api action=<?php echo FILE_OUTPUT_DEBUG;?> method=get>
                        <h2 class=bottom20>
                            Inserire richiesta get:
                        </h2>
                        <p>
                            <label for=outputTransformation>Trasformazione di output : </label>
                            <select id=outputTransformation name=outputTransformation onChange=tellme()>
                                <?php foreach ($outputSchemas as $k => $v) { echo '            <option value="' . $k . '">' . $v['label'] . '</option>' . "\n"; } ?>
                            </select>
                        </p>
                        <p style=float:left>
                            <label for=inputFormat>Formato di input : </label>
                            <select id=inputFormat name=inputFormat onChange=tellme()>
                                <option value=CSW>CSW</option>
                                <option value=REST>REST</option>
                            </select>
                        </p>
                        <p style=float:right>
                            <label for=outputFormat>Formato di output : </label>
                            <select id=outputFormat name=outputFormat onChange=tellme()>
                                <?php

                                foreach ($outputFormats as $k => $v) {
                                    $selected = '';
                                    if ($k == $defaultOutputFormat) {
                                        $selected = ' selected="selected"';
                                    }
                                    echo '            <option value="' . $k . '"' . $selected . '>' . $v[0] . '</option>' . "\n";
                                }

                                ?>
                            </select>
                        </p>
                        <p>
                            <textarea id=src name=src wrap=soft cols=80 rows=7 placeholder="Inserire la richiesta CSW o REST" required=required onMouseOut=tellme()></textarea>
                        </p>
                        <textarea id=tell wrap=soft cols=80 rows=7 class=top20 disabled></textarea>
                        <p><input style=float:right type=submit id=transform value="Trasforma"/></p>
                    </form>
                </section>
                <section id=postBox class="top25 p25">
                    <form action=<?php echo FILE_OUTPUT_DEBUG;?>  method=post>
                        <h2 class=bottom20>
                            <label for=xmlPicker>Inserire richiesta post: </label>
                        </h2>
                        <p style=float:left>
                            <label for=outputTransformation>Trasformazione di output : </label>
                            <select id=outputTransformation name=outputTransformation>
                                <option value=geodcatap_it>GeoDCAT-AP_IT</option>
                                <option value=dcatap_it>DCAT-AP_IT</option>
                            </select>
                        </p>
                        <p style=float:right>
                            <label for=outputFormat>Formato di output : </label>
                            <select id=outputFormat name=outputFormat>
                                <?php

                                foreach ($outputFormats as $k => $v) {
                                    $selected = '';
                                    if ($k == $defaultOutputFormat) {
                                        $selected = ' selected="selected"';
                                    }
                                    echo '            <option value="' . $k . '"' . $selected . '>' . $v[0] . '</option>' . "\n";
                                }

                                ?>
                            </select>
                        </p>
                        <textarea id=xmlPicker name=src_xml rows=7 cols=80></textarea>
                        <p>
                            <input style=float:right type=submit id=doPost value="Trasforma"/>
                        </p>
                    </form>
                </section>
                <div class="footer" class="top25">
    <footer>RNDT GeoDCAT-AP API - GitHub: <a target='_blank' href="<?php echo $apiSrcRep; ?>">https://github.com/AgID/rndt-geodcat-ap-api</a></footer>
</div>
            </div>
        </div>
    </div>
</body>
</html>
