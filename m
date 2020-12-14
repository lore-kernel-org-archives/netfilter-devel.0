Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D47CC2BB48
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 16:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBC8722571
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Dec 2020 16:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440204AbgLNQOd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440194AbgLNQOT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Dec 2020 11:14:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65233C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2020 08:13:39 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1koqTi-0007NF-3u; Mon, 14 Dec 2020 17:13:38 +0100
Date:   Mon, 14 Dec 2020 17:13:38 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] nft: trace: print packet unconditionally
Message-ID: <20201214161338.GB8710@breakpoint.cc>
References: <20201212183625.71140-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201212183625.71140-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> The kernel includes the packet dump once for each base hook.
> This means that in case a table contained no matching rule(s),
> the packet dump will be included in the base policy dump.
> 
> Simply move the packet dump request out of the switch statement
> so the debug output shows current packet even with no matched rule.

Pushed this series with the one change (PRIx64) suggested by Phil.
