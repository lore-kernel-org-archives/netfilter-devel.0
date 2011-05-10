From: pablo@netfilter.org
Subject: [PATCH 7/8] netfilter: IPv6: fix DSCP mangle code
Date: Tue, 10 May 2011 12:05:58 +0200
Message-ID: <1305021959-2980-8-git-send-email-pablo@netfilter.org>
References: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net,
	Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48595 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab1EJKGa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 May 2011 06:06:30 -0400
In-Reply-To: <1305021959-2980-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

The mask indicates the bits one wants to zero out, so it needs to be
inverted before applying to the original TOS field.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
1.7.2.3

