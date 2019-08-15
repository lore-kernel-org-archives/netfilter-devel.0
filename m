Return-Path: <SRS0=UCCN=WL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CA2C31E40
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 07:03:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EDDC2084D
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Aug 2019 07:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbfHOHDC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Aug 2019 03:03:02 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:45285 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbfHOHDC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Aug 2019 03:03:02 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Aug 2019 03:03:01 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave02.hostedemail.com (Postfix) with ESMTP id 1F38418019A2E
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2019 06:56:22 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 381FB8368EFC;
        Thu, 15 Aug 2019 06:56:20 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: shirt04_19e6b128f1714
X-Filterd-Recvd-Size: 3207
Received: from XPS-9350.home (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Thu, 15 Aug 2019 06:56:17 +0000 (UTC)
Message-ID: <9973b4a89e54296a6a033c790fc0837397a14a5d.camel@perches.com>
Subject: Re: [PATCH] netfilter: nft_bitwise: Adjust parentheses to fix
 memcmp size argument
From:   Joe Perches <joe@perches.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        kbuild test robot <lkp@intel.com>
Date:   Wed, 14 Aug 2019 23:56:16 -0700
In-Reply-To: <20190814165809.46421-1-natechancellor@gmail.com>
References: <20190814165809.46421-1-natechancellor@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2019-08-14 at 09:58 -0700, Nathan Chancellor wrote:
> clang warns:
> 
> net/netfilter/nft_bitwise.c:138:50: error: size argument in 'memcmp'
> call is a comparison [-Werror,-Wmemsize-comparison]
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ~~~~~~~~~~~~~~~~~~^~
> net/netfilter/nft_bitwise.c:138:6: note: did you mean to compare the
> result of 'memcmp' instead?
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>             ^
>                                                        )
> net/netfilter/nft_bitwise.c:138:32: note: explicitly cast the argument
> to size_t to silence this warning
>         if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
>                                       ^
>                                       (size_t)(
> 1 error generated.
> 
> Adjust the parentheses so that the result of the sizeof is used for the
> size argument in memcmp, rather than the result of the comparison (which
> would always be true because sizeof is a non-zero number).
> 
> Fixes: bd8699e9e292 ("netfilter: nft_bitwise: add offload support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/638
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  net/netfilter/nft_bitwise.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
[]
> @@ -135,8 +135,8 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
>  {
>  	const struct nft_bitwise *priv = nft_expr_priv(expr);
>  
> -	if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
> -	    priv->sreg != priv->dreg))
> +	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
> +	    priv->sreg != priv->dreg)

This code should use memchr_inv and not compare against a
static uninitialized struct.

Perhaps linux should introduce and use memcchr like bsd. 
or just add something like #define memcchr memchr_inv




