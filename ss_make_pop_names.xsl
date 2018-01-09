<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
      method="xml"
      version="1.0"
      indent="yes"
      omit-xml-declaration="yes"
      encoding="utf-8"/>

  <xsl:variable name="lnames" select="//*[local-name()='lnames'][@namelist]" />
  <xsl:variable name="gnames" select="//*[local-name()='girls'][@namelist]" />
  <xsl:variable name="bnames" select="//*[local-name()='boys'][@namelist]" />
  <xsl:variable name="lname_total" select="sum($lnames/*/@freq)" />
  <xsl:variable name="gname_total" select="sum($gnames/*/@freq)" />
  <xsl:variable name="bname_total" select="sum($bnames/*/@freq)" />

  <xsl:key name="nlist" match="//*[@namelist]" use="local-name()" />

  <xsl:template match="/">
    <names>
      <xsl:apply-templates select="*" />
    </names>
  </xsl:template>

  <xsl:template match="lists">

    <!-- <xsl:call-template name="show_counts" /> -->

    <xsl:apply-templates select="//*[@namelist]" />
    
  </xsl:template>

  <!-- This template uses a key to process together each set of same-named namelists. -->
  <xsl:template match="*[@namelist]">
    <xsl:variable name="keyel" select="key('nlist', local-name())" />

    <xsl:if test="generate-id() = generate-id($keyel)">
      <xsl:variable name="ncount" select="count($keyel/*)" />
      <xsl:variable name="instances" select="sum($keyel/*/@freq)" />
      <xsl:variable name="elname" select="local-name()" />

      <!-- This element encloses together the individual names from all same-named lists. -->
      <xsl:element name="{$elname}">
        <xsl:attribute name="count"><xsl:value-of select="$ncount" /></xsl:attribute>
        <xsl:attribute name="instances"><xsl:value-of select="$instances" /></xsl:attribute>
        <xsl:apply-templates select="." mode="process_list" />
      </xsl:element>

    </xsl:if>
    
  </xsl:template>

  <!-- Recursive template to carry instance accumulations between lists in a namelist group. -->
  <xsl:template match="*[@namelist]" mode="process_list">
    <xsl:param name="precount" select="0" />
    <xsl:variable name="cname" select="local-name()" />
    <xsl:variable name="instances" select="sum(*/@freq)" />

    <!-- <xsl:element name="sub"> -->
    <!--   <xsl:attribute name="starting"><xsl:value-of select="$precount" /></xsl:attribute> -->
    <!--   <xsl:attribute name="count"><xsl:value-of select="count(*)" /></xsl:attribute> -->
    <!--   <xsl:attribute name="inst"><xsl:value-of select="$inst" /></xsl:attribute> -->

    <!--   <xsl:apply-templates select="*[1]" mode="process_names"> -->
    <!--     <xsl:with-param name="precount" select="$precount" /> -->
    <!--   </xsl:apply-templates> -->
      
    <!-- </xsl:element> -->

    <xsl:apply-templates select="*[1]" mode="process_names">
      <xsl:with-param name="start" select="$precount" />
    </xsl:apply-templates>
    
    <!-- recurse: -->
    <xsl:apply-templates select="./following-sibling::*[local-name()=$cname][1]" mode="process_list">
      <xsl:with-param name="precount" select="($precount) + ($instances)" />
    </xsl:apply-templates>

  </xsl:template>


  <!-- Recursively process each name in the list. -->
  <xsl:template match="*" mode="process_names">
    <xsl:param name="start" />

    <xsl:variable name="bottom" select="($start)+(@freq)" />

    <xsl:element name="name">
      <xsl:attribute name="bottom"><xsl:value-of select="$bottom" /></xsl:attribute>
      <xsl:attribute name="freq"><xsl:value-of select="@freq" /></xsl:attribute>
      <xsl:value-of select="." />
    </xsl:element>

    <!-- recurse: -->
    <xsl:apply-templates select="following-sibling::*[1]" mode="process_names">
      <xsl:with-param name="start" select="$bottom" />
    </xsl:apply-templates>

  </xsl:template>






  <xsl:template name="show_counts">
    <xsl:element name="counts">
      <xsl:attribute name="lnames"><xsl:value-of select="count($lnames/*)" /></xsl:attribute>
      <xsl:attribute name="gnames"><xsl:value-of select="count($gnames/*)" /></xsl:attribute>
      <xsl:attribute name="bnames"><xsl:value-of select="count($bnames/*)" /></xsl:attribute>
    </xsl:element>

    <xsl:element name="instances">
      <xsl:attribute name="lasts"><xsl:value-of select="$lname_total" /></xsl:attribute>
      <xsl:attribute name="girls"><xsl:value-of select="$gname_total" /></xsl:attribute>
      <xsl:attribute name="boys"><xsl:value-of select="$bname_total" /></xsl:attribute>
    </xsl:element>
  </xsl:template>

  

</xsl:stylesheet>
