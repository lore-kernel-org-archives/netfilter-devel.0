From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH RFC 2/2] nft.8: Make use of synopfragment in synopsis section
Date: Thu, 17 Aug 2017 15:39:00 +0200
Message-ID: <20170817133900.21946-3-phil@nwl.cc>
References: <20170817133900.21946-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:54679 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdHQNjZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 09:39:25 -0400
In-Reply-To: <20170817133900.21946-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This introduces an element of indirection to list common options in
a separate place and allows to put each of the three invocation variants
onto it's own line.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
While I think readability has increased quite a bit, I don't like how
docbook formats these references: Having a name at the reference point
but not at the target is kind of unintuitive.

Another issue is that I couldn't get it to print the repeat marker
('...') inside of the brackets when referencing OPTIONS - it would end
up past the closing bracket, which appears wrong to my eye. So I used
this double indirection as one would without that repeat marker, which
didn't really improve it.
---
 doc/nft.xml | 112 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 64 insertions(+), 48 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 191a4c12f8487..2942849d8b15f 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -45,67 +45,83 @@ vi:ts=4 sw=4
 	<refsynopsisdiv>
 		<cmdsynopsis>
 			<command>nft</command>
-			<group>
-				<arg><option>-n</option></arg>
-				<arg><option>--numeric</option></arg>
-			</group>
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
+			<arg>
+				<synopfragmentref linkend="opts">OPTIONS</synopfragmentref>
+			</arg>
+			<group choice="req">
+				<arg><option>-f</option></arg>
+				<arg><option>--file</option></arg>
 			</group>
+			<replaceable>filename</replaceable>
+		</cmdsynopsis>
+		<cmdsynopsis>
+			<command>nft</command>
 			<arg>
-				<group choice="req">
-					<arg><option>-I</option></arg>
-					<arg><option>--includepath</option></arg>
-				</group>
-				<replaceable>directory</replaceable>
+				<synopfragmentref linkend="opts">OPTIONS</synopfragmentref>
 			</arg>
-			<group>
-				<arg>
-					<group choice="req">
-						<arg><option>-f</option></arg>
-						<arg><option>--file</option></arg>
-					</group>
-					<replaceable>filename</replaceable>
-				</arg>
-				<arg>
-					<group choice="req">
-						<arg><option>-i</option></arg>
-						<arg><option>--interactive</option></arg>
-					</group>
-				</arg>
-				<arg rep="repeat">
-					<replaceable>cmd</replaceable>
-				</arg>
+			<group choice="req">
+				<arg><option>-i</option></arg>
+				<arg><option>--interactive</option></arg>
 			</group>
 		</cmdsynopsis>
 		<cmdsynopsis>
 			<command>nft</command>
-			<group>
+			<arg>
+				<synopfragmentref linkend="opts">OPTIONS</synopfragmentref>
+			</arg>
+			<arg choice="plain" rep="repeat">
+				<replaceable>cmd</replaceable>
+			</arg>
+		</cmdsynopsis>
+		<cmdsynopsis>
+			<command>nft</command>
+			<group choice="req">
 				<arg><option>-h</option></arg>
 				<arg><option>--help</option></arg>
-			</group>
-			<group>
 				<arg><option>-v</option></arg>
 				<arg><option>--version</option></arg>
 			</group>
 		</cmdsynopsis>
+		<cmdsynopsis>
+			<synopfragment id="opts">
+				<arg choice="plain" rep="repeat">
+					<synopfragmentref linkend="opt">OPTION</synopfragmentref>
+				</arg>
+			</synopfragment>
+			<synopfragment id="opt">
+				<group>
+					<arg><option>-n</option></arg>
+					<arg><option>--numeric</option></arg>
+				</group>
+				<group>
+					<arg><option>-N</option></arg>
+					<arg><option>--reversedns</option></arg>
+				</group>
+				<group>
+					<arg><option>-s</option></arg>
+					<arg><option>--stateless</option></arg>
+				</group>
+				<group>
+					<arg><option>-c</option></arg>
+					<arg><option>--check</option></arg>
+				</group>
+				<group>
+					<arg><option>-a</option></arg>
+					<arg><option>--handle</option></arg>
+				</group>
+				<group>
+					<arg><option>-e</option></arg>
+					<arg><option>--echo</option></arg>
+				</group>
+				<arg>
+					<group choice="req">
+						<arg><option>-I</option></arg>
+						<arg><option>--includepath</option></arg>
+					</group>
+					<replaceable>directory</replaceable>
+				</arg>
+			</synopfragment>
+		</cmdsynopsis>
 	</refsynopsisdiv>
 
 	<refsect1>
-- 
2.13.1

