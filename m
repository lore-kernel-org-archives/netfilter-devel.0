From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 3/3 v3] src: add xt compat support
Date: Tue, 5 Jul 2016 14:46:37 +0200
Message-ID: <20160705124637.GA28499@salvia>
References: <20160629123307.32609-1-pablombg@gmail.com>
 <20160629123307.32609-3-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbcGEMqq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 08:46:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 32ADE210F2B
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 14:46:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24D5C8E7B4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 14:46:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 588D6FAB53
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 14:46:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160629123307.32609-3-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 29, 2016 at 02:33:07PM +0200, Pablo M. Bermudo Garay wrote:
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 1a02ecd..a36a488 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -28,6 +28,7 @@
>  #include <erec.h>
>  #include <gmputil.h>
>  #include <utils.h>
> +#include <xt.h>
>  
>  static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
>  
> @@ -2294,6 +2295,8 @@ int stmt_evaluate(struct eval_ctx *ctx, struct stmt *stmt)
>  		return stmt_evaluate_fwd(ctx, stmt);
>  	case STMT_SET:
>  		return stmt_evaluate_set(ctx, stmt);
> +	case STMT_XT:
> +		return stmt_evaluate_xt(ctx, stmt);

You can get rid of stmt_evaluate_xt() and the underlying code there.
We don't exercise this code anymore.

This removal simplify your patchset even more.
