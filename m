Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B2AC5B578
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 21:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C00520B7C
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 21:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfGAVrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 17:47:31 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41880 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbfGAVra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 17:47:30 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hi493-0000QG-1t; Mon, 01 Jul 2019 23:47:29 +0200
Date:   Mon, 1 Jul 2019 23:47:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] parser_bison: Accept arbitrary user-defined names
 by quoting
Message-ID: <20190701214728.GR31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190624163608.17348-1-phil@nwl.cc>
 <20190628180051.47o27vbgqrsjpwab@salvia>
 <20190701161139.GQ31548@orbyte.nwl.cc>
 <20190701181341.na3v3jmk2hejlmyq@salvia>
 <20190701181924.2xo7akmbqtcrh6bj@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701181924.2xo7akmbqtcrh6bj@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Jul 01, 2019 at 08:19:24PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 01, 2019 at 08:13:41PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jul 01, 2019 at 06:11:39PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Fri, Jun 28, 2019 at 08:00:51PM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, Jun 24, 2019 at 06:36:08PM +0200, Phil Sutter wrote:
> > > > > Parser already allows to quote user-defined strings in some places to
> > > > > avoid clashing with defined keywords, but not everywhere. Extend this
> > > > > support further and add a test case for it.
> > > > > 
> > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > ---
> > > > > Changes since v1:
> > > > > - Fix testcase, I forgot to commit adjustments done to it.
> > > > > 
> > > > > Note: This is a reduced variant of "src: Quote user-defined names" sent
> > > > >       back in January. Discussion was not conclusive regarding whether
> > > > >       to quote these names on output or not, but I assume allowing for
> > > > >       users to specify them by adding quotes is a step forward without
> > > > >       drawbacks.
> > > > 
> > > > So this will fail later on, right?
> > > > 
> > > >         nft list ruleset > file.nft
> > > >         nft -f file.nft
> > > 
> > > Yes, that's right. I sent a complete version which does the necessary
> > > quoting on output in January[1], but discussion wasn't conclusive. You
> > > had a different approach which accepts the quotes as part of the name
> > > but you weren't happy with it, either. I *think* you wanted to search
> > > for ways to solve this from within bison but we never got back to it
> > > anymore.
> > > 
> > > This simplified patch is merely trying to make things consistent
> > > regarding user-defined names. IIRC, I can already have an interface
> > > named "month", use that in a netdev family chain declaration (quoted)
> > > and 'nft list ruleset' will print it unquoted, so it can't be applied
> > > anymore. Without my patch, it is simply impossible to use certain
> > > recognized keywords as names for tables, chains, etc., even if one
> > > accepted the implications it has.
> > 
> > I'm not arguing there's something to fix.
> > 
> > I'm telling this is still incomplete.
> > 
> > Would you allocate a bit of time to discuss this during the NFWS?
> 
> I mean, a quick summary of the different options for a complete
> solution for this, and we decide there.
> 
> Unless you tell me this is very urgent :-)

That's a great idea! I'll check my inbox for more of those unfinished
topics. :)

Thanks, Phil
