<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform 

xmlns:adms="http://www.w3.org/ns/adms#" 
xmlns:cnt    = "http://www.w3.org/2011/content#"
xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
xmlns:dc="http://purl.org/dc/elements/1.1/" 
xmlns:dcat="http://www.w3.org/ns/dcat#" 
xmlns:dcatapit="http://dati.gov.it/onto/dcatapit#" 
xmlns:dct="http://purl.org/dc/terms/"
xmlns:dqv="http://www.w3.org/ns/dqv#"
xmlns:foaf="http://xmlns.com/foaf/0.1/" 
xmlns:gco="http://www.isotc211.org/2005/gco" 
xmlns:gfc="http://www.isotc211.org/2005/gfc" 
xmlns:gmd="http://www.isotc211.org/2005/gmd" 
xmlns:gml="http://www.opengis.net/gml/3.2" 
xmlns:gmx="http://www.isotc211.org/2005/gmx"
xmlns:gsr="http://www.isotc211.org/2005/gsr" 
xmlns:gss="http://www.isotc211.org/2005/gss" 
xmlns:gsp="http://www.opengis.net/ont/geosparql#" 
xmlns:gts="http://www.isotc211.org/2005/gts" 
xmlns:locn="http://www.w3.org/ns/locn#" 
xmlns:ogc="http://www.opengis.net/ogc" 
xmlns:owl="http://www.w3.org/2002/07/owl#" 
xmlns:ows="http://www.opengis.net/ows" 
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
xmlns:schema = "http://schema.org/"
xmlns:sdmx-attribute="http://purl.org/linked-data/sdmx/2009/attribute#"
xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
xmlns:srv="http://www.isotc211.org/2005/srv" 
xmlns:vcard="http://www.w3.org/2006/vcard/ns#"
xmlns:xsd="http://www.w3.org/2001/XMLSchema#" 
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xmlns:xsl    = "http://www.w3.org/1999/XSL/Transform"
xmlns:xlink="http://www.w3.org/1999/xlink" 
xmlns="http://www.isotc211.org/2005/gmd" 
xsi:schemaLocation="https://www.ngdc.noaa.gov/metadata/published/xsd/schema.xsd"
    version="1.0">
    
 <xsl:output method="xml"
              indent="yes"
              encoding="utf-8"
              cdata-section-elements="locn:geometry" /> 

<xsl:param name="xsd">http://www.w3.org/2001/XMLSchema#</xsl:param>
<xsl:param name="gsp">http://www.opengis.net/ont/geosparql#</xsl:param>

<!-- variabili per la scelta dell'output -->
<xsl:variable name="jsonld">application/ld+json</xsl:variable>
<xsl:variable name="rdf">application/rdf+xml</xsl:variable>

<!-- variabili per la scelta del formato di dati (al momento non usata)
<xsl:variable name="dcatap_it">dcatap_it</xsl:variable>
<xsl:variable name="geodcatap_it">geodcatap_it</xsl:variable>-->

<!-- parametri per le URI delle sezioni -->
<xsl:param name="ResourceCatalogURI">http://dati.gov.it/resource/Catalogo/</xsl:param>
<xsl:param name="ResourceCatalogRecordURI">http://dati.gov.it/resource/CatalogRecord/</xsl:param>
<xsl:param name="ResourceDatasetURI">http://dati.gov.it/resource/Dataset/</xsl:param>
<xsl:param name="ResourceDistributionURI">http://dati.gov.it/resource/Distribuzione/</xsl:param>
<xsl:param name="ResourceAgentURI">http://dati.gov.it/resource/Amministrazione/</xsl:param>
<xsl:param name="ResourceContactPointURI">http://dati.gov.it/resource/PuntoContatto/</xsl:param>
<xsl:param name="ResourcePeriodoTemporaleURI">http://dati.gov.it/resource/PeriodoTemporale/</xsl:param> 
<xsl:param name="ResourceAltroIdentificativoURI">http://dati.gov.it/resource/AltroIdentificativo/</xsl:param>
<xsl:param name="ResourceLocationURI">http://dati.gov.it/resource/CoperturaSpaziale/</xsl:param>
<xsl:param name="ResourceStandardURI">http://dati.gov.it/resource/Standard/</xsl:param>
<xsl:param name="ResourceLicenseURI">http://dati.gov.it/resource/License/</xsl:param>
<xsl:param name="ResourceDataQualityURI">http://dati.gov.it/resource/DataQuality/</xsl:param>
<xsl:param name="ResourceConstraintURI">http://dati.gov.it/resource/Constraints/</xsl:param>
<xsl:param name="ResourceProvenanceURI">http://dati.gov.it/resource/Provenance/</xsl:param>


<xsl:param name="id_suffix">_ID</xsl:param>

<!-- URL utili -->
<xsl:param name="EUPublications">http://publications.europa.eu/resource/authority/frequency/</xsl:param>

<!-- formato di output e profilo di default -->
<xsl:param name="foutput" select ="$jsonld"/>
<!--<xsl:param name="profile" select="$dcatap_it"/> -->

  <!-- Intestazione e Catalogo -->
<xsl:template match="/" >

<!-- La data di modifica del catalogo va imposta a "ieri", parametro passato dal php -->

<xsl:param name="lastCatModify"><xsl:value-of select="$yesterday"/></xsl:param>

<xsl:param name="catalog_id">http://dati.gov.it/resource/Catalogo/agid:csw_rndt</xsl:param>
<xsl:param name="title">RNDT - Repertorio Nazionale dei Dati Territoriali - Servizio di ricerca</xsl:param>
<xsl:param name="description">Il servizio di ricerca del RNDT fornisce l'accesso ai metadati su dati e servizi territoriali delle Pubbliche Amministrazioni italiane. Esso è conforme alle specifiche CSW (ISO Application Profile) di OGC e alle linee guida INSPIRE sui servizi di ricerca</xsl:param>

<xsl:param name="homepage">http://geodati.gov.it</xsl:param>
<xsl:param name="language">it_IT</xsl:param>
<xsl:param name="publisher">http://dati.gov.it/resource/Amministrazione/agid</xsl:param>
<xsl:param name="issued">2018-12-11</xsl:param> <!-- imposto, al momento -->
<xsl:param name="themeTaxonomy">http://publications.europa.eu/resource/authority/data-theme</xsl:param>


