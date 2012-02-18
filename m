From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] SSDP (UPnP) conntrack helper
Date: Sat, 18 Feb 2012 11:09:43 -0600
Message-ID: <jhom0o$548$1@dough.gmane.org>
References: <jhkpju$dsp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080604020306030503030501"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47659 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752941Ab2BRRKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Feb 2012 12:10:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1RynnJ-0005Oi-BA
	for netfilter-devel@vger.kernel.org; Sat, 18 Feb 2012 18:09:57 +0100
Received: from pool-71-252-228-112.dllstx.fios.verizon.net ([71.252.228.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Feb 2012 18:09:57 +0100
Received: from arequipeno by pool-71-252-228-112.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 18 Feb 2012 18:09:57 +0100
In-Reply-To: <jhkpju$dsp$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080604020306030503030501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 02/16/2012 11:46 PM, Ian Pilcher wrote:
> 6.  In the vast majority of cases, any responses should come from media
>     servers on the same subnet as the interface through which the query
>     is sent, so it seems like it might make sense to only accept
>     responses from the local subnet, unless overridden with a module
>     parameter.  The source address is easily accessible, but I'll need
>     to access its associated subnet mask.  What is the proper way to
>     access this information through the skb?  (That __rcu in struct
>     net_device makes me think I should be careful.)

Attached is a new version of the module, which enforces the subnet match
that I described (modulo a parameter to turn off the restriction).  I'm
using in_dev_get()/in_dev_put() to access the IP address information via
skb->dev.

Is this approach correct, or do I need to do additional RCU-related
stuff to safely iterate through the IP addresses?

Still hoping for some help with the other questions in my previous note.

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
"If you're going to shift my paradigm ... at least buy me dinner first."
========================================================================

--------------080604020306030503030501
Content-Type: text/x-csrc;
 name="nf_conntrack_ssdp.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="nf_conntrack_ssdp.c"

/*
 * nf_conntrack_ssdp.c - netfilter connection tracking helper for UPnP SSDP
 * 
 * Copyright 2012 Ian Pilcher <arequipeno@gmail.com>
 * 
 * This program is free software. You can redistribute it or modify it
 * under the terms of version 2 of the GNU General Public License, as
 * published by the Free Software Foundation.
 */

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/udp.h>
#include <linux/inetdevice.h>

#include <net/netfilter/nf_conntrack_helper.h>
#include <net/netfilter/nf_conntrack_expect.h>

#define SSDP_MCAST_ADDR		0xeffffffa	/* 239.255.255.250 - host byte order */
#define SSDP_UDP_PORT		1900
#define SSDP_M_SEARCH		"M-SEARCH"
#define SSDP_M_SEARCH_SIZE	(sizeof SSDP_M_SEARCH - 1)

MODULE_LICENSE("GPL v2");
MODULE_AUTHOR("Ian Pilcher <arequipeno@gmail.com>");
MODULE_DESCRIPTION("SSDP connection tracking helper");
MODULE_ALIAS("ip_conntrack_ssdp");
MODULE_ALIAS_NFCT_HELPER("ssdp");

static __be32 ssdp_src_netmask(const struct sk_buff *skb,
			       const struct nf_conntrack_tuple *orig)
{
	struct in_device *dev;
	const struct in_ifaddr *addr;
	__be32 ret = 0;		/* indicates failure (0.0.0.0 is not a valid netmask) */
	
	if ((dev = in_dev_get(skb->dev)) == NULL) {
		pr_warn("Device %s has no IPv4 addresses assigned\n", skb->dev->name);
		return ret;	/* 0 */
	}
	
	for (addr = dev->ifa_list; addr != NULL; addr = addr->ifa_next) {
		if (addr->ifa_local == orig->src.u3.ip) {
			pr_debug("ssdp_netmask: found netmask %pI4 for address %pI4 on device %s\n",
				 &addr->ifa_mask, &orig->src.u3.ip, addr->ifa_label);
			ret = addr->ifa_mask;
			break;
		}
	}
	
	if (ret == 0) {
		pr_warn("M-SEARCH source address %pI4 not assigned to device %s\n",
			&orig->src.u3.ip, skb->dev->name);
	}
	
	in_dev_put(dev);
	return ret;
}
		
static int ssdp_help(struct sk_buff *skb,
		     unsigned int protoff,
		     struct nf_conn *ct,
		     enum ip_conntrack_info ctinfo)
{
	struct nf_conntrack_expect *expect;
	struct nf_conntrack_tuple *tuple;
	char udpdata_buffer[SSDP_M_SEARCH_SIZE];
	char *udpdata;
	__be32 netmask;
	
	tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
	pr_debug("ssdp_help: %pI4:%hu --> %pI4:%hu\n",
		 &tuple->src.u3.ip, be16_to_cpu(tuple->src.u.udp.port),
		 &tuple->dst.u3.ip, be16_to_cpu(tuple->dst.u.udp.port));
	
	if (tuple->dst.u3.ip != cpu_to_be32(SSDP_MCAST_ADDR)) {
		pr_debug("ssdp_help: destination address != 239.255.255.250; ignoring\n");
		return NF_ACCEPT;
	}
	
	udpdata = skb_header_pointer(skb, protoff + sizeof(struct udphdr),
				     sizeof udpdata_buffer, &udpdata_buffer);
	if (udpdata == NULL) {
		pr_debug("ssdp_help: UDP payload too small for M-SEARCH; ignoring\n");
		return NF_ACCEPT;
	}
	
	if (memcmp(udpdata, SSDP_M_SEARCH, SSDP_M_SEARCH_SIZE) != 0) {
		pr_debug("ssdp_help: UDP payload does not begin with 'M-SEARCH'; ignoring\n");
		return NF_ACCEPT;
	}
	
	if ((netmask = ssdp_src_netmask(skb, tuple)) == 0)
		return NF_DROP;		/* ssdp_src_netmask prints warning on failure */
	
	if ((expect = nf_ct_expect_alloc(ct)) == NULL) {
		pr_warn("Memory allocation failure\n");
		return NF_DROP;
	}

	expect->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
	expect->tuple.src.u3.ip = expect->tuple.dst.u3.ip;
	memset(&expect->mask, 0, sizeof expect->mask);
	expect->mask.src.u3.ip = netmask;
	expect->mask.src.u.udp.port = 0xffff;	/* byte order doesn't matter */
	expect->expectfn = NULL;
	expect->flags = 0;
	expect->class = NF_CT_EXPECT_CLASS_DEFAULT;
	expect->helper = NULL;
	
	nf_ct_expect_related(expect);
	nf_ct_expect_put(expect);
	
	return NF_ACCEPT;
}

static const struct nf_conntrack_expect_policy ssdp_policy = {
	.max_expected	= 1,
	.timeout	= 1,
	.name 		= "ssdp",
};

static struct nf_conntrack_helper __read_mostly ssdp_helper = {
	.name 			= "ssdp",
	.tuple.src.l3num 	= NFPROTO_IPV4,
	.tuple.src.u.udp.port	= cpu_to_be16(SSDP_UDP_PORT),
	.tuple.dst.protonum 	= IPPROTO_UDP,
	.me			= THIS_MODULE,
	.help			= ssdp_help,
	.expect_policy		= &ssdp_policy,
};

static int __init nf_conntrack_ssdp_init(void)
{
	return nf_conntrack_helper_register(&ssdp_helper);
}

static void __exit nf_conntrack_ssdp_exit(void)
{
	nf_conntrack_helper_unregister(&ssdp_helper);
}

module_init(nf_conntrack_ssdp_init);
module_exit(nf_conntrack_ssdp_exit);

--------------080604020306030503030501--

