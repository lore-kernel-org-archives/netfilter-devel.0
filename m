From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: [PATCH] doc: nft: Fixed a typo and added/changed punctuation
Date: Mon, 7 Mar 2016 20:24:20 +0530
Message-ID: <20160307145420.GA4852@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36074 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbcCGOyF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 09:54:05 -0500
Received: by mail-pa0-f65.google.com with SMTP id 1so2222088pal.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2016 06:54:05 -0800 (PST)
Received: from fate ([14.139.254.36])
        by smtp.gmail.com with ESMTPSA id 17sm24700813pfp.96.2016.03.07.06.54.03
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Mon, 07 Mar 2016 06:54:04 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of using '/' longopts , use ',' ,as followed by man pages of other
programs.

Signed-off-by: Piyush Pangtey <gokuvsvegita@gmail.com>
---
 doc/nft.xml | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 7cc9988..eab97f5 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
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

