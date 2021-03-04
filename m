Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0AEC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 07:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7BD64EFC
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 07:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233863AbhCDHrl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 02:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhCDHrb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 02:47:31 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACC4C061574;
        Wed,  3 Mar 2021 23:46:51 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lHih6-0007VN-FI; Thu, 04 Mar 2021 08:46:48 +0100
Date:   Thu, 4 Mar 2021 08:46:48 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] netfilter: x_tables: Use correct memory barriers.
Message-ID: <20210304074648.GJ17911@breakpoint.cc>
References: <20210304013116.8420-1-mark.tomlinson@alliedtelesis.co.nz>
 <20210304013116.8420-4-mark.tomlinson@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304013116.8420-4-mark.tomlinson@alliedtelesis.co.nz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mark Tomlinson <mark.tomlinson@alliedtelesis.co.nz> wrote:
> When a new table value was assigned, it was followed by a write memory
> barrier. This ensured that all writes before this point would complete
> before any writes after this point. However, to determine whether the
> rules are unused, the sequence counter is read. To ensure that all
> writes have been done before these reads, a full memory barrier is
> needed, not just a write memory barrier. The same argument applies when
> incrementing the counter, before the rules are read.
> 
> Changing to using smp_mb() instead of smp_wmb() fixes the kernel panic
> reported in cc00bcaa5899,

Can you reproduce the crashes without this change?

> while still maintaining the same speed of replacing tables.

How much of an impact is the MB change on the packet path?

Please also CC authors of the patches you want reverted when reposting.
