From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: Add option '-D' to define variables from
 command-line
Date: Mon, 4 Dec 2017 12:06:35 +0100
Message-ID: <20171204110635.GA19724@salvia>
References: <20171204105259.28070-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752640AbdLDLGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Dec 2017 06:06:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 388E42E7874
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 12:06:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A0B1DA87B
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Dec 2017 12:06:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171204105259.28070-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 04, 2017 at 04:22:59PM +0530, Harsha Sharma wrote:
> This patch adds option '-D' with optarg in form test="foo" to define
> variable to be referenced from input file.
> 
> For eg.
> nft -D test="foo" -f /tmp/test1

Could you generalize this to take comma separated list of variables,
ie.

nft -D test="foo",test2="bar" -f /tmp/test1

> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
> This patch passes identifier and its value as nft_ctx struct members
> and binds variable with symbol_bind and when symbol_lookup is called
> while parsing, then comparison returns true, but this patch causes 
> segmentation fault.

Valgrind can help you know where the crash is going on.

# cat /tmp/x
add table x
add chain x y
add rule x y ip saddr $test

# valgrind nft -D test="1.1.1.1" -f /tmp/x
[...]
==23100== Invalid read of size 8
==23100==    at 0x40E31A: expr_clone (expression.c:52)
==23100==    by 0x439826: expr_evaluate_symbol (evaluate.c:191)
==23100==    by 0x439826: expr_evaluate (evaluate.c:1790)
==23100==    by 0x43855D: expr_evaluate_relational (evaluate.c:1569)
==23100==    by 0x43855D: expr_evaluate (evaluate.c:1830)
==23100==    by 0x436F93: stmt_evaluate_expr (evaluate.c:1843)
==23100==    by 0x436F93: stmt_evaluate (evaluate.c:2780)
==23100==    by 0x43B20E: rule_evaluate (evaluate.c:2915)
==23100==    by 0x42FD44: nft_parse (parser_bison.y:727)
==23100==    by 0x40768D: nft_run (libnftables.c:86)
==23100==    by 0x407DF8: nft_run_cmd_from_filename
(libnftables.c:330)
==23100==    by 0x406FC5: main (main.c:292)

> @@ -49,6 +50,10 @@ void parser_init(struct mnl_socket *nf_sock, struct nft_cache *cache,
>  	state->ectx.nf_sock = nf_sock;
>  	state->ectx.debug_mask = debug_mask;
>  	state->ectx.octx = octx;
> +	if (variable->identifier != NULL) {
> +		struct expr *expr = (struct expr *) variable->expr_value;

This casting is not correct. You need to allocate a symbol expression, eg.

        $$ = symbol_expr_alloc(&@$, SYMBOL_DEFINE, scope, $2);

> +		symbol_bind(state->scopes[state->scope], variable->identifier, expr);
> +	}
