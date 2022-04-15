Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A32C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Apr 2022 13:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353988AbiDONay (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353991AbiDONaw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 09:30:52 -0400
X-Greylist: delayed 325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 15 Apr 2022 06:28:23 PDT
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDBD8ABF6C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2022 06:28:23 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id AC1E223F8B;
        Fri, 15 Apr 2022 16:22:57 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 7A42223F8A;
        Fri, 15 Apr 2022 16:22:55 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id BBF8D3C0332;
        Fri, 15 Apr 2022 16:22:49 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 23FDMlEo057935;
        Fri, 15 Apr 2022 16:22:49 +0300
Date:   Fri, 15 Apr 2022 16:22:47 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Pengcheng Yang <yangpc@wangsu.com>
cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] ipvs: correctly print the memory size of
 ip_vs_conn_tab
In-Reply-To: <1649761545-1864-1-git-send-email-yangpc@wangsu.com>
Message-ID: <dd2f82a6-bf70-2b10-46e0-9d81e4dde6@ssi.bg>
References: <1649761545-1864-1-git-send-email-yangpc@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 12 Apr 2022, Pengcheng Yang wrote:

> The memory size of ip_vs_conn_tab changed after we use hlist
> instead of list.
> 
> Fixes: 731109e78415 ("ipvs: use hlist instead of list")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---

	v2 looks better to me for nf-next, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> v2: use pointer dereference instead of struct types
> 
>  net/netfilter/ipvs/ip_vs_conn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 2c467c4..fb67f1c 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
>  	pr_info("Connection hash table configured "
>  		"(size=%d, memory=%ldKbytes)\n",
>  		ip_vs_conn_tab_size,
> -		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
> +		(long)(ip_vs_conn_tab_size*sizeof(*ip_vs_conn_tab))/1024);
>  	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
>  		  sizeof(struct ip_vs_conn));
>  
> -- 
> 1.8.3.1

Regards

--
Julian Anastasov <ja@ssi.bg>

