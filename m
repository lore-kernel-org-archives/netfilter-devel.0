Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CFD2920AE;
	Fri, 23 May 2025 13:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006870; cv=none; b=Lvifq7+7T8xV0/oaTJ2r3g1nKFikgKNhxN6ud9+a8vOdmkTvyZVAqQP+rhQR8z96UVn9QMVDLzfIkmuZgYt3NOIXxBf0k4TVntoZfm+kwopLbrp1tbwZ5wZMp4omsZXJLnX31mvk9d6VA1tewErYCVs56SUSlAFdkQzLOfOnTEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006870; c=relaxed/simple;
	bh=LEiauz+zWpCfyU9UT7XYHMLagbCZtN10b/0Jh695pSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BJSp9H0iuXHVEGeNf48j8Vcy8xel3X225Or8FuAaepDH/YUkXn2k3e/TtWiQif5FfDskMUXRiD80Zpmf3Qf8UYU6Lhycwb8CbLj2Vo4rgSqH24xFl9UCcfDm7t5bPY3Q/+R8lM0J2bE4CGsGkA99ug6G8YmY7TqdgPsylN+Gee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Khq9oSsM; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ppq+Ey8H; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Khq9oSsM";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ppq+Ey8H"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C6D5A60783; Fri, 23 May 2025 15:27:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006866;
	bh=OSqhPbdT5k/HQXhpBxzIiOIubefCV6Annz6LnYqQNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Khq9oSsMpAkq2E5fnQSz5fUMQDWFct8q/zYrT6cKsW+8flXFl/+RkDhdeDcQuk4+z
	 fhvZWxIMOqmsgzaR7M2OAZJivKTws1UXvGfG88z8n4nAqG1O7dTIFrMUzb5G3SPJUS
	 mGc86aOqhTCSlC+TWgH4dQ8RW+5mTUkjB3aMGj7C9BPPdjD9N/PL9VPHOM/9J/2K3v
	 KMHZYQ6sBL+goZxf7s68QZ73HFxtTG4fTKNdJjXoKDwP9Zd3HkU8ONORFUx3dlTgKj
	 mgng6MExxK1jplTqpFT+CSIl4gXjgukUIvP5EdBJmJJxhDnYlf3W9NxM6ZGgC2skph
	 e264swjt21wfA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CFFBF60779;
	Fri, 23 May 2025 15:27:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006846;
	bh=OSqhPbdT5k/HQXhpBxzIiOIubefCV6Annz6LnYqQNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppq+Ey8HzXoib2EOwsQaNAdaQIOQvxJ7TH0u8rp15UHp1/ggSVTDLRYr0UsNqGOtc
	 auveECUKKudY0dHe1gnZ9dfSXungymeO6SCMN6xyK+7TSwSRl7DAPrf0A3KEJdVGKw
	 o/GEV3WdUUdLa/U7zxzlU4t0N7a5ciVmI8OsgBdOGm38JEyANo763ZlL49gCJg+EFg
	 whh1CQPFK6D7zLjyogKaVRG3xIjE/mb4MAcvUsMHwnb7CitD0CBTDVa2xK5KdvRFng
	 lRv7Z5PTX4FyfxalOTNJURIebffjfssKLyaGNDSPoUWXl6HWZVOPOEB3BlSgrCaOGh
	 g2RsI+AzQD21w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 09/26] netfilter: nf_dup{4, 6}: Move duplication check to task_struct
Date: Fri, 23 May 2025 15:26:55 +0200
Message-Id: <20250523132712.458507-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

nf_skb_duplicated is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Due to the recursion involved, the simplest change is to make it a
per-task variable.

