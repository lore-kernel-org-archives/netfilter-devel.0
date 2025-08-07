Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFB6279DB0;
	Thu,  7 Aug 2025 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754566216; cv=none; b=PulNEwICvbkwG2flQe40K/S5wf/qoQCeGIBf2h99fN7IKibLGYt3t77KYvXV9ZFtmu3ngSZ1wW0z35dKxFy3rvI+M7Siy7LDLc4VOyb3DTEZTbEBhZUfP3RWfo2o1Q6qrJOEBROihjR6IvhZC4GWOWoE9XIz7QopZJcVI3fS50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754566216; c=relaxed/simple;
	bh=R3/Wv4n9fQuhTA28A/Tyejq6HQVq23M36whk3qag/Sk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h1hDR27Aw/rwgVpJf8pHyAl3tHMva2P8/4yqYCSsJtIS9nYkxZBbDFl32Sf2ZesSgrsiIjYOmyIE9w7XJg4diEikwPI+O4b2UhvX3kf3lID8nLkHXKKVCbCntUSo0ebac5GhISACeYkVzpKaG5fqcPiCqeaHcKbhQJB0g00iUyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NYC9ILCh; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cleo8ioU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NYC9ILCh";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cleo8ioU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C567F60921; Thu,  7 Aug 2025 13:30:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566204;
	bh=fbEBLLkFCNmDLWywaslhEGh8LUtbUEFZnjmJxCrJowc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYC9ILChyjbMdO2/22qxDPaZKgMmn0VuHzYDRWP/zAtehAO1sSink/R2i3jslTsPi
	 Pv/HAzETeM0duG4Lc6vhkYy7XGkCdwQxBrsxFjZV8HwrKlXoj3B4QN+kJrV1r/3fFH
	 e0XUEKJIoOtjc9PpNTqF5Esi/CySyS6xpZnnJXvfkpaxq+1G5Hxn5QPwe+HRBuvUT8
	 +34JP7Rn5s2fv1qXXpQTXy3sGDBmQFP1VxytqrRCtEnFTd12U/XWBajtqrhLOnDk9P
	 +HFn8X/JFk1l33z6vz1DGVg4IYaIc1vfE3DHlk+Sn4oQv6S/5DHxge0KOIzQtG4qAJ
	 xtOZ8oI7zkmCQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CFDC5605F2;
	Thu,  7 Aug 2025 13:29:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754566197;
	bh=fbEBLLkFCNmDLWywaslhEGh8LUtbUEFZnjmJxCrJowc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cleo8ioUs5AwkRRlYQPPlpR7QVQmWlphuxnSJL+xmtyB+GjP17Bjltykc3whDdLZn
	 Y/u360sCWNsOH+Dn07b4qhKIIWat4r569zRBcK/GKsQwHJ8uKG+pMuU78w4hJaIvRE
	 3AKAwp/PBWqVhVAE6NROuGLwIhCVhWh0AaQqrvynl9M17ZtskIVJMUIgzQzZBgdchZ
	 p2utPF0/VxbZtg5jL2H+pojOurpw3qbx/xRpjgzTBSGGWoZpeW32SWDAQyHVXs3V0Y
	 PMk3e2gJEMMuTaDg4ihSMGJbiSTV6XI0237u8SrXiAGiQ/AMsivjsZEJ2bweFkO+nn
	 rK73iwdJdRqgg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 4/7] netfilter: ctnetlink: remove refcounting in expectation dumpers
Date: Thu,  7 Aug 2025 13:29:45 +0200
Message-Id: <20250807112948.1400523-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250807112948.1400523-1-pablo@netfilter.org>
References: <20250807112948.1400523-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 41 ++++++++++++----------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index f403acd82437..50fd6809380f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3170,23 +3170,27 @@ ctnetlink_expect_event(unsigned int events, const struct nf_exp_event *item)
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
 	struct net *net = sock_net(skb->sk);
-	struct nf_conntrack_expect *exp, *last;
 	struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
 	u_int8_t l3proto = nfmsg->nfgen_family;
+	unsigned long last_id = cb->args[1];
+	struct nf_conntrack_expect *exp;
 
 	rcu_read_lock();
-	last = (struct nf_conntrack_expect *)cb->args[1];
 	for (; cb->args[0] < nf_ct_expect_hsize; cb->args[0]++) {
 restart:
 		hlist_for_each_entry_rcu(exp, &nf_ct_expect_hash[cb->args[0]],
@@ -3198,7 +3202,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 				continue;
 
 			if (cb->args[1]) {
-				if (exp != last)
+				if (ctnetlink_exp_id(exp) != last_id)
 					continue;
 				cb->args[1] = 0;
 			}
@@ -3207,9 +3211,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -3220,32 +3222,30 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -3253,9 +3253,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -3266,9 +3264,6 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	cb->args[0] = 1;
 out:
 	rcu_read_unlock();
-	if (last)
-		nf_ct_expect_put(last);
-
 	return skb->len;
 }
 
@@ -3287,7 +3282,6 @@ static int ctnetlink_dump_exp_ct(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_zone zone;
 	struct netlink_dump_control c = {
 		.dump = ctnetlink_exp_ct_dump_table,
-		.done = ctnetlink_exp_done,
 	};
 
 	err = ctnetlink_parse_tuple(cda, &tuple, CTA_EXPECT_MASTER,
@@ -3337,7 +3331,6 @@ static int ctnetlink_get_expect(struct sk_buff *skb,
 		else {
 			struct netlink_dump_control c = {
 				.dump = ctnetlink_exp_dump_table,
-				.done = ctnetlink_exp_done,
 			};
 			return netlink_dump_start(info->sk, skb, info->nlh, &c);
 		}
-- 
2.30.2

