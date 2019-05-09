Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E22C04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 15:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5603F216C4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 15:37:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEIPhr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 11:37:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35510 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbfEIPhq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 11:37:46 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hOl7B-0002zR-Ce; Thu, 09 May 2019 17:37:45 +0200
Date:   Thu, 9 May 2019 17:37:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, logan@cyberstorm.mu
Subject: Re: [nft PATCH 7/9] tests/py: Fix for ip dscp symbol "le"
Message-ID: <20190509153745.GM4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, logan@cyberstorm.mu
References: <20190509113545.4017-1-phil@nwl.cc>
 <20190509113545.4017-8-phil@nwl.cc>
 <20190509151106.qpgz6qrk4hawmbjs@salvia>
 <20190509151135.5p2ptf5pjqqagabs@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509151135.5p2ptf5pjqqagabs@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 09, 2019 at 05:11:35PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 09, 2019 at 05:11:06PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, May 09, 2019 at 01:35:43PM +0200, Phil Sutter wrote:
> > > In scanner.l, that name is defined as alternative to "<=" symbol. To
> > > avoid the clash, it must be quoted on input.
> > > 
> > > Fixes: 55715486efba4 ("proto: support for draft-ietf-tsvwg-le-phb-10.txt")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Note that nft still produces invalid output since it doesn't quote
> > > symbol table values.
> > 
> > I have reverted 55715486efba42 by now, I overlook that tests/py/ were
> > never run because the update for non-json is broken. @Logan: Please,
> > fix this and resubmit.
> > 
> > BTW, a trick similar to what we do in primary_rhs_expr to deal with
> > the "le" token showing as a constant value will be needed.

I'm not sure if that's possible - I would expect shift-reduce conflicts
since the parser can't decide between 'ip6 dscp <= cs1' and 'ip6 dscp
le'.

> For the record, this 7/9 patch was left behind, not needed after the
> revert.

Sure, it wasn't a complete fix anyway.

Thanks, Phil
