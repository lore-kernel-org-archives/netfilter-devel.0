Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4D3C5479D
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Jan 2023 11:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbjABLqn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 06:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbjABLqc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 06:46:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFD8F18
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Jan 2023 03:46:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pCJGv-0004rH-Nz; Mon, 02 Jan 2023 12:46:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: conntrack: remove pr_debug calls
Date:   Mon,  2 Jan 2023 12:46:11 +0100
Message-Id: <20230102114612.15860-3-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230102114612.15860-1-fw@strlen.de>
References: <20230102114612.15860-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Those are all useless or dubious.
getorigdst() is called via setsockopt, so return value/errno will
already indicate an appropriate error.

For other pr_debug calls there are better replacements, such as
slab/slub debugging or 'conntrack -E' (ctnetlink events).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c      | 20 ++------------------
 net/netfilter/nf_conntrack_proto.c     | 20 +++-----------------
 net/netfilter/nf_conntrack_proto_tcp.c |  9 ---------
 3 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 93ab191917cf..17c72d276868 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -514,7 +514,6 @@ EXPORT_SYMBOL_GPL(nf_ct_get_id);
 static void
 clean_from_lists(struct nf_conn *ct)
 {
-	pr_debug("clean_from_lists(%p)\n", ct);
 	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
 	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode);
 
@@ -582,7 +581,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 {
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
-	pr_debug("%s(%p)\n", __func__, ct);
 	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
@@ -603,7 +601,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	if (ct->master)
 		nf_ct_put(ct->master);
 
-	pr_debug("%s: returning ct=%p to slab\n", __func__, ct);
 	nf_conntrack_free(ct);
 }
 EXPORT_SYMBOL(nf_ct_destroy);
@@ -1211,7 +1208,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		goto dying;
 	}
 
-	pr_debug("Confirming conntrack %p\n", ct);
 	/* We have to check the DYING flag after unlink to prevent
 	 * a race against nf_ct_get_next_corpse() possibly called from
 	 * user context, else we insert an already 'dead' hash, blocking
@@ -1722,10 +1718,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conntrack_zone tmp;
 	struct nf_conntrack_net *cnet;
 
-	if (!nf_ct_invert_tuple(&repl_tuple, tuple)) {
-		pr_debug("Can't invert tuple.\n");
+	if (!nf_ct_invert_tuple(&repl_tuple, tuple))
 		return NULL;
-	}
 
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
 	ct = __nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC,
@@ -1765,8 +1759,6 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		spin_lock_bh(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
 		if (exp) {
-			pr_debug("expectation arrives ct=%p exp=%p\n",
-				 ct, exp);
 			/* Welcome, Mr. Bond.  We've been expecting you... */
 			__set_bit(IPS_EXPECTED_BIT, &ct->status);
 			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
@@ -1830,10 +1822,8 @@ resolve_normal_ct(struct nf_conn *tmpl,
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb),
 			     dataoff, state->pf, protonum, state->net,
-			     &tuple)) {
-		pr_debug("Can't get tuple\n");
+			     &tuple))
 		return 0;
-	}
 
 	/* look for tuple match */
 	zone = nf_ct_zone_tmpl(tmpl, skb, &tmp);
@@ -1867,13 +1857,10 @@ resolve_normal_ct(struct nf_conn *tmpl,
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
 		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-			pr_debug("normal packet for %p\n", ct);
 			ctinfo = IP_CT_ESTABLISHED;
 		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
-			pr_debug("related packet for %p\n", ct);
 			ctinfo = IP_CT_RELATED;
 		} else {
-			pr_debug("new packet for %p\n", ct);
 			ctinfo = IP_CT_NEW;
 		}
 	}
