Return-Path: <SRS0=MMpb=TO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766E2C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 15:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 460622086A
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 May 2019 15:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="KKZQoLUe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfENPn1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 May 2019 11:43:27 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46932 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725901AbfENPn1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 May 2019 11:43:27 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id C81E71A30E3;
        Tue, 14 May 2019 08:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1557848606; bh=ZByWJgfkduoXpEStyr39SCNn/qU+xF3omrwaDv9rHhM=;
        h=Subject:To:References:From:Cc:Date:In-Reply-To:From;
        b=KKZQoLUeeJTwu/VpZQAfPK5+xs+Aj5ZZTxWG64doQdo6oT+9O2c5+Cy8sLIRYozm6
         Q95KbvFQ+22UYBOTk1sDs56k6FSc+la6N/CThY8xcYrXIAjg8jL9Y2i7eNx0MjrJCT
         cTZJj0f9Ug3bT+WdP/hxOp1SgHZwWPpU10toJWwk=
X-Riseup-User-ID: EADBC0249480CFB3FBB22282C2DC770D50C8F8563093F36E5D8D0B723DE88BE7
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 28F26221D08;
        Tue, 14 May 2019 08:43:25 -0700 (PDT)
Subject: Re: [PATCH 2/2 nft WIP v2] jump: Allow jump to a variable when using
 nft input files
To:     netfilter-devel@vger.kernel.org
References: <20190514152542.23406-1-ffmancera@riseup.net>
 <20190514152542.23406-2-ffmancera@riseup.net>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Message-ID: <1772a0cf-6cd0-171f-8db0-038cd823ac9c@riseup.net>
Date:   Tue, 14 May 2019 17:43:39 +0200
MIME-Version: 1.0
In-Reply-To: <20190514152542.23406-2-ffmancera@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This last patch does not work. The first one works fine with a string as
chain name.

# nft add table ip foo
# nft add chain ip foo bar {type filter hook input priority 0\;}
# nft add chain ip foo ber
# nft add rule ip foo ber counter
# nft add rule ip foo bar jump ber
# nft list ruleset

table ip foo {
	chain bar {
		type filter hook input priority filter; policy accept;
		jump ber
	}

	chain ber {
		counter packets 69 bytes 6138
	}
}

But when trying to execute "# nft -f file.nft", being file.nft:

> define dest = ber
> add rule ip foo bar jump $dest

I am getting the following error:

file.nft:3:26-30: Error: Can't parse symbolic netfilter verdict expressions
add rule ip foo bar jump $dest
			 ^^^^^
This error comes from symbol_parse() at expr_evaluate_symbol() after the
expr_evaluate() call added in the first patch.

On 5/14/19 5:25 PM, Fernando Fernandez Mancera wrote:
> This patch introduces the use of nft input files variables in 'jump'
> statements, e.g.
> 
> define dest = chainame
> 
> add rule ip filter input jump $dest
> 
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  src/parser_bison.y | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 69b5773..42fd71f 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -3841,7 +3841,13 @@ verdict_expr		:	ACCEPT
>  			}
>  			;
>  
> -chain_expr		:	identifier
> +chain_expr		:	variable_expr
> +			{
> +				$$ = symbol_expr_alloc(&@$, SYMBOL_VALUE,
> +						       current_scope(state),
> +						       $1->sym->identifier);
> +			}
> +			|	identifier
>  			{
>  				$$ = constant_expr_alloc(&@$, &string_type,
>  							 BYTEORDER_HOST_ENDIAN,
> 
