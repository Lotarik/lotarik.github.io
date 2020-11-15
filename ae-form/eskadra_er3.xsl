<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs">
<xsl:output indent="yes"/><xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"/>
<!-- #20191003-->

<xsl:variable name="space" select="' '" />
<xsl:variable name="edit" select="//@edit" />
<xsl:variable name="advanced" select="number(//@advanced)*1" />

<xsl:variable name="mandatoryItem">
	<xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_error_mandatory'"/></xsl:call-template>
</xsl:variable>

<xsl:variable name="errorItem">
	<xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_error_element'"/></xsl:call-template>
</xsl:variable>

<xsl:variable name="errorHeader">
	<xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_error_header'"/></xsl:call-template>
</xsl:variable>

<xsl:template name="label">
	<xsl:param name="name"/>  
  <xsl:param name="block" select="'weber3'"/>
  <xsl:variable name="caption" select="/eskadra/dictionary/*[name()=$block]/item[@code=$name]/@value"/>
  <xsl:if test="string-length($caption)=0">
    [<xsl:value-of select="$name"/>]
  </xsl:if>
  <xsl:value-of select="$caption" />
  <xsl:if test="@mandatory=1"><span class="error" title="{$mandatoryItem}">*</span></xsl:if>
  <xsl:if test="@error=1"><div class="right"><span class="error" title="{$errorItem}">!</span></div></xsl:if>
</xsl:template>

<xsl:template name="multiplyIcon">
  <xsl:if test="not($edit=0)">
    <xsl:variable name="current_name" select="name()"/>
      <a class="addButton" id="addnew" name="Add" value="Add" href="#" onclick="xmlPage.addNew('{@id}');return false;"><img src="plus.gif"/></a>
    <xsl:if test="count(../*[name() = $current_name]) &gt; 1">
      <a class="remButton" id="removeitem" name="Remove" value="Remove" href="#;" onclick="xmlPage.removeItem('{@id}');return false;"><img src="delete.gif"/></a>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template name="multiplyText">
  <xsl:if test="not($edit=0)">
    <xsl:variable name="current_name" select="name()"/>
    <xsl:value-of select="concat($space,'(')"/>
    <a class="addButton" id="addnew" name="Add" value="Add" href="#" onclick="xmlPage.addNew('{@id}');return false;">
      <xsl:call-template name="label"><xsl:with-param name="name" select="concat('xmlform_add_',$current_name)"/></xsl:call-template></a>
    <xsl:if test="count(../*[name() = $current_name]) &gt; 1">
      <spam> - </spam>
      <a class="remButton" id="removeitem" name="Remove" value="Remove" href="#;" onclick="xmlPage.removeItem('{@id}');return false;">
        <xsl:call-template name="label"><xsl:with-param name="name" select="concat('xmlform_delete_',$current_name)"/></xsl:call-template></a>
    </xsl:if>
    <xsl:value-of select="')'"/>
  </xsl:if>
</xsl:template>

<xsl:template name="blockHeader">
  <xsl:param name="label"/>
  <xsl:variable name="current_name" select="name()"/>
  <div class="headerBlock">
    <div class="left"><xsl:call-template name="label"><xsl:with-param name="name" select="$label"/></xsl:call-template></div>
      <xsl:if test="not($edit=0) and (@multiply=1) and (count(../*[name() = $current_name]) &gt; 1)">
        <div class="left">
          <xsl:value-of select="concat($space,'(')"/>
          <a class="remButton" id="removeitem" name="Remove" value="Remove" href="#;" onclick="xmlPage.removeItem('{@id}');return false;">
            <xsl:call-template name="label"><xsl:with-param name="name" select="concat('xmlform_delete_',$current_name)"/></xsl:call-template>
          </a>
          <xsl:value-of select="')'"/>
        </div>
      </xsl:if>
   <div class="left"><xsl:if test="*/@error=1"><span class="error"> - <xsl:value-of select="$errorHeader"/></span></xsl:if></div>
  <div class="clear"></div>
  </div>
