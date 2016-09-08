From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] doc: payload and conntrack statement
Date: Fri,  9 Sep 2016 00:16:56 +0200
Message-ID: <1473373016-24078-2-git-send-email-fw@strlen.de>
References: <1473373016-24078-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46584 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751907AbcIHWQq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 18:16:46 -0400
In-Reply-To: <1473373016-24078-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 6297674..3b215f8 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2037,7 +2037,7 @@ filter output oif eth0
 							</row>
 							<row>
 								<entry>label</entry>
-								<entry>Connection tracking label</entry>
+								<entry>Connection tracking label bit or symbolic name defined in connlabel.conf in the nftables include path</entry>
 								<entry>ct_label</entry>
 							</row>
 							<row>
@@ -2207,6 +2207,29 @@ filter input iif eth0 drop
 			</para>
 		</refsect2>
 		<refsect2>
+			<title>Payload statement</title>
+			<para>
+				The payload statement alters packet content.
+				It can be used for example to set ip DSCP (differv) header field or ipv6 flow labels.
+			</para>
+			<para>
+				<example>
+					<title>route some packets instead of bridging</title>
+					<programlisting>
+# redirect tcp:http from 192.160.0.0/16 to local machine for routing instead of bridging
+# assumes 00:11:22:33:44:55 is local MAC address.
+bridge input meta iif eth0 ip saddr 192.168.0.0/16 tcp dport 80 meta pkttype set unicast ether daddr set 00:11:22:33:44:55
+					</programlisting>
+				</example>
+				<example>
+					<title>Set IPv4 DSCP header field</title>
+					<programlisting>
+ip forward ip dscp set 42
+					</programlisting>
+				</example>
+			</para>
+		</refsect2>
+		<refsect2>
 			<title>Log statement</title>
 			<para>
 				<cmdsynopsis>
@@ -2390,6 +2413,63 @@ filter input iif eth0 drop
 
 		</refsect2>
 		<refsect2>
+			<title>Conntrack statement</title>
+			<para>
+				The conntrack statement can be used to set the conntrack mark and conntrack labels.
+			</para>
+			<para>
+				<cmdsynopsis>
+					<command>ct</command>
+					<group choice="req">
+						<arg>mark</arg>
+						<arg>label</arg>
+					</group>
+					<arg choice="none">set</arg>
+					<replaceable>value</replaceable>
+				</cmdsynopsis>
+			</para>
+			<para>
+				The ct statement sets meta data associated with a connection.
+			</para>
+			<para>
+				<table frame="all">
+					<title>Meta statement types</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Keyword</entry>
+								<entry>Description</entry>
+								<entry>Value</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>mark</entry>
+								<entry>Connection tracking mark</entry>
+								<entry>mark</entry>
+							</row>
+							<row>
+								<entry>label</entry>
+								<entry>Connection tracking label</entry>
+								<entry>label</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				<example>
+					<title>save packet nfmark in conntrack</title>
+					<programlisting>
+ct set mark meta mark
+					</programlisting>
+				</example>
+			</para>
+		</refsect2>
+		<refsect2>
 			<title>Meta statement</title>
 			<para>
 				A meta statement sets the value of a meta expression.
-- 
2.7.3

