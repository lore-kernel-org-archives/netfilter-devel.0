Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF017C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 08:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D12921473
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 08:18:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="U8D0urXS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfDCISg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 04:18:36 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34731 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfDCISf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 04:18:35 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 856B125B820;
        Wed,  3 Apr 2019 19:18:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1554279512; bh=TATorOr4uhv9V4nQdt+Jcav/p7yNR4Kl3UzKo8QWOK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8D0urXSlPaM067qfC2nKdeCYuatVTzLEvkw3/pXWqcFprcRbueEUF6mrv8Z/vKWF
         mTMUVDdlbRb9vupex9D93pdwU7alL5nyONiGB4mUNd0B2FRDRe0YMzi5ndAtyDpZi2
         l0y35qCCoLpm5HaDujfKTl96d20f1GV7tEsI6U8c=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 80DA5940361; Wed,  3 Apr 2019 10:18:30 +0200 (CEST)
Date:   Wed, 3 Apr 2019 10:18:30 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     lvs-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Jacky Hu <hengqing.hu@gmail.com>,
        jacky.hu@walmart.com, jason.niesz@walmart.com
Subject: Re: [PATCH net-next 1/3] ipvs: allow rs_table to contain different
 real server types
Message-ID: <20190403081830.zeisy4kxyqamgmiv@verge.net.au>
References: <20190331102621.7460-1-ja@ssi.bg>
 <20190331102621.7460-2-ja@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190331102621.7460-2-ja@ssi.bg>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Julian,

On Sun, Mar 31, 2019 at 01:26:19PM +0300, Julian Anastasov wrote:
> Before now rs_table was used only for NAT real servers.
> Change it to allow TUN real severs from different types,
> possibly hashed with different port key.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

This looks good to me, modulo some nits below.

> ---
>  include/net/ip_vs.h            |  3 +++
>  net/netfilter/ipvs/ip_vs_ctl.c | 43 +++++++++++++++++++++++++++-------
>  2 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 2ac40135b576..9a8ac8997e34 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -1497,6 +1497,9 @@ static inline int ip_vs_todrop(struct netns_ipvs *ipvs)
>  static inline int ip_vs_todrop(struct netns_ipvs *ipvs) { return 0; }
>  #endif
>  
> +#define IP_VS_DFWD_METHOD(dest) (atomic_read(&(dest)->conn_flags) & \
> +				 IP_VS_CONN_F_FWD_MASK)
> +
>  /* ip_vs_fwd_tag returns the forwarding tag of the connection */
>  #define IP_VS_FWD_METHOD(cp)  (cp->flags & IP_VS_CONN_F_FWD_MASK)
>  
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 328683452229..7de90c00c8bd 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -515,15 +515,36 @@ static inline unsigned int ip_vs_rs_hashkey(int af,
>  static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
>  {
>  	unsigned int hash;
> +	__be16 port;
>  
>  	if (dest->in_rs_table)
>  		return;
>  
> +	switch (IP_VS_DFWD_METHOD(dest)) {
> +	case IP_VS_CONN_F_MASQ:
> +		port = dest->port;
> +		break;
> +	case IP_VS_CONN_F_TUNNEL:
> +		switch (dest->tun_type) {
> +		case IP_VS_CONN_F_TUNNEL_TYPE_GUE:
> +			port = dest->tun_port;
> +			break;
> +		case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
> +			port = 0;
> +			break;
> +		default:
> +			return;
> +		}
> +		break;
> +	default:
> +		return;
> +	}
> +
>  	/*
>  	 *	Hash by proto,addr,port,
>  	 *	which are the parameters of the real service.
>  	 */
> -	hash = ip_vs_rs_hashkey(dest->af, &dest->addr, dest->port);
> +	hash = ip_vs_rs_hashkey(dest->af, &dest->addr, port);
>  
>  	hlist_add_head_rcu(&dest->d_list, &ipvs->rs_table[hash]);
>  	dest->in_rs_table = 1;
> @@ -555,7 +576,8 @@ bool ip_vs_has_real_service(struct netns_ipvs *ipvs, int af, __u16 protocol,
>  		if (dest->port == dport &&
>  		    dest->af == af &&
  		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
> -		    (dest->protocol == protocol || dest->vfwmark)) {
> +		    (dest->protocol == protocol || dest->vfwmark) &&
> +		    (IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_MASQ)) {

nit: there seem to be unnecessary () on the line above

>  			/* HIT */
>  			return true;
>  		}
> @@ -585,7 +607,8 @@ struct ip_vs_dest *ip_vs_find_real_service(struct netns_ipvs *ipvs, int af,
>  		if (dest->port == dport &&
>  		    dest->af == af &&
>  		    ip_vs_addr_equal(af, &dest->addr, daddr) &&
> -			(dest->protocol == protocol || dest->vfwmark)) {
> +		    (dest->protocol == protocol || dest->vfwmark) &&
> +		    (IP_VS_DFWD_METHOD(dest) == IP_VS_CONN_F_MASQ)) {

ditto

>  			/* HIT */
>  			return dest;
>  		}

...
