From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] doc: nft: add my copyright statement to the manpage
Date: Thu,  8 Sep 2016 23:12:21 +0200
Message-ID: <1473369142-21765-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44040 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754369AbcIHVMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 17:12:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12F7F1E11B3
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 23:12:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04DEB114D62
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 23:12:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9B5D4100A5D
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2016 23:12:25 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Update the manpage to include my copyright statement and credit me as
author of this software.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index ea47e2b..e6e8583 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -18,6 +18,18 @@ vi:ts=4 sw=4
 		</copyright>
 	</refentryinfo>
 
+	<refentryinfo>
+		<author>
+			<firstname>Pablo Neira</firstname>
+			<surname>Neira Ayuso</surname>
+			<email>pablo@netfilter.org</email>
+		</author>
+		<copyright>
+			<year>2013-2016</year>
+			<holder>Pablo Neira Ayuso</holder>
+		</copyright>
+	</refentryinfo>
+
 	<refmeta>
 		<refentrytitle>nft</refentrytitle>
 		<manvolnum>8</manvolnum>
@@ -2358,15 +2370,16 @@ filter output oif wlan0
 	<refsect1>
 		<title>Authors</title>
 		<para>
-			nftables was written by Patrick McHardy.
+			nftables was written by Patrick McHardy and Pablo Neira Ayuso, among many other contributors from the Netfilter community.
 		</para>
 	</refsect1>
 
 	<refsect1>
 		<title>Copyright</title>
-		<para>
-			Copyright &copy; 2008-2014 Patrick McHardy <email>kaber@trash.net</email>
-		</para>
+		<literallayout>
+Copyright &copy; 2008-2014 Patrick McHardy <email>kaber@trash.net</email>
+Copyright &copy; 2013-2016 Pablo Neira Ayuso <email>pablo@netfilter.org</email>
+		</literallayout>
 		<para>
 			nftables is free software; you can redistribute it and/or modify
 			it under the terms of the GNU General Public License version 2 as
-- 
2.1.4

