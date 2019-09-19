Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD867C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17C921924
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388569AbfISJYp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:24:45 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46276 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387637AbfISJYp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 05:24:45 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAsg6-0003rV-En; Thu, 19 Sep 2019 11:24:42 +0200
Date:   Thu, 19 Sep 2019 11:24:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919092442.GO6961@breakpoint.cc>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919084321.2g2hzrcrtz4r6nex@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Sep 18, 2019 at 04:42:35PM +0200, Florian Westphal wrote:
> > Laura Garcia <nevola@gmail.com> wrote:
> > > > Following example loads fine:
> > > > table ip NAT {
> > > >   set set1 {
> > > >     type ipv4_addr
> > > >     size 64
> > > >     flags dynamic,timeout
> > > >     timeout 1m
> > > >   }
> > > >
> > > >   chain PREROUTING {
> > > >      type nat hook prerouting priority -101; policy accept;
> > > >   }
> > > > }
> > > >
> > > > But adding/using this set doesn't work:
> > > > nft -- add rule NAT PREROUTING tcp dport 80 ip saddr @set1 counter
> > > > Error: Could not process rule: Operation not supported
> > > 
> > > If this set is only for matching, 'dynamic' is not required.
> > 
> > I know, and the example above works if the 'dynamic' flag is omitted.
> 
> Looks like a kernel bug, kernel is selecting the fixed size hash with
> the dynamic flag. That should not happen.

No, it selects the rhashtable one -- its the only one that sets
NFT_SET_EVAL.

> > > > The rule add is rejected from the lookup expression (nft_lookup_init)
> > > > which has:
> > > >
> > > > if (set->flags & NFT_SET_EVAL)
> > > >     return -EOPNOTSUPP;

... and thats the reason why it won't work.  "dynamic" flag disables
lookup expression for the given set.

I can't remove the if () because that would make it possible to lookup
for meter-type sets.
