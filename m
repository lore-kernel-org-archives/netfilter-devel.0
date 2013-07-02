From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 11/15] netfilter: xt_TCPMSS: Fix missing fragmentation handling
Date: Tue,  2 Jul 2013 16:51:01 +0200
Message-ID: <1372776665-6795-11-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44137 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548Ab3GBOxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:53:11 -0400
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Oester <kernel@linuxace.com>

Similar to commit bc6bcb59 ("netfilter: xt_TCPOPTSTRIP: fix
possible mangling beyond packet boundary"), add safe fragment
handling to xt_TCPMSS.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: b396966c4688522863572927cb30aa874b3ec504

 net/netfilter/xt_TCPMSS.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 4960b66..a77d786 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -55,6 +55,10 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 	u16 newmss;
 	u8 *opt;
 
+	/* This is a fragment, no TCP header is available */
+	if (par->fragoff != 0)
+		return XT_CONTINUE;
+
 	if (!skb_make_writable(skb, skb->len))
 		return -1;
 
-- 
1.7.10.4

