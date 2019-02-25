Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0AA0C10F00
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 15:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4D9520663
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 15:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i/WTl/+i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfBYP2X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 10:28:23 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41915 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfBYP2X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 10:28:23 -0500
Received: by mail-qt1-f196.google.com with SMTP id v10so10886987qtp.8;
        Mon, 25 Feb 2019 07:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sETiJ0Bam3ddJeRURAxkJZJKKX6x5tkCk2N7Yioi+Hs=;
        b=i/WTl/+iROAGW+Qnbj8A71foVtHtRdK9J8Z8hRR14kBOKR257UZt7CAVqgMLU30BbT
         SIAYaleECLRcwSXZ1wh4MAl1grAtXIhSk6hNE02tIarZwy9OIzd6w9undu2brcyR3s2N
         1BPqAtPG+DY6zT523buSrsL8Hun46gcWhd4Qb5G+w4SxcHzFJR+bQBlF8uRHV9xe1Hnk
         2IgTnfTdedl5+3lpm8sorgkvuqJ0CzdAym6nletAqpwDan32jG4KIyAgqemXtLE3eRyc
         NdnJHbJY1GyPlpxHqpbAfKX0x7fXKps3x6EgcuhE7UZp2nsozU78EQGihibiIvbc37JC
         DZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sETiJ0Bam3ddJeRURAxkJZJKKX6x5tkCk2N7Yioi+Hs=;
        b=gLGABGhRYQAqenXRE5loh1QCnFzjQiekCB8rDWcfmuuTjs43xSx2viinh0TWtc1Xqu
         Jc+vgqiPVXYDzYxV4JGYSrpd4wsjLCIPmS7N76LjjzHa4/XFDXkYAfM/PMMlIoVYQPwr
         po2+uzIIE3GiaHFR2tyNU0YoSxTu8biDXmlzxzSh0D6BkM4AS6ilFxWBBjOJeN3QlmAX
         9BT391At18y/qqN3UYb5/ckUNQKJOJ7CX/uZgsLbfh3npGLQAcCJsjIYkiYr41suCZA9
         NEjFxWteywrpX2SU9G1i/fYFCuKt2jN6ZcA3/zSNUqzg5/PFi+HNE09+gP3T/M7aDA48
         aywQ==
X-Gm-Message-State: AHQUAua5MDu7rPBYf77r5aQUMkMKPFm3ULQQGm28th7FpFZlpPrYW+Qp
        BGupM2IayYhdsJAxDxQasFw=
X-Google-Smtp-Source: AHgI3IbAqxlA/UgdLUzzdUGkzygOxRvgmXp+MIasn5nYIe9eXiU4X9Wg8xEGX8JCQ8qJB8KvOv/UNg==
X-Received: by 2002:ac8:3f98:: with SMTP id d24mr13913995qtk.219.1551108501878;
        Mon, 25 Feb 2019 07:28:21 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:ef72:88cc:5639:1ccc:5537])
        by smtp.gmail.com with ESMTPSA id n17sm3965113qke.89.2019.02.25.07.28.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Feb 2019 07:28:20 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 686EF180B5B; Mon, 25 Feb 2019 12:28:18 -0300 (-03)
Date:   Mon, 25 Feb 2019 12:28:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>, pablo@netfilter.org
Subject: Re: [PATCH net] ipvs: get sctphdr by sctphoff in sctp_csum_check
Message-ID: <20190225152818.GV13621@localhost.localdomain>
References: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 25, 2019 at 07:27:43PM +0800, Xin Long wrote:
> sctp_csum_check() is called by sctp_s/dnat_handler() where it calls
> skb_make_writable() to ensure sctphdr to be linearized.
> 
> So there's no need to get sctphdr by calling skb_header_pointer()
> in sctp_csum_check().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/netfilter/ipvs/ip_vs_proto_sctp.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> index b0cd7d0..0ecf241 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
> @@ -183,7 +183,7 @@ static int
>  sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
>  {
>  	unsigned int sctphoff;
> -	struct sctphdr *sh, _sctph;
> +	struct sctphdr *sh;
>  	__le32 cmp, val;
>  
>  #ifdef CONFIG_IP_VS_IPV6
> @@ -193,10 +193,7 @@ sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
>  #endif
>  		sctphoff = ip_hdrlen(skb);
>  
> -	sh = skb_header_pointer(skb, sctphoff, sizeof(_sctph), &_sctph);
> -	if (sh == NULL)
> -		return 0;
> -
> +	sh = (struct sctphdr *)(skb->data + sctphoff);
>  	cmp = sh->checksum;
>  	val = sctp_compute_cksum(skb, sctphoff);
>  
> -- 
> 2.1.0
> 
