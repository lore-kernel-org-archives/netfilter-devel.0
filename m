From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nftables PATCH] Correct initial value of bytes counter in nftables rule
Date: Thu, 19 Jun 2014 20:23:47 +0800
Message-ID: <1403180627-5631-1-git-send-email-ycnian@gmail.com>
Cc: Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53163 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442AbaFSMUb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:20:31 -0400
Received: by mail-pa0-f44.google.com with SMTP id rd3so1858379pab.17
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2014 05:20:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Packages can be accounted by nftables through such command.
% nft add rule filter output ip daddr 8.8.8.8 counter

You can also give the initial values of packets and bytes.
% nft add rule filter output ip daddr 8.8.8.8 counter  packets 10 bytes 20

But packets and bytes are both initialized to 10 in above command for there is
a mistake in the program.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 src/netlink_linearize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index b0ca241..222d102 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -545,7 +545,7 @@ static void netlink_gen_counter_stmt(struct netlink_linearize_ctx *ctx,
 	}
 	if (stmt->counter.bytes) {
 		nft_rule_expr_set_u64(nle, NFT_EXPR_CTR_BYTES,
-				      stmt->counter.packets);
+				      stmt->counter.bytes);
 	}
 	nft_rule_add_expr(ctx->nlr, nle);
 }
-- 
1.9.3

