Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024FEC43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Nov 2022 15:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiKXPnO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 10:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiKXPnN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 10:43:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192E3898F8
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2022 07:43:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1oyENZ-0001BP-6P; Thu, 24 Nov 2022 16:43:09 +0100
Date:   Thu, 24 Nov 2022 16:43:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft 1/3] xlate: get rid of escape_quotes
Message-ID: <20221124154309.GE2753@breakpoint.cc>
References: <20221124134939.8245-1-fw@strlen.de>
 <20221124134939.8245-2-fw@strlen.de>
 <Y396RKuevTLC7f4+@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y396RKuevTLC7f4+@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Nov 24, 2022 at 02:49:37PM +0100, Florian Westphal wrote:
> > Its not necessary to escape " characters, we can simply
> > let xtables-translate print the entire translation/command
> > enclosed in '' chracters, i.e. nft 'add rule ...', this also takes
> > care of [, { and other special characters that some shells might
> > parse otherwise (when copy-pasting translated output).
> > 
> > This breaks all xlate test cases, fixup in followup patches.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> [...]
> > diff --git a/include/xtables.h b/include/xtables.h
> > index 9eba4f619d35..150d40bfafd9 100644
> > --- a/include/xtables.h
> > +++ b/include/xtables.h
> > @@ -211,14 +211,12 @@ struct xt_xlate_mt_params {
> >  	const void			*ip;
> >  	const struct xt_entry_match	*match;
> >  	int				numeric;
> > -	bool				escape_quotes;
> >  };
> >  
> >  struct xt_xlate_tg_params {
> >  	const void			*ip;
> >  	const struct xt_entry_target	*target;
> >  	int				numeric;
> > -	bool				escape_quotes;
> >  };
> 
> Does this break ABI compatibility?

Yes.  I can keep the bool as a dead member if you prefer.

> >  	if (ret)
> > -		printf("%s\n", xt_xlate_get(xl));
> > +		printf("%s", xt_xlate_get(xl));
> >  
> > +	puts("'");
> >  	xt_xlate_free(xl);
> >  	return ret;
> >  }
> 
> If h->ops->xlate() fails, the code prints "'\n". How about:
> 
> | if (ret)
> | 	printf("%s'\n", xt_xlate_get(xl));
> 
> Or am I missing something?

We already printed 'insert rule, hence it was weird for the '\n' to be missed, but I see that
the caller will print a ' # iptables-syntax' in that case, so I will
re-add the '\n' to where it was.

> >  	if (set[0]) {
> > -		printf("add set %s %s %s\n", family2str[h->family], p->table,
> > +		printf("'add set %s %s %s'\n", family2str[h->family], p->table,
> >  		       xt_xlate_set_get(xl));
> 
> Quoting needs to respect cs->restore value, no? Maybe simpler to
> introduce 'const char *tick = cs->restore ? "" : "'";' and just insert
> it everywhere needed.

Will do that.
