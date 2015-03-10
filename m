From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH v3 2/2] src: add import command
Date: Tue, 10 Mar 2015 11:37:46 +0100
Message-ID: <20150310103737.GC4538@acer.localdomain>
References: <1425981858-10687-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39246 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbCJKhu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 06:37:50 -0400
Content-Disposition: inline
In-Reply-To: <1425981858-10687-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10.03, Alvaro Neira Ayuso wrote:
> @@ -275,6 +279,13 @@ struct export {
>  struct export *export_alloc(uint32_t format);
>  void export_free(struct export *e);
>  
> +struct import {
> +	uint32_t	format;
> +};
> +
> +struct import *import_alloc(uint32_t format);
> +void import_free(struct import *i);

How about a common struct for both commands? "format", "import_export",
...

> +import_cmd		:	import_format

Same here, please change export_format to something common.

> +static int ruleset_parse_setelems(const struct nft_parse_ctx *ctx)
> +{
> +	const struct ruleset_parse *rp;
> +	struct nft_set *set;
> +	uint32_t cmd;
> +	int ret = -1;
> +
> +	set = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_SET);
> +	rp = nft_ruleset_ctx_get(ctx, NFT_RULESET_CTX_DATA);
> +
> +	cmd = nft_ruleset_ctx_get_u32(ctx, NFT_RULESET_CTX_CMD);
> +	switch (cmd) {
> +	case NFT_CMD_ADD:
> +		ret = mnl_nft_setelem_batch_add(set, 0, rp->nl_ctx->seqnum);
> +		break;
> +	case NFT_CMD_DELETE:
> +		ret = mnl_nft_setelem_batch_del(set, 0, rp->nl_ctx->seqnum);
> +		break;
> +	default:
> +		errno = EOPNOTSUPP;
> +		break;

This would be a BUG, no? Same question for all similar cases.

> +static int do_command_import(struct netlink_ctx *ctx, struct cmd *cmd)
> +{
> +	int ret;
> +	struct nft_parse_err *err;
> +	struct ruleset_parse rp = {
> +		.nl_ctx = ctx,
> +		.cmd = cmd

Please align, makes it easier to read.

> +	ret = nft_ruleset_parse_file_cb(cmd->import->format, stdin, err, &rp,
> +					ruleset_parse_cb);
> +	if (ret < 0)
> +		nft_parse_perror("unable to import. Parsing failed", err);

I'd suggest a ": parsing failed", makes it clear that its only a single
error, not two.

> +
> +	nft_parse_err_free(err);
> +	return ret;
> +}
> +
