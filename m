Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A6CC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 07:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3799D20882
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 07:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="StksjdOx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfDCHp3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 03:45:29 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34142 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbfDCHp3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 03:45:29 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 2F7BE25AD6C;
        Wed,  3 Apr 2019 18:45:27 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1554277527; bh=RkADbyppKLziRGAgsnTmBQLTuaAsj8buJmdt4vkvK+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=StksjdOxVBrA65/KqRtoPPdj7FhWVe7g2meb/yknPCxBTMjAYXVCowRdub+uAakSl
         dC761P0S9IFGUN4YuzZgi2NgOO/XJzthUXLYQTt1zB6S5/vjOXEIWuRJg6xXXQ8nz3
         Zmb8OUl/GYpPx2cYWz27/1c7NpB1P/LZIe+pu9Yc=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id C5972940361; Wed,  3 Apr 2019 09:45:24 +0200 (CEST)
Date:   Wed, 3 Apr 2019 09:45:24 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Alex Gartrell <agartrell@fb.com>,
        Jacky Hu <hengqing.hu@gmail.com>, jacky.hu@walmart.com,
        jason.niesz@walmart.com
Subject: Re: [PATCH net] ipvs: do not schedule icmp errors from tunnels
Message-ID: <20190403074521.uijb34c6mo264nmg@verge.net.au>
References: <20190331102452.7415-1-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331102452.7415-1-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Mar 31, 2019 at 01:24:52PM +0300, Julian Anastasov wrote:
> We can receive ICMP errors from client or from
> tunneling real server. While the former can be
> scheduled to real server, the latter should
> not be scheduled, they are decapsulated only when
> existing connection is found.
> 
> Fixes: 6044eeffafbe ("ipvs: attempt to schedule icmp packets")
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Thanks Julian, I assume this is also relevant to -stable.

Pablo, please consider applying this to nf.

Signed-off-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index 43bbaa32b1d6..14457551bcb4 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1678,7 +1678,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, struct sk_buff *skb, int *related,
>  	if (!cp) {
>  		int v;
>  
> -		if (!sysctl_schedule_icmp(ipvs))
> +		if (ipip || !sysctl_schedule_icmp(ipvs))
>  			return NF_ACCEPT;
>  
>  		if (!ip_vs_try_to_schedule(ipvs, AF_INET, skb, pd, &v, &cp, &ciph))
> -- 
> 2.17.1
> 
