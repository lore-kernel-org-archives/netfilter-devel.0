Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6F9C83F12
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjH2SDR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbjH2SDF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:03:05 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DB119A
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:03:00 -0700 (PDT)
Received: from [78.30.34.192] (port=38596 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qb33I-00FkzH-Gj; Tue, 29 Aug 2023 20:02:59 +0200
Date:   Tue, 29 Aug 2023 20:02:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [nf PATCH 2/2] netfilter: nf_tables: Audit log rule reset
Message-ID: <ZO4yz9ZgrgyzDIWs@calendula>
References: <20230829175158.20202-1-phil@nwl.cc>
 <20230829175158.20202-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230829175158.20202-2-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 29, 2023 at 07:51:58PM +0200, Phil Sutter wrote:
> Resetting rules' stateful data happens outside of the transaction logic,
> so 'get' and 'dump' handlers have to emit audit log entries themselves.
> 
> Cc: Richard Guy Briggs <rgb@redhat.com>
> Fixes: 8daa8fde3fc3f ("netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/linux/audit.h         |  1 +
>  kernel/auditsc.c              |  1 +
>  net/netfilter/nf_tables_api.c | 18 ++++++++++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 192bf03aacc52..51b1b7054a233 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -118,6 +118,7 @@ enum audit_nfcfgop {
>  	AUDIT_NFT_OP_FLOWTABLE_REGISTER,
>  	AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,
>  	AUDIT_NFT_OP_SETELEM_RESET,
> +	AUDIT_NFT_OP_RULE_RESET,
>  	AUDIT_NFT_OP_INVALID,
>  };
>  
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 38481e3181975..fc0c7c03eeabe 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -144,6 +144,7 @@ static const struct audit_nfcfgop_tab audit_nfcfgs[] = {
>  	{ AUDIT_NFT_OP_FLOWTABLE_REGISTER,	"nft_register_flowtable"   },
>  	{ AUDIT_NFT_OP_FLOWTABLE_UNREGISTER,	"nft_unregister_flowtable" },
>  	{ AUDIT_NFT_OP_SETELEM_RESET,		"nft_reset_setelem"        },
> +	{ AUDIT_NFT_OP_RULE_RESET,		"nft_reset_rule"           },
>  	{ AUDIT_NFT_OP_INVALID,			"nft_invalid"		   },
>  };
>  
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a1218ea4e0c3d..2aa7b9a55cca4 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -3432,6 +3432,18 @@ static void nf_tables_rule_notify(const struct nft_ctx *ctx,
>  	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
>  }
>  
> +static void audit_log_rule_reset(const struct nft_table *table,
> +				 unsigned int base_seq,
> +				 unsigned int nentries)
> +{
> +	char *buf = kasprintf(GFP_ATOMIC, "%s:%u",
> +			      table->name, base_seq);

No check for NULL.
