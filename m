Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF19C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 15:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiFWPoL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 11:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiFWPoL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 11:44:11 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD9724BDE
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 08:44:09 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1o4P03-00088E-O9; Thu, 23 Jun 2022 17:44:07 +0200
Date:   Thu, 23 Jun 2022 17:44:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 2/2] Revert "scanner: remove saddr/daddr from initial
 state"
Message-ID: <YrSKR0q8YEuolCjT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20220623142843.32309-1-phil@nwl.cc>
 <20220623142843.32309-3-phil@nwl.cc>
 <YrSJt+C+eNDZH/cl@salvia>
 <YrSJ5lmnna7Ss0Ur@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrSJ5lmnna7Ss0Ur@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 05:42:30PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 23, 2022 at 05:41:46PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Jun 23, 2022 at 04:28:43PM +0200, Phil Sutter wrote:
> > > This reverts commit df4ee3171f3e3c0e85dd45d555d7d06e8c1647c5 as it
> > > breaks ipsec expression if preceeded by a counter statement:
> > > 
> > > | Error: syntax error, unexpected string, expecting saddr or daddr
> > > | add rule ip ipsec-ip4 ipsec-forw counter ipsec out ip daddr 192.168.1.2
> > > |                                                       ^^^^^
> > 
> > Please add a test covering this regression case.
> 
> Oh, actually coming in a separated patch. Probably collapsing them is
> better for git annotate, but your call.

ACK, will send a v2.
