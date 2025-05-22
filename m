Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95F29B22D;
	Thu, 22 May 2025 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747932793; cv=none; b=PV7wKqvOf+MZEmZM+5SJ6JbJc5kXODuNSw9Pu+vSaS7VazcBmCShZePUgf9OIgBGToLtaj8G+VrzMzVJccRMJ5v0iGobXbfs3Fr2AHIauR7j+bebVeHJYoJSC5Z5a3KDuIpdeUqGPKki8cjcoQbLRyhE2Hmdyrnn3fyAswxicA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747932793; c=relaxed/simple;
	bh=LEiauz+zWpCfyU9UT7XYHMLagbCZtN10b/0Jh695pSY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LG0f+o//LnFfGnw4ECG3CG+6N58acv9U7oY8fjE3SgqUUaw04W2b6QPdOtLYJknYH8sk+YRYFbb3V1Yp/e7uTFF+LunZt/KNPh6dlb2dWXLewgEOXwep4TyG3y9FnXF3xk1u6N+ZU8F+csxm/GaNR3QwpzEur5oIHEx4ws5eELg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QUUV9CyY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jgn/eDdr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QUUV9CyY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jgn/eDdr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id E3F4F60742; Thu, 22 May 2025 18:53:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932790;
	bh=OSqhPbdT5k/HQXhpBxzIiOIubefCV6Annz6LnYqQNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUUV9CyY6phfrrM1gT1OuvS/3TUYV3Hzaqz4RT+nYuBSpee1Np/FJsSM/2Tvpf1qE
	 MWnGTBAqgIrJkh69E5Yc1EHF2XxriVB4bp9GKKGhFfxAGw9grP56MOQKALuY1o98gR
	 JMKduhMrw3SqWuNByBbQG3eiri+6TRXsZhcJ9fz8guNs5RHH6bgNMzMHLkj2rFRSYX
	 5JouWscGYThCrqvLgBPa/f+jz/xv89L/J6nN34epBdPZocy94e31imckfqiYPQ6xyX
	 mW6RGtgxaswAPD5FqRma4A0I63zXiRl9qofW3VFgaZhx/dVyUfiWra6se1Gb74ZjjC
	 /hLzfRdJgQqZA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AB05D60718;
	Thu, 22 May 2025 18:52:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747932773;
	bh=OSqhPbdT5k/HQXhpBxzIiOIubefCV6Annz6LnYqQNkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgn/eDdrCN1f0oXWsUYyluuCfqshXLqARBr+6gqsfMUv2h81R0zp5EzIbgkfNS5+X
	 p4q3ShZJtjiU877tf1k5qkRV4c/6XDMqmzjji7eqKnBHWcupEx8rZ7n8LBy8WGUC/S
	 an7q01uOzZLJDY1T1XDTuYbFKmamdmFotBR6qCG97V9MK86+ZvYTp8ZN7ZBXKcNen0
	 2TYlS+2BBEy1zOtqJ7SjZ7i65u99MQWyRpeno4qbd4CtWGHY6Tmb6NsGmM9vJcjRPA
	 azr5XnaTS+Zp0jx2FPrpgtVb8CMeMA8Y3CjIk9RjkUz3PRJuzY0Vw+xXJVcRtalG8d
	 avJosGklYDe8A==
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
Date: Thu, 22 May 2025 18:52:21 +0200
Message-Id: <20250522165238.378456-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250522165238.378456-1-pablo@netfilter.org>
References: <20250522165238.378456-1-pablo@netfilter.org>
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

