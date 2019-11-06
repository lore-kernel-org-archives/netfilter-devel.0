Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96416C5DF62
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 12:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68AD9217F4
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 12:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfKFMkX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 07:40:23 -0500
Received: from correo.us.es ([193.147.175.20]:46270 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbfKFMkW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 07:40:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A34D3C3A0A
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 13:40:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94A45B8005
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 13:40:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92FC9B7FF6; Wed,  6 Nov 2019 13:40:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98A0AB7FF2;
        Wed,  6 Nov 2019 13:40:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 13:40:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7193C41E4801;
        Wed,  6 Nov 2019 13:40:16 +0100 (CET)
Date:   Wed, 6 Nov 2019 13:40:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] libnftables: Store top_scope in struct nft_ctx
Message-ID: <20191106124017.trvdxr4dylvigg5g@salvia>
References: <20191030212854.19494-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030212854.19494-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 30, 2019 at 10:28:54PM +0100, Phil Sutter wrote:
> Allow for interactive sessions to make use of defines. Since parser is
> initialized for each line, top scope defines didn't persist although
> they are actually useful for stuff like:
> 
> | # nft -i
> | goodports = { 22, 23, 80, 443 }
   ^
'define' is missing here, right?

> | add rule inet t c tcp dport $goodports accept
> | add rule inet t c tcp sport $goodports accept
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

One more comment, possible follow up, just an idea.

> diff --git a/src/libnftables.c b/src/libnftables.c
> index e20372438db62..7c35e898d87ab 100644
> --- a/src/libnftables.c
> +++ b/src/libnftables.c
> @@ -155,6 +155,8 @@ struct nft_ctx *nft_ctx_new(uint32_t flags)
>  	nft_ctx_add_include_path(ctx, DEFAULT_INCLUDE_PATH);
>  	ctx->parser_max_errors	= 10;
>  	init_list_head(&ctx->cache.list);
> +	ctx->top_scope = xzalloc(sizeof(struct scope));
> +	init_list_head(&ctx->top_scope->symbols);

Probably add scope_alloc()

>  	ctx->flags = flags;
>  	ctx->output.output_fp = stdout;
>  	ctx->output.error_fp = stderr;
> @@ -292,6 +294,8 @@ void nft_ctx_free(struct nft_ctx *ctx)
>  	iface_cache_release();
>  	cache_release(&ctx->cache);
>  	nft_ctx_clear_include_paths(ctx);
> +	scope_release(ctx->top_scope);
> +	xfree(ctx->top_scope);

and scope_free().

>  	xfree(ctx->state);
>  	nft_exit(ctx);
>  	xfree(ctx);
> @@ -368,7 +372,7 @@ static int nft_parse_bison_buffer(struct nft_ctx *nft, const char *buf,
>  {
>  	int ret;
>  
> -	parser_init(nft, nft->state, msgs, cmds);
> +	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
>  	nft->scanner = scanner_init(nft->state);
>  	scanner_push_buffer(nft->scanner, &indesc_cmdline, buf);
>  
> @@ -384,7 +388,7 @@ static int nft_parse_bison_filename(struct nft_ctx *nft, const char *filename,
>  {
>  	int ret;
>  
> -	parser_init(nft, nft->state, msgs, cmds);
> +	parser_init(nft, nft->state, msgs, cmds, nft->top_scope);
>  	nft->scanner = scanner_init(nft->state);
>  	if (scanner_read_file(nft, filename, &internal_location) < 0)
>  		return -1;
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 7f9b1752f41d4..b73cf3bcfb209 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -42,13 +42,13 @@
>  #include "parser_bison.h"
>  
>  void parser_init(struct nft_ctx *nft, struct parser_state *state,
> -		 struct list_head *msgs, struct list_head *cmds)
> +		 struct list_head *msgs, struct list_head *cmds,
> +		 struct scope *top_scope)
>  {
>  	memset(state, 0, sizeof(*state));
> -	init_list_head(&state->top_scope.symbols);
>  	state->msgs = msgs;
>  	state->cmds = cmds;
> -	state->scopes[0] = scope_init(&state->top_scope, NULL);
> +	state->scopes[0] = scope_init(top_scope, NULL);
>  	init_list_head(&state->indesc_list);
>  }
>  
> diff --git a/tests/shell/testcases/nft-i/0001define_0 b/tests/shell/testcases/nft-i/0001define_0
> new file mode 100755
> index 0000000000000..62e1b6dede21d
> --- /dev/null
> +++ b/tests/shell/testcases/nft-i/0001define_0
> @@ -0,0 +1,22 @@
> +#!/bin/bash
> +
> +set -e
> +
> +# test if using defines in interactive nft sessions works
> +
> +$NFT -i >/dev/null <<EOF
> +add table inet t
> +add chain inet t c
> +define ports = { 22, 443 }
> +add rule inet t c tcp dport \$ports accept
> +add rule inet t c udp dport \$ports accept
> +EOF
> +
> +$NFT -i >/dev/null <<EOF
> +define port = 22
> +flush chain inet t c
> +redefine port = 443
> +delete chain inet t c
> +undefine port
> +delete table inet t
> +EOF
> -- 
> 2.23.0
> 
