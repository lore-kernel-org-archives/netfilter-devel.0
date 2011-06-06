From: pablo@netfilter.org
Subject: [PATCH 2/2] netfilter: IPv6: fix DSCP mangle code
Date: Mon,  6 Jun 2011 02:41:11 +0200
Message-ID: <1307320871-31770-2-git-send-email-pablo@netfilter.org>
References: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37848 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab1FFAlk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:41:40 -0400
In-Reply-To: <1307320871-31770-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

The mask indicates the bits one wants to zero out, so it needs to be
inverted before applying to the original TOS field.

The following Linux kernels are affected: <= 2.6.38.8

Cc: stable@kernel.org
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit 1ed2f73d90fb49bcf5704aee7e9084adb882bfc5)
---
 net/netfilter/xt_DSCP.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 0a22919..ae82716 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -99,7 +99,7 @@ tos_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 	u_int8_t orig, nv;
 
 	orig = ipv6_get_dsfield(iph);
-	nv   = (orig & info->tos_mask) ^ info->tos_value;
+	nv   = (orig & ~info->tos_mask) ^ info->tos_value;
 
 	if (orig != nv) {
 		if (!skb_make_writable(skb, sizeof(struct iphdr)))
-- 
1.7.2.5

