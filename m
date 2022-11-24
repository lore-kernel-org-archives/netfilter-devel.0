Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F06AC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 17:22:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiKXRWl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 12:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiKXRWg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 12:22:36 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0D3E58
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 09:22:27 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oyFvd-000171-KK; Thu, 24 Nov 2022 18:22:25 +0100
Date:   Thu, 24 Nov 2022 18:22:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] xt: Rewrite unsupported compat expression dumping
Message-ID: <Y3+oUeGrKbcdpntz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20221124165641.26921-1-phil@nwl.cc>
 <20221124165641.26921-4-phil@nwl.cc>
 <20221124170454.GG2753@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124170454.GG2753@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 24, 2022 at 06:04:54PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > diff --git a/src/scanner.l b/src/scanner.l
> > index 1371cd044b65a..4edd729c80dab 100644
> > --- a/src/scanner.l
> > +++ b/src/scanner.l
> > @@ -214,6 +214,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
> >  %s SCANSTATE_TCP
> >  %s SCANSTATE_TYPE
> >  %s SCANSTATE_VLAN
> > +%s SCANSTATE_XT
> >  %s SCANSTATE_CMD_EXPORT
> >  %s SCANSTATE_CMD_IMPORT
> >  %s SCANSTATE_CMD_LIST
> > @@ -799,6 +800,8 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
> >  
> >  "secmark"		{ scanner_push_start_cond(yyscanner, SCANSTATE_SECMARK); return SECMARK; }
> >  
> > +"xt"			{ scanner_push_start_cond(yyscanner, SCANSTATE_XT); return XT; }
> 
> Why is there a new scanner state?  It has no tokens, so it doesn't do
> anything.
> 
> Perhaps a leftover?  Or did you plan to make match/target/watcher scoped
> tokens?

We want to accept two arbitrary strings after "xt" and just complain
about the whole thing. Without the scope, something like "xt target
exthdr" will make the parser complain about the unexpected keyword.

Cheers, Phil
