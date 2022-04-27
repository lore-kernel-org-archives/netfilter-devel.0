Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 997D2C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 07:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358519AbiD0HEa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 03:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357867AbiD0HE0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 03:04:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 665F125581
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 00:01:15 -0700 (PDT)
Date:   Wed, 27 Apr 2022 09:01:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <YmjqN7KtWFMGbiJ9@salvia>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
 <20220425223421.GA14400@breakpoint.cc>
 <ab7923f2-d1e7-ce61-5df8-c05778ef3ebd@gmail.com>
 <20220427054820.GB9849@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427054820.GB9849@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 27, 2022 at 07:48:20AM +0200, Florian Westphal wrote:
> Topi Miettinen <toiwoton@gmail.com> wrote:
> > On 26.4.2022 1.34, Florian Westphal wrote:
> > > Topi Miettinen <toiwoton@gmail.com> wrote:
> > > > On 20.4.2022 21.54, Topi Miettinen wrote:
> > > > > Add socket expressions for checking GID or UID of the originating
> > > > > socket. These work also on input side, unlike meta skuid/skgid.
> > > > 
> > > > Unfortunately, there's a reproducible kernel BUG when closing a local
> > > > connection:
> > > > 
> > > > Apr 25 21:18:13 kernel:
> > > > ==================================================================
> > > > Apr 25 21:18:13 kernel: BUG: KASAN: null-ptr-deref in
> > > > nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
> > > 
> > > You can pass this to scripts/faddr2line to get the location of the null deref.
> > 
> > Didn't work,
> 
> ?
> 
> You pass the object file and the nf_sk_lookup_slow_v6+0x45b/0x590 info.
> I can't do it for you because I lack the object file and the exact
> source code.
> 
> > net/ipv6/netfilter/nf_socket_ipv6.c:
> > 
> > static struct sock *
> > nf_socket_get_sock_v6(struct net *net, struct sk_buff *skb, int doff,
> >                       const u8 protocol,
> >                       const struct in6_addr *saddr, const struct in6_addr
> > *daddr,
> >                       const __be16 sport, const __be16 dport,
> >                       const struct net_device *in)
> > {
> >         switch (protocol) {
> >         case IPPROTO_TCP:
> >                 return inet6_lookup(net, &tcp_hashinfo, skb, doff,
> >                                     saddr, sport, daddr, dport,
> >                                     in->ifindex);
> 
> What does that rule look like?  Seems like no input interface is
> available, seems like a bug in existing code?

nft_socket_eval() assumes it always run from input path.

@Topi: How does you test ruleset look like?
