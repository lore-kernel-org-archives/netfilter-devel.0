Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02D247F770;
	Thu, 27 Aug 2026 14:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787842463; cv=none; b=OLT5ORy+6GSiUhdP906YBz7NX6bvBqLTIkEtWGRXvgh0ZMd0dDpcJVUkW4e7ZXBJNgJjNQUh5DcZQ5f90SZVJmYG62hfihWXaMV3T46VbJ/wmJWkIKVYF4d4lDxeDlLvlpu49ivq+7amqTba4SM37prBAItl9yZhoGTSm0GY3HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787842463; c=relaxed/simple;
	bh=vA6XlNiwOBux8epsbZa89V45XQ6kUfKQK8P7Lt87cVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NCzk7SiL/Aichg6O0N2cisXsLgKBW3WLdhfAGjmD1z2SfZZ5eTuVutEMxRZQ4YU4aaDf5JcS+KX1X0J1HDBo5SGeO3wMeCJ4z3qCWO8d9vK1uH5xZhx9SVCFVbrY6tMZsPlRtcpDoDe2bzNCs0sb3VGqtHryWD6YGLtzr2X1oO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C3sMd+3P; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C3sMd+3P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787842450;
	bh=4ZkYinyf88pXEloZGVMGV/26vir7D5/yrLpFCdyD1DM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C3sMd+3PxWNXjvj8cwEQYRJ8lqNwdvFJXY5g2gBl2ir3i4GotNa+tsN01ZEY3Ve44
	 TgFKUQ717Q7VpVGxDiEqxnTpvkLVdliCFgmKTE7PG8bvdIPeT4BJaNQ+D779XfoMcE
	 PtpnsydupqS4a9duqL7Y9Rzjx/QGWd/hMIYa8S8xPYD9xPfVl2PXT4bWxH5r0YbUrq
	 fIzflYXUddrful1PssmIxCqzmpOsT2njSVv9eT9W7DObV5ClMW1556oaqe8BDY9twJ
	 y94Dkyqoc6GQXmZOZG0fQ9mThugjPy/jKJVhlJLvHPeUJU+QupnRt4l/t5xojHcCaO
	 VNHArZl6Ynxhw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id D9E9F60081;
	Thu, 27 Aug 2026 16:54:09 +0200 (CEST)
Date: Thu, 27 Aug 2026 16:54:07 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>, Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net/bridge: out-of-bounds in br_forward()
Message-ID: <apBPj741ai10Wajf@chamomile>
References: <fai12uKS5302YnCQV4E3zlDqcsAS5aGcMutS@bugs.sh>
 <apBJyKJ7zs4kUmpd@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apBJyKJ7zs4kUmpd@strlen.de>

On Thu, Aug 27, 2026 at 04:29:28PM +0200, Florian Westphal wrote:
> co <co+63bad23bb3b4cd85@bugs.sh> wrote:
> > We found a bug reachable in:
> > 
> >     path    net/bridge/netfilter
> >     crash   out-of-bounds in br_forward()
> >     commit  7b5344954050 ("Merge tag 'nf-26-08-10' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf")
> 
> I'm looking into these reports, I think this is the same
> underlying bug as the other report; a variant of
> 
> ccb9fd4b8753 ("netfilter: revalidate bridge ports")
> 
> That bug uses nfnetlink_queue for RCU escape, the other two reports
> use defrag engine.

