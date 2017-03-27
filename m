From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH] netfilter: nat: remove rcu_read_lock in __nf_nat_decode_session.
Date: Tue, 28 Mar 2017 00:28:50 +0900
Message-ID: <20170327152850.19812-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:32878 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752292AbdC0P3E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 11:29:04 -0400
Received: by mail-pg0-f66.google.com with SMTP id 79so13815725pgf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 08:28:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

__nf_nat_decode_session is called from nf_nat_decode_session as decodefn.
before calling decodefn, it already set rcu_read_lock. so rcu_read_lock in
__nf_nat_decode_session can be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_nat_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 94b14c5..9b68676 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -71,11 +71,10 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 	if (ct == NULL)
 		return;
 
-	family = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num;
-	rcu_read_lock();
+	family = nf_ct_l3num(ct);
 	l3proto = __nf_nat_l3proto_find(family);
 	if (l3proto == NULL)
-		goto out;
+		return;
 
 	dir = CTINFO2DIR(ctinfo);
 	if (dir == IP_CT_DIR_ORIGINAL)
@@ -84,8 +83,6 @@ static void __nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 		statusbit = IPS_SRC_NAT;
 
 	l3proto->decode_session(skb, ct, dir, statusbit, fl);
-out:
-	rcu_read_unlock();
 }
 
 int nf_xfrm_me_harder(struct net *net, struct sk_buff *skb, unsigned int family)
-- 
2.9.3

