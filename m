Return-Path: <SRS0=t5ds=XV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2201C432C2
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 10:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F4D32053B
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Sep 2019 10:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbfIZKk5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Sep 2019 06:40:57 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47280 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfIZKk5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Sep 2019 06:40:57 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iDRCg-00061h-Nt; Thu, 26 Sep 2019 12:40:54 +0200
Date:   Thu, 26 Sep 2019 12:40:54 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH v2 0/2] parser_bison: Get rid of (most) bison
 compiler warnings
Message-ID: <20190926104054.GF14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20190723132313.13238-1-phil@nwl.cc>
 <20190730124106.5edmsjwzzgknpnjs@salvia>
 <20190730140354.GO14469@orbyte.nwl.cc>
 <20190730141845.exhy3tshlbdjnknj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730141845.exhy3tshlbdjnknj@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Jul 30, 2019 at 04:18:45PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 30, 2019 at 04:03:54PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Jul 30, 2019 at 02:41:06PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Jul 23, 2019 at 03:23:11PM +0200, Phil Sutter wrote:
> > > > Eliminate as many bison warnings emitted since bison-3.3 as possible.
> > > > Sadly getting bison, flex and automake right is full of pitfalls so on
> > > > one hand this series does not fix for deprecated %name-prefix statement
> > > > and on the other passes -Wno-yacc to bison to not complain about POSIX
> > > > incompatibilities although automake causes to run bison in POSIX compat
> > > > mode in the first place. Fixing either of those turned out to be
> > > > non-trivial.
> > > 
> > > Indeed, lots of warnings and things to be updated.
> > > 
> > > Do you think it's worth fixing those in the midterm?
> > > 
> > > We can just place these two small ones in the tree, I'm just concerned
> > > about tech debt in the midterm, these deprecated stuff might just go
> > > away.
> > 
> > We should avoid calling bison with -y since the parser simply isn't
> > POSIX yacc compatible. I found a trick somewhere in WWW to do that (one
> > has to substitute AC_PROG_YACC) but lost the reference again. But after
> > doing so, there was a problem with file names I failed to resolve.
> > Hence why I resorted to just passing -Wno-yacc.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> If parser does not break with this and tests pass fine, I'm ok with
> this temporary solution. I also need all most warnings go away here by
> now.
> 
> Please, if you find that reference again share it with me.

Sorry, I didn't. But instead I found Bison 3.0 release notes[1], please
have a look at "Use of YACC='bison -y'" paragraph. I tried to set
YACC='bison -o y.tab.c' in configure.ac. This avoids the warnings in
parser_bison.y, but scanner.l fails to build as a macro ECHO is being
defined by bison/flex which clashes with ECHO keyword used by us.

Given that even Bison maintainer suggests to set -Wno-yacc, let's just
wait what autoconf-2.7 brings.

Speaking of parser_bison, we had a discussion at NFWS about whether to
quote all user-defined strings on output (and make sure to accept quotes
on input). Your bet was that it is possible to fix the problem of users
choosing keywords (e.g. "hour" as table name) from within bison. I tried
and came up with the following:

| --- a/src/parser_bison.y
| +++ b/src/parser_bison.y
| @@ -2021,6 +2021,8
|                         ;
|  
|  identifier             :       STRING
| +                       |       HOUR            { $$ = strdup("hour"); }
| +                       |       TABLE           { $$ = strdup("table"); }
|                         ;
|  
|  string                 :       STRING

This works in that I can create a table named "table":

| # nft add table table
| # nft list ruleset
| table ip table {
| }

But it causes shift/reduce warnings when compiling. Do you have an idea
for how to avoid the shift/reduce conflicts?

Cheers, Phil

[1] https://savannah.gnu.org/forum/forum.php?forum_id=7663