<xsl:choose>
  <xsl:when test="$foutput = $jsonld">
{
    "@context": {
    "dcat": "http://www.w3.org/ns/dcat#",
    "org": "http://www.w3.org/ns/org#",
    "vcard": "http://www.w3.org/2006/vcard/ns#",
    "foaf": "http://xmlns.com/foaf/0.1/",
    "@vocab": "http://www.w3.org/ns/dcat#",
    "dct": "http://purl.org/dc/terms/",
    "locn": "http://www.w3.org/ns/locn#",
    "skos": "http://www.w3.org/2004/02/skos/core#",
    "dcatapit": "http://dati.gov.it/onto/dcatapit#",
    "gsp": "http://www.opengis.net/ont/geosparql#",
    "describedBy": {
      "@id": "http://www.w3.org/2007/05/powder#describedby",
      "@type": "@id"
    },
    "dataset": "dcatapit:Dataset",
    "distribution": "dcatapit:Distribution",
    "downloadURL": {
      "@id": "dcat:downloadURL",
      "@type": "@id"
    },
    "accessURL": {
      "@id": "dcat:accessURL",
      "@type": "@id"
    },
    "title": {
    	"@id": "dct:title",
    	"@language" : "it"
    },
    "description": {
    	"@id": "dct:description",
    	"@language" : "it"
    },
    "issued": {
      "@id": "dct:issued",
      "@type": "http://www.w3.org/2001/XMLSchema#date"
    },
    "modified": {
      "@id": "dct:modified",
      "@type": "http://www.w3.org/2001/XMLSchema#date"
    },
    "language": {
      "@id": "dct:language",
      "@type": "@vocab"
    },
    "it_IT": "http://publications.europa.eu/resource/authority/language/ITA",
    "fr_FR": "http://publications.europa.eu/resource/authority/language/FRA",
    "de_DE": "http://publications.europa.eu/resource/authority/language/DEU",
    "en_GB": "http://publications.europa.eu/resource/authority/language/ENG",
    "en_US": "http://publications.europa.eu/resource/authority/language/ENG",
    "license": "dct:license",
    "rights": "dct:rights",
    "spatial": {
      "@id": "dct:spatial",
      "@type": "gsp:gmlLiteral"
    },
    "conformsTo": {
      "@id": "dct:conformsTo",
      "@type": "@id"
    },
    "publisher": "dct:publisher",
	"creator":"dct:creator",
	"rightsHolder": "dct:rightsHolder",
    "identifier": "dct:identifier",
    "temporal": "dct:temporal",
    "format": "dct:format",
    "accrualPeriodicity": {
    	"@id": "dct:accrualPeriodicity",
    	"@type": "@vocab"
	},
	"altro": "http://publications.europa.eu/resource/authority/frequency/OTHER",
	"annuale": "http://publications.europa.eu/resource/authority/frequency/ANNUAL",
	"biennale": "http://publications.europa.eu/resource/authority/frequency/BIENNIAL",
	"bimensile": "http://publications.europa.eu/resource/authority/frequency/MONTHLY_2",
	"bimestrale": "http://publications.europa.eu/resource/authority/frequency/BIMONTHLY ",
	"bisettimanale": "http://publications.europa.eu/resource/authority/frequency/WEEKLY_2",
	"continuo / continua": "http://publications.europa.eu/resource/authority/frequency/CONT",
	"due volte al giorno": "http://publications.europa.eu/resource/authority/frequency/DAILY_2",
	"in continuo aggiornamento": "http://publications.europa.eu/resource/authority/frequency/UPDATE_CONT",
	"irregolare": "http://publications.europa.eu/resource/authority/frequency/IRREG",
	"mai": "http://publications.europa.eu/resource/authority/frequency/NEVER",
	"mensile": "http://publications.europa.eu/resource/authority/frequency/MONTHLY",
	"quindicinale": "http://publications.europa.eu/resource/authority/frequency/BIWEEKLY",
	"quotidiano / quotidiana": "http://publications.europa.eu/resource/authority/frequency/DAILY",
	"sconosciuto / sconosciuta": "http://publications.europa.eu/resource/authority/frequency/UNKNOWN",
	"semestrale": "http://publications.europa.eu/resource/authority/frequency/ANNUAL_2",
	"settimanale": "http://publications.europa.eu/resource/authority/frequency/WEEKLY",
	"tre volte a settimana": "http://publications.europa.eu/resource/authority/frequency/WEEKLY_3",
	"tre volte al mese": "http://publications.europa.eu/resource/authority/frequency/MONTHLY_3",
	"tre volte all'anno": "http://publications.europa.eu/resource/authority/frequency/ANNUAL_3",
	"triennale": "http://publications.europa.eu/resource/authority/frequency/TRIENNIAL",
	"trimestrale": "http://publications.europa.eu/resource/authority/frequency/QUARTERLY",
    "landingPage": {
    	"@id": "dct:landingPage",
    	"@type": "@id"
     },
    "homepage": {
    	"@id": "foaf:homepage",
    	"@type": "@id"
     },	
    "fn": "vcard:fn",
    "hasEmail": {
    	"@id": "vcard:hasEmail",
    	"@type": "@id"
     },	
    "hasURL": {
    	"@id": "vcard:hasURL",
    	"@type": "@id"
     },
    "name": {
    	"@id": "foaf:name",
    	"@language" : "it"
    },
    "subOrganizationOf": "org:subOrganizationOf",
	"geometry": "locn:geometry",
	"subject": {
		"@id": "dct:subject",
		"@type": "@vocab"
	},
	"Indirizzi": "http://inspire.ec.europa.eu/theme/ad",
	"Unità amministrative": "http://inspire.ec.europa.eu/theme/au",
	"Sistemi di coordinate": "http://inspire.ec.europa.eu/theme/rs",
	"Sistemi di griglie geografiche": "http://inspire.ec.europa.eu/theme/gg",
	"Parcelle catastali": "http://inspire.ec.europa.eu/theme/cp",
	"Nomi geografici": "http://inspire.ec.europa.eu/theme/gn",
	"Idrografia": "http://inspire.ec.europa.eu/theme/hy",
	"Siti protetti": "http://inspire.ec.europa.eu/theme/ps",
	"Reti di trasporto": "http://inspire.ec.europa.eu/theme/tn",
	"Elevazione": "http://inspire.ec.europa.eu/theme/el",
	"Geologia": "http://inspire.ec.europa.eu/theme/ge",
	"Copertura del suolo": "http://inspire.ec.europa.eu/theme/lc",
	"Orto immagini": "http://inspire.ec.europa.eu/theme/oi",
	"Impianti agricoli e di acquacoltura": "http://inspire.ec.europa.eu/theme/af",
	"Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati": "http://inspire.ec.europa.eu/theme/am",
	"Condizioni atmosferiche": "http://inspire.ec.europa.eu/theme/ac",
	"Regioni biogeografiche": "http://inspire.ec.europa.eu/theme/br",
	"Edifici": "http://inspire.ec.europa.eu/theme/bu",
	"Risorse energetiche": "http://inspire.ec.europa.eu/theme/er",
	"Impianti di monitoraggio ambientale": "http://inspire.ec.europa.eu/theme/ef",
	"Habitat e biotopi": "http://inspire.ec.europa.eu/theme/hb",
	"Salute umana e sicurezza": "http://inspire.ec.europa.eu/theme/hh",
	"Utilizzo del territorio": "http://inspire.ec.europa.eu/theme/lu",
	"Risorse minerarie": "http://inspire.ec.europa.eu/theme/mr",
	"Zone a rischio naturale": "http://inspire.ec.europa.eu/theme/nz",
	"Elementi geografici oceanografici": "http://inspire.ec.europa.eu/theme/of",
	"Distribuzione della popolazione - demografia": "http://inspire.ec.europa.eu/theme/pd",
	"Produzione e impianti industriali": "http://inspire.ec.europa.eu/theme/pf",
	"Regioni marine": "http://inspire.ec.europa.eu/theme/sr",
	"Suolo": "http://inspire.ec.europa.eu/theme/so",
	"Distribuzione delle specie": "http://inspire.ec.europa.eu/theme/sd",
	"Unità statistiche": "http://inspire.ec.europa.eu/theme/su",
	"Servizi di pubblica utilità e servizi amministrativi": "http://inspire.ec.europa.eu/theme/us",
	"Elementi geografici meteorologici": "http://inspire.ec.europa.eu/theme/mf",
	
	"Agricoltura": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/farming",
	"Biota": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/biota",
	"Confini": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/boundaries",
	"Climatologia/Meteorologia/Atmosfera": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/climatologyMeteorologyAtmosphere",
	"Economia": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/economy",
	"Elevazione": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/elevation",
	"Ambiente": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/environment",
	"Informazioni geoscientifiche": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/geoscientificInformation",
	"Salute": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/health",
	"Cartografia di base per immagini/Copertura terrestre": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/imageryBaseMapsEarthCover",
	"Intelligence/Settore militare": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/intelligenceMilitary",
	"Acque interne": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/inlandWaters",
	"Localizzazione": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/location",
	"Oceani": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/oceans",
	"Pianificazione/Catasto": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/planningCadastre",
	"Società": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/society",
	"Struttura": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/structure",
	"Trasporti": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/transportation",
	"Servizi di pubblica utilità/Comunicazione": "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/utilitiesCommunication",
	"themeTaxonomy": {
		"@type": "@id"
	}, 
	"theme": {
		"@type": "@vocab"
	},
	"Agricoltura, pesca, silvicoltura e prodotti alimentari": "http://publications.europa.eu/resource/authority/data-theme/AGRI",
	"Economia e Finanze": "http://publications.europa.eu/resource/authority/data-theme/ECON",
	"Istruzione, cultura e sport": "http://publications.europa.eu/resource/authority/data-theme/EDUC",
	"Energia": "http://publications.europa.eu/resource/authority/data-theme/ENER",
	"Ambiente": "http://publications.europa.eu/resource/authority/data-theme/ENVI",
	"Governo e settore pubblico": "http://publications.europa.eu/resource/authority/data-theme/GOVE",
	"Salute": "http://publications.europa.eu/resource/authority/data-theme/HEAL",
	"Tematiche internazionali": "http://publications.europa.eu/resource/authority/data-theme/INTR",
	"Giustizia, sistema giuridico e sicurezza pubblica": "http://publications.europa.eu/resource/authority/data-theme/JUST",
	"Regioni e città": "http://publications.europa.eu/resource/authority/data-theme/REGI",
	"Popolazione e società": "http://publications.europa.eu/resource/authority/data-theme/SOCI",
	"Scienza e tecnologia": "http://publications.europa.eu/resource/authority/data-theme/TECH",
	"Trasporti": "http://publications.europa.eu/resource/authority/data-theme/TRAN"
  },
  
  "@id": "<xsl:value-of select="$catalog_id"/>",
  "@type": [
    "dcat:Catalog",
    "http://dati.gov.id/onto/dctapit#Catalog"
        ],
  "title": "<xsl:value-of select="$title"/>",
  "description" : "<xsl:value-of select="$description"/>",
  "homepage" : "<xsl:value-of select="$homepage"/>",
  "language" : "<xsl:value-of select="$language"/>",
  "publisher" : {
  	"@id" : "<xsl:value-of select="$publisher"/>",
  	"@type": [
       "foaf:Agent",
       "http://dati.gov.it/onto/dcatapit#Agent"
    ],
  	"identifier": "agid",
  	"name":"Agenzia per l'italia Digitale"
  	},
  "issued" : "<xsl:value-of select="$issued"/>", 
  "modified" : "<xsl:value-of select="$lastCatModify"/>",
  "themeTaxonomy" : "<xsl:value-of select="$themeTaxonomy"/>",
  
   "dataset" : [
  <xsl:for-each select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]"><xsl:call-template name="dataset" /><xsl:if test="position()!=last()">, </xsl:if>
  </xsl:for-each>
   ]
}
 </xsl:when>
