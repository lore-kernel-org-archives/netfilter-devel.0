Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E12FC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Apr 2022 07:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350986AbiDOHYT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 03:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348207AbiDOHYS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 03:24:18 -0400
Received: from zeeaster.vergenet.net (zeeaster.vergenet.net [206.189.110.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCFA9D052;
        Fri, 15 Apr 2022 00:21:49 -0700 (PDT)
Received: from madeliefje.horms.nl (2a02-a44a-2918-403-201-8eff-fe22-8fea.fixed6.kpn.net [IPv6:2a02:a44a:2918:403:201:8eff:fe22:8fea])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by zeeaster.vergenet.net (Postfix) with ESMTPSA id 35DA1200CD;
        Fri, 15 Apr 2022 07:21:48 +0000 (UTC)
Received: by madeliefje.horms.nl (Postfix, from userid 7100)
        id EA12335A8; Fri, 15 Apr 2022 09:21:47 +0200 (CEST)
Date:   Fri, 15 Apr 2022 09:21:47 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] ipvs: correctly print the memory size of
 ip_vs_conn_tab
Message-ID: <YlkdC1/AnuRCdhnv@vergenet.net>
References: <1649754031-18627-1-git-send-email-yangpc@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649754031-18627-1-git-send-email-yangpc@wangsu.com>
Organisation: Horms Solutions BV
X-Virus-Scanned: clamav-milter 0.103.5 at zeeaster
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 12, 2022 at 05:00:31PM +0800, Pengcheng Yang wrote:
> The memory size of ip_vs_conn_tab changed after we use hlist
> instead of list.
> 
> Fixes: 731109e78415 ("ipvs: use hlist instead of list")
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_conn.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
> index 2c467c4..e886c74 100644
> --- a/net/netfilter/ipvs/ip_vs_conn.c
> +++ b/net/netfilter/ipvs/ip_vs_conn.c
> @@ -1495,7 +1495,7 @@ int __init ip_vs_conn_init(void)
>  	pr_info("Connection hash table configured "
>  		"(size=%d, memory=%ldKbytes)\n",
>  		ip_vs_conn_tab_size,
> -		(long)(ip_vs_conn_tab_size*sizeof(struct list_head))/1024);
> +		(long)(ip_vs_conn_tab_size*sizeof(struct hlist_head))/1024);
>  	IP_VS_DBG(0, "Each connection entry needs %zd bytes at least\n",
>  		  sizeof(struct ip_vs_conn));
>  
> -- 
> 1.8.3.1
> 
