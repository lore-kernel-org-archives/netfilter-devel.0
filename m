From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/3 nft] src: get rid of EINTR handling in nft_netlink()
Date: Wed,  8 Jul 2015 11:18:06 +0200
Message-ID: <1436347088-9687-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42259 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbbGHJMf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 05:12:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The only remaining caller that needs this is netlink_dump_ruleset(), that is
used to export the ruleset using markup representation. We can remove it and
handle this from do_command_export() now that we have a centralized point to
build up the object cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c |    7 -------
 src/rule.c |   10 ++++++----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/src/main.c b/src/main.c
index a069f63..52c1597 100644
--- a/src/main.c
+++ b/src/main.c
@@ -254,14 +254,7 @@ replay:
 	if (ret != 0 || state->nerrs > 0)
 		goto err1;
 
-retry:
 	ret = nft_netlink(state, msgs);
-	if (ret < 0 && errno == EINTR) {
-		nft_cache_fini();
-		netlink_restart();
-		goto retry;
-	}
-
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
diff --git a/src/rule.c b/src/rule.c
index 86e77b6..f806db6 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -899,11 +899,13 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 
 static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 {
-	struct nft_ruleset *rs = netlink_dump_ruleset(ctx, &cmd->handle,
-						      &cmd->location);
+	struct nft_ruleset *rs;
 
-	if (rs == NULL)
-		return -1;
+	do {
+		rs = netlink_dump_ruleset(ctx, &cmd->handle, &cmd->location);
+		if (rs == NULL && errno != EINTR)
+			return -1;
+	} while (rs == NULL);
 
 	nft_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
 	fprintf(stdout, "\n");
-- 
1.7.10.4

