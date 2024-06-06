Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E167D1D696;
	Thu,  6 Jun 2024 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717679106; cv=none; b=CUCanjaYpAsOQHu5bHpc5O97oMbEjggMKH9j1es+5P/7LmBH1WzYdeaFbwXIa8UTcBg6FSMJyV4mbtxs7kMjfXvjC4ULkN99ggQtlCo+gNSYU3JGgMKnHVRt0t716W9TJk2l8inVVbpgBHb1kpovPOoUYdC04LZ1YaTJVJz4UQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717679106; c=relaxed/simple;
	bh=ipNwps6GA/THnHJMQ4ov1vutBYXr+eaMshxe1CAGqNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPmycRG68NfTYtSwkKX+SquAx/DX4I8BFSi7MXfrEuB2lxfsY6+0W4mziDlpBXBgs7EvXtzkOYAXVrtjwfThUOrzrZP9tpyP6MRUedc6FFDHw43rhstLMXWoGPvBJQ9DCBBxsFBU4/HtBjzMYouH90q+sa29fLMt3ejHf7+bW/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sFCnZ-0003EH-75; Thu, 06 Jun 2024 15:04:57 +0200
Date: Thu, 6 Jun 2024 15:04:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240606130457.GA9890@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606092620.GC4688@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Florian Westphal <fw@strlen.de> wrote:
> ... doesn't solve the nft_hash.c issue (which calls _symmetric version, and
> that uses flow_key definiton that isn't exported outside flow_dissector.o.

and here is the diff that would pass net for _symmetric, not too
horrible I think.

