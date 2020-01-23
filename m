Return-Path: <SRS0=Vl9M=3M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C6AC33CAA
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 22:45:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE4B1206A2
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jan 2020 22:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgAWWpu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jan 2020 17:45:50 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40846 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgAWWpu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jan 2020 17:45:50 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iulES-0006EZ-KK; Thu, 23 Jan 2020 23:45:48 +0100
Date:   Thu, 23 Jan 2020 23:45:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [nft PATCH] src: Quote user-defined names
Message-ID: <20200123224548.GP19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190116184613.31698-1-phil@nwl.cc>
 <20190116191900.fpkefbm6fvmhuz2b@salvia>
 <20190214111054.6kazlpk3nxabfvuy@salvia>
 <20190214174303.GU26388@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190214174303.GU26388@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi again,

On Thu, Feb 14, 2019 at 06:43:03PM +0100, Phil Sutter wrote:
> On Thu, Feb 14, 2019 at 12:10:54PM +0100, Pablo Neira Ayuso wrote:
> > Another spin on this, let's try to make a final decision on this asap.
> > 
> > In this case, this patch passes the quoted string to the kernel, so
> > the listing shows it again.
> > 
> > Still, problem here is that the shell is stripping off the quotes
> > unless I escape them, ie.
> > 
> >         nft add chain "x" "y"
> > 
> > enters the unquoted path from the scannner. So I have to use:
> > 
> >         nft add chain \"x\" \"y\"
> > 
> > or:
> > 
> >         nft add chain x '"y"'
> > 
> > I think your patch fixes the problem with using keywords as object
> > names, which we could also fix via a rule that deals with this.
> > 
> > The problem with using any arbitrary name would be still there, unless
> > the user escapes the quotes.
> > 
> > On the other hand, if we quote the string in the listing by default,
> > we clearly show that these are user-defined, which is not a bad idea.
> > However, we don't get much from showing quotes by default on listings,
> > I mean, this is not solving the arbitrary name problem from the input
> > path, which I think it the real problem.
> > 
> > Then, enforcing quotes since the beginning would not have helped
> > either, because of the shell behaviour.
> > 
> > Exploring another patch here to allow to use keywords without quotes
> > as object names, it won't look nice in bison, since we will need
> > something similar to what we do in primary_rhs_expr for TCP, UDP...
> > but it will work.
> 
> Are you sure about that? Flex would still recognize the keyword as such
> and you won't get STRING type in Bison. Or am I missing the point?
> 
> Personally, I'm totally fine with people having to escape the quotes.
> This is how shells work, and we have the same problem in other situation
> requiring the quotes, too. My shell for instance catches the curly
> braces and semi-colons, as well if not escaped.
> 
> Quoting all user-defined names on output merely helps with the case
> where a user *really* wanted to produce a confusing ruleset and to avoid
> ruleset restore after dump from failing miserably because the names are
> not quoted in output.

Getting back to this dusty topic again: I played with extending
'identifier' in parser_bison.c like so:

| @@ -2183,6 +2183,7 @@ chain_policy              :       ACCEPT          { $$ = NF_ACCEPT; }
|                         ;
|  
|  identifier             :       STRING
| +                       |       HOUR            { $$ = strdup("hour"); }
|                         ;
|  
|  string                 :       STRING

I am able to create a table named 'hour'. The approach has two problems
though AFAICT:

1) When adding TABLE as identifier, bison spews shift/reduce conflict
   warnings.

2) In order to allow for really arbitrary names, we would have to add
   all defined keywords to identifier. This is tedious, ugly and (most
   importantly) a moving target.

Do you think it is possible to address these problems?

Cheers, Phil
