From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/4 v2] src: add support to import json/xml with
 the new syntax
Date: Fri, 30 Jan 2015 20:56:52 +0100
Message-ID: <20150130195652.GB23741@salvia>
References: <1422628525-28109-1-git-send-email-alvaroneay@gmail.com>
 <1422628525-28109-2-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53181 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbbA3Tx7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2015 14:53:59 -0500
Content-Disposition: inline
In-Reply-To: <1422628525-28109-2-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 30, 2015 at 03:35:23PM +0100, Alvaro Neira Ayuso wrote:
> diff --git a/src/ruleset.c b/src/ruleset.c
> index 3fb381d..0c8eadf 100644
> --- a/src/ruleset.c
> +++ b/src/ruleset.c
> @@ -32,6 +32,31 @@ struct nft_ruleset {
>  	uint16_t		flags;
>  };
>  
> +struct nft_parse_ctx {
> +	uint32_t cmd;
> +	uint32_t type;
> +	uint32_t format;
> +	union {
> +		struct nft_table *table;
> +		struct nft_chain *chain;
> +		struct nft_rule *rule;
> +		struct nft_set *set;
> +		struct nft_set_elem *set_elem;
> +	};
> +	union {
> +		json_t *json;
> +		mxml_node_t *xml;
> +	};
> +

Please, put all private fields below a comment like:

/* These fields below are not exposed to the user */

> +	uint32_t set_id;
> +	struct nft_set_list *set_list;

These two are private too, and include uint32_t format here too.

> +	void *data;

This 'data' public, so place it above that comment.

So if we need to have a look at this later on, we easily know what is
exposed and what is not.

> +	int (*cb)(const struct nft_parse_ctx *ctx);
> +	uint16_t flags;
> +};
