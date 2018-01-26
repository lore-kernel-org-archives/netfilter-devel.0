From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] doc: dup and fwd statements
Date: Fri, 26 Jan 2018 14:27:12 +0100
Message-ID: <20180126132712.7416-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58650 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751412AbeAZN1Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 08:27:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 6a95ea6..d5b9c27 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -5000,6 +5000,86 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 				</table>
 			</para>
 		</refsect2>
+		<refsect2>
+			<title>Dup statement</title>
+			<para>
+				The dup statement is used to duplicate a packet and send the copy to a different destination.
+			</para>
+			<para>
+				<cmdsynopsis>
+						<command>dup</command>
+						<arg choice="none">to
+						<replaceable>device</replaceable></arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+						<command>dup</command>
+						<arg choice="none">to
+						<replaceable>address</replaceable>
+						<arg choice="none">device</arg>
+						<replaceable>device</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+			<para>
+				<table frame="all">
+				<title>Dup statement values</title>
+					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<colspec colname='c3'/>
+						<thead>
+							<row>
+								<entry>Expression</entry>
+								<entry>Description</entry>
+								<entry>Type</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>address</entry>
+								<entry>Specifies that the copy of the packet should be sent to a new gateway.</entry>
+								<entry>ipv4_addr, ipv6_addr, eg. abcd::1234, or you can use a mapping, eg. ip saddr map { 192.168.1.2 : 10.1.1.1 }</entry>
+							</row>
+							<row>
+								<entry>device</entry>
+								<entry>Specifies that the copy should be transmitted via device.</entry>
+								<entry>string</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
+			</para>
+			<para>
+				<example>
+					<title>Using the dup statement</title>
+					<programlisting>
+# send to machine with ip address 10.2.3.4 on eth0
+ip filter forward dup to 10.2.3.4 device "eth0"
+
+# copy raw frame to another interface
+netdetv ingress dup to "eth0"
+dup to "eth0"
+
+# combine with map dst addr to gateways
+dup to ip daddr map { 192.168.7.1 : "eth0", 192.168.7.2 : "eth1" }
+					</programlisting>
+				</example>
+			</para>
+		</refsect2>
+		<refsect2>
+			<title>Fwd statement</title>
+			<para>
+				The fwd statement is used to redirect a raw packet to another interface.  Its is only available in the netdev family ingress hook.
+				It is similar to the dup statement except that no copy is made.
+			</para>
+			<para>
+				<cmdsynopsis>
+						<command>fwd</command>
+						<arg choice="none">to
+						<replaceable>device</replaceable></arg>
+				</cmdsynopsis>
+			</para>
+		</refsect2>
+
 	</refsect1>
 
 	<refsect1>
-- 
2.14.3

