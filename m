From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 09/15] netfilter: xt_TCPMSS: Fix violation of RFC879 in absence of MSS option
Date: Tue,  2 Jul 2013 16:50:59 +0200
Message-ID: <1372776665-6795-9-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44023 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3GBOwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:52:18 -0400
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Phil Oester <kernel@linuxace.com>

The clamp-mss-to-pmtu option of the xt_TCPMSS target can cause issues
connecting to websites if there was no MSS option present in the
original SYN packet from the client. In these cases, it may add a
MSS higher than the default specified in RFC879. Fix this by never
setting a value > 536 if no MSS option was specified by the client.

This closes netfilter's bugzilla #662.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: 409b545ac10d9548929557a75ad86540f59a2c83

 net/netfilter/xt_TCPMSS.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index 71a266d..4960b66 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -124,6 +124,12 @@ tcpmss_mangle_packet(struct sk_buff *skb,
 
 	skb_put(skb, TCPOLEN_MSS);
 
+	/* RFC 879 states that the default MSS is 536 without specific
+	 * knowledge that the destination host is prepared to accept larger.
+	 * Since no MSS was provided, we MUST NOT set a value > 536.
+	 */
+	newmss = min(newmss, (u16)536);
+
 	opt = (u_int8_t *)tcph + sizeof(struct tcphdr);
 	memmove(opt + TCPOLEN_MSS, opt, tcplen - sizeof(struct tcphdr));
 
-- 
1.7.10.4

