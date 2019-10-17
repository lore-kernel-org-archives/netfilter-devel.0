Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54623C4CECE
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 08:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359D720872
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 08:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408082AbfJQIAt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 04:00:49 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55594 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392718AbfJQIAt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 04:00:49 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iL0iF-0002DV-LC; Thu, 17 Oct 2019 10:00:47 +0200
Date:   Thu, 17 Oct 2019 10:00:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/4] Revert "monitor: fix double cache update with
 --echo"
Message-ID: <20191017080047.GT25052@breakpoint.cc>
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016230322.24432-3-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> This reverts commit 9b032cd6477b847f48dc8454f0e73935e9f48754.
> 
> While it is true that a cache exists, we still need to capture new sets
> and their elements if they are anonymous. This is because the name
> changes and rules will refer to them by name.
> 
> Given that there is no easy way to identify the anonymous set in cache
> (kernel doesn't (and shouldn't) dump SET_ID value) to update its name,
> just go with cache updates. Assuming that echo option is typically used
> for single commands, there is not much cache updating happening anyway.

Acked-by: Florian Westphal <fw@strlen.de>

