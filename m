Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B83C28CC5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 19:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71887206BB
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 19:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFETeN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:34:13 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:59300 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfFETeM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 15:34:12 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hYbfn-0008Qj-1r; Wed, 05 Jun 2019 21:34:11 +0200
Date:   Wed, 5 Jun 2019 21:34:11 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nft 4/4] src: single cache_update() call to build cache
 before evaluation
Message-ID: <20190605193410.GY31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20190605164652.20199-1-pablo@netfilter.org>
 <20190605164652.20199-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605164652.20199-5-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Jun 05, 2019 at 06:46:52PM +0200, Pablo Neira Ayuso wrote:
[...]
> diff --git a/src/cache.c b/src/cache.c
> new file mode 100644
> index 000000000000..89a884012a90
> --- /dev/null
> +++ b/src/cache.c
> @@ -0,0 +1,123 @@
> +/*
> + * Copyright (c) 2019 Pablo Neira Ayuso <pablo@netfilter.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <expression.h>
> +#include <statement.h>
> +#include <rule.h>
> +#include <erec.h>
> +#include <utils.h>
> +
> +static void evaluate_cache_add(struct cmd *cmd, unsigned int *completeness)
> +{
> +	switch (cmd->obj) {
> +	case CMD_OBJ_SETELEM:
> +	case CMD_OBJ_SET:
> +	case CMD_OBJ_CHAIN:
> +	case CMD_OBJ_FLOWTABLE:
> +		if (*completeness < cmd->op)
> +			*completeness = cmd->op;
> +		break;
> +	case CMD_OBJ_RULE:
> +		/* XXX index is set to zero unless this handle_merge() call is
> +		 * invoked, this handle_merge() call is done from the
> +		 * evaluation, which is too late.
> +		 */

Using the right handle was somehow tricky. IIRC, getting it right was
part of the work on v5 of my series. Maybe you were working around a bug
in my code?

> +		handle_merge(&cmd->rule->handle, &cmd->handle);
> +
> +		if (cmd->rule->handle.index.id &&
> +		    *completeness < CMD_LIST)
> +			*completeness = CMD_LIST;
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static void evaluate_cache_del(struct cmd *cmd, unsigned int *completeness)
> +{
> +	switch (cmd->obj) {
> +	case CMD_OBJ_SETELEM:
> +		if (*completeness < cmd->op)
> +			*completeness = cmd->op;

This manual max() thing seems to be a common pattern. Maybe make these
functions return cmd->op (or the desired completeness) and handle the
max() check in caller?

[...]
> +int cache_evaluate(struct nft_ctx *nft, struct list_head *cmds)
> +{
> +	unsigned int completeness = CMD_INVALID;
> +	struct cmd *cmd;
> +
> +	list_for_each_entry(cmd, cmds, list) {
> +		switch (cmd->op) {
> +		case CMD_ADD:
> +		case CMD_INSERT:
> +		case CMD_REPLACE:
> +			if (nft_output_echo(&nft->output) &&
> +			    completeness < cmd->op)
> +				return cmd->op;

Is 'return' correct here? That would abort cmd list processing.

> +
> +			/* Fall through */
> +		case CMD_CREATE:
> +			evaluate_cache_add(cmd, &completeness);
> +			break;
> +		case CMD_DELETE:
> +			evaluate_cache_del(cmd, &completeness);
> +			break;
> +		case CMD_GET:
> +		case CMD_LIST:
> +		case CMD_RESET:
> +		case CMD_EXPORT:
> +		case CMD_MONITOR:
> +			if (completeness < cmd->op)
> +				completeness = cmd->op;
> +			break;
> +		case CMD_FLUSH:
> +			evaluate_cache_flush(cmd, &completeness);
> +			break;
> +		case CMD_RENAME:
> +			evaluate_cache_rename(cmd, &completeness);

As suggested above, I would do (also in the other cases):

			tmp = evaluate_cache_rename(cmd);

> +			break;
> +		case CMD_DESCRIBE:
> +		case CMD_IMPORT:
> +			break;
> +		default:
> +			break;
> +		}

And here:
		completeness = max(tmp, completeness);

> +	}
> +
> +	return completeness;
> +}

Cheers, Phil
