From: Ian Pilcher <arequipeno@gmail.com>
Subject: [RFC] SSDP (UPnP) conntrack helper
Date: Thu, 16 Feb 2012 23:46:38 -0600
Message-ID: <jhkpju$dsp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000409010102060900010507"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41001 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab2BQFqw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Feb 2012 00:46:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1RyGeg-0004b8-HF
	for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2012 06:46:50 +0100
Received: from pool-71-252-228-112.dllstx.fios.verizon.net ([71.252.228.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2012 06:46:50 +0100
Received: from arequipeno by pool-71-252-228-112.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2012 06:46:50 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000409010102060900010507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached is my first crack at a conntrack helper for SSDP, which is used
by DLNA/UPnP clients to discover media servers.

This is the first time I've ever tried to write a kernel module, let
alone a netfilter conntrack helper, so I have a number of questions:

1.  Most obviously, have I done anything egregiously wrong?

    I have tried to follow the general framework of nf_conntrack_tftp.c
    and the DHCPv6 helper that Darren Willis has been working on, along
    with the (very limited) documentation that I could find.

2.  What is the significance of nf_conntrack_expect_policy.max_expected?

    I have set this to 1, but VLC is able to discover both of the media
    servers on my network, which seems to indicate that the expectation
    is not being removed when the first response is received.

3.  Does nf_conntrack_expect_policy.timeout have the same meaning as the
    old ip_conntrack_helper.timeout field (as described in the Hacking
    HOWTO)?

4.  Am I using the appropriate values for expect->flags and
    expect->class?  (Are the possible values and their meanings
    documented anywhere?)

5.  What is the effect of the return value of the helper function?

    I've followed the example of the TFTP helper and returned NF_DROP if
    nf_ct_allow() fails.  Does this mean that the outgoing packet will
    dropped?  (I guess this makes sense, if the response won't make it
    through.)

6.  In the vast majority of cases, any responses should come from media
    servers on the same subnet as the interface through which the query
    is sent, so it seems like it might make sense to only accept
    responses from the local subnet, unless overridden with a module
    parameter.  The source address is easily accessible, but I'll need
    to access its associated subnet mask.  What is the proper way to
    access this information through the skb?  (That __rcu in struct
    net_device makes me think I should be careful.)

7.  I intend to add IPv6 support, which means I won't be able to get
    away with bitwise operations on 32-bit ints.  Are there any helper
    functions available to assist with manipulating/comparing IPv6
    addresses?

Thanks in advance for your feedback!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
"If you're going to shift my paradigm ... at least buy me dinner first."
========================================================================

--------------000409010102060900010507
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
 * This program is free software. You can redistribute it and/or modify
 * it under the terms of the GNU General Public License, version 2, as
 * published by the Free Software Foundation.
 */

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/udp.h>

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

static int ssdp_help(struct sk_buff *skb,
		     unsigned int protoff,
		     struct nf_conn *ct,
		     enum ip_conntrack_info ctinfo)
{
	struct nf_conntrack_expect *expect;
	struct nf_conntrack_tuple *tuple;
	char udpdata_buffer[SSDP_M_SEARCH_SIZE];
	char *udpdata;
	
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
	
	if ((expect = nf_ct_expect_alloc(ct)) == NULL) {
		pr_warn("Memory allocation failure\n");
		return NF_DROP;
	}

	expect->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
	memset(&expect->mask, 0, sizeof expect->mask);
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
	.max_expected = 1,
	.timeout = 1,
	.name = "ssdp",
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

--------------000409010102060900010507--

