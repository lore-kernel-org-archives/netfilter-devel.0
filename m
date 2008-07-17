From: Laurent Licour <laurent@licour.com>
Subject: Re: [PATCH] netfilter : nfmark routing in OUTPUT, mangle, NFQUEUE
Date: Thu, 17 Jul 2008 10:00:56 +0200
Message-ID: <487EFC38.4030709@licour.com>
References: <4875A1FC.8050705@licour.com> <487C7B6F.8010802@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010402010700070804090700"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:55350 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752798AbYGQIIC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 04:08:02 -0400
In-Reply-To: <487C7B6F.8010802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010402010700070804090700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


> Please resend against the current kernel tree if you want me to
> apply this. Also it appears the patch is whitespace damaged,
> please make sure you'll send it in a way that doesn't corrupt
> it (f.i. as attachment).

Here is the patch against the 2.6.26-stable



--------------010402010700070804090700
Content-Type: text/plain;
 name="netfilter.nfmark.output.mangle.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netfilter.nfmark.output.mangle.patch"

--- linux-2.6.26/net/ipv4/netfilter.c.ori	2008-07-15 22:39:02.000000000 +0200
+++ linux-2.6.26/net/ipv4/netfilter.c	2008-07-16 18:10:14.000000000 +0200
@@ -121,6 +121,7 @@
 	__be32 daddr;
 	__be32 saddr;
 	u_int8_t tos;
+	__u32 mark;
 };
 
 static void nf_ip_saveroute(const struct sk_buff *skb,
@@ -134,6 +135,7 @@
 		rt_info->tos = iph->tos;
 		rt_info->daddr = iph->daddr;
 		rt_info->saddr = iph->saddr;
+		rt_info->mark = skb->mark;
 	}
 }
 
@@ -146,6 +148,7 @@
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (!(iph->tos == rt_info->tos
+		      && skb->mark == rt_info->mark
 		      && iph->daddr == rt_info->daddr
 		      && iph->saddr == rt_info->saddr))
 			return ip_route_me_harder(skb, RTN_UNSPEC);

--------------010402010700070804090700--