</xsl:choose>
</xsl:template>

<!-- DATASET -->
  <xsl:template name="dataset">
<!-- trovo il numero d'ordine per evitare identificativi inavvertitamente duplicati -->
    <xsl:param name="cardinal" select="position()"/>

    <xsl:param name="catalogRecordId">
        <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
    </xsl:param>

    <xsl:param name="identifier">
        <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString"/> 
    </xsl:param>

    <xsl:param name="tipologia">
        <xsl:if test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'service'">service</xsl:if>
        <xsl:if test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'dataset' or gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'series'">dataset</xsl:if>
    </xsl:param>

    <xsl:param name="codeListValue">
      <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue | gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/>
    </xsl:param>


<!-- trovo il reativo valore di accrualPeriodicity  CONTROLLARLO!!! -->

    <xsl:param name="accrualTranslated"><xsl:call-template name="accrualTransf"><xsl:with-param name="accrualOrig" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue" /></xsl:call-template></xsl:param>


    <xsl:param name="title">
        <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
    </xsl:param>

    <xsl:param name="description">
        <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:abstract/gco:CharacterString"/>
    </xsl:param>

    <xsl:param name="languageCode">
        <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:language/gmd:LanguageCode"/>
    </xsl:param>

    <xsl:param name="modified">
      <xsl:choose>
    <xsl:when test="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='revision'] != '' "><xsl:value-of select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='revision']/../../gmd:date/gco:Date "/></xsl:when>
    <xsl:when test="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='publication'] != '' "><xsl:value-of select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='publication']/../../gmd:date/gco:Date "/></xsl:when>
    <xsl:when test="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='creation'] != '' "><xsl:value-of select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='creation']/../../gmd:date/gco:Date "/></xsl:when>
      </xsl:choose>
    </xsl:param> 

    <xsl:param name="hierarchy" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>

    <xsl:param name="periodoTemporale">
    <xsl:if test="(gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant | gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod) != ''">
        <xsl:value-of select="concat($ResourcePeriodoTemporaleURI, $catalogRecordId, $id_suffix)"/>
      </xsl:if>
    </xsl:param>

    <xsl:param name="datasetLanguage">
        <xsl:call-template name="decodeLang">
         <xsl:with-param name="kword" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode/@codeListValue"/>
        </xsl:call-template>
    </xsl:param>

    <xsl:param name="conformsTo">
      <xsl:if test="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass/gco:Boolean = 'true'">http://data.europa.eu/eli/reg/2010/1089</xsl:if>
    </xsl:param>

    <xsl:param name="conformsTo2">
    <xsl:choose>
    <xsl:when test="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString != ''"><xsl:choose>
    <xsl:when test="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString != ''"><xsl:value-of select="concat('http://www.opengis.net/def/crs/EPSG/0/', gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString)"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
    </xsl:choose></xsl:when>
    <xsl:otherwise><xsl:call-template name="decodificaEPSG"><xsl:with-param name="code" select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"/></xsl:call-template></xsl:otherwise>
    </xsl:choose>
    </xsl:param>

    <xsl:param name="issued">
      <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date"><xsl:if test="gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'publication'"><xsl:value-of select="gmd:date/gco:Date"/></xsl:if></xsl:for-each>
    </xsl:param>

    <xsl:param name="comment">
        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction">
            <xsl:if test="gmd:denominator/gco:Integer != ''">Risoluzione spaziale (scala equivalente): 1:<xsl:value-of select="gmd:denominator/gco:Integer"/></xsl:if>
        </xsl:for-each>
    </xsl:param>

    <xsl:param name="isPartOf">
        <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/*/gmd:series/gmd:issueIdentification/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/*/gmd:series/gmd:issueIdentification/gco:CharacterString"/>
    </xsl:param>

    <xsl:variable name="localizzazione" select="concat($ResourceLocationURI, gmd:fileIdentifier/gco:CharacterString, $id_suffix)"/>

    <xsl:variable name="landingPage" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
    <xsl:variable name="isVersionOf" select="''"/>

    <xsl:variable name="hqm" select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record/gco:Real"/>

    <xsl:variable name="subj" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>


    <!-- attribuzione dei diritti -->
    <xsl:variable name="owner" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner']"/>
    <xsl:variable name="author" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='author']"/>
    <xsl:variable name="editor" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='editor']"/>
    <xsl:variable name="originator" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='originator']"/>
    <xsl:variable name="paracute" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue"/>


