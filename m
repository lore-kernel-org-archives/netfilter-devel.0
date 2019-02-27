Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AF6C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 12:21:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 986112087C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 12:21:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="i7HxWrs/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfB0MVy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:21:54 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:53139 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfB0MVx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 07:21:53 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 9079025B7D6;
        Wed, 27 Feb 2019 23:21:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1551270111; bh=k4Jct6wgvMYe9zV25vm7YZQRUVngJ7Ep4cIrOv7KXEA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7HxWrs/Nz2Yb3xML5BBs/PZx/GvLjtxk7kPlU3k4whrvdIWfAo1XGuVFXcqurR/8
         c5fVbN/drrcZe4Hlai3ZBvytMstx0BkV2PnNfg2dECTn92hzxGPQS2/gYSrCGSSstY
         Ev7L5XXnDFvbl57iFVDiWGtCKUcU/TLWkT2XBOro=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 035C89402DD; Wed, 27 Feb 2019 13:21:49 +0100 (CET)
Date:   Wed, 27 Feb 2019 13:21:49 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, pablo@netfilter.org
Subject: Re: [PATCH net] ipvs: get sctphdr by sctphoff in sctp_csum_check
Message-ID: <20190227122149.ip2x4ki65utadbzz@verge.net.au>
References: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
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

Acked-by: Simon Horman <horms@verge.net.au>

Pablo,

please consider applying this to nf-next.

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
