Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD2EC31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B616208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 17:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfFQR2d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 13:28:33 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:33590 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726004AbfFQR2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 13:28:33 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hcvQl-00036A-Vc; Mon, 17 Jun 2019 19:28:32 +0200
Date:   Mon, 17 Jun 2019 19:28:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 3/5] src: add cache level flags
Message-ID: <20190617172831.GX31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190617122518.10486-1-pablo@netfilter.org>
 <20190617122518.10486-3-pablo@netfilter.org>
 <20190617161104.GT31548@orbyte.nwl.cc>
 <20190617162840.pqeyndnjwh4amzwx@salvia>
 <20190617164559.GV31548@orbyte.nwl.cc>
 <20190617172433.4bbyykwagxblwn4k@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617172433.4bbyykwagxblwn4k@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 17, 2019 at 07:24:33PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 17, 2019 at 06:45:59PM +0200, Phil Sutter wrote:
> > On Mon, Jun 17, 2019 at 06:28:40PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Jun 17, 2019 at 06:11:04PM +0200, Phil Sutter wrote:
> > > > Hi,
> > > > 
> > > > On Mon, Jun 17, 2019 at 02:25:16PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > > 
> > > We need these for references to sets, eg.
> > > 
> > >         add rule x y ip saddr @x
> > > 
> > > same for other flowtable and object.
> > 
> > Oh, right. I got that wrong - old code is always fetching the above
> > items unless there's no ruleset in kernel (i.e., returned genid is 0).
> > 
> > I confused that with fetching rules which at some point started to
> > happen by accident with my changes.
> > 
> > > We should not use NFT_CACHE_RULE in this case, if this is what you
> > > suggest.
> > 
> > No, quite the opposite: I thought we could get by without fetching
> > anything from kernel at all.
> > 
> > Yet now I wonder why the handle guessing stops working, because the
> > above can't be the cause of it.
> 
> I think we should partial revert the changes that are doing the
> handle guessing, would you submit a patch for this?

There are no explicit changes allowing for it. The reason it works is
because user space doesn't care to check the given handle for existence
and in kernel space it is valid already.

Cheers, Phil
