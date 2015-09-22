From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/2] rule: filter out tables depending on family
Date: Wed, 23 Sep 2015 00:20:50 +0200
Message-ID: <1442960451-4704-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, nvinson234@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34697 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759658AbbIVWOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2015 18:14:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 # nft list tables ip
 table ip filter

 # nft list tables ip6
 table ip6 filter

Closes: http://bugzilla.netfilter.org/show_bug.cgi?id=1033
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 43cc4a8..92b83f0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1013,10 +1013,15 @@ static int do_list_tables(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct table *table;
 
-	list_for_each_entry(table, &table_list, list)
+	list_for_each_entry(table, &table_list, list) {
+		if (cmd->handle.family != NFPROTO_UNSPEC &&
+		    cmd->handle.family != table->handle.family)
+			continue;
+
 		printf("table %s %s\n",
 		       family2str(table->handle.family),
 		       table->handle.table);
+	}
 
 	return 0;
 }
-- 
1.7.10.4