<xsl:choose>
  <xsl:when test="$foutput = $jsonld">
    { 
    "@id" : "<xsl:value-of select="concat($ResourceDatasetURI, $identifier, $id_suffix, $cardinal)"/>",
    "@type": [
        "dcat:Dataset",
        "http://dati.gov.id/onto/dctapit#Dataset"
    ],
    "identifier" : "<xsl:value-of select="$identifier"/>",
    "title" : "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$title"/></xsl:call-template>",
    "description" : "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$description"/></xsl:call-template>",
    "modified" : "<xsl:value-of select="$modified"/>",
    "subject" : [<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[(contains(gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString , 'GEMET - INSPIRE themes, version 1.0'))]">
      <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
        <xsl:call-template name="subjectDataset">
         <xsl:with-param name="kword" select="gco:CharacterString"/>
        </xsl:call-template><xsl:if test="position() != last()">, </xsl:if>
      </xsl:for-each>
    </xsl:for-each>],
    "theme" : [<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[(contains(gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString , 'GEMET - INSPIRE themes, version 1.0'))]">
      <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
        <xsl:call-template name="themeDataset">
          <xsl:with-param name="kword" select="gco:CharacterString"/>
        </xsl:call-template>
      </xsl:for-each><xsl:if test="position() != last()">, </xsl:if>
    </xsl:for-each>],
  <xsl:call-template name="agent" >
      <xsl:with-param name="identifier" select="$identifier"/>
      <xsl:with-param name="tipo">rightsHolder</xsl:with-param>
      <xsl:with-param name="role"><xsl:choose>
       <xsl:when test="$editor != ''">editor</xsl:when>
       <xsl:when test="$owner != ''">owner</xsl:when>
       <xsl:when test="$originator != ''">originator</xsl:when>
       <xsl:when test="$author != ''">author</xsl:when>
      <xsl:otherwise><xsl:value-of select="$paracute"/></xsl:otherwise>
      </xsl:choose></xsl:with-param>
  </xsl:call-template>

    "accrualPeriodicity" : "<xsl:value-of select="$accrualTranslated" />",
    "distribution" : [
    <xsl:call-template name="distribution" >
      <xsl:with-param name="catalogRecordId" select="$catalogRecordId"/>           
    </xsl:call-template>
	],
  <xsl:call-template name="licenza">
  </xsl:call-template>

    <xsl:call-template name="puntoDiContatto" >
      <xsl:with-param name="identifier" select="$identifier"/>    <!-- o era meglio catalogRecordId? -->       
    </xsl:call-template>
    "keyword" : [
<xsl:for-each select="gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords "> 
         "<xsl:value-of select="gmd:keyword/gco:CharacterString"/>"<xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        ] ,
  <xsl:call-template name="agent" >
      <xsl:with-param name="identifier" select="$identifier"/>
      <xsl:with-param name="tipo">publisher</xsl:with-param>
      <xsl:with-param name="role">editor</xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="agent" >
      <xsl:with-param name="identifier" select="$identifier"/>
      <xsl:with-param name="tipo">creator</xsl:with-param>
      <xsl:with-param name="role">originator</xsl:with-param>
  </xsl:call-template>
    "language": "<xsl:value-of select="$datasetLanguage"/>"<xsl:if test="$landingPage != ''">,  
    "landingPage": "<xsl:value-of select="$landingPage"/>"</xsl:if><xsl:if test="$issued != ''">,
    "issued": "<xsl:value-of select="$issued"/>"
  </xsl:if>
   <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
      <xsl:call-template name="spatial"></xsl:call-template></xsl:for-each><xsl:if test="$isVersionOf != ''">,
    "isVersionOf": "<xsl:value-of select="$isVersionOf"/>"</xsl:if><xsl:if test="$periodoTemporale != ''">,
    <xsl:call-template name="temporal" /></xsl:if><xsl:if test="$conformsTo != ''">,
    "conformsTo": "<xsl:value-of select="$conformsTo"/>"</xsl:if><xsl:if test="$conformsTo2 != ''">,
    "conformsTo": "<xsl:value-of select="$conformsTo2"/>"</xsl:if>
    }
  </xsl:when>
 </xsl:choose>
</xsl:template>


<!-- AGENT -->
<xsl:template name="agent" >
 <xsl:param name="identifier"/>
 <xsl:param name="tipo"/>
 <xsl:param name="role"/>

 <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[(contains(gmd:role/gmd:CI_RoleCode/@codeListValue , $role))]">
    "<xsl:value-of select="$tipo"/>" : {
        "@id" : "<xsl:value-of select="$ResourceAgentURI"/><xsl:value-of select="$identifier"/><xsl:value-of select="$id_suffix"/><xsl:value-of select="gmd:role/gmd:CI_RoleCode/@codeListValue"/>",
        "@type": [
         "foaf:Agent",
         "http://dati.gov.it/onto/dcatapit#Agent"
       ],
       	"identifier": "<xsl:value-of select="substring-before($identifier, ':')"/>",
        "name": "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="gmd:organisationName/gco:CharacterString"/></xsl:call-template>"
    	},
 </xsl:for-each>
</xsl:template>

<!-- DISTRIBUTION 

