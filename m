From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 1/7] src: fix memory leak when listing rules
Date: Tue, 11 Jul 2017 00:32:49 +0200
Message-ID: <20170710223255.29885-2-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41126 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754221AbdGJWdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:14 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When listing rules we were calling strdup on the table name
but variable was just used locally.

Found via `nft list ruleset` run with ASAN:

Direct leak of 4 byte(s) in 1 object(s) allocated from:
    #0 0x45cca0 in __interceptor_strdup (/usr/local/sbin/nft+0x45cca0)
    #1 0x593c71 in xstrdup /home/eric/git/netfilter/nftables/src/utils.c:75:8
    #2 0x513b34 in do_list_ruleset /home/eric/git/netfilter/nftables/src/rule.c:1388:23
    #3 0x50e178 in do_command_list /home/eric/git/netfilter/nftables/src/rule.c:1500:10
    #4 0x50d3ea in do_command /home/eric/git/netfilter/nftables/src/rule.c:1696:10
    #5 0x5061ae in nft_netlink /home/eric/git/netfilter/nftables/src/main.c:207:9
    #6 0x505b87 in nft_run /home/eric/git/netfilter/nftables/src/main.c:255:8
    #7 0x50771f in main /home/eric/git/netfilter/nftables/src/main.c:392:6
    #8 0x7fa1f326d2b0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x202b0)

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/rule.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index f65674c..58d640e 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1385,12 +1385,14 @@ static int do_list_ruleset(struct netlink_ctx *ctx, struct cmd *cmd)
 			continue;
 
 		cmd->handle.family = table->handle.family;
-		cmd->handle.table = xstrdup(table->handle.table);
+		cmd->handle.table = table->handle.table;
 
 		if (do_list_table(ctx, cmd, table) < 0)
 			return -1;
 	}
 
+	cmd->handle.table = NULL;
+
 	return 0;
 }
 
-- 
2.13.2

