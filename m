From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/6] netfilter: xtables: generate initial table on-demand
Date: Mon, 24 Aug 2009 15:12:44 +0200
Message-ID: <4A9291CC.3000606@trash.net>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de> <1249931992-18761-7-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51753 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZHXNMq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Aug 2009 09:12:46 -0400
In-Reply-To: <1249931992-18761-7-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The static initial tables are pretty large, and after the net
> namespace has been instantiated, they just hang around for nothing.
> This commit removes them and creates tables on-demand at runtime when
> needed.
> 
> Some numbers:
>     text    data     bss     dec     hex filename
> -4043674  563169  512000 5118843  4e1b7b ./vmlinux[x86_64](before)
> +4045071  550177  512000 5107248  4dee30 ./vmlinux[x86_64](after)
> =  +1397  -12992
> === -11595

They are actually freed when no network namespaces are used.
But I agree that this makes sense since distributors are going
to enable them.

> +/*
> + * Today's hack: quantum tunneling in structs
> + *
> + * 'entries' and 'term' are never anywhere referenced by word in code. In fact,
> + * they serve as the hanging-off data accessed through repl.data[]!
> + */
> +#define xt_repldata_mk(type, typ2) \
> +	struct { \
> +		struct type##_replace repl; \
> +		struct type##_standard entries[nhooks]; \
> +		struct type##_error term; \
> +	} *tbl = kzalloc(sizeof(*tbl), GFP_KERNEL); \
> +	if (tbl == NULL) \
> +		return NULL; \
> +	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
> +	tbl->term = (struct type##_error)typ2##_ERROR_INIT;  \
> +	tbl->repl.valid_hooks = hook_mask; \
> +	tbl->repl.num_entries = nhooks + 1; \
> +	tbl->repl.size = nhooks * sizeof(struct type##_standard) + \
> +	                 sizeof(struct type##_error); \
> +	for (; hook_mask != 0; hook_mask >>= 1, ++hooknum) { \
> +		if (!(hook_mask & 1)) \
> +			continue; \
> +		tbl->repl.hook_entry[hooknum] = bytes; \
> +		tbl->repl.underflow[hooknum]  = bytes; \
> +		tbl->entries[i++] = (struct type##_standard) \
> +			typ2##_STANDARD_INIT(NF_ACCEPT); \
> +		bytes += sizeof(struct type##_standard); \
> +	}
> +
> +void *xt_repldata_create(const struct xt_table *info)
> +{
> +	unsigned int hook_mask = info->valid_hooks;
> +	unsigned int nhooks = xt_hookmask_bitcount(hook_mask);
> +	unsigned int bytes = 0, hooknum = 0, i = 0;
> +
> +	if (info->af == NFPROTO_IPV6) {
> +		xt_repldata_mk(ip6t, IP6T);
> +		return tbl;

Would look slightly nicer if the above macro would "return"
the table, then you could simply do "return xt_repldata_mk(..);"
without using variables declared within the macro.

> +	} else if (info->af == NFPROTO_IPV4) {
> +		xt_repldata_mk(ipt, IPT);
> +		return tbl;
> +	} else if (info->af == NFPROTO_ARP) {
> +		xt_repldata_mk(arpt, ARPT);
> +		return tbl;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(xt_repldata_create);

How about adding this beauty to the respective address-family
specific files (ip_tables.c etc)? That would avoid some of the
bloat of the new function (apparently almost 1300bytes) when
only some of those modules are used.

I also would prefer a nicer name, something like
xt_alloc_initial_table().
