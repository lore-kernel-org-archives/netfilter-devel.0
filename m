Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23EBC77B73
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 May 2023 08:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjEBIZB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 May 2023 04:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjEBIYt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2023 04:24:49 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EF95E58
        for <netfilter-devel@vger.kernel.org>; Tue,  2 May 2023 01:24:47 -0700 (PDT)
Date:   Tue, 2 May 2023 10:24:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] netlink: restore typeof interval map data type
Message-ID: <ZFDIzKqH8jX1vQXD@calendula>
References: <20230501165119.396357-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230501165119.396357-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, May 01, 2023 at 06:51:19PM +0200, Florian Westphal wrote:
> When "typeof ... : interval ..." gets used, existing logic
> failed to validate the expressions.
> 
> "interval" means that kernel reserves twice the size,
> so consider this when validating and restoring.
> 
> Also fix up the dump file of the existing test
> case to be symmetrical.

LGTM. Thanks, I wanted to have at this bug too, it was on my list.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/netlink.c                                              | 7 ++++++-
>  .../testcases/sets/dumps/0067nat_concat_interval_0.nft     | 4 ++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/src/netlink.c b/src/netlink.c
> index f1452d48f424..3352ad0abb61 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -1024,10 +1024,15 @@ struct set *netlink_delinearize_set(struct netlink_ctx *ctx,
>  	list_splice_tail(&set_parse_ctx.stmt_list, &set->stmt_list);
>  
>  	if (datatype) {
> +		uint32_t dlen;
> +
>  		dtype = set_datatype_alloc(datatype, databyteorder);
>  		klen = nftnl_set_get_u32(nls, NFTNL_SET_DATA_LEN) * BITS_PER_BYTE;
>  
> -		if (set_udata_key_valid(typeof_expr_data, klen)) {
> +		dlen = data_interval ?  klen / 2 : klen;
> +
> +		if (set_udata_key_valid(typeof_expr_data, dlen)) {
> +			typeof_expr_data->len = klen;
>  			datatype_free(datatype_get(dtype));
>  			set->data = typeof_expr_data;
>  		} else {
> diff --git a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
> index 6af47c6682ce..0215691e28ee 100644
> --- a/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
> +++ b/tests/shell/testcases/sets/dumps/0067nat_concat_interval_0.nft
> @@ -18,14 +18,14 @@ table ip nat {
>  	}
>  
>  	map ipportmap4 {
> -		type ifname . ipv4_addr : interval ipv4_addr
> +		typeof iifname . ip saddr : interval ip daddr
>  		flags interval
>  		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69/32,
>  			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 }
>  	}
>  
>  	map ipportmap5 {
> -		type ifname . ipv4_addr : interval ipv4_addr . inet_service
> +		typeof iifname . ip saddr : interval ip daddr . tcp dport
>  		flags interval
>  		elements = { "enp2s0" . 10.1.1.136 : 1.1.2.69 . 22,
>  			     "enp2s0" . 10.1.1.1-10.1.1.135 : 1.1.2.66-1.84.236.78 . 22 }
> -- 
> 2.40.1
> 
