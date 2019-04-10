Return-Path: <SRS0=tBTY=SM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14FB7C10F14
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Apr 2019 13:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D840D2133D
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Apr 2019 13:37:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732069AbfDJNhy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 09:37:54 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40356 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732063AbfDJNhx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 09:37:53 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hEDQC-00020q-Pl; Wed, 10 Apr 2019 15:37:48 +0200
Date:   Wed, 10 Apr 2019 15:37:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        arturo@netfilter.org
Subject: Re: [PATCH nft] evaluate: disallow anonymous set with empty elements
Message-ID: <20190410133748.GW4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        arturo@netfilter.org
References: <20190409105936.23422-1-pablo@netfilter.org>
 <20190409135925.GQ4851@orbyte.nwl.cc>
 <20190409140326.zme4ik6ozqbnf544@breakpoint.cc>
 <20190409231925.uancubapdemhdpqn@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190409231925.uancubapdemhdpqn@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Apr 10, 2019 at 01:19:25AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 09, 2019 at 04:03:26PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > Could we maybe find a middle ground where nft still does these
> > > optimizations but prints warnings so users are notified? We might even
> > > introduce -W flag to customize behaviour (-W all (default), -W error
> > > (strict mode), -W none (suppress any non-fatal output on stderr)).
> > 
> > I like this proposal.
> > 
> > One of the broken tproxy test cases (it prints warning) does this:
> > 
> > ip daddr 0.0.0.0/0
> 
> Yes, sorry, that's my fault.
> 
> > .. and that is always true and could be removed.
> > Different "problem" of course, but it shows that there is ample
> > opportunity for pruning irrelevant expressions.
> > 
> > And breaking scripts every time we decide that something is
> > "silly" is a bad decision, imo.
> 
> Agreed, this case is slightly bit corner case as they should _not_ be
> doing enclosing single element in brackets in their scripts. But I get
> your point, better adopt a more conservative approach ;-)
> 
> > I suspect users will complain about { 1.2.3.4 } being illegal
> > "just because".
> 
> I'll explore the warning idea, it can be an initial step before we can
> fully disallow this, so users don't complain about sudden breakage :-)

What I have in mind is "dumb" scripts collecting addresses and adding a
rule matching them in an anonymous set. The case of just a single address
needs additional code, not just an adjustment of the existing one. This
is not so much a matter of bad design or missing education but one of
effort and feasibility.

Cheers, Phil
