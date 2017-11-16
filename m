From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 1/2] Make 'nft export' respect output_fp
Date: Thu, 16 Nov 2017 09:06:28 +0100
Message-ID: <20171116080629.30564-2-phil@nwl.cc>
References: <20171116080629.30564-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59736 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759387AbdKPIGq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 03:06:46 -0500
In-Reply-To: <20171116080629.30564-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 6a322167b8265..5a6c602505455 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1153,6 +1153,10 @@ static int do_command_delete(struct netlink_ctx *ctx, struct cmd *cmd)
 static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 {
 	struct nftnl_ruleset *rs;
+	FILE *fp = ctx->octx->output_fp;
+
+	if (!fp)
+		return 0;
 
 	do {
 		rs = netlink_dump_ruleset(ctx, &cmd->handle, &cmd->location);
@@ -1160,8 +1164,9 @@ static int do_command_export(struct netlink_ctx *ctx, struct cmd *cmd)
 			return -1;
 	} while (rs == NULL);
 
-	nftnl_ruleset_fprintf(stdout, rs, cmd->export->format, 0);
-	fprintf(stdout, "\n");
+	nftnl_ruleset_fprintf(fp, rs, cmd->export->format, 0);
+	fprintf(fp, "\n");
+	fflush(fp);
 
 	nftnl_ruleset_free(rs);
 	return 0;
-- 
2.13.1

