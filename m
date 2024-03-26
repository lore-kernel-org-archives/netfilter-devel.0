Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D984D1CA96;
	Tue, 26 Mar 2024 01:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711416538; cv=none; b=T66shiAaO9CBOD8hKHQnVlq0A+HM3S++mr+OFeGPX0/WXTzxGkHHpwIVO6RLd/K7iz0TJDMZ1bmzvLK1LpeXOWBNBD3JVMOXZ5d2q8xpfKSRoMygUsdYHZZegwihFxfp4/0Fq4CYfblD4GUcfxEG+Uk7EmDfXL0gVz7q1e5ni7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711416538; c=relaxed/simple;
	bh=kWGAI+s1Pxqt7bonCtG1vJfxljCi4nW5f1ezyFmQZtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l344mnmQ57xdgSTjFO/n77IdT8q9VO9FZYel6eu75rX7Q1f3szAgUpLOcC7OZSS0VDwggC+wpPcJcI47UVUhHUJnyegU5VrvCzNUPrLtzeoidIOeSMA4gc1ASOYQi9FdbnWFbj1t5pl7+JbwDNzKmjXUHI8NPPjX4xae3PA8VBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Tue, 26 Mar 2024 02:28:48 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jianbo Liu <jianbol@nvidia.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"fw@strlen.de" <fw@strlen.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [BUG] kernel warning from br_nf_local_in+0x157/0x180
Message-ID: <ZgIkm3KNK78qpptx@calendula>
References: <ac03a9ba41e130123cd680be6df9f30be95d0f98.camel@nvidia.com>
 <Zf15Ni8CuRLNnBAJ@calendula>
 <d6084a1cdd0e6d2133c8586936266aedd8eb3564.camel@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sSihlBUZoJ3qz12H"
Content-Disposition: inline
In-Reply-To: <d6084a1cdd0e6d2133c8586936266aedd8eb3564.camel@nvidia.com>


--sSihlBUZoJ3qz12H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Sat, Mar 23, 2024 at 10:37:16AM +0000, Jianbo Liu wrote:
> On Fri, 2024-03-22 at 13:27 +0100, Pablo Neira Ayuso wrote:
> > Hi Jianbo,
> > 
> > On Mon, Mar 18, 2024 at 09:41:46AM +0000, Jianbo Liu wrote:
> > > Hi Florian and Pablo,
> > > 
> > > We hit the following warning from br_nf_local_in+0x157/0x180.
> > 
> > Can you give a try to this patch?
> > 
> 
> Sorry, it doesn't fix.
> It looks fine when running the test manually. But the warning still
> appeared in our regression tests.

You mean different test triggers now the warning splat?

Not sure yet if this is the bug that is triggering the issue in your
testbed yet, but I find it odd that packets hitting the local_in hook
because promisc flag is set on can confirm conntrack entries.

Would you please give a try to this patch? Thanks!

--sSihlBUZoJ3qz12H
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index f21097e73482..0abdec77f0b0 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -137,7 +137,9 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 	if (p->flags & BR_LEARNING)
 		br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, 0);
 
-	local_rcv = !!(br->dev->flags & IFF_PROMISC);
+	BR_INPUT_SKB_CB(skb)->promisc = !!(br->dev->flags & IFF_PROMISC);
+	local_rcv = BR_INPUT_SKB_CB(skb)->promisc;
+
 	if (is_multicast_ether_addr(eth_hdr(skb)->h_dest)) {
 		/* by definition the broadcast is also a multicast address */
 		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 35e10c5a766d..22e35623c148 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -600,11 +600,17 @@ static unsigned int br_nf_local_in(void *priv,
 				   struct sk_buff *skb,
 				   const struct nf_hook_state *state)
 {
+	bool promisc = BR_INPUT_SKB_CB(skb)->promisc;
 	struct nf_conntrack *nfct = skb_nfct(skb);
 	const struct nf_ct_hook *ct_hook;
 	struct nf_conn *ct;
 	int ret;
 
+	if (promisc) {
+		nf_reset_ct(skb);
+		return NF_ACCEPT;
+	}
+
 	if (!nfct || skb->pkt_type == PACKET_HOST)
 		return NF_ACCEPT;
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 86ea5e6689b5..d4bedc87b1d8 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -589,6 +589,7 @@ struct br_input_skb_cb {
 #endif
 	u8 proxyarp_replied:1;
 	u8 src_port_isolated:1;
+	u8 promisc:1;
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 	u8 vlan_filtered:1;
 #endif
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 6f877e31709b..c3c51b9a6826 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -294,18 +294,24 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
 static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 				    const struct nf_hook_state *state)
 {
-	enum ip_conntrack_info ctinfo;
+	bool promisc = BR_INPUT_SKB_CB(skb)->promisc;
+	struct nf_conntrack *nfct = skb_nfct(skb);
 	struct nf_conn *ct;
 
-	if (skb->pkt_type == PACKET_HOST)
+	if (promisc) {
+		nf_reset_ct(skb);
+		return NF_ACCEPT;
+	}
+
+	if (!nfct || skb->pkt_type == PACKET_HOST)
 		return NF_ACCEPT;
 
 	/* nf_conntrack_confirm() cannot handle concurrent clones,
 	 * this happens for broad/multicast frames with e.g. macvlan on top
 	 * of the bridge device.
 	 */
-	ct = nf_ct_get(skb, &ctinfo);
-	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct))
+	ct = container_of(nfct, struct nf_conn, ct_general);
+	if (nf_ct_is_confirmed(ct) || nf_ct_is_template(ct))
 		return NF_ACCEPT;
 
 	/* let inet prerouting call conntrack again */

--sSihlBUZoJ3qz12H--
