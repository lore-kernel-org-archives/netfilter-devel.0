From: FaTe <gokuvsvegita@gmail.com>
Subject: [PATCH v2] doc: nft: Fixed a typo and added/changed punctuation
Date: Tue, 8 Mar 2016 19:57:15 +0530
Message-ID: <56DEE143.60604@gmail.com>
References: <20160307145420.GA4852@fate> <20160307180600.GA6777@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34246 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbcCHO1G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 09:27:06 -0500
Received: by mail-pf0-f194.google.com with SMTP id 184so1352108pff.1
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Mar 2016 06:27:04 -0800 (PST)
In-Reply-To: <20160307180600.GA6777@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In nft's man page , instead of using '/' between shortopt and longopt in the
"SYNOPSIS" and "OPTIONS" section , use '|' and ',' respectively.
(just like the man pages of iptables, etc.)

Fixed a typo and added missing ',' .

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 doc/nft.xml | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 7cc9988..e4d227c 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -34,19 +34,19 @@ vi:ts=4 sw=4
 		<cmdsynopsis>
 			<command>nft</command>
 			<arg choice="opt">
-				<option>-n/--numeric</option>
+				<option>-n | --numeric</option>
 			</arg>
 			<arg choice="opt">
-				<option>-I/--includepath</option>
+				<option>[-I | --includepath]</option>
 				<replaceable>directory</replaceable>
 			</arg>
 			<group>
 				<arg choice="opt">
-					<option>-f/--file</option>
+					<option>[-f | --file]</option>
 					<replaceable>filename</replaceable>
 				</arg>
 				<arg choice="opt">
-					<option>-i/--interactive</option>
+					<option>[-i | --interactive]</option>
 				</arg>
 				<arg choice="opt" rep="repeat">
 					<replaceable>cmd</replaceable>
@@ -56,10 +56,10 @@ vi:ts=4 sw=4
 		<cmdsynopsis>
 			<command>nft</command>
 			<arg choice="opt">
-				<option>-h/--help</option>
+				<option>-h | --help</option>
 			</arg>
 			<arg choice="opt">
-				<option>-v/--version</option>
+				<option>-v | --version</option>
 			</arg>
 		</cmdsynopsis>
 	</refsynopsisdiv>
@@ -80,7 +80,7 @@ vi:ts=4 sw=4
 
 		<variablelist>
 			<varlistentry>
-				<term><option>-h/--help</option></term>
+				<term><option>-h, --help</option></term>
 				<listitem>
 					<para>
 						Show help message and all options.
@@ -88,7 +88,7 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-v/--version</option></term>
+				<term><option>-v, --version</option></term>
 				<listitem>
 					<para>
 						Show version.
@@ -96,7 +96,7 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-n/--numeric</option></term>
+				<term><option>-n, --numeric</option></term>
 				<listitem>
 					<para>
 						Numeric output: Addresses and other information
@@ -117,7 +117,7 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-a/--handle</option></term>
+				<term><option>-a, --handle</option></term>
 				<listitem>
 					<para>
 						Show rule handles in output.
@@ -125,15 +125,15 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-I/--includepath <replaceable>directory</replaceable></option></term>
+				<term><option>-I, --includepath <replaceable>directory</replaceable></option></term>
 				<listitem>
 					<para>
-						Add the directory <replaceable>directory</replaceable> to the list of directories to by searched for included files.
+						Add the directory <replaceable>directory</replaceable> to the list of directories to be searched for included files.
 					</para>
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-f/--file <replaceable>filename</replaceable></option></term>
+				<term><option>-f, --file <replaceable>filename</replaceable></option></term>
 				<listitem>
 					<para>
 						Read input from <replaceable>filename</replaceable>.
@@ -141,7 +141,7 @@ vi:ts=4 sw=4
 				</listitem>
 			</varlistentry>
 			<varlistentry>
-				<term><option>-i/--interactive</option></term>
+				<term><option>-i, --interactive</option></term>
 				<listitem>
 					<para>
 						Read input from an interactive readline CLI.
@@ -156,8 +156,8 @@ vi:ts=4 sw=4
 		<refsect2>
 			<title>Lexical conventions</title>
 			<para>
-				Input is parsed line-wise. When the last character of a line just before
-				the newline character is a non-quoted backslash (<literal>\</literal>),
+				Input is parsed line-wise. When the last character of a line, just before
+				the newline character, is a non-quoted backslash (<literal>\</literal>),
 				the next line is treated as a continuation. Multiple commands on the
 				same line can be separated using a semicolon (<literal>;</literal>).
 			</para>
-- 
1.9.1
