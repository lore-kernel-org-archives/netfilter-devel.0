From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 2/2] doc: Describe ICMP(v6) expression and types
Date: Thu, 16 Mar 2017 13:43:21 +0100
Message-ID: <20170316124321.23399-2-phil@nwl.cc>
References: <20170315214757.GA1289@salvia>
 <20170316124321.23399-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47865 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752332AbdCPMno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2017 08:43:44 -0400
In-Reply-To: <20170316124321.23399-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds a description of the icmp and icmpv6 expressions (to match
various ICMP header fields) as well as the icmp and icmpv6 type types
(yay) which are used for ICMP(v6) type field.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Added this patch.
---
 doc/nft.xml | 380 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 380 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index b3e3d9e7ac632..d412184609135 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1504,6 +1504,254 @@ filter input tcp option timestamp exists
 				</programlisting>
 			</example>
 		</refsect2>
+		<refsect2>
+			<title>ICMP Type type</title>
+			<para>
+				<table frame="all">
+					<tgroup cols="4" align="left" colsep="1" rowsep="1">
+						<colspec colname="c1"/>
+						<colspec colname="c2"/>
+						<colspec colname="c3"/>
+						<colspec colname="c4"/>
+						<thead>
+							<row>
+								<entry>Name</entry>
+								<entry>Keyword</entry>
+								<entry>Size</entry>
+								<entry>Base type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>ICMP Type</entry>
+								<entry>icmp_type</entry>
+								<entry>8 bit</entry>
+								<entry>integer</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				The ICMP Type type is used to conveniently specify the ICMP header's type field.
+			</para>
+			<para>
+				The following keywords may be used when specifying the ICMP type:
+				<table frame="all">
+					<tgroup cols="2" align="left" colsep="1" rowsep="1">
+						<colspec colname="c1"/>
+						<colspec colname="c2"/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Value</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>echo-reply</entry>
+								<entry>0</entry>
+							</row>
+							<row>
+								<entry>destination-unreachable</entry>
+								<entry>3</entry>
+							</row>
+							<row>
+								<entry>source-quench</entry>
+								<entry>4</entry>
+							</row>
+							<row>
+								<entry>redirect</entry>
+								<entry>5</entry>
+							</row>
+							<row>
+								<entry>echo-request</entry>
+								<entry>8</entry>
+							</row>
+							<row>
+								<entry>router-advertisement</entry>
+								<entry>9</entry>
+							</row>
+							<row>
+								<entry>router-solicitation</entry>
+								<entry>10</entry>
+							</row>
+							<row>
+								<entry>time-exceeded</entry>
+								<entry>11</entry>
+							</row>
+							<row>
+								<entry>parameter-problem</entry>
+								<entry>12</entry>
+							</row>
+							<row>
+								<entry>timestamp-request</entry>
+								<entry>13</entry>
+							</row>
+							<row>
+								<entry>timestamp-reply</entry>
+								<entry>14</entry>
+							</row>
+							<row>
+								<entry>info-request</entry>
+								<entry>15</entry>
+							</row>
+							<row>
+								<entry>info-reply</entry>
+								<entry>16</entry>
+							</row>
+							<row>
+								<entry>address-mask-request</entry>
+								<entry>17</entry>
+							</row>
+							<row>
+								<entry>address-mask-reply</entry>
+								<entry>18</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<example>
+				<title>ICMP Type specification</title>
+				<programlisting>
+# match ping packets
+filter output icmp type { echo-request, echo-reply }
+				</programlisting>
+			</example>
+		</refsect2>
+		<refsect2>
+			<title>ICMPv6 Type type</title>
+			<para>
+				<table frame="all">
+					<tgroup cols="4" align="left" colsep="1" rowsep="1">
+						<colspec colname="c1"/>
+						<colspec colname="c2"/>
+						<colspec colname="c3"/>
+						<colspec colname="c4"/>
+						<thead>
+							<row>
+								<entry>Name</entry>
+								<entry>Keyword</entry>
+								<entry>Size</entry>
+								<entry>Base type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>ICMPv6 Type</entry>
+								<entry>icmpv6_type</entry>
+								<entry>8 bit</entry>
+								<entry>integer</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				The ICMPv6 Type type is used to conveniently specify the ICMPv6 header's type field.
+			</para>
+			<para>
+				The following keywords may be used when specifying the ICMPv6 type:
+				<table frame="all">
+					<tgroup cols="2" align="left" colsep="1" rowsep="1">
+						<colspec colname="c1"/>
+						<colspec colname="c2"/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Value</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>destination-unreachable</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>packet-too-big</entry>
+								<entry>2</entry>
+							</row>
+							<row>
+								<entry>time-exceeded</entry>
+								<entry>3</entry>
+							</row>
+							<row>
+								<entry>parameter-problem</entry>
+								<entry>4</entry>
+							</row>
+							<row>
+								<entry>echo-request</entry>
+								<entry>128</entry>
+							</row>
+							<row>
+								<entry>echo-reply</entry>
+								<entry>129</entry>
+							</row>
+							<row>
+								<entry>mld-listener-query</entry>
+								<entry>130</entry>
+							</row>
+							<row>
+								<entry>mld-listener-report</entry>
+								<entry>131</entry>
+							</row>
+							<row>
+								<entry>mld-listener-done</entry>
+								<entry>132</entry>
+							</row>
+							<row>
+								<entry>mld-listener-reduction</entry>
+								<entry>132</entry>
+							</row>
+							<row>
+								<entry>nd-router-solicit</entry>
+								<entry>133</entry>
+							</row>
+							<row>
+								<entry>nd-router-advert</entry>
+								<entry>134</entry>
+							</row>
+							<row>
+								<entry>nd-neighbor-solicit</entry>
+								<entry>135</entry>
+							</row>
+							<row>
+								<entry>nd-neighbor-advert</entry>
+								<entry>136</entry>
+							</row>
+							<row>
+								<entry>nd-redirect</entry>
+								<entry>137</entry>
+							</row>
+							<row>
+								<entry>router-renumbering</entry>
+								<entry>138</entry>
+							</row>
+							<row>
+								<entry>ind-neighbor-solicit</entry>
+								<entry>141</entry>
+							</row>
+							<row>
+								<entry>ind-neighbor-advert</entry>
+								<entry>142</entry>
+							</row>
+							<row>
+								<entry>mld2-listener-report</entry>
+								<entry>143</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<example>
+				<title>ICMPv6 Type specification</title>
+				<programlisting>
+# match ICMPv6 ping packets
+filter output icmpv6 type { echo-request, echo-reply }
+				</programlisting>
+			</example>
+		</refsect2>
 	</refsect1>
 
 	<refsect1>
