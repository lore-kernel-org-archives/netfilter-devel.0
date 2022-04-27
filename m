Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93AE5C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbiD0PeG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbiD0Pd5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:33:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7476B46D440
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:30:45 -0700 (PDT)
Date:   Wed, 27 Apr 2022 17:30:42 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <YmlhokhnOxG8tD7R@salvia>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
 <20220425223421.GA14400@breakpoint.cc>
 <ab7923f2-d1e7-ce61-5df8-c05778ef3ebd@gmail.com>
 <20220427054820.GB9849@breakpoint.cc>
 <YmjqN7KtWFMGbiJ9@salvia>
 <b0389581-cf28-13fe-6444-0840958b757a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sSQKQG6NCInfg5CF"
Content-Disposition: inline
In-Reply-To: <b0389581-cf28-13fe-6444-0840958b757a@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sSQKQG6NCInfg5CF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Apr 27, 2022 at 06:00:49PM +0300, Topi Miettinen wrote:
> On 27.4.2022 10.01, Pablo Neira Ayuso wrote:
> > On Wed, Apr 27, 2022 at 07:48:20AM +0200, Florian Westphal wrote:
> > > Topi Miettinen <toiwoton@gmail.com> wrote:
> > > > On 26.4.2022 1.34, Florian Westphal wrote:
> > > > > Topi Miettinen <toiwoton@gmail.com> wrote:
> > > > > > On 20.4.2022 21.54, Topi Miettinen wrote:
> > > > > > > Add socket expressions for checking GID or UID of the originating
> > > > > > > socket. These work also on input side, unlike meta skuid/skgid.
> > > > > > 
> > > > > > Unfortunately, there's a reproducible kernel BUG when closing a local
> > > > > > connection:
> > > > > > 
> > > > > > Apr 25 21:18:13 kernel:
> > > > > > ==================================================================
> > > > > > Apr 25 21:18:13 kernel: BUG: KASAN: null-ptr-deref in
> > > > > > nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
> > > > > 
> > > > > You can pass this to scripts/faddr2line to get the location of the null deref.
> > > > 
> > > > Didn't work,
> > > 
> > > ?
> > > 
> > > You pass the object file and the nf_sk_lookup_slow_v6+0x45b/0x590 info.
> > > I can't do it for you because I lack the object file and the exact
> > > source code.
> > > 
> 
> $ faddr2line nf_socket_ipv6.ko nf_sk_lookup_slow_v6+0x45b/0x590
> bad symbol size: base: 0x0000000000000000 end: 0x0000000000000000
> $ faddr2line nf_socket_ipv6.o nf_sk_lookup_slow_v6+0x45b/0x590
> bad symbol size: base: 0x0000000000000000 end: 0x0000000000000000
> $ faddr2line nf_socket_ipv6.mod nf_sk_lookup_slow_v6+0x45b/0x590
> readelf: Error: nf_socket_ipv6.mod: Failed to read file header
> size: nf_socket_ipv6.mod: file format not recognized
> nm: nf_socket_ipv6.mod: file format not recognized
> size: nf_socket_ipv6.mod: file format not recognized
> nm: nf_socket_ipv6.mod: file format not recognized
> no match for nf_sk_lookup_slow_v6+0x45b/0x590
> $ faddr2line nf_socket_ipv6.mod.o nf_sk_lookup_slow_v6+0x45b/0x590
> no match for nf_sk_lookup_slow_v6+0x45b/0x590
> $ faddr2line vmlinux nf_sk_lookup_slow_v6+0x45b/0x590
> no match for nf_sk_lookup_slow_v6+0x45b/0x590
>
> > > > net/ipv6/netfilter/nf_socket_ipv6.c:
> > > > 
> > > > static struct sock *
> > > > nf_socket_get_sock_v6(struct net *net, struct sk_buff *skb, int doff,
> > > >                        const u8 protocol,
> > > >                        const struct in6_addr *saddr, const struct in6_addr
> > > > *daddr,
> > > >                        const __be16 sport, const __be16 dport,
> > > >                        const struct net_device *in)
> > > > {
> > > >          switch (protocol) {
> > > >          case IPPROTO_TCP:
> > > >                  return inet6_lookup(net, &tcp_hashinfo, skb, doff,
> > > >                                      saddr, sport, daddr, dport,
> > > >                                      in->ifindex);
> > > 
> > > What does that rule look like?  Seems like no input interface is
> > > available, seems like a bug in existing code?
> > 
> > nft_socket_eval() assumes it always run from input path.
> > 
> > @Topi: How does you test ruleset look like?
> 
> Here's a reproducer:
> #!/usr/sbin/nft -f
> 
> table inet mangle {
>         chain output {
>                 type route hook output priority mangle; policy accept;
> 
>                 socket uid != 0 reject with icmpx type admin-prohibited
>         }
> }
> 
> Start nc -6l 1 as root
> 
> Try 'telnet ::1 1' as root, press enter and close the connection. After 1-3
> tries, system hangs and Caps Lock starts blinking.

Looks like skb->sk is NULL? Patch attached.

--sSQKQG6NCInfg5CF
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="fix-nft-socket.patch"

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 6d9e8e0a3a7d..d6da68a3b739 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -59,21 +59,27 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_socket *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
 	struct sk_buff *skb = pkt->skb;
+	const struct net_device *dev;
 	struct sock *sk = skb->sk;
-	u32 *dest = &regs->data[priv->dreg];
 
 	if (sk && !net_eq(nft_net(pkt), sock_net(sk)))
 		sk = NULL;
 
-	if (!sk)
+	if (nft_hook(pkt) == NF_INET_LOCAL_OUT)
+		dev = nft_out(pkt);
+	else
+		dev = nft_in(pkt);
+
+	if (!sk) {
 		switch(nft_pf(pkt)) {
 		case NFPROTO_IPV4:
-			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
+			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, dev);
 			break;
 #if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
 		case NFPROTO_IPV6:
-			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
+			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, dev);
 			break;
 #endif
 		default:
@@ -81,6 +87,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 			regs->verdict.code = NFT_BREAK;
 			return;
 		}
+	}
 
 	if (!sk) {
 		regs->verdict.code = NFT_BREAK;
@@ -184,6 +191,15 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 					NULL, NFT_DATA_VALUE, len);
 }
 
+static int nft_socket_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_PRE_ROUTING) |
+						    (1 << NF_INET_LOCAL_IN) |
+						    (1 << NF_INET_LOCAL_OUT));
+}
+
 static int nft_socket_dump(struct sk_buff *skb,
 			   const struct nft_expr *expr)
 {
@@ -230,6 +246,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_socket)),
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
+	.validate	= nft_socket_validate,
 	.dump		= nft_socket_dump,
 	.reduce		= nft_socket_reduce,
 };

--sSQKQG6NCInfg5CF--
