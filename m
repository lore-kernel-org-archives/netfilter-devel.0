From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH nft v2] evaluate: fix "list set" unexpected behaviour
Date: Wed,  1 Jun 2016 12:16:51 +0200
Message-ID: <20160601101651.23971-1-pablombg@gmail.com>
Cc: pablo@netfilter.org, "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36359 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbcFAKRY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 06:17:24 -0400
Received: by mail-wm0-f66.google.com with SMTP id q62so5294409wmg.3
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 03:17:23 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Special sets like maps and flow tables have their own commands to be
listed and inspected.

Before this patch, "nft list set" was able to display these special sets
content:

  # nft list set filter test
  table ip filter {
          map test {
                  type ipv4_addr : inet_service
                  elements = { 192.168.1.101 : http-alt}
          }
  }

Now an error is shown:

  # nft list set filter test
  <cmdline>:1:1-20: Error: Could not process rule: Set 'test' does not exist
  list set filter test
  ^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 423523f..f24e5f3 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2674,7 +2674,8 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 		if (table == NULL)
 			return cmd_error(ctx, "Could not process rule: Table '%s' does not exist",
 					 cmd->handle.table);
-		if (set_lookup(table, cmd->handle.set) == NULL)
+		set = set_lookup(table, cmd->handle.set);
+		if (set == NULL || set->flags & (SET_F_MAP | SET_F_EVAL))
 			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
 					 cmd->handle.set);
 		return 0;
-- 
2.8.3

