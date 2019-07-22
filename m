Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6277C76188
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85B8C2190D
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 12:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbfGVMQh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 08:16:37 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53074 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbfGVMQh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 08:16:37 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hpXF5-0002Tt-EE; Mon, 22 Jul 2019 14:16:35 +0200
Date:   Mon, 22 Jul 2019 14:16:35 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        phil@nwl.cc
Subject: Re: [PATCH nft] doc: fib: explain example in more detail
Message-ID: <20190722121635.m2jbh7rx34mvxrgg@breakpoint.cc>
References: <20190721104305.29594-1-fw@strlen.de>
 <20190721184212.2fxviqkcil27wzqp@salvia>
 <20190721185432.o2wke7wecfdbyzfr@breakpoint.cc>
 <20190722115803.a6vjrirc3gxgqc2d@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722115803.a6vjrirc3gxgqc2d@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Jul 21, 2019 at 08:54:32PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Cc'ing Phil.
> > > 
> > > On Sun, Jul 21, 2019 at 12:43:05PM +0200, Florian Westphal wrote:
> > > > As noted by Felix Dreissig, fib documentation is quite terse, so explain
> > > > the 'saddr . iif' example with a few more words.
> > > 
> > > There are patches to disallow ifindex 0 from Phil
> > 
> > WHich ones?
> 
> https://patchwork.ozlabs.org/patch/1133521/

This is insane. "nft meta iif 0 counter" seems totally fine to me.

I think we should never try to be clever here.
