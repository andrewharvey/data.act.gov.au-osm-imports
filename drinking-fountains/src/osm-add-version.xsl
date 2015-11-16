<?xml version="1.0" encoding="UTF-8"?>
<!--
  This XSL stylesheet takes a .osm file and adds/replaces object ids with fresh
  negative sequential IDs. It is very rough as it was designed as a hack for 
  the xml2osm.xsl from this same directory, hence it should only be used for
  files produced from that.
  
  xsltproc is one such program which can apply this XSL.
  xsltproc osm-add-ids.xsl - < input.osm > output.osm
  
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

  <xsl:template match="/osm">
    <osm version="{@version}">
      <xsl:apply-templates select="node"/>
    </osm>
  </xsl:template>

  <xsl:template match="node">
    <node id="{@id}" lat="{@lat}" lon="{@lon}" visible="{@visible}" version="1">
      <xsl:copy-of select="tag"/>
    </node>
  </xsl:template>
</xsl:stylesheet>
