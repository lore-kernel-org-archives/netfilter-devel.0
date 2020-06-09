Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D88C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 17:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D7032074B
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 17:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731852AbgFIRgL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 13:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbgFIRgL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 13:36:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6940C05BD1E
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2020 10:36:10 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jiiAS-0004N0-1M; Tue, 09 Jun 2020 19:36:08 +0200
Date:   Tue, 9 Jun 2020 19:36:08 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [nft PATCH] src: Quote user-defined names
Message-ID: <20200609173608.GI3060@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190116184613.31698-1-phil@nwl.cc>
 <20190116191900.fpkefbm6fvmhuz2b@salvia>
 <20190214111054.6kazlpk3nxabfvuy@salvia>
 <20190214174303.GU26388@orbyte.nwl.cc>
 <20200123224548.GP19873@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123224548.GP19873@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jan 23, 2020 at 11:45:48PM +0100, Phil Sutter wrote:
> On Thu, Feb 14, 2019 at 06:43:03PM +0100, Phil Sutter wrote:
> > On Thu, Feb 14, 2019 at 12:10:54PM +0100, Pablo Neira Ayuso wrote:
> > > Another spin on this, let's try to make a final decision on this asap.
> > > 
> > > In this case, this patch passes the quoted string to the kernel, so
> > > the listing shows it again.
> > > 
> > > Still, problem here is that the shell is stripping off the quotes
> > > unless I escape them, ie.
> > > 
> > >         nft add chain "x" "y"
> > > 
> > > enters the unquoted path from the scannner. So I have to use:
> > > 
> > >         nft add chain \"x\" \"y\"
> > > 
> > > or:
> > > 
> > >         nft add chain x '"y"'
> > > 
> > > I think your patch fixes the problem with using keywords as object
> > > names, which we could also fix via a rule that deals with this.
> > > 
> > > The problem with using any arbitrary name would be still there, unless
> > > the user escapes the quotes.
> > > 
> > > On the other hand, if we quote the string in the listing by default,
> > > we clearly show that these are user-defined, which is not a bad idea.
> > > However, we don't get much from showing quotes by default on listings,
> > > I mean, this is not solving the arbitrary name problem from the input
> > > path, which I think it the real problem.
> > > 
> > > Then, enforcing quotes since the beginning would not have helped
> > > either, because of the shell behaviour.
> > > 
> > > Exploring another patch here to allow to use keywords without quotes
> > > as object names, it won't look nice in bison, since we will need
> > > something similar to what we do in primary_rhs_expr for TCP, UDP...
> > > but it will work.
> > 
> > Are you sure about that? Flex would still recognize the keyword as such
> > and you won't get STRING type in Bison. Or am I missing the point?
> > 
> > Personally, I'm totally fine with people having to escape the quotes.
> > This is how shells work, and we have the same problem in other situation
> > requiring the quotes, too. My shell for instance catches the curly
> > braces and semi-colons, as well if not escaped.
> > 
> > Quoting all user-defined names on output merely helps with the case
> > where a user *really* wanted to produce a confusing ruleset and to avoid
> > ruleset restore after dump from failing miserably because the names are
> > not quoted in output.
> 
> Getting back to this dusty topic again: I played with extending
> 'identifier' in parser_bison.c like so:
> 
> | @@ -2183,6 +2183,7 @@ chain_policy              :       ACCEPT          { $$ = NF_ACCEPT; }
> |                         ;
> |  
> |  identifier             :       STRING
> | +                       |       HOUR            { $$ = strdup("hour"); }
> |                         ;
> |  
> |  string                 :       STRING
> 
> I am able to create a table named 'hour'. The approach has two problems
> though AFAICT:
> 
> 1) When adding TABLE as identifier, bison spews shift/reduce conflict
>    warnings.
> 
> 2) In order to allow for really arbitrary names, we would have to add
>    all defined keywords to identifier. This is tedious, ugly and (most
>    importantly) a moving target.

I had another idea, namely teaching flex to recognize a bit of context
by defining e.g. 'table <something>' as a keyword. But this turns into a
mess when it comes to optional family specifiers, line breaks, etc. Also
this is probably not how lex/yacc was meant to be used.

The reason why I keep getting back to this is the increasing impact on
users over time: Whenever we introduce a new keyword, we potentially
break someone's working ruleset.

With bison not even accepting quoted names everywhere, there is no way
out even for cautious users.

Can we please restart discussions on how to solve this issue?

Cheers, Phil
