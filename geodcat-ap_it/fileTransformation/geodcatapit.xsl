<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:adms="http://www.w3.org/ns/adms#" xmlns:cnt="http://www.w3.org/2011/content#"
               xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:dc="http://purl.org/dc/elements/1.1/"
               xmlns:dcat="http://www.w3.org/ns/dcat#" xmlns:dcatapit="http://dati.gov.it/onto/dcatapit#"
               xmlns:dct="http://purl.org/dc/terms/" xmlns:dqv="http://www.w3.org/ns/dqv#"
               xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:gco="http://www.isotc211.org/2005/gco"
               xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd"
               xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:gmx="http://www.isotc211.org/2005/gmx"
               xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss"
               xmlns:gsp="http://www.opengis.net/ont/geosparql#" xmlns:gts="http://www.isotc211.org/2005/gts"
               xmlns:locn="http://www.w3.org/ns/locn#" xmlns:ogc="http://www.opengis.net/ogc"
               xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:ows="http://www.opengis.net/ows"
               xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
               xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:schema="http://schema.org/"
               xmlns:sdmx-attribute="http://purl.org/linked-data/sdmx/2009/attribute#"
               xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:srv="http://www.isotc211.org/2005/srv"
               xmlns:vcard="http://www.w3.org/2006/vcard/ns#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
               xmlns="http://www.isotc211.org/2005/gmd"
               xsi:schemaLocation="http://www.isotc211.org/2005/gmd https://inspire.ec.europa.eu/draft-schemas/inspire-md-schemas-temp/apiso-inspire/apiso-inspire.xsd" version="1.0">

    <xsl:output method="xml" indent="yes" encoding="utf-8" cdata-section-elements="locn:geometry"/>


    <xsl:param name="xsd">http://www.w3.org/2001/XMLSchema#</xsl:param>
    <xsl:param name="gsp">http://www.opengis.net/ont/geosparql#</xsl:param>

    <!-- variabili per la scelta dell'output -->
    <xsl:variable name="jsonld">application/ld+json</xsl:variable>
    <xsl:variable name="rdf">application/rdf+xml</xsl:variable>

    <!-- variabili per la scelta del formato di dati -->
    <xsl:variable name="dcatap_it">dcatap_it</xsl:variable>
    <xsl:variable name="geodcatap_it">geodcatap_it</xsl:variable>

    <!-- parametri per le URI delle sezioni. Modificare eventualmente il namespace -->
    <xsl:param name="ResourceCatalogURI">https://geodati.gov.it/resource/catalog/</xsl:param>
    <xsl:param name="ResourceCatalogRecordURI">https://geodati.gov.it/resource/catalogRecord/</xsl:param>
    <xsl:param name="ResourceDatasetURI">https://geodati.gov.it/resource/id/</xsl:param>
    <xsl:param name="ResourceDistributionURI">https://geodati.gov.it/resource/distribution/</xsl:param>
    <xsl:param name="ResourceAgentURI">https://geodati.gov.it/resource/administration/</xsl:param>
    <!-- =====================-->
    <xsl:param name="ResourceContactPointURI">https://geodati.gov.it/resource/pointOfContact/</xsl:param>
    <xsl:param name="ResourcePeriodoTemporaleURI">https://geodati.gov.it/resource/temporalExtent/</xsl:param>
    <xsl:param name="ResourceAltroIdentificativoURI">https://geodati.gov.it/resource/otherIdentifier/</xsl:param>
    <xsl:param name="ResourceLocationURI">https://geodati.gov.it/resource/spatial/</xsl:param>
    <xsl:param name="ResourceStandardURI">https://geodati.gov.it/resource/standard/</xsl:param>
    <xsl:param name="ResourceLicenseURI">https://geodati.gov.it/resource/license/</xsl:param>
    <xsl:param name="ResourceDataQualityURI">https://geodati.gov.it/resource/dataQuality/</xsl:param>
    <xsl:param name="ResourceConstraintURI">https://geodati.gov.it/resource/constraints/</xsl:param>
    <xsl:param name="ResourceProvenanceURI">https://geodati.gov.it/resource/provenance/</xsl:param>


    <xsl:param name="id_suffix">_ID</xsl:param>

    <!-- URL utili -->
    <xsl:param name="EUPublications">http://publications.europa.eu/resource/authority/frequency/</xsl:param>

    <!-- formato di output e profilo di default -->
    <xsl:param name="foutput" select="$rdf"/>
    <xsl:param name="profile" select="$dcatap_it"/>

    <!-- Intestazione e Catalogo -->
    <xsl:template match="/">

        <!-- ricerca dell'ultima modifica del catalogo -->
        <!-- Data di modifica impostata a "ieri" -->

        <xsl:param name="lastCatModify"><xsl:value-of select="$yesterday"/>
            <!--
          <xsl:for-each select="//gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date">
                 <xsl:sort select="gmd:CI_Date/gmd:date/gco:Date" order="descending"/>
                 <xsl:if test="position() = 1"><xsl:value-of select="gmd:CI_Date/gmd:date/gco:Date" /></xsl:if>
          </xsl:for-each>
      -->
        </xsl:param>
        <!-- ========================== -->

		<!-- I valori dei parametri seguenti sono da modificare facendo riferimento al catalogo in cui la soluzione è riusata. Nell'esempio RNDT -->
        <xsl:param name="catalog_id">https://geodati.gov.it</xsl:param>
        <xsl:param name="title">RNDT - Repertorio Nazionale dei Dati Territoriali - Servizio di ricerca</xsl:param>
        <xsl:param name="description">Il servizio di ricerca del RNDT fornisce l'accesso ai metadati su dati e servizi territoriali delle Pubbliche Amministrazioni italiane. Esso è conforme alle specifiche CSW (ISO Application Profile) di OGC e alle linee guida INSPIRE sui servizi di ricerca</xsl:param>

        <xsl:param name="homepage">https://geodati.gov.it</xsl:param>
        <xsl:param name="language">http://publications.europa.eu/resource/authority/language/ITA</xsl:param>

        <xsl:param name="publisher">https://geodati.gov.it/resource/publisher/agid</xsl:param>
        <xsl:param name="issued">2012-04-06</xsl:param>
        <xsl:param name="themeTaxonomy">http://publications.europa.eu/resource/authority/data-theme</xsl:param>
        <xsl:param name="cat-license">https://creativecommons.org/licenses/by/4.0/legalcode.it</xsl:param>


        <xsl:choose>
            <xsl:when test="$foutput = $rdf">

                <rdf:RDF xmlns:adms="http://www.w3.org/ns/adms#" xmlns:dc="http://purl.org/dc/elements/1.1/"
                         xmlns:dcat="http://www.w3.org/ns/dcat#" xmlns:dcatapit="http://dati.gov.it/onto/dcatapit#"
                         xmlns:dct="http://purl.org/dc/terms/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
                         xmlns:gml="http://www.opengis.net/gml/3.2"
                         xmlns:gsp="http://www.opengis.net/ont/geosparql#" xmlns:locn="http://www.w3.org/ns/locn#"
                         xmlns:owl="http://www.w3.org/2002/07/owl#"
                         xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                         xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                         xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                         xmlns:vcard="http://www.w3.org/2006/vcard/ns#">

                    <dcatapit:Catalog rdf:about="{$catalog_id}">
                        <rdf:type rdf:resource="http://www.w3.org/ns/dcat#Catalog"/>
                        <dct:title xml:lang="it"><xsl:value-of select="$title"/></dct:title>
                        <dct:description xml:lang="it"><xsl:value-of select="$description"/></dct:description>
                        <!-- Da modificare le informazioni relative all'amministrazione titolare del catalogo. Nell'esempio AgID -->
                        <dct:publisher>
                            <dcatapit:Agent rdf:about="https://indicepa.gov.it/ricerca/n-dettaglioamministrazione.php?cod_amm=agid">
                                <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Organization"/>
                                <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent"/>
                                <dct:identifier>agid</dct:identifier>
                                <foaf:name xml:lang="it">Agenzia per l'Italia Digitale</foaf:name>
                            </dcatapit:Agent>
                        </dct:publisher>
                        <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#Date"><xsl:value-of select="$lastCatModify"/></dct:modified>
                        <foaf:homepage rdf:resource="{$homepage}"/>
                        <dct:language rdf:resource="{$language}"/>
                        <dct:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#Date"><xsl:value-of select="$issued"/></dct:issued>
                        <dcat:themeTaxonomy>
                            <skos:ConceptScheme rdf:about="{$themeTaxonomy}">
                                <dct:title>Data Theme Vocabulary</dct:title>
                            </skos:ConceptScheme>
                        </dcat:themeTaxonomy>
                        <dct:license rdf:resource="{$cat-license}"/>
                        <xsl:if test="$profile = $dcatap_it">
                            <!-- per dcatap_it non prendo i servizi -->
                            <xsl:for-each select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                                <dcat:dataset>
                                    <xsl:call-template name="dataset"/>
                                </dcat:dataset>
                            </xsl:for-each>
                        </xsl:if>



                        <!-- GEODCAT-AP_IT -->

                        <xsl:if test="$profile = $geodcatap_it">

                            <xsl:for-each select="//gmd:MD_Metadata">
                                <dcat:dataset>
                                    <xsl:call-template name="dataset"/>
                                </dcat:dataset>
                            </xsl:for-each>


                        </xsl:if>

                    </dcatapit:Catalog>


                    <xsl:if test="$profile=$geodcatap_it">

                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="catalogrecord"/>
                        </xsl:for-each>
                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="puntoDiContattoCatalogRecord"/>
                        </xsl:for-each>
                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="qualityInfo"/>
                        </xsl:for-each>
                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="provenance"/>
                        </xsl:for-each>
                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="distribution"/>
                        </xsl:for-each>

                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="puntoDiContatto"/>
                        </xsl:for-each>
                        <xsl:for-each select="//gmd:MD_Metadata">
                            <xsl:call-template name="rightsAll"/>
                        </xsl:for-each>
                    </xsl:if>

                    <!-- dcat-ap_IT -->

                    <xsl:if test="$profile=$dcatap_it">



                        <xsl:for-each
                                select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                            <xsl:call-template name="distribution"/>
                        </xsl:for-each>

                        <xsl:for-each
                                select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                            <xsl:call-template name="puntoDiContatto"/>
                        </xsl:for-each>

                    </xsl:if>

                </rdf:RDF>
            </xsl:when>
            <xsl:when test="$foutput = $jsonld"> { "dcatapit:Catalog" : { "@id": "<xsl:value-of
                    select="$catalog_id"/>", "@type": [ "http://www.w3.org/ns/dcat#Catalog",
                "http://dati.gov.id/onto/dctapit#Catalog" ], "dcterms:title": { "@language": "it", "@value"
                : "<xsl:value-of select="$title"/>" }, "dcterms:description" : { "@language" : "it",
                "@value" : "<xsl:value-of select="$description"/>" }, "foaf:homepage" : { "@id" :
                "<xsl:value-of select="$homepage"/>" }, "dcterms:language" : { "@id" : "<xsl:value-of
                        select="$language"/>"
                },
                "dcterms:publisher" : {
                "@id" : "<xsl:value-of select="$publisher"/>"
                }, "dcterms:issued" : { "@type": "xsd:date", "@value" : "<xsl:value-of select="$issued"/>"
                }, "dcterms:modified" : { "@type" : "http://www.w3.org/2001/XMLSchema#Date", "@value" : "<xsl:value-of
                        select="$lastCatModify"/>" }, "dcat:themeTaxonomy" : { "@id" : "<xsl:value-of
                        select="$themeTaxonomy"/>" }, <xsl:if test="$profile = $dcatap_it">
                    <!-- per dcatap_it non prendo i servizi --> "dcat:dataset" : [ <xsl:for-each
                        select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]"
                > { "@id" : "<xsl:value-of
                        select="concat($ResourceDatasetURI, gmd:fileIdentifier/gco:CharacterString)"

                />"<xsl:if test="position()!=last()">, </xsl:if>
                </xsl:for-each> ] } </xsl:if>
                <xsl:if test="$profile=$geodcatap_it">
                    <!-- GEODCAT-AP_IT --> "dcat:dataset" : [ <xsl:for-each
                        select="//gmd:MD_Metadata/gmd:fileIdentifier"
                > { "@id" : "<xsl:value-of
                        select="concat($ResourceDatasetURI, gco:CharacterString)"
                />"}<xsl:if test="position()!=last()">, </xsl:if>
                </xsl:for-each> ] }} <xsl:for-each select="//gmd:MD_Metadata">
                    <xsl:call-template name="catalogrecord"/>
                </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="puntoDiContattoCatalogRecord"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="qualityInfo"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="provenance"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="dataset"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="distribution"/>
                    </xsl:for-each>, 
                    "dcatapit:Agent" : { "@id": "<!-- Modificare URI e informazioni dell'amministrazione titolare del catalogo-->https://indicepa.gov.it/ricerca/n-dettaglioamministrazione.php?cod_amm=agid",
                    "@type": [ "foaf:Agent", "http://dati.gov.it/onto/dcatapit#Agent" ], "dcterms:identifier":
                    "agid", "foaf:name": { "@language": "it", "@value": "Agenzia per l'italia Digitale" } }
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="agent"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="licenza"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="puntoDiContatto"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="rightsAll"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="periodOfTime"/>
                    </xsl:for-each>
                    <xsl:for-each select="//gmd:MD_Metadata">
                        <xsl:call-template name="location"/>
                    </xsl:for-each>
                </xsl:if>
                <!-- dcat-ap_IT -->
                <xsl:if test="$profile = $dcatap_it">
                    <xsl:for-each
                            select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                        <xsl:call-template name="dataset"/>
                    </xsl:for-each>
                    <xsl:for-each
                            select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                        <xsl:call-template name="distribution"/>
                    </xsl:for-each>, "dcatapit:Agent" : { "@id": "<!-- Modificare URI e informazioni dell'amministrazione titolare del catalogo-->https://indicepa.gov.it/ricerca/n-dettaglioamministrazione.php?cod_amm=agid", "@type": [ "foaf:Agent",
                    "http://dati.gov.it/onto/dcatapit#Agent" ], "dcterms:identifier": "agid", "foaf:name": {
                    "@language": "it", "@value": "Agenzia per l'italia Digitale" } } <xsl:for-each
                        select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                    <xsl:call-template name="agent"/>
                </xsl:for-each>
                    <xsl:for-each
                            select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                        <xsl:call-template name="licenza"/>
                    </xsl:for-each>
                    <xsl:for-each
                            select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                        <xsl:call-template name="puntoDiContatto"/>
                    </xsl:for-each>
                    
                    <xsl:for-each
                            select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                        <xsl:call-template name="periodOfTime"/>
                    </xsl:for-each>
                    <xsl:for-each
                            select="//gmd:MD_Metadata[not(contains(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue , 'service'))]">
                        <xsl:call-template name="location"/>
                    </xsl:for-each>
                    
                </xsl:if> } </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//gmd:MD_Metadata"/>

    <xsl:template name="alternateIdentifier">
        <xsl:param name="identificativo">
            <xsl:value-of select="concat($ResourceAltroIdentificativoURI, 'NON SO', $id_suffix)"/>
        </xsl:param>
        <xsl:param name="valore">NON SO</xsl:param>

        <xsl:choose>
            <xsl:when test="$foutput = $rdf">
                <adms:Identifier rdf:about="{$identificativo}">
                    <skos:notation>
                        <xsl:value-of select="$valore"/>
                    </skos:notation>
                </adms:Identifier>
            </xsl:when>

            <xsl:when test="$foutput = $jsonld"> "adms:Identifier" : { "@id": "<xsl:value-of
                    select="$identificativo"/>", "@type": "adms:Identifier", "skos:notation": { "@value":
                "<xsl:value-of select="$valore"/>" } } </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- LOCATION -->
    <xsl:template name="location">

        <xsl:variable name="identificativo" select="concat($ResourceLocationURI, gmd:fileIdentifier/gco:CharacterString)"/>

        <xsl:variable name="name">http://www.opengis.net/def/EPSG/0/4326</xsl:variable>


        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">

            <xsl:variable name="cardinal" select="position()"/>
            <xsl:variable name="west" select="gmd:westBoundLongitude/gco:Decimal"/>
            <xsl:variable name="east" select="gmd:eastBoundLongitude/gco:Decimal"/>
            <xsl:variable name="south" select="gmd:southBoundLatitude/gco:Decimal"/>
            <xsl:variable name="north" select="gmd:northBoundLatitude/gco:Decimal"/>

            <xsl:variable name="GMLLiteral">&lt;gml:Envelope
                srsName=\"http://www.opengis.net/def/EPSG/0/4326\"&gt;&lt;gml:lowerCorner&gt;<xsl:value-of
                        select="$south"/><xsl:text> </xsl:text><xsl:value-of select="$west"
                />&lt;/gml:lowerCorner&gt;&lt;gml:upperCorner&gt;<xsl:value-of select="$north"
                /><xsl:text> </xsl:text><xsl:value-of select="$east"
                />&lt;/gml:upperCorner&gt;&lt;/gml:Envelope&gt;</xsl:variable>


            <xsl:variable name="envelope">&lt;gml:Envelope
                srsName=&quot;http://www.opengis.net/def/EPSG/0/4326&quot;&gt;&lt;gml:lowerCorner&gt;<xsl:value-of
                        select="concat($south, ' ', $west)"
                />&lt;/gml:lowerCorner&gt;&lt;gml:upperCorner&gt;<xsl:value-of
                        select="concat($north, ' ', $east)"
                />&lt;/gml:upperCorner&gt;&lt;/gml:Envelope&gt;</xsl:variable>

            <xsl:choose>
                <xsl:when test="$foutput = $rdf">

                    <dct:Location rdf:about="{$identificativo}">
    
                        <locn:geometry rdf:datatype="http://www.opengis.net/ont/geosparql#wktLiteral"><xsl:value-of select="concat('POLYGON ((', $east, ' ', $north, ', ', $west, ' ', $north, ', ', $west, ' ', $south, ', ', $east, ' ', $south, ', ', $east, ' ', $north, '))')"/></locn:geometry>
                    </dct:Location>
                </xsl:when>

                <xsl:when test="$foutput = $jsonld">, "dcterms:Location" : { "@id": "<xsl:value-of
                        select="$identificativo"/>", "@type": "dcterms:Location", "locn:geometry": { "@type":
                    "gsp:gmlLiteral", "@value": "<xsl:value-of select="$GMLLiteral"/>" } } </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <!-- CATALOG RECORD -->


    <xsl:template name="catalogrecord">


        <xsl:param name="catalogRecordId">
            <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="isVersionOf">
            <xsl:value-of select="gmd:parentIdentifier/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="conformsTo">
            <xsl:if test="gmd:metadataStandardName/gco:CharacterString!='DM - Regole tecniche RNDT'">
                <xsl:value-of select="gmd:metadataStandardName/gco:CharacterString"/>
            </xsl:if>
            <xsl:if test="gmd:metadataStandardName/gco:CharacterString!='DM - Regole tecniche RNDT'">
                https://www.gazzettaufficiale.it/eli/id/2012/02/27/12A01801/sg
            </xsl:if>
        </xsl:param>

        <xsl:param name="conformsVersion">
            <xsl:value-of select="gmd:metadataStandardVersion/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="modified">
            <xsl:value-of select="gmd:dateStamp/gco:Date"/>
        </xsl:param>

        <xsl:param name="languageCode">
            <xsl:value-of select="gmd:language/gmd:LanguageCode"/>
        </xsl:param>

        <xsl:param name="codeListValue">
            <xsl:value-of select="gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/>
        </xsl:param>

        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>

        <xsl:choose>
            <xsl:when test="$foutput = $rdf">

                <dcat:CatalogRecord rdf:about="{concat($ResourceCatalogRecordURI, $catalogRecordId)}">
                    <dct:language rdf:resource="{concat('http://publications.europa.eu/resource/authority/language/', translate($languageCode, $lowercase, $uppercase))}"/>
                    <dct:identifier rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="$catalogRecordId"/></dct:identifier>
                    <dct:isVersionOf><xsl:value-of select="$isVersionOf"/></dct:isVersionOf>

                    <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="$modified"/></dct:modified>
                    <xsl:for-each select="gmd:contact">
                        
                        <dcat:contactPoint rdf:resource="{concat($ResourceContactPointURI, $catalogRecordId, '-', position())}"/>
                    </xsl:for-each>

                    <dct:source rdf:parseType="Resource">
                        
                        <xsl:if test="gmd:metadataStandardName/gco:CharacterString='DM - Regole tecniche RNDT'">
                            <dct:conformsTo rdf:resource="{$conformsTo}"/>
                            
                        </xsl:if>
                        <xsl:if test="gmd:metadataStandardName/gco:CharacterString!='DM - Regole tecniche RNDT'">
                            <dct:conformsTo>
                                <dcatapit:Standard>
                                    <rdf:type rdf:resource="dct:Standard"/>
                                    <dct:title xml:lang="it"><xsl:value-of select="$conformsTo"/></dct:title>
                                    <owl:versionInfo xml:lang="it"><xsl:value-of select="$conformsVersion"/></owl:versionInfo>
                                </dcatapit:Standard>
                            </dct:conformsTo>
                            
                        </xsl:if>
                    </dct:source>
                    <xsl:call-template name="characterEncoding">
                        <xsl:with-param name="codeListValue" select="$codeListValue"/>
                    </xsl:call-template>
                </dcat:CatalogRecord>


            </xsl:when>

            <xsl:when test="$foutput = $jsonld">, "dcat:CatalogRecord" : { "@id": "<xsl:value-of
                    select="concat($ResourceCatalogRecordURI, $catalogRecordId)"/>", "@type": [
                "dcat:CatalogRecord", "http://dati.gov.id/onto/dctapit#CatalogRecord" ], "dcterms:language"
                : { "@id" : "<xsl:value-of select="concat('http://publications.europa.eu/resource/authority/language/', translate($languageCode, $lowercase, $uppercase))"/>" }, "dcterms:identifier" :
                "<xsl:value-of select="$catalogRecordId"/>", "dcterms:isVersionOf" : "<xsl:value-of
                        select="$isVersionOf"/>", <xsl:if test="gmd:metadataStandardName/gco:CharacterString='DM - Regole tecniche RNDT'">"dcterms:conformsTo" : { "@id" : "<xsl:value-of
                        select="$conformsTo"/>"},</xsl:if><xsl:if test="gmd:metadataStandardName/gco:CharacterString!='DM - Regole tecniche RNDT'">
                    "dcterms:conformsTo" : { "dcterms:title" : "<xsl:value-of
                        select="$conformsTo"/>", "owl:versionInfo" : "<xsl:value-of select="$conformsVersion"/>" },</xsl:if>
                <xsl:call-template name="characterEncoding"><xsl:with-param name="codeListValue"
                                                                            select="$codeListValue"/></xsl:call-template>, "dcterms:modified" : { "@type" :
                "xsd:date", "@value" : "<xsl:value-of select="$modified"/>" }, "dcat:contactPoint" :
                "<xsl:value-of
                        select="concat($ResourceContactPointURI, $catalogRecordId, '-', position())"/>" }
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- STANDARD -->

    <xsl:template name="standard">

        <xsl:param name="identification"><xsl:value-of select="concat($ResourceStandardURI, 'NON SO', $id_suffix)"/></xsl:param>

        <xsl:param name="title">DM - Regole tecniche RNDT</xsl:param>

        <xsl:param name="description">DM - Regole tecniche RNDT</xsl:param>
        <xsl:param name="about">http://data.europa.eu/eli/reg/2010/1089</xsl:param>
        <xsl:param name="documentation">http://data.europa.eu/eli/reg/2010/1089</xsl:param>

        <xsl:param name="conformsTo"><xsl:value-of select="gmd:metadataStandardName/gco:CharacterString"/></xsl:param>

        <xsl:param name="conformsVersion"><xsl:value-of select="gmd:metadataStandardVersion/gco:CharacterString"/></xsl:param>


        <xsl:choose>
            <xsl:when test="$foutput = $rdf">

                <dcatapit:Standard rdf:about="{$about}">
                    <rdf:type rdf:resource="dct:Standard"/>
                    <dct:title xml:lang="it"><xsl:value-of select="$title"/></dct:title>
                    <dct:description xml:lang="it"><xsl:value-of select="$description"/></dct:description>
                    <owl:versionInfo xml:lang="it">10 novembre 2011</owl:versionInfo>
                    <dcatapit:referenceDocumentation rdf:datatype="xsd:anyURI"><xsl:value-of select="$documentation"/></dcatapit:referenceDocumentation>
                </dcatapit:Standard>
            </xsl:when>

            <xsl:when test="$foutput = $jsonld">, "dcatapit:Standard" : { "@id": "<xsl:value-of
                    select="$about"/>", "@type": [ "dcterms:Standard",
                "http://dati.gov.it/onto/dcatapit#Standard" ], "dcterms:description": { "@language": "it",
                "@value": "<xsl:value-of select="$description"/>" }, "dcterms:title": { "@language": "it",
                "@value": "<xsl:value-of select="$title"/>" }, "owl:versionInfo": { "@language" : "it",
                "@value" : "10 novembre 2011" }, "http://dati.gov.it/onto/dcatapit#referenceDocumentation":
                [ { "@type": "xsd:anyURI", "@value": "<xsl:value-of select="$documentation"/>" } ] }
            </xsl:when>
        </xsl:choose>

    </xsl:template>


    <!-- PROVENANCE -->

    <xsl:template name="provenance">

        <xsl:variable name="identifier"><xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString"/></xsl:variable>

        <xsl:variable name="provenance"><xsl:value-of select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString"/></xsl:variable>

        <xsl:choose>
            <xsl:when test="$foutput = $rdf">
                <xsl:if test="$provenance != ''">
                    <dct:ProvenanceStatement rdf:about="{concat($ResourceProvenanceURI, $identifier, $id_suffix)}">
                        <rdfs:label xml:lang="it">
                            <xsl:call-template name="escapeString">
                                <xsl:with-param name="s" select="$provenance"/>
                            </xsl:call-template>
                        </rdfs:label>
                    </dct:ProvenanceStatement>
                </xsl:if>

            </xsl:when>

            <xsl:when test="$foutput = $jsonld">
                <xsl:if test="$provenance != ''">, "dcterms:ProvenanceStatement" : { "@id": "<xsl:value-of
                        select="concat($ResourceProvenanceURI, $identifier, $id_suffix)"/>", "rdfs:label": {
                    "@language" : "it", "@value" : "<xsl:call-template name="escapeString"><xsl:with-param
                            name="s" select="$provenance"/></xsl:call-template>" } } </xsl:if>

            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- RIGHTS -->

    <xsl:template name="rightsAll">

        <xsl:variable name="identifier">
            <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:variable>

        <xsl:variable name="accessRights">
            <xsl:choose>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode != 'altri vincoli'">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode"/>
                </xsl:when>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode = 'altri vincoli'">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="useRights">
            <xsl:choose>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode != 'altri vincoli'">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode"/>
                </xsl:when>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode != 'altri vincoli'">
                    <xsl:value-of select="''"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$foutput = $rdf">
                <xsl:if test="$useRights != ''">
                    <dct:RightsStatement rdf:about="{concat($ResourceConstraintURI, $identifier, $id_suffix, '_useConstraints')}">
                        <rdfs:label xml:lang="it"><xsl:value-of select="$useRights"/></rdfs:label>
                    </dct:RightsStatement>
                </xsl:if>
                <dct:RightsStatement rdf:about="{concat($ResourceConstraintURI, $identifier, $id_suffix, '_accessConstraints')}">
                    <rdfs:label xml:lang="it"><xsl:value-of select="$accessRights"/></rdfs:label>
                </dct:RightsStatement>
            </xsl:when>

            <xsl:when test="$foutput = $jsonld">, "dcterms: RightsStatement" : { "@id": "<xsl:value-of
                    select="concat($ResourceConstraintURI, $identifier, $id_suffix, '_accessConstraints')"/>",
                "rdfs:label": { "@language" : "it", "@value" : "<xsl:value-of select="$accessRights"/>" } }
                <xsl:if test="$useRights != ''">, "dcterms: RightsStatement" : { "@id": "<xsl:value-of
                        select="concat($ResourceConstraintURI, $identifier, $id_suffix, '_useConstraints')"/>",
                    "rdfs:label": { "@language" : "it", "@value" : "<xsl:value-of select="$useRights"/>" } }
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- ORGANIZATION -->

    <xsl:template name="puntoDiContattoCatalogRecord">
        
        <xsl:param name="catalogRecordId">
            <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>

        <xsl:for-each select="gmd:contact/gmd:CI_ResponsibleParty">
            <xsl:variable name="fn" select="gmd:organisationName/gco:CharacterString"/>

            <xsl:variable name="hasEmail" select="gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>

            <xsl:variable name="hasURL" select="gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>

            <xsl:variable name="hasTelephone" select="gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>

            <xsl:choose>
                <xsl:when test="$foutput = $rdf">
            
                    <dcatapit:Organization rdf:about="{concat($ResourceContactPointURI, $catalogRecordId, '-', position())}">

                        <rdf:type rdf:resource="vcard:Kind"/>
                        <rdf:type rdf:resource="vcard:Organization"/>
                        <vcard:fn xml:lang="it"><xsl:value-of select="$fn"/></vcard:fn>
                        <vcard:hasEmail rdf:resource="{concat('mailto:',$hasEmail)}"/>
                        <xsl:if test="$hasURL != ''">
                            <vcard:hasURL rdf:resource="{$hasURL}"/>
                        </xsl:if>
                        <xsl:if test="$hasTelephone != ''">
                            <vcard:hasTelephone rdf:parseType="Resource">
                                <vcard:value><xsl:value-of select="$hasTelephone"/></vcard:value>
                                <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Voice"/>
                            </vcard:hasTelephone>
                        </xsl:if>
                    </dcatapit:Organization>
                </xsl:when>

                <xsl:when test="$foutput = $jsonld"> , "dcatapit:Organization" : { "@id" : "<xsl:value-of
                        select="concat($ResourceContactPointURI, $catalogRecordId, '-', position())"/>",
                    "@type" : [ "vcard:Organization", "vcard:Kind",
                    "http://dati.gov.it/onto/dcatapit#Organization" ], "vcard:fn" : "<xsl:call-template
                            name="escapeString"><xsl:with-param name="s" select="$fn"/></xsl:call-template>",
                    "vcard:hasEmail" : { "@id" : "mailto:<xsl:value-of select="$hasEmail"/>" } <xsl:if
                            test="$hasTelephone != ''">, "vcard:hasTelephone" : { "@type" : "vcard:Voice",
                        "vcard:hasValue" : "<xsl:value-of select="$hasTelephone"/>" }</xsl:if>
                    <xsl:if test="$hasURL != ''">, "vcard:hasURL" : { "@id" : "<xsl:value-of select="$hasURL"
                    />" }</xsl:if> }</xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <!-- Punti di contatto di serie, dataset e servizi  -->
    <xsl:template name="puntoDiContatto">

        <xsl:param name="catalogRecordId">
            <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="hierarchyLevel">
            <xsl:value-of select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
        </xsl:param>

        <xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification | gmd:identificationInfo/srv:SV_ServiceIdentification">

            <xsl:variable name="fn" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"/>

            <xsl:variable name="hasEmail" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>

            <xsl:variable name="hasURL" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>

            <xsl:variable name="hasTelephone" select="gmd:pointOfContact/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>

            <xsl:choose>
                <xsl:when test="$foutput = $rdf">
            
                    <dcatapit:Organization rdf:about="{concat($ResourceContactPointURI, $catalogRecordId, '-', position())}">
                        <rdf:type rdf:resource="vcard:Kind"/>
                        <rdf:type rdf:resource="vcard:Organization"/>
                        <vcard:fn xml:lang="it"><xsl:value-of select="$fn"/></vcard:fn>
                        <vcard:hasEmail rdf:resource="{concat('mailto:',$hasEmail)}"/>
                        <xsl:if test="$hasURL != ''">
                            <vcard:hasURL rdf:resource="{$hasURL}"/>
                        </xsl:if>
                        <xsl:if test="$hasTelephone != ''">
                            <vcard:hasTelephone rdf:parseType="Resource">
                                <vcard:value><xsl:value-of select="$hasTelephone"/></vcard:value>
                                <rdf:type rdf:resource="http://www.w3.org/2006/vcard/ns#Voice"/>
                            </vcard:hasTelephone>
                        </xsl:if>
                    </dcatapit:Organization>
                </xsl:when>

                <xsl:when test="$foutput = $jsonld"> , "dcatapit:Organization" : { "@id" : "<xsl:value-of select="concat($ResourceContactPointURI, $catalogRecordId, '-', position())"/>", "@type" : [ "vcard:Organization", "vcard:Kind",
                    "http://dati.gov.it/onto/dcatapit#Organization" ], "vcard:fn" : "<xsl:call-template
                            name="escapeString"><xsl:with-param name="s" select="$fn"/></xsl:call-template>",
                    "vcard:hasEmail" : { "@id" : "mailto:<xsl:value-of select="$hasEmail"/>" } <xsl:if
                            test="$hasTelephone != ''">, "vcard:hasTelephone" : { "@type" : "vcard:Voice",
                        "vcard:hasValue" : "<xsl:value-of select="$hasTelephone"/>" } </xsl:if>
                    <xsl:if test="$hasURL != ''">, "vcard:hasURL" : { "@id" : "<xsl:value-of select="$hasURL"
                    />" } </xsl:if> }</xsl:when>
            </xsl:choose>

        </xsl:for-each>

    </xsl:template>


    <!-- DISTRIBUTION -->
    <xsl:template name="distribution">

        <xsl:param name="catalogRecordId">
            <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="format">
            <xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString"/>
        </xsl:param>



        <xsl:param name="title">
            <xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:name/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="description">
            <xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:description/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="license">
            <xsl:value-of select="concat($ResourceLicenseURI, gmd:fileIdentifier/gco:CharacterString)"/>

        </xsl:param>

        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

        <xsl:variable name="formatURI">
            <xsl:choose>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shp') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shape')">SHP</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'zip')">ZIP</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'pdf')">PDF</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'kml')">KML</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'tif')">TIFF</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpg') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpeg')">JPEG</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'ecw')">ECW</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'mdb')">MDB</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'csv')">CSV</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'gml')">GML</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'geojson')">GEOJSON</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'grid')">GRID</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'rdf')">RDF</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'xml')">XML</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('format', '-', position())"/>
                </xsl:otherwise>
               
            </xsl:choose>
        </xsl:variable>

       
        <xsl:variable name="conformsToWms">
            <xsl:choose>
                <xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString = 'WMS' or gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString = 'WMS' or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL, $uppercase, $lowercase), 'wms')">http://www.opengis.net/def/serviceType/ogc/wms</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="conformsToWfs">
            <xsl:choose>
                <xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString = 'WFS' or gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString = 'WFS' or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL, $uppercase, $lowercase), 'wfs')">http://www.opengis.net/def/serviceType/ogc/wfs</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="accessURL">
            <xsl:choose>
                <xsl:when test="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL != ''">
				    <xsl:value-of select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions[1]/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
				</xsl:when>
				<xsl:when test="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL != ''">
				    <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
				</xsl:when>
				<xsl:otherwise>
                    <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:variable name="accessRights">
            <xsl:choose>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode != 'altri vincoli'">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode"/>
                </xsl:when>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode = 'altri vincoli'">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="rights">
            <xsl:choose>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode != 'altri vincoli'">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode"/>
                </xsl:when>
                <xsl:when test="gmd:identificationInfo/*/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode != 'altri vincoli'">
                    <xsl:value-of select="''"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="representation">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode/@codeListValue"/>
        </xsl:variable>

      

        <xsl:choose>
            <xsl:when test="$foutput = $rdf">


               
                <dcatapit:Distribution rdf:about="{concat($ResourceDistributionURI, $catalogRecordId, '/', $formatURI, '-', position())}">
                    <rdf:type rdf:resource="http://www.w3.org/ns/dcat#Distribution"/>
                   
                    <xsl:if test="(contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shp') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shape') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'zip') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'pdf') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'kml') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'tif') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpg') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpeg') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'ecw') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'mdb') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'csv') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'gml') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'geojson') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'grid') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'rdf') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'xml'))">
                        <dct:format rdf:resource="{concat('http://publications.europa.eu/resource/authority/file-type/', $formatURI)}"></dct:format>
                    </xsl:if>
                    <xsl:if test="not(contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shp') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shape') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'zip') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'pdf') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'kml') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'tif') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpg') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpeg') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'ecw') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'mdb') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'csv') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'gml') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'geojson') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'grid') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'rdf') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'xml'))">
                        <dct:format>
                            <xsl:value-of select="$format"/>
                        </dct:format>
                    </xsl:if>
                    <dcat:accessURL rdf:resource="{$accessURL}"/>

                   
                    <dct:license>
                        <xsl:call-template name="licenza"/>
                    </dct:license>

                    
                    <xsl:for-each
                            select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage">
                       
                        <xsl:if test="contains(translate(gmd:URL, $uppercase, $lowercase), 'wfs') or contains(translate(gmd:URL, $uppercase, $lowercase), 'zip') or contains(translate(gmd:URL, $uppercase, $lowercase), 'atom') or contains(translate(gmd:URL, $uppercase, $lowercase), 'kml')">
                            <dcat:downloadURL rdf:resource="{gmd:URL}"/>
                        </xsl:if>
                    </xsl:for-each>

                   

                    <xsl:if test="$profile = $geodcatap_it">
                        <xsl:if test="$conformsToWms != ''">
                            <dct:conformsTo rdf:resource="{$conformsToWms}"/>
                            <dct:description xml:lang="it">Web Map Service (WMS)</dct:description>
                        </xsl:if>
                        <xsl:if test="$conformsToWfs != ''">
                            <dct:conformsTo rdf:resource="{$conformsToWfs}"/>
                            <dct:description xml:lang="it">Web Feature Service (WFS)</dct:description>
                        </xsl:if>
                        
                        <xsl:if test="$conformsToWms != '' or $conformsToWfs != ''">
                            <dct:type rdf:resource="http://publications.europa.eu/resource/authority/distribution-type/WEB_SERVICE"/>
                            
                        </xsl:if>
                        <xsl:if test="$rights != ''">
                            <dct:rights rdf:resource="{concat($ResourceConstraintURI, $catalogRecordId, $id_suffix, '_useConstraints')}"/>
                        </xsl:if>
                        <dct:rights rdf:resource="{concat($ResourceConstraintURI, $catalogRecordId, $id_suffix, '_accessConstraints')}"/>

                        <xsl:if test="$representation != ''">
                            <adms:representationTechnique>http://inspire.ec.europa.eu/metadata-codelist/SpatialRepresentationTypeCode/<xsl:value-of select="$representation"/></adms:representationTechnique>
                        </xsl:if>
                    </xsl:if>

                </dcatapit:Distribution>

            </xsl:when>

            <xsl:when test="$foutput = $jsonld"> , "dcatapit:Distribution" : { "@id": "<xsl:value-of
                    select="concat($ResourceDistributionURI, $catalogRecordId, '/', $formatURI, '-', position())"/>", "@type": [
                "http://dati.gov.it/onto/dcatapit#Distribution", "http://www.w3.org/ns/dcat#Distribution" ], "dcterms:format": {
                "@id": "<xsl:value-of select="$format"/>" }, "dcat:accessURL": { "@id": "<xsl:value-of
                        select="$accessURL"/>" }, "dcterms:license": { "@id": "<xsl:value-of select="$license"/>"
                } <xsl:if test="$description != ''"> , "dcterms:description": { "@language": "it", "@value":
                    "<xsl:value-of select="$description"/>" }</xsl:if>
                <xsl:if test="$title != ''">, "dcterms:title": "<xsl:call-template name="escapeString"
                ><xsl:with-param name="s" select="$title"/></xsl:call-template>"</xsl:if>
                <xsl:for-each
                        select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage">
                     <xsl:if test="contains(translate(gmd:URL, $uppercase, $lowercase), 'wfs') or contains(translate(gmd:URL, $uppercase, $lowercase), 'zip') or contains(translate(gmd:URL, $uppercase, $lowercase), 'atom') or contains(translate(gmd:URL, $uppercase, $lowercase), 'kml')">, "dcat:downloadURL": { "@id": "<xsl:value-of
                        select="gmd:URL"/>"</xsl:if> <xsl:if test="position() != last()">,</xsl:if>
                    <xsl:if test="position() = last()"> }</xsl:if>
                   
                </xsl:for-each>
               
                <xsl:if test="$profile = $geodcatap_it">
                    <xsl:if test="$conformsToWms != ''">, "dcterms:conformsTo" : { "@id" : "<xsl:value-of
                            select="$conformsToWms"/>" }, "dcterms:description" : { "@language" : "it", "@value" : "Web Map Service (WMS)"}</xsl:if>
                    <xsl:if test="$conformsToWfs != ''">, "dcterms:conformsTo" : { "@id" : "<xsl:value-of
                            select="$conformsToWfs"/>" }, "dcterms:description" : { "@language" : "it", "@value" : "Web Feature Service (WFS)"} </xsl:if>
                    <xsl:if test="$conformsToWms != '' or $conformsToWfs != ''">, "dcterms:type" : { "@id" :
                        "http://publications.europa.eu/resource/authority/distribution-type/WEB_SERVICE"
                         }</xsl:if><xsl:if
                        test="$rights != ''">, "dcterms:rights" : { "@id" : "<xsl:value-of
                        select="concat($ResourceConstraintURI, $catalogRecordId, $id_suffix, '_useConstraints')"
                />" }</xsl:if>, "dcterms:rights" : { "@id" : "<xsl:value-of
                        select="concat($ResourceConstraintURI, $catalogRecordId, $id_suffix, '_accessConstraints')"
                />" } <xsl:if test="$representation != ''">, "adms:representationTechnique" : { "@id" :
                    "http://inspire.ec.europa.eu/metadata-codelist/SpatialRepresentationTypeCode/<xsl:value-of
                            select="$representation"/>" } </xsl:if>
                </xsl:if> } </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- =============
         DATASET
       =============-->

    <xsl:template name="dataset">
        
        <xsl:param name="cardinal" select="position()"/>

        <xsl:param name="catalogRecordId">
            <xsl:value-of select="gmd:fileIdentifier/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="identifier">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="tipologia">
            <xsl:if test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'service'">service</xsl:if>
            <xsl:if test="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'dataset' or gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'series'">dataset</xsl:if>
        </xsl:param>

        <xsl:param name="codeListValue">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue | gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue"/>
        </xsl:param>


        <!-- Valore di accrualPeriodicity -->
        <xsl:param name="accrualOrig">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance/gmd:MD_MaintenanceInformation/gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue"/>
        </xsl:param>
        <xsl:param name="accrualTranslated">
            <xsl:choose>
                <xsl:when test="$accrualOrig = 'continual'">
                    <xsl:text>UPDATE_CONT</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'daily'">
                    <xsl:text>DAILY</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'weekly'">
                    <xsl:text>WEEKLY</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'fortnightly'">
                    <xsl:text>FORTNIGHTLY</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'monthly'">
                    <xsl:text>MONTHLY</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'quarterly'">
                    <xsl:text>QUARTERLY</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'biannually'">
                    <xsl:text>ANNUAL_2</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'annually'">
                    <xsl:text>ANNUAL</xsl:text>
                </xsl:when>
                <xsl:when test="$accrualOrig = 'Irregular'">
                    <xsl:text>IRREG</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>UNKNOWN</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>

        <xsl:param name="title">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="description">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:abstract/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="languageCode">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:language/gmd:LanguageCode[@codeListValue]"/>
        </xsl:param>

        <xsl:param name="modified">
            <xsl:choose>
                <xsl:when test="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='revision'] != '' ">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='revision']/../../gmd:date/gco:Date "/>
                </xsl:when>
                <xsl:when test="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='publication'] != '' ">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='publication']/../../gmd:date/gco:Date "/>
                </xsl:when>
                <xsl:when test="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='creation'] != '' ">
                    <xsl:value-of select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode[@codeListValue='creation']/../../gmd:date/gco:Date "/>
                </xsl:when>
            </xsl:choose>
        </xsl:param>

        <xsl:param name="hierarchy" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>

        <xsl:param name="periodoTemporale">
            <xsl:if
                    test="(gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant | gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod) != ''">
                
                <xsl:value-of select="concat($ResourcePeriodoTemporaleURI, $catalogRecordId)"/>
            </xsl:if>
        </xsl:param>

        <xsl:param name="conformsTo">
            <xsl:if test="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass/gco:Boolean = 'true'">http://data.europa.eu/eli/reg/2010/1089</xsl:if>
        </xsl:param>

        <xsl:param name="conformsTo2">
            <xsl:choose>
                <xsl:when test="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString != ''">
                    <xsl:choose>
                        <xsl:when test="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString != ''">
                            <xsl:value-of select="concat('http://www.opengis.net/def/crs/EPSG/0/', gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="decodificaEPSG">
                        <xsl:with-param name="code"
                                        select="gmd:referenceSystemInfo/gmd:MD_ReferenceSystem/gmd:referenceSystemIdentifier/gmd:RS_Identifier/gmd:code/gco:CharacterString"
                        />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>

        <xsl:param name="issued">
           
            <xsl:for-each
                    select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date">
                <xsl:if test="gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation'">
                    <xsl:value-of select="gmd:date/gco:Date"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:param>

        <xsl:param name="comment">
            <xsl:for-each
                    select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction">
                <xsl:if test="gmd:denominator/gco:Integer != ''">Risoluzione spaziale (scala equivalente): 1:<xsl:value-of select="gmd:denominator/gco:Integer"/></xsl:if>
            </xsl:for-each>
        </xsl:param>

        <xsl:param name="versionInfo">
            <xsl:choose>
                <xsl:when test="gmd:metadataStandardVersion/gco:CharacterString != ''">
                    <xsl:value-of select="gmd:metadataStandardVersion/gco:CharacterString"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>



        <xsl:param name="isPartOf">
            <xsl:value-of select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/*/gmd:series/gmd:issueIdentification/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/*/gmd:series/gmd:issueIdentification/gco:CharacterString"/>
        </xsl:param>

        <xsl:param name="contatore"/>

        
        <xsl:variable name="localizzazione" select="concat($ResourceLocationURI, gmd:fileIdentifier/gco:CharacterString)"/>

        <xsl:variable name="landingPage" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL"/>
        <xsl:variable name="isVersionOf" select="''"/>

        <xsl:variable name="hqm" select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record/gco:Real"/>

        <xsl:variable name="subj" select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory/gmd:MD_TopicCategoryCode"/>


    
        <xsl:variable name="owner"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner']"/>
        <xsl:variable name="author"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='author'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='author']"/>
        <xsl:variable name="editor"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='editor'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='editor']"/>
        <xsl:variable name="originator"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='originator'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='originator']"/>
        <xsl:variable name="paracute"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue"/>

        <xsl:variable name="rightsHolder">
            <xsl:choose>
                <xsl:when test="$owner != ''">
                    <xsl:value-of select="concat($catalogRecordId, '/', 'owner')"/>
                </xsl:when>
                <xsl:when test="$editor != ''">
                    <xsl:value-of select="concat($catalogRecordId, '/', 'editor')"/>
                </xsl:when>
                <xsl:when test="$originator != ''">
                    <xsl:value-of select="concat($catalogRecordId, '/', 'originator')"/>
                </xsl:when>
                <xsl:when test="$author != ''">
                    <xsl:value-of select="concat($catalogRecordId, '/', 'author')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($catalogRecordId, '/', $paracute)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="publisher">
           
            <xsl:choose>
                <xsl:when test="$editor != ''">
                    
                    <xsl:value-of select="concat($catalogRecordId, '/', 'editor')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="creator">
            <xsl:choose>
                <xsl:when test="$originator != ''">
                    
                    <xsl:value-of select="concat($catalogRecordId, '/', 'originator')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="provenance">
            <xsl:value-of
                    select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement/gco:CharacterString"
            />
        </xsl:variable>

        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

     
        <xsl:variable name="formatURI">
            <xsl:choose>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shp') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'shape')">SHP</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'zip')">ZIP</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'pdf')">PDF</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'kml')">KML</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'tif')">TIFF</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpg') or contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'jpeg')">JPEG</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'ecw')">ECW</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'mdb')">MDB</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'csv')">CSV</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'gml')">GML</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'geojson')">GEOJSON</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'grid')">GRID</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'rdf')">RDF</xsl:when>
                <xsl:when test="contains(translate(gmd:distributionInfo/gmd:MD_Distribution/gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString, $uppercase, $lowercase), 'xml')">XML</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('format', '-', position())"/>
                </xsl:otherwise>
               
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$foutput = $rdf">
               

                <dcatapit:Dataset
                        rdf:about="{concat($ResourceDatasetURI, $catalogRecordId)}">

                    <xsl:choose>
                        <xsl:when test="$hierarchy = 'service'">
                            <rdf:type rdf:resource="http://www.w3.org/ns/dcat#Service"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdf:type rdf:resource="http://www.w3.org/ns/dcat#Dataset"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <dct:identifier><xsl:value-of select="$identifier"/></dct:identifier>
                    <dct:title xml:lang="it"><xsl:value-of select="$title"/></dct:title>
                    <dct:description xml:lang="it">
                        <xsl:call-template name="escapeString">
                            <xsl:with-param name="s" select="$description"/>
                        </xsl:call-template>
                    </dct:description>
                    <dct:modified rdf:datatype="http://www.w3.org/2001/XMLSchema#Date"><xsl:value-of select="$modified"/></dct:modified>

                    <xsl:for-each
                            select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords">
                        <xsl:if
                                test="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString = 'GEMET - INSPIRE themes, version 1.0'">
                            <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
                                <xsl:call-template name="keywordSpatial">
                                    <xsl:with-param name="kword" select="gco:CharacterString"/>
                                    <xsl:with-param name="subj" select="$subj"/>
                                </xsl:call-template>
                            </xsl:for-each>
                           
                        </xsl:if>
                    </xsl:for-each>

                    <xsl:variable name="fileIdentifier" select="gmd:fileIdentifier/gco:CharacterString"/>
                    <xsl:variable name="count_owner" select="count($owner)"/>
                    <xsl:variable name="count_author" select="count($author)"/>
                    <xsl:variable name="count_editor" select="count($editor)"/>
                    <xsl:variable name="count_originator" select="count($originator)"/>
                    <xsl:variable name="count_cited" select="count(gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty)"/>

                    <xsl:for-each
                            select="(gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='owner'])[1] | (srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='owner'])[1]">

                        <xsl:call-template name="rightsHolder">

                        </xsl:call-template>

                    </xsl:for-each>
                    <xsl:for-each
                            select="(gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='editor'])[1] | (srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='editor'])[1]">

                        <xsl:if test="$count_owner=0">
                            <xsl:call-template name="rightsHolder"/>
                        </xsl:if>

                        <xsl:call-template name="publisher">

                        </xsl:call-template>

                    </xsl:for-each>

                    <xsl:for-each
                            select="(gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='originator'])[1] | (srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue='originator'])[1]">

                        <xsl:if test="$count_owner=0 and $count_editor=0">
                            <xsl:call-template name="rightsHolder"/>
                        </xsl:if>

                        <xsl:call-template name="creator">

                        </xsl:call-template>

                    </xsl:for-each>

                    <xsl:for-each
                            select="(gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue!='editor' or gmd:role/gmd:CI_RoleCode/@codeListValue!='owner' or gmd:role/gmd:CI_RoleCode/@codeListValue!='originator'])[1] | (srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty[gmd:role/gmd:CI_RoleCode/@codeListValue!='editor' or gmd:role/gmd:CI_RoleCode/@codeListValue!='owner' or gmd:role/gmd:CI_RoleCode/@codeListValue!='originator'])[1]">

                        <xsl:if test="$count_owner=0 and $count_editor=0 and $count_originator = 0">
                            <xsl:call-template name="rightsHolder"/>
                        </xsl:if>

                    </xsl:for-each>

                    <dct:accrualPeriodicity rdf:resource="{concat($EUPublications, $accrualTranslated)}"/>
                    
                    <dcat:distribution rdf:resource="{concat($ResourceDistributionURI, $catalogRecordId, '/', $formatURI, '-', position())}"/>
                   
                    <xsl:for-each
                            select="gmd:identificationInfo/gmd:MD_DataIdentification | gmd:identificationInfo/srv:SV_ServiceIdentification">
                        
                        <dcat:contactPoint rdf:resource="{concat($ResourceContactPointURI, $catalogRecordId, '-', position())}"/>
                    </xsl:for-each>

                   
                    <xsl:if test="$issued != ''">
                        <dct:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#Date"><xsl:value-of select="$issued"/></dct:issued>
                    </xsl:if>
    
                    <xsl:if test="$landingPage != ''">
                        <dcat:landingPage rdf:resource="{$landingPage}"/>
                    </xsl:if>
                    <dct:language rdf:resource="{concat('http://publications.europa.eu/resource/authority/language/', translate($languageCode, $lowercase, $uppercase))}"/>
                    <xsl:for-each
                            select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords">
                        <dcat:keyword><xsl:value-of select="gmd:keyword/gco:CharacterString"/></dcat:keyword>
                    </xsl:for-each>
                   
                    <xsl:if test="$periodoTemporale != ''">
                        
                        <xsl:call-template name="periodOfTime"/>
                    </xsl:if>
                    <xsl:if test="$localizzazione != ''">
                       
                        <dct:spatial>
                            <xsl:call-template name="location"/>
                        </dct:spatial>
                    </xsl:if>
                    <xsl:if test="$conformsTo != ''">
                        <dct:conformsTo rdf:resource="{$conformsTo}"/>
                    </xsl:if>
                    

                    <xsl:if test="$profile = $geodcatap_it">
                        <xsl:if test="$hierarchy = 'dataset' or $hierarchy = 'series'">
                            <dct:type>http://inspire.ec.europa.eu/metadata-codelist/ResourceType/<xsl:value-of select="$hierarchy"/></dct:type>
                            
                        </xsl:if>
                        <xsl:if test="$hierarchy = 'service'">
                            <dct:type rdf:resource="http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType/{gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName}">http://inspire.ec.europa.eu/metadata-codelist/ResourceType/service</dct:type>
                        </xsl:if>
                        <foaf:isPrimaryTopicOf rdf:resource="{concat($ResourceCatalogRecordURI, $catalogRecordId)}"/>
                        <xsl:if test="$isPartOf != ''">
                            <dct:isPartOf>
                                <xsl:value-of select="$isPartOf"/>
                            </dct:isPartOf>
                        </xsl:if>
                        <xsl:for-each
                                select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:presentationForm">
                            <dct:medium rdf:resource="https://registry.geodati.gov.it/metadata-codelist/presentationForm/{gmd:CI_PresentationFormCode/@codeListValue}"/>
                        </xsl:for-each>
                        <xsl:if test="$codeListValue != ''">
                            <xsl:call-template name="characterEncoding">
                                <xsl:with-param name="codeListValue" select="$codeListValue"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:if test="$hqm != ''">
                            <dqv:hasQualityMeasurement rdf:resource="{concat($ResourceDataQualityURI, $catalogRecordId, '-positionalAccuracy')}"/>
                        </xsl:if>
                        <xsl:if test="$comment != ''">
                            <rdfs:comment xml:lang="it"><xsl:value-of select="$comment"/></rdfs:comment>
                        </xsl:if>
                        <xsl:if test="$provenance != ''">
                            <dct:provenance rdf:resource="{concat($ResourceProvenanceURI, $identifier, $id_suffix)}"/>
                        </xsl:if>
                    </xsl:if>

                </dcatapit:Dataset>
            </xsl:when>

            <xsl:when test="$foutput = $jsonld">, "dcatapit:Dataset" : { "@id" : "<xsl:value-of
                    select="concat($ResourceDatasetURI, $catalogRecordId)"/>", "@type" : [
                "dcat:Dataset", "http://dati.gov.it/onto/dcatapit#Dataset" ], "dcterms:identifier" :
                "<xsl:value-of select="$identifier"/>", "dcterms:title" : { "@language" : "it", "@value" :
                "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$title"
                /></xsl:call-template>" }, "dcterms:description" : { "@language" : "it", "@value" :
                "<xsl:call-template name="escapeString"><xsl:with-param name="s" select="$description"
                /></xsl:call-template>" }, "dcterms:modified" : { "@type" : "xsd:date", "@value" :
                "<xsl:value-of select="$modified"/>" }<xsl:for-each
                        select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords">
                    <xsl:if
                            test="gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString = 'GEMET - INSPIRE themes, version 1.0'">
                        <xsl:for-each select="gmd:MD_Keywords/gmd:keyword">
                            <xsl:call-template name="keywordSpatial">
                                <xsl:with-param name="kword" select="gco:CharacterString"/><xsl:with-param
                                    name="subj" select="$subj"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>, "dcterms:rightsHolder" : { "@id" : "<xsl:value-of
                        select="concat($ResourceAgentURI, translate($rightsHolder, ' ', ''))"/>" },
                "dcterms:accrualPeriodicity" : { "@id" : "<xsl:value-of
                        select="concat($EUPublications, $accrualTranslated)"/>" }, "dcat:distribution" : { "@id" :
                "<xsl:value-of
                        select="concat($ResourceDistributionURI, gmd:fileIdentifier/gco:CharacterString, $id_suffix)"
                />" }, "dcat:contactPoint" : { <xsl:for-each
                        select="gmd:identificationInfo/gmd:MD_DataIdentification | gmd:identificationInfo/srv:SV_ServiceIdentification"
                > "@id" : "<xsl:value-of
                        select="concat($ResourceContactPointURI, $catalogRecordId, '-', position())"/>"
                </xsl:for-each> } <xsl:if test="$publisher != ''">, "dcterms:publisher" : { "@id" :
                    "<xsl:value-of select="concat($ResourceAgentURI, translate($publisher, ' ', ''))"/>"
                    }</xsl:if>
                <xsl:if test="$creator != ''">, "dcterms:creator" : { "@id" : "<xsl:value-of
                        select="concat($ResourceAgentURI, translate($creator, ' ', ''))"/>" }</xsl:if><xsl:if
                        test="$issued != ''">, "dcterms:issued": { "@type": "xsd:date", "@value": "<xsl:value-of
                        select="$issued"/>" }</xsl:if>
                <xsl:if test="$landingPage != ''">, "dcat:landingPage": { "@id": "<xsl:value-of
                        select="$landingPage"/>" }</xsl:if>, "dcterms:language": { "@id":
                "http://publications.europa.eu/resource/authority/language/ITA" }, "dcat:keyword" : [
                <xsl:for-each select="gmd:identificationInfo/*/gmd:descriptiveKeywords/gmd:MD_Keywords ">
                    "<xsl:value-of select="gmd:keyword/gco:CharacterString"/>"<xsl:if
                        test="position() != last()">, </xsl:if>
                </xsl:for-each> ] <xsl:if test="$isVersionOf != ''">, "dcterms:isVersionOf": { "@id":
                    "<xsl:value-of select="$isVersionOf"/>" }</xsl:if>
                <xsl:if test="$periodoTemporale != ''">, "dcterms:temporal": { "@id": "<xsl:value-of
                        select="$periodoTemporale"/>" }</xsl:if>
                <xsl:if test="$localizzazione != ''">, "dcterms:spatial" : { "@id" : "<xsl:value-of
                        select="$localizzazione"/>" }</xsl:if>
                <xsl:if test="$conformsTo != ''">, "dcterms:conformsTo": { "@id": "<xsl:value-of
                        select="$conformsTo"/>" }</xsl:if>
                <xsl:if test="$conformsTo2 != ''">, "dcterms:conformsTo": { "@id": "<xsl:value-of
                        select="$conformsTo2"/>" }</xsl:if>
               

                <xsl:if test="$profile = $geodcatap_it">
                    <!-- GEODCAT-AP_IT -->
                    <xsl:if test="$hierarchy = 'dataset' or $hierarchy = 'series'">, "dcterms:type" : { "@id"
                        : "http://inspire.ec.europa.eu/metadata-codelist/ResourceType/<xsl:value-of
                                select="$hierarchy"/>" } </xsl:if>
                    <xsl:if test="$hierarchy = 'service'">, "dcterms:type" : { "@id" :
                        "http://inspire.ec.europa.eu/metadata-codelist/SpatialDataServiceType/<xsl:value-of
                                select="gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:LocalName"
                        />", "@value" : "http://inspire.ec.europa.eu/metadata-codelist/ResourceType/service" }
                    </xsl:if>, "foaf:isPrimaryTopicOf" : { "@id" : "<xsl:value-of
                        select="concat($ResourceCatalogRecordURI, $catalogRecordId, $id_suffix)"/>" } <xsl:if
                        test="$isPartOf != ''">, "dcterms:isPartOf": { "@id" : "<xsl:value-of select="$isPartOf"
                />" }</xsl:if>
                    <xsl:for-each
                            select="gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:presentationForm">,
                        "dcterms:medium" : { "@id" :
                        "http://www.registry-inspire.rndt.gov.it/metadata-codelist/presentationForm/<xsl:value-of
                                select="gmd:CI_PresentationFormCode/@codeListValue"/>" } </xsl:for-each>
                    <xsl:if test="$hqm != ''">, "dqv:hasQualityMeasurement": { "@id" : "<xsl:value-of
                            select="concat($ResourceDataQualityURI, $catalogRecordId, '-positionalAccuracy')"/>"
                        }</xsl:if>
                    <xsl:if test="$codeListValue != ''"><xsl:call-template name="characterEncoding"
                    ><xsl:with-param name="codeListValue" select="$codeListValue"/></xsl:call-template>
                    </xsl:if>
                    <xsl:if test="$comment != ''">, "rdfs:comment" : { "@id" : "<xsl:call-template
                            name="escapeString"><xsl:with-param name="s" select="$comment"/></xsl:call-template>",
                        "@language" : "it" } </xsl:if>
                    <xsl:if test="$provenance != ''">, "dcterms:provenance": { "@id" : "<xsl:value-of
                            select="concat($ResourceProvenanceURI, $identifier, $id_suffix)"/>" }</xsl:if>
                </xsl:if> }</xsl:when>
        </xsl:choose>

    </xsl:template>


    <!-- AGENT -->

    <xsl:template name="agent_old">
        
        <xsl:variable name="fileIdentifier" select="gmd:fileIdentifier/gco:CharacterString"/>

        <xsl:for-each
                select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty">
            <xsl:choose>
                <xsl:when
                        test="gmd:role/gmd:CI_RoleCode/@codeListValue = 'author' or gmd:role/gmd:CI_RoleCode/@codeListValue = 'owner' or gmd:role/gmd:CI_RoleCode/@codeListValue = 'editor' or gmd:role/gmd:CI_RoleCode/@codeListValue = 'originator'">

                    <xsl:call-template name="agentSub">
                        <xsl:with-param name="about"
                                        select="concat($ResourceAgentURI, $fileIdentifier, $id_suffix, gmd:role/gmd:CI_RoleCode/@codeListValue)"/>
                        <xsl:with-param name="identif" select="substring-before($fileIdentifier, ':')"/>
                        <xsl:with-param name="aname" select="gmd:organisationName/gco:CharacterString"/>
                    </xsl:call-template>

                </xsl:when>
            </xsl:choose>
        </xsl:for-each>


        <xsl:variable name="owner"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='owner']"/>
        <xsl:variable name="author"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='author'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='author']"/>
        <xsl:variable name="editor"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='editor'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='editor']"/>
        <xsl:variable name="originator"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='originator'] | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode[@codeListValue='originator']"/>
        <xsl:variable name="paracute"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:role/gmd:CI_RoleCode/@codeListValue"/>


        <xsl:if test="($owner = '') and  ($author = '') and ($editor = '') and ($originator = '')">
            <xsl:call-template name="agentSub">
                <xsl:with-param name="about"
                                select="concat($ResourceAgentURI, $fileIdentifier, $id_suffix, $paracute)"/>
                <xsl:with-param name="identif" select="substring-before($fileIdentifier, ':')"/>
                <xsl:with-param name="aname"
                                select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty/gmd:organisationName/gco:CharacterString"
                />
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <xsl:template name="agent">
        
        <xsl:variable name="fileIdentifier" select="gmd:fileIdentifier/gco:CharacterString"/>

        <xsl:for-each select="gmd:identificationInfo">


            <xsl:for-each
                    select="gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty | srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:citedResponsibleParty/gmd:CI_ResponsibleParty">
               

                <xsl:variable name="owner"
                              select="gmd:role/gmd:CI_RoleCode[@codeListValue='owner']"/>
                <xsl:variable name="author"
                              select="gmd:role/gmd:CI_RoleCode[@codeListValue='author']"/>
                <xsl:variable name="editor"
                              select="gmd:role/gmd:CI_RoleCode[@codeListValue='editor']"/>
                <xsl:variable name="originator"
                              select="gmd:role/gmd:CI_RoleCode[@codeListValue='originator']"/>
                
                <xsl:choose>
                    <xsl:when test="$editor != ''"/>
                    <xsl:when test="$owner != ''">
                        <xsl:call-template name="agentSub">
                            
                            <xsl:with-param name="about" select="concat($ResourceAgentURI, $fileIdentifier, '/', 'owner')"/>
                            <xsl:with-param name="identif" select="substring-before($fileIdentifier, ':')"/>
                            <xsl:with-param name="aname" select="gmd:organisationName/gco:CharacterString"/>
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="$originator != ''"/>
                    <xsl:when test="$author != ''"/>

                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="rightsHolder">
        <xsl:param name="count_owner_p"/>
        <xsl:param name="contatore"><xsl:value-of select="$count_owner_p"/></xsl:param>
        <xsl:variable name="fileIdentifier" select="../../../../../../gmd:fileIdentifier/gco:CharacterString"/>
        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
        <xsl:variable name="orgName">
         <xsl:choose>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE ABRUZZO')">Regione Abruzzo</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE CALABRIA')">Regione Calabria</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE BASILICATA')">Regione Basilicata</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE AUTONOMA VALLE') or starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE VALLE')">Regione Autonoma Valle D'Aosta</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE PIEMONTE')">Regione Piemonte</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE LOMBARDIA')">Regione Lombardia</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE LIGURIA')">Regione Liguria</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE AUTONOMA FRIULI') or starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE FRIULI')">Regione Autonoma Friuli Venezia Giulia</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE VENETO') or starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE DEL VENETO')">Regione del Veneto</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE EMILIA')">Regione Emilia Romagna</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE TOSCANA')">Regione Toscana</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE UMBRIA')">Regione Umbria</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE MOLISE')">Regione Molise</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE LAZIO')">Regione Lazio</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE CAMPANIA')">Regione Campania</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE PUGLIA')">Regione Puglia</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE AUTONOMA DELLA SARDEGNA') or starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE SARDEGNA')">Regione Autonoma della Sardegna</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE SICILIA')">Regione Siciliana</xsl:when>
                        <xsl:when test="starts-with(translate(gmd:organisationName/gco:CharacterString, $lowercase, $uppercase), 'REGIONE MARCHE')">Regione Marche</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="gmd:organisationName/gco:CharacterString"/>
                        </xsl:otherwise>
                    </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="$contatore = $count_owner_p">
            <dct:rightsHolder>
                <xsl:call-template name="agentSub">
                   
                    <xsl:with-param name="about" select="concat($ResourceAgentURI, $fileIdentifier, '/', 'owner')"/>
                    <xsl:with-param name="identif" select="substring-before($fileIdentifier, ':')"/>
                   
                    <xsl:with-param name="aname" select="$orgName"/>
                </xsl:call-template>
            </dct:rightsHolder>

            <xsl:call-template name="rightsHolder">

                <xsl:with-param name="contatore" select="$contatore - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="publisher">
        <xsl:param name="count_owner_p"/>
        <xsl:param name="contatore"><xsl:value-of select="$count_owner_p"/></xsl:param>
        <xsl:variable name="fileIdentifier" select="../../../../../../gmd:fileIdentifier/gco:CharacterString"/>
        <xsl:if test="$contatore = $count_owner_p">
            <dct:publisher>
                <xsl:call-template name="agentSub">
                   
                    <xsl:with-param name="about" select="concat($ResourceAgentURI, $fileIdentifier, '/', 'editor')"/>
                    <xsl:with-param name="identif" select="substring-before($fileIdentifier, ':')"/>
                    <xsl:with-param name="aname" select="gmd:organisationName/gco:CharacterString"/>
                </xsl:call-template>
            </dct:publisher>

            <xsl:call-template name="publisher">

                <xsl:with-param name="contatore" select="$contatore - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="creator">
        <xsl:param name="count_owner_p"/>
        <xsl:param name="contatore"><xsl:value-of select="$count_owner_p"/></xsl:param>
        <xsl:variable name="fileIdentifier" select="../../../../../../gmd:fileIdentifier/gco:CharacterString"/>
        <xsl:if test="$contatore = $count_owner_p">
            <dct:creator>
                <xsl:call-template name="agentSub">
                   
                    <xsl:with-param name="about" select="concat($ResourceAgentURI, $fileIdentifier, '/', 'creator')"/>
                    <xsl:with-param name="identif" select="substring-before($fileIdentifier, ':')"/>
                    <xsl:with-param name="aname" select="gmd:organisationName/gco:CharacterString"/>
                </xsl:call-template>
            </dct:creator>

            <xsl:call-template name="creator">

                <xsl:with-param name="contatore" select="$contatore - 1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="agentSub">
        <xsl:param name="about"/>
        <xsl:param name="identif"/>
        <xsl:param name="aname"/>

        <xsl:if test="$foutput = $rdf">
            <dcatapit:Agent rdf:about="{$about}">
               
                <rdf:type rdf:resource="http://xmlns.com/foaf/0.1/Agent"/>
                <dct:identifier><xsl:value-of select="$identif"/></dct:identifier>
                <foaf:name xml:lang="it"><xsl:value-of select="$aname"/></foaf:name>
            </dcatapit:Agent>
        </xsl:if>

        <xsl:if test="$foutput = $jsonld">, "dcatapit:Agent" : { "@id": "<xsl:value-of select="$about"
        />", "@type": [ "foaf:Agent", "http://dati.gov.it/onto/dcatapit#Agent" ],
            "dcterms:identifier": "<xsl:value-of select="$identif"/>", "foaf:name": { "@language": "it",
            "@value": "<xsl:value-of select="$aname"/>" } }</xsl:if>
    </xsl:template>

    <xsl:template name="periodOfTime">

        <xsl:param name="identificativo">
           
            <xsl:value-of select="concat($ResourcePeriodoTemporaleURI, gmd:fileIdentifier/gco:CharacterString, position())"/>
        </xsl:param>

        <xsl:for-each
                select="gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimeInstant | gmd:identificationInfo/*/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml:TimePeriod ">
            <xsl:if
                    test="local-name(.) = 'TimeInstant' or ( local-name(.) = 'TimePeriod' and gml:beginPosition and gml:endPosition )">
                <xsl:variable name="dateStart">
                    <xsl:choose>
                        <xsl:when test="local-name(.) = 'TimeInstant'">
                            <xsl:value-of select="gml:timePosition"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="gml:beginPosition"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="dateEnd">
                    <xsl:choose>
                        <xsl:when test="local-name(.) = 'TimeInstant'">
                            <xsl:value-of select="gml:timePosition"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="gml:endPosition"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$foutput = $rdf">
                    <dct:temporal>
                        <dct:PeriodOfTime rdf:about="{$identificativo}">
                            <schema:startDate xmlns:schema="http://schema.org/" rdf:datatype="{$xsd}date"><xsl:value-of select="$dateStart"/></schema:startDate>
                            <schema:endDate xmlns:schema="http://schema.org/" rdf:datatype="{$xsd}date"><xsl:value-of select="$dateEnd"/></schema:endDate>
                        </dct:PeriodOfTime>
                    </dct:temporal>
                </xsl:if>
                <xsl:if test="$foutput = $jsonld">, "dcterms:temporal" : { "@id": "<xsl:value-of
                        select="$identificativo"/>", "@type": "dcterms:PeriodOfTime",
                    "http://dati.gov.it/onto/dcatapit#startDate": { "@type": "xsd:date", "@value":
                    "<xsl:value-of select="$dateStart"/>" }<xsl:if test="$dateEnd">,
                        "http://dati.gov.it/onto/dcatapit#endDate": { "@type": "xsd:date", "@value":
                        "<xsl:value-of select="$dateEnd"/>" } </xsl:if> }</xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


    <!-- QUALITY INFO -->

    <xsl:template name="qualityInfo">
        <xsl:variable name="fileIdentifier" select="gmd:fileIdentifier/gco:CharacterString"/>
        <xsl:variable name="qvalue"
                      select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:value/gco:Record/gco:Real"/>
        <xsl:variable name="qunit"
                      select="gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_AbsoluteExternalPositionalAccuracy/gmd:result/gmd:DQ_QuantitativeResult/gmd:valueUnit/gml:BaseUnit/gml:identifier"/>

        <xsl:if test="($qvalue != '') and ($qunit = 'm')">

            <xsl:choose>
                <xsl:when test="$foutput = $rdf">

                    <dqv:QualityMeasurement rdf:about="{concat($ResourceDataQualityURI, $fileIdentifier, '-positionalAccuracy')}">
                        <dqv:isMeasurementOf rdf:resource="http://registry.geodati.gov.it/glossary/positionalAccuracy"/>
                        <dqv:value rdf:datatype="xsd:decimal"><xsl:value-of select="$qvalue"/></dqv:value>
                        <sdmx-attribute:unitMeasure rdf:resource="http://www.wurvoc.org/vocabularies/om-1.8/metre"/>
                    </dqv:QualityMeasurement>

                </xsl:when>

                <xsl:when test="$foutput = $jsonld">, "dqv:QualityMeasurement": { "@id": "<xsl:value-of
                        select="concat($ResourceDataQualityURI, $fileIdentifier, '-positionalAccuracy')"/>",
                    "dqv:isMeasurementOf": { "@id":
                    "http://registry.geodati.gov.it/glossary/positionalAccuracy" }, "dqv:value": [ { "@type":
                    "xsd:decimal", "@value": "<xsl:value-of select="$qvalue"/>" } ],
                    "sdmx-attribute:unitMeasure": { "@id": "http://www.wurvoc.org/vocabularies/om-1.8/metre" }
                    } </xsl:when>
            </xsl:choose>

        </xsl:if>

    </xsl:template>



    <!-- MAPPING per thesaurus -->

    <xsl:template name="keywordDataset">
        <xsl:param name="word"/>
        <xsl:param name="wordLong"/>
        <xsl:if test="$word = 'af' or $word = 'Agriculture, fisheries, forestry and food' or $word = 'Agricoltura, pesca, silvicoltura e prodotti alimentari'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">AGRI</xsl:with-param>
                <xsl:with-param name="wordLong">Agricoltura, pesca, silvicoltura e prodotti alimentari</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$word = 'Education, culture and sport' or $word = 'Istruzione, cultura e sport'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">EDUC</xsl:with-param>
                <xsl:with-param name="wordLong">Istruzione, cultura e sport</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'mf' or $word = 'sd' or $word = 'so' or $word = 'sr' or $word = 'of' or $word = 'nz' or $word = 'mr' or $word = 'lu' or $word = 'hb' or $word = 'ef' or $word = 'am' or $word = 'ac' or $word = 'br' or $word = 'lc' or $word = 'ps' or $word = 'hy' or $word = 'Environment' or $word = 'Ambiente'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">ENVI</xsl:with-param>
                <xsl:with-param name="wordLong">Ambiente</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$word = 'mr' or $word = 'er' or $word = 'Energy' or $word = 'Energia'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">ENER</xsl:with-param>
                <xsl:with-param name="wordLong">Energia</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$word = 'tn' or $word = 'Transport' or $word = 'Trasporti'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">TRAN</xsl:with-param>
                <xsl:with-param name="wordLong">Trasporti</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'mf' or $word = 'oi' or $word = 'ge' or $word = 'hy' or $word = 'cp' or $word = 'Science and technology' or $word = 'Scienza e tecnologia'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">TECH</xsl:with-param>
                <xsl:with-param name="wordLong">Scienza e tecnologia</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'pf' or $word = 'mr' or $word = 'lu' or $word = 'Economy and finance' or $word = 'Economia e finanze'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">ECON</xsl:with-param>
                <xsl:with-param name="wordLong">Economia e finanze</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'su' or $word = 'pd' or $word = 'Population and society' or $word = 'Popolazione e società'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">SOCI</xsl:with-param>
                <xsl:with-param name="wordLong">Popolazione e società</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$word = 'hh' or $word = 'Health' or $word = 'Salute'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">HEAL</xsl:with-param>
                <xsl:with-param name="wordLong">Salute</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'us' or $word = 'au' or $word = 'Government and public sector' or $word = 'Governo e settore pubblico'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">GOVE</xsl:with-param>
                <xsl:with-param name="wordLong">Governo e settore pubblico</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'bu' or $word = 'oi' or $word = 'ge' or $word = 'el' or $word = 'ad' or $word = 'rs' or $word='gg' or $word = 'cp' or $word = 'gn' or $word ='Regions and cities' or $word = 'Regioni e città'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">REGI</xsl:with-param>
                <xsl:with-param name="wordLong">Regioni e città</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if
                test="$word = 'Justice, legal system and public safety' or $word = 'Giustizia, sistema giuridico e sicurezza pubblica'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">JUST</xsl:with-param>
                <xsl:with-param name="wordLong">Giustizia, sistema giuridico e sicurezza pubblica</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="$word = 'International issues' or $word = 'Tematiche internazionali'">
            <xsl:call-template name="keywordTheme">
                <xsl:with-param name="word">INTR</xsl:with-param>
                <xsl:with-param name="wordLong">Tematiche internazionali</xsl:with-param>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- MAPPING per subject -->
    <xsl:template name="keywordSpatial">
        <xsl:param name="kword"/>
        <xsl:param name="subj"/>
        <xsl:choose>
            <xsl:when test="$kword = 'Condizioni atmosferiche' or $kword = 'Atmospheric conditions'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">ac</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Copertura del suolo' or $kword = 'Land cover'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">lc</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Distribuzione della popolazione — demografia' or $kword = 'Distribuzione della popolazione _ demografia' or $kword ='Population distribution - demography' or $kword ='Distribuzione della popolazione - demografia' or $kword = 'Population distribution — demography'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">pd</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Distribuzione delle specie' or $kword = 'Species distribution'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">sd</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Edifici' or $kword = 'Buildings'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">bu</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Elementi geografici meteorologici' or $kword = 'Meteorological geographical features'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">mf</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Elementi geografici oceanografici' or $kword = 'Oceanographic geographical features'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">of</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Elevazione' or $kword = 'Elevation'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">el</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Geologia' or $kword = 'Geology'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">ge</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Habitat e biotopi' or $kword = 'Habitats and biotopes'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">hb</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Idrografia' or $kword = 'Hydrography'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">hy</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Impianti agricoli e di acquacoltura' or $kword = 'Agricultural and aquaculture facilities'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">af</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Impianti di monitoraggio ambientale' or $kword = 'Environmental monitoring facilities'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">ef</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Indirizzi' or $kword = 'Addresses'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">ad</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Nomi geografici' or $kword = 'Geographical names'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">gn</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Orto immagini' or $kword = 'Orthoimagery'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">oi</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Parcelle catastali' or $kword = 'Cadastral parcels'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">cp</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Produzione e impianti industriali' or $kword = 'Production and industrial facilities'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">pf</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Regioni biogeografiche' or $kword = 'Bio-geographical regions'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">br</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Regioni marine' or $kword = 'Sea regions'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">sr</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Reti di trasporto' or $kword = 'Transport networks'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">tn</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Risorse energetiche' or $kword = 'Energy resources'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">er</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Risorse minerarie' or $kword = 'Mineral resources'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">mr</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Salute umana e sicurezza' or $kword = 'Human health and safety'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">hh</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Servizi di pubblica utilità e servizi amministrativi' or $kword = 'Utility and governmental services'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">us</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Sistemi di coordinate' or $kword = 'Coordinate reference systems'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">rs</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Sistemi di griglie geografiche' or $kword = 'Geographical grid systems'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">gg</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Siti protetti' or $kword = 'Protected sites'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">ps</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Suolo' or $kword = 'Soil'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">so</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Unità amministrative' or $kword = 'Administrative units'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">au</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Unità statistiche' or $kword = 'Statistical units'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">su</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Utilizzo del territorio' or $kword = 'Land use'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">lu</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$kword = 'Zone a rischio naturale' or $kword = 'Natural risk zones'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">nz</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when
                    test="$kword = 'Zone sottoposte a gestione/limitazioni/regolamentazione e unità con obbligo di comunicare dati' or $kword = 'Area management/restriction/regulation zones and reporting units'">
                <xsl:call-template name="keywordSubject">
                    <xsl:with-param name="subj" select="$subj"/>
                    <xsl:with-param name="word">am</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
     
        </xsl:choose>
    </xsl:template>

    <!-- subject -->

    <xsl:template name="keywordSubject">
        <xsl:param name="subj"/>
        <xsl:param name="word"/>
        <xsl:choose>
            <xsl:when test="$foutput = $rdf">
                <dct:subject rdf:resource="{concat('http://inspire.ec.europa.eu/theme/', $word)}"/>
                <dct:subject
                        rdf:resource="{concat('http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/', $subj)}"
                />
            </xsl:when>
            <xsl:when test="$foutput = $jsonld">, "dcterms:subject" : { "@id" :
                "http://inspire.ec.europa.eu/theme/<xsl:value-of select="$word"/>"<xsl:if test="$subj">,
                    "@id" : "http://inspire.ec.europa.eu/metadata-codelist/TopicCategory/<xsl:value-of
                            select="$subj"/>"</xsl:if> }</xsl:when>
        </xsl:choose>
        <xsl:call-template name="keywordDataset">
            <xsl:with-param name="word" select="$word"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="keywordTheme">
        <xsl:param name="word"/>
        <xsl:param name="wordLong"/>
        <xsl:choose>
            <xsl:when test="$foutput = $rdf">
                <dcat:theme
                        rdf:resource="{concat('http://publications.europa.eu/resource/authority/data-theme/', $word)}"
                />
            </xsl:when>
            <xsl:when test="$foutput = $jsonld">, "dcat:theme" : { "@id" :
                "http://publications.europa.eu/resource/authority/data-theme/<xsl:value-of select="$word"
                />", "@type" : "skos:Concept", "skos:prefLabel" : { "@language" : "it", "@value" :
                "<xsl:value-of select="$wordLong"/>" } }</xsl:when>
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
            <cnt:characterEncoding xmlns:cnt="http://www.w3.org/2011/content#"
                                   rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                <xsl:value-of select="$CharSetCode"/>
            </cnt:characterEncoding>
        </xsl:if>
        <xsl:if test="$foutput = $jsonld">, "cnt:characterEncoding" : { "@type" : "xsd:string", "@id" :
            "<xsl:value-of select="$CharSetCode"/>" }</xsl:if>
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
            <xsl:otherwise>http://www.opengis.net/def/crs/EPSG/0/CRS_SCONOSCIUTO: <xsl:value-of
                    select="$code"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!-- Constraints related to access and use -->
    <xsl:template name="licenza">
        
        <xsl:variable name="catalogRecordId" select="gmd:fileIdentifier/gco:CharacterString"/>

        <xsl:variable name="useLimitation_str"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString"/>

        <xsl:variable name="useLimitation_lnk"
                      select="gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gmx:Anchor/@xlink:href | gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gmx:Anchor/@xlink:href"/>

        <xsl:variable name="licenseName">
            <xsl:choose>
                <xsl:when test="$useLimitation_str">
                    <xsl:value-of select="$useLimitation_str"/>
                </xsl:when>
                <xsl:when test="$useLimitation_lnk">
                    <xsl:value-of select="$useLimitation_lnk"/>
                </xsl:when>
                
                <xsl:otherwise>licenza non specificata</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:if test="$foutput = $rdf">

            
            <xsl:choose>
                <xsl:when test="$useLimitation_lnk">
                    <dcatapit:LicenseDocument rdf:about="{$useLimitation_lnk}">
                        <rdf:type rdf:resource="dct:LicenseDocument"/>
                        <xsl:if test="contains($useLimitation_str, 'CC-BY') or contains($useLimitation_str, 'CCBY') or contains($useLimitation_str, 'BY SA') or contains($useLimitation_str, 'IODL') or contains($useLimitation_str, 'Creative Commons BY') or contains($useLimitation_str, 'CC BY')">
                            
                            <dct:type rdf:resource="http://purl.org/adms/licencetype/Attribution"/>
                        </xsl:if>
                       
                        <foaf:name>
                            <xsl:call-template name="escapeString">
                                <xsl:with-param name="s" select="$licenseName"/>
                            </xsl:call-template>
                        </foaf:name>
                    </dcatapit:LicenseDocument>
                </xsl:when>
                <xsl:otherwise>
                    <dcatapit:LicenseDocument rdf:about="{concat($ResourceLicenseURI, $catalogRecordId)}">
                        <rdf:type rdf:resource="dct:LicenseDocument"/>
                        <xsl:choose>
                            <xsl:when test="contains($useLimitation_str, 'CC-BY') or contains($useLimitation_str, 'CCBY') or contains($useLimitation_str, 'BY SA') or contains($useLimitation_str, 'IODL') or contains($useLimitation_str, 'Creative Commons BY') or contains($useLimitation_str, 'CC BY')">
                                
                                <dct:type rdf:resource="http://purl.org/adms/licencetype/Attribution"/>

                               
                                <foaf:name>
                                    <xsl:call-template name="escapeString">
                                        <xsl:with-param name="s" select="$licenseName"/>
                                    </xsl:call-template>
                                </foaf:name>
                            </xsl:when>
                            <xsl:when test="contains($useLimitation_str, 'cita')">
                                <dct:type rdf:resource="http://purl.org/adms/licencetype/Attribution"/>
                                
                                <rdfs:label xml:lang="it">
                                    <xsl:call-template name="escapeString">
                                        <xsl:with-param name="s" select="$licenseName"/>
                                    </xsl:call-template>
                                </rdfs:label>
                            </xsl:when>
                            <xsl:otherwise>
                                <dct:type rdf:resource="http://purl.org/adms/licencetype/OtherRestrictiveClauses"/>
                                <rdfs:label xml:lang="it">
                                    <xsl:call-template name="escapeString">
                                        <xsl:with-param name="s" select="$licenseName"/>
                                    </xsl:call-template>
                                </rdfs:label>
                            </xsl:otherwise>
                        </xsl:choose>
                    </dcatapit:LicenseDocument>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$foutput = $jsonld"><xsl:choose>
            <xsl:when test="$useLimitation_lnk">, "dcatapit:LicenseDocument" : { "@id": "<xsl:value-of
                    select="$useLimitation_lnk"/>"
                , "@type": [
                "http://dati.gov.it/onto/dcatapit#LicenseDocument", "dcterms:LicenseDocument" ], <xsl:if test="contains($useLimitation_str, 'CC-BY') or contains($useLimitation_str, 'CCBY') or contains($useLimitation_str, 'BY SA') or contains($useLimitation_str, 'IODL') or contains($useLimitation_str, 'Creative Commons BY') or contains($useLimitation_str, 'CC BY')">"dcterms:type": {
                    "@id": "http://purl.org/adms/licensetype/Attribution"
                    },</xsl:if>
                "foaf:name": "<xsl:call-template name="escapeString"><xsl:with-param name="s"
                                                                                     select="$licenseName"/></xsl:call-template>" }</xsl:when>
            <xsl:otherwise>, "dcatapit:LicenseDocument" : { "@id": "<xsl:value-of
                    select="concat($ResourceLicenseURI, $catalogRecordId)"/>"
        		, "@type": [
                "http://dati.gov.it/onto/dcatapit#LicenseDocument", "dcterms:LicenseDocument" ], <xsl:choose>
                    <xsl:when test="contains($useLimitation_str, 'CC-BY') or contains($useLimitation_str, 'CCBY') or contains($useLimitation_str, 'BY SA') or contains($useLimitation_str, 'IODL') or contains($useLimitation_str, 'Creative Commons BY') or contains($useLimitation_str, 'CC BY')">"dcterms:type": {
                        "@id": "http://purl.org/adms/licensetype/Attribution"
                        },
                        "foaf:name": "<xsl:call-template name="escapeString"><xsl:with-param name="s"
                                                                                             select="$licenseName"/></xsl:call-template>"</xsl:when><xsl:otherwise>"rdfs:label": {"@language" : "it", "@value" : "<xsl:call-template name="escapeString"><xsl:with-param name="s"
                                                                                                                                                                                                                                                                         select="$licenseName"/></xsl:call-template>"</xsl:otherwise></xsl:choose>} }</xsl:otherwise></xsl:choose></xsl:if>


    </xsl:template>


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
                <xsl:call-template name="removeBreaks">
                    <xsl:with-param name="s" select="concat($encoded, $s)"/>
                </xsl:call-template>


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
                    <xsl:with-param name="encoded" select="concat($encoded,substring-before($s,'&#xA;'),' ')"
                    />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="removeCR">
                    <xsl:with-param name="s" select="concat($encoded, $s)"/>
                </xsl:call-template>

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
                    <xsl:with-param name="encoded" select="concat($encoded,substring-before($s,'&#13;'),'')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($encoded, $s)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:transform>
