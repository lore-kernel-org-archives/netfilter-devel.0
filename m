From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf 1/1] netfilter: xt_CT: Fix one possible memleak of timeout
Date: Thu, 6 Apr 2017 19:21:32 +0800
Message-ID: <006401d2aec7$f284cc80$d78e6580$@foxmail.com>
References: <1491476698-45220-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <gfree.wind@foxmail.com>, <pablo@netfilter.org>,
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg202.qq.com ([184.105.206.29]:37869 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751415AbdDFLVf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 07:21:35 -0400
In-Reply-To: <1491476698-45220-1-git-send-email-gfree.wind@foxmail.com>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

> -----Original Message-----
> From: gfree.wind@foxmail.com [mailto:gfree.wind@foxmail.com]
> Sent: Thursday, April 6, 2017 7:05 PM
> To: pablo@netfilter.org; netfilter-devel@vger.kernel.org
> Cc: Gao Feng <fgao@ikuai8.com>
> Subject: [PATCH nf 1/1] netfilter: xt_CT: Fix one possible memleak of
timeout
> 
> From: Gao Feng <fgao@ikuai8.com>
> 
> When nf_ct_timeout_ext_add failed in xt_ct_set_timeout, it should free the
> timeout refcnt.
> 
> Now goto the err_put_timeout error handler instead of going ahead.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/xt_CT.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c index
> b008db0..3cd812c 100644
> --- a/net/netfilter/xt_CT.c
> +++ b/net/netfilter/xt_CT.c
> @@ -168,7 +168,7 @@ static void __xt_ct_tg_timeout_put(struct ctnl_timeout
> *timeout)
>  	}
>  	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
>  	if (timeout_ext == NULL)
> -		ret = -ENOMEM;
> +		goto err_put_timeout;
> 
>  	rcu_read_unlock();
>  	return ret;
> --
> 1.9.1
> 
Sorry, please ignore this patch.
I have sent the v2 patch which keep the -ENOMEM assignment.

Regards
Feng 





