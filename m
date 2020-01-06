Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D36C32771
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 09:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24EA32072C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 09:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgAFJ2q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 04:28:46 -0500
Received: from correo.us.es ([193.147.175.20]:51868 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbgAFJ2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 04:28:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC0D1EB903
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 10:28:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DC1ADA70E
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 10:28:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 937A7DA702; Mon,  6 Jan 2020 10:28:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6A2ACDA702;
        Mon,  6 Jan 2020 10:28:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 10:28:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4D69C424EECB;
        Mon,  6 Jan 2020 10:28:42 +0100 (CET)
Date:   Mon, 6 Jan 2020 10:28:42 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2] evaluate: fix expr_set_context call for shift
 binops.
Message-ID: <20200106092842.tp2pxubgmfcptthq@salvia>
References: <20191220190215.1743199-1-jeremy@azazel.net>
 <20191224231428.1972155-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191224231428.1972155-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Tue, Dec 24, 2019 at 11:14:28PM +0000, Jeremy Sowden wrote:
> expr_evaluate_binop calls expr_set_context for shift expressions to set
> the context data-type to `integer`.  This clobbers the byte-order of the
> context, resulting in unexpected conversions to NBO.  For example:
> 
>   $ sudo nft flush ruleset
>   $ sudo nft add table t
>   $ sudo nft add chain t c '{ type filter hook output priority mangle; }'
>   $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0x10 | 0xe'
>   $ sudo nft add rule t c oif lo tcp dport ssh ct mark set '0xf << 1'
>   $ sudo nft list table t
>   table ip t {
>           chain c {
>                   type filter hook output priority mangle; policy accept;
>                   oif "lo" tcp dport 22 ct mark set 0x0000001e
>                   oif "lo" tcp dport 22 ct mark set 0x1e000000
>           }
>   }
> 
> Replace it with a call to __expr_set_context in order to preserve host
> endianness.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/evaluate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Change-log:
> 
>   In v1, I just dropped the expr_set_context call; however, it is needed
>   to ensure that the right operand has integer type.  Instead, I now
>   change it to __expr_set_context in order to ensure that the byte-order
>   is correct.
> 
> diff --git a/src/evaluate.c b/src/evaluate.c
> index a865902c0fc7..43637e1cf6c8 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -1145,7 +1145,8 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
>  	left = op->left;
>  
>  	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
> -		expr_set_context(&ctx->ectx, &integer_type, ctx->ectx.len);
> +		__expr_set_context(&ctx->ectx, &integer_type,
> +				   BYTEORDER_HOST_ENDIAN, ctx->ectx.len, 0);

tests/py spews a few warnings after this patch.
