Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 906F1C4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47CBF23741
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Dec 2020 11:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgLQLiB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 06:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgLQLiA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 06:38:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5BAC061794
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2020 03:37:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1kpras-0007Zl-Hm; Thu, 17 Dec 2020 12:37:14 +0100
Date:   Thu, 17 Dec 2020 12:37:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     fw@strlen.de, lkp@intel.com, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, stranche@codeaurora.org
Subject: Re: [PATCH nf] netfilter: x_tables: Update remaining dereference to
 RCU
Message-ID: <20201217113714.GB23575@breakpoint.cc>
References: <1608179882-1207-1-git-send-email-subashab@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608179882-1207-1-git-send-email-subashab@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> wrote:
> This fixes the dereference to fetch the RCU pointer when holding
> the appropriate xtables lock.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: cc00bcaa5899 ("netfilter: x_tables: Switch synchronization to RCU")
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Reviewed-by: Florian Westphal <fw@strlen.de>
