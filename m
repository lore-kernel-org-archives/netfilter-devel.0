Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E68C61DB3
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Jan 2023 09:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjAEJiS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 04:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjAEJiP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 04:38:15 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A99551F0
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2023 01:38:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pDMhO-0008Rj-Vm; Thu, 05 Jan 2023 10:38:11 +0100
Date:   Thu, 5 Jan 2023 10:38:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: Re: [PATCH nf] selftests: netfilter: fix transaction test script
 timeout handling
Message-ID: <20230105093810.GA8857@breakpoint.cc>
References: <20230104115442.2427-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104115442.2427-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> The kselftest framework uses a default timeout of 45 seconds for
> all test scripts.
> 
> Increase the timeout to two minutes for the netfilter tests, this
> should hopefully be enough,
> 
> Make sure that, should the script be canceled, the net namespace and
> the spawned ping instances are removed.
> 
> Reported-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>

Fixes: 25d8bcedbf43 ("selftests: add script to stress-test nft packet path vs. control plane")
Reported-and-tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>

I'll add those tags when applying the patch to nf.git, thanks for
testing.
