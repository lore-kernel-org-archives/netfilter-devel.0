Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24186C77B61
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Apr 2023 10:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjDMKgn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Apr 2023 06:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDMKgm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2023 06:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694052D73
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 03:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681382152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=itT3WRdataR3mc3HSH4d4WnSN/G47tLHOz7nmNIZqZs=;
        b=P0SWOin8MlxCdftZ1GghHkGEz/iKsW8bnhAC/pzBAb2wAaoEEuB4hq6yi6UJLmEevpHe4V
        VyIFDl2JATCfc8wZzGgoZ9/pLlag95J+pXYqMm4tbAm328Serh28W7BEJLxfxDaRjFFHYQ
        bqOiHTrjuqhuuwDZfNMOtR8DZqLF0+Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-Xw7EUGPxMJeg50BUNSSkgQ-1; Thu, 13 Apr 2023 06:35:51 -0400
X-MC-Unique: Xw7EUGPxMJeg50BUNSSkgQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-505149e1a4eso2715599a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2023 03:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681382149; x=1683974149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itT3WRdataR3mc3HSH4d4WnSN/G47tLHOz7nmNIZqZs=;
        b=ZoSznRCIcnK8P2N7b9Hhs4j3bTZcSaYNdCCZLcrD9gy0jSDuEOt4enaIR2vArryAyM
         fo2qjJ7REvdKNC8/LFEZbLYm2t42/FY5m5ArB6yBxxHAdCXm3M+Zo/j5m/B1SOHHB5Dj
         rMSykPfhjIiyGJaAztJ7rfKWZji7BVy8AjjDwKsrn61LPrnjVwAYc9w179gU7Ug5qVzk
         xSLZCtExwcnW2fqYOtQynRrWxjwhPmushkNeW5ZejghDowWesagIYJuK98wm7+35pEpl
         yRt+75jm21thBOi6DMJig1sy/ZzaxZ4H4Y83z3s/UsyGNpCx15x179LiO+K/6CLhdN0G
         +5vA==
X-Gm-Message-State: AAQBX9ftQQOUEs7CubafT+BboLdF4/QUppV4UDtWPzD2ep8J5TsTqXy9
        JdRkV5/ZrEEyMM41H3biDKe3VDWbKsYjnmBdVkgQ7vnuW2sYQzQkq4wajHYrs/WEN5MLGRwyfZZ
        pt7X1sC8CTE7nSRHZbIkoFf7Msg14
X-Received: by 2002:a05:6402:1804:b0:505:43e9:6ff7 with SMTP id g4-20020a056402180400b0050543e96ff7mr1397632edy.7.1681382148838;
        Thu, 13 Apr 2023 03:35:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvapUCs5yvALVfiM8gaOeYsZIZZa+WkvEHbTKA39JH/fvn1Hiiib2L0yY3rVUMuVDAMmZp6Q==
X-Received: by 2002:a05:6402:1804:b0:505:43e9:6ff7 with SMTP id g4-20020a056402180400b0050543e96ff7mr1397609edy.7.1681382148525;
        Thu, 13 Apr 2023 03:35:48 -0700 (PDT)
Received: from localhost ([37.160.12.137])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402044400b00501c96564b5sm641951edw.93.2023.04.13.03.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 03:35:48 -0700 (PDT)
Date:   Thu, 13 Apr 2023 12:35:43 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     abhijeet.1989@gmail.com
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
Message-ID: <ZDfa/wuJTp8vk+wI@renaissance-vector>
References: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 12, 2023 at 01:49:08PM -0700, Abhijeet Rastogi via B4 Relay wrote:
> From: Abhijeet Rastogi <abhijeet.1989@gmail.com>
> 
> Current range [8, 20] is set purely due to historical reasons
> because at the time, ~1M (2^20) was considered sufficient.
> 
> Previous change regarding this limit is here.
> 
> Link: https://lore.kernel.org/all/86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com/T/#u
> 
> Signed-off-by: Abhijeet Rastogi <abhijeet.1989@gmail.com>
> ---
> The conversation for this started at: 
> 
> https://www.spinics.net/lists/netfilter/msg60995.html
> 
> The upper limit for algo is any bit size less than 32, so this
> change will allow us to set bit size > 20. Today, it is common to have
> RAM available to handle greater than 2^20 connections per-host.
> 
> Distros like RHEL already have higher limits set.

Hi Abhijeet,
for the record, RHEL ships with CONFIG_IP_VS_TAB_BITS set to 12 as
default.

> ---
>  net/netfilter/ipvs/Kconfig      | 4 ++--
>  net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
> index 271da8447b29..3e3371f8c0f9 100644
> --- a/net/netfilter/ipvs/Kconfig
> +++ b/net/netfilter/ipvs/Kconfig
> @@ -44,7 +44,7 @@ config	IP_VS_DEBUG
>  
>  config	IP_VS_TAB_BITS
>  	int "IPVS connection table size (the Nth power of 2)"
> -	range 8 20
> +	range 8 31
>  	default 12
>  	help
>  	  The IPVS connection hash table uses the chaining scheme to handle
> @@ -54,7 +54,7 @@ config	IP_VS_TAB_BITS
>  
>  	  Note the table size must be power of 2. The table size will be the
>  	  value of 2 to the your input number power. The number to choose is
> -	  from 8 to 20, the default number is 12, which means the table size
> +	  from 8 to 31, the default number is 12, which means the table size
>  	  is 4096. Don't input the number too small, otherwise you will lose
>  	  performance on it. You can adapt the table size yourself, according
>  	  to your virtual server application. It is good to set the table size
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 13534e02346c..bc0fe1a698d4 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1484,8 +1484,8 @@ int __init ip_vs_conn_init(void)
>  	int idx;
>  
>  	/* Compute size and mask */
> -	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
> -		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
> +	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 31) {
> +		pr_info("conn_tab_bits not in [8, 31]. Using default value\n");
>  		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
>  	}
>  	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
> 
> ---
> base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
> change-id: 20230412-increase_ipvs_conn_tab_bits-4322c90da216
> 
> Best regards,
> -- 
> Abhijeet Rastogi <abhijeet.1989@gmail.com>
>

Looks good to me.

Reviewed-by: Andrea Claudi <aclaudi@redhat.com>

