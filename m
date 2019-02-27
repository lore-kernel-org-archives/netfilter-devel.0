Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC049C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 12:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A45F2087C
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 12:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=verge.net.au header.i=@verge.net.au header.b="aSMu0K46"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfB0MVA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 07:21:00 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:53116 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729964AbfB0MU7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 07:20:59 -0500
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 6319325B7D6;
        Wed, 27 Feb 2019 23:20:55 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=verge.net.au; s=mail;
        t=1551270055; bh=BmxBGOBJftDdAFxzyvB4eXGRVHTfHULmv1gVGohpimA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aSMu0K46zSXRAEzxDBBUgzclfM+negmDUNoamDgVZXUwhkV2/EspHsRUA6nZWf8zA
         EeUGDApbV17PzU+Cz6bN+e06kFAlQJsF5Y2DQlcZiIfac+9TqsyVUQwcJTUsGrOtmD
         W18h+JFgXVPdFwMslMVh0swMSiN7NwwDkFD469ds=
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id C3F199402DD; Wed, 27 Feb 2019 13:20:53 +0100 (CET)
Date:   Wed, 27 Feb 2019 13:20:53 +0100
From:   Simon Horman <horms@verge.net.au>
To:     Andrea Claudi <aclaudi@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     wensong@linux-vs.org, ja@ssi.bg, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] ipvs: change some data types from int to bool
Message-ID: <20190227122053.wzwhhuv4xmomb6z7@verge.net.au>
References: <4b4e7e88ad4b274b204c50caabc0ce1423f9e11d.1550331292.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b4e7e88ad4b274b204c50caabc0ce1423f9e11d.1550331292.git.aclaudi@redhat.com>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Feb 16, 2019 at 04:39:53PM +0100, Andrea Claudi wrote:
> Change the data type of the following variables from int to bool
> across ipvs code:
> 
>   - found
>   - loop
>   - need_full_dest
>   - need_full_svc
>   - payload_csum
> 
> Also change the following functions to use bool full_entry param
> instead of int:
> 
>   - ip_vs_genl_parse_dest()
>   - ip_vs_genl_parse_service()
> 
> This patch does not change any functionality but makes the source
> code slightly easier to read.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>


Acked-by: Simon Horman <horms@verge.net.au>

Pablo,

please consider applying this to nf-next.