</xsl:template>

<xsl:template name="blockFooter">
  <xsl:param name="label"/>
  <xsl:variable name="current_name" select="name()"/>
  <xsl:if test="not($edit=0) and (@multiply=1)">
    <div class="headerBlock">
      <!-- <div class="right"><xsl:call-template name="label"><xsl:with-param name="name" select="$label"/></xsl:call-template></div> -->
      <div class="right">
        <xsl:value-of select="concat($space,'(')"/>
        <a class="addButton" id="addnew" name="Add" value="Add" href="#" onclick="xmlPage.addNew('{@id}');return false;">
        <xsl:call-template name="label"><xsl:with-param name="name" select="concat('xmlform_add_',$current_name)"/></xsl:call-template>
        </a>
        <xsl:value-of select="')'"/>
      </div><div class="clear"></div>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template name="inputText">
  <xsl:param name="id"/>
  <xsl:param name="value"/>
  <xsl:param name="length"/>
  <xsl:param name="class"/>
  <xsl:param name="format" select="''"/>
  <input type="text" class="{$class}" id="{$id}" name="{$id}" value="{$value}" maxlength="{$length}"
    onchange="xmlPage.modifyItem('{$id}');" 
    onblur="xmlPage.lostFocus(event,'{$id}');">
    <xsl:attribute name="placeholder"><xsl:value-of select="$format" /></xsl:attribute>
  </input>
</xsl:template>

<xsl:template name="rowInputText">
	<xsl:param name="length"/>
	<xsl:param name="class" select="''"/>
	<xsl:param name="format" select="''"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
			<td class="fLabel">
				<xsl:attribute name="title">
<xsl:value-of select="name()" />
</xsl:attribute>
				<xsl:call-template name="label">
<xsl:with-param name="name" select="name()"/>
</xsl:call-template>
			</td>
			<td>
        <xsl:call-template name="inputText">
          <xsl:with-param name="id" select="@id"/>
          <xsl:with-param name="length" select="$length"/>
          <xsl:with-param name="value" select="text()"/>
          <xsl:with-param name="class" select="$class"/>
          <xsl:with-param name="format" select="$format"/>
        </xsl:call-template>
			</td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="inputCountry">
	<xsl:param name="id"/>
	<xsl:param name="value"/>
	<xsl:param name="class" select="'country'"/>
  <input type="text" class="{$class}" id="{$id}" name="{$id}" value="{$value}" iscountry="1"
    onchange="xmlPage.modifyItem('{$id}');" 
    onblur="xmlPage.lostFocus(event,'{$id}');"/>
</xsl:template>

<xsl:template name="rowInputCountry">
<xsl:param name="class" select="'country'"/>
<xsl:if test="(($advanced='1' and @advanced='1') or not (@advanced='1'))">
<tr>
  <td class="fLabel">
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
  <td>
    <xsl:call-template name="inputCountry">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="class" select="$class"/>
    </xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="inputDrug">
	<xsl:param name="id"/>
	<xsl:param name="value"/>
	<xsl:param name="class" select="'country'"/>
  <xsl:variable name="drugcodeId" select="../Gk2x1/@id"/>
  <xsl:variable name="drugname" select="$value"/>  
  <input type="text" class="{$class}" id="{$id}" name="{$id}" value="{$drugname}" maxlength="70" isdrug="1"
    onchange="xmlPage.modifyItem('{$id}');xmlPage.modifyItem('{$drugcodeId}','');" 
    onblur="xmlPage.lostFocus(event,'{$id}');"/>
</xsl:template>

