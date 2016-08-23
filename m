From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] parser_bison: explicit indication on export ruleset
Date: Tue, 23 Aug 2016 17:12:08 +0200
Message-ID: <1471965128-1150-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58866 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751676AbcHWPMS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Aug 2016 11:12:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2F6CCC0B38
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:12:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 215A4114D6C
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:12:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4D643563
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Aug 2016 17:12:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies the grammar to explicitly indicate what you want to
export, eg.

 # nft export ruleset json

This leaves room to extend this later on to support other object types,
such as integrating conntrack into nft.

This also leaves the syntax in consistent state wrt. other existing
objects. The existing syntax is still preserved.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index e16b8a3..cd149e7 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -882,7 +882,13 @@ rename_cmd		:	CHAIN		chain_spec	identifier
 			}
 			;
 
-export_cmd		:	export_format
+export_cmd		:	RULESET		export_format
+			{
+				struct handle h = { .family = NFPROTO_UNSPEC };
+				struct export *export = export_alloc($2);
+				$$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_EXPORT, &h, &@$, export);
+			}
+			|	export_format
 			{
 				struct handle h = { .family = NFPROTO_UNSPEC };
 				struct export *export = export_alloc($1);
-- 
2.1.4