ci sono più distribuzioni nello stesso dataset. Usare le position
SE le url mancano, prendo per access url il sito on line 

gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL
 

oppure inserisco il telefono

gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString
-->
<xsl:template name="distribution">
 <xsl:param name="catalogRecordId"/>


<xsl:param name="format"><xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString"/>
</xsl:param>
<!-- attenzione, al momento il formato è testo libero. Più avanti revisioneranno e sarà possibile fare un mapping -->

<xsl:param name="title">
  <xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name/gco:CharacterString"/>
</xsl:param>

<xsl:param name="description">
  <xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:description/gco:CharacterString"/>
</xsl:param>

<xsl:variable name="conformsToWms">
<xsl:choose>
 <xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString = 'WMS' or gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString = 'WMS'">http://www.opengis.net/def/serviceType/ogc/wms</xsl:when>
 <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>

<xsl:variable name="conformsToWfs">
<xsl:choose>
 <xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString = 'WFS' or gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString = 'WFS'">http://www.opengis.net/def/serviceType/ogc/wfs</xsl:when>
 <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>


<xsl:variable name="accessURL" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
<xsl:if test="$accessURL = ''">
  <xsl:variable name="accessURL" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
</xsl:if>
<xsl:if test="$accessURL = ''">
  <xsl:variable name="accessURL" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>
</xsl:if>

<xsl:variable name="accessRights">
<xsl:choose>
<xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode != 'altri vincoli'"><xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode"/></xsl:when>
<xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode = 'altri vincoli'"><xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString"/></xsl:when>
</xsl:choose>
</xsl:variable>

<xsl:variable name="rights">
<xsl:choose>
<xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode != 'altri vincoli'"><xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode"/></xsl:when>
<xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode != 'altri vincoli'"><xsl:value-of select="''"/></xsl:when>
</xsl:choose>
</xsl:variable>

<xsl:variable name="representation">
<xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/>
</xsl:variable>

  <xsl:choose>

    <xsl:when test="$foutput = $jsonld"> 
     {
       "@id": "<xsl:value-of select="concat($ResourceDistributionURI, $catalogRecordId, $id_suffix)"/>",
       "@type": [
         "http://dati.gov.it/onto/dcatapit#Distribution",
         "dcat:Distribution"
       ],
       "format": "<xsl:value-of select="$format"/>",
       "accessURL": "<xsl:value-of select="$accessURL"/>"<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage"><xsl:if test="position() = 2">,
       "downloadURL": "<xsl:value-of select="gmd:URL"/>"</xsl:if>
    </xsl:for-each><xsl:if test="$description != ''">,
       "description": "<xsl:value-of select="$description"/>"</xsl:if><xsl:if test="$title != ''">,
       "dcterms:title": "<xsl:value-of select="$title"/>"</xsl:if>,
       "mediaType": "<xsl:value-of select="$format"/>" <!--  identico a format. amen. -->
      }
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- LICENSE -->
<xsl:template name="licenza" >
    <!-- NOTE:   le licenze vengono prese da useLimitation per i documenti in distribuzione.  -->

    <xsl:variable name="useLimitation_str" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString"/>
    <xsl:variable name="useLimitation_lnk" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gmx:Anchor/@xlink:href"/>
    <xsl:variable name="licenseName"><xsl:choose><xsl:when test="$useLimitation_str"><xsl:value-of select="$useLimitation_str"/></xsl:when>
            <xsl:when test="$useLimitation_lnk"><xsl:value-of select="$useLimitation_lnk"/></xsl:when><xsl:otherwise>informazione non presente</xsl:otherwise></xsl:choose></xsl:variable>

      <xsl:if test="$foutput = $jsonld">
    "license": "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$licenseName"/></xsl:call-template>",
      </xsl:if>
</xsl:template>

<!-- CONTACT POINT -->
<xsl:template name="puntoDiContatto">
 <xsl:param name="identifier"/>
  <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification">
    <xsl:variable name="fn" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>
    <xsl:variable name="hasEmail" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>
    <xsl:variable name="hasURL" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
    <xsl:variable name="hasTelephone" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>

  <xsl:choose>
    <xsl:when test="$foutput = $jsonld"> 
    "contactPoint" : {
    	"@id" : "<xsl:value-of select="concat($ResourceContactPointURI, $identifier, $id_suffix)"/>",
    	"@type" : [
        	"vcard:Organization",
        	"vcard:Kind",
        	"http://dati.gov.it/onto/dcatapit#Organization"
        ],
        "fn" : "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$fn"/></xsl:call-template>",
        "hasEmail" : "mailto:<xsl:value-of select="$hasEmail"/>"<xsl:if test="$hasTelephone != ''">,
        "hasTelephone" : "<xsl:value-of select="$hasTelephone"/>"</xsl:if><xsl:if test="$hasURL != ''">,
        "hasURL" : "<xsl:value-of select="$hasURL"/>"</xsl:if>
        },
    </xsl:when>
   </xsl:choose>
  </xsl:for-each>
</xsl:template>


<!-- SPATIAL -->
<xsl:template name="spatial">
  <xsl:variable name="name">http://www.opengis.net/def/EPSG/0/4326</xsl:variable>

    <xsl:variable name="west" select="gmd:westBoundLongitude/gco:Decimal"/>
    <xsl:variable name="east" select="gmd:eastBoundLongitude/gco:Decimal"/>
    <xsl:variable name="south" select="gmd:southBoundLatitude/gco:Decimal"/>
    <xsl:variable name="north" select="gmd:northBoundLatitude/gco:Decimal"/>

    <xsl:variable name="lc" select="concat($south, ' ', $west)"/>
    <xsl:variable name="uc" select="concat($north, ' ', $east)"/>
    <xsl:variable name="spatialVal">&lt;gml:Envelope srsName="<xsl:value-of select="$name" />"&gt;&lt;gml:lowerCorner&gt;<xsl:value-of select="$lc"/>&lt;/gml:lowerCorner&gt;&lt;gml:upperCorner&gt;<xsl:value-of select="$uc"/>&lt;/gml:upperCorner&gt;&lt;/gml:Envelope&gt;</xsl:variable>

  <xsl:choose>

    <xsl:when test="$foutput = $jsonld">,
    "spatial" : "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$spatialVal"/></xsl:call-template>" 
<!--  "spatial" : "<gml:Envelope srsName="{$name}"><gml:lowerCorner><xsl:value-of select="$lc"/></gml:lowerCorner><gml:upperCorner><xsl:value-of select="$uc"/></gml:upperCorner></gml:Envelope>" -->

    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- TEMPORAL -->
<xsl:template name="temporal" >
    <xsl:for-each select="gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant | gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod ">
      <xsl:if test="local-name(.) = 'TimeInstant' or ( local-name(.) = 'TimePeriod' and gml:beginPosition and gml:endPosition )">
        <xsl:variable name="dateStart">
          <xsl:choose>
            <xsl:when test="local-name(.) = 'TimeInstant'"><xsl:value-of select="gml:timePosition"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="gml:beginPosition"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dateEnd">
          <xsl:choose>
            <xsl:when test="local-name(.) = 'TimeInstant'"><xsl:value-of select="gml:timePosition"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="gml:endPosition"/></xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$foutput = $jsonld">
    "temporal" : "<xsl:value-of select="$dateStart"/>/<xsl:value-of select="$dateEnd"/>"</xsl:if>
      </xsl:if>
    </xsl:for-each>

