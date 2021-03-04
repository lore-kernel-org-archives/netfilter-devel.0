Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88183C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 07:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E13F64EFC
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 07:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhCDHoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 02:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbhCDHoW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 02:44:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28904C061574;
        Wed,  3 Mar 2021 23:43:42 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lHie1-0007Sy-JD; Thu, 04 Mar 2021 08:43:37 +0100
Date:   Thu, 4 Mar 2021 08:43:37 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Revert "netfilter: x_tables: Update remaining
 dereference to RCU"
Message-ID: <20210304074337.GH17911@breakpoint.cc>
References: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
 <20210304013116.8420-2-mark.tomlinson@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304013116.8420-2-mark.tomlinson@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz> wrote:
> This reverts commit 443d6e86f821a165fae3fc3fc13086d27ac140b1.
> 
> This (and the following) patch basically re-implemented the RCU
> mechanisms of patch 784544739a25. That patch was replaced because of the
> performance problems that it created when replacing tables. Now, we have
> the same issue: the call to synchronize_rcu() makes replacing tables
> slower by as much as an order of magnitude.
> 
> See https://lore.kernel.org/patchwork/patch/151796/ for why using RCU is
> not a good idea.

Please don't add links for the rationale.
