From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] ipvs: use nf_ct_kill helper
Date: Wed,  3 Aug 2016 02:51:05 +0200
Message-ID: <1470185465-17983-1-git-send-email-fw@strlen.de>
Cc: lvs-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54504 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756949AbcHCAvA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Aug 2016 20:51:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once timer is removed from nf_conn struct we cannot open-code
the removal sequence like this anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 ipvs maintainers:

 Alternatively I can do a 1:1 replacement of the del_timer() with a
 test_and_set_bit().

 Please let me know if you would prefer this,

diff --git a/net/netfilter/ipvs/ip_vs_nfct.c b/net/netfilter/ipvs/ip_vs_nfct.c
index f04fd8d..69ce16e 100644
--- a/net/netfilter/ipvs/ip_vs_nfct.c
+++ b/net/netfilter/ipvs/ip_vs_nfct.c
@@ -281,18 +281,7 @@ void ip_vs_conn_drop_conntrack(struct ip_vs_conn *cp)
 	h = nf_conntrack_find_get(cp->ipvs->net, &nf_ct_zone_dflt, &tuple);
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		/* Show what happens instead of calling nf_ct_kill() */
-		if (del_timer(&ct->timeout)) {
-			IP_VS_DBG(7, "%s: ct=%p, deleted conntrack timer for tuple="
-				FMT_TUPLE "\n",
-				__func__, ct, ARG_TUPLE(&tuple));
-			if (ct->timeout.function)
-				ct->timeout.function(ct->timeout.data);
-		} else {
-			IP_VS_DBG(7, "%s: ct=%p, no conntrack timer for tuple="
-				FMT_TUPLE "\n",
-				__func__, ct, ARG_TUPLE(&tuple));
-		}
+		nf_ct_kill(ct);
 		nf_ct_put(ct);
 	} else {
 		IP_VS_DBG(7, "%s: no conntrack for tuple=" FMT_TUPLE "\n",
-- 
2.7.3