<xsl:template name="rowInputDrug">
<xsl:param name="class" select="''"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
  <td class="fLabel">
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
  <td>
    <xsl:call-template name="inputDrug">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="class" select="$class"/>
    </xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="inputTextArea">
	<xsl:param name="id" select="@id"/>
	<xsl:param name="name" select="name()"/>
	<xsl:param name="value" select="text()"/>
	<xsl:param name="length" select="500"/>
	<xsl:param name="rows" select="10"/>
    <xsl:param name="class" select="print"/>

    <textarea name="{$id}" id="{$id}" style="width:97.5%" maxlength="{$length}" cols="2" rows="{$rows}"
    onchange="xmlPage.modifyItem('{$id}');" onblur="xmlPage.lostFocus('{$id}');" 
    value="{$value}" class="{$class}" onkeyup="AutoGrowTextArea(this)">
    <xsl:if test="not($edit=1)"><xsl:attribute name="readonly">1</xsl:attribute></xsl:if>
    <xsl:value-of select="$value"/>
    </textarea>

</xsl:template>

<xsl:template name="checkbox">
  <xsl:param name="id" select="@id"/>
  <xsl:param name="checked"/>
  <xsl:param name="disabled" select="0"/>
  <xsl:param name="onchange" select="''"/>
  <xsl:param name="onclick" select="''"/>
    <input type="checkbox" name="{$id}" id="{$id}" class="fCheckbox" 
      onclick="xmlPage.modifyCheckbox('{$id}');{$onclick}" 
      onblur="xmlPage.lostFocus(event,'{$id}');">
      <xsl:if test="$onchange"><xsl:attribute name="onchange">{$onchange}</xsl:attribute></xsl:if>
      <xsl:if test="$checked!=0"><xsl:attribute name="checked">{$checked}</xsl:attribute></xsl:if>
      <xsl:if test="$disabled=1"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
    </input>
</xsl:template>

<xsl:template name="rowInputCheckbox">
  <xsl:param name="onchange" select="''"/>
  <xsl:param name="onclick" select="''"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
  <td>
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="checkbox">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="checked" select="text()"/>
      <xsl:with-param name="onclick" select="$onclick"/>
      <xsl:with-param name="onchange" select="$onchange"/>
    </xsl:call-template>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="combobox">
  <xsl:param name="id"/>
  <xsl:param name="codeList"/>
  <xsl:param name="codeValue"/>
  <xsl:param name="codeClass" select="'select'"/>
  <xsl:param name="disable" />
  <xsl:param name="attrdisable" />
  <xsl:choose>
    <xsl:when test="$disable = 1 or $attrdisable = 1">
    </xsl:when>
    <xsl:otherwise>
      <select class="{$codeClass}" name="{$id}" id="{$id}"
        onchange="xmlPage.modifyCombo('{$id}');" 
        onblur="xmlPage.lostFocus(event,'{$id}');" 
        >
        <xsl:for-each select="/eskadra/dictionary/*[name()=$codeList]/item">
          <xsl:element name="option">
            <xsl:attribute name="value">
              <xsl:value-of select="@code" />
            </xsl:attribute>
            <xsl:if test="@disabled">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
            <xsl:if test="$codeValue = @code">
              <xsl:attribute name="selected">1</xsl:attribute>
            </xsl:if>
            <xsl:value-of select="@value" />
          </xsl:element>
        </xsl:for-each>
      </select>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="rowInputCombo">
  <xsl:param name="codeList"/>
  <xsl:param name="codeValue" select="text()"/>
  <xsl:param name="disable" select="0"/>
  <xsl:param name="attrdisable" select="0"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
  <td class="fLabel">
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
  <td>
    <xsl:call-template name="combobox">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="codeList" select="$codeList"/>
      <xsl:with-param name="codeValue" select="$codeValue"/>
      <xsl:with-param name="disable" select="$disable"/>
    </xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="rowInputComboText">
  <xsl:param name="codeId"/>
  <xsl:param name="codeList"/>
  <xsl:param name="codeValue"/>
  <xsl:param name="length"/>
  <xsl:param name="disable" select="0"/>
  <xsl:param name="attrdisable" select="0"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
  <td class="fLabel">
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
  <td>
    <xsl:call-template name="inputText">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="length" select="$length"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="class" select="'date'"/>
    </xsl:call-template>
    <xsl:call-template name="combobox">
      <xsl:with-param name="id" select="$codeId"/>
      <xsl:with-param name="codeList" select="$codeList"/>
      <xsl:with-param name="codeValue" select="$codeValue"/>
      <xsl:with-param name="codeClass" select="'dateFormat'"/>
      <xsl:with-param name="disable" select="$disable"/>
    </xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="rowInputComboDate">
  <xsl:param name="codeId"/>
  <xsl:param name="codeList"/>
  <xsl:param name="codeValue" select="text()"/>
  <xsl:param name="disable" select="0"/>
  <xsl:param name="attrdisable" select="0"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
  <td class="fLabel">
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
  <td>
    <xsl:call-template name="inputText">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="length" select="'16'"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="class" select="'date'"/>
    </xsl:call-template>
    <xsl:call-template name="combobox">
      <xsl:with-param name="id" select="$codeId"/>
      <xsl:with-param name="codeList" select="$codeList"/>
      <xsl:with-param name="codeValue" select="$codeValue"/>
      <xsl:with-param name="codeClass" select="'dateFormat'"/>
      <xsl:with-param name="disable" select="$disable"/>
    </xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="rowInputDate">
  <xsl:param name="format" select="'dd-mm-yyyy'"/>
  <xsl:param name="codeList" select="'dmy'"/>
  <xsl:param name="class" select="''"/>
  <xsl:param name="disable" select="0"/>
  <xsl:param name="attrdisable" select="0"/>
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<tr>
  <td class="fLabel">
    <xsl:attribute name="title"><xsl:value-of select="name()" /></xsl:attribute>
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
  </td>
  <td>
    <xsl:call-template name="inputText">
      <xsl:with-param name="id" select="@id"/>
      <xsl:with-param name="length" select="'16'"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="class" select="$class"/>
      <xsl:with-param name="format" select="$format"/>
    </xsl:call-template>
  </td>
