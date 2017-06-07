From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] doc: nft: describe -I override behaviour when path starts by ./ and /
Date: Wed,  7 Jun 2017 12:35:46 +0200
Message-ID: <1496831747-9221-1-git-send-email-pablo@netfilter.org>
Cc: ismo.puustinen@intel.com, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50324 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751406AbdFGKfy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:35:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9FB1C106E
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:35:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99F406DA6D
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:35:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 618D5FF6E1
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:35:42 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You can override -I by starting your path either using ./ for relative
paths and / for absolute paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9364133f1787..f93baa03d721 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -207,7 +207,10 @@ vi:ts=4 sw=4
 			<para>
 				Other files can be included by using the <command>include</command> statement.
 				The directories to be searched for include files can be specified using
-				the <option>-I/--includepath</option> option.
+				the <option>-I/--includepath</option> option. You can override this behaviour
+				either by prepending ./ to your path to force inclusion of files located in the
+				current working directory (ie. relative path) or / for file location expressed
+				as an absolute path.
 			</para>
 			<para>
 				If the <literal>filename</literal> parameter is a directory, then all files in
-- 
2.1.4

