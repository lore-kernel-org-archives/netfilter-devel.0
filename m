Return-Path: <SRS0=T6Q7=W3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E43C3A59F
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 10:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36D4621670
	for <netfilter-devel@archiver.kernel.org>; Sat, 31 Aug 2019 10:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="FCIVxEX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfHaKSF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 31 Aug 2019 06:18:05 -0400
Received: from mx1.riseup.net ([198.252.153.129]:37888 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbfHaKSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 31 Aug 2019 06:18:04 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 05D3E1A0D1A;
        Sat, 31 Aug 2019 03:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1567246684; bh=jJ/yGdUgQpjIskdF1jY8iTn5E1p3+EP6AHfl8lb+wyA=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=FCIVxEX8jBhIXklitSSMryudK1I9KD69S+efbMeXNNosICs26YqzbMVuDPENsz9Ud
         VpGgFx7Alr6NNOa1cS8KTZUAFvqLp/+zrpaDXzWZxOdwZxi5Xs5Vk12hMzfcONFz6S
         pPvLp+URF1kB37hCB10pgCZUScumZ/T4aTWGB+RE=
X-Riseup-User-ID: 619406953931D9CE6BEF9B18D5C17E998AAAD6978C205BE165B60A42586FBEE2
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id A034922328F;
        Sat, 31 Aug 2019 03:18:00 -0700 (PDT)
Subject: Re: [PATCH nf-next] netfilter: nft_socket: fix erroneous socket
 assignment
To:     netfilter-devel@vger.kernel.org
References: <20190831101453.1869-1-ffmancera@riseup.net>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <ad7f9540-4e32-a506-4477-844e7c049c3f@riseup.net>
Date:   Sat, 31 Aug 2019 12:18:14 +0200
MIME-Version: 1.0
In-Reply-To: <20190831101453.1869-1-ffmancera@riseup.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch fixes https://bugzilla.redhat.com/show_bug.cgi?id=1651813. I
didn't include this link into the commit message because I don't know if
it is appropiate. Thanks! :-)

On 8/31/19 12:14 PM, Fernando Fernandez Mancera wrote:
> This socket assignment was unnecessary and also added a missing sock_gen_put().
> 
> Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
> ---
>  net/netfilter/nft_socket.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
> index d7f3776dfd71..637ce3e8c575 100644
> --- a/net/netfilter/nft_socket.c
> +++ b/net/netfilter/nft_socket.c
> @@ -47,9 +47,6 @@ static void nft_socket_eval(const struct nft_expr *expr,
>  		return;
>  	}
>  
> -	/* So that subsequent socket matching not to require other lookups. */
> -	skb->sk = sk;
> -
>  	switch(priv->key) {
>  	case NFT_SOCKET_TRANSPARENT:
>  		nft_reg_store8(dest, inet_sk_transparent(sk));
> @@ -66,6 +63,9 @@ static void nft_socket_eval(const struct nft_expr *expr,
>  		WARN_ON(1);
>  		regs->verdict.code = NFT_BREAK;
>  	}
> +
> +	if (sk != skb->sk)
> +		sock_gen_put(sk);
>  }
>  
>  static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
> 
