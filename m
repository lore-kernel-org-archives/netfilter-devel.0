From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft v5 14/14] src: get rid of EINTR handling for nft_netlink()
Date: Mon, 10 Aug 2015 13:50:48 +0200
Message-ID: <1439207448-22485-15-git-send-email-pablo@netfilter.org>
References: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56049 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbbHJLpM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 07:45:12 -0400
In-Reply-To: <1439207448-22485-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The only remaining caller that needs this is netlink_dump_ruleset(), that is
used to export the ruleset using markup representation. We can remove it and
handle this from do_command_export() now that we have a centralized point to
build up the object cache.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/main.c |    5 -----
 src/rule.c |   10 ++++++----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/src/main.c b/src/main.c
index d6c9ccc..7bbcfc4 100644
--- a/src/main.c
+++ b/src/main.c
@@ -233,12 +233,7 @@ int nft_run(void *scanner, struct parser_state *state, struct list_head *msgs)
 		ret = -1;
 		goto err1;
 	}
-retry:
 	ret = nft_netlink(state, msgs);
-	if (ret < 0 && errno == EINTR) {
-		netlink_restart();
-		goto retry;
-	}
 err1:
 	list_for_each_entry_safe(cmd, next, &state->cmds, list) {
 		list_del(&cmd->list);
diff --git a/src/rule.c b/src/rule.c
index 310ff95..d369596 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -942,11 +942,13 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 
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

