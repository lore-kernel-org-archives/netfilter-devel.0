From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] doc: Complete the documentation of statements
Date: Thu, 12 May 2016 13:05:21 +0200
Message-ID: <20160512110521.GA1262@salvia>
References: <20160512080845.GA25231@shivani>
 <20160512094439.GA1694@salvia>
 <CAKHNQQFkpzx2r0v87JL55RhMsmmPt-BfVCmP=_ugOy=nZ_QysA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbcELLFb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2016 07:05:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A224C1F1902
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 13:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 911B82687DF
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 13:05:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 202F32687F0
	for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2016 13:05:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFkpzx2r0v87JL55RhMsmmPt-BfVCmP=_ugOy=nZ_QysA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 12, 2016 at 04:21:06PM +0530, Shivani Bhardwaj wrote:
> On Thu, May 12, 2016 at 3:14 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, May 12, 2016 at 01:38:45PM +0530, Shivani Bhardwaj wrote:
> >> +                     <para>
> >> +                             &#13;&#10;The nflog statement provides logging of matching packets. When this statement is set for a rule, the Linux kernel will pass the packet to the loaded logging backend to log the packet. This is used in combination with nfnetlink_log as logging backend, which will multicast the packet through a netlink socket to the specified multicast group. One or more userspace processes may subscribe to the group to receive the packets. Like log statement, this is a non-terminating statement, i.e. rule traversal continues at the next rule. It is necessary to mention the group [default 0] to consider logging with nflog.
> >
> > We don't have a nflog statement, actually this is integrated into
> > 'log' itself. So if you indique the group, then it is assumed that you
> > want to use logging through nflog.
> >
> Yes, I'm sorry for the mistake.

No problem.

[...]
> >>                       <title>Meta statement</title>
> >>                       <para>
> >> +                             A meta statement sets the value of a meta expression.
> >> +                             The existing meta fields are: length,
> >> nfproto, l4proto, protocol, priority, mark, iif, iifname, iiftype,
> >> oif, oifname, oiftype, skuid, skgid, nftrace, rtclassid, ibriport,
> >> obriport, pkttype, cpu, iifgroup, oifgroup, cgroup.
> >
> > We actually support a bunch of this, have a look at:
> > net/netfilter/nft_meta.c so you know which ones we support ;)
> >
> Should I be adding the ones like prandom, secmark too? nft_meta.c
> shows it but nftables doesn't seem to have an entry in the parser.
> Please let me know.

void nft_meta_set_eval(const struct nft_expr *expr,
                       struct nft_regs *regs,
                       const struct nft_pktinfo *pkt)
{
        const struct nft_meta *meta = nft_expr_priv(expr);
        struct sk_buff *skb = pkt->skb;
        u32 value = regs->data[meta->sreg];

        switch (meta->key) {
        case NFT_META_MARK:
                [...]
                break;
        case NFT_META_PRIORITY:
                [...]
                break;
        case NFT_META_PKTTYPE:
                [...]
                break;
        case NFT_META_NFTRACE:
                [...]
        default:
                WARN_ON(1);
        }
}

We support mark, priority, pkttype and nftrace for meta statements at
this stage.

Note that you indicated what we support for meta expressions (what we
used to call 'matches' in iptables) that is the long list of things
you placed above.