</xsl:template>



<!-- subject -->
<xsl:template name="subjectDataset">
    <xsl:param name="kword"/>
    <xsl:choose>
        <xsl:when test="$kword = 'Condizioni atmosferiche' or $kword = 'Atmospheric conditions'">"Condizioni atmosferiche"</xsl:when>
        <xsl:when test="$kword = 'Copertura del suolo' or $kword = 'Land cover'">"Copertura del suolo"</xsl:when>
        <xsl:when test="$kword = 'Distribuzione della popolazione — demografia' or $kword = 'Population distribution — demography'">"Distribuzione della popolazione — demografia"</xsl:when>
        <xsl:when test="$kword = 'Distribuzione delle specie' or $kword = 'Species distribution'">"Distribuzione delle specie"</xsl:when>
        <xsl:when test="$kword = 'Edifici' or $kword = 'Buildings'">"Edifici"</xsl:when>
        <xsl:when test="$kword = 'Elementi geografici meteorologici' or $kword = 'Meteorological geographical features'">"Elementi geografici meteorologici"</xsl:when>
        <xsl:when test="$kword = 'Elementi geografici oceanografici' or $kword = 'Oceanographic geographical features'">"Elementi geografici oceanografici"</xsl:when>
        <xsl:when test="$kword = 'Elevazione' or $kword = 'Elevation'">"Elevazione"</xsl:when>
        <xsl:when test="$kword = 'Geologia' or $kword = 'Geology'">"Geologia"</xsl:when>
        <xsl:when test="$kword = 'Habitat e biotopi' or $kword = 'Habitats and biotopes'">"Habitat e biotopi"</xsl:when>
        <xsl:when test="$kword = 'Idrografia' or $kword = 'Hydrography'">"Idrografia"</xsl:when>
        <xsl:when test="$kword = 'Impianti agricoli e di acquacoltura' or $kword = 'Agricultural and aquaculture facilities'">"Impianti agricoli e di acquacoltura"</xsl:when>
        <xsl:when test="$kword = 'Impianti di monitoraggio ambientale' or $kword = 'Environmental monitoring facilities'">"Impianti di monitoraggio ambientale"</xsl:when>
        <xsl:when test="$kword = 'Indirizzi' or $kword = 'Addresses'">"Indirizzi"</xsl:when>
        <xsl:when test="$kword = 'Nomi geografici' or $kword = 'Geographical names'">"Nomi geografici"</xsl:when>
        <xsl:when test="$kword = 'Orto immagini' or $kword = 'Orthoimagery'">"Orto immagini"</xsl:when>
        <xsl:when test="$kword = 'Parcelle catastali' or $kword = 'Cadastral parcels'">"Parcelle catastali"</xsl:when>
        <xsl:when test="$kword = 'Produzione e impianti industriali' or $kword = 'Production and industrial facilities'">"Produzione e impianti industriali"</xsl:when>
        <xsl:when test="$kword = 'Regioni biogeografiche' or $kword = 'Bio-geographical regions'">"Regioni biogeografiche"</xsl:when>
        <xsl:when test="$kword = 'Regioni marine' or $kword = 'Sea regions'">"Regioni marine"</xsl:when>
        <xsl:when test="$kword = 'Reti di trasporto' or $kword = 'Transport networks'">"Reti di trasporto"</xsl:when>
        <xsl:when test="$kword = 'Risorse energetiche' or $kword = 'Energy resources'">"Risorse energetiche"</xsl:when>
        <xsl:when test="$kword = 'Risorse minerarie' or $kword = 'Mineral resources'">"Risorse minerarie"</xsl:when>
        <xsl:when test="$kword = 'Salute umana e sicurezza' or $kword = 'Human health and safety'">"Salute umana e sicurezza"</xsl:when>
        <xsl:when test="$kword = 'Servizi di pubblica utilità e servizi amministrativi' or $kword = 'Utility and governmental services'">"Servizi di pubblica utilità e servizi amministrativi"</xsl:when>
        <xsl:when test="$kword = 'Sistemi di coordinate' or $kword = 'Coordinate reference systems'">"Sistemi di coordinate"</xsl:when>
        <xsl:when test="$kword = 'Sistemi di griglie geografiche' or $kword = 'Geographical grid systems'">"Sistemi di griglie geografiche"</xsl:when>
        <xsl:when test="$kword = 'Siti protetti' or $kword = 'Protected sites'">"Siti protetti"</xsl:when>
        <xsl:when test="$kword = 'Suolo' or $kword = 'Soil'">"Suolo"</xsl:when>
        <xsl:when test="$kword = 'Unità amministrative' or $kword = 'Administrative units'">"Unità amministrative"</xsl:when>
        <xsl:when test="$kword = 'Unità statistiche' or $kword = 'Statistical units'">"Unità statistiche"</xsl:when>
        <xsl:when test="$kword = 'Utilizzo del territorio' or $kword = 'Land use'">"Utilizzo del territorio"</xsl:when>
        <xsl:when test="$kword = 'Zone a rischio naturale' or $kword = 'Natural risk zones'">"Zone a rischio naturale"</xsl:when>
        <xsl:when test="$kword = 'Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati' or $kword = 'Area management/restriction/regulation zones and reporting units'">"Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati"</xsl:when>

        <xsl:when test="$kword = 'Agricoltura'">"Agricoltura"</xsl:when>
        <xsl:when test="$kword = 'Biota'">"Biota"</xsl:when>
        <xsl:when test="$kword = 'Confini'">"Confini"</xsl:when>
        <xsl:when test="$kword = 'Climatologia/Meteorologia/Atmosfera'">"Climatologia/Meteorologia/Atmosfera"</xsl:when>
        <xsl:when test="$kword = 'Economia'">"Economia"</xsl:when>
        <xsl:when test="$kword = 'Elevazione'">"Elevazione"</xsl:when>
        <xsl:when test="$kword = 'Ambiente'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Informazioni geoscientifiche'">"Informazioni geoscientifiche"</xsl:when>
        <xsl:when test="$kword = 'Salute'">"Salute"</xsl:when>
        <xsl:when test="$kword = 'Cartografia di base per immagini/Copertura terrestre'">"Cartografia di base per immagini/Copertura terrestre"</xsl:when>
        <xsl:when test="$kword = 'Intelligence/Settore militare'">"Intelligence/Settore militare"</xsl:when>
        <xsl:when test="$kword = 'Acque interne'">"Acque interne"</xsl:when>
        <xsl:when test="$kword = 'Localizzazione'">"Localizzazione"</xsl:when>
        <xsl:when test="$kword = 'Oceani'">"Oceani"</xsl:when>
        <xsl:when test="$kword = 'Pianificazione/Catasto'">"Pianificazione/Catasto"</xsl:when>
        <xsl:when test="$kword = 'Società'">"Società"</xsl:when>
        <xsl:when test="$kword = 'Struttura'">"Struttura"</xsl:when>
        <xsl:when test="$kword = 'Trasporti'">"Trasporti"</xsl:when>
        <xsl:when test="$kword = 'Servizi di pubblica utilità/Comunicazione'">"Servizi di pubblica utilità/Comunicazione"</xsl:when>

    </xsl:choose> 

