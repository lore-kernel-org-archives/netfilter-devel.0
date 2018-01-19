From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [nft PATCH] doc/nft.xml: mention nftables earlier
Date: Fri, 19 Jan 2018 13:17:47 +0100
Message-ID: <151636426787.19915.2075416375709343233.stgit@endurance>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:40591 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751212AbeASMRv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:17:51 -0500
Received: by mail-wm0-f68.google.com with SMTP id v123so3132957wmd.5
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 04:17:51 -0800 (PST)
Received: from endurance (154.red-88-9-84.dynamicip.rima-tde.net. [88.9.84.154])
        by smtp.gmail.com with ESMTPSA id 44sm14255649wrv.0.2018.01.19.04.17.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jan 2018 04:17:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Mention nftables earlier in the documentation, so users have more context on what
we are talking about.

This is Debian bug #887718, which contains:

<<<
Currently one must read down 100 lines before it is even mentioned.
You might want to make the connection between "nft" and "nftables" as
early as the NAME or DESCRIPTION.
>>>

Requested-by: Dan Jacobson <jidanni@jidanni.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 doc/nft.xml |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index e515b11..9e979af 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -38,7 +38,7 @@ vi:ts=4 sw=4
 	<refnamediv>
 		<refname>nft</refname>
 		<refpurpose>
-			Administration tool for packet filtering and classification
+			Administration tool of the nftables framework for packet filtering and classification
 		</refpurpose>
 	</refnamediv>
 
@@ -73,8 +73,9 @@ vi:ts=4 sw=4
 	<refsect1>
 		<title>Description</title>
 		<para>
-			nft is used to set up, maintain and inspect packet
-			filtering and classification rules in the Linux kernel.
+			nft is the command line tool used to set up, maintain and inspect packet
+			filtering and classification rules in the Linux kernel, in the nftables framework.
+			The Linux kernel subsystem is known as nf_tables, and 'nf' stands for Netfilter.
 		</para>
 	</refsect1>
 

