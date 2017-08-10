From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 2/6] nft.8: Describe conntrack types
Date: Thu, 10 Aug 2017 19:29:16 +0200
Message-ID: <20170810172920.14893-3-phil@nwl.cc>
References: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42469 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752559AbdHJRaK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:30:10 -0400
In-Reply-To: <20170810172920.14893-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 230 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 230 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 91b9bb378c80a..3ef88a79efd70 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1921,6 +1921,232 @@ filter output icmpv6 type { echo-request, echo-reply }
 				</programlisting>
 			</example>
 		</refsect2>
+		<refsect2>
+			<title>Conntrack types</title>
+			<para>
+				This is an overview of types used in <command>ct</command>
+				expression and statement:
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
+								<entry>conntrack state</entry>
+								<entry>ct_state</entry>
+								<entry>4 byte</entry>
+								<entry>bitmask</entry>
+							</row>
+							<row>
+								<entry>conntrack direction</entry>
+								<entry>ct_dir</entry>
+								<entry>8 bit</entry>
+								<entry>integer</entry>
+							</row>
+							<row>
+								<entry>conntrack status</entry>
+								<entry>ct_status</entry>
+								<entry>4 byte</entry>
+								<entry>bitmask</entry>
+							</row>
+							<row>
+								<entry>conntrack event bits</entry>
+								<entry>ct_event</entry>
+								<entry>4 byte</entry>
+								<entry>bitmask</entry>
+							</row>
+							<row>
+								<entry>conntrack label</entry>
+								<entry>ct_label</entry>
+								<entry>128 bit</entry>
+								<entry>bitmask</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				For each of the types above, keywords are available for convenience:
+				<table frame="all">
+					<title>conntrack state (ct_state)</title>
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
+								<entry>invalid</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>established</entry>
+								<entry>2</entry>
+							</row>
+							<row>
+								<entry>related</entry>
+								<entry>4</entry>
+							</row>
+							<row>
+								<entry>new</entry>
+								<entry>8</entry>
+							</row>
+							<row>
+								<entry>untracked</entry>
+								<entry>64</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+
+				<table frame="all">
+					<title>conntrack direction (ct_dir)</title>
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
+								<entry>original</entry>
+								<entry>0</entry>
+							</row>
+							<row>
+								<entry>reply</entry>
+								<entry>1</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+
+				<table frame="all">
+					<title>conntrack status (ct_status)</title>
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
+								<entry>expected</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>seen-reply</entry>
+								<entry>2</entry>
+							</row>
+							<row>
+								<entry>assured</entry>
+								<entry>4</entry>
+							</row>
+							<row>
+								<entry>confirmed</entry>
+								<entry>8</entry>
+							</row>
+							<row>
+								<entry>snat</entry>
+								<entry>16</entry>
+							</row>
+							<row>
+								<entry>dnat</entry>
+								<entry>32</entry>
+							</row>
+							<row>
+								<entry>dying</entry>
+								<entry>512</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+
+				<table frame="all">
+					<title>conntrack event bits (ct_event)</title>
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
+								<entry>new</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>related</entry>
+								<entry>2</entry>
+							</row>
+							<row>
+								<entry>destroy</entry>
+								<entry>4</entry>
+							</row>
+							<row>
+								<entry>reply</entry>
+								<entry>8</entry>
+							</row>
+							<row>
+								<entry>assured</entry>
+								<entry>16</entry>
+							</row>
+							<row>
+								<entry>protoinfo</entry>
+								<entry>32</entry>
+							</row>
+							<row>
+								<entry>helper</entry>
+								<entry>64</entry>
+							</row>
+							<row>
+								<entry>mark</entry>
+								<entry>128</entry>
+							</row>
+							<row>
+								<entry>seqadj</entry>
+								<entry>256</entry>
+							</row>
+							<row>
+								<entry>secmark</entry>
+								<entry>512</entry>
+							</row>
+							<row>
+								<entry>label</entry>
+								<entry>1024</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+				<para>
+					Possible keywords for conntrack label type
+					(<command>ct_label</command>) are read at runtime from
+					<literal>/etc/connlabel.conf</literal>.
+				</para>
+			</para>
+		</refsect2>
 	</refsect1>
 
 	<refsect1>
@@ -3577,6 +3803,10 @@ ip6 filter input frag more-fragments 1 counter
 					</tgroup>
 				</table>
 			</para>
+			<para>
+				A description of conntrack-specific types listed above can be
+				found sub-section <literal>CONNTRACK TYPES</literal> above.
+			</para>
 		</refsect2>
 	</refsect1>
 
-- 
2.13.1

