<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
<xsl:output indent="yes"/><xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
<!-- #20180816-->
<!-- Row of Drug-->
<xsl:template name="drugRow">
  <tr onclick="drug_click(this);">
    <td width="80%"><xsl:value-of select="name"/> (<xsl:value-of select="suplement"/>)</td>
    <td width="19%"><xsl:value-of select="code"/></td>
  </tr>
</xsl:template>
<!-- end of Row of Drug-->

<!-- List of Drugs-->
<xsl:template match="drugs">
  <div class="autosuggest" style="display: none"  id="drugs" onmouseover="drugs_mouse_over()" onmouseout="drugs_mouse_out()">
    <table border="0" cellpadding="1" cellspacing="0" rules="rows">
      <xsl:for-each select="drug">
        <xsl:call-template name="drugRow"/>
      </xsl:for-each>
    </table>
  </div>
</xsl:template>
<!-- end of List of drugs-->
</xsl:stylesheet>