</tr>
</xsl:if>
</xsl:template>

<xsl:template name="subtitle">
<!--  <div class="title"><span class="Eskadra"><span><span><xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_title'"/></xsl:call-template></span></span></span></div>-->
  <h1><div class="left">
    <xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_subtitle'"/></xsl:call-template>
  </div></h1>
  <table><tbody><td>
    <span class="error" title="{$mandatoryItem}">*</span>
    <xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_mandatory_info'"/></xsl:call-template>
    <span> - </span>
    <span class="error" title="{$errorItem}">!</span>
    <xsl:call-template name="label"><xsl:with-param name="name" select="'xmlform_error_info'"/></xsl:call-template>
  </td></tbody></table>
</xsl:template>

<!-- Row of Countries-->
<xsl:template name="countryRow">'<xsl:value-of select="code"/> - <xsl:value-of select="name"/>',</xsl:template>
<!-- end of Row of Countries-->

<!-- Template match -->
<xsl:template match="dictionary" />

<!-- List of countries -->
<xsl:template match="countries">
  <div xmldata-jscript="true" style="display:none">
    window.country_list = [<xsl:for-each select="country"><xsl:call-template name="countryRow"/></xsl:for-each>''];
  </div>
</xsl:template>
<!-- end of List of countries -->

<!-- START FORM -->
<xsl:template match="R3">
  <xsl:call-template name="subtitle"/>
  <form name="form_sentence" method="post" action="https://portal.sukl.sk/weSKadra/weSKadra_commit.php">
    <xsl:apply-templates select="C1"/><!-- report -->
    <xsl:apply-templates select="C2/C2r"/><!-- reporter -->
    <xsl:apply-templates select="D"/><!-- patient -->
    <xsl:apply-templates select="E/Ei"/><!-- reaction -->
    <xsl:apply-templates select="E/Ei[1]/Ei32"/><!-- serious -->
    <xsl:apply-templates select="F/Fr"/><!-- test -->
    <xsl:apply-templates select="G/Gk"/><!-- drug -->
    <xsl:apply-templates select="H/H5r/H5r1a"/><!-- Narrative Case Summary -->
  </form>
