From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: ipset: fix linking with CONFIG_IPV6=n
Date: Wed, 02 Feb 2011 09:46:20 +0100
Message-ID: <4D4919DC.20406@trash.net>
References: <4D49188B.2030002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060502050206050805090902"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63210 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab1BBIqe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 03:46:34 -0500
In-Reply-To: <4D49188B.2030002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060502050206050805090902
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

[resend with netfilter-devel CCed instead of netfilter]

On 02.02.2011 09:40, Patrick McHardy wrote:
> Add some #ifdefs to unconditionally return false in
> ip_set_get_ip6_port() when CONFIG_IPV6=n and convert
> to ipv6_skip_exthdr() to avoid pulling in the ip6_tables
> module when loading ipset.
> 
> A slightly more code-saving alternative would be to add
> a dummy inline function or ifdef the callsites. Please
> let me know which way you prefer.
> 


--------------060502050206050805090902
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="05.diff"

diff --git a/net/netfilter/ipset/ip_set_getport.c b/net/netfilter/ipset/ip_set_getport.c
index 4dd2785..5ea0736 100644
--- a/net/netfilter/ipset/ip_set_getport.c
+++ b/net/netfilter/ipset/ip_set_getport.c
@@ -13,6 +13,7 @@
 #include <linux/icmpv6.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/ip.h>
+#include <net/ipv6.h>
 
 #include <linux/netfilter/ipset/ip_set_getport.h>
 
@@ -97,15 +98,19 @@ bool
 ip_set_get_ip6_port(const struct sk_buff *skb, bool src,
 		    __be16 *port, u8 *proto)
 {
-	unsigned int protooff = 0;
-	int protocol;
-	unsigned short fragoff;
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
+	int protoff;
+	u8 nexthdr;
 
-	protocol = ipv6_find_hdr(skb, &protooff, -1, &fragoff);
-	if (protocol <= 0 || fragoff)
+	nexthdr = ipv6_hdr(skb)->nexthdr;
+	protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &nexthdr);
+	if (protoff < 0)
 		return false;
 
-	return get_port(skb, protocol, protooff, src, port, proto);
+	return get_port(skb, nexthdr, protoff, src, port, proto);
+#else
+	return false;
+#endif
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ip6_port);
 

--------------060502050206050805090902--