@@ -2171,6 +2419,70 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 		</refsect2>
 
 		<refsect2>
+			<title>ICMP header expression</title>
+			<para>
+				<cmdsynopsis>
+					<command>icmp</command>
+					<arg opt="req"><replaceable>ICMP header field</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				<table frame="all">
+					<title>ICMP header expression</title>
+					<tgroup cols="3" align="left" colsep="1" rowsep="1">
+						<colspec colname="c1"/>
+						<colspec colname="c2"/>
+						<colspec colname="c3"/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>type</entry>
+								<entry>ICMP type field</entry>
+								<entry>icmp_type</entry>
+							</row>
+							<row>
+								<entry>code</entry>
+								<entry>ICMP code field</entry>
+								<entry>integer (8 bit)</entry>
+							</row>
+							<row>
+								<entry>checksum</entry>
+								<entry>ICMP checksum field</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>id</entry>
+								<entry>ID of echo request/response</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>sequence</entry>
+								<entry>sequence number of echo request/response</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>gateway</entry>
+								<entry>gateway of redirects</entry>
+								<entry>integer (32 bit)</entry>
+							</row>
+							<row>
+								<entry>mtu</entry>
+								<entry>MTU of path MTU discovery</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+		</refsect2>
+
+		<refsect2>
 			<title>IPv6 header expression</title>
 			<para>
 				<cmdsynopsis>
@@ -2245,6 +2557,74 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 		</refsect2>
 
 		<refsect2>
+			<title>ICMPv6 header expression</title>
+			<para>
+				<cmdsynopsis>
+					<command>icmpv6</command>
+					<arg opt="req"><replaceable>ICMPv6 header field</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				<table frame="all">
+					<title>ICMPv6 header expression</title>
+					<tgroup cols="3" align="left" colsep="1" rowsep="1">
+						<colspec colname="c1"/>
+						<colspec colname="c2"/>
+						<colspec colname="c3"/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>type</entry>
+								<entry>ICMPv6 type field</entry>
+								<entry>icmpv6_type</entry>
+							</row>
+							<row>
+								<entry>code</entry>
+								<entry>ICMPv6 code field</entry>
+								<entry>integer (8 bit)</entry>
+							</row>
+							<row>
+								<entry>checksum</entry>
+								<entry>ICMPv6 checksum field</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>parameter-problem</entry>
+								<entry>pointer to problem</entry>
+								<entry>integer (32 bit)</entry>
+							</row>
+							<row>
+								<entry>packet-too-big</entry>
+								<entry>oversized MTU</entry>
+								<entry>integer (32 bit)</entry>
+							</row>
+							<row>
+								<entry>id</entry>
+								<entry>ID of echo request/response</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>sequence</entry>
+								<entry>sequence number of echo request/response</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>max-delay</entry>
+								<entry>maximum response delay of MLD queries</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+		</refsect2>
+		<refsect2>
 			<title>TCP header expression</title>
 			<para>
 				<cmdsynopsis>
-- 
2.11.0

