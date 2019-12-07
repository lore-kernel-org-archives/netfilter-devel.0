Return-Path: <SRS0=byYJ=Z5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3727C43603
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 11:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3AC21835
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Dec 2019 11:03:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfLGLDK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Dec 2019 06:03:10 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:37178 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfLGLDK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Dec 2019 06:03:10 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1idXrf-0001Pz-UM; Sat, 07 Dec 2019 12:03:07 +0100
Date:   Sat, 7 Dec 2019 12:03:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: bogus lookup/get on
 consecutive elements in named sets
Message-ID: <20191207110307.GK14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191205180706.134232-1-pablo@netfilter.org>
 <20191205220408.GG14469@orbyte.nwl.cc>
 <20191206192647.h3htnpq3b4qmlphs@salvia>
 <20191206193938.7jceb5dvi2zwkm2g@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206193938.7jceb5dvi2zwkm2g@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Dec 06, 2019 at 08:39:38PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Dec 06, 2019 at 08:26:47PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Dec 05, 2019 at 11:04:08PM +0100, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Thu, Dec 05, 2019 at 07:07:06PM +0100, Pablo Neira Ayuso wrote:
> > > > The existing rbtree implementation might store consecutive elements
> > > > where the closing element and the opening element might overlap, eg.
> > > > 
> > > > 	[ a, a+1) [ a+1, a+2)
> > > > 
> > > > This patch removes the optimization for non-anonymous sets in the exact
> > > > matching case, where it is assumed to stop searching in case that the
> > > > closing element is found. Instead, invalidate candidate interval and
> > > > keep looking further in the tree.
> > > > 
> > > > This patch fixes the lookup and get operations.
> > > 
> > > I didn't get what the actual problem is?
> > 
> > The lookup/get results false, while there is an element in the rbtree.
> > Moreover, the get operation returns true as if a+2 would be in the
> > tree. This happens with named sets after several set updates, I could
> > reproduce the issue with several elements mixed with insertion and
> > deletions in one batch.
> 
> To extend the problem description: The issue is that the existing
> lookup optimization (that only works for the anonymous sets) might not
> reach the opening [ a+1, ... element if the closing ... , a+1) is
> found in first place when walking over the rbtree. Hence, walking the
> full tree in that case is needed.

Ah! Thanks a lot for your elaborations. It was really hard to grasp what
all this is about from the initial commit message. :)

Sometimes I wonder if we should do more set optimizations under the hood
when adding elements. Right now, we don't touch existing ones although
it would make sense. And we could be more intelligent for example if a
set contains 20-30 and a user adds 25-35.

Cheers, Phil
