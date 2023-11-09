Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A387C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjKIX0P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbjKIX0O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:26:14 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD43420F
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:26:12 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1EPa-0006LN-MO; Fri, 10 Nov 2023 00:26:10 +0100
Date:   Fri, 10 Nov 2023 00:26:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, thaller@redhat.com, fw@strlen.de
Subject: Re: [PATCH nft 03/12] tests: shell: skip prerouting reject tests if
 kernel lacks support
Message-ID: <20231109232610.GF8000@breakpoint.cc>
References: <20231109162304.119506-1-pablo@netfilter.org>
 <20231109162304.119506-4-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109162304.119506-4-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Skip tests that require reject at prerouting hook.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  tests/shell/features/prerouting_reject.nft  | 8 ++++++++
>  tests/shell/testcases/optimizations/ruleset | 2 ++
>  2 files changed, 10 insertions(+)
>  create mode 100644 tests/shell/features/prerouting_reject.nft
> 
> diff --git a/tests/shell/features/prerouting_reject.nft b/tests/shell/features/prerouting_reject.nft
> new file mode 100644
> index 000000000000..26098bb54534
> --- /dev/null
> +++ b/tests/shell/features/prerouting_reject.nft
> @@ -0,0 +1,8 @@
> +# f53b9b0bdc59 netfilter: introduce support for reject at prerouting stage
> +# v5.13-rc1~94^2~10^2~2

# v5.9-rc1~133^2~302^2~11
