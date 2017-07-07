From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3] include: Remove __init and __exit macro
 definitions.
Date: Fri, 7 Jul 2017 10:40:27 +0200
Message-ID: <20170707084027.GA1609@salvia>
References: <595e9838.8a0e620a.759bf.3e0f@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751782AbdGGIkh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Jul 2017 04:40:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3BCF95232D
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jul 2017 10:40:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DC0CD1CB3
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jul 2017 10:40:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07D99D1CA2
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Jul 2017 10:40:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <595e9838.8a0e620a.759bf.3e0f@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Varsha,

On Fri, Jul 07, 2017 at 01:36:10AM +0530, Varsha Rao wrote:
[...]
> diff --git a/src/main.c b/src/main.c
> index 7fbf00a..020ae6e 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -190,7 +190,7 @@ static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,

Please, pass 'struct mnl_socket *nf_sock' as parameter to nft_netlink.

No need for nft->nf_sock field, we only need it in nft_netlink(), and
if we pass it as parameter, it should be just fine.

Look, I want that nf_sock becomes a parameter since, like this, the
mnl_socket details get exposed, which gives us more flexibility.

>  	struct mnl_err *err, *tmp;
>  	LIST_HEAD(err_list);
>  	uint32_t batch_seqnum;
> -	bool batch_supported = netlink_batch_supported();
> +	bool batch_supported = netlink_batch_supported(nft->nf_sock);
>  	int ret = 0;
>  
>  	batch = mnl_batch_init();
> @@ -203,6 +203,7 @@ static int nft_netlink(struct nft_ctx *nft, struct parser_state *state,
>  		ctx.batch = batch;
>  		ctx.batch_supported = batch_supported;
>  		ctx.octx = &nft->output;
> +		ctx.nf_sock = nft->nf_sock;
>  		init_list_head(&ctx.list);
>  		ret = do_command(&ctx, cmd);
>  		if (ret < 0)
> @@ -262,6 +263,28 @@ err1:
>  	return ret;
>  }
>  
> +void nft_init(void)
> +{
> +	mark_table_init();
> +        realm_table_rt_init();
> +        devgroup_table_init();
> +        realm_table_meta_init();
> +        ct_label_table_init();
> +        gmp_init();
   ^^^^^^^^
indentation is broken here, use 8-chars tab.

> +#ifdef HAVE_LIBXTABLES
> +         xt_init();
> +#endif
> +}
> +
> +void nft_exit(void)
> +{
> +	ct_label_table_exit();
> +	realm_table_rt_exit();
> +	devgroup_table_exit();
> +	realm_table_meta_exit();
> +	mark_table_exit();
> +}
> +
>  int main(int argc, char * const *argv)
>  {
>  	struct parser_state state;
> @@ -271,7 +294,11 @@ int main(int argc, char * const *argv)
>  	unsigned int len;
>  	bool interactive = false;
>  	int i, val, rc = NFT_EXIT_SUCCESS;
> +	struct mnl_socket *nf_sock = NULL; /* XXX: netlink_socket_open(). */

Here:

        struct mnl_socket *nf_sock;

should be enough. You can remove the comment and the initialization to
NULL.

> +	nft_init();
> +	nf_sock = netlink_open_sock();
> +	nft.nf_sock = nf_sock;
>  	while (1) {
>  		val = getopt_long(argc, argv, OPTSTRING, options, NULL);
>  		if (val == -1)

Everything else looks good to me.

Thanks!
