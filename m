From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] doc: Update datatypes
Date: Sun, 5 Jun 2016 00:33:31 +0200
Message-ID: <20160604223328.GA30197@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36402 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbcFDWdg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Jun 2016 18:33:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id m124so6379313wme.3
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Jun 2016 15:33:35 -0700 (PDT)
Received: from sonyv (128.red-176-84-210.dynamicip.rima-tde.net. [176.84.210.128])
        by smtp.gmail.com with ESMTPSA id y3sm12525579wji.40.2016.06.04.15.33.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Sat, 04 Jun 2016 15:33:33 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check and update nft parameter datatypes.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 doc/nft.xml | 42 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 26 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index b9f3c69..ea47e2b 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1029,12 +1029,12 @@ filter output ip6 daddr ::1
 							<row>
 								<entry>priority</entry>
 								<entry>TC packet priority</entry>
-								<entry>integer (32 bit)</entry>
+								<entry>tc_handle</entry>
 							</row>
 							<row>
 								<entry>mark</entry>
 								<entry>Packet mark</entry>
-								<entry>packetmark</entry>
+								<entry>mark</entry>
 							</row>
 							<row>
 								<entry>iif</entry>
@@ -1104,12 +1104,12 @@ filter output ip6 daddr ::1
 							<row>
 								<entry>iifgroup</entry>
 								<entry>incoming device group</entry>
-								<entry>devgroup_type</entry>
+								<entry>devgroup</entry>
 							</row>
 							<row>
 								<entry>oifgroup</entry>
 								<entry>outgoing device group</entry>
-								<entry>devgroup_type</entry>
+								<entry>devgroup</entry>
 							</row>
 							<row>
 								<entry>cgroup</entry>
@@ -1287,7 +1287,7 @@ filter output oif eth0
 							<row>
 								<entry>cfi</entry>
 								<entry>Canonical Format Indicator</entry>
-								<entry>flag</entry>
+								<entry>integer (1 bit)</entry>
 							</row>
 							<row>
 								<entry>pcp</entry>
@@ -1297,7 +1297,7 @@ filter output oif eth0
 							<row>
 								<entry>type</entry>
 								<entry>EtherType</entry>
-								<entry>ethertype</entry>
+								<entry>ether_type</entry>
 							</row>
 						</tbody>
 					</tgroup>
@@ -1336,7 +1336,7 @@ filter output oif eth0
 							<row>
 								<entry>ptype</entry>
 								<entry>EtherType</entry>
-								<entry>ethertype</entry>
+								<entry>ether_type</entry>
 							</row>
 							<row>
 								<entry>hlen</entry>
@@ -1395,12 +1395,12 @@ filter output oif eth0
 							<row>
 								<entry>dscp</entry>
 								<entry>Differentiated Services Code Point</entry>
-								<entry>integer (6 bit)</entry>
+								<entry>dscp</entry>
 							</row>
 							<row>
 								<entry>ecn</entry>
 								<entry>Explicit Congestion Notification</entry>
-								<entry>integer (2 bit)</entry>
+								<entry>ecn</entry>
 							</row>
 							<row>
 								<entry>length</entry>
@@ -1477,19 +1477,14 @@ filter output oif eth0
 								<entry>integer (4 bit)</entry>
 							</row>
 							<row>
-								<entry>priority</entry>
-								<entry></entry>
-								<entry></entry>
-							</row>
-							<row>
 								<entry>dscp</entry>
 								<entry>Differentiated Services Code Point</entry>
-								<entry>integer (6 bit)</entry>
+								<entry>dscp</entry>
 							</row>
 							<row>
 								<entry>ecn</entry>
 								<entry>Explicit Congestion Notification</entry>
-								<entry>integer (2 bit)</entry>
+								<entry>ecn</entry>
 							</row>
 							<row>
 								<entry>flowlabel</entry>
@@ -1583,7 +1578,7 @@ filter output oif eth0
 							<row>
 								<entry>flags</entry>
 								<entry>TCP flags</entry>
-								<entry>tcp_flags</entry>
+								<entry>tcp_flag</entry>
 							</row>
 							<row>
 								<entry>window</entry>
@@ -1689,11 +1684,6 @@ filter output oif eth0
 								<entry>inet_service</entry>
 							</row>
 							<row>
-								<entry>cscov</entry>
-								<entry>Checksum coverage</entry>
-								<entry>integer (16 bit)</entry>
-							</row>
-							<row>
 								<entry>checksum</entry>
 								<entry>Checksum</entry>
 								<entry>integer (16 bit)</entry>
@@ -1819,7 +1809,7 @@ filter output oif eth0
 							<row>
 								<entry>nexthdr</entry>
 								<entry>Next header protocol</entry>
-								<entry>inet_service</entry>
+								<entry>inet_proto</entry>
 							</row>
 							<row>
 								<entry>hdrlength</entry>
@@ -1829,7 +1819,7 @@ filter output oif eth0
 							<row>
 								<entry>reserved</entry>
 								<entry>Reserved area</entry>
-								<entry>integer (4 bit)</entry>
+								<entry>integer (16 bit)</entry>
 							</row>
 							<row>
 								<entry>spi</entry>
@@ -1912,7 +1902,7 @@ filter output oif eth0
 							<row>
 								<entry>nexthdr</entry>
 								<entry>Next header protocol</entry>
-								<entry>inet_service</entry>
+								<entry>inet_proto</entry>
 							</row>
 							<row>
 								<entry>flags</entry>
@@ -2015,7 +2005,7 @@ filter output oif eth0
 							<row>
 								<entry>mark</entry>
 								<entry>Connection mark</entry>
-								<entry>packetmark</entry>
+								<entry>mark</entry>
 							</row>
 							<row>
 								<entry>expiration</entry>
-- 
2.7.0

