From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 8/9] doc: ct zone set support
Date: Tue, 14 Mar 2017 20:58:15 +0100
Message-ID: <20170314195816.1721-9-fw@strlen.de>
References: <20170314195816.1721-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42158 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdCNT6c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:58:32 -0400
In-Reply-To: <20170314195816.1721-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index de86d2a18258..8ea280417742 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -3347,6 +3347,7 @@ ip6 filter output log flags all
 					<group choice="req">
 						<arg>mark</arg>
 						<arg>label</arg>
+						<arg>zone</arg>
 					</group>
 					<arg choice="none">set</arg>
 					<replaceable>value</replaceable>
@@ -3354,10 +3355,14 @@ ip6 filter output log flags all
 			</para>
 			<para>
 				The ct statement sets meta data associated with a connection.
+				The zone id has to be assigned before a conntrack lookup takes place,
+				i.e. this has to be done in prerouting and possibly output (if locally
+				generated packets need to be placed in a distinct zone), with a hook
+				priority of -300.
 			</para>
 			<para>
 				<table frame="all">
-					<title>Meta statement types</title>
+					<title>Conntrack statement types</title>
 					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
 						<colspec colname='c1'/>
 						<colspec colname='c2'/>
@@ -3380,6 +3385,12 @@ ip6 filter output log flags all
 								<entry>Connection tracking label</entry>
 								<entry>label</entry>
 							</row>
+							<row>
+								<entry>zone</entry>
+								<entry>conntrack zone</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+
 						</tbody>
 					</tgroup>
 				</table>
@@ -3391,6 +3402,21 @@ ip6 filter output log flags all
 ct set mark meta mark
 					</programlisting>
 				</example>
+				<example>
+					<title>set zone mapped via interface</title>
+				<programlisting>
+table inet raw {
+  chain prerouting {
+      type filter hook prerouting priority -300;
+      ct zone set iif map { "eth1" : 1, "veth1" : 2 }
+  }
+  chain output {
+      type filter hook output priority -300;
+      ct zone set oif map { "eth1" : 1, "veth1" : 2 }
+  }
+}
+				</programlisting>
+			</example>
 			</para>
 		</refsect2>
 		<refsect2>
-- 
2.10.2

