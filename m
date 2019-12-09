Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 261A3C43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 20:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E24802073D
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 20:03:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="HITeT3Yy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfLIUDW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 15:03:22 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45304 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfLIUDW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 15:03:22 -0500
Received: by mail-qk1-f195.google.com with SMTP id x1so14198100qkl.12
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Dec 2019 12:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GDUYUeBUbCRk5D6c/V5R/L+ljtI8qLNEf77mvyj/88c=;
        b=HITeT3Yy7URqczK7aKeGgL2+2uK4OmeOWTuQCmoVEv9f7YGigdozAHsdgsgv/XW54y
         W9bvk4mT1ub8Y3GFzLKmr7Daq/zDRggB98gvWubNe8lWR8JJBTM4g6pFLMrP3+nrm/NF
         X95IsUy8F0mtcCIJRkmMnHkiOll/mO35vcUGl8vWDgceNiNUmdVE63MgkGmz6zEpi8m8
         8VjAojj+l2kv5nMfxFQSc9Ox+RKuzdLXE8KsErS1sYJZdTEELsql0GC8nKc1Nd96WfqE
         +71OisRabQOTOtsb2gxx2DyzuKx2m0i9kMHV0zfHGhQxTKxTwWdXXvleWy/MdjUx21lW
         7WZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GDUYUeBUbCRk5D6c/V5R/L+ljtI8qLNEf77mvyj/88c=;
        b=aKcxx5bFojtEFWAJGPySfce0oLB+YFimu+BrKaC0A5ztWdB29F2rW+sJZVha0broO8
         cEI0NOL334vGUeglNo9/ZH7LOZo40Unr3Lh3rx04VhTFaDPmcuSErAPde0Qps4h+rycf
         Mq5xYbMUoiWmZXT+4uYimY2uK2wctwubCkVI3htIJUj76l9UHNZGCcbhkTLNx8ZerjxS
         JH4XBQzD5sj1Q4u0LtAoF3N02c27013TBy5VC4RF7/7Vs8stLXWpnYoSKARVeOpHeLAb
         mmbowcF8F0tBrCWDVP4fGNFZi43wT6nmLCDt6spGd/cbBIvK23q5K+gUtyMbDF0TeHwn
         RCOQ==
X-Gm-Message-State: APjAAAUrv5Blm+HfZQFX5EKFo5/0raZUsHGbsVL4zkW1VhJwDURVjXE8
        mi+K86Yu3rEOzBPDo+7F9kLR3Q==
X-Google-Smtp-Source: APXvYqxUdfacWJJq3CkJ5nuf6con2/1CclwH5aUJ2zuvDPb4Tye09yHCPNqViUdNW+6fRMhQhgOChg==
X-Received: by 2002:a37:6294:: with SMTP id w142mr1594816qkb.284.1575921801371;
        Mon, 09 Dec 2019 12:03:21 -0800 (PST)
Received: from netronome.com (209-213-91-242.bos.ma.meganet.net. [209.213.91.242])
        by smtp.gmail.com with ESMTPSA id z4sm175279qkz.62.2019.12.09.12.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 12:03:20 -0800 (PST)
Date:   Mon, 9 Dec 2019 15:03:19 -0500
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
Message-ID: <20191209200317.GA10466@netronome.com>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Xin,

On Sun, Dec 08, 2019 at 12:41:31PM +0800, Xin Long wrote:
> To keep consistent with ipgre_policy, it's better to parse
> ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
> cls_flower and ip_tunnel_core.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/netfilter/nft_tunnel.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> index 3d4c2ae..f76cd7d 100644
> --- a/net/netfilter/nft_tunnel.c
> +++ b/net/netfilter/nft_tunnel.c
> @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
>  }
>  
>  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> +	[NFTA_TUNNEL_KEY_ERSPAN_VERSION]	= { .type = NLA_U8 },
>  	[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]	= { .type = NLA_U32 },
> -	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]	= { .type = NLA_U8 },
> +	[NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]		= { .type = NLA_U8 },
>  	[NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]	= { .type = NLA_U8 },
>  };
>  
> @@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
>  	if (err < 0)
>  		return err;
>  
> -	version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
> +	version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);

I have concerns about this change and backwards-compatibility with existing
users of this UAPI. Likewise, with other changes to the encoding of existing
attributes elsewhere in this series.

>  	switch (version) {
>  	case ERSPAN_VERSION:
>  		if (!tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX])
> -- 
> 2.1.0
> 
