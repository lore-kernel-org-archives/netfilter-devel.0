From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] nft.8: Fix and enhance synopsis section
Date: Thu, 17 Aug 2017 15:38:59 +0200
Message-ID: <20170817133900.21946-2-phil@nwl.cc>
References: <20170817133900.21946-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39055 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdHQNjT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 09:39:19 -0400
In-Reply-To: <20170817133900.21946-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch addresses shortcomings in the main synopsis section
illustrating possible invocations of nft command:

- Fix font styles to correctly put options into bold font and meta
  characters (brackets, pipes) into normal font.

- Add missing options to synopsis line.

- Use curly braces where either one of the alternatives is required.

- Remove choice="opt" attribute since that is the default anyway.

- Note that --includepath option is allowed to be given multiple times.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/nft.xml | 74 +++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index d7aae3f03b8c1..191a4c12f8487 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -45,40 +45,66 @@ vi:ts=4 sw=4
 	<refsynopsisdiv>
 		<cmdsynopsis>
 			<command>nft</command>
-			<arg choice="opt">
-				<option>-n | --numeric</option>
-			</arg>
-			<arg choice="opt">
-				<option>-s | --stateless</option>
-			</arg>
-			<arg choice="opt">
-				<option>-c | --check</option>
-			</arg>
-			<arg choice="opt">
-				<option>[-I | --includepath]</option>
+			<group>
+				<arg><option>-n</option></arg>
+				<arg><option>--numeric</option></arg>
+			</group>
+			<group>
+				<arg><option>-N</option></arg>
+				<arg><option>--reversedns</option></arg>
+			</group>
+			<group>
+				<arg><option>-s</option></arg>
+				<arg><option>--stateless</option></arg>
+			</group>
+			<group>
+				<arg><option>-c</option></arg>
+				<arg><option>--check</option></arg>
+			</group>
+			<group>
+				<arg><option>-a</option></arg>
+				<arg><option>--handle</option></arg>
+			</group>
+			<group>
+				<arg><option>-e</option></arg>
+				<arg><option>--echo</option></arg>
+			</group>
+			<arg>
+				<group choice="req">
+					<arg><option>-I</option></arg>
+					<arg><option>--includepath</option></arg>
+				</group>
 				<replaceable>directory</replaceable>
 			</arg>
 			<group>
-				<arg choice="opt">
-					<option>[-f | --file]</option>
+				<arg>
+					<group choice="req">
+						<arg><option>-f</option></arg>
+						<arg><option>--file</option></arg>
+					</group>
 					<replaceable>filename</replaceable>
 				</arg>
-				<arg choice="opt">
-					<option>[-i | --interactive]</option>
+				<arg>
+					<group choice="req">
+						<arg><option>-i</option></arg>
+						<arg><option>--interactive</option></arg>
+					</group>
 				</arg>
-				<arg choice="opt" rep="repeat">
+				<arg rep="repeat">
 					<replaceable>cmd</replaceable>
 				</arg>
 			</group>
 		</cmdsynopsis>
 		<cmdsynopsis>
 			<command>nft</command>
-			<arg choice="opt">
-				<option>-h | --help</option>
-			</arg>
-			<arg choice="opt">
-				<option>-v | --version</option>
-			</arg>
+			<group>
+				<arg><option>-h</option></arg>
+				<arg><option>--help</option></arg>
+			</group>
+			<group>
+				<arg><option>-v</option></arg>
+				<arg><option>--version</option></arg>
+			</group>
 		</cmdsynopsis>
 	</refsynopsisdiv>
 
@@ -141,7 +167,7 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-N</option></term>
+				<term><option>-N, --reversedns</option></term>
 				<listitem>
 					<para>
 						Translate IP addresses to names. Usually requires network traffic for DNS lookup.
@@ -170,7 +196,7 @@ vi:ts=4 sw=4
 				<term><option>-I, --includepath <replaceable>directory</replaceable></option></term>
 				<listitem>
 					<para>
-						Add the directory <replaceable>directory</replaceable> to the list of directories to be searched for included files.
+						Add the directory <replaceable>directory</replaceable> to the list of directories to be searched for included files. This option may be specified multiple times.
 					</para>
 				</listitem>
 			</varlistentry>
-- 
2.13.1

