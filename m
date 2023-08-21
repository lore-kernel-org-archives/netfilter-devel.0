Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A33EE4993
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 13:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbjHUNOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 09:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbjHUNOm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 09:14:42 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF8C12D
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 06:14:15 -0700 (PDT)
Received: from [78.30.34.192] (port=46230 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qY4iW-00Dm3H-6D
        for netfilter-devel@vger.kernel.org; Mon, 21 Aug 2023 15:13:14 +0200
Date:   Mon, 21 Aug 2023 15:13:11 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: use correct lock to protect
 gc_list
Message-ID: <ZONi53oXf8Agcvwh@calendula>
References: <20230821123332.34690-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230821123332.34690-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 21, 2023 at 02:33:32PM +0200, Pablo Neira Ayuso wrote:
> Use nf_tables_gc_list_lock spinlock, not nf_tables_destroy_list_lock to
> protect the destroy list.

For the record, this text should be instead:

  ... to protect the gc_list.

> Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a255456efae4..eb8b1167dced 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -9456,9 +9456,9 @@ static void nft_trans_gc_work(struct work_struct *work)
>  	struct nft_trans_gc *trans, *next;
>  	LIST_HEAD(trans_gc_list);
>  
> -	spin_lock(&nf_tables_destroy_list_lock);
> +	spin_lock(&nf_tables_gc_list_lock);
>  	list_splice_init(&nf_tables_gc_list, &trans_gc_list);
> -	spin_unlock(&nf_tables_destroy_list_lock);
> +	spin_unlock(&nf_tables_gc_list_lock);
>  
>  	list_for_each_entry_safe(trans, next, &trans_gc_list, list) {
>  		list_del(&trans->list);
> -- 
> 2.30.2
> 
