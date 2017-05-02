From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH] nft.8: Enhance NAT documentation
Date: Tue,  2 May 2017 19:51:27 +0200
Message-ID: <20170502175127.30805-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:46799 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750864AbdEBRvk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2017 13:51:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds documentation about masquerade and redirect statements, points
out that for any NAT statement both prerouting and postrouting chains
are required and adds a bunch of examples to the section's end.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 57 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 4d0e89cd2054c..5680cdf1f5a22 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -4121,12 +4121,45 @@ ct eventmask set new or related or destroy
 						<arg choice="opt">:<replaceable>port</replaceable> - <replaceable>port</replaceable></arg></arg>
 						<arg choice="opt">persistent, random, fully-random</arg>
 				</cmdsynopsis>
+				<cmdsynopsis>
+						<command>masquerade</command>
+						<arg choice="none">to
+						<arg choice="opt">:<replaceable>port</replaceable></arg></arg>
+						<arg choice="opt">persistent, random, fully-random</arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+						<command>masquerade</command>
+						<arg choice="none">to
+						<arg choice="opt">:<replaceable>port</replaceable> - <replaceable>port</replaceable></arg></arg>
+						<arg choice="opt">persistent, random, fully-random</arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+						<command>redirect</command>
+						<arg choice="none">to
+						<arg choice="opt">:<replaceable>port</replaceable></arg></arg>
+						<arg choice="opt">persistent, random, fully-random</arg>
+				</cmdsynopsis>
+				<cmdsynopsis>
+						<command>redirect</command>
+						<arg choice="none">to
+						<arg choice="opt">:<replaceable>port</replaceable> - <replaceable>port</replaceable></arg></arg>
+						<arg choice="opt">persistent, random, fully-random</arg>
+				</cmdsynopsis>
 			</para>
 			<para>
 				The nat statements are only valid from nat chain types.
 			</para>
 			<para>
-				The <command>snat</command> statement is only valid in the postrouting and input hooks, it specifies that the source address of the packet should be modified. The <command>dnat</command> statement is only valid in the prerouting and output chains, it specifies that the destination address of the packet should be modified. You can use non-base chains which are called from base chains of nat chain type too. All future packets in this connection will also be mangled, and rules should cease being examined.
+				The <command>snat</command> and <command>masquerade</command> statements specify that the source address of the packet should be modified. While <command>snat</command> is only valid in the postrouting and input chains, <command>masquerade</command> makes sense only in postrouting. The <command>dnat</command> and <command>redirect</command> statements are only valid in the prerouting and output chains, they specify that the destination address of the packet should be modified. You can use non-base chains which are called from base chains of nat chain type too. All future packets in this connection will also be mangled, and rules should cease being examined.
+			</para>
+			<para>
+				The <command>masquerade</command> statement is a special form of <command>snat</command> which always uses the outgoing interface's IP address to translate to. It is particularly useful on gateways with dynamic (public) IP addresses.
+			</para>
+			<para>
+				The <command>redirect</command> statement is a special form of <command>dnat</command> which always translates the destination address to the local host's one. It comes in handy if one only wants to alter the destination port of incoming traffic on different interfaces.
+			</para>
+			<para>
+				Note that all nat statements require both prerouting and postrouting base chains to be present since otherwise packets on the return path won't be seen by netfilter and therefore no reverse translation will take place.
 			</para>
 			<para>
 				<table frame="all">
@@ -4183,7 +4216,30 @@ ct eventmask set new or related or destroy
 						</tbody>
 					</tgroup>
 				</table>
+			</para>
+			<para>
+				<example>
+					<title>Using NAT statements</title>
+					<programlisting>
+# create a suitable table/chain setup for all further examples
+add table nat
+add chain nat prerouting { type nat hook prerouting priority 0; }
+add chain nat postrouting { type nat hook postrouting priority 100; }
+
+# translate source addresses of all packets leaving via eth0 to address 1.2.3.4
+add rule nat postrouting oif eth0 snat to 1.2.3.4
 
+# redirect all traffic entering via eth0 to destination address 192.168.1.120
+add rule nat prerouting iif eth0 dnat to 192.168.1.120
+
+# translate source addresses of all packets leaving via eth0 to whatever
+# locally generated packets would use as source to reach the same destination
+add rule nat postrouting oif eth0 masquerade
+
+# redirect incoming TCP traffic for port 22 to port 2222
+add rule nat prerouting tcp dport 22 redirect to :2222
+					</programlisting>
+				</example>
 			</para>
 		</refsect2>
 		<refsect2>
-- 
2.11.0

