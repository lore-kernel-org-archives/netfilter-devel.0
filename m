Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67343C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 21:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4306020674
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 21:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfKLVpX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 16:45:23 -0500
Received: from correo.us.es ([193.147.175.20]:40944 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbfKLVpW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 16:45:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DCB7BE123A
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 22:45:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D066C8012A
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2019 22:45:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C5359CF8A2; Tue, 12 Nov 2019 22:45:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB9A1D2B1E;
        Tue, 12 Nov 2019 22:45:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Nov 2019 22:45:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B87384251480;
        Tue, 12 Nov 2019 22:45:16 +0100 (CET)
Date:   Tue, 12 Nov 2019 22:45:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject set references in mapping LHS
Message-ID: <20191112214518.tsevqoqtm5ubov3p@salvia>
References: <20191031182124.11393-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031182124.11393-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 31, 2019 at 07:21:24PM +0100, Phil Sutter wrote:
> This wasn't explicitly caught before causing a program abort:
> 
> | BUG: invalid range expression type set reference
> | nft: expression.c:1162: range_expr_value_low: Assertion `0' failed.
> | zsh: abort      sudo ./install/sbin/nft add rule t c meta mark set tcp dport map '{ @s : 23 }
> 
> With this patch in place, the error message is way more descriptive:
> 
> | Error: Key can't be set reference
> | add rule t c meta mark set tcp dport map { @s : 23 }
> |                                            ^^

I wanted to check why the parser allow for this...

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/evaluate.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 81230fc7f4be4..500780aeae243 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1456,6 +1456,10 @@ static int expr_evaluate_mapping(struct eval_ctx *ctx, struct expr **expr)
>  	if (!expr_is_constant(mapping->left))
>  		return expr_error(ctx->msgs, mapping->left,
>  				  "Key must be a constant");
> +	if (mapping->left->etype == EXPR_SET_ELEM &&
> +	    mapping->left->key->etype == EXPR_SET_REF)
> +		return expr_error(ctx->msgs, mapping->left,
> +				  "Key can't be set reference");
>  	mapping->flags |= mapping->left->flags & EXPR_F_SINGLETON;
>  
>  	expr_set_context(&ctx->ectx, set->datatype, set->datalen);
> -- 
> 2.23.0
> 
