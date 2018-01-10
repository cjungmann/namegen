<?xml version="1.0" encoding="utf-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output
      method="xml"
      version="1.0"
      indent="yes"
      omit-xml-declaration="yes"
      encoding="utf-8"/>

  <xsl:variable name="popdoc" select="document('pop_names.xml')" />
  <xsl:variable name="names_boy" select="$popdoc/names/boys" />
  <xsl:variable name="names_girl" select="$popdoc/names/girls" />
  <xsl:variable name="names_last" select="$popdoc/names/lnames" />

  <xsl:template match="/">
    <people>
      <schema>
        <field name="gender" />
        <field name="fname" />
        <field name="lname" />
      </schema>
      <xsl:apply-templates select="$popdoc/names" mode="show_limits" />
      <xsl:apply-templates select="*" />
    </people>
  </xsl:template>

  <xsl:template match="names" mode="show_limits">
    <xsl:element name="limits">
      <xsl:apply-templates select="*" mode="add_limit_attrib" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@instances]" mode="add_limit_attrib">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="@instances" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="person">
    <xsl:element name="person">
      <xsl:attribute name="gender"><xsl:value-of select="@gender" /></xsl:attribute>
      <xsl:apply-templates select="." mode="add_fname" />
      <xsl:apply-templates select="." mode="add_lname" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="person[@gender='m']" mode="add_fname">
    <xsl:variable name="nameno" select="@nameno" />
    <xsl:variable name="name" select="$names_boy/name[not(@bottom &lt; $nameno)][1]" />

    <xsl:attribute name="fname">
      <xsl:value-of select="$name" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="person[@gender='f']" mode="add_fname">
    <xsl:variable name="nameno" select="@nameno" />
    <xsl:variable name="name" select="$names_girl/name[not(@bottom &lt; $nameno)][1]" />

    <xsl:attribute name="fname">
      <xsl:value-of select="$name" />
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="person" mode="add_lname">
    <xsl:variable name="nameno" select="@lnameno" />
    <xsl:variable name="name" select="$names_last/name[not(@bottom &lt; $nameno)][1]" />

    <xsl:attribute name="lname">
      <xsl:value-of select="$name" />
    </xsl:attribute>
  </xsl:template>

</xsl:stylesheet>
