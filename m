From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH] doc: nft.8 simplify initial SYNOPSIS line
Date: Fri, 20 Oct 2017 22:29:15 +1100
Message-ID: <20171020112915.5859-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39126 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752172AbdJTL3c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 07:29:32 -0400
Received: from dimstar.local.net (c220-239-36-238.eburwd6.vic.optusnet.com.au [220.239.36.238])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id BF08910495F5
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 22:29:17 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the style of tcpdump.8: where options have short and long forms, only show
short form in synopsis but mention long form in description.
Re-order option descriptions to match order in synopsis (move -N to just after -n).

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/nft.xml | 66 +++++++++++++------------------------------------------------
 1 file changed, 14 insertions(+), 52 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 86b4bd9..2dec0aa 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -46,49 +46,16 @@ vi:ts=4 sw=4
 		<cmdsynopsis>
 			<command>nft</command>
 			<group>
-				<arg><option>-n</option></arg>
-				<arg><option>--numeric</option></arg>
+				<arg><option> -nNscae </option></arg>
 			</group>
-			<group>
-				<arg><option>-N</option></arg>
-				<arg><option>--reversedns</option></arg>
-			</group>
-			<group>
-				<arg><option>-s</option></arg>
-				<arg><option>--stateless</option></arg>
-			</group>
-			<group>
-				<arg><option>-c</option></arg>
-				<arg><option>--check</option></arg>
-			</group>
-			<group>
-				<arg><option>-a</option></arg>
-				<arg><option>--handle</option></arg>
-			</group>
-			<group>
-				<arg><option>-e</option></arg>
-				<arg><option>--echo</option></arg>
-			</group>
-			<arg>
-				<group choice="req">
-					<arg><option>-I</option></arg>
-					<arg><option>--includepath</option></arg>
-				</group>
+			<arg> -I
 				<replaceable>directory</replaceable>
 			</arg>
 			<group>
-				<arg>
-					<group choice="req">
-						<arg><option>-f</option></arg>
-						<arg><option>--file</option></arg>
-					</group>
+				<arg> -f
 					<replaceable>filename</replaceable>
 				</arg>
-				<arg>
-					<group choice="req">
-						<arg><option>-i</option></arg>
-						<arg><option>--interactive</option></arg>
-					</group>
+				<arg> -i
 				</arg>
 				<arg rep="repeat">
 					<replaceable>cmd</replaceable>
@@ -96,15 +63,10 @@ vi:ts=4 sw=4
 			</group>
 		</cmdsynopsis>
 		<cmdsynopsis>
-			<command>nft</command>
-			<group>
-				<arg><option>-h</option></arg>
-				<arg><option>--help</option></arg>
-			</group>
-			<group>
-				<arg><option>-v</option></arg>
-				<arg><option>--version</option></arg>
-			</group>
+			<command>nft -h</command>
+		</cmdsynopsis>
+		<cmdsynopsis>
+			<command>nft -v</command>
 		</cmdsynopsis>
 	</refsynopsisdiv>
 
@@ -151,26 +113,26 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-s, --stateless</option></term>
+				<term><option>-N, --reversedns</option></term>
 				<listitem>
 					<para>
-						Omit stateful information of rules and stateful objects.
+						Translate IP addresses to names. Usually requires network traffic for DNS lookup.
 					</para>
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-c, --check</option></term>
+				<term><option>-s, --stateless</option></term>
 				<listitem>
 					<para>
-						Check commands validity without actually applying the changes.
+						Omit stateful information of rules and stateful objects.
 					</para>
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-N, --reversedns</option></term>
+				<term><option>-c, --check</option></term>
 				<listitem>
 					<para>
-						Translate IP addresses to names. Usually requires network traffic for DNS lookup.
+						Check commands validity without actually applying the changes.
 					</para>
 				</listitem>
 			</varlistentry>
-- 
2.9.0

