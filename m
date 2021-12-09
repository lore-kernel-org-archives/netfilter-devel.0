Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6CDC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 17:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhLIRP2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbhLIRP1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 12:15:27 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33145C061746
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Dec 2021 09:11:54 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mvMxU-00086D-Hd; Thu, 09 Dec 2021 18:11:52 +0100
Date:   Thu, 9 Dec 2021 18:11:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Vitaly Zuevsky <vzuevsky@ns1.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ctnetlink: remove expired entries first
Message-ID: <20211209171152.GA26636@breakpoint.cc>
References: <20211209163926.25563-1-fw@strlen.de>
 <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+PiBLw3aUEd7X3yt5p7D6=-+EdL3EtFxiqSV8FDb5GuuyyxaQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vitaly Zuevsky <vzuevsky@ns1.com> wrote:
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 81d03acf68d4..ec4164c32d27 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -1195,8 +1195,6 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
> >                 }
> >                 hlist_nulls_for_each_entry(h, n, &nf_conntrack_hash[cb->args[0]],
> >                                            hnnode) {
> > -                       if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
> > -                               continue;
> >                         ct = nf_ct_tuplehash_to_ctrack(h);
> >                         if (nf_ct_is_expired(ct)) {
> >                                 if (i < ARRAY_SIZE(nf_ct_evict) &&
> > @@ -1208,6 +1206,9 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
> >                         if (!net_eq(net, nf_ct_net(ct)))
> >                                 continue;
> >
> > +                       if (NF_CT_DIRECTION(h) != IP_CT_DIR_ORIGINAL)
> > +                               continue;
> > +
> >                         if (cb->args[1]) {
> >                                 if (ct != last)
> >                                         continue;
> > --
> > 2.32.0
> >
> 
> Florian, thanks for prompt turnaround on this. Seeing
> conntrack -C
> 107530
> mandates the check what flows consume this many entries. I cannot do
> this if conntrack -L skips anything while kernel defaults to not
> exposing conntrack table via /proc. This server is not supposed to NAT
> anything by the way.

Then this patch doesn't change anything.

Maybe 'conntrack -L unconfirmed' or 'conntrack -L dying' show something?
