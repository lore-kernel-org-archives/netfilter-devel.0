From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH 11/13] xt_TPROXY
Date: Mon, 1 Oct 2007 01:04:45 +0200
Message-ID: <200710010104.45225@nessa>
References: <20070930205141.10969.27205.stgit@nessa.odu> <20070930205335.10969.91031.stgit@nessa.odu> <Pine.LNX.4.64.0710010016080.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:41498 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbXI3XEn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:04:43 -0400
In-Reply-To: <Pine.LNX.4.64.0710010016080.7130@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 01 October 2007, Jan Engelhardt wrote:
> On Sep 30 2007 22:53, KOVACS Krisztian wrote:
> >+struct ipt_tproxy_target_info {
> >+	__be32 laddr;
> >+	__be16 lport;
> >+	unsigned long mark_mask;
> >+	unsigned long mark_value;
> >+};
>
> Cannot use unsigned long, as its size is not fixed.
>
>
> (other nitpicks that were already in xt_socket)
>
> >+	/* NOTE: assign_sock consumes our sk reference */
> >+	if (sk && nf_tproxy_assign_sock(skb, sk)) {
> >+		/* This should be in a separate target, but we don't do multiple
> >+		   targets on the same rule yet */
> >+		skb->mark = (skb->mark & ~tgi->mark_mask) ^ tgi->mark_value;
>
> I guess you mean | instead of ^ here.

No, ^ is intentional. The idea is that in addition to being able to _set_ 
the masked part of the mark to a given value, you can also flip other 
bits of the mark with the unmasked parts of the value. So it has slightly 
more expressive power, and does the right thing if you use it in 
a 'conventional' way.

>
> >+#ifdef CONFIG_COMPAT
> >+struct compat_ipt_tproxy_target_info {
> >+	__be32 laddr;
> >+	__be16 lport;
> >+	__be16 __pad1;
> >+	compat_ulong_t mark_mask;
> >+	compat_ulong_t mark_value;
> >+};
>
> Uhm, that's a bit cumbersome. By reordering, we can get all the
> alignment done without any premature compat code.

Yes, given that we can go back to using 32 bit marks.

>
> Find below a patch that makes me happy, and compiles. :)
>
> [ xtification comes at no cost, even if it's ipv4-only.
>   Although it is just a guess, I suppose xt_ is going to replace
>   ipt_ and ip6t_ even if some matches/targets are not all-protocol ]
>
> ===
>
> The TPROXY target implements redirection of non-local TCP/UDP traffic
> to local sockets. Additionally, it's possible to manipulate the packet
> mark if and only if a socket has been found. (We need this because we
> cannot use multiple targets in the same iptables rule.)
>
> (originally from: KOVACS Krisztian <hidden@sch.bme.hu>)
>
> A few cleanups and fixes.
>
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> ---
>
>  include/linux/netfilter/xt_TPROXY.h |   16 ++++++
>  net/netfilter/Kconfig               |   12 ++++
>  net/netfilter/Makefile              |    1
>  net/netfilter/xt_TPROXY.c           |   92
> ++++++++++++++++++++++++++++++++++++ 4 files changed, 121 insertions(+)
>
> Index: linux-2.6.23/include/linux/netfilter/xt_TPROXY.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.23/include/linux/netfilter/xt_TPROXY.h
> @@ -0,0 +1,16 @@
> +#ifndef _XT_TPROXY_H
> +#define _XT_TPROXY_H
> +
> +/*
> + * TPROXY target is capable of marking the packet to perform
> + * redirection. We can get rid of that whenever we get support for
> + * mutliple targets in the same rule.
> + */
> +struct xt_tproxy_info {
> +	u_int32_t mark_mask;
> +	u_int32_t mark_value;
> +	__be32 laddr;
> +	__be16 lport;
> +};
> +
> +#endif /* _XT_TPROXY_H */
> Index: linux-2.6.23/net/netfilter/Kconfig
> ===================================================================
> --- linux-2.6.23.orig/net/netfilter/Kconfig
> +++ linux-2.6.23/net/netfilter/Kconfig
> @@ -363,6 +363,18 @@ config NETFILTER_XT_TARGET_NOTRACK
>  	  If you want to compile it as a module, say M here and read
>  	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
>
> +config NETFILTER_XT_TARGET_TPROXY
> +	tristate '"TPROXY" target support'
> +	depends on NETFILTER_TPROXY
> +	depends on NETFILTER_XTABLES
> +	help
> +	  This option adds a "TPROXY" target, which is somewhat similar to
> +	  REDIRECT. It can only be used in the tproxy table and is useful
> +	  to redirect traffic to a transparent proxy. It does _not_ depend
> +	  on Netfilter connection tracking.
> +
> +	  To compile it as a module, choose M here. If unsure, say N.
> +
>  config NETFILTER_XT_TARGET_TRACE
>  	tristate  '"TRACE" target support'
>  	depends on NETFILTER_XTABLES
> Index: linux-2.6.23/net/netfilter/Makefile
> ===================================================================
> --- linux-2.6.23.orig/net/netfilter/Makefile
> +++ linux-2.6.23/net/netfilter/Makefile
> @@ -50,6 +50,7 @@ obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG)
>  obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
>  obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
>  obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
> +obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
>  obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
>  obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
>
> Index: linux-2.6.23/net/netfilter/xt_TPROXY.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.23/net/netfilter/xt_TPROXY.c
> @@ -0,0 +1,92 @@
> +/*
> + * Transparent proxy support for Linux/iptables
> + *
> + * Copyright (c) 2006-2007 BalaBit IT Ltd.
> + * Author: Balazs Scheidler, Krisztian Kovacs
> + *
> + * This program is free software; you can redistribute it and/or
> modify + * it under the terms of the GNU General Public License version
> 2 as + * published by the Free Software Foundation.
> + *
> + */
> +#include <linux/module.h>
> +#include <linux/skbuff.h>
> +#include <linux/ip.h>
> +#include <net/checksum.h>
> +#include <net/inet_sock.h>
> +#include <net/udp.h>
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter/xt_TPROXY.h>
> +#include <net/netfilter/ipv4/nf_defrag_ipv4.h>
> +#include <net/netfilter/nf_tproxy_core.h>
> +
> +static unsigned int
> +tproxy_target(struct sk_buff **pskb, const struct net_device *in,
> +              const struct net_device *out, unsigned int hooknum,
> +              const struct xt_target *target, const void *targinfo)
> +{
> +	const struct xt_tproxy_info *tgi = targinfo;
> +	const struct iphdr *iph = ip_hdr(*pskb);
> +	struct sk_buff *skb = *pskb;
> +	struct udphdr _hdr, *hp;
> +	struct sock *sk;
> +
> +	/* TCP/UDP only */
> +	if (iph->protocol != IPPROTO_TCP && iph->protocol != IPPROTO_UDP)
> +		return NF_ACCEPT;
> +
> +	hp = skb_header_pointer(*pskb, ip_hdrlen(skb), sizeof(_hdr), &_hdr);
> +	if (hp == NULL)
> +		return NF_DROP;
> +
> +	sk = nf_tproxy_get_sock_v4(iph->protocol, iph->saddr,
> +	     tgi->laddr ? tgi->laddr : iph->daddr, hp->source,
> +	     tgi->lport ? tgi->lport : hp->dest, in, true);
> +
> +	/* NOTE: assign_sock consumes our sk reference */
> +	if (sk != NULL && nf_tproxy_assign_sock(skb, sk) != 0) {
> +		/*
> +		 * This should be in a separate target, but we do not do
> +		 * multiple targets on the same rule yet.
> +		 */
> +		skb->mark = (skb->mark & ~tgi->mark_mask) | tgi->mark_value;
> +
> +		pr_debug("redirecting: proto %u %08x:%u -> %08x:%u, mark: %x\n",
> +		         iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
> +		         ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
> +		return NF_ACCEPT;
> +	}
> +
> +	pr_debug("no socket, dropping: proto %u %08x:%u -> %08x:%u, mark:
> %x\n", +	         iph->protocol, ntohl(iph->daddr), ntohs(hp->dest),
> +	         ntohl(tgi->laddr), ntohs(tgi->lport), skb->mark);
> +	return NF_DROP;
> +}
> +
> +static struct xt_target xt_tproxy_reg = {
> +	.name       = "TPROXY",
> +	.family     = AF_INET,
> +	.table      = "mangle",
> +	.target     = tproxy_target,
> +	.targetsize = sizeof(struct xt_tproxy_info),
> +	.hooks      = 1 << NF_IP_PRE_ROUTING,
> +	.me         = THIS_MODULE,
> +};
> +
> +static int __init xt_tproxy_init(void)
> +{
> +	nf_defrag_ipv4_enable();
> +	return xt_register_target(&xt_tproxy_reg);
> +}
> +
> +static void __exit xt_tproxy_exit(void)
> +{
> +	xt_unregister_target(&xt_tproxy_reg);
> +}
> +
> +module_init(xt_tproxy_init);
> +module_exit(xt_tproxy_exit);
> +MODULE_AUTHOR("Krisztian Kovacs");
> +MODULE_DESCRIPTION("Netfilter transparent proxy (TPROXY) target
> module"); +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("ipt_TPROXY");
> -
> To unsubscribe from this list: send the line "unsubscribe
> netfilter-devel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
 KOVACS Krisztian
