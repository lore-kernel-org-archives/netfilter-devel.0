From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 3/6] nft.8: Review reject statement description
Date: Thu, 10 Aug 2017 19:29:17 +0200
Message-ID: <20170810172920.14893-4-phil@nwl.cc>
References: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42123 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753114AbdHJR3v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:29:51 -0400
In-Reply-To: <20170810172920.14893-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

- Describe 'type' argument datatypes in DATA TYPES section, then remove
  value list from reject statement description and refer to that section
  instead.
- Fix synopsis: 'with ...' is optional.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 317 ++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 256 insertions(+), 61 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 3ef88a79efd70..bc6b6fb72b6a7 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1790,6 +1790,83 @@ filter output icmp type { echo-request, echo-reply }
 			</example>
 		</refsect2>
 		<refsect2>
+			<title>ICMP Code type</title>
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
+								<entry>ICMP Code</entry>
+								<entry>icmp_code</entry>
+								<entry>8 bit</entry>
+								<entry>integer</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				The ICMP Code type is used to conveniently specify the ICMP header's code field.
+			</para>
+			<para>
+				The following keywords may be used when specifying the ICMP code:
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
+								<entry>net-unreachable</entry>
+								<entry>0</entry>
+							</row>
+							<row>
+								<entry>host-unreachable</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>prot-unreachable</entry>
+								<entry>2</entry>
+							</row>
+							<row>
+								<entry>port-unreachable</entry>
+								<entry>3</entry>
+							</row>
+							<row>
+								<entry>net-prohibited</entry>
+								<entry>9</entry>
+							</row>
+							<row>
+								<entry>host-prohibited</entry>
+								<entry>10</entry>
+							</row>
+							<row>
+								<entry>admin-prohibited</entry>
+								<entry>13</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+		</refsect2>
+		<refsect2>
 			<title>ICMPv6 Type type</title>
 			<para>
 				<table frame="all">
@@ -1922,6 +1999,146 @@ filter output icmpv6 type { echo-request, echo-reply }
 			</example>
 		</refsect2>
 		<refsect2>
+			<title>ICMPv6 Code type</title>
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
+								<entry>ICMPv6 Code</entry>
+								<entry>icmpv6_code</entry>
+								<entry>8 bit</entry>
+								<entry>integer</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				The ICMPv6 Code type is used to conveniently specify the ICMPv6 header's code field.
+			</para>
+			<para>
+				The following keywords may be used when specifying the ICMPv6 code:
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
+								<entry>no-route</entry>
+								<entry>0</entry>
+							</row>
+							<row>
+								<entry>admin-prohibited</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>addr-unreachable</entry>
+								<entry>3</entry>
+							</row>
+							<row>
+								<entry>port-unreachable</entry>
+								<entry>4</entry>
+							</row>
+							<row>
+								<entry>policy-fail</entry>
+								<entry>5</entry>
+							</row>
+							<row>
+								<entry>reject-route</entry>
+								<entry>6</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+		</refsect2>
+		<refsect2>
+			<title>ICMPvX Code type</title>
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
+								<entry>ICMPvX Code</entry>
+								<entry>icmpx_code</entry>
+								<entry>8 bit</entry>
+								<entry>integer</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				The ICMPvX Code type abstraction is a set of values which
+				overlap between ICMP and ICMPv6 Code types to be used from the
+				inet family.
+			</para>
+			<para>
+				The following keywords may be used when specifying the ICMPvX code:
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
+								<entry>no-route</entry>
+								<entry>0</entry>
+							</row>
+							<row>
+								<entry>port-unreachable</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>host-unreachable</entry>
+								<entry>2</entry>
+							</row>
+							<row>
+								<entry>admin-prohibited</entry>
+								<entry>3</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+		</refsect2>
+		<refsect2>
 			<title>Conntrack types</title>
 			<para>
 				This is an overview of types used in <command>ct</command>
@@ -4083,95 +4300,73 @@ ip6 filter output log flags all
 			<para>
 				<cmdsynopsis>
 					<command>reject</command>
