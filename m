Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27BAC4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiLHVl1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiLHVlI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:41:08 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F99084B6A
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:40:27 -0800 (PST)
Date:   Thu, 8 Dec 2022 22:40:22 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH 1/7] ebtables: Implement --check command
Message-ID: <Y5JZxolqr+dzWsgh@salvia>
References: <20221201163916.30808-1-phil@nwl.cc>
 <20221201163916.30808-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221201163916.30808-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 01, 2022 at 05:39:10PM +0100, Phil Sutter wrote:
> Sadly, '-C' is in use already for --change-counters (even though
> ebtables-nft does not implement this), so add a long-option only. It is
> needed for xlate testsuite in replay mode, which will use '--check'
> instead of '-C'.

Hm, yet another of those exotic deviations (from ip{6}tables) in
ebtables.

This -C is not supported by ebtables-nft, right? If so,
according to manpage, ebtables -C takes start_nr[:end_nr].

Maybe there is a chance to get this aligned with other ip{6}tables
tools by checking if optarg is available? Otherwise, really check the
ruleset?

BTW, I'm re-reading the ebtables manpage, not sure how this feature -C
was supposed to be used. Do you understand the usecase?
