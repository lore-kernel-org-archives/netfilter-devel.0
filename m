Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA64C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 01:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiLPBqj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 20:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLPBqh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 20:46:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896F265EA
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 17:46:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p5zo3-0003lp-4l; Fri, 16 Dec 2022 02:46:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: move rcu read lock to nf_conntrack_find_get
Date:   Fri, 16 Dec 2022 02:46:28 +0100
Message-Id: <20221216014628.622-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move rcu_read_lock/unlock to nf_conntrack_find_get(), this avoids
nested rcu_read_lock call from resolve_normal_ct().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 496c4920505b..93ab191917cf 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -786,8 +786,6 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conn *ct;
 
-	rcu_read_lock();
-
 	h = ____nf_conntrack_find(net, zone, tuple, hash);
 	if (h) {
 		/* We have a candidate that matches the tuple we're interested
@@ -799,7 +797,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 			smp_acquire__after_ctrl_dep();
 
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
-				goto found;
+				return h;
 
 			/* TYPESAFE_BY_RCU recycled the candidate */
 			nf_ct_put(ct);
@@ -807,8 +805,6 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 
 		h = NULL;
 	}
-found:
-	rcu_read_unlock();
 
 	return h;
 }
@@ -820,16 +816,21 @@ nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	unsigned int rid, zone_id = nf_ct_zone_id(zone, IP_CT_DIR_ORIGINAL);
 	struct nf_conntrack_tuple_hash *thash;
 
+	rcu_read_lock();
+
 	thash = __nf_conntrack_find_get(net, zone, tuple,
 					hash_conntrack_raw(tuple, zone_id, net));
 
 	if (thash)
-		return thash;
+		goto out_unlock;
 
 	rid = nf_ct_zone_id(zone, IP_CT_DIR_REPLY);
 	if (rid != zone_id)
-		return __nf_conntrack_find_get(net, zone, tuple,
-					       hash_conntrack_raw(tuple, rid, net));
+		thash = __nf_conntrack_find_get(net, zone, tuple,
+						hash_conntrack_raw(tuple, rid, net));
+
+out_unlock:
+	rcu_read_unlock();
 	return thash;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_find_get);
-- 
2.37.4