> ---
>  net/netfilter/ipvs/ip_vs_ctl.c       | 12 ++++++------
>  net/netfilter/ipvs/ip_vs_ftp.c       |  4 ++--
>  net/netfilter/ipvs/ip_vs_proto_tcp.c |  8 ++++----
>  net/netfilter/ipvs/ip_vs_proto_udp.c |  8 ++++----
>  net/netfilter/ipvs/ip_vs_xmit.c      |  4 ++--
>  5 files changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index ac8d848d7624..0665ffca407f 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -3088,7 +3088,7 @@ static bool ip_vs_is_af_valid(int af)
>  
>  static int ip_vs_genl_parse_service(struct netns_ipvs *ipvs,
>  				    struct ip_vs_service_user_kern *usvc,
> -				    struct nlattr *nla, int full_entry,
> +				    struct nlattr *nla, bool full_entry,
>  				    struct ip_vs_service **ret_svc)
>  {
>  	struct nlattr *attrs[IPVS_SVC_ATTR_MAX + 1];
> @@ -3175,7 +3175,7 @@ static struct ip_vs_service *ip_vs_genl_find_service(struct netns_ipvs *ipvs,
>  	struct ip_vs_service *svc;
>  	int ret;
>  
> -	ret = ip_vs_genl_parse_service(ipvs, &usvc, nla, 0, &svc);
> +	ret = ip_vs_genl_parse_service(ipvs, &usvc, nla, false, &svc);
>  	return ret ? ERR_PTR(ret) : svc;
>  }
>  
> @@ -3285,7 +3285,7 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
>  }
>  
>  static int ip_vs_genl_parse_dest(struct ip_vs_dest_user_kern *udest,
> -				 struct nlattr *nla, int full_entry)
> +				 struct nlattr *nla, bool full_entry)
>  {
>  	struct nlattr *attrs[IPVS_DEST_ATTR_MAX + 1];
>  	struct nlattr *nla_addr, *nla_port;
> @@ -3547,11 +3547,11 @@ static int ip_vs_genl_set_daemon(struct sk_buff *skb, struct genl_info *info)
>  
>  static int ip_vs_genl_set_cmd(struct sk_buff *skb, struct genl_info *info)
>  {
> +	bool need_full_svc = false, need_full_dest = false;
>  	struct ip_vs_service *svc = NULL;
>  	struct ip_vs_service_user_kern usvc;
>  	struct ip_vs_dest_user_kern udest;
>  	int ret = 0, cmd;
> -	int need_full_svc = 0, need_full_dest = 0;
>  	struct net *net = sock_net(skb->sk);
>  	struct netns_ipvs *ipvs = net_ipvs(net);
>  
> @@ -3575,7 +3575,7 @@ static int ip_vs_genl_set_cmd(struct sk_buff *skb, struct genl_info *info)
>  	 * received a valid one. We need a full service specification when
>  	 * adding / editing a service. Only identifying members otherwise. */
>  	if (cmd == IPVS_CMD_NEW_SERVICE || cmd == IPVS_CMD_SET_SERVICE)
> -		need_full_svc = 1;
> +		need_full_svc = true;
>  
>  	ret = ip_vs_genl_parse_service(ipvs, &usvc,
>  				       info->attrs[IPVS_CMD_ATTR_SERVICE],
> @@ -3595,7 +3595,7 @@ static int ip_vs_genl_set_cmd(struct sk_buff *skb, struct genl_info *info)
>  	if (cmd == IPVS_CMD_NEW_DEST || cmd == IPVS_CMD_SET_DEST ||
>  	    cmd == IPVS_CMD_DEL_DEST) {
>  		if (cmd != IPVS_CMD_DEL_DEST)
> -			need_full_dest = 1;
> +			need_full_dest = true;
>  
>  		ret = ip_vs_genl_parse_dest(&udest,
>  					    info->attrs[IPVS_CMD_ATTR_DEST],
> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
> index 4398a72edec5..fe69d46ff779 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> @@ -124,7 +124,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
>  	}
>  	s = data + plen;
>  	if (skip) {
> -		int found = 0;
> +		bool found = false;
>  
>  		for (;; s++) {
>  			if (s == data_limit)
> @@ -136,7 +136,7 @@ static int ip_vs_ftp_get_addrport(char *data, char *data_limit,
>  				if (!ext && isdigit(*s))
>  					break;
>  				if (*s == skip)
> -					found = 1;
> +					found = true;
>  			} else if (*s != skip) {
>  				break;
>  			}
> diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> index 1770fc6ce960..a95ef1d77159 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
> @@ -149,8 +149,8 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  {
>  	struct tcphdr *tcph;
>  	unsigned int tcphoff = iph->len;
> +	bool payload_csum = false;
>  	int oldlen;
> -	int payload_csum = 0;
>  
>  #ifdef CONFIG_IP_VS_IPV6
>  	if (cp->af == AF_INET6 && iph->fragoffs)
> @@ -176,7 +176,7 @@ tcp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  		if (ret == 1)
>  			oldlen = skb->len - tcphoff;
>  		else
> -			payload_csum = 1;
> +			payload_csum = true;
>  	}
>  
>  	tcph = (void *)skb_network_header(skb) + tcphoff;
> @@ -227,8 +227,8 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  {
>  	struct tcphdr *tcph;
>  	unsigned int tcphoff = iph->len;
> +	bool payload_csum = false;
>  	int oldlen;
> -	int payload_csum = 0;
>  
>  #ifdef CONFIG_IP_VS_IPV6
>  	if (cp->af == AF_INET6 && iph->fragoffs)
> @@ -257,7 +257,7 @@ tcp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  		if (ret == 1)
>  			oldlen = skb->len - tcphoff;
>  		else
> -			payload_csum = 1;
> +			payload_csum = true;
>  	}
>  
>  	tcph = (void *)skb_network_header(skb) + tcphoff;
> diff --git a/net/netfilter/ipvs/ip_vs_proto_udp.c b/net/netfilter/ipvs/ip_vs_proto_udp.c
> index 0f53c49025f8..d914e077d51b 100644
> --- a/net/netfilter/ipvs/ip_vs_proto_udp.c
> +++ b/net/netfilter/ipvs/ip_vs_proto_udp.c
> @@ -139,8 +139,8 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  {
>  	struct udphdr *udph;
>  	unsigned int udphoff = iph->len;
> +	bool payload_csum = false;
>  	int oldlen;
> -	int payload_csum = 0;
>  
>  #ifdef CONFIG_IP_VS_IPV6
>  	if (cp->af == AF_INET6 && iph->fragoffs)
> @@ -168,7 +168,7 @@ udp_snat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  		if (ret == 1)
>  			oldlen = skb->len - udphoff;
>  		else
> -			payload_csum = 1;
> +			payload_csum = true;
>  	}
>  
>  	udph = (void *)skb_network_header(skb) + udphoff;
> @@ -222,8 +222,8 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  {
>  	struct udphdr *udph;
>  	unsigned int udphoff = iph->len;
> +	bool payload_csum = false;
>  	int oldlen;
> -	int payload_csum = 0;
>  
>  #ifdef CONFIG_IP_VS_IPV6
>  	if (cp->af == AF_INET6 && iph->fragoffs)
> @@ -252,7 +252,7 @@ udp_dnat_handler(struct sk_buff *skb, struct ip_vs_protocol *pp,
>  		if (ret == 1)
>  			oldlen = skb->len - udphoff;
>  		else
> -			payload_csum = 1;
> +			payload_csum = true;
>  	}
>  
>  	udph = (void *)skb_network_header(skb) + udphoff;
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 473cce2a5231..175349fcf91f 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -126,7 +126,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
>  {
>  	struct flowi4 fl4;
>  	struct rtable *rt;
> -	int loop = 0;
> +	bool loop = false;
>  
>  	memset(&fl4, 0, sizeof(fl4));
>  	fl4.daddr = daddr;
> @@ -149,7 +149,7 @@ static struct rtable *do_output_route4(struct net *net, __be32 daddr,
>  		ip_rt_put(rt);
>  		*saddr = fl4.saddr;
>  		flowi4_update_output(&fl4, 0, 0, daddr, fl4.saddr);
> -		loop++;
> +		loop = true;
>  		goto retry;
>  	}
>  	*saddr = fl4.saddr;
> -- 
> 2.20.1
> 
