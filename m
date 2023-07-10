Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2681EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 17:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjGJR67 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 13:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbjGJR66 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 13:58:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C406D127
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 10:58:54 -0700 (PDT)
Date:   Mon, 10 Jul 2023 19:58:51 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH] nftables: add flag for nft context to avoid blocking
 getaddrinfo()
Message-ID: <ZKxG23yJzlRRPpsO@calendula>
References: <20230710174652.221651-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230710174652.221651-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 10, 2023 at 07:46:30PM +0200, Thomas Haller wrote:
> getaddrinfo() blocks while trying to resolve the name. Blocking the
> caller of the library is bad in some cases. Especially, while
> reconfiguring the firewall, it's not clear that we can access the
> network to resolve names.
> 
> Add a way to opt out from getaddrinfo() and only accept plain IP addresses.
> 
> The opt-out is per nft_ctx instance and cannot be changed after the
> context is created. I think that is sufficient.
> 
> We could also use AI_NUMERICHOST and getaddrinfo() instead of
> inet_pton(). But it seems we can do a better job of generating an error
> message, when we try to parse via inet_pton(). Then our error message
> can clearly indicate that the string is not a valid IP address.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  include/datatype.h             |  1 +
>  include/nftables/libnftables.h |  1 +
>  py/nftables.py                 | 12 +++++-
>  src/datatype.c                 | 68 ++++++++++++++++++++--------------
>  src/evaluate.c                 | 16 +++++++-
>  5 files changed, 66 insertions(+), 32 deletions(-)
> 
> diff --git a/include/datatype.h b/include/datatype.h
> index 4b59790b67f9..108bf03ad0ed 100644
> --- a/include/datatype.h
> +++ b/include/datatype.h
> @@ -182,6 +182,7 @@ struct datatype *dtype_clone(const struct datatype *orig_dtype);
>  
>  struct parse_ctx {
>  	struct symbol_tables	*tbl;
> +	bool			no_block;
>  };
>  
>  extern struct error_record *symbol_parse(struct parse_ctx *ctx,
> diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
> index 85e08c9bc98b..d75aff05dec8 100644
> --- a/include/nftables/libnftables.h
> +++ b/include/nftables/libnftables.h
> @@ -34,6 +34,7 @@ enum nft_debug_level {
>   * Possible flags to pass to nft_ctx_new()
>   */
>  #define NFT_CTX_DEFAULT		0
> +#define NFT_CTX_NO_BLOCK	1

Could you add this flag instead?

        NFT_CTX_INPUT_NO_DNS

there are NFT_CTX_OUTPUT_* flags already in place that determine how
the output is done, but better not to (ab)use them.

And add:

        nft_ctx_input_set_flags(...)

to allow users to set it on.

>  struct nft_ctx *nft_ctx_new(uint32_t flags);
>  void nft_ctx_free(struct nft_ctx *ctx);
