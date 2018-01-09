<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml">

  <xsl:output
      method="xml"
      omit-xml-declaration="yes"
      version="1.0"
      indent="yes"
      encoding="utf-8"/>

  <xsl:template match="/">
    <xsl:apply-templates select="html//table" />
  </xsl:template>

  <xsl:template match="table">
    <xsl:variable name="col_girls">
      <xsl:apply-templates select="tr[1]" mode="get_column">
        <xsl:with-param name="group" select="'Girl'" />
      </xsl:apply-templates>
    </xsl:variable>

    <xsl:variable name="col_boys">
      <xsl:apply-templates select="tr[1]" mode="get_column">
        <xsl:with-param name="group" select="'Boy'" />
      </xsl:apply-templates>
    </xsl:variable>

    <fnames>
      <xsl:if test="$col_girls &gt; 0">
        <girls namelist="true">
          <xsl:apply-templates select="tr[position()&gt;1]">
            <xsl:with-param name="namecol" select="$col_girls" />
          </xsl:apply-templates>
        </girls>
      </xsl:if>

      <xsl:if test="$col_boys &gt; 0">
        <boys namelist="true">
          <xsl:apply-templates select="tr[position()&gt;1]">
            <xsl:with-param name="namecol" select="$col_boys" />
          </xsl:apply-templates>
        </boys>
      </xsl:if>
    </fnames>

  </xsl:template>

  <xsl:template match="tr" mode="get_column">
    <xsl:param name="group" />
    <xsl:variable name="col" select="td[starts-with(., $group)]" />

    <xsl:choose>
      <xsl:when test="$col">
        <xsl:value-of select="count($col/preceding-sibling::td)+1" />
      </xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tr">
    <xsl:param name="namecol" />
    <xsl:variable name="freqcol" select="$namecol+1" />
    <xsl:element name="nom">
      <xsl:attribute name="freq"><xsl:value-of select="td[position()=$freqcol]" /></xsl:attribute>
      <xsl:value-of select="td[position()=$namecol]" />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
