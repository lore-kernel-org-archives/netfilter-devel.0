Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848AE272E51
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Aug 2025 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754061936; cv=none; b=QQeAm2q1Zw1H6+y346dgjDFpyVroG+jOvJ49C9nAXKNjhayyR4inoooV6U5Edi8XDj1lya974gdc68ZN3aBRssyidYZkn4dXW/sVJEvRJv8mbjhp2fCumPMKBGpImhV9kABXQVne8g6GvLNfQ5DfdOMhDRJphLN+Cqn2WWW+ggI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754061936; c=relaxed/simple;
	bh=UWAX124Vd531CQ5ml2nv5r6hCzzf0z0I2THnO/LtseY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr+/lohBawCwJSM5EKMFoWEodVhzG/XXJxw5wAdOf8OUM23H/swHMwo/OsnwVNqsGKKqqRlniT0w+AnLvVPSe2YNwMqACFqYzLi9F3Qv7DkPdmYFiR6Zuuds0ygeZ8BzNN/1J8KgRwfTHNAR4kdQvNeZClx4nl0F8TppduWz51Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8996C602B2; Fri,  1 Aug 2025 17:25:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/2] netfilter: ctnetlink: remove refcounting in expectation dumpers
Date: Fri,  1 Aug 2025 17:25:09 +0200
Message-ID: <20250801152515.20172-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250801152515.20172-1-fw@strlen.de>
References: <20250801152515.20172-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same pattern as previous patch: do not keep the expectation object
alive via refcount, only store a cookie value and then use that
as the skip hint for dump resumption.

AFAICS this has the same issue as the one resolved in the conntrack
dumper, when we do
  if (!refcount_inc_not_zero(&exp->use))

to increment the refcount, there is a chance that exp == last, which
causes a double-increment of the refcount and subsequent memory leak.

Fixes: cf6994c2b981 ("[NETFILTER]: nf_conntrack_netlink: sync expectation dumping with conntrack table dumping")
Fixes: e844a928431f ("netfilter: ctnetlink: allow to dump expectation per master conntrack")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_netlink.c | 41 ++++++++++++----------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5fdcae45e0bc..cbe42c987136 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3171,23 +3171,27 @@ ctnetlink_expect_event(unsigned int events, const struct nf_exp_event *item)
 	return 0;
 }
 #endif
-static int ctnetlink_exp_done(struct netlink_callback *cb)
+
+static unsigned long ctnetlink_exp_id(const struct nf_conntrack_expect *exp)
 {
-	if (cb->args[1])
-		nf_ct_expect_put((struct nf_conntrack_expect *)cb->args[1]);
-	return 0;
+	unsigned long id = (unsigned long)exp;
+
+	id += nf_ct_get_id(exp->master);
+	id += exp->class;
+
+	return id ? id : 1;
 }
 
 static int
 ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
+	unsigned long last_id = cb->args[1];
 	struct net *net = sock_net(skb->sk);
-	struct nf_conntrack_expect *exp, *last;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
+	struct nf_conntrack_expect *exp;
 
 	rcu_read_lock();
-	last = (struct nf_conntrack_expect *)cb->args[1];
 	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
 		hlist_for_each_entry_rcu(exp, &nf_ct_expect_hash[cb->args[0]],
@@ -3199,7 +3203,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (exp != last)
+				if (ctnetlink_exp_id(exp) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -3208,9 +3212,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 						    cb->nlh->nlmsg_seq,
 						    IPCTNL_MSG_EXP_NEW,
 						    exp) < 0) {
-				if (!refcount_inc_not_zero(&exp->use))
-					continue;
-				cb->args[1] = (unsigned long)exp;
+				cb->args[1] = ctnetlink_exp_id(exp);
 				goto out;
 			}
 		}
@@ -3221,32 +3223,30 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	}
 out:
 	rcu_read_unlock();
-	if (last)
-		nf_ct_expect_put(last);
-
 	return skb->len;
 }
 
 static int
 ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct nf_conntrack_expect *exp, *last;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	struct nf_conn *ct = cb->data;
 	struct nf_conn_help *help = nfct_help(ct);
 	u_int8_t l3proto = nfmsg->nfgen_family;
+	unsigned long last_id = cb->args[1];
+	struct nf_conntrack_expect *exp;
 
 	if (cb->args[0])
 		return 0;
 
 	rcu_read_lock();
-	last = (struct nf_conntrack_expect *)cb->args[1];
+
 restart:
 	hlist_for_each_entry_rcu(exp, &help->expectations, lnode) {
 		if (l3proto && exp->tuple.src.l3num != l3proto)
 			continue;
 		if (cb->args[1]) {
-			if (exp != last)
+			if (ctnetlink_exp_id(exp) != last_id)
 				continue;
 			cb->args[1] = 0;
 		}
@@ -3254,9 +3254,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    cb->nlh->nlmsg_seq,
 					    IPCTNL_MSG_EXP_NEW,
 					    exp) < 0) {
-			if (!refcount_inc_not_zero(&exp->use))
-				continue;
-			cb->args[1] = (unsigned long)exp;
+			cb->args[1] = ctnetlink_exp_id(exp);
 			goto out;
 		}
 	}
@@ -3267,9 +3265,6 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->args[0] = 1;
 out:
 	rcu_read_unlock();
-	if (last)
-		nf_ct_expect_put(last);
-
 	return skb->len;
 }
 
@@ -3288,7 +3283,6 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
-		.done = ctnetlink_exp_done,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
@@ -3338,7 +3332,6 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 		else {
 			struct netlink_dump_control c = {
 				.dump = ctnetlink_exp_dump_table,
-				.done = ctnetlink_exp_done,
 			};
 			return netlink_dump_start(info->sk, skb, info->nlh, &c);
 		}
-- 
2.49.1

