Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB4AC49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 07:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EA62206A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 07:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="pZY/NBXt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbfIPHlK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 03:41:10 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46294 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfIPHlK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 03:41:10 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id A73451B9428;
        Mon, 16 Sep 2019 00:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1568619668; bh=J3DK3FmMv4RTg6s4txbfkUd6tCNhPQM1YJHhLLmnCT0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=pZY/NBXtlO6GtR/msSXtmeF3TSSLmNXhSoapkfU5nSJ0hEZLj5w+f15uIgQVeVG6Y
         xnDTYRdhJPcQmVnAxMPjdEXtMGB/qTIHuUbNLwqUa9TEpbBnmQ3K2di4EI8B2a6Wpj
         cydrITKNyC07gk82H1Nsj3MhsBtYdQvruFXp+EQw=
X-Riseup-User-ID: 56D3776CEBE81EED4DD21F570F85576C8C2BF47A1AB31DC0DF51C58C0B6CC90B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 918642232B9;
        Mon, 16 Sep 2019 00:41:07 -0700 (PDT)
Subject: Re: [PATCH] nftables: don't crash in 'list ruleset' if policy is not
 set
To:     Sergei Trofimovich <slyfox@gentoo.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20190916073320.2799091-1-slyfox@gentoo.org>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <801524a6-86ce-620b-f06e-9792a37786cb@riseup.net>
Date:   Mon, 16 Sep 2019 09:41:19 +0200
MIME-Version: 1.0
In-Reply-To: <20190916073320.2799091-1-slyfox@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Sergei,

On 9/16/19 9:33 AM, Sergei Trofimovich wrote:
> Minimal reproducer:
> 
> ```
>   $ cat nft.ruleset
>     # filters
>     table inet filter {
>         chain prerouting {
>             type filter hook prerouting priority -50
>         }
>     }
> 
>     # dump new state
>     list ruleset
> 
>   $ nft -c -f ./nft.ruleset
>     table inet filter {
>     chain prerouting {
>     Segmentation fault (core dumped)
> ```
> 
> The crash happens in `chain_print_declaration()`:
> 
> ```
>     if (chain->flags & CHAIN_F_BASECHAIN) {
>         mpz_export_data(&policy, chain->policy->value,
>                         BYTEORDER_HOST_ENDIAN, sizeof(int));
> ```
> 
> Here `chain->policy` is `NULL` (as textual rule does not mention it).
> 
> The change is not to print the policy if it's not set
> (similar to `chain_evaluate()` handling).

Thanks for fixing that. Sorry I missed that we could have a base chain
without policy.

Acked-by: Fernando Fernandez Mancera <ffmancera@riseup.net>

> CC: Florian Westphal <fw@strlen.de>
> CC: Pablo Neira Ayuso <pablo@netfilter.org>
> CC: netfilter-devel@vger.kernel.org
> Bug: https://bugzilla.netfilter.org/show_bug.cgi?id=1365
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  src/rule.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 5bb1c1d3..0cc1fa59 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1107,17 +1107,21 @@ static void chain_print_declaration(const struct chain *chain,
>  		nft_print(octx, " # handle %" PRIu64, chain->handle.handle.id);
>  	nft_print(octx, "\n");
>  	if (chain->flags & CHAIN_F_BASECHAIN) {
> -		mpz_export_data(&policy, chain->policy->value,
> -				BYTEORDER_HOST_ENDIAN, sizeof(int));
>  		nft_print(octx, "\t\ttype %s hook %s", chain->type,
>  			  hooknum2str(chain->handle.family, chain->hooknum));
>  		if (chain->dev != NULL)
>  			nft_print(octx, " device \"%s\"", chain->dev);
> -		nft_print(octx, " priority %s; policy %s;\n",
> +		nft_print(octx, " priority %s;",
>  			  prio2str(octx, priobuf, sizeof(priobuf),
>  				   chain->handle.family, chain->hooknum,
> -				   chain->priority.expr),
> -			  chain_policy2str(policy));
> +				   chain->priority.expr));
> +		if (chain->policy) {
> +			mpz_export_data(&policy, chain->policy->value,
> +					BYTEORDER_HOST_ENDIAN, sizeof(int));
> +			nft_print(octx, " policy %s;",
> +				  chain_policy2str(policy));
> +		}
> +		nft_print(octx, "\n");
>  	}
>  }
>  
> 
