Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43646C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 09:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbiK3Jhe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 04:37:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiK3JhO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 04:37:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBFF8BD34
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 01:34:11 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0JTl-0000OB-QB; Wed, 30 Nov 2022 10:34:09 +0100
Date:   Wed, 30 Nov 2022 10:34:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 iptables-nft 1/3] xlate: get rid of escape_quotes
Message-ID: <Y4cjkeS9I9PZmJ3H@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221129140542.28311-1-fw@strlen.de>
 <20221129140542.28311-2-fw@strlen.de>
 <Y4YnSH99kWqtHGeI@orbyte.nwl.cc>
 <20221130074719.GA17072@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130074719.GA17072@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 30, 2022 at 08:47:19AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Tue, Nov 29, 2022 at 03:05:40PM +0100, Florian Westphal wrote:
> > [...]
> > > diff --git a/extensions/libxt_LOG.c b/extensions/libxt_LOG.c
> > > index e3f4290ba003..b6fe0b2edda1 100644
> > > --- a/extensions/libxt_LOG.c
> > > +++ b/extensions/libxt_LOG.c
> > > @@ -151,12 +151,8 @@ static int LOG_xlate(struct xt_xlate *xl,
> > >  	const char *pname = priority2name(loginfo->level);
> > >  
> > >  	xt_xlate_add(xl, "log");
> > > -	if (strcmp(loginfo->prefix, "") != 0) {
> > > -		if (params->escape_quotes)
> > > -			xt_xlate_add(xl, " prefix \\\"%s\\\"", loginfo->prefix);
> > > -		else
> > > -			xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
> > > -	}
> > > +	if (strcmp(loginfo->prefix, "") != 0)
> > > +		xt_xlate_add(xl, " prefix \"%s\"", loginfo->prefix);
> > 
> > Use the occasion and replace the strcmp() call with a check for first
> > array elem?
> 
> Can do, but gcc should do that substitution too.

Ah, I didn't know that.

> > > +	bool				escape_quotes; /* not used anymore, retained for ABI */
> > >  };
> > 
> > We *could* rename the variable to intentionally break API so people
> > notice. OTOH, escape_quotes will always be false which is exactly what
> > we need.
> 
> Dunno.  I suggest to keep it and remove it once we change ABI for some
> other reason.

ACK.

Thanks, Phil