</xsl:template>


<!-- themes -->
<xsl:template name="themeDataset">
    <xsl:param name="word"/>  
        <xsl:param name="kword"/><xsl:param name="subj"/>
    <xsl:choose>
        <xsl:when test="$kword = 'Condizioni atmosferiche' or $kword = 'Atmospheric conditions'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Copertura del suolo' or $kword = 'Land cover'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Distribuzione della popolazione — demografia' or $kword = 'Population distribution — demography'">"Popolazione e società"</xsl:when>
        <xsl:when test="$kword = 'Distribuzione delle specie' or $kword = 'Species distribution'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Edifici' or $kword = 'Buildings'">"Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Elementi geografici meteorologici' or $kword = 'Meteorological geographical features'">"Ambiente", "Scienza e tecnologia"</xsl:when>
        <xsl:when test="$kword = 'Elementi geografici oceanografici' or $kword = 'Oceanographic geographical features'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Elevazione' or $kword = 'Elevation'">"Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Geologia' or $kword = 'Geology'">"Scienza e tecnologia", "Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Habitat e biotopi' or $kword = 'Habitats and biotopes'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Idrografia' or $kword = 'Hydrography'">"Ambiente", "Scienza e tecnologia"</xsl:when>
        <xsl:when test="$kword = 'Impianti agricoli e di acquacoltura' or $kword = 'Agricultural and aquaculture facilities'">"Agricoltura, pesca, silvicoltura e prodotti alimentari"</xsl:when>
        <xsl:when test="$kword = 'Impianti di monitoraggio ambientale' or $kword = 'Environmental monitoring facilities'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Indirizzi' or $kword = 'Addresses'">"Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Nomi geografici' or $kword = 'Geographical names'">"Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Orto immagini' or $kword = 'Orthoimagery'">"Scienza e tecnologia", "Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Parcelle catastali' or $kword = 'Cadastral parcels'">"Scienza e tecnologia", "Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Produzione e impianti industriali' or $kword = 'Production and industrial facilities'">"Economia e finanze"</xsl:when>
        <xsl:when test="$kword = 'Regioni biogeografiche' or $kword = 'Bio-geographical regions'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Regioni marine' or $kword = 'Sea regions'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Reti di trasporto' or $kword = 'Transport networks'">"Trasporti"</xsl:when>
        <xsl:when test="$kword = 'Risorse energetiche' or $kword = 'Energy resources'">"Energia"</xsl:when>
        <xsl:when test="$kword = 'Risorse minerarie' or $kword = 'Mineral resources'">"Energia", "Economia e finanze"</xsl:when>
        <xsl:when test="$kword = 'Salute umana e sicurezza' or $kword = 'Human health and safety'">"Salute"</xsl:when>
        <xsl:when test="$kword = 'Servizi di pubblica utilità e servizi amministrativi' or $kword = 'Utility and governmental services'">"Governo e settore pubblico"</xsl:when>
        <xsl:when test="$kword = 'Sistemi di coordinate' or $kword = 'Coordinate reference systems'">"Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Sistemi di griglie geografiche' or $kword = 'Geographical grid systems'">"Regioni e città"</xsl:when>
        <xsl:when test="$kword = 'Siti protetti' or $kword = 'Protected sites'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Suolo' or $kword = 'Soil'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Unità amministrative' or $kword = 'Administrative units'">"Governo e settore pubblico"</xsl:when>
        <xsl:when test="$kword = 'Unità statistiche' or $kword = 'Statistical units'">"Popolazione e società"</xsl:when>
        <xsl:when test="$kword = 'Utilizzo del territorio' or $kword = 'Land use'">"Ambiente", "Economia e finanze"</xsl:when>
        <xsl:when test="$kword = 'Zone a rischio naturale' or $kword = 'Natural risk zones'">"Ambiente"</xsl:when>
        <xsl:when test="$kword = 'Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati' or $kword = 'Area management/restriction/regulation zones and reporting units'">"Ambiente"</xsl:when>
    </xsl:choose>
</xsl:template>


<!-- CHARACTER ENCODING -->

<xsl:template name="characterEncoding">
  <xsl:param name="codeListValue"/>
    <xsl:variable name="CharSetCode">
      <xsl:choose>
        <xsl:when test="$codeListValue = 'ucs2'">
          <xsl:text>ISO-10646-UCS-2</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'ucs4'">
          <xsl:text>ISO-10646-UCS-4</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'utf7'">
          <xsl:text>UTF-7</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'utf8'">
          <xsl:text>UTF-8</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'utf16'">
          <xsl:text>UTF-16</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part1'">
          <xsl:text>ISO-8859-1</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part2'">
          <xsl:text>ISO-8859-2</xsl:text>
        </xsl:when>
        <xsl:when test="@codeListValue = '8859part3'">
          <xsl:text>ISO-8859-3</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part4'">
          <xsl:text>ISO-8859-4</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part5'">
          <xsl:text>ISO-8859-5</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part6'">
          <xsl:text>ISO-8859-6</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part7'">
          <xsl:text>ISO-8859-7</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part8'">
          <xsl:text>ISO-8859-8</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part9'">
          <xsl:text>ISO-8859-9</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part10'">
          <xsl:text>ISO-8859-10</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part11'">
          <xsl:text>ISO-8859-11</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part12'">
          <xsl:text>ISO-8859-12</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part13'">
          <xsl:text>ISO-8859-13</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part14'">
          <xsl:text>ISO-8859-14</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part15'">
          <xsl:text>ISO-8859-15</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = '8859part16'">
          <xsl:text>ISO-8859-16</xsl:text>
        </xsl:when>
<!-- Mapping to be verified: multiple candidates are available in the IANA register for jis -->
        <xsl:when test="$codeListValue = 'jis'">
          <xsl:text>JIS_Encoding</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'shiftJIS'">
          <xsl:text>Shift_JIS</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'eucJP'">
          <xsl:text>EUC-JP</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'usAscii'">
          <xsl:text>US-ASCII</xsl:text>
        </xsl:when>