-					<arg choice="none">with</arg>
-					<group choice="req">
-						<arg>icmp</arg>
-						<arg>icmp6</arg>
-						<arg>icmpx</arg>
-					</group>
-					<arg choice="none">type</arg>
-					<group choice="req">
-						<arg>icmp_type</arg>
-						<arg>icmp6_type</arg>
-						<arg>icmpx_type</arg>
-					</group>
+					<arg choice="opt">
+						<arg choice="none">with</arg>
+						<group choice="req">
+							<arg>icmp</arg>
+							<arg>icmp6</arg>
+							<arg>icmpx</arg>
+						</group>
+						<arg choice="none">type</arg>
+						<group choice="req">
+							<arg>icmp_type</arg>
+							<arg>icmp6_type</arg>
+							<arg>icmpx_type</arg>
+						</group>
+					</arg>
 				</cmdsynopsis>
 				<cmdsynopsis>
 					<command>reject</command>
-					<arg choice="none">with</arg>
-					<arg choice="req">tcp</arg>
-					<arg choice="req">reset</arg>
+					<arg choice="opt">
+						<arg choice="none">with</arg>
+						<arg choice="req">tcp</arg>
+						<arg choice="req">reset</arg>
+					</arg>
 				</cmdsynopsis>
 			</para>
 			<para>
 				A reject statement is used to send back an error packet in response to the matched packet otherwise it is equivalent to drop so it is a terminating statement, ending rule traversal. This statement is only valid in the input, forward and output chains, and user-defined chains which are only called from those chains.
+			</para>
+			<para>
+				The different ICMP reject variants are meant for use in different table families:
 				<table frame="all">
-					<title>reject statement type (ip)</title>
-					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
-						<colspec colname='c1'/>
-						<colspec colname='c2'/>
-						<colspec colname='c3'/>
-						<thead>
-							<row>
-								<entry>Value</entry>
-								<entry>Description</entry>
-								<entry>Type</entry>
-							</row>
-						</thead>
-						<tbody>
-							<row>
-								<entry>icmp_type</entry>
-								<entry>ICMP type response to be sent to the host</entry>
-								<entry>net-unreachable, host-unreachable, prot-unreachable, port-unreachable [default], net-prohibited, host-prohibited, admin-prohibited</entry>
-							</row>
-						</tbody>
-					</tgroup>
-				</table>
-				<table frame="all">
-					<title>reject statement type (ip6)</title>
 					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
 						<colspec colname='c1'/>
 						<colspec colname='c2'/>
 						<colspec colname='c3'/>
 						<thead>
 							<row>
-								<entry>Value</entry>
-								<entry>Description</entry>
+								<entry>Variant</entry>
+								<entry>Family</entry>
 								<entry>Type</entry>
 							</row>
 						</thead>
 						<tbody>
 							<row>
-								<entry>icmp6_type</entry>
-								<entry>ICMPv6 type response to be sent to the host</entry>
-								<entry>no-route, admin-prohibited, addr-unreachable, port-unreachable [default], policy-fail, reject-route</entry>
+								<entry>icmp</entry>
+								<entry>ip</entry>
+								<entry>icmp_code</entry>
 							</row>
-						</tbody>
-					</tgroup>
-				</table>
-				<table frame="all">
-					<title>reject statement type (inet)</title>
-					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
-						<colspec colname='c1'/>
-						<colspec colname='c2'/>
-						<colspec colname='c3'/>
-						<thead>
 							<row>
-								<entry>Value</entry>
-								<entry>Description</entry>
-								<entry>Type</entry>
+								<entry>icmp6</entry>
+								<entry>ip6</entry>
+								<entry>icmpv6_code</entry>
 							</row>
-						</thead>
-						<tbody>
 							<row>
-								<entry>icmpx_type</entry>
-								<entry>ICMPvXtype abstraction response to be sent to the host, this is a set of types that overlap in IPv4 and IPv6 to be used from the inet family.</entry>
-								<entry>port-unreachable [default], admin-prohibited, no-route, host-unreachable</entry>
+								<entry>icmpx</entry>
+								<entry>inet</entry>
+								<entry>icmpx_code</entry>
 							</row>
 						</tbody>
 					</tgroup>
 				</table>
 			</para>
+			<para>
+				For a description of the different types and a list of supported
+				keywords refer to <literal>DATA TYPES</literal> section above.
+				The common default reject value is
+				<command>port-unreachable</command>.
+			</para>
 		</refsect2>
 		<refsect2>
 			<title>Counter statement</title>
-- 
2.13.1

