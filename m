From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] include: Remove __init macro definition.
Date: Fri, 30 Jun 2017 12:56:33 +0200
Message-ID: <20170630105633.GB1876@salvia>
References: <cover.1498814530.git.rvarsha016@gmail.com>
 <252529ca943916a9b9473b7a443460a6559dc8d2.1498814530.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54610 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdF3K4i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Jun 2017 06:56:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C801F249C5
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 12:56:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7768BAC33
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 12:56:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A16BCD1CB1
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jun 2017 12:56:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <252529ca943916a9b9473b7a443460a6559dc8d2.1498814530.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 30, 2017 at 02:57:12PM +0530, Varsha Rao wrote:
> Add nft_init function, which calls _init functions in main.c file.
> Remove __init macro definition as libnftables library will be created
> soon. Rename realm_table_init() function to avoid ambiguity as
> realm_table_rt_init() and realm_table_meta_init() in rt.c and meta.c
> files.
> 
> Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
> ---
>  include/nftables.h |  9 +++++++++
>  include/utils.h    |  1 -
>  src/ct.c           |  2 +-
>  src/datatype.c     |  2 +-
>  src/gmputil.c      |  2 +-
>  src/main.c         | 15 +++++++++++++++
>  src/meta.c         |  4 ++--
>  src/netlink.c      |  2 +-
>  src/rt.c           |  2 +-
>  src/xt.c           |  2 +-
>  10 files changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/include/nftables.h b/include/nftables.h
> index 26fd344..b188b9e 100644
> --- a/include/nftables.h
> +++ b/include/nftables.h
> @@ -117,5 +117,14 @@ struct parser_state;
>  
>  int nft_run(struct nft_ctx *nft, void *scanner, struct parser_state *state,
>  	    struct list_head *msgs);
> +void ct_label_table_init(void);
> +void mark_table_init(void);
> +void gmp_init(void);
> +void realm_table_rt_init(void);
> +void devgroup_table_init(void);
> +void netlink_open_sock(void);

OK, so before I apply this, I would like that we remove
netlink_open_sock() from nft_init().

Could you make a patch that does the following (in steps):

1) Add a new struct mnl_socket * field to struct nft_ctx, you can name
   this new field as 'nf_sock'.
2) Call netlink_open_sock() from nft_netlink(), at the very beginning,
   so you set ctx->nf_sock.
3) Use ctx->nf_sock everywhere in src/netlink.c and src/mnl.c,
   so this is not global anymore.

All this in one single patch. As a result, we don't need to call
netlink_open_sock() from nft_init() anymore.