Move the per-CPU variable nf_skb_duplicated to task_struct and name it
in_nf_duplicate. Add it to the existing bitfield so it doesn't use
additional memory.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h        | 11 -----------
 include/linux/sched.h            |  1 +
 net/ipv4/netfilter/ip_tables.c   |  2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c |  6 +++---
 net/ipv6/netfilter/ip6_tables.c  |  2 +-
 net/ipv6/netfilter/nf_dup_ipv6.c |  6 +++---
 net/netfilter/core.c             |  3 ---
 7 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2b8aac2c70ad..892d12823ed4 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -497,17 +497,6 @@ struct nf_defrag_hook {
 extern const struct nf_defrag_hook __rcu *nf_defrag_v4_hook;
 extern const struct nf_defrag_hook __rcu *nf_defrag_v6_hook;
 
-/*
- * nf_skb_duplicated - TEE target has sent a packet
- *
- * When a xtables target sends a packet, the OUTPUT and POSTROUTING
- * hooks are traversed again, i.e. nft and xtables are invoked recursively.
- *
- * This is used by xtables TEE target to prevent the duplicated skb from
- * being duplicated again.
- */
-DECLARE_PER_CPU(bool, nf_skb_duplicated);
-
 /*
  * Contains bitmask of ctnetlink event subscribers, if any.
  * Can't be pernet due to NETLINK_LISTEN_ALL_NSID setsockopt flag.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f96ac1982893..52d9c52dc8f2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1044,6 +1044,7 @@ struct task_struct {
 	/* delay due to memory thrashing */
 	unsigned                        in_thrashing:1;
 #endif
+	unsigned			in_nf_duplicate:1;
 #ifdef CONFIG_PREEMPT_RT
 	struct netdev_xmit		net_xmit;
 #endif
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3d101613f27f..23c8deff8095 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -270,7 +270,7 @@ ipt_do_table(void *priv,
 	 * but it is no problem since absolute verdict is issued by these.
 	 */
 	if (static_key_false(&xt_tee_enabled))
-		jumpstack += private->stacksize * __this_cpu_read(nf_skb_duplicated);
+		jumpstack += private->stacksize * current->in_nf_duplicate;
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 25e1e8eb18dd..ed08fb78cfa8 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -54,7 +54,7 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	struct iphdr *iph;
 
 	local_bh_disable();
-	if (this_cpu_read(nf_skb_duplicated))
+	if (current->in_nf_duplicate)
 		goto out;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -86,9 +86,9 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		--iph->ttl;
 
 	if (nf_dup_ipv4_route(net, skb, gw, oif)) {
-		__this_cpu_write(nf_skb_duplicated, true);
+		current->in_nf_duplicate = true;
 		ip_local_out(net, skb->sk, skb);
-		__this_cpu_write(nf_skb_duplicated, false);
+		current->in_nf_duplicate = false;
 	} else {
 		kfree_skb(skb);
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7d5602950ae7..d585ac3c1113 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -292,7 +292,7 @@ ip6t_do_table(void *priv, struct sk_buff *skb,
 	 * but it is no problem since absolute verdict is issued by these.
 	 */
 	if (static_key_false(&xt_tee_enabled))
-		jumpstack += private->stacksize * __this_cpu_read(nf_skb_duplicated);
+		jumpstack += private->stacksize * current->in_nf_duplicate;
 
 	e = get_entry(table_base, private->hook_entry[hook]);
 
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 0c39c77fe8a8..b903c62c00c9 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -48,7 +48,7 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif)
 {
 	local_bh_disable();
-	if (this_cpu_read(nf_skb_duplicated))
+	if (current->in_nf_duplicate)
 		goto out;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -64,9 +64,9 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		--iph->hop_limit;
 	}
 	if (nf_dup_ipv6_route(net, skb, gw, oif)) {
-		__this_cpu_write(nf_skb_duplicated, true);
+		current->in_nf_duplicate = true;
 		ip6_local_out(net, skb->sk, skb);
-		__this_cpu_write(nf_skb_duplicated, false);
+		current->in_nf_duplicate = false;
 	} else {
 		kfree_skb(skb);
 	}
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index b9f551f02c81..11a702065bab 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -31,9 +31,6 @@
 const struct nf_ipv6_ops __rcu *nf_ipv6_ops __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ipv6_ops);
 
-DEFINE_PER_CPU(bool, nf_skb_duplicated);
-EXPORT_SYMBOL_GPL(nf_skb_duplicated);
-
 #ifdef CONFIG_JUMP_LABEL
 struct static_key nf_hooks_needed[NFPROTO_NUMPROTO][NF_MAX_HOOKS];
 EXPORT_SYMBOL(nf_hooks_needed);
-- 
2.30.2

