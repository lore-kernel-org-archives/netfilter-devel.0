From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATH 12/16] libnftables: transaction support
Date: Thu, 17 Aug 2017 12:11:28 +0200
Message-ID: <20170817101128.GY16375@orbyte.nwl.cc>
References: <20170816204310.3371-1-eric@regit.org>
 <20170816204310.3371-13-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57455 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbdHQKL3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 06:11:29 -0400
Content-Disposition: inline
In-Reply-To: <20170816204310.3371-13-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 16, 2017 at 10:43:06PM +0200, Eric Leblond wrote:
[...]
> diff --git a/src/libnftables.c b/src/libnftables.c
> index 494ff57..08050e5 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -151,3 +151,92 @@ int nft_run_command_from_filename(struct nft_ctx *nft, const char *filename)
>  	erec_print_list(stderr, &msgs);
>  	return rc;
>  }
> +
> +struct nft_batch *nft_batch_start(struct nft_ctx *nft)
> +{
> +	struct nft_batch *batch = malloc(sizeof(*batch));
> +	if (batch == NULL)
> +		return NULL;
> +
> +	batch->batch = mnl_batch_init();
> +	mnl_batch_begin(batch->batch, mnl_seqnum_alloc(&nft->cache.seqnum));
> +
> +	return batch;
> +}

Don't you need to initialize batch->nl_ctx here as well?

> +int nft_batch_add(struct nft_ctx *nft, struct nft_batch *batch,
> +		  const char * buf, size_t buflen)
> +{
> +	int rc = NFT_EXIT_SUCCESS;
> +	int ret = 0;
> +	struct parser_state state;
> +	LIST_HEAD(msgs);
> +	void *scanner;
> +	struct cmd *cmd, *next;
> +	struct netlink_ctx *ctx = &batch->nl_ctx;
> +	uint32_t seqnum;
> +	bool batch_supported = netlink_batch_supported(nft->nf_sock, &seqnum);

That should be an error condition in nft_batch_start(). If it turns out
to be false, later calls to do_command() will execute instead of adding
to batch buffer.

> +	parser_init(nft->nf_sock, &nft->cache, &state, &msgs);
> +	scanner = scanner_init(&state);
> +	scanner_push_buffer(scanner, &indesc_cmdline, buf);
> +		
> +	ret = nft_parse(scanner, &state);
> +	if (ret != 0 || state.nerrs > 0) {
> +		rc = -1;
> +		goto err1;
> +	} 
> +
> +	list_for_each_entry(cmd, &state.cmds, list) {
> +		nft_cmd_expand(cmd);
> +		memset(ctx, 0, sizeof(*ctx));
> +		ctx->msgs = &msgs;
> +		ctx->seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
> +		ctx->batch = batch->batch;
> +		ctx->batch_supported = batch_supported;
> +		ctx->octx = &nft->output;
> +		ctx->nf_sock = nft->nf_sock;
> +		ctx->cache = &nft->cache;
> +		init_list_head(&ctx->list);
> +		ret = do_command(ctx, cmd);
> +		if (ret < 0)
> +			return -1;
> +	}
> +
> +	list_for_each_entry_safe(cmd, next, &state.cmds, list) {
> +		list_del(&cmd->list);
> +		cmd_free(cmd);
> +	}
> +err1:
> +	scanner_destroy(scanner);
> +	erec_print_list(stderr, &msgs);
> +	return rc;
> +}
> +
> +int nft_batch_commit(struct nft_ctx *nft, struct nft_batch *batch)
> +{
> +	int ret = 0;
> +
> +	mnl_batch_end(batch->batch, mnl_seqnum_alloc(&nft->cache.seqnum));
> +	LIST_HEAD(err_list);
> +
> +	if (!mnl_batch_ready(batch->batch))
> +		goto out;

That's an error, no? (In the old code it was a regular exit point in
case batch support wasn't supported.)

Cheers, Phil