<!-- Mapping to be verified: multiple candidates are available in the IANA register ebcdic  -->
        <xsl:when test="$codeListValue = 'ebcdic'">
          <xsl:text>IBM037</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'eucKR'">
          <xsl:text>EUC-KR</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'big5'">
          <xsl:text>Big5</xsl:text>
        </xsl:when>
        <xsl:when test="$codeListValue = 'GB2312'">
          <xsl:text>GB2312</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
   <xsl:if test="$foutput = $rdf">
    <cnt:characterEncoding  xmlns:cnt="http://www.w3.org/2011/content#" rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="$CharSetCode"/></cnt:characterEncoding>
   </xsl:if>
   <xsl:if test="$foutput = $jsonld">,
    "cnt:characterEncoding" : {
        "@type" : "xsd:string",
        "@id" : "<xsl:value-of select="$CharSetCode"/>"
        }</xsl:if>
</xsl:template>

<!-- mapping per conformsTo -->

<xsl:template name="decodificaEPSG">
<xsl:variable name="code"/>
<xsl:choose>
 <xsl:when test="$code ='WGS84'">4326</xsl:when>
 <xsl:when test="$code ='ETRS89'">4258</xsl:when>
 <xsl:when test="$code ='ETRS89/ETRS-LAEA'">3035</xsl:when>
 <xsl:when test="$code ='ETRS89/ETRS-LCC'">3034</xsl:when>
 <xsl:when test="$code ='ETRS89/ETRS-TM32'">3044</xsl:when>
 <xsl:when test="$code ='ETRS89/ETRS-TM33'">3045</xsl:when>
 <xsl:when test="$code ='ROMA40/EST'">3004</xsl:when>
 <xsl:when test="$code ='ROMA40/OVEST'">3003</xsl:when>
 <xsl:when test="$code ='ED50/UTM 32N'">23032</xsl:when>
 <xsl:when test="$code ='ED50/UTM 33N'">23033</xsl:when>
 <xsl:when test="$code ='IGM95/UTM 32N'">3064</xsl:when>
 <xsl:when test="$code ='IGM95/UTM 33N'">3065</xsl:when>
 <xsl:when test="$code ='WGS84/UTM 32N'">32632</xsl:when>
 <xsl:when test="$code ='WGS84/UTM 33N'">32633</xsl:when>
 <xsl:when test="$code ='WGS84/UTM 34N'">32634</xsl:when>
 <xsl:when test="$code ='ROMA40'">4265</xsl:when>
 <xsl:when test="$code ='ROMA40/ROMA'">4806</xsl:when>
 <xsl:when test="$code ='ED50'">4230</xsl:when>
 <xsl:when test="$code ='IGM95'">4670</xsl:when>
 <xsl:when test="$code ='WGS84/3d'">4979</xsl:when>
 <xsl:when test="$code ='ETRS89/UTM-ZONE32N'">25832</xsl:when>
 <xsl:when test="$code ='ETRS89/UTM-ZONE33N'">25833</xsl:when>
<xsl:otherwise>http://www.opengis.net/def/crs/EPSG/0/CRS_SCONOSCIUTO: <xsl:value-of select="$code"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- decodifico la lingua -->
<xsl:template name="decodeLang">
  <xsl:param name="kword" />
      <xsl:choose>
        <xsl:when test="$kword = 'ita'">it_IT</xsl:when>
        <xsl:when test="$kword = 'fra'">fr_FR</xsl:when>
        <xsl:when test="$kword = 'deu'">de_DE</xsl:when>
        <xsl:when test="$kword = 'eng'">en_GB</xsl:when>
        <xsl:otherwise>it_IT</xsl:otherwise>
      </xsl:choose>
</xsl:template>

<!-- ricavo il valore di accrualPeriod -->
<xsl:template name="accrualTransf">
  <xsl:param name="accrualOrig" />
      <xsl:choose>
        <xsl:when test="$accrualOrig = 'other'">
          <xsl:text>altro</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'triennial'">
          <xsl:text>triennale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'biennial'">
          <xsl:text>biennale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'monthly_2'">
          <xsl:text>bimensile</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'bimonthly'">
          <xsl:text>bimestrale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'weekly_2'">
          <xsl:text>bisettimanale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'cont'">
          <xsl:text>continuo / continua</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'daily_2'">
          <xsl:text>due volte al giorno</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'never'">
          <xsl:text>mai</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'biweekly'">
          <xsl:text>quindicinale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'weekly_3'">
          <xsl:text>tre volte a settimana</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'monthly_3'">
          <xsl:text>tre volte al mese</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'annual_3'">
          <xsl:text>tre volte all'anno</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'triennial'">
          <xsl:text>triennale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'continual'">
          <xsl:text>in continuo aggiornamento</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'daily'">
          <xsl:text>quotidiano / quotidiana</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'weekly'">
          <xsl:text>settimanale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'fortnightly'">
          <xsl:text>FORTNIGHTLY</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'monthly'">
          <xsl:text>mensile</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'quarterly'">
          <xsl:text>trimestrale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'biannually'">
          <xsl:text>semestrale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'annually'">
          <xsl:text>annuale</xsl:text>
        </xsl:when>
        <xsl:when test="$accrualOrig = 'irregular'">
          <xsl:text>irregolare</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>sconosciuto / sconosciuta</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

<!-- sistema per fare escape dei doppi apici in un testo -->

<xsl:template name="escapeString">
    <xsl:param name="s" select="''"/>
    <xsl:param name="encoded" select="''"/>

    <xsl:choose>
      <xsl:when test="$s = ''">
        <xsl:value-of select="$encoded"/>
      </xsl:when>
      <xsl:when test="contains($s, '&quot;')">
       
        <xsl:call-template name="escapeString">
          <xsl:with-param name="s" select="substring-after($s,'&quot;')"/>
          <xsl:with-param name="encoded"
                          select="concat($encoded,substring-before($s,'&quot;'),'\&quot;')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="removeBreaks"><xsl:with-param name="s" select="concat($encoded, $s)"/></xsl:call-template>

<!--        <xsl:value-of select="concat($encoded, $s)"/> -->

      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="removeBreaks">
    <xsl:param name="s" select="''"/>
    <xsl:param name="encoded" select="''"/>

    <xsl:choose>
      <xsl:when test="$s = ''">
        <xsl:value-of select="$encoded"/>
      </xsl:when>
      <xsl:when test="contains($s, '&#xA;')">
        <xsl:call-template name="removeBreaks">
          <xsl:with-param name="s" select="substring-after($s,'&#xA;')"/>
          <xsl:with-param name="encoded"
                          select="concat($encoded,substring-before($s,'&#xA;'),' ')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="removeCR"><xsl:with-param name="s" select="concat($encoded, $s)"/></xsl:call-template>
<!--        <xsl:value-of select="concat($encoded, $s)"/> -->

      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="removeCR">
    <xsl:param name="s" select="''"/>
    <xsl:param name="encoded" select="''"/>

    <xsl:choose>
      <xsl:when test="$s = ''">
        <xsl:value-of select="$encoded"/>
      </xsl:when>
      <xsl:when test="contains($s, '&#13;')">
        <xsl:call-template name="removeCR">
          <xsl:with-param name="s" select="substring-after($s,'&#13;')"/>
          <xsl:with-param name="encoded"
                          select="concat($encoded,substring-before($s,'&#13;'),'')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat($encoded, $s)"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:transform>