With that and the copypaste of skb_get_hash into nf_trace infra
netfilter can still pass skbs to the flow dissector with NULL skb->sk,dev
but the WARN would no longer trigger as struct net is non-null.

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9254bca2813d..e9e6cf3d148c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -524,12 +524,13 @@ static inline void tun_flow_save_rps_rxhash(struct tun_flow_entry *e, u32 hash)
  */
 static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
 {
+	const struct net *net = dev_net(tun->dev);
 	struct tun_flow_entry *e;
 	u32 txq, numqueues;
 
 	numqueues = READ_ONCE(tun->numqueues);
 
-	txq = __skb_get_hash_symmetric(skb);
+	txq = __skb_get_hash_symmetric(net, skb);
 	e = tun_flow_find(&tun->flows[tun_hashfn(txq)], txq);
 	if (e) {
 		tun_flow_save_rps_rxhash(e, txq);
@@ -1038,10 +1039,11 @@ static void tun_automq_xmit(struct tun_struct *tun, struct sk_buff *skb)
 		/* Select queue was not called for the skbuff, so we extract the
 		 * RPS hash and save it into the flow_table here.
 		 */
+		const struct net *net = dev_net(tun->dev);
 		struct tun_flow_entry *e;
 		__u32 rxhash;
 
-		rxhash = __skb_get_hash_symmetric(skb);
+		rxhash = __skb_get_hash_symmetric(net, skb);
 		e = tun_flow_find(&tun->flows[tun_hashfn(rxhash)], rxhash);
 		if (e)
 			tun_flow_save_rps_rxhash(e, rxhash);
@@ -1938,7 +1940,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	 */
 	if (!rcu_access_pointer(tun->steering_prog) && tun->numqueues > 1 &&
 	    !tfile->detached)
-		rxhash = __skb_get_hash_symmetric(skb);
+		rxhash = __skb_get_hash_symmetric(dev_net(tun->dev), skb);
 
 	rcu_read_lock();
 	if (unlikely(!(tun->dev->flags & IFF_UP))) {
@@ -2521,7 +2523,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 
 	if (!rcu_dereference(tun->steering_prog) && tun->numqueues > 1 &&
 	    !tfile->detached)
-		rxhash = __skb_get_hash_symmetric(skb);
+		rxhash = __skb_get_hash_symmetric(dev_net(tun->dev), skb);
 
 	if (tfile->napi_enabled) {
 		queue = &tfile->sk.sk_write_queue;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1c2902eaebd3..60a4dc5586c8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1493,7 +1493,7 @@ __skb_set_sw_hash(struct sk_buff *skb, __u32 hash, bool is_l4)
 }
 
 void __skb_get_hash(struct sk_buff *skb);
-u32 __skb_get_hash_symmetric(const struct sk_buff *skb);
+u32 __skb_get_hash_symmetric(const struct net *net, const struct sk_buff *skb);
 u32 skb_get_poff(const struct sk_buff *skb);
 u32 __skb_get_poff(const struct sk_buff *skb, const void *data,
 		   const struct flow_keys_basic *keys, int hlen);
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index f82e9a7d3b37..634896129780 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1831,14 +1831,14 @@ EXPORT_SYMBOL(make_flow_keys_digest);
 
 static struct flow_dissector flow_keys_dissector_symmetric __read_mostly;
 
-u32 __skb_get_hash_symmetric(const struct sk_buff *skb)
+u32 __skb_get_hash_symmetric(const struct net *net, const struct sk_buff *skb)
 {
 	struct flow_keys keys;
 
 	__flow_hash_secret_init();
 
 	memset(&keys, 0, sizeof(keys));
-	__skb_flow_dissect(NULL, skb, &flow_keys_dissector_symmetric,
+	__skb_flow_dissect(net, skb, &flow_keys_dissector_symmetric,
 			   &keys, NULL, 0, 0, 0, 0);
 
 	return __flow_hash_from_keys(&keys, &hashrnd);
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 92d47e469204..3e7296ed5319 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -51,7 +51,8 @@ static void nft_symhash_eval(const struct nft_expr *expr,
 	struct sk_buff *skb = pkt->skb;
 	u32 h;
 
-	h = reciprocal_scale(__skb_get_hash_symmetric(skb), priv->modulus);
+	h = reciprocal_scale(__skb_get_hash_symmetric(nft_net(pkt), skb),
+			     priv->modulus);
 
 	regs->data[priv->dreg] = h + priv->offset;
 }
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 964225580824..0e6166784972 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1084,7 +1084,8 @@ static int clone(struct datapath *dp, struct sk_buff *skb,
 			     !dont_clone_flow_key);
 }
 
-static void execute_hash(struct sk_buff *skb, struct sw_flow_key *key,
+static void execute_hash(const struct net *net,
+			 struct sk_buff *skb, struct sw_flow_key *key,
 			 const struct nlattr *attr)
 {
 	struct ovs_action_hash *hash_act = nla_data(attr);
@@ -1097,7 +1098,7 @@ static void execute_hash(struct sk_buff *skb, struct sw_flow_key *key,
 		/* OVS_HASH_ALG_SYM_L4 hashing type.  NOTE: this doesn't
 		 * extend past an encapsulated header.
 		 */
-		hash = __skb_get_hash_symmetric(skb);
+		hash = __skb_get_hash_symmetric(net, skb);
 	}
 
 	hash = jhash_1word(hash, hash_act->hash_basis);
@@ -1359,7 +1360,7 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 			break;
 
 		case OVS_ACTION_ATTR_HASH:
-			execute_hash(skb, key, a);
+			execute_hash(ovs_dp_get_net(dp), skb, key, a);
 			break;
 
 		case OVS_ACTION_ATTR_PUSH_MPLS: {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ea3ebc160e25..b047fdb0c02c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1364,7 +1364,9 @@ static unsigned int fanout_demux_hash(struct packet_fanout *f,
 				      struct sk_buff *skb,
 				      unsigned int num)
 {
-	return reciprocal_scale(__skb_get_hash_symmetric(skb), num);
+	struct net *net = read_pnet(&f->net);
+
+	return reciprocal_scale(__skb_get_hash_symmetric(net, skb), num);
 }
 
 static unsigned int fanout_demux_lb(struct packet_fanout *f,
