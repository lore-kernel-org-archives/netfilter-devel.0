Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE09143C40;
	Tue, 24 Sep 2024 20:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727208860; cv=none; b=CrC+NAY11mdqJA/UNP5po1faKnNwaoqHJW8xubx3Fe5BRx8z0Ifw8aCgtnNnmKW3bf2SX9+lI5cv8awVUPIiX/9yqfao/MxIJiu8UkdaTJnPL/z1WEfzt09DEseqijlpd003EIDkt3/q4sredkrWzKAe6ZvVKqraSbslOG1gG54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727208860; c=relaxed/simple;
	bh=C5FDE7pCQvVkoVUtyXiNhBw15TJ1fM+jODRayTHfoOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m3XPnRY8CzbkmOIbc7Rk/zMfcfwvEI/hl0FgSztUmifZKMGV8h3a25vcAtoTAzCOzz+LEH/sHUjqS7SR/PaL7hL1vgbttedPCOnGPgrcbdvwZvtBB8aah/47rsRhHEHBrwWDsg+B9EDyIqcBHVLMgQzVZZAT2m/xgLO5fNqjcgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 12/14] netfilter: nfnetlink_queue: remove old clash resolution logic
Date: Tue, 24 Sep 2024 22:13:59 +0200
Message-Id: <20240924201401.2712-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240924201401.2712-1-pablo@netfilter.org>
References: <20240924201401.2712-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

For historical reasons there are two clash resolution spots in
netfilter, one in nfnetlink_queue and one in conntrack core.

nfnetlink_queue one was added first: If a colliding entry is found, NAT
NAT transformation is reversed by calling nat engine again with altered
tuple.

See commit 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for
unconfirmed conntracks") for details.

One problem is that nf_reroute() won't take an action if the queueing
doesn't occur in the OUTPUT hook, i.e. when queueing in forward or
postrouting, packet will be sent via the wrong path.

Another problem is that the scenario addressed (2nd UDP packet sent with
identical addresses while first packet is still being processed) can also
occur without any nfqueue involvement due to threaded resolvers doing
A and AAAA requests back-to-back.

This lead us to add clash resolution logic to the conntrack core, see
commit 6a757c07e51f ("netfilter: conntrack: allow insertion of clashing
entries").  Instead of fixing the nfqueue based logic, lets remove it
and let conntrack core handle this instead.

Retain the ->update hook for sake of nfqueue based conntrack helpers.
We could axe this hook completely but we'd have to split confirm and
helper logic again, see commit ee04805ff54a ("netfilter: conntrack: make
conntrack userspace helpers work again").

This SHOULD NOT be backported to kernels earlier than v5.6; they lack
adequate clash resolution handling.

Patch was originally written by Pablo Neira Ayuso.

Reported-by: Antonio Ojea <aojea@google.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1766
Signed-off-by: Florian Westphal <fw@strlen.de>
Tested-by: Antonio Ojea <aojea@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h         |  4 --
 net/netfilter/nf_conntrack_core.c | 85 -------------------------------
 net/netfilter/nf_nat_core.c       |  1 -
 3 files changed, 90 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2683b2b77612..2b8aac2c70ad 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -376,15 +376,11 @@ int nf_route(struct net *net, struct dst_entry **dst, struct flowi *fl,
 struct nf_conn;
 enum nf_nat_manip_type;
 struct nlattr;
-enum ip_conntrack_dir;
 
 struct nf_nat_hook {
 	int (*parse_nat_setup)(struct nf_conn *ct, enum nf_nat_manip_type manip,
 			       const struct nlattr *attr);
 	void (*decode_session)(struct sk_buff *skb, struct flowi *fl);
-	unsigned int (*manip_pkt)(struct sk_buff *skb, struct nf_conn *ct,
-				  enum nf_nat_manip_type mtype,
-				  enum ip_conntrack_dir dir);
 	void (*remove_nat_bysrc)(struct nf_conn *ct);
 };
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5f21dc7b8e90..852448a7cf8f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2197,80 +2197,6 @@ static void nf_conntrack_attach(struct sk_buff *nskb, const struct sk_buff *skb)
 	nf_conntrack_get(skb_nfct(nskb));
 }
 
-static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
-				 struct nf_conn *ct,
-				 enum ip_conntrack_info ctinfo)
-{
-	const struct nf_nat_hook *nat_hook;
-	struct nf_conntrack_tuple_hash *h;
-	struct nf_conntrack_tuple tuple;
-	unsigned int status;
-	int dataoff;
-	u16 l3num;
-	u8 l4num;
-
-	l3num = nf_ct_l3num(ct);
-
-	dataoff = get_l4proto(skb, skb_network_offset(skb), l3num, &l4num);
-	if (dataoff <= 0)
-		return NF_DROP;
-
-	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
-			     l4num, net, &tuple))
-		return NF_DROP;
-
-	if (ct->status & IPS_SRC_NAT) {
-		memcpy(tuple.src.u3.all,
-		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.all,
-		       sizeof(tuple.src.u3.all));
-		tuple.src.u.all =
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.all;
-	}
-
-	if (ct->status & IPS_DST_NAT) {
-		memcpy(tuple.dst.u3.all,
-		       ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.all,
-		       sizeof(tuple.dst.u3.all));
-		tuple.dst.u.all =
-			ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.all;
-	}
-
-	h = nf_conntrack_find_get(net, nf_ct_zone(ct), &tuple);
-	if (!h)
-		return NF_ACCEPT;
-
-	/* Store status bits of the conntrack that is clashing to re-do NAT
-	 * mangling according to what it has been done already to this packet.
-	 */
-	status = ct->status;
-
-	nf_ct_put(ct);
-	ct = nf_ct_tuplehash_to_ctrack(h);
-	nf_ct_set(skb, ct, ctinfo);
-
-	nat_hook = rcu_dereference(nf_nat_hook);
-	if (!nat_hook)
-		return NF_ACCEPT;
-
-	if (status & IPS_SRC_NAT) {
-		unsigned int verdict = nat_hook->manip_pkt(skb, ct,
-							   NF_NAT_MANIP_SRC,
-							   IP_CT_DIR_ORIGINAL);
-		if (verdict != NF_ACCEPT)
-			return verdict;
-	}
-
-	if (status & IPS_DST_NAT) {
-		unsigned int verdict = nat_hook->manip_pkt(skb, ct,
-							   NF_NAT_MANIP_DST,
-							   IP_CT_DIR_ORIGINAL);
-		if (verdict != NF_ACCEPT)
-			return verdict;
-	}
-
-	return NF_ACCEPT;
-}
-
 /* This packet is coming from userspace via nf_queue, complete the packet
  * processing after the helper invocation in nf_confirm().
  */
@@ -2334,17 +2260,6 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 	if (!ct)
 		return NF_ACCEPT;
 
-	if (!nf_ct_is_confirmed(ct)) {
-		int ret = __nf_conntrack_update(net, skb, ct, ctinfo);
-
-		if (ret != NF_ACCEPT)
-			return ret;
-
-		ct = nf_ct_get(skb, &ctinfo);
-		if (!ct)
-			return NF_ACCEPT;
-	}
-
 	return nf_confirm_cthelper(skb, ct, ctinfo);
 }
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 728d7026ebd2..579ffafbc143 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1324,7 +1324,6 @@ static const struct nf_nat_hook nat_hook = {
 #ifdef CONFIG_XFRM
 	.decode_session		= __nf_nat_decode_session,
 #endif
-	.manip_pkt		= nf_nat_manip_pkt,
 	.remove_nat_bysrc	= nf_nat_cleanup_conntrack,
 };
 
-- 
2.30.2

