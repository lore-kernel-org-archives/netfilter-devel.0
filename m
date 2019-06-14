Return-Path: <SRS0=9u1R=UN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F28C31E4C
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E070920866
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jun 2019 13:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfFNNl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jun 2019 09:41:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53508 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfFNNl0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 09:41:26 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hbmSK-0003xw-Ew; Fri, 14 Jun 2019 15:41:24 +0200
Date:   Fri, 14 Jun 2019 15:41:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft,v2] cache: do not populate the cache in case of flush
 ruleset command
Message-ID: <20190614134124.GP31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190614123630.17341-1-pablo@netfilter.org>
 <20190614125432.GO31548@orbyte.nwl.cc>
 <20190614125910.zlpbor35toz6ewgp@salvia>
 <20190614130438.y6stvoi3ydz33s55@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614130438.y6stvoi3ydz33s55@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Jun 14, 2019 at 03:04:38PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Jun 14, 2019 at 02:59:10PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jun 14, 2019 at 02:54:32PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Fri, Jun 14, 2019 at 02:36:30PM +0200, Pablo Neira Ayuso wrote:
> > > > __CMD_FLUSH_RULESET is a dummy definition that used to skip the netlink
> > > > dump to populate the cache. This patch is a workaround until we have a
> > > > better infrastructure to track the state of the cache objects.
> > > 
> > > I assumed the problem wouldn't exist anymore since we're populating the
> > > cache just once. Can you maybe elaborate a bit on the problem you're
> > > trying to solve with that workaround?
> > 
> > If nft segfaults to dump the cache, 'nft flush ruleset' will not work
> > since it always fetches the cache, it will segfault too.
> > 
> > The flush ruleset command was still dumping the cache before this
> > patch.
> 
> In general, we still need to improve the cache logic, to make it finer
> grain. Now that we have a single point to populate the cache, things
> will get more simple. We need to replace the cache command level to
> cache flags or our own cache level definitions. The existing approach
> that uses of commands to define the cache level completeness has its
> own limitations. We can discuss this during the NFWS :-).

Yes, I had the same thought already. It is quite unintuitive how we link
cache completeness to certain commands. :)

Regarding your problem, maybe cache_update() should exit immediately if
passed cmd is CMD_INVALID? Unless I miss something, if cache_evaluate()
returns that value, we don't need a cache at all.

Cheers, Phil
