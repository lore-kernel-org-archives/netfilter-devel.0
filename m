From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 5/5] doc: Document boolean type and applications
Date: Fri, 10 Mar 2017 18:13:53 +0100
Message-ID: <20170310171353.28868-6-phil@nwl.cc>
References: <20170310171353.28868-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:32849 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932595AbdCJROc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 12:14:32 -0500
In-Reply-To: <20170310171353.28868-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 134 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 990b93684c9c4..de86d2a18258f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1329,6 +1329,110 @@ filter output ip6 daddr ::1
 				</programlisting>
 			</example>
 		</refsect2>
+
+		<refsect2>
+			<title>Boolean type</title>
+			<para>
+				<table frame="all">
+					<tgroup cols='4' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<colspec colname='c4'/>
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
+								<entry>Boolean</entry>
+								<entry>boolean</entry>
+								<entry>1 bit</entry>
+								<entry>integer</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				The boolean type is a syntactical helper type in user space.
+				It's use is in the right-hand side of a (typically implicit)
+				relational expression to change the expression on the left-hand
+				side into a boolean check (usually for existence).
+			</para>
+			<para>
+				The following keywords will automatically resolve into a boolean
+				type with given value:
+				<table frame="all">
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Value</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>exists</entry>
+								<entry>1</entry>
+							</row>
+							<row>
+								<entry>missing</entry>
+								<entry>0</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<example>
+				<title>Boolean specification</title>
+				<para>
+					The following expressions support a boolean comparison:
+					<table frame="all">
+						<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+							<colspec colname='c1'/>
+							<colspec colname='c2'/>
+							<thead>
+								<row>
+									<entry>Expression</entry>
+									<entry>Behaviour</entry>
+								</row>
+							</thead>
+							<tbody>
+								<row>
+									<entry>fib</entry>
+									<entry>Check route existence.</entry>
+								</row>
+								<row>
+									<entry>exthdr</entry>
+									<entry>Check IPv6 extension header existence.</entry>
+								</row>
+								<row>
+									<entry>tcp option</entry>
+									<entry>Check TCP option header existence.</entry>
+								</row>
+							</tbody>
+						</tgroup>
+					</table>
+				</para>
+				<programlisting>
+# match if route exists
+filter input fib iif saddr exists
+
+# match only non-fragmented packets in IPv6 traffic
+filter input exthdr frag missing
+
+# match if TCP timestamp option is present
+filter input tcp option timestamp exists
+				</programlisting>
+			</example>
+		</refsect2>
 	</refsect1>
 
 	<refsect1>
@@ -2536,6 +2640,36 @@ inet filter meta nfproto ipv6 output rt nexthop fd00::1
 				<arg choice="none"><replaceable>tcp_option_field</replaceable></arg>
 			</cmdsynopsis>
 			<para>
+				The following syntaxes are valid only in a relational expression
+				with boolean type on right-hand side for checking header existence only:
+			</para>
+			<cmdsynopsis>
+				<command>exthdr</command>
+				<group choice="req">
+					<arg>hbh</arg>
+					<arg>frag</arg>
+					<arg>rt</arg>
+					<arg>dst</arg>
+					<arg>mh</arg>
+				</group>
+			</cmdsynopsis>
+			<cmdsynopsis>
+				<command>tcp option</command>
+				<group choice="req">
+					<arg>eol</arg>
+					<arg>noop</arg>
+					<arg>maxseg</arg>
+					<arg>window</arg>
+					<arg>sack-permitted</arg>
+					<arg>sack</arg>
+					<arg>sack0</arg>
+					<arg>sack1</arg>
+					<arg>sack2</arg>
+					<arg>sack3</arg>
+					<arg>timestamp</arg>
+				</group>
+			</cmdsynopsis>
+			<para>
 				<table frame="all">
 					<title>IPv6 extension headers</title>
 					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
-- 
2.11.0

