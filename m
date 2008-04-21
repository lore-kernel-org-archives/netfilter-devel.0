From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Ebtables-devel]  [PATCH 2/2] Add IPv6 support
Date: Mon, 21 Apr 2008 16:41:05 +0200
Message-ID: <480CA781.6020602@trash.net>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net><3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com><3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com><1201303354.2909.1.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr> <3F25FE8C477E9E4FB3D42C2FF937C08A8D090D@orsmsx423.amr.corp.intel.com> <3F25FE8C477E9E4FB3D42C2FF937C08A8D0B6D@orsmsx423.amr.corp.intel.com> <47FBAD77.2050701@trash.net> <3F25FE8C477E9E4FB3D42C2FF937C08AC9B75E@orsmsx423.amr.corp.intel.com> <3F25FE8C477E9E4FB3D42C2FF937C08AD619F1@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020307020805010202020807"
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>,
	ebtables-devel@lists.sourceforge.net
To: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42444 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYDUOlM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:41:12 -0400
In-Reply-To: <3F25FE8C477E9E4FB3D42C2FF937C08AD619F1@orsmsx423.amr.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020307020805010202020807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Tseng, Kuo-Lang wrote:
> Please try out the updated patch. It has fixed the coding style errors
> and added protocol checks for UDPLITE, and shared the TCP/UDP/.. logging
> part. 


Thanks. Unfortunately you've missed the networking merge window by
a few days. I've queued your patch for 2.6.27 with the attached
whitespace and sparse fixes.



--------------020307020805010202020807
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 7fc44ae..36efb3a 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -7,7 +7,7 @@
  *	Jan Engelhardt <jengelh@computergmbh.de>
  *
  * Summary:
- * This is just a modification of the IPv4 code written by 
+ * This is just a modification of the IPv4 code written by
  * Bart De Schuymer <bdschuym@pandora.be>
  * with the changes required to support IPv6
  *
@@ -23,8 +23,8 @@
 #include <net/dsfield.h>
 
 struct tcpudphdr {
-	uint16_t src;
-	uint16_t dst;
+	__be16 src;
+	__be16 dst;
 };
 
 static int ebt_filter_ip6(const struct sk_buff *skb,
@@ -47,14 +47,14 @@ static int ebt_filter_ip6(const struct sk_buff *skb,
 	   FWINV(info->tclass != ipv6_get_dsfield(ih6), EBT_IP6_TCLASS))
 		return EBT_NOMATCH;
 	for (i = 0; i < 4; i++)
-		tmp_addr.in6_u.u6_addr32[i] = ih6->saddr.in6_u.u6_addr32[i] & 
+		tmp_addr.in6_u.u6_addr32[i] = ih6->saddr.in6_u.u6_addr32[i] &
 			info->smsk.in6_u.u6_addr32[i];
 	if (info->bitmask & EBT_IP6_SOURCE &&
-		FWINV((ipv6_addr_cmp(&tmp_addr, &info->saddr) != 0), 
+		FWINV((ipv6_addr_cmp(&tmp_addr, &info->saddr) != 0),
 			EBT_IP6_SOURCE))
 		return EBT_NOMATCH;
 	for (i = 0; i < 4; i++)
-		tmp_addr.in6_u.u6_addr32[i] = ih6->daddr.in6_u.u6_addr32[i] & 
+		tmp_addr.in6_u.u6_addr32[i] = ih6->daddr.in6_u.u6_addr32[i] &
 			info->dmsk.in6_u.u6_addr32[i];
 	if (info->bitmask & EBT_IP6_DEST &&
 	   FWINV((ipv6_addr_cmp(&tmp_addr, &info->daddr) != 0), EBT_IP6_DEST))
@@ -71,7 +71,7 @@ static int ebt_filter_ip6(const struct sk_buff *skb,
 		if (!(info->bitmask & EBT_IP6_DPORT) &&
 		    !(info->bitmask & EBT_IP6_SPORT))
 			return EBT_MATCH;
-		pptr = skb_header_pointer(skb, offset_ph, sizeof(_ports), 
+		pptr = skb_header_pointer(skb, offset_ph, sizeof(_ports),
 					  &_ports);
 		if (pptr == NULL)
 			return EBT_NOMATCH;
@@ -84,7 +84,7 @@ static int ebt_filter_ip6(const struct sk_buff *skb,
 		if (info->bitmask & EBT_IP6_SPORT) {
 			u32 src = ntohs(pptr->src);
 			if (FWINV(src < info->sport[0] ||
-			    	  src > info->sport[1], EBT_IP6_SPORT))
+				  src > info->sport[1], EBT_IP6_SPORT))
 			return EBT_NOMATCH;
 		}
 		return EBT_MATCH;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index ba132e5..c883ec8 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -124,7 +124,7 @@ ebt_log_packet(unsigned int pf, unsigned int hooknum,
 	}
 
 	if ((bitmask & EBT_LOG_IP6) && eth_hdr(skb)->h_proto ==
-	   htons(ETH_P_IPV6)){
+	   htons(ETH_P_IPV6)) {
 		const struct ipv6hdr *ih;
 		struct ipv6hdr _iph;
 		uint8_t nexthdr;

--------------020307020805010202020807--
