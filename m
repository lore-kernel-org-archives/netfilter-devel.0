Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3D6C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 21:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjKCVr6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 17:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjKCVr5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 17:47:57 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E122D5A
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 14:47:50 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qz216-0004IX-Rd; Fri, 03 Nov 2023 22:47:48 +0100
Date:   Fri, 3 Nov 2023 22:47:48 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/2] json: drop warning on stderr for missing
 json() hook in stmt_print_json()
Message-ID: <ZUVqhFgp4KJy8bqI@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20231103162937.3352069-1-thaller@redhat.com>
 <20231103162937.3352069-3-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103162937.3352069-3-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 03, 2023 at 05:25:14PM +0100, Thomas Haller wrote:
> All "struct stmt_ops" really must have a json hook set, to handle the
> statement. And almost all of them do, except "struct chain_stmt_ops".
> 
> Soon a unit test will be added, to check that all stmt_ops have a json()
> hook. Also, the missing hook in "struct chain_stmt_ops" is a bug, that
> is now understood and shall be fixed soon/later.
> 
> Note that we can already hit the bug, if we would call `nft -j list
> ruleset` at the end of test "tests/shell/testcases/nft-f/sample-ruleset":
> 
>     warning: stmt ops chain have no json callback
> 
> Soon tests will be added, that hit this condition. Printing a message to
> stderr breaks those tests, and blocks adding the tests.

Why not make the tests tolerate messages on stderr instead?

> Drop this warning on stderr, so we can add those other tests sooner, as
> those tests are useful for testing JSON code in general. The warning
> stderr was useful for finding the problem, but the problem is now
> understood and will be addressed separately. Drop the message to unblock
> adding those tests.

What do you mean with "the problem is now understood"?

> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  src/json.c      | 10 ++++++++--
>  src/statement.c |  1 +
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/src/json.c b/src/json.c
> index 25e349155394..8fff401dfb3e 100644
> --- a/src/json.c
> +++ b/src/json.c
> @@ -83,8 +83,14 @@ static json_t *stmt_print_json(const struct stmt *stmt, struct output_ctx *octx)
>  	if (stmt->ops->json)
>  		return stmt->ops->json(stmt, octx);
>  
> -	fprintf(stderr, "warning: stmt ops %s have no json callback\n",
> -		stmt->ops->name);

Converting this to using octx->error_fp does not help?

> +	/* In general, all "struct stmt_ops" must implement json() hook. Otherwise
> +	 * we have a bug, and a unit test should check that all ops are correct.
> +	 *
> +	 * Currently, "chain_stmt_ops.json" is known to be NULL. That is a bug that
> +	 * needs fixing.
> +	 *
> +	 * After the bug is fixed, and the unit test in place, this fallback code
> +	 * can be dropped. */

How will those unit tests cover new statements added at a later time? We
don't have a registration process, are you planning to discover them
based on enum stmt_types or something like that?

Cheers, Phil
