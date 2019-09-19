Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C540C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 691D9217D6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 09:41:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbfISJlD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:41:03 -0400
Received: from correo.us.es ([193.147.175.20]:47106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfISJlC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 05:41:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2CD85E5395
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 11:40:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95B2EB7FF6
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 11:40:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8940EFB362; Thu, 19 Sep 2019 11:40:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4087710079C;
        Thu, 19 Sep 2019 11:40:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 11:40:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D5A864265A5A;
        Thu, 19 Sep 2019 11:40:56 +0200 (CEST)
Date:   Thu, 19 Sep 2019 11:40:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919094055.4b2nd6aarjxi2bt6@salvia>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919092442.GO6961@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 11:24:42AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Sep 18, 2019 at 04:42:35PM +0200, Florian Westphal wrote:
> > > Laura Garcia <nevola@gmail.com> wrote:
> > > > > Following example loads fine:
> > > > > table ip NAT {
> > > > >   set set1 {
> > > > >     type ipv4_addr
> > > > >     size 64
> > > > >     flags dynamic,timeout
> > > > >     timeout 1m
> > > > >   }
> > > > >
> > > > >   chain PREROUTING {
> > > > >      type nat hook prerouting priority -101; policy accept;
> > > > >   }
> > > > > }
> > > > >
> > > > > But adding/using this set doesn't work:
> > > > > nft -- add rule NAT PREROUTING tcp dport 80 ip saddr @set1 counter
> > > > > Error: Could not process rule: Operation not supported
> > > > 
> > > > If this set is only for matching, 'dynamic' is not required.
> > > 
> > > I know, and the example above works if the 'dynamic' flag is omitted.
> > 
> > Looks like a kernel bug, kernel is selecting the fixed size hash with
> > the dynamic flag. That should not happen.
> 
> No, it selects the rhashtable one -- its the only one that sets
> NFT_SET_EVAL.
> 
> > > > > The rule add is rejected from the lookup expression (nft_lookup_init)
> > > > > which has:
> > > > >
> > > > > if (set->flags & NFT_SET_EVAL)
> > > > >     return -EOPNOTSUPP;
> 
> ... and thats the reason why it won't work.  "dynamic" flag disables
> lookup expression for the given set.
> 
> I can't remove the if () because that would make it possible to lookup
> for meter-type sets.

Why is this a problem? meter-set are basically a set with a
counter/quota/etc... that is created from the packet path. It should
be possible to make lookups on the content of this set.

I think we can just check instead from nft_lookup if there is an
extension in this then, instead of checking for the NFT_SET_EVAL flag
to fix this. Hence, you can make lookups on dynamic sets, but not on
dynamic sets with extensions.
