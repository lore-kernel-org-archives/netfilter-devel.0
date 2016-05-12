From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH v2] doc: Complete the documentation of statements
Date: Thu, 12 May 2016 16:37:01 +0530
Message-ID: <CAKHNQQEqQ+2qSueTO5hN3JTnneS8UKaujAA_8KNJxsd7QJP6qQ@mail.gmail.com>
References: <20160512080845.GA25231@shivani> <20160512094439.GA1694@salvia>
 <CAKHNQQFkpzx2r0v87JL55RhMsmmPt-BfVCmP=_ugOy=nZ_QysA@mail.gmail.com> <20160512110521.GA1262@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33707 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcELLHm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2016 07:07:42 -0400
Received: by mail-oi0-f68.google.com with SMTP id t140so8691983oie.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 04:07:41 -0700 (PDT)
In-Reply-To: <20160512110521.GA1262@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 12, 2016 at 4:35 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, May 12, 2016 at 04:21:06PM +0530, Shivani Bhardwaj wrote:
>> On Thu, May 12, 2016 at 3:14 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> > On Thu, May 12, 2016 at 01:38:45PM +0530, Shivani Bhardwaj wrote:
>> >> +                     <para>
>> >> +                             &#13;&#10;The nflog statement provides logging of matching packets. When this statement is set for a rule, the Linux kernel will pass the packet to the loaded logging backend to log the packet. This is used in combination with nfnetlink_log as logging backend, which will multicast the packet through a netlink socket to the specified multicast group. One or more userspace processes may subscribe to the group to receive the packets. Like log statement, this is a non-terminating statement, i.e. rule traversal continues at the next rule. It is necessary to mention the group [default 0] to consider logging with nflog.
>> >
>> > We don't have a nflog statement, actually this is integrated into
>> > 'log' itself. So if you indique the group, then it is assumed that you
>> > want to use logging through nflog.
>> >
>> Yes, I'm sorry for the mistake.
>
> No problem.
>
> [...]
>> >>                       <title>Meta statement</title>
>> >>                       <para>
>> >> +                             A meta statement sets the value of a meta expression.
>> >> +                             The existing meta fields are: length,
>> >> nfproto, l4proto, protocol, priority, mark, iif, iifname, iiftype,
>> >> oif, oifname, oiftype, skuid, skgid, nftrace, rtclassid, ibriport,
>> >> obriport, pkttype, cpu, iifgroup, oifgroup, cgroup.
>> >
>> > We actually support a bunch of this, have a look at:
>> > net/netfilter/nft_meta.c so you know which ones we support ;)
>> >
>> Should I be adding the ones like prandom, secmark too? nft_meta.c
>> shows it but nftables doesn't seem to have an entry in the parser.
>> Please let me know.
>
> void nft_meta_set_eval(const struct nft_expr *expr,
>                        struct nft_regs *regs,
>                        const struct nft_pktinfo *pkt)
> {
>         const struct nft_meta *meta = nft_expr_priv(expr);
>         struct sk_buff *skb = pkt->skb;
>         u32 value = regs->data[meta->sreg];
>
>         switch (meta->key) {
>         case NFT_META_MARK:
>                 [...]
>                 break;
>         case NFT_META_PRIORITY:
>                 [...]
>                 break;
>         case NFT_META_PKTTYPE:
>                 [...]
>                 break;
>         case NFT_META_NFTRACE:
>                 [...]
>         default:
>                 WARN_ON(1);
>         }
> }
>
> We support mark, priority, pkttype and nftrace for meta statements at
> this stage.
>
> Note that you indicated what we support for meta expressions (what we
> used to call 'matches' in iptables) that is the long list of things
> you placed above.

OK. I confused expressions with statements again. I'm sorry. Fixing
this and sending the patch. Thanks!
