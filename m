Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF39CC7EE30
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 11:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbjCBL1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 06:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjCBL1m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 06:27:42 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BE6311EB
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Mar 2023 03:27:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXh61-0000ib-HO; Thu, 02 Mar 2023 12:27:37 +0100
Date:   Thu, 2 Mar 2023 12:27:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Ivan Delalande <colona@arista.com>, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ctnetlink: revert to dumping mark regardless
 of event type
Message-ID: <20230302112737.GC23204@breakpoint.cc>
References: <20230302022218.GA195225@visor>
 <20230302105115.GB23204@breakpoint.cc>
 <ZACEhssZ7KcCnHjw@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZACEhssZ7KcCnHjw@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Mar 02, 2023 at 11:51:15AM +0100, Florian Westphal wrote:
> > Ivan Delalande <colona@arista.com> wrote:
> > > I assume that change was unintentional, we have userspace code that
> > > needs the mark while listening for events like REPLY, DESTROY, etc.
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Fixes: 1feeae071507 ("netfilter: ctnetlink: fix compilation warning after data race fixes in ct mark")
> > > Signed-off-by: Ivan Delalande <colona@arista.com>
> > > ---
> > >  net/netfilter/nf_conntrack_netlink.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > > index c11dff91d52d..194822f8f1ee 100644
> > > --- a/net/netfilter/nf_conntrack_netlink.c
> > > +++ b/net/netfilter/nf_conntrack_netlink.c
> > > @@ -831,7 +831,7 @@ ctnetlink_conntrack_event(unsigned int events, const struct nf_ct_event *item)
> > >  	}
> > >  
> > >  #ifdef CONFIG_NF_CONNTRACK_MARK
> > > -	if (events & (1 << IPCT_MARK) &&
> > > +	if ((events & (1 << IPCT_MARK) || READ_ONCE(ct->mark)) &&
> > >  	    ctnetlink_dump_mark(skb, ct) < 0)
> > >  		goto nla_put_failure;
> > 
> > Probably better to just drop the event bit test?
> > 
> > if (ctnetlink_dump_mark(skb, ct) < 0)
> > 	goto nla_put_failure;
> 
> Looks good to me, but 1feeae071507 also changes behaviour in another
> way: if ct->mark is reset to zero (being non-zero before), the event
> will not show mark=0 which is probably relevant to userspace. It is a
> strange corner case though.

Oh, right.

> Maybe this?
> 
>         if (ctnetlink_dump_mark(skb, ct, events & (1 << IPCT_MARK)))
>                 goto nla_put_failure;
> 
> then:
> 
> static int ctnetlink_dump_mark(struct sk_buff *skb, const struct nf_conn *ct, bool dump)
> {
>         u32 mark = READ_ONCE(ct->mark);
> 
>         if (!mark && !dump)
>                 return 0;

LGTM, Ivan, can you submit a v2 with Pablos suggested change?

Thanks!
