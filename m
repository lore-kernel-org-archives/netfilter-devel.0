From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH next] netfilter: reject: don't send icmp error if packet
 has invalid checksum
Date: Sat, 31 Jan 2015 22:47:17 +0100
Message-ID: <20150131214717.GA24751@breakpoint.cc>
References: <1422525586-9760-1-git-send-email-fw@strlen.de>
 <20150129102157.GB5794@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44251 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751652AbbAaVrT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Jan 2015 16:47:19 -0500
Content-Disposition: inline
In-Reply-To: <20150129102157.GB5794@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jan 29, 2015 at 10:59:46AM +0100, Florian Westphal wrote:
> > tcp resets are never emitted if the packet that triggers the
> > reject/reset has an invalid checksum.
> > 
> > For icmp error responses there was no such check.
> > It allows to distinguish icmp response generated via
> > 
> > iptables -I INPUT -p udp --dport 42 -j REJECT
> > 
> > and those emitted by network stack (won't respond if csum is invalid,
> > REJECT does).
> > 
> > Arguably its possible to avoid this by using conntrack and only using
> > REJECT with -m conntrack NEW/RELATED.
> > 
> > However, this doesn't work when connection tracking is not in use or
> > when using nf_conntrack_checksum=0.
> > 
> > Furthermore, sending errors in response to invalid csums doesn't make
> > much sense so just add similar test as in nf_send_reset.
> 
> Could you also review net/bridge/netfilter/nft_reject_bridge.c?

Sorry that this took some time.  Gist is that this has a few issues at
the moment, its not working for me.

Some issues that I found:
Doesn't work in INPUT since skb->dev is the bridge port, so we end
with NULL br_port_get_rcu (no crash, br_deliver is noop).

After fixing INPUT issue, nft reject from bridge works if
nf-call-iptables is on, most likely due to extra pskb_trim_rcsum
done by bridge_netfilter before PREROUTING invocation for ipv4.

Adding an explicit call to pskb_trim_rcsum() seemed to make reject
work from bridge layer in both prerouting and input.

Untested further possible issues:

seems nf*_ip_checksum() only works for UDP or TCP, not with
e.g. SCTP or UDPLITE.

Unfortunately I'll be unavailable next week due to meetings & devconf conference
in Brno.  I'm sending what I have at the moment.  If someone wants to
pick that up as a starting point, please go ahead.

Otherwise I'll get back to this on Feb 10th or so.

Thanks,
Florian

This makes bridge reject (good-checksum) udp packets in both input and
prerouting (nf-call-iptables off).  ipv6 is untested.

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -36,7 +36,14 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
 	skb_pull(nskb, ETH_HLEN);
 }
 
-static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb, int hook)
+/* We cannot use oldskb->dev, since it either is the bridge port
+ * (NF_BRIDGE PREROUTING) OR the bridge device (NF_BRIDGE INPUT).
+ *
+ * We must use bridge netfilter indevice instead.
+ */
+static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb,
+					    const struct net_device *dev,
+					    int hook)
 {
 	struct sk_buff *nskb;
 	struct iphdr *niph;
@@ -65,11 +72,12 @@ static void nft_reject_br_send_v4_tcp_reset(struct sk_buff *oldskb, int hook)
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
-static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
-					  u8 code)
+static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb,
+					  const struct net_device *dev,
+					  int hook, u8 code)
 {
 	struct sk_buff *nskb;
 	struct iphdr *niph;
@@ -91,7 +99,10 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 	if (!pskb_may_pull(oldskb, len))
 		return;
 
-	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), 0))
+	if (pskb_trim_rcsum(oldskb, htons(ip_hdr(oldskb)->tot_len)))
+		return;
+
+	if (nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), ip_hdr(oldskb)->protocol))
 		return;
 
 	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmphdr) +
@@ -120,11 +131,13 @@ static void nft_reject_br_send_v4_unreach(struct sk_buff *oldskb, int hook,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
 static void nft_reject_br_send_v6_tcp_reset(struct net *net,
-					    struct sk_buff *oldskb, int hook)
+					    struct sk_buff *oldskb,
+					    const struct net_device *dev,
+					    int hook)
 {
 	struct sk_buff *nskb;
 	const struct tcphdr *oth;
@@ -152,12 +165,13 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
 static void nft_reject_br_send_v6_unreach(struct net *net,
-					  struct sk_buff *oldskb, int hook,
-					  u8 code)
+					  struct sk_buff *oldskb,
+					  const struct net_device *dev,
+					  int hook, u8 code)
 {
 	struct sk_buff *nskb;
 	struct ipv6hdr *nip6h;
@@ -205,7 +219,7 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
-	br_deliver(br_port_get_rcu(oldskb->dev), nskb);
+	br_deliver(br_port_get_rcu(dev), nskb);
 }
 
 static void nft_reject_bridge_eval(const struct nft_expr *expr,
@@ -224,16 +238,16 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 	case htons(ETH_P_IP):
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nft_reject_br_send_v4_unreach(pkt->skb,
+			nft_reject_br_send_v4_unreach(pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      priv->icmp_code);
 			break;
 		case NFT_REJECT_TCP_RST:
-			nft_reject_br_send_v4_tcp_reset(pkt->skb,
+			nft_reject_br_send_v4_tcp_reset(pkt->skb, pkt->in,
 							pkt->ops->hooknum);
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nft_reject_br_send_v4_unreach(pkt->skb,
+			nft_reject_br_send_v4_unreach(pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      nft_reject_icmp_code(priv->icmp_code));
 			break;
@@ -242,16 +256,16 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
 	case htons(ETH_P_IPV6):
 		switch (priv->type) {
 		case NFT_REJECT_ICMP_UNREACH:
-			nft_reject_br_send_v6_unreach(net, pkt->skb,
+			nft_reject_br_send_v6_unreach(net, pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      priv->icmp_code);
 			break;
 		case NFT_REJECT_TCP_RST:
-			nft_reject_br_send_v6_tcp_reset(net, pkt->skb,
+			nft_reject_br_send_v6_tcp_reset(net, pkt->skb, pkt->in,
 							pkt->ops->hooknum);
 			break;
 		case NFT_REJECT_ICMPX_UNREACH:
-			nft_reject_br_send_v6_unreach(net, pkt->skb,
+			nft_reject_br_send_v6_unreach(net, pkt->skb, pkt->in,
 						      pkt->ops->hooknum,
 						      nft_reject_icmpv6_code(priv->icmp_code));
 			break;
