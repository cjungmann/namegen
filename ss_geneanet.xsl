<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output
      method="xml"
      version="1.0"
      indent="yes"
      omit-xml-declaration="yes"
      encoding="utf-8"/>

  <xsl:template match="/">
    <lnames namelist="true">
    <xsl:apply-templates select="//table[@style]" />
    </lnames>
  </xsl:template>

  <xsl:template match="table">
      <xsl:apply-templates select="tr[position() &gt; 1]" />
  </xsl:template>

  <xsl:template match="tr">
    <xsl:variable name="freq" select="translate(td[2],' ','')" />
    <xsl:element name="nom">
      <xsl:attribute name="freq">
        <xsl:value-of select="floor(($freq) div 1000)" />
      </xsl:attribute>
      <xsl:value-of select="normalize-space(td[1])" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
