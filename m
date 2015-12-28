From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] doc: update meta and ct expression keyword lists
Date: Mon, 28 Dec 2015 22:07:33 +0100
Message-ID: <1451336853-30224-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:56661 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887AbbL1VS3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 16:18:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
I'll update ct once I know how the directional key support patch
set turns out.

diff --git a/doc/nft.xml b/doc/nft.xml
index d51876c..dbc9cd5 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -982,6 +982,13 @@ filter output ip6 daddr ::1
 						<arg>skgid</arg>
 						<arg>nftrace</arg>
 						<arg>rtclassid</arg>
+						<arg>ibriport</arg>
+						<arg>obriport</arg>
+						<arg>pkttype</arg>
+						<arg>cpu</arg>
+						<arg>iifgroup</arg>
+						<arg>oifgroup</arg>
+						<arg>cgroup</arg>
 					</group>
 				</cmdsynopsis>
 			</para>
@@ -1074,6 +1081,41 @@ filter output ip6 daddr ::1
 								<entry>Routing realm</entry>
 								<entry>realm</entry>
 							</row>
+							<row>
+								<entry>ibriport</entry>
+								<entry>Input bridge interface name</entry>
+								<entry>string</entry>
+							</row>
+							<row>
+								<entry>obriport</entry>
+								<entry>Output bridge interface name</entry>
+								<entry>string</entry>
+							</row>
+							<row>
+								<entry>pkttype</entry>
+								<entry>packet type</entry>
+								<entry>pkt_type</entry>
+							</row>
+							<row>
+								<entry>cpu</entry>
+								<entry>cpu number processing the packet</entry>
+								<entry>integer (32 bits)</entry>
+							</row>
+							<row>
+								<entry>iifgroup</entry>
+								<entry>incoming device group</entry>
+								<entry>devgroup_type</entry>
+							</row>
+							<row>
+								<entry>oifgroup</entry>
+								<entry>outgoing device group</entry>
+								<entry>devgroup_type</entry>
+							</row>
+							<row>
+								<entry>cgroup</entry>
+								<entry>control group id</entry>
+								<entry>integer (32 bits)</entry>
+							</row>
 						</tbody>
 					</tgroup>
 				</table>
@@ -1131,6 +1173,20 @@ filter output ip6 daddr ::1
 									or as symbolic name defined in /etc/iproute2/rt_realms.
 								</entry>
 							</row>
+							<row>
+								<entry>devgroup_type</entry>
+								<entry>
+									Device group (32 bit number). Can be specified numerically
+									or as symbolic name defined in /etc/iproute2/group.
+								</entry>
+							</row>
+							<row>
+								<entry>pkt_type</entry>
+								<entry>
+									Packet type: Unicast (addressed to local host),
+									Broadcast (to all), Multicast (to group).
+								</entry>
+							</row>
 						</tbody>
 					</tgroup>
 				</table>
@@ -1884,6 +1940,7 @@ filter output oif eth0
 						<arg>mark</arg>
 						<arg>expiration</arg>
 						<arg>helper</arg>
+						<arg>label</arg>
 						<arg>l3proto</arg>
 						<arg>saddr</arg>
 						<arg>daddr</arg>
@@ -1939,6 +1996,11 @@ filter output oif eth0
 								<entry>string</entry>
 							</row>
 							<row>
+								<entry>label</entry>
+								<entry>Connection tracking label</entry>
+								<entry>ct_label</entry>
+							</row>
+							<row>
 								<entry>l3proto</entry>
 								<entry>Layer 3 protocol of the connection</entry>
 								<entry>nf_proto FIXME</entry>
-- 
2.4.10