</xsl:template>

<xsl:template match="C1">
</xsl:template>

<xsl:template match="Ei32">
<xsl:variable name="seriousId" select="@id" />
<xsl:variable name="serious" select="count(Ei32a[text()='1'] | Ei32b[text()='1'] | Ei32c[text()='1'] | Ei32d[text()='1']  | Ei32e[text()='1']  | Ei32f[text()='1'])"/>
<div class="block">
  <div class="headerBlock">
   <div class="left">
    <xsl:call-template name="label"><xsl:with-param name="name" select="name()"/></xsl:call-template>
   </div>
  <div class="clear"></div>
  </div>
<xsl:if test="(1=1) or ($serious=1)">
  <div class="fLeftBlock">
    <table><tbody>
    <xsl:for-each select="Ei32a">
      <xsl:call-template name="rowInputCheckbox">
        <xsl:with-param name="onclick" select="'xmlPage.reloadDocument();'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Ei32b  | Ei32c">
      <xsl:call-template name="rowInputCheckbox">
        <xsl:with-param name="onclick" select="'xmlPage.reloadDocument();'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="fRightBlock">
    <table><tbody>
    <xsl:for-each select="Ei32d  | Ei32e  | Ei32f">
      <xsl:call-template name="rowInputCheckbox">
        <xsl:with-param name="onclick" select="'xmlPage.reloadDocument();'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
</xsl:if>
  <div class="clear"></div>
  <xsl:apply-templates select="//D9">
    <xsl:with-param name="Ei32a" select="Ei32a"/>
  </xsl:apply-templates>
</div>
</xsl:template>

<xsl:template match="C2r">
<div class="block">
  <xsl:call-template name="blockHeader"><xsl:with-param name="label" select="name()"/></xsl:call-template>
  <div class="fLeftBlock">
    <table><tbody>
<!--
    <xsl:for-each select="../primarysourcecountry">
      <xsl:call-template name="rowInputCountry">
        <xsl:with-param name="class" select="'country'"/>
      </xsl:call-template>
    </xsl:for-each>
 -->
    <xsl:for-each select="C2r1/C2r11">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'50'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="C2r1/C2r12">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'35'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="C2r1/C2r14 | C2r2/C2r27| C2r2/C2r2x1">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'50'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
    </div>
  <div class="fRightBlock">
    <table><tbody>
    <xsl:for-each select="C2r2/C2r21 | C2r2/C2r22">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'60'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="C2r2/C2r23">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'100'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="C2r2/C2r26">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'15'"/>
        <xsl:with-param name="class" select="'zip'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="C2r2/C2r24">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'35'"/>
        <xsl:with-param name="class" select="''"/>
      </xsl:call-template>
    </xsl:for-each>
<!--     
    <xsl:for-each select="C2r2/C2r25">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'40'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="C2r3">
      <xsl:call-template name="rowInputCountry">
        <xsl:with-param name="class" select="'country'"/>
      </xsl:call-template>
    </xsl:for-each>
 -->
    <xsl:for-each select="C2r4">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="'C2r4'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="clear"></div>
</div>
</xsl:template>

