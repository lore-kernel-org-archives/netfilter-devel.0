Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87B139B94D;
	Wed, 25 Mar 2026 22:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477600; cv=none; b=IDwLMZvxVTZTX2WBmDWMCyLx3ru4P5/2DkySoewd37vEbRFhlQ1R/iaXaHYOXJg7L9C9GKjUSq/ANZxk6SvOe1dWBKFZIF+10X05WFs/KYutbvXODd+4M3eDe6y5aED9pxftTR6oCwnvA1NxDAeGJYimYih4fle7c+7jzDz5aYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477600; c=relaxed/simple;
	bh=1s9DZjAHoVuYpHvnJY0+Rv5MfpSeCaZID3pEFXgtbiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HauV8k5Y0joT0kgb9mkwZZuXksO0Ebzi8zqjZHkS6U3/xe7GTv2f8cAWE4955t0/A/9Y38Gtn+vVajCmxzCanOF5aLYf/HqmfN8hyax/QnpbIoQEEVL5lL01M6QT3IYiymmYL8pEgKRvVaoXBBiuabpHDNG/OccgZ1/my2vKe00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HhNPVepb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HhNPVepb"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5CCEF600B5;
	Wed, 25 Mar 2026 23:26:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774477596;
	bh=c2oFxf7laka3ewjT50JmynISekij/PH4ViHMcXso+NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhNPVepbY8vwayVE5xms5i90B03Ma+GfBusf2tK6s44LRjVWv/Y2BHpecUKdbXlNz
	 aW3eDvx7RQNAdJurf2CNncjrqjgLBIc/hAHWJvOscR9Ad5m8S4tOeq0Skv2l2OQW8m
	 4cy/XNpH52I2i/cX0vqRQfrDasY2/1pZovcmAA9DoPx1U0M2VvPg5S4eRdndhX7SzR
	 JDynwcakejNJy38swlAirl3wRNptuLzxga+p+wHnaWFYPvs/zMkhbcjEtrTUl6dFv6
	 BhhWJOH0VNCSq7wAw5g8o2i6ifQfoZouPXdfKA34Yri+Rsh9/OV0PkNeGSePcQU1Ls
	 dtkfLDpZ6CqvQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/14] netfilter: ctnetlink: ensure safe access to master conntrack
Date: Wed, 25 Mar 2026 23:26:11 +0100
Message-ID: <20260325222615.637793-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325222615.637793-1-pablo@netfilter.org>
References: <20260325222615.637793-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Holding reference on the expectation is not sufficient, the master
conntrack object can just go away, making exp->master invalid.

To access exp->master safely:

- Grab the nf_conntrack_expect_lock, this gets serialized with
  clean_from_lists() which also holds this lock when the master
  conntrack goes away.

- Hold reference on master conntrack via nf_conntrack_find_get().
  Not so easy since the master tuple to look up for the master conntrack
  is not available in the existing problematic paths.

This patch goes for extending the nf_conntrack_expect_lock section
to address this issue for simplicity, in the cases that are described
below this is just slightly extending the lock section.

The add expectation command already holds a reference to the master
conntrack from ctnetlink_create_expect().

However, the delete expectation command needs to grab the spinlock
before looking up for the expectation. Expand the existing spinlock
section to address this to cover the expectation lookup. Note that,
the nf_ct_expect_iterate_net() calls already grabs the spinlock while
iterating over the expectation table, which is correct.

The get expectation command needs to grab the spinlock to ensure master
conntrack does not go away. This also expands the existing spinlock
section to cover the expectation lookup too. I needed to move the
netlink skb allocation out of the spinlock to keep it GFP_KERNEL.

For the expectation events, the IPEXP_DESTROY event is already delivered
under the spinlock, just move the delivery of IPEXP_NEW under the
spinlock too because the master conntrack event cache is reached through
exp->master.

While at it, add lockdep notations to help identify what codepaths need
to grab the spinlock.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h |  5 ++++
 net/netfilter/nf_conntrack_ecache.c       |  2 ++
 net/netfilter/nf_conntrack_expect.c       | 10 +++++++-
 net/netfilter/nf_conntrack_netlink.c      | 28 +++++++++++++++--------
 4 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 3384859a8921..8883575adcc1 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -83,6 +83,11 @@ void nf_conntrack_lock(spinlock_t *lock);
 
 extern spinlock_t nf_conntrack_expect_lock;
 
