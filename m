Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E4AC3A5A6
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 11:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2828421924
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 11:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388614AbfISLwr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 07:52:47 -0400
Received: from correo.us.es ([193.147.175.20]:50416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387417AbfISLwq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 07:52:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D34683066A4
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 13:52:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C452BFF2C8
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2019 13:52:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B910DB8007; Thu, 19 Sep 2019 13:52:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CCBECA0F3;
        Thu, 19 Sep 2019 13:52:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Sep 2019 13:52:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F05624251481;
        Thu, 19 Sep 2019 13:52:39 +0200 (CEST)
Date:   Thu, 19 Sep 2019 13:52:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919115240.nhaabyxfefbwok6w@salvia>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919100329.GP6961@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 19, 2019 at 12:03:29PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I can't remove the if () because that would make it possible to lookup
> > > for meter-type sets.
> > 
> > Why is this a problem?
> 
> I was worried about this exposing expr pointers in the nft registers but
> that won't happen (lookup expr doesn't care, only dynset will check for
> attached expression coming from set).

See reply at the bottom of this email regarding ignoring the attached
expression.

> I will send a patch to zap this check.
> However, that still is a problem because that means "dynamic" can't
> be used in kernels < 5.4 .

I think this qualifies as a fix, it will be a two-liner, we could
send it to -stable?

> > I think we can just check instead from nft_lookup if there is an
> > extension in this then, instead of checking for the NFT_SET_EVAL flag
> > to fix this. Hence, you can make lookups on dynamic sets, but not on
> > dynamic sets with extensions.
> 
> What do you mean?

I was thinking about the counter per set element case, this is
something we don't support and IIRC ipset does. After this fix, we can
probably make a patch to check if the NFT_SET_EXT_EXPR exists, so we
can add counter per element matching a lookup. We also need a way to
say that this set has an expression counter when definiting the set.
At some point we might need to support for stateful objects per set
element too so users can also dump-and-reset an specific element
counter.
