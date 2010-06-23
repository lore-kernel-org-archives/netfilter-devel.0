From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: ipt_LOG/ip6t_LOG: add option to print decoded MAC
 header
Date: Wed, 23 Jun 2010 18:47:20 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006231840180.21618@obet.zrqbmnf.qr>
References: <4C22324E.2060404@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40231 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab0FWQrV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:47:21 -0400
In-Reply-To: <4C22324E.2060404@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-06-23 18:11, Patrick McHardy wrote:

>+	switch (dev->type) {
>+	case ARPHRD_ETHER:
>+		printk("MACSRC=%pM MACDST=%pM MACPROTO=%.4x ",
>+		       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
>+		       ntohs(eth_hdr(skb)->h_proto));

Why not just the standard %04x? [Same applies to v6]

>+	printk("MAC=");
>+	if (dev->hard_header_len &&
>+	    skb->mac_header != skb->network_header) {
>+		const unsigned char *p = skb_mac_header(skb);
>+		unsigned int i;
>+
>+		for (i = 0; i < dev->hard_header_len; i++, p++)
>+			printk("%02x%c", *p,
>+			       i == dev->hard_header_len - 1 ? ' ' : ':');

		if (dev->hard_header_len > 0)
			printk("%02x", *p++);
		for (i = 1; i < dev->hard_header_len; ++i)
			printk(":%02x", *p++);

I like better for getting rid of the comparison inside the loop.

>+	/* MAC logging for input chain only. */

"input path".

>+	if (in && !out)
>+		dump_mac_header(loginfo, skb);
> 
> 	dump_packet(loginfo, skb, 0);

# ipv6
> 	printk("\n");
>+	if (dev->hard_header_len &&
>+	    skb->mac_header != skb->network_header) {
>+		const unsigned char *p = skb_mac_header(skb);
>+		unsigned int len = dev->hard_header_len;
>+		unsigned int i;
>+
>+		if (dev->type == ARPHRD_SIT &&
>+		    (p -= ETH_HLEN) < skb->head)
>+			p = NULL;

What is the purpose of this? If the device is a sit, there is no
guarantee that there's any ethernet header in the skb.

