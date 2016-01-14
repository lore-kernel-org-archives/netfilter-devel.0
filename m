From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] doc: update ct expression
Date: Thu, 14 Jan 2016 04:56:57 +0100
Message-ID: <1452743817-28261-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33760 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbcAND5J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 22:57:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index dbc9cd5..7cc9988 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1931,6 +1931,13 @@ filter output oif eth0
 				Conntrack expressions refer to meta data of the connection tracking entry associated with a packet.
 			</para>
 			<para>
+				There are three types of conntrack expressions. Some conntrack expressions require the flow
+				direction before the conntrack key, others must be used directly because they are
+				direction agnostic.  The <command>packets<command> and </command>bytes</command> keywords can be used
+				with or without a direction.  If the direction is omitted, the sum of the original and the reply
+				direction is returned.
+			</para>
+			<para>
 				<cmdsynopsis>
 					<command>ct</command>
 					<group choice="req">
@@ -1941,12 +1948,22 @@ filter output oif eth0
 						<arg>expiration</arg>
 						<arg>helper</arg>
 						<arg>label</arg>
-						<arg>l3proto</arg>
-						<arg>saddr</arg>
-						<arg>daddr</arg>
-						<arg>protocol</arg>
-						<arg>proto-src</arg>
-						<arg>proto-dst</arg>
+						<arg>bytes</arg>
+						<arg>packets</arg>
+					</group>
+					<group choice="req">
+						<arg>original</arg>
+						<arg>reply</arg>
+						<group choice="req">
+							<arg>l3proto</arg>
+							<arg>protocol</arg>
+							<arg>saddr</arg>
+							<arg>daddr</arg>
+							<arg>proto-src</arg>
+							<arg>proto-dst</arg>
+							<arg>bytes</arg>
+							<arg>packets</arg>
+						</group>
 					</group>
 				</cmdsynopsis>
 			</para>
@@ -2003,7 +2020,7 @@ filter output oif eth0
 							<row>
 								<entry>l3proto</entry>
 								<entry>Layer 3 protocol of the connection</entry>
-								<entry>nf_proto FIXME</entry>
+								<entry>nf_proto</entry>
 							</row>
 							<row>
 								<entry>saddr</entry>
@@ -2023,12 +2040,22 @@ filter output oif eth0
 							<row>
 								<entry>proto-src</entry>
 								<entry>Layer 4 protocol source for the given direction</entry>
-								<entry>FIXME</entry>
+								<entry>integer (16 bit)</entry>
 							</row>
 							<row>
 								<entry>proto-dst</entry>
 								<entry>Layer 4 protocol destination for the given direction</entry>
-								<entry>FIXME</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
+							<row>
+								<entry>packets</entry>
+								<entry>packet count seen in the given direction or sum of original and reply</entry>
+								<entry>integer (64 bit)</entry>
+							</row>
+							<row>
+								<entry>bytes</entry>
+								<entry>bytecount seen, see description for <command>packets</command> keyword</entry>
+								<entry>integer (64 bit)</entry>
 							</row>
 						</tbody>
 					</tgroup>
-- 
2.4.10

