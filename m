Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351CFC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 10:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346245AbjKBKQl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 06:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbjKBKQk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 06:16:40 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F47131
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 03:16:34 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-53e2dc8fa02so1190523a12.2
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2023 03:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698920193; x=1699524993; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=02xkZqOKKz9d+moFfG7ERv43EDw24szAgy8uy4/RXNc=;
        b=Dsc6HVVl0B5n+tG36McAUl9jsQbCec3w4zgQobK2LkQS+8NYuc8Dk3PhhVrYi0HSCS
         98ha4aiSpab1vlIouEGstnJiTkUb0ObG+5b7TsuWsNwH3iMscOESBIeAIobPdHU6C52j
         lPRynfl0kc9on886tJNG0yc68UXR8VE8D6Sezjbfvk+tzKs+xAyS5xdXQg/Slo5cTaXb
         ynqyZ4tvid7jYFkBE6ifqZ3UgeYQuPLPx5iSeY54KE7PU7ydg+A41audtycFah+UUd9C
         0gzzP4bFaTOG5U3yvHoOuj+bfYWtf60mq9c/DaXrkCORbvZPdzcjYb2pZn5pi+oLbWcc
         AD+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698920193; x=1699524993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=02xkZqOKKz9d+moFfG7ERv43EDw24szAgy8uy4/RXNc=;
        b=jFkxfcdOblIJhgsCQPORtWAKpE8nJdGzLWfGdX/bfbdQ+T65ZV1OZlAVdL/wu087Bn
         neDoZMxQMaAyGCRvMJIpJnX03cyjYMQzLpi6X9qDoYLNCwS+Sj8ZRalULp8hkOrxtHDA
         3qdxLh1iuYyQ3Cr1fSFrGuff3KaQztFFsFKW/d9F1nLkcIqS2gq+PV+P3gUA3xrrbd3v
         4EqsA1zTPlGJX5eJOk7SNoHTo0vahHWiUFqJF21ykKljTntM5u8+1X83bFajhnv9u//t
         SPUWAXJOO/1o59wie2NUU6RP/dW4e4bq3FbAyn+V3vx3+TIsKAGe1r3z+TBrXaSkDaWw
         bz2g==
X-Gm-Message-State: AOJu0YzDy5nhS61So2ekcFkQaJE+1XCajSvGTtng7amfR1zk7eNT6jbG
        Q2uzVdBqp7Ako3y6zD7A5ruwzw==
X-Google-Smtp-Source: AGHT+IGAIpKlpb139ceS6EcClNVt5Z+NaIbDHk76iPL/T7wUBC0B/lAuYL7CQFzy391iCAo+wQDcCA==
X-Received: by 2002:a50:9544:0:b0:543:595a:8280 with SMTP id v4-20020a509544000000b00543595a8280mr7273567eda.37.1698920193032;
        Thu, 02 Nov 2023 03:16:33 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id u22-20020aa7d896000000b0054354da96e5sm2146543edq.55.2023.11.02.03.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 03:16:32 -0700 (PDT)
Date:   Thu, 2 Nov 2023 13:16:28 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Harshit Mogalapalli <harshit.m.mogalapalli@gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <d7e42ffd-aabf-46d7-b02a-a7337708a29a@moroto.mountain>
References: <20230705201232.GG3751@breakpoint.cc>
 <20230705210535.943194-1-cascardo@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705210535.943194-1-cascardo@canonical.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 05, 2023 at 06:05:35PM -0300, Thadeu Lima de Souza Cascardo wrote:
> diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
> index 9a85e797ed58..e596d1a842f7 100644
> --- a/net/netfilter/nft_byteorder.c
> +++ b/net/netfilter/nft_byteorder.c
> @@ -30,11 +30,11 @@ void nft_byteorder_eval(const struct nft_expr *expr,
>  	const struct nft_byteorder *priv = nft_expr_priv(expr);
>  	u32 *src = &regs->data[priv->sreg];
>  	u32 *dst = &regs->data[priv->dreg];
> -	union { u32 u32; u16 u16; } *s, *d;
> +	u16 *s16, *d16;
>  	unsigned int i;
>  
> -	s = (void *)src;
> -	d = (void *)dst;
> +	s16 = (void *)src;
> +	d16 = (void *)dst;
>  
>  	switch (priv->size) {
>  	case 8: {

This patch is correct, but shouldn't we fix the code for 64 bit writes
as well?

net/netfilter/nft_byteorder.c
    26  void nft_byteorder_eval(const struct nft_expr *expr,
    27                          struct nft_regs *regs,
    28                          const struct nft_pktinfo *pkt)
    29  {
    30          const struct nft_byteorder *priv = nft_expr_priv(expr);
    31          u32 *src = &regs->data[priv->sreg];
    32          u32 *dst = &regs->data[priv->dreg];
    33          u16 *s16, *d16;
    34          unsigned int i;
    35  
    36          s16 = (void *)src;
    37          d16 = (void *)dst;
    38  
    39          switch (priv->size) {
    40          case 8: {
    41                  u64 src64;
    42  
    43                  switch (priv->op) {
    44                  case NFT_BYTEORDER_NTOH:
    45                          for (i = 0; i < priv->len / 8; i++) {
    46                                  src64 = nft_reg_load64(&src[i]);
    47                                  nft_reg_store64(&dst[i],
    48                                                  be64_to_cpu((__force __be64)src64));

We're writing 8 bytes, then moving forward 4 bytes and writing 8 bytes
again.  Each subsequent write over-writes 4 bytes from the previous
write.

    49                          }
    50                          break;
    51                  case NFT_BYTEORDER_HTON:
    52                          for (i = 0; i < priv->len / 8; i++) {
    53                                  src64 = (__force __u64)
    54                                          cpu_to_be64(nft_reg_load64(&src[i]));
    55                                  nft_reg_store64(&dst[i], src64);

Same.

    56                          }
    57                          break;
    58                  }
    59                  break;
    60          }
    61          case 4:
    62                  switch (priv->op) {
    63                  case NFT_BYTEORDER_NTOH:
    64                          for (i = 0; i < priv->len / 4; i++)
    65                                  dst[i] = ntohl((__force __be32)src[i]);
    66                          break;
    67                  case NFT_BYTEORDER_HTON:

regards,
dan carpenter

