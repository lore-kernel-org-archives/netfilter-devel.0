Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8993DC43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 15:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiFWPmh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 11:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiFWPme (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 11:42:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 404CA43AD4
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 08:42:33 -0700 (PDT)
Date:   Thu, 23 Jun 2022 17:42:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 2/2] Revert "scanner: remove saddr/daddr from initial
 state"
Message-ID: <YrSJ5lmnna7Ss0Ur@salvia>
References: <20220623142843.32309-1-phil@nwl.cc>
 <20220623142843.32309-3-phil@nwl.cc>
 <YrSJt+C+eNDZH/cl@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YrSJt+C+eNDZH/cl@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 23, 2022 at 05:41:46PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 23, 2022 at 04:28:43PM +0200, Phil Sutter wrote:
> > This reverts commit df4ee3171f3e3c0e85dd45d555d7d06e8c1647c5 as it
> > breaks ipsec expression if preceeded by a counter statement:
> > 
> > | Error: syntax error, unexpected string, expecting saddr or daddr
> > | add rule ip ipsec-ip4 ipsec-forw counter ipsec out ip daddr 192.168.1.2
> > |                                                       ^^^^^
> 
> Please add a test covering this regression case.

Oh, actually coming in a separated patch. Probably collapsing them is
better for git annotate, but your call.

Thanks
