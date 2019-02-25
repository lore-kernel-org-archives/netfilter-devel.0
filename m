Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7325EC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 03:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D9FE20684
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 03:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gjFx6C9N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbfBYDwr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Feb 2019 22:52:47 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44581 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbfBYDwr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Feb 2019 22:52:47 -0500
Received: by mail-pl1-f193.google.com with SMTP id c4so3804378pls.11
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Feb 2019 19:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=b2KzQA027euJRTNYdKDwAjlXCd2hZ9JTw4njLUsPgPA=;
        b=gjFx6C9NvIC7vG9nOwm/f9yPSGulWxGJME/BeALFB1DhPnApKxX+JQZI0tthLmVpLX
         MB2BvQP2GKh6INHqqllK+OWunmMLk6GhIvbbDNFz7e3t0dYhMrH+Jj8P+5Wm67opVnCB
         p5ugAhD7cFjXmjKVj0NkjhwDrMj+5XdKdmuKw+UXXiPEdFIKfH4zFsd24BtEJGih1Z6I
         QKeVvGS/SS5WOD7Z5KcfBSPfcRyIugy6f0VJ4eYdOQ5PNXKAZjlRs8pzJiE6TuXosgFP
         W2atRnXvR5h3T718UbRacEp8MvH5TvN8Dl18wzKaR00Ofo4r7y0TOdxeP/8okl3XxKBe
         vPYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2KzQA027euJRTNYdKDwAjlXCd2hZ9JTw4njLUsPgPA=;
        b=ngqAAnEFjdFX+rUv9gSIRjxnWIP82GypxCjXpkONBIl8Jt4v8E0X2A2ve8PVuqwzLE
         EL22+Q/EnIiXJDi6OefAEZLx7hStRe3w+OjONUHSlFqcpWET33GXN8rDoNbsldfaVA0x
         z6pO9+yKN03Cw0oHVReB4Uss+1jCQi1Pxj7gc2Isz/bUdnROyk93gudM0OUKByNTbbkp
         q+MKEHWnwA7YgM23GG9oo23r37bgtjKYqYmsUZKhtdfrUfWJR1UYJitydQrnzV2jP9n0
         CVfMlTIzUmcoJga4WqQJ6VKE/rSdjg9AFLppZlC7hHqfw3tV4gcLgGJ3heIhsR4P8U0L
         PIqA==
X-Gm-Message-State: AHQUAuah4I1faywuFADQKBAp1RQQnDevfmoHQ7qhVhb675m8+OezKxdp
        kpxZ39+arsL2oqwnCp6gamY0Bb2W
X-Google-Smtp-Source: AHgI3IZaunTA8CpLTmG41Mysi/1Qi7FxoUxfQ4f/Waj5YFdE3usw6+AluA44G7/4szKRSAmWy9D8FA==
X-Received: by 2002:a17:902:5a45:: with SMTP id f5mr1001219plm.78.1551066766796;
        Sun, 24 Feb 2019 19:52:46 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id v12sm4935930pfn.25.2019.02.24.19.52.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Feb 2019 19:52:45 -0800 (PST)
Subject: Re: [PATCH][nf-next] netfilter: Use RCU primitives under RCU
 protected data
To:     Li RongQing <lirongqing@baidu.com>, netfilter-devel@vger.kernel.org
References: <1551065562-26220-1-git-send-email-lirongqing@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2963a108-e8ae-e8d6-8e5a-d4605c432e72@gmail.com>
Date:   Sun, 24 Feb 2019 19:52:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1551065562-26220-1-git-send-email-lirongqing@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 02/24/2019 07:32 PM, Li RongQing wrote:
> This pointer is RCU protected, so proper primitives should be used.
> 
> Signed-off-by: Zhang Yu <zhangyu31@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  net/netfilter/xt_CT.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
> index 0fa863f57575..26dee8bba326 100644
> --- a/net/netfilter/xt_CT.c
> +++ b/net/netfilter/xt_CT.c
> @@ -99,7 +99,7 @@ xt_ct_set_helper(struct nf_conn *ct, const char *helper_name,
>  		return -ENOMEM;
>  	}
>  
> -	help->helper = helper;
> +	RCU_INIT_POINTER(help->helper, helper);
>  	return 0;
>  }
>  
> @@ -274,7 +274,7 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
>  err4:
>  	help = nfct_help(ct);
>  	if (help)
> -		nf_conntrack_helper_put(help->helper);
> +		nf_conntrack_helper_put(rcu_dereference(help->helper));

Are you sure it is ok, have you tested your patch ?

Where is the rcu_read_lock() ?

CONFIG_PROVE_RCU=y  will likely give a splat here.

>  err3:
>  	nf_ct_tmpl_free(ct);
>  err2:
> @@ -357,7 +357,7 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
>  	if (ct) {
>  		help = nfct_help(ct);
>  		if (help)
> -			nf_conntrack_helper_put(help->helper);
> +			nf_conntrack_helper_put(rcu_dereference(help->helper));

Same here.

>  
>  		nf_ct_netns_put(par->net, par->family);
>  
> 
