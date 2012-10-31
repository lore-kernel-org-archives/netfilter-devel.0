From: Nick Jones <nick.jones@network-box.com>
Subject: Re: [PATCH next] netfilter: ipv6: add getsockopt to retrieve
 origdst
Date: Wed, 31 Oct 2012 10:11:38 +0800
Message-ID: <1351649498.10780.6947.camel@nbnickhq4>
References: <1351595329-13081-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from erika.network-box.com ([202.52.42.180]:48132 "EHLO
	nbmailscanhq1.network-box.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753797Ab2JaC0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:26:55 -0400
In-Reply-To: <1351595329-13081-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2012-10-30 at 12:08 +0100, Florian Westphal wrote: 
> userspace can query the original ipv4 destination address of a REDIRECTed
> connection via
> getsockopt(m_sock, SOL_IP, SO_ORIGINAL_DST, &m_server_addr, &addrsize)
> 
> but for ipv6 no such option existed.
> 
> This adds getsockopt(..., IPPROTO_IPV6, IP6T_SO_ORIGINAL_DST, ...).
> 
> Without this, userspace needs to parse /proc or use ctnetlink, which
> appears to be overkill.
> 

Doesn't getsockname(2) provide this information?  It does for TPROXY'd
connections.

> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Instead of adding new IP6T_SO_ORIGINAL_DST, we could also
>  simply re-use existing SO_ORIGINAL_DST ipv4 define.  Any Preferences?
> 
>  include/uapi/linux/in6.h                       |    1 +
>  include/uapi/linux/netfilter_ipv6/ip6_tables.h |    3 +
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   61 ++++++++++++++++++++++++
>  3 files changed, 65 insertions(+), 0 deletions(-)
> 
> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
> index 1e31599..f79c372 100644
> --- a/include/uapi/linux/in6.h
> +++ b/include/uapi/linux/in6.h
> @@ -240,6 +240,7 @@ struct in6_flowlabel_req {
>   *
>   * IP6T_SO_GET_REVISION_MATCH	68
>   * IP6T_SO_GET_REVISION_TARGET	69
> + * IP6T_SO_ORIGINAL_DST		80
>   */
>  
>  /* RFC5014: Source address selection */
> diff --git a/include/uapi/linux/netfilter_ipv6/ip6_tables.h b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
> index bf1ef65..649c680 100644
> --- a/include/uapi/linux/netfilter_ipv6/ip6_tables.h
> +++ b/include/uapi/linux/netfilter_ipv6/ip6_tables.h
> @@ -178,6 +178,9 @@ struct ip6t_error {
>  #define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 5)
>  #define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
>  
> +/* obtain original address if REDIRECT'd connection */
> +#define IP6T_SO_ORIGINAL_DST            80
> +
>  /* ICMP matching stuff */
>  struct ip6t_icmp {
>  	__u8 type;				/* type to match */
> diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> index 8860d23..02dcafd 100644
> --- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
> @@ -21,6 +21,7 @@
>  
>  #include <linux/netfilter_bridge.h>
>  #include <linux/netfilter_ipv6.h>
> +#include <linux/netfilter_ipv6/ip6_tables.h>
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_helper.h>
>  #include <net/netfilter/nf_conntrack_l4proto.h>
> @@ -295,6 +296,50 @@ static struct nf_hook_ops ipv6_conntrack_ops[] __read_mostly = {
>  	},
>  };
>  
> +static int
> +ipv6_getorigdst(struct sock *sk, int optval, void __user *user, int *len)
> +{
> +	const struct inet_sock *inet = inet_sk(sk);
> +	const struct ipv6_pinfo *inet6 = inet6_sk(sk);
> +	const struct nf_conntrack_tuple_hash *h;
> +	struct sockaddr_in6 sin6;
> +	struct nf_conntrack_tuple tuple = { .src.l3num = NFPROTO_IPV6 };
> +	struct nf_conn *ct;
> +
> +	tuple.src.u3.in6 = inet6->rcv_saddr;
> +	tuple.src.u.tcp.port = inet->inet_sport;
> +	tuple.dst.u3.in6 = inet6->daddr;
> +	tuple.dst.u.tcp.port = inet->inet_dport;
> +	tuple.dst.protonum = sk->sk_protocol;
> +
> +	if (sk->sk_protocol != IPPROTO_TCP && sk->sk_protocol != IPPROTO_SCTP)
> +		return -ENOPROTOOPT;
> +
> +	if (*len < 0 || (unsigned int) *len < sizeof(sin6))
> +		return -EINVAL;
> +
> +	h = nf_conntrack_find_get(sock_net(sk), NF_CT_DEFAULT_ZONE, &tuple);
> +	if (!h) {
> +		pr_debug("IP6T_SO_ORIGINAL_DST: Can't find %pI6c/%u-%pI6c/%u.\n",
> +			 &tuple.src.u3.ip6, ntohs(tuple.src.u.tcp.port),
> +			 &tuple.dst.u3.ip6, ntohs(tuple.dst.u.tcp.port));
> +		return -ENOENT;
> +	}
> +
> +	ct = nf_ct_tuplehash_to_ctrack(h);
> +
> +	sin6.sin6_family = AF_INET6;
> +	sin6.sin6_port = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port;
> +	sin6.sin6_flowinfo = inet6->flow_label & IPV6_FLOWINFO_MASK;
> +	memcpy(&sin6.sin6_addr,
> +		&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.in6,
> +					sizeof(sin6.sin6_addr));
> +	sin6.sin6_scope_id = sk->sk_bound_dev_if;
> +
> +	nf_ct_put(ct);
> +	return copy_to_user(user, &sin6, sizeof(sin6)) ? -EFAULT : 0;
> +}
> +
>  #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
>  
>  #include <linux/netfilter/nfnetlink.h>
> @@ -359,6 +404,14 @@ MODULE_ALIAS("nf_conntrack-" __stringify(AF_INET6));
>  MODULE_LICENSE("GPL");
>  MODULE_AUTHOR("Yasuyuki KOZAKAI @USAGI <yasuyuki.kozakai@toshiba.co.jp>");
>  
> +static struct nf_sockopt_ops so_getorigdst6 = {
> +	.pf		= NFPROTO_IPV6,
> +	.get_optmin	= IP6T_SO_ORIGINAL_DST,
> +	.get_optmax	= IP6T_SO_ORIGINAL_DST + 1,
> +	.get		= ipv6_getorigdst,
> +	.owner		= THIS_MODULE,
> +};
> +
>  static int ipv6_net_init(struct net *net)
>  {
>  	int ret = 0;
> @@ -425,6 +478,12 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
>  	need_conntrack();
>  	nf_defrag_ipv6_enable();
>  
> +	ret = nf_register_sockopt(&so_getorigdst6);
> +	if (ret < 0) {
> +		pr_err("Unable to register netfilter socket option\n");
> +		return ret;
> +	}
> +
>  	ret = register_pernet_subsys(&ipv6_net_ops);
>  	if (ret < 0)
>  		goto cleanup_pernet;
> @@ -440,6 +499,7 @@ static int __init nf_conntrack_l3proto_ipv6_init(void)
>   cleanup_ipv6:
>  	unregister_pernet_subsys(&ipv6_net_ops);
>   cleanup_pernet:
> +	nf_unregister_sockopt(&so_getorigdst6);
>  	return ret;
>  }
>  
> @@ -448,6 +508,7 @@ static void __exit nf_conntrack_l3proto_ipv6_fini(void)
>  	synchronize_net();
>  	nf_unregister_hooks(ipv6_conntrack_ops, ARRAY_SIZE(ipv6_conntrack_ops));
>  	unregister_pernet_subsys(&ipv6_net_ops);
> +	nf_unregister_sockopt(&so_getorigdst6);
>  }
>  
>  module_init(nf_conntrack_l3proto_ipv6_init);

-- 
Nick Jones                              nick.jones@network-box.com
Senior Manager                          Core Development Team

Network Box Corporation Ltd
16th Floor, Metro Loft,
38 Kwai Hei Street,                     Tel: +852 2736 2083
Kwai Chung, Kowloon,                    Fax: +852 2736 2778
Hong Kong S.A.R.                        www.network-box.com

