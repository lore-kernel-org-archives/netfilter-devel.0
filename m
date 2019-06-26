Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0458C48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A018B20659
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 10:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfFZKm5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 06:42:57 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40012 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfFZKm5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 06:42:57 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hg5OA-0001J5-TA; Wed, 26 Jun 2019 12:42:54 +0200
Date:   Wed, 26 Jun 2019 12:42:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: Use of oifname in input chains
Message-ID: <20190626104254.cfhkfpagequp6kuv@breakpoint.cc>
References: <20190625122954.GC9218@orbyte.nwl.cc>
 <20190625194321.e2siqh7jfhldwzgw@salvia>
 <20190626103230.b7eqh2i3ibpkfv52@breakpoint.cc>
 <20190626103746.ag26jczoq7ggkh5b@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626103746.ag26jczoq7ggkh5b@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > new chain C
> > meta oifname bla added to C
> > jump added from output to C
> > jump added from input to C   # should this fail? why?
> > 
> > new chain C
> > jump added from input to C
> > meta oifname added to C	     # same q: why should this fail?
> 
> There's tracking infrastructure for this already in place, right? It's
> just a matter to check for this from nft_meta_get_validate().

But what semantics would you add?
It seems it would 100% break existing rulesets.

new chain C
jump added from ouput to C
meta oifname added to C	   	# allowed? jump from output exists
jump added from input to C	# disallow this? Why?

..
delete jump from output		# disallow?

This seems rather suicidal to me.
