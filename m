Return-Path: <SRS0=T2b5=XN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58C3C4CEC9
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:42:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE76620665
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Sep 2019 14:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbfIROmi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:42:38 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43248 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730712AbfIROmi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Sep 2019 10:42:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAbAB-0007EX-SR; Wed, 18 Sep 2019 16:42:35 +0200
Date:   Wed, 18 Sep 2019 16:42:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Laura Garcia <nevola@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190918144235.GN6961@breakpoint.cc>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Laura Garcia <nevola@gmail.com> wrote:
> > Following example loads fine:
> > table ip NAT {
> >   set set1 {
> >     type ipv4_addr
> >     size 64
> >     flags dynamic,timeout
> >     timeout 1m
> >   }
> >
> >   chain PREROUTING {
> >      type nat hook prerouting priority -101; policy accept;
> >   }
> > }
> >
> > But adding/using this set doesn't work:
> > nft -- add rule NAT PREROUTING tcp dport 80 ip saddr @set1 counter
> > Error: Could not process rule: Operation not supported
> 
> If this set is only for matching, 'dynamic' is not required.

I know, and the example above works if the 'dynamic' flag is omitted.

> > This is because the 'dynamic' flag sets NFT_SET_EVAL.
> >
> > According to kernel comment, that flag means:
> >  * @NFT_SET_EVAL: set can be updated from the evaluation path
> >
> > The rule add is rejected from the lookup expression (nft_lookup_init)
> > which has:
> >
> > if (set->flags & NFT_SET_EVAL)
> >     return -EOPNOTSUPP;
> >
> > From looking at the git history, the NFT_SET_EVAL flag means that the
> > set contains expressions (i.e., a meter).
> >
> > And I can see why doing a lookup on meters isn't meaningful.
> >
> > Can someone please explain the exact precise meaning of 'dynamic'?
> > Was it supposed to mean 'set can be updated from packet path'?
> > Or was it supposed to mean 'set contains expressions'?
> >
> 
> AFAIK, I traduce the 'dynamic' flag as a 'set that is updated from the
> packet path using an expression', formerly 'meter'.

That would mean the kernel comment quoted above is wrong and should be
patched to say

* @NFT_SET_EVAL: set can be updated from the packet path and stores expressions.

Unfortunately, this seems to contradict various nftables.git changelog
messages which seem to imply that 'dynamic' means

@NFT_SET_EVAL: set can be updated from the evaluation path

i.e., make sure that set provides an ->update() implementation so

'add @set1 { ip saddr }' and the like work.

The core issue is that when saying

   set set1 {
      type ipv4_addr
      size 64
       flags timeout
       timeout 1m
    }

The kernel has no information on how this set is going to be used.
For 'ip saddr @set1' this will just work as all sets implement
->lookup().

But will this work reliably:
nft add rule ... add @set1 { ip saddr }

At this time, it looks like when specifiying the mandatory 'timeout'
flag, the kernel happens to pick the rhashtable backend so it will work.

But I wonder if we're just lucky or if this is intentional, i.e.
'timeout' means that the set can be altered from the packet path.

In any case, this needs to be documented in nft.8, its telling that I
can't be 100% about the intent of dynamic/EVAL even after reading both
nftables.git and kernel implementation.
