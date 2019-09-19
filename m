Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79C8C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 08:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7DB5217D6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 08:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387759AbfISIn2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 04:43:28 -0400
Received: from correo.us.es ([193.147.175.20]:34708 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731341AbfISIn2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 04:43:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 378D118D002
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 10:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 257A3CA0F3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 10:43:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1A759D2B1E; Thu, 19 Sep 2019 10:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2BD9B8001;
        Thu, 19 Sep 2019 10:43:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 10:43:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 997D64265A5A;
        Thu, 19 Sep 2019 10:43:21 +0200 (CEST)
Date:   Thu, 19 Sep 2019 10:43:21 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919084321.2g2hzrcrtz4r6nex@salvia>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918144235.GN6961@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 18, 2019 at 04:42:35PM +0200, Florian Westphal wrote:
> Laura Garcia <nevola@gmail.com> wrote:
> > > Following example loads fine:
> > > table ip NAT {
> > >   set set1 {
> > >     type ipv4_addr
> > >     size 64
> > >     flags dynamic,timeout
> > >     timeout 1m
> > >   }
> > >
> > >   chain PREROUTING {
> > >      type nat hook prerouting priority -101; policy accept;
> > >   }
> > > }
> > >
> > > But adding/using this set doesn't work:
> > > nft -- add rule NAT PREROUTING tcp dport 80 ip saddr @set1 counter
> > > Error: Could not process rule: Operation not supported
> > 
> > If this set is only for matching, 'dynamic' is not required.
> 
> I know, and the example above works if the 'dynamic' flag is omitted.

Looks like a kernel bug, kernel is selecting the fixed size hash with
the dynamic flag. That should not happen.

> > > This is because the 'dynamic' flag sets NFT_SET_EVAL.
> > >
> > > According to kernel comment, that flag means:
> > >  * @NFT_SET_EVAL: set can be updated from the evaluation path
> > >
> > > The rule add is rejected from the lookup expression (nft_lookup_init)
> > > which has:
> > >
> > > if (set->flags & NFT_SET_EVAL)
> > >     return -EOPNOTSUPP;
> > >
> > > From looking at the git history, the NFT_SET_EVAL flag means that the
> > > set contains expressions (i.e., a meter).
> > >
> > > And I can see why doing a lookup on meters isn't meaningful.
> > >
> > > Can someone please explain the exact precise meaning of 'dynamic'?
> > > Was it supposed to mean 'set can be updated from packet path'?
> > > Or was it supposed to mean 'set contains expressions'?
> > >
> > 
> > AFAIK, I traduce the 'dynamic' flag as a 'set that is updated from the
> > packet path using an expression', formerly 'meter'.
> 
> That would mean the kernel comment quoted above is wrong and should be
> patched to say
> 
> * @NFT_SET_EVAL: set can be updated from the packet path and stores expressions.

The comment is correct. NFT_SET_EVAL semantics is "this set can be
updated from the packet path", this helps the kernel selects a set
backend that implements the ->update interface.

The expression is option, if the netlink attribute to describe the
extension is set, then it used.

> Unfortunately, this seems to contradict various nftables.git changelog
> messages which seem to imply that 'dynamic' means
> 
> @NFT_SET_EVAL: set can be updated from the evaluation path
> 
> i.e., make sure that set provides an ->update() implementation so
> 
> 'add @set1 { ip saddr }' and the like work.
> 
> The core issue is that when saying
> 
>    set set1 {
>       type ipv4_addr
>       size 64
>        flags timeout
>        timeout 1m
>     }
> 
> The kernel has no information on how this set is going to be used.
> For 'ip saddr @set1' this will just work as all sets implement
> ->lookup().
> 
> But will this work reliably:
> nft add rule ... add @set1 { ip saddr }

No, because the dynamic flag is not set.

> At this time, it looks like when specifiying the mandatory 'timeout'
> flag, the kernel happens to pick the rhashtable backend so it will work.

Probably it would be good to implicitly set on timeout flag if dynamic
flag is set on, just like it happens with set size. To relax the
control plane interface a bit (IIRC the user currently gets an error
if you forget to set the timeout flag in a set that is updated from
the packet path).

> But I wonder if we're just lucky or if this is intentional, i.e.
> 'timeout' means that the set can be altered from the packet path.

I think we're just being lucky :-)

> In any case, this needs to be documented in nft.8, its telling that I
> can't be 100% about the intent of dynamic/EVAL even after reading both
> nftables.git and kernel implementation.

Sure.
