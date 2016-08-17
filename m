From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3 v5 nft] Simplify parser rule_spec tree
Date: Wed, 17 Aug 2016 17:04:08 +0200
Message-ID: <20160817150408.GA10948@salvia>
References: <20160817110010.28943-1-carlosfg@riseup.net>
 <20160817110010.28943-2-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33732 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbcHQPEr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:04:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EF0F7D1622
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:04:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E18C7DA7F6
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:04:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DC532DA7E5
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:04:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160817110010.28943-2-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 17, 2016 at 01:00:09PM +0200, Carlos Falgueras García wrote:
> diff --git a/include/parser.h b/include/parser.h
> index 92beab2..41e5340 100644
> --- a/include/parser.h
> +++ b/include/parser.h
> @@ -27,6 +27,8 @@ struct parser_state {
>  
>  	struct list_head		cmds;
>  	struct eval_ctx			ectx;
> +
> +	bool				err_recovering;

There must be a better way to handle this.

The error records are placed in a list, so it should be possible to
cancel the last error record.

Anyway, to keep this simple at this stage, please submit a patch
without this err_recovering and we fall back on the default error
reporting, OK?

Carlos, look:

1st) Finish the tests for the libnftnl cmp.
2nd) Come back to this patchset for nft (only after 1st is done).

OK? One thing at time :)
