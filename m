From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2 1/1] netfilter: xt_CT: Fix one possible memleak of
 timeout
Date: Fri, 14 Apr 2017 00:24:46 +0200
Message-ID: <20170413222446.GA4978@salvia>
References: <1491477574-82700-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751638AbdDMWZ1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:25:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 433F1BA714
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:25:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81751DA86B
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:25:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D597ADA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:25:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491477574-82700-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 06, 2017 at 07:19:34PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When nf_ct_timeout_ext_add failed in xt_ct_set_timeout, it should
> free the timeout refcnt.
> 
> Now goto the err_put_timeout error handler instead of going ahead.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  v2: Keep the ret = -ENOMEM, per Gao Feng
>  v1: initial version
> 
>  net/netfilter/xt_CT.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
> index b008db0..a1783b6 100644
> --- a/net/netfilter/xt_CT.c
> +++ b/net/netfilter/xt_CT.c
> @@ -167,8 +167,10 @@ static void __xt_ct_tg_timeout_put(struct ctnl_timeout *timeout)
>  		goto err_put_timeout;
>  	}
>  	timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
> -	if (timeout_ext == NULL)
> +	if (!timeout_ext) {
>  		ret = -ENOMEM;
> +		goto err_put_timeout;
> +	}

This also needs to be fixed, just a few line after this:

        timeout_ext = nf_ct_timeout_ext_add(ct, timeout, GFP_ATOMIC);
        if (timeout_ext == NULL)
                ret = -ENOMEM;