+static inline void lockdep_nfct_expect_lock_held(void)
+{
+	lockdep_assert_held(&nf_conntrack_expect_lock);
+}
+
 /* ctnetlink code shared by both ctnetlink and nf_conntrack_bpf */
 
 static inline void __nf_ct_set_timeout(struct nf_conn *ct, u64 timeout)
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 81baf2082604..9df159448b89 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -247,6 +247,8 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
+	lockdep_nfct_expect_lock_held();
+
 	rcu_read_lock();
 	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
 	if (!notify)
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 64977db12b1d..1cbe5f1108c2 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -51,6 +51,7 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 	struct net *net = nf_ct_exp_net(exp);
 	struct nf_conntrack_net *cnet;
 
+	lockdep_nfct_expect_lock_held();
 	WARN_ON(!master_help);
 	WARN_ON(timer_pending(&exp->timeout));
 
@@ -118,6 +119,8 @@ nf_ct_exp_equal(const struct nf_conntrack_tuple *tuple,
 
 bool nf_ct_remove_expect(struct nf_conntrack_expect *exp)
 {
+	lockdep_nfct_expect_lock_held();
+
 	if (timer_delete(&exp->timeout)) {
 		nf_ct_unlink_expect(exp);
 		nf_ct_expect_put(exp);
@@ -177,6 +180,8 @@ nf_ct_find_expectation(struct net *net,
 	struct nf_conntrack_expect *i, *exp = NULL;
 	unsigned int h;
 
+	lockdep_nfct_expect_lock_held();
+
 	if (!cnet->expect_count)
 		return NULL;
 
@@ -454,6 +459,8 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 	unsigned int h;
 	int ret = 0;
 
+	lockdep_nfct_expect_lock_held();
+
 	if (!master_help) {
 		ret = -ESHUTDOWN;
 		goto out;
@@ -510,8 +517,9 @@ int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 
 	nf_ct_expect_insert(expect);
 
-	spin_unlock_bh(&nf_conntrack_expect_lock);
 	nf_ct_expect_event_report(IPEXP_NEW, expect, portid, report);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
 	return 0;
 out:
 	spin_unlock_bh(&nf_conntrack_expect_lock);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8477c3736432..89540112d165 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3355,31 +3355,37 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
+	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb2)
+		return -ENOMEM;
+
+	spin_lock_bh(&nf_conntrack_expect_lock);
 	exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
-	if (!exp)
+	if (!exp) {
+		spin_unlock_bh(&nf_conntrack_expect_lock);
+		kfree_skb(skb2);
 		return -ENOENT;
+	}
 
 	if (cda[CTA_EXPECT_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 
 		if (id != nf_expect_get_id(exp)) {
 			nf_ct_expect_put(exp);
+			spin_unlock_bh(&nf_conntrack_expect_lock);
+			kfree_skb(skb2);
 			return -ENOENT;
 		}
 	}
 
-	skb2 = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!skb2) {
-		nf_ct_expect_put(exp);
-		return -ENOMEM;
-	}
-
 	rcu_read_lock();
 	err = ctnetlink_exp_fill_info(skb2, NETLINK_CB(skb).portid,
 				      info->nlh->nlmsg_seq, IPCTNL_MSG_EXP_NEW,
 				      exp);
 	rcu_read_unlock();
 	nf_ct_expect_put(exp);
+	spin_unlock_bh(&nf_conntrack_expect_lock);
+
 	if (err <= 0) {
 		kfree_skb(skb2);
 		return -ENOMEM;
@@ -3426,22 +3432,26 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 		if (err < 0)
 			return err;
 
+		spin_lock_bh(&nf_conntrack_expect_lock);
+
 		/* bump usage count to 2 */
 		exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
-		if (!exp)
+		if (!exp) {
+			spin_unlock_bh(&nf_conntrack_expect_lock);
 			return -ENOENT;
+		}
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
 
 			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
+				spin_unlock_bh(&nf_conntrack_expect_lock);
 				return -ENOENT;
 			}
 		}
 
 		/* after list removal, usage count == 1 */
-		spin_lock_bh(&nf_conntrack_expect_lock);
 		if (timer_delete(&exp->timeout)) {
 			nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
 						   nlmsg_report(info->nlh));
-- 
2.47.3

