Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0674AC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 23:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjKIX1i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 18:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbjKIX1i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 18:27:38 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2461B1727
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 15:27:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r1EQw-0006MC-LV; Fri, 10 Nov 2023 00:27:34 +0100
Date:   Fri, 10 Nov 2023 00:27:34 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, thaller@redhat.com, fw@strlen.de
Subject: Re: [PATCH nft 04/12] tests: shell: skip stateful expression in sets
 tests if kernel lacks support
Message-ID: <20231109232734.GG8000@breakpoint.cc>
References: <20231109162304.119506-1-pablo@netfilter.org>
 <20231109162304.119506-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109162304.119506-5-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Skip tests that require stateful expressions in sets.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  tests/shell/features/set_expr.sh              | 19 +++++++++++++++++++
>  tests/shell/testcases/json/0002table_map_0    |  1 +
>  tests/shell/testcases/maps/0009vmap_0         |  2 ++
>  .../testcases/optimizations/merge_stmts_vmap  |  2 ++
>  tests/shell/testcases/sets/0048set_counters_0 |  2 ++
>  .../testcases/sets/0051set_interval_counter_0 |  2 ++
>  tests/shell/testcases/sets/elem_opts_compat_0 |  2 ++
>  7 files changed, 30 insertions(+)
>  create mode 100755 tests/shell/features/set_expr.sh
> 
> diff --git a/tests/shell/features/set_expr.sh b/tests/shell/features/set_expr.sh
> new file mode 100755
> index 000000000000..c323d59e8920
> --- /dev/null
> +++ b/tests/shell/features/set_expr.sh
> @@ -0,0 +1,19 @@
> +#!/bin/bash
> +
> +# 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
> +# v5.6-rc5-1736-g65038428b2c6

v5.7-rc1~146^2~12^2~25

(git-describe --contains).
