Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1D652120F
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548068; cv=none; b=Bf+yjm3T4OMmJ9igEt90rBfEYJXavebMmIYAK2P47qdvR5RNUBXgu0yOQj+joBZELF6n5YX7hDu5wC60PUF/7pCPiaSTRugtehR+w1OBVRBhhAD4QO4VPNpwapLV2neFx+EaSCBw4t6YjFNSTmGc7lFLRvkVduWao8xEyxx5TWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548068; c=relaxed/simple;
	bh=qKzNk0soOsoCxzeRRyq714xSxgXhMR4kzmToCLBxsB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6yy5JEi4P4kjq7HeKmYUNEE40UirpTkjEKpBA06eO8NfAyARTLDuxlAzgGblNq7RfD0ETeQSZMnQd/2JaU82wFVjVSxygkimtti4Srr4JzxyOXt3DIz5YmpnvzqVNyrkS7D+03UKS0vC+LOY51G9H24RGyie/LV8C0nEyZCvHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E9E8760E25; Fri, 04 Sep 2026 20:54:24 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 12/13] netfilter: ipset: use plain rcu_read_lock
Date: Fri,  4 Sep 2026 20:53:20 +0200
Message-ID: <20260904185321.30313-13-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904185321.30313-1-fw@strlen.de>
References: <20260904185321.30313-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No need to disable/reenable softirqs.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/ipset/ip_set_core.c            |  4 ++--
 net/netfilter/ipset/ip_set_hash_gen.h        | 19 ++++++++-----------
 net/netfilter/ipset/ip_set_hash_netnet.c     |  8 ++++----
 net/netfilter/ipset/ip_set_hash_netportnet.c |  8 ++++----
 4 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 632e30c7f35d..856e53271b38 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1868,9 +1868,9 @@ static int ip_set_utest(struct sk_buff *skb, const struct nfnl_info *info,
 			     set->type->adt_policy, NULL))
 		return -IPSET_ERR_PROTOCOL;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	ret = set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	/* Userspace can't trigger element to be re-added */
 	if (ret == -EAGAIN)
 		ret = 1;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 225f30e5b749..cf48b7c50ca1 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -17,9 +17,6 @@
 #define ipset_dereference_nfnl(p)	\
 	rcu_dereference_protected(p,	\
 		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
-#define ipset_dereference_bh_nfnl(p)	\
-	rcu_dereference_bh_check(p, 	\
-		lockdep_nfnl_is_held(NFNL_SUBSYS_IPSET))
 
 /* Kept for backward compatibility */
 #define AHASH_INIT_SIZE			2
@@ -729,7 +726,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i;
 #endif
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 #ifdef IP_SET_HASH_WITH_MULTI
 	{
 		struct rhlist_head *tmp, *list;
@@ -906,7 +903,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ret = flag_exist ? 0 : -IPSET_ERR_EXIST;
 
 out_rcu_unlock:
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return ret;
 }
 
@@ -920,7 +917,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct mtype_rht_elem *e;
 	int ret = -IPSET_ERR_EXIST;
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 #ifdef IP_SET_HASH_WITH_MULTI
 	{
 		struct rhlist_head *tmp, *list;
@@ -954,7 +951,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	ip_set_ext_destroy(set, &e->elem);
 	kfree_rcu(e, rcu);
 out_unlock:
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return ret ? -IPSET_ERR_EXIST : 0;
 }
 
@@ -994,10 +991,10 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	pr_debug("test by nets\n");
 retry:
 	multi = 0;
-	nets0 = ipset_dereference_bh_nfnl(h->rnets[0]);
+	nets0 = rcu_dereference(h->rnets[0]);
 	seq0 = read_seqcount_begin(&nets0->seq);
 #if IPSET_NET_COUNT == 2
-	nets1 = ipset_dereference_bh_nfnl(h->rnets[1]);
+	nets1 = rcu_dereference(h->rnets[1]);
 	seq1 = read_seqcount_begin(&nets1->seq);
 #endif
 	for (j = 0; j < nets0->len && !multi; j++) {
@@ -1076,7 +1073,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i;
 #endif
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 #ifdef IP_SET_HASH_WITH_NETS
 	/* If we test an IP address and not a network address,
 	 * try all possible network sizes
@@ -1114,7 +1111,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	ret = mtype_data_match(&e->elem, ext, mext, set, flags);
 #endif
 out:
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	return ret;
 }
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index a6bd24e3b1ac..6b768725e4cd 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -148,10 +148,10 @@ hash_netnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -382,10 +382,10 @@ hash_netnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 8575a2c5e215..d1e4ce2f2afa 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -155,10 +155,10 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(e.cidr[0]) * 8)) | HOST_MASK;
 
@@ -444,10 +444,10 @@ hash_netportnet6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_netportnet6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	rcu_read_lock_bh();
+	rcu_read_lock();
 	e.cidr[0] = INIT_CIDR(h->rnets[0], HOST_MASK);
 	e.cidr[1] = INIT_CIDR(h->rnets[1], HOST_MASK);
-	rcu_read_unlock_bh();
+	rcu_read_unlock();
 	if (adt == IPSET_TEST)
 		e.ccmp = (HOST_MASK << (sizeof(u8) * 8)) | HOST_MASK;
 
-- 
2.55.0

