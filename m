Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CF3E7F14E
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 13:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjI0NJ6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 09:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbjI0NJ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 09:09:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE235126
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 06:09:54 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlUIb-0001Ik-7w; Wed, 27 Sep 2023 15:09:53 +0200
Date:   Wed, 27 Sep 2023 15:09:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 3/3,v2] netlink_linearize: skip set element
 expression in map statement key
Message-ID: <ZRQpodNr/9aiVI7H@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230926160216.152549-1-pablo@netfilter.org>
 <ZRMNB+3/4rzYb08p@orbyte.nwl.cc>
 <ZRPq/JMoVffTEDM4@calendula>
 <ZRQNkSG/dnesQ6Wv@orbyte.nwl.cc>
 <ZRQPw+jMI+i9qSyE@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRQPw+jMI+i9qSyE@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 01:19:31PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Sep 27, 2023 at 01:10:09PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, Sep 27, 2023 at 10:42:36AM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > > Did you ever follow up on your pull request for libjansson or did you
> > > find a way to dynamically allocate the error reporting area that they
> > > complain about?
> > 
> > All done. When there were no technical reasons left to reject it, I was
> > told it's not important enough[1].
> 
> Concern seems to be related to extra memory consumption.
> 
> Would it be possible to revisit your patchset so the extra memory
> consumption for error reporting only happens if some flag is toggle to
> request this? Some sort of opt-in mechanism. Would that be feasible?

You mean eliminate the 'location' pointer field from json_*_t structs?
Because apart from that, the whole thing is already opt-in based on
JSON_STORE_LOCATION flag.

> > > Error reporting with libjansson is very rudimentary, there is no way
> > > to tell what precisely in the command that is represented in JSON is
> > > actually causing the error, this coarse grain error reporting is too
> > > broad.
> > 
> > Indeed, and my implementation would integrate nicely with nftables'
> > erecs.
> 
> Yes, I like that.
> 
> > I actually considered forking the project. Or we just ship a copy of the
> > lib with nftables sources?
> 
> I would try to get back to them to refresh and retry.

Oh well. I'll try an approach which eliminates the pointer if not
enabled. The terse feedback and pessimistic replies right from the start
convinced me though they just don't want it.

Cheers, Phil
