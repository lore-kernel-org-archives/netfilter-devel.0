Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B26C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F0CB20663
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfLJLci (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:32:38 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45480 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727018AbfLJLci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 06:32:38 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iedko-0000Ui-NO; Tue, 10 Dec 2019 12:32:34 +0100
Date:   Tue, 10 Dec 2019 12:32:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [RFC PATCH nf-next] netfilter: conntrack: add support for
 storing DiffServ code-point as CT mark.
Message-ID: <20191210113234.GK795@breakpoint.cc>
References: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
 <20191209214208.852229-1-jeremy@azazel.net>
 <20191209224710.GI795@breakpoint.cc>
 <20191209232339.GA655861@azazel.net>
 <20191210012542.GJ795@breakpoint.cc>
 <20191210110100.GA5194@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210110100.GA5194@azazel.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jeremy Sowden <jeremy@azazel.net> wrote:
> On 2019-12-10, at 02:25:42 +0100, Florian Westphal wrote:
> > Jeremy Sowden <jeremy@azazel.net> wrote:
> > > > I have older patches that adds a 'typeof' keyword for set
> > > > definitions, maybe it could be used for this casting too.
> > >
> > > These?
> > >
> > >   https://lore.kernel.org/netfilter-devel/20190816144241.11469-1-fw@strlen.de/
> >
> > Yes, still did not yet have time to catch up and implement what Pablo
> > suggested though.
> 
> I'll take a look.

No need, I plan to resurrect this work soon.
If you really want to have a stab at it, let me know and I will rebase
what I have locally and push it out to a scratch repo for you.

Its not related to the 'ct mark' issue.  On second thought, reusing the
typeof keyword doesn't look like a good idea either.

We have, in most simple cases:

ct mark set 1
tcp dport set 42
ip daddr set 10.1.2.3

i.e. type on right side matches type of the left-hand expression.

tcp dport set 65536

would throw an error, as the number is out of range for the expected
port.

I thought that we could reuse typeof keyword:

tcp dport set typeof tcp dport 65536

But I'm not sure, it looks redundant, and I can't think of a
use-case/reason where one would need an 'intermediate type'
different from what is on the left-hand side.
