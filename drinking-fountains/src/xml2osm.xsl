<?xml version="1.0" encoding="UTF-8"?>
<!--
  This XSL stylesheet takes an XML document of Drinking Fountain locations from
  https://www.data.act.gov.au/Infrastructure-and-Utilities/Drinking-Fountains/8eg4-uskm
  and produces an OSM XML file of the same data.
  
  xsltproc is one such program which can apply this XSL to produce the OSM file.
  xsltproc xml2osm.xsl - < input.xml > output.osm
  
  This document is licensed CC0 by Andrew Harvey.
  
  To the extent possible under law, the person who associated CC0
  with this work has waived all copyright and related or neighboring
  rights to this work.
  http://creativecommons.org/publicdomain/zero/1.0/
-->
<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/response">
    <osm version="0.6">
        <xsl:apply-templates select="row/row"/>
    </osm>
  </xsl:template>

  <xsl:template match="row/row">
    <node lat="{latitude}" lon="{longitude}" visible="true" version="1">
      <tag k="amenity" v="drinking_water"/>
      <tag k="source:ref" v="https://www.data.act.gov.au/Infrastructure-and-Utilities/Drinking-Fountains/8eg4-uskm"/>
      <tag k="attribution" v="Territory and Municipal Services"/>
    </node>
  </xsl:template>
</xsl:stylesheet>
