From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] doc: fix old parameters and update datatypes
Date: Thu, 2 Jun 2016 00:25:13 +0200
Message-ID: <20160601222511.GA4314@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33605 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbcFAWZS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 18:25:18 -0400
Received: by mail-wm0-f68.google.com with SMTP id a136so10760373wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 15:25:17 -0700 (PDT)
Received: from sonyv ([213.143.50.104])
        by smtp.gmail.com with ESMTPSA id g192sm34887801wme.15.2016.06.01.15.25.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 01 Jun 2016 15:25:16 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix old identifiers like 'ipcomp' and 'op' with 'comp' and 'operation'
instead. Update some FIXME datatypes.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 doc/nft.xml | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 0ebf51a..b9f3c69 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1331,7 +1331,7 @@ filter output oif eth0
 							<row>
 								<entry>htype</entry>
 								<entry>ARP hardware type</entry>
-								<entry>FIXME</entry>
+								<entry>integer (16 bit)</entry>
 							</row>
 							<row>
 								<entry>ptype</entry>
@@ -1349,9 +1349,9 @@ filter output oif eth0
 								<entry>integer (8 bit)</entry>
 							</row>
 							<row>
-								<entry>op</entry>
+								<entry>operation</entry>
 								<entry>Operation</entry>
-								<entry>FIXME</entry>
+								<entry>arp_op</entry>
 							</row>
 						</tbody>
 					</tgroup>
@@ -1578,7 +1578,7 @@ filter output oif eth0
 							<row>
 								<entry>reserved</entry>
 								<entry>Reserved area</entry>
-								<entry>FIXME</entry>
+								<entry>integer (4 bit)</entry>
 							</row>
 							<row>
 								<entry>flags</entry>
@@ -1829,7 +1829,7 @@ filter output oif eth0
 							<row>
 								<entry>reserved</entry>
 								<entry>Reserved area</entry>
-								<entry>FIXME</entry>
+								<entry>integer (4 bit)</entry>
 							</row>
 							<row>
 								<entry>spi</entry>
@@ -1890,7 +1890,7 @@ filter output oif eth0
 			<title>IPcomp header expression</title>
 			<para>
 				<cmdsynopsis>
-					<command>ipcomp</command>
+					<command>comp</command>
 					<arg opt="req"><replaceable>IPComp header field</replaceable></arg>
 				</cmdsynopsis>
 			</para>
@@ -1917,12 +1917,12 @@ filter output oif eth0
 							<row>
 								<entry>flags</entry>
 								<entry>Flags</entry>
-								<entry>FIXME</entry>
+								<entry>bitmask</entry>
 							</row>
 							<row>
 								<entry>cpi</entry>
 								<entry>Compression Parameter Index</entry>
-								<entry>FIXME</entry>
+								<entry>integer (16 bit)</entry>
 							</row>
 						</tbody>
 					</tgroup>
-- 
2.7.0