<xsl:template match="D">
<div class="block">
  <xsl:call-template name="blockHeader"><xsl:with-param name="label" select="name()"/></xsl:call-template>
  <div class="fLeftBlock">
    <table><tbody>
    <xsl:for-each select="D1">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'10'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="D2/D21">
      <xsl:call-template name="rowInputDate">
        <xsl:with-param name="format" select="'dd.mm.rrrr'"/>
        <xsl:with-param name="class" select="''"/>
      </xsl:call-template>
    </xsl:for-each>
    
    <xsl:for-each select="D2/D22/D22a">
      <xsl:call-template name="rowInputComboText">
        <xsl:with-param name="codeList" select="'D22b'"/>
        <xsl:with-param name="codeId" select="../D22b/@id"/>
        <xsl:with-param name="codeValue" select="../D22b/text()"/>
        <xsl:with-param name="codeClass" select="'date'"/>
        <xsl:with-param name="length" select="'5'"/>
      </xsl:call-template>
    </xsl:for-each>
    
    </tbody></table>
  </div>
  <div class="fRightBlock">
    <table><tbody>
    <xsl:for-each select="D3 | D4">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'3'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="D5">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="'D5'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="clear"></div>
</div>
</xsl:template>

<xsl:template match="D9">
  <xsl:param name="Ei32a" />
  <xsl:if test="$Ei32a=1 or (string-length(D91/text()) &gt; 0)">
  <!-- <xsl:if test="$Ei32a=1"> -->
  <div class="fLeftBlock">
    <table><tbody>
    <xsl:for-each select="D91">
      <xsl:call-template name="rowInputDate">
        <xsl:with-param name="format" select="'dd.mm.rrrr alebo mm.rrrr alebo rrrr'"/>
       </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="fRightBlock">
    <table><tbody>
    <xsl:for-each select="D93">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="'ynu'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="clear"></div>
</xsl:if>
</xsl:template>

<xsl:template match="Ei">
<div class="block">
  <xsl:call-template name="blockHeader"><xsl:with-param name="label" select="name()"/></xsl:call-template>
  <div class="fFullBlock">
    <table><tbody>
    <xsl:for-each select="Ei1/Ei11a">
<tr>
<td width="15%">
<xsl:call-template name="label">
          <xsl:with-param name="name" select="name()"/>
        </xsl:call-template>
      </td>
      <td>
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="value" select="text()"/>
        <textarea name="{$id}" id="{$id}" style="width:98%" maxlength="250" rows="1"
          onchange="xmlPage.modifyItem('{$id}');" onblur="xmlPage.lostFocus('{$id}');" 
          value="{$value}" >
        <xsl:if test="not($edit=1)"><xsl:attribute name="readonly">1</xsl:attribute></xsl:if>
        <xsl:value-of select="$value"/>
        </textarea>
      </td>
      </tr>
    </xsl:for-each>
    </tbody></table>
  </div>
	
<div class="fLeftBlock">
    <table><tbody>
    <xsl:for-each select="Ei7">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="name()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Ei6a">
      <xsl:call-template name="rowInputComboText">
        <xsl:with-param name="length" select="'8'"/>
        <xsl:with-param name="codeList" select="'ucum26'"/>
        <xsl:with-param name="codeId" select="../Ei6b/@id"/>
        <xsl:with-param name="codeValue" select="../Ei6b/text()"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
    </div>
  <div class="fRightBlock">
    <table><tbody>
    <xsl:for-each select="Ei4">
      <xsl:call-template name="rowInputDate">
        <xsl:with-param name="format" select="'dd.mm.rrrr alebo mm.rrrr alebo rrrr'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Ei5">
      <xsl:call-template name="rowInputDate">
        <xsl:with-param name="format" select="'dd.mm.rrrr alebo mm.rrrr alebo rrrr'"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="clear"></div>
  <xsl:call-template name="blockFooter"><xsl:with-param name="label" select="name()"/></xsl:call-template>
</div>
</xsl:template>

<xsl:template match="Fr">
<xsl:if test="(($advanced=1 and @advanced=1) or not (@advanced=1))">
<xsl:variable name="Fr21" select="Fr2/Fr21/text()!=''"/>
<div class="block">
  <xsl:call-template name="blockHeader"><xsl:with-param name="label" select="name()"/></xsl:call-template>
  <div class="fFullBlock">
    <xsl:for-each select="Fr2/Fr21[text()!=''] | Fr3/Fr34">
      <xsl:if test="position()=1">
      <xsl:call-template name="inputTextArea">
            <xsl:with-param name="length" select="2000"/>
            <xsl:with-param name="class" select="'print'"/>
      </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
    </div>
