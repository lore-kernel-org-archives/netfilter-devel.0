Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6824CCA47C
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jun 2022 17:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbiFWR0z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Jun 2022 13:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiFWR00 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Jun 2022 13:26:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE826E780
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2022 10:02:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o4QE4-0006mx-8X; Thu, 23 Jun 2022 19:02:40 +0200
Date:   Thu, 23 Jun 2022 19:02:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] Revert "scanner: remove saddr/daddr from initial
 state"
Message-ID: <20220623170240.GB21459@breakpoint.cc>
References: <20220623155241.28859-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623155241.28859-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> This reverts commit df4ee3171f3e3c0e85dd45d555d7d06e8c1647c5 as it
> breaks ipsec expression if preceeded by a counter statement:
> 
> | Error: syntax error, unexpected string, expecting saddr or daddr
> | add rule ip ipsec-ip4 ipsec-forw counter ipsec out ip daddr 192.168.1.2
> |                                                       ^^^^^
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Fold the two patches into one.

Please hold back a bit, I think this is a bug in the scoping code
on nft side, not a flex or bison limitation.

I've applied the test case locally and will report back on alternate
fix for this bug.
