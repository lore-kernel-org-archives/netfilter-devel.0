From: Laurent Licour <laurent@licour.com>
Subject: [PATCH] netfilter : nfmark routing in OUTPUT, mangle, NFQUEUE
Date: Thu, 10 Jul 2008 07:45:32 +0200
Message-ID: <4875A1FC.8050705@licour.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:47908 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751354AbYGJFwW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 01:52:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patch let nfmark to be evaluated for routing decision for OUTPUT 
packet, in mangle
table, when process paquet in NFQUEUE
Until now, only change (in NFQUEUE process) on fields src_addr, 
dest_addr and tos
could make netfilter to reevalute the routing.
Similar code could also be applied to ipv6 code...


--- linux-2.6.18.i386.ori/net/ipv4/netfilter.c  2006-09-20 
05:42:06.000000000 +0200
+++ linux-2.6.18.i386/net/ipv4/netfilter.c      2008-07-07 
02:04:34.000000000 +0200
@@ -131,6 +131,9 @@
       u_int32_t daddr;
       u_int32_t saddr;
       u_int8_t tos;
+#ifdef CONFIG_IP_ROUTE_FWMARK
+       __u32 nfmark;
+#endif
};

static void nf_ip_saveroute(const struct sk_buff *skb, struct nf_info 
*info)
@@ -143,6 +146,9 @@
               rt_info->tos = iph->tos;
               rt_info->daddr = iph->daddr;
               rt_info->saddr = iph->saddr;
+#ifdef CONFIG_IP_ROUTE_FWMARK
+               rt_info->nfmark = skb->nfmark;
+#endif
       }
}

@@ -154,6 +160,9 @@
               struct iphdr *iph = (*pskb)->nh.iph;

               if (!(iph->tos == rt_info->tos
+#ifdef CONFIG_IP_ROUTE_FWMARK
+                     && (*pskb)->nfmark == rt_info->nfmark
+#endif
                     && iph->daddr == rt_info->daddr
                     && iph->saddr == rt_info->saddr))
                       return ip_route_me_harder(pskb);


