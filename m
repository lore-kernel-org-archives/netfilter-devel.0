From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: xt_owner-xt_socket plans
Date: Tue, 22 Jan 2008 08:54:58 +0100
Message-ID: <20080122075458.GA14519@sch.bme.hu>
References: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr> <479461C2.1060703@balabit.hu> <Pine.LNX.4.64.0801211417200.24186@fbirervta.pbzchgretzou.qr> <4794AB98.1050607@balabit.hu> <Pine.LNX.4.64.0801211539020.25080@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:37842 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbYAVHzB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 02:55:01 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801211539020.25080@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On k, jan 22, 2008 at 12:22:56 +0100, Jan Engelhardt wrote:
> This is how it would look then:
> commit 807482809f619a167d3dd349553d621ee4cd3b48
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Mon Jan 21 14:08:27 2008 +0100
> 
>     [NETFILTER]: xt_socket: input path processing
>     
>     tproxy adds a function for socket lookup; xt_socket can use this to
>     be usable in the PREROUTING and INPUT chains.
>     (This code has not been compile tested, but serves as an example.)
>     
>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index 07d681c..1deacb2 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c

#ifdef CONFIG_NETFILTER_TPROXY
#include <net/netfilter/nf_tproxy_core.h>
#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
#endif

> @@ -76,17 +76,46 @@ owner_mt6_v0(const struct sk_buff *skb, const struct net_device *in,
>  	return true;
>  }
>  
> +static struct sock *
> +socket_mt_getsock(const struct sk_buff *skb, const struct net_device *in)
> +{
> +#ifdef CONFIG_NETFILTER_TPROXY
> +	const struct iphdr *iph = ip_hdr(skb);
> +	const struct udphdr *udph;
> +	struct udphdr udphdr;
> +
> +	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP &&
> +	    iph->protocol != IPPROTO_UDPLITE)
> +		return false;

Should return NULL here.

> +
> +	/*
> +	 * All the protocols that are currently supported (see above if
> +	 * statement) have source and destination port at the same position,
> +	 * so we can use this udph shortcut. Why UDP? The struct is the
> +	 * smallest.
> +	 */
> +	udph = skb_header_pointer(skb, ip_hdrlen(skb), udphdr, sizeof(udphdr));
> +	if (udph == NULL)
> +		return NULL;
> +
> +	return nf_tproxy_get_v4(iph->protocol, iph->saddr, iph->daddr,
> +	                        hp->source, hp->dest, in, false);
> +#endif
> +	return NULL;
> +}
> +
> +static void socket_mt_putsock(struct sock *sk)

Inline?

> +{
> +#ifdef CONFIG_NETFILTER_TPROXY
> +	nf_tproxy_put_sock(sk);
> +#endif
> +}
> +
>  static bool
> -socket_mt(const struct sk_buff *skb, const struct net_device *in,
> -          const struct net_device *out, const struct xt_match *match,
> -          const void *matchinfo, int offset, unsigned int protoff,
> -          bool *hotdrop)
> +socket_mt_match(const struct sock *sk, const struct xt_socket_mtinfo *info)
>  {
> -	const struct xt_socket_mtinfo *info = matchinfo;
>  	const struct file *filp;
> -	const struct sock *sk;
>  
> -	sk = skb->sk;
>  	if (sk == NULL || sk->sk_socket == NULL)
>  		return (info->match ^ info->invert) == 0;
>  	else if (info->match & info->invert & XT_SOCKET_EXISTS)
> @@ -117,6 +146,25 @@ socket_mt(const struct sk_buff *skb, const struct net_device *in,
>  }
>  
>  static bool
> +socket_mt(const struct sk_buff *skb, const struct net_device *in,
> +          const struct net_device *out, const struct xt_match *match,
> +          const void *matchinfo, int offset, unsigned int protoff,
> +          bool *hotdrop)
> +{
> +	struct sock *tpsk = NULL;
> +	const struct sock *sk;
> +	bool ret;
> +
> +	sk = skb->sk;
> +	if (sk == NULL && in != NULL && match->family == AF_INET)
> +		sk = tpsk = socket_mt_getsock(skb, in);
> +	ret = socket_mt_match(sk, matchinfo);
> +	if (tpsk != NULL)
> +		socket_mt_putsock(tpsk);
> +	return ret;
> +}
> +
> +static bool
>  owner_mt_check_v0(const char *tablename, const void *ip,
>                    const struct xt_match *match, void *matchinfo,
>                    unsigned int hook_mask)
> @@ -149,6 +197,22 @@ owner_mt6_check_v0(const char *tablename, const void *ip,
>  	return true;
>  }
>  
> +static bool
> +socket_mt4_check(const char *tablename, const void *ip,
> +                 const struct xt_match *match, void *matchinfo,
> +                 unsigned int hook_mask)
> +{
> +#ifndef CONFIG_NETFILTER_TPROXY
> +	if (hook_mask & (NF_INET_PRE_ROUTING | NF_INET_LOCAL_IN)) {
> +		printk(KERN_WARNING KBUILD_MODNAME
> +			       ": Use in PREROUTING and INPUT chains only "
> +			       "possible with tproxy\n");
> +		return false;
> +	}
> +#endif
> +	return true;
> +}
> +
>  static struct xt_match socket_mt_reg[] __read_mostly = {
>  	{
>  		.name       = "owner",
> @@ -178,7 +242,10 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
>  		.family     = AF_INET,
>  		.match      = socket_mt,
>  		.matchsize  = sizeof(struct xt_socket_mtinfo),
> -		.hooks      = (1 << NF_INET_LOCAL_OUT) |
> +		.checkentry = socket_mt4_check,
> +		.hooks      = (1 << NF_INET_PRE_ROUTING) |
> +		              (1 << NF_INET_LOCAL_IN) |
> +		              (1 << NF_INET_LOCAL_OUT) |
>  		              (1 << NF_INET_POST_ROUTING),
>  		.me         = THIS_MODULE,
>  	},
> @@ -196,6 +263,13 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
>  
>  static int __init socket_mt_init(void)
>  {
> +#ifdef CONFIG_NETFILTER_TPROXY

        nf_defrag_ipv4_enable();

As socket can be used without conntrack but you _need_ the first few
bytes of the IP datagram to be able to do the socket lookup you have to
defrag. This is just another ugly kludge...

> +	printk(KERN_INFO KBUILD_MODNAME
> +	       ": Input path socket lookup for IPv4 via tproxy.\n");
> +#else
> +	printk(KERN_INFO KBUILD_MODNAME
> +	       ": No socket lookup for PREROUTING/INPUT available.\n");
> +#endif
>  	return xt_register_matches(socket_mt_reg, ARRAY_SIZE(socket_mt_reg));
>  }
>  
> 

-- 
KOVACS Krisztian
