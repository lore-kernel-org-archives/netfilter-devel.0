Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0BAC433E7
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 19:36:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A87062223F
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 19:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390752AbgJNTf4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 15:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390744AbgJNTf4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 15:35:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC90C061755;
        Wed, 14 Oct 2020 12:35:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kSmYx-0003tJ-Cz; Wed, 14 Oct 2020 21:35:51 +0200
Date:   Wed, 14 Oct 2020 21:35:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
Message-ID: <20201014193551.GD16895@breakpoint.cc>
References: <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
 <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
 <20201009110323.GC5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092035550.19307@blackhole.kfki.hu>
 <20201009185552.GF5723@breakpoint.cc>
 <alpine.DEB.2.23.453.2010092132220.19307@blackhole.kfki.hu>
 <20201009200548.GG5723@breakpoint.cc>
 <20201014000628.GA15290@salvia>
 <20201014082341.GA16895@breakpoint.cc>
 <CA+HUmGij2kddxovowfK=Wt=SB6N2sTLTb1Hs+65MfrZGpv=YWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HUmGij2kddxovowfK=Wt=SB6N2sTLTb1Hs+65MfrZGpv=YWg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Francesco Ruggeri <fruggeri@arista.com> wrote:
> On Wed, Oct 14, 2020 at 1:23 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Legacy would still be flawed though.
> >
> > Its fine too, new rule blob gets handled (and match/target checkentry
> > called) before old one is dismantled.
> >
> > We only have a 0 refcount + hook unregister when rules get
> > flushed/removed explicitly.
> 
> Should the patch be used in the meantime while this gets
> worked out?

I think the patch is correct, and I do NOT see a better solution.