<!-- moreinformation -->
<!-- 
  <div class="fLeftBlock">
    <table><tbody>
    <xsl:for-each select="Fr7">
      <xsl:call-template name="rowInputCheckbox"/>
    </xsl:for-each>
    </tbody></table>
  </div>
 -->
  <div class="clear"></div>
</div>
</xsl:if>
</xsl:template>

<xsl:template match="Gk">
<div class="block">
  <xsl:call-template name="blockHeader"><xsl:with-param name="label" select="name()"/></xsl:call-template>
  <div class="fLeftBlock">
    <table><tbody>
    <xsl:for-each select="Gk1">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="name()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk2/Gk22">
      <xsl:call-template name="rowInputDrug"/>
    </xsl:for-each>
    <xsl:for-each select="Gk2/Gk23r/Gk23r1">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'100'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk4r/Gk4r9/Gk4r91">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'100'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk4r/Gk4r7">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'35'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk7r/Gk7r1">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'250'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk8">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="name()"/>
        <xsl:with-param name="codeValue" select="text()"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="fRightBlock">
    <table><tbody>
    <xsl:for-each select="Gk4r/Gk4r1a">
      <xsl:call-template name="rowInputComboText">
        <xsl:with-param name="length" select="'8'"/>
        <xsl:with-param name="codeList" select="'wucum25'"/>
        <xsl:with-param name="codeId" select="../Gk4r1b/@id"/>
        <xsl:with-param name="codeValue" select="../Gk4r1b/text()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk4r/Gk4r8">
      <xsl:call-template name="rowInputText">
        <xsl:with-param name="length" select="'100'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk5a">
      <xsl:call-template name="rowInputComboText">
        <xsl:with-param name="length" select="'10'"/>
        <xsl:with-param name="codeList" select="'wucum25'"/>
        <xsl:with-param name="codeId" select="../Gk5b/@id"/>
        <xsl:with-param name="codeValue" select="../Gk5b/text()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk4r/Gk4r4">
      <xsl:call-template name="rowInputDate">
        <xsl:with-param name="format" select="'dd.mm.rrrr alebo mm.rrrr alebo rrrr'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk4r/Gk4r5">
      <xsl:call-template name="rowInputDate">
        <xsl:with-param name="format" select="'dd.mm.rrrr alebo mm.rrrr alebo rrrr'"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk4r/Gk4r6a">
      <xsl:call-template name="rowInputComboText">
        <xsl:with-param name="length" select="'5'"/>
        <xsl:with-param name="codeList" select="'ucum26'"/>
        <xsl:with-param name="codeId" select="../Gk4r6b/@id"/>
        <xsl:with-param name="codeValue" select="../Gk4r6b/text()"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="Gk9i/Gk9i4">
      <xsl:call-template name="rowInputCombo">
        <xsl:with-param name="codeList" select="name()"/>
        <xsl:with-param name="codeValue" select="text()"/>
      </xsl:call-template>
    </xsl:for-each>
    </tbody></table>
  </div>
  <div class="clear"></div>
  <xsl:call-template name="blockFooter"><xsl:with-param name="label" select="name()"/></xsl:call-template>
</div>
</xsl:template>

<xsl:template match="H5r1a">
<div class="block">
  <xsl:call-template name="blockHeader"><xsl:with-param name="label" select="name()"/></xsl:call-template>
  <div class="fFullBlock">
      <xsl:call-template name="inputTextArea">
        <xsl:with-param name="length" select="100000"/>
        <xsl:with-param name="class" select="'print'"/>
      </xsl:call-template>
  </div>
</div>
</xsl:template>

</xsl:stylesheet>
