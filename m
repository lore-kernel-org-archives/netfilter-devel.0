From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/3] src/evaluate.c: improve rule management checks
Date: Thu, 7 Apr 2016 18:39:43 +0200
Message-ID: <20160407163943.GA2367@salvia>
References: <145873749309.10004.11477358360509958985.stgit@nfdev2.cica.es>
 <145873749855.10004.10666252455830923605.stgit@nfdev2.cica.es>
 <20160323160834.GA6981@salvia>
 <CAOkSjBgH5PVfRisRXb3gqTi1Feaf+gVn=AFHVEFvH-zsBn1ZSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51653 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbcDGQjx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 12:39:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 852466DFCB
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:39:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6AE31DA3A5
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:39:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3D681DA385
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:39:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgH5PVfRisRXb3gqTi1Feaf+gVn=AFHVEFvH-zsBn1ZSA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 28, 2016 at 01:32:41PM +0200, Arturo Borrero Gonzalez wrote:
> +static int rule_evaluate_cmd(struct eval_ctx *ctx)
> +{
> +	struct handle *handle = &ctx->cmd->handle;
> +
> +	/* allowed:
> +	 * - insert [position] (no handle)
> +	 * - add [position] (no handle)
> +	 * - replace <handle> (no position)
> +	 * - delete <handle> (no position)
> +	 */
> +
> +	switch (ctx->cmd->op) {
> +	case CMD_INSERT:
> +		if (handle->handle.id && handle->position.id)
> +			return handle_position_error(ctx, "Could not insert "
> +						     "rule: wrong combination"
> +						     ", use only `position' "
> +						     "instead");

I know we have this "Could not insert rule:" thing in other four spots
in the evaluation.c, but those are my fault and I'll get rid of them
soon.

Given that we now have good error reporting through location, I
suggest you use the shortened version.

	return handle_position_error(ctx, "you cannot combine this");

The error reporting we have visualizes the problem to the user.

Thanks.
