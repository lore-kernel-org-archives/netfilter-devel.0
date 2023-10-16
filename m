Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AFFCDB482
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 20:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjJPUdD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 16:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbjJPUdC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 16:33:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAAA9B;
        Mon, 16 Oct 2023 13:33:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qsUGl-0002pi-1W; Mon, 16 Oct 2023 22:32:55 +0200
Date:   Mon, 16 Oct 2023 22:32:55 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [net-next PATCH] net: skb_find_text: Ignore patterns extending
 past 'to'
Message-ID: <20231016203255.GB10271@breakpoint.cc>
References: <20231013195113.3663-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231013195113.3663-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> Assume that caller's 'to' offset really represents an upper boundary for
> the pattern search, so patterns extending past this offset are to be
> rejected.
> 
> The old behaviour also was kind of inconsistent when it comes to
> fragmentation (or otherwise non-linear skbs): If the pattern started in
> between 'to' and 'from' offsets but extended to the next fragment, it
> was not found if 'to' offset was still within the current fragment.
> 
> Test the new behaviour in a kselftest using iptables' string match.
> 
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: f72b948dcbb85 ("[NET]: skb_find_text ignores to argument")

FYI, checkpatch complains about the fixes tag.

> diff --git a/tools/testing/selftests/netfilter/xt_string.sh b/tools/testing/selftests/netfilter/xt_string.sh
> new file mode 100755
> index 0000000000000..1802653a47287
> --- /dev/null
> +++ b/tools/testing/selftests/netfilter/xt_string.sh

Thanks for the test case. Is there a reason why its not hooked
up to the kselftest makefile?

I think it should be.
