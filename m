Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F928C0651F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 14:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 749B72083B
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 14:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfGDOnQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 10:43:16 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48738 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfGDOnQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 10:43:16 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hj2x8-0007ak-J7; Thu, 04 Jul 2019 16:43:14 +0200
Date:   Thu, 4 Jul 2019 16:43:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 1/3] nft: don't use xzalloc()
Message-ID: <20190704144314.GF31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <156197834773.14440.15033673835278456059.stgit@endurance>
 <20190704102123.GA20778@orbyte.nwl.cc>
 <20190704124136.2go4aouj2l4vva6i@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704124136.2go4aouj2l4vva6i@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Jul 04, 2019 at 02:41:36PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 04, 2019 at 12:21:23PM +0200, Phil Sutter wrote:
> > Hi Arturo,
> > 
> > On Mon, Jul 01, 2019 at 12:52:48PM +0200, Arturo Borrero Gonzalez wrote:
> > > In the current setup, nft (the frontend object) is using the xzalloc() function
> > > from libnftables, which does not makes sense, as this is typically an internal
> > > helper function.
> > > 
> > > In order to don't use this public libnftables symbol (a later patch just
> > > removes it), let's use calloc() directly in the nft frontend.
> > > 
> > > Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> > 
> > This series breaks builds for me. Seems you missed xfree() and xmalloc()
> > used in src/main.c and src/cli.c.
> 
> Hm, this did not break here for me.

I was testing my inet-nat config enhancement. The Makefile.am change
caused an automake rerun, maybe that exposed the problem.

> Patch is attached.

Works fine, thanks! I didn't fix it myself because I wasn't sure whether
it makes sense to turn these wrappers into inline functions so both the
library and frontend could use them.

Cheers, Phil