@@ -1989,7 +1976,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	/* rcu_read_lock()ed by nf_hook_thresh */
 	dataoff = get_l4proto(skb, skb_network_offset(skb), state->pf, &protonum);
 	if (dataoff <= 0) {
-		pr_debug("not prepared to track yet or error occurred\n");
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
 		ret = NF_ACCEPT;
 		goto out;
@@ -2028,7 +2014,6 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 	if (ret <= 0) {
 		/* Invalid: inverse of the return code tells
 		 * the netfilter core what to do */
-		pr_debug("nf_conntrack_in: Can't track with proto module\n");
 		nf_ct_put(ct);
 		skb->_nfct = 0;
 		/* Special case: TCP tracker reports an attempt to reopen a
@@ -2067,7 +2052,6 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 	/* Should be unconfirmed, so not in hash table yet */
 	WARN_ON(nf_ct_is_confirmed(ct));
 
-	pr_debug("Altering reply tuple of %p to ", ct);
 	nf_ct_dump_tuple(newreply);
 
 	ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 99323fb12d0f..c4c1e38fa5e8 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -281,16 +281,11 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 
 	/* We only do TCP and SCTP at the moment: is there a better way? */
 	if (tuple.dst.protonum != IPPROTO_TCP &&
-	    tuple.dst.protonum != IPPROTO_SCTP) {
-		pr_debug("SO_ORIGINAL_DST: Not a TCP/SCTP socket\n");
+	    tuple.dst.protonum != IPPROTO_SCTP)
 		return -ENOPROTOOPT;
-	}
 
-	if ((unsigned int)*len < sizeof(struct sockaddr_in)) {
-		pr_debug("SO_ORIGINAL_DST: len %d not %zu\n",
-			 *len, sizeof(struct sockaddr_in));
+	if ((unsigned int)*len < sizeof(struct sockaddr_in))
 		return -EINVAL;
-	}
 
 	h = nf_conntrack_find_get(sock_net(sk), &nf_ct_zone_dflt, &tuple);
 	if (h) {
@@ -304,17 +299,12 @@ getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 			.tuple.dst.u3.ip;
 		memset(sin.sin_zero, 0, sizeof(sin.sin_zero));
 
-		pr_debug("SO_ORIGINAL_DST: %pI4 %u\n",
-			 &sin.sin_addr.s_addr, ntohs(sin.sin_port));
 		nf_ct_put(ct);
 		if (copy_to_user(user, &sin, sizeof(sin)) != 0)
 			return -EFAULT;
 		else
 			return 0;
 	}
-	pr_debug("SO_ORIGINAL_DST: Can't find %pI4/%u-%pI4/%u.\n",
-		 &tuple.src.u3.ip, ntohs(tuple.src.u.tcp.port),
-		 &tuple.dst.u3.ip, ntohs(tuple.dst.u.tcp.port));
 	return -ENOENT;
 }
 
@@ -357,12 +347,8 @@ ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
 		return -EINVAL;
 
 	h = nf_conntrack_find_get(sock_net(sk), &nf_ct_zone_dflt, &tuple);
-	if (!h) {
-		pr_debug("IP6T_SO_ORIGINAL_DST: Can't find %pI6c/%u-%pI6c/%u.\n",
-			 &tuple.src.u3.ip6, ntohs(tuple.src.u.tcp.port),
-			 &tuple.dst.u3.ip6, ntohs(tuple.dst.u.tcp.port));
+	if (!h)
 		return -ENOENT;
-	}
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 656631083177..21a3741162ba 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -930,7 +930,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
-	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
 	enum nf_ct_tcp_action res;
@@ -954,7 +953,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	dir = CTINFO2DIR(ctinfo);
 	index = get_conntrack_index(th);
 	new_state = tcp_conntracks[dir][index][old_state];
-	tuple = &ct->tuplehash[dir].tuple;
 
 	switch (new_state) {
 	case TCP_CONNTRACK_SYN_SENT:
@@ -1217,13 +1215,6 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	ct->proto.tcp.last_index = index;
 	ct->proto.tcp.last_dir = dir;
 
-	pr_debug("tcp_conntracks: ");
-	nf_ct_dump_tuple(tuple);
-	pr_debug("syn=%i ack=%i fin=%i rst=%i old=%i new=%i\n",
-		 (th->syn ? 1 : 0), (th->ack ? 1 : 0),
-		 (th->fin ? 1 : 0), (th->rst ? 1 : 0),
-		 old_state, new_state);
-
 	ct->proto.tcp.state = new_state;
 	if (old_state != new_state
 	    && new_state == TCP_CONNTRACK_FIN_WAIT)
-- 
2.38.2

