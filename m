Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D8BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbiD0Pby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239819AbiD0Pbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:31:53 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400C144937C
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:28:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1njjao-00034I-Cv; Wed, 27 Apr 2022 17:28:38 +0200
Date:   Wed, 27 Apr 2022 17:28:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <20220427152838.GC9849@breakpoint.cc>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
 <20220425223421.GA14400@breakpoint.cc>
 <ab7923f2-d1e7-ce61-5df8-c05778ef3ebd@gmail.com>
 <20220427054820.GB9849@breakpoint.cc>
 <YmjqN7KtWFMGbiJ9@salvia>
 <b0389581-cf28-13fe-6444-0840958b757a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0389581-cf28-13fe-6444-0840958b757a@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Topi Miettinen <toiwoton@gmail.com> wrote:
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

Oof, there is no restriction.
I don't think we can make it illegal now, so probably best to check for
indev != NULL first.

I'll send a patch.
