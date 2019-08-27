Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE88C3A5A6
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 10:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111C0204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 10:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfH0Ki5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 06:38:57 -0400
Received: from correo.us.es ([193.147.175.20]:45542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfH0Ki4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 06:38:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78B6367B97
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:38:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A407D2B1D
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 12:38:53 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5FCE6DA4D0; Tue, 27 Aug 2019 12:38:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3373BDA7B6;
        Tue, 27 Aug 2019 12:38:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 27 Aug 2019 12:38:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0F5FB42EE39C;
        Tue, 27 Aug 2019 12:38:51 +0200 (CEST)
Date:   Tue, 27 Aug 2019 12:38:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 11/14] nft: Bore up nft_parse_payload()
Message-ID: <20190827103852.5gef3xhk4nrql7jb@salvia>
References: <20190821092602.16292-1-phil@nwl.cc>
 <20190821092602.16292-12-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821092602.16292-12-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 11:25:59AM +0200, Phil Sutter wrote:
> Allow for closer inspection by storing payload expression's base and
> length values. Also facilitate for two consecutive payload expressions
> as LHS of a (cmp/lookup) statement as used with concatenations.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft-shared.c | 8 ++++++++
>  iptables/nft-shared.h | 4 +++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index d5984d0577ed1..0f8cabf9abcc7 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -445,8 +445,16 @@ static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>  
>  static void nft_parse_payload(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
>  {
> +	if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
> +		memcpy(&ctx->prev_payload, &ctx->payload,
> +		       sizeof(ctx->prev_payload));
> +		ctx->flags |= NFT_XT_CTX_PREV_PAYLOAD;
> +	}
>
>  	ctx->reg = nftnl_expr_get_u32(e, NFTNL_EXPR_META_DREG);
> +	ctx->payload.base = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_BASE);
>  	ctx->payload.offset = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_OFFSET);
> +	ctx->payload.len = nftnl_expr_get_u32(e, NFTNL_EXPR_PAYLOAD_LEN);
>  	ctx->flags |= NFT_XT_CTX_PAYLOAD;
>  }
>  
> diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> index ff3beef1af0de..cb7eea6208cd2 100644
> --- a/iptables/nft-shared.h
> +++ b/iptables/nft-shared.h
> @@ -43,6 +43,7 @@ enum {
>  	NFT_XT_CTX_META		= (1 << 1),
>  	NFT_XT_CTX_BITWISE	= (1 << 2),
>  	NFT_XT_CTX_IMMEDIATE	= (1 << 3),
> +	NFT_XT_CTX_PREV_PAYLOAD	= (1 << 4),

Why does ebt among needs this?
