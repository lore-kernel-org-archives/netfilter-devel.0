Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B413C49ED7
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23DA420882
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 14:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfISOee (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:34:34 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47782 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727273AbfISOee (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 10:34:34 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAxVv-0005eo-T3; Thu, 19 Sep 2019 16:34:31 +0200
Date:   Thu, 19 Sep 2019 16:34:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919143431.GT6961@breakpoint.cc>
References: <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
 <20190919115636.GQ6961@breakpoint.cc>
 <20190919132828.nydpzdt3qqupgtg5@salvia>
 <20190919140144.GS6961@breakpoint.cc>
 <20190919142258.oxv2kzdbl7vj5sqk@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919142258.oxv2kzdbl7vj5sqk@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Sep 19, 2019 at 04:01:44PM +0200, Florian Westphal wrote:
> > Do you mean NFT_SET_EVAL?
> 
> No, I mean there is no NFT_SET_EXT_EXPR handling yet, sorry I forgot
> the _EXT_ infix.
> 
> nft_lookup should invoke the expression that is attached. Control
> plane code is also missing, there is no way to create the
> NFT_SET_EXT_EXPR from newsetelem() in nf_tables_api.c.

Hmm, no, I don't think it should.
Otherwise lookups on a set that has counters added to it will
increment the counter values.

I think we should leave all munging to nft_dynset.c, i.e. add/update
in terms of nft frontend set syntax.

> If NFT_SET_EVAL is set or not from nft_lookup is completely
> irrelevant, nft_lookup should not care about this flag.

Right, I will try to reflect that in the commit message.
