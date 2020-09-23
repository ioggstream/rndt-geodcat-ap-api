# RNDT GeoDCAT-AP API

[![License: EUPL 1.2](https://img.shields.io/badge/License-EUPL&nbsp;1.2-blue.svg)](https://joinup.ec.europa.eu/sites/default/files/custom-page/attachment/eupl_v1.2_it.pdf)

L&#39;API di RNDT per l&#39;implementazione di GeoDCAT-AP consente di trasformare i metadati dei dati documentati secondo il profilo italiano RNDT, dallo standard ISO TS 19139 allo standard DCAT-AP/DCAT-AP_IT (estensione italiana di DCAT-AP) utilizzato per i dati aperti.

L&#39;API accetta sia richieste CSW (GET e POST) che richieste REST e restituisce i metadati in formato RDF/XML o JSON-LD.

Le richieste REST devono essere coerenti con le [**API RNDT**](https://geodati.gov.it/geoportale/strumenti/api-rest).

Per ulteriori informazioni sull'uso dell'API, fare riferimento alla [**guida rapida per l'utente**](https://github.com/AgID/rndt-geodcat-ap-api/wiki/Guida-rapida-per-l'utente).

Una installazione della soluzione è disponibile sul [**portale RNDT**](https://geodati.gov.it/geodcat-ap_it/).

## Istruzioni per l'installazione
La soluzione è stata sviluppata in PHP 7.1 e gira su qualsiasi web server che ospita quella versione di PHP. Essa è stata testata su Linux, Windows and iOS.

Utilizza le librerie EasyRDF e ML/JSON-LD di PHP che sono [già disponibili nel repository](geodcat-ap_it/lib/composer).

Il repository include tutto ciò che è necessario per l'installazione e l'avvio, copiando la cartella di distribuzione [**geodcat-ap_it**](geodcat-ap_it) in una 'web folder'. Prima dell'avvio è necessario configurare i parametri presenti nel file [```function/config.properties```](geodcat-ap_it/function/config.properties) secondo le indicazioni ivi presenti.
 
**NOTA 1** - Il file [```publiccode.yml```](publiccode.yml) è un file di metadati richiesto per il software della pubblica amministrazione italiana e non è funzionale all'uso dell'API. Esso è stato inserito per consentire al crawler automatico di Developers Italia di raccogliere tutte le informazioni utili al popolamento del [catalogo del software open source](https://developers.italia.it/it/software).

**NOTA 2** - La cartella [```images/```](images) contiene le immagini per il [```wiki```](https://github.com/AgID/rndt-geodcat-ap-api/wiki) e non è funzionale all'uso del converter.

## Licenza
La licenza applicata è [European Union Public License v. 1.2](LICENSE).

## Credits
La soluzione è stata sviluppata da ESRI Italia per [AgID](https://www.agid.gov.it/) nell'ambito della gara per le **Infrastrutture Nazionali Condivise SPC**.

La soluzione, inoltre, riusa ed estende l'**API GeoDCAT-AP** sviluppata da JRC e disponibile sul relativo [**repository GitHub**](https://github.com/SEMICeu/iso-19139-to-dcat-ap/tree/master/api).