I started this patch. I think this can still happen with native
nfnetlink_queue support for the bridge family?

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index cd2b04236a99..b3a51ba72e9c 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -44,7 +44,7 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
  */
 static void nft_reject_br_send_v4_tcp_reset(struct net *net,
                                            struct sk_buff *oldskb,
-                                           const struct net_device *dev,
+                                           struct net_bridge_port *port,
                                            int hook)
 {
        struct sk_buff *nskb;
@@ -55,12 +55,12 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 
        nft_reject_br_push_etherhdr(oldskb, nskb);
 
-       br_forward(br_port_get_rcu(dev), nskb, false, true);
+       br_forward(port, nskb, false, true);
 }
 
 static void nft_reject_br_send_v4_unreach(struct net *net,
                                          struct sk_buff *oldskb,
-                                         const struct net_device *dev,
+                                         struct net_bridge_port *port,
                                          int hook, u8 code)
 {
        struct sk_buff *nskb;
@@ -71,12 +71,12 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 
        nft_reject_br_push_etherhdr(oldskb, nskb);
 
-       br_forward(br_port_get_rcu(dev), nskb, false, true);
+       br_forward(port, nskb, false, true);
 }
 
 static void nft_reject_br_send_v6_tcp_reset(struct net *net,
                                            struct sk_buff *oldskb,
-                                           const struct net_device *dev,
+                                           struct net_bridge_port *port,
                                            int hook)
 {
        struct sk_buff *nskb;
@@ -87,13 +87,13 @@ static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 
        nft_reject_br_push_etherhdr(oldskb, nskb);
 
-       br_forward(br_port_get_rcu(dev), nskb, false, true);
+       br_forward(port, nskb, false, true);
 }
 
 
 static void nft_reject_br_send_v6_unreach(struct net *net,
                                          struct sk_buff *oldskb,
-                                         const struct net_device *dev,
+                                         struct net_bridge_port *port,
                                          int hook, u8 code)
 {
        struct sk_buff *nskb;
@@ -104,37 +104,47 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 
        nft_reject_br_push_etherhdr(oldskb, nskb);
 
-       br_forward(br_port_get_rcu(dev), nskb, false, true);
+       br_forward(port, nskb, false, true);
 }
 
 static void nft_reject_bridge_eval(const struct nft_expr *expr,
                                   struct nft_regs *regs,
                                   const struct nft_pktinfo *pkt)
 {
-       struct nft_reject *priv = nft_expr_priv(expr);
        const unsigned char *dest = eth_hdr(pkt->skb)->h_dest;
+       struct nft_reject *priv = nft_expr_priv(expr);
+       const struct net_device *dev = nft_in(pkt);
+       struct net_bridge_port *port;
 
        if (is_broadcast_ether_addr(dest) ||
            is_multicast_ether_addr(dest))
                goto out;
 
+       if (!dev || !netif_is_bridge_port(dev) ||
+           netdev_master_upper_dev_get_rcu((struct net_device *)dev))
+               goto out;
+
+       port = br_port_get_rcu(dev);
+       if (!port)
+               goto out;
+
        switch (eth_hdr(pkt->skb)->h_proto) {
        case htons(ETH_P_IP):
                switch (priv->type) {
                case NFT_REJECT_ICMP_UNREACH:
                        nft_reject_br_send_v4_unreach(nft_net(pkt), pkt->skb,
-                                                     nft_in(pkt),
+                                                     port,
                                                      nft_hook(pkt),
                                                      priv->icmp_code);
                        break;
                case NFT_REJECT_TCP_RST:
                        nft_reject_br_send_v4_tcp_reset(nft_net(pkt), pkt->skb,
-                                                       nft_in(pkt),
+                                                       port,
                                                        nft_hook(pkt));
                        break;
                case NFT_REJECT_ICMPX_UNREACH:
                        nft_reject_br_send_v4_unreach(nft_net(pkt), pkt->skb,
-                                                     nft_in(pkt),
+                                                     port,
                                                      nft_hook(pkt),
                                                      nft_reject_icmp_code(priv->icmp_code));
                        break;
@@ -144,18 +154,18 @@ static void nft_reject_bridge_eval(const struct nft_expr *expr,
                switch (priv->type) {
                case NFT_REJECT_ICMP_UNREACH:
                        nft_reject_br_send_v6_unreach(nft_net(pkt), pkt->skb,
-                                                     nft_in(pkt),
+                                                     port,
                                                      nft_hook(pkt),
                                                      priv->icmp_code);
                        break;
                case NFT_REJECT_TCP_RST:
                        nft_reject_br_send_v6_tcp_reset(nft_net(pkt), pkt->skb,
-                                                       nft_in(pkt),
+                                                       port,
                                                        nft_hook(pkt));
                        break;
                case NFT_REJECT_ICMPX_UNREACH:
                        nft_reject_br_send_v6_unreach(nft_net(pkt), pkt->skb,
-                                                     nft_in(pkt),
+                                                     port,
                                                      nft_hook(pkt),
                                                      nft_reject_icmpv6_code(priv->icmp_code));
                        break;

