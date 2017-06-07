From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] src: display default directory for file inclusion in -h/--help
Date: Wed,  7 Jun 2017 12:35:47 +0200
Message-ID: <1496831747-9221-2-git-send-email-pablo@netfilter.org>
References: <1496831747-9221-1-git-send-email-pablo@netfilter.org>
Cc: ismo.puustinen@intel.com, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50372 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbdFGKfz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 06:35:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22666DFE45
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:35:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F775100A47
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:35:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E735010218A
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2017 12:35:43 +0200 (CEST)
In-Reply-To: <1496831747-9221-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If no explicit relative or absolute path is enforced by the user, nft
relies on either -I/--includepath or the default include directory that
is set at compile time.

Given most of our users will rely on packaged versions of nft, provide a
way to display the location of this default includepath directory.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 doc/nft.xml | 5 +++++
 src/main.c  | 4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index f93baa03d721..faf0ffde9e19 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -213,6 +213,11 @@ vi:ts=4 sw=4
 				as an absolute path.
 			</para>
 			<para>
+				If -I/--includepath is not specified, then nft relies on the default directory
+				that is specified at compile time. You can retrieve this default directory via
+				-h/--help option.
+			</para>
+			<para>
 				If the <literal>filename</literal> parameter is a directory, then all files in
 				the directory are loaded in alphabetical order.
 			</para>
diff --git a/src/main.c b/src/main.c
index 6dae817af40b..5089ff2448f3 100644
--- a/src/main.c
+++ b/src/main.c
@@ -125,12 +125,12 @@ static void show_help(const char *name)
 "  -s, --stateless		Omit stateful information of ruleset.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
-"  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
+"  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 #endif
 "\n",
-	name);
+	name, DEFAULT_INCLUDE_PATH);
 }
 
 #ifdef DEBUG
-- 
2.1.4

