Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50880C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjKIXZL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjKIXZK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:25:10 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99690449A
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:25:08 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1EOZ-0006Jj-Ab; Fri, 10 Nov 2023 00:25:07 +0100
Date:   Fri, 10 Nov 2023 00:25:07 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, thaller@redhat.com, fw@strlen.de
Subject: Re: [PATCH nft 02/12] tests: shell: skip pipapo tests if kernel
 lacks support
Message-ID: <20231109232507.GD8000@breakpoint.cc>
References: <20231109162304.119506-1-pablo@netfilter.org>
 <20231109162304.119506-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109162304.119506-3-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Skip tests that require net/netfilter/nft_set_pipapo support.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  tests/shell/features/pipapo.nft                      |  9 +++++++++
>  tests/shell/testcases/maps/0013map_0                 |  2 ++
>  tests/shell/testcases/maps/anon_objmap_concat        |  2 ++
>  tests/shell/testcases/maps/typeof_integer_0          |  2 ++
>  .../shell/testcases/optimizations/merge_stmts_concat |  2 ++
>  tests/shell/testcases/optimizations/merge_vmap_raw   |  2 ++
>  tests/shell/testcases/sets/0034get_element_0         |  2 ++
>  tests/shell/testcases/sets/0043concatenated_ranges_0 |  1 +
>  tests/shell/testcases/sets/0043concatenated_ranges_1 |  2 ++
>  tests/shell/testcases/sets/0044interval_overlap_0    | 12 ++++++++++--
>  tests/shell/testcases/sets/0047nat_0                 |  2 ++
>  tests/shell/testcases/sets/concat_interval_0         |  2 ++
>  12 files changed, 38 insertions(+), 2 deletions(-)
>  create mode 100644 tests/shell/features/pipapo.nft
> 
> diff --git a/tests/shell/features/pipapo.nft b/tests/shell/features/pipapo.nft
> new file mode 100644
> index 000000000000..17b56f2210d4
> --- /dev/null
> +++ b/tests/shell/features/pipapo.nft
> @@ -0,0 +1,9 @@
> +# aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
> +# v5.13-rc1~94^2~10^2~2

# 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
# v5.6-rc1~151^2~28^2~1
