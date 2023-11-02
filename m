Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9AAC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjKBLYu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjKBLYt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:24:49 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4337E111
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:24:47 -0700 (PDT)
Received: from [78.30.35.151] (port=49914 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyVoZ-008ckb-9O; Thu, 02 Nov 2023 12:24:45 +0100
Date:   Thu, 2 Nov 2023 12:24:42 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/2] json: implement json() hook for
 "symbol_expr_ops"/"variabl_expr_ops"
Message-ID: <ZUOG+sXwE6E7y9dc@calendula>
References: <20231102112122.383527-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231102112122.383527-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 12:20:28PM +0100, Thomas Haller wrote:
> The ultimate goal is that all "struct expr_ops" have a "json()" hook
> set.
> 
> It's also faster, to just create the JSON node, instead of creating a
> memory stream, write there using print only to get the sting.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
> The patches 1/2 and 2/2 replaces
> 
>   Subject:	[PATCH nft 2/7] json: drop messages "warning: stmt ops chain have no json callback"
>   Date:	Tue, 31 Oct 2023 19:53:28 +0100
> 
>  include/json.h   |  4 ++++
>  src/expression.c |  2 ++
>  src/json.c       | 10 ++++++++++
>  3 files changed, 16 insertions(+)
> 
> diff --git a/include/json.h b/include/json.h
> index 39be8928e8ee..134e503afe54 100644
> --- a/include/json.h
> +++ b/include/json.h
> @@ -49,7 +49,9 @@ json_t *rt_expr_json(const struct expr *expr, struct output_ctx *octx);
>  json_t *numgen_expr_json(const struct expr *expr, struct output_ctx *octx);
>  json_t *hash_expr_json(const struct expr *expr, struct output_ctx *octx);
>  json_t *fib_expr_json(const struct expr *expr, struct output_ctx *octx);
> +json_t *symbol_expr_json(const struct expr *expr, struct output_ctx *octx);
>  json_t *constant_expr_json(const struct expr *expr, struct output_ctx *octx);
> +json_t *variable_expr_json(const struct expr *expr, struct output_ctx *octx);

Makes no sense.

Are these expression really triggering specifically errors? I don't
think so.

This expressions are consumed, ie. the get transformed into a
value_expr, but never use in an output path.
