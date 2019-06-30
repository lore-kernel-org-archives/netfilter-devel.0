Return-Path: <SRS0=/adl=U5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56CC4C5B576
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Jun 2019 22:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F33F3208E4
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Jun 2019 22:29:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Dcx47k7h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfF3W3Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Jun 2019 18:29:16 -0400
Received: from secure35f.mail.yandex.net ([77.88.29.119]:52942 "EHLO
        secure35f.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbfF3W3Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Jun 2019 18:29:16 -0400
Received: from secure35f.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by secure35f.mail.yandex.net (Yandex) with ESMTP id D0B5E3A42CAE;
        Mon,  1 Jul 2019 01:29:11 +0300 (MSK)
Received: from mnt-myt.yandex.net (mnt-myt.yandex.net [77.88.1.115])
        by secure35f.mail.yandex.net (nwsmtp/Yandex) with ESMTP id 7dlNUXHbrj-T8SqSFV3;
        Mon, 01 Jul 2019 01:29:08 +0300
X-Yandex-Front: secure35f.mail.yandex.net
X-Yandex-TimeMark: 1561933748.693
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1561933748; bh=yC+03joC/7pq023tWRPdjGjHmRGLy9wb7CAq1PZ8qAE=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=Dcx47k7hxctYSNP6ndNXACODdKvi1KNfz3cwfPmkFb69NZSc11uTkXdyiujfbJs/D
         cDoaP9E9UpyputEm4ucoU+QpZfqRyMVKsMSX9uzFXE41Ct2LLhSb+uSSRRImvtZ0pj
         Nz2A1QD6S2EkKCM0Vf0ETSXoO6bRJiuUQfiWoLTQ=
X-Yandex-Suid-Status: 1 0,1 0,1 0,1 0,1 0
X-Yandex-Spam: 1
X-Yandex-Envelope: aGVsbz1tbnQtbXl0LnlhbmRleC5uZXQKbWFpbF9mcm9tPXZmZWRvcmVua29AeWFuZGV4LXRlYW0ucnUKcmNwdF90bz1qYUBzc2kuYmcKcmNwdF90bz1raGxlYm5pa292QHlhbmRleC10ZWFtLnJ1CnJjcHRfdG89cGFibG9AbmV0ZmlsdGVyLm9yZwpyY3B0X3RvPW5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcKcmNwdF90bz12ZmVkb3JlbmtvQHlhbmRleC10ZWFtLnJ1CnJlbW90ZV9ob3N0PW1udC1teXQueWFuZGV4Lm5ldApyZW1vdGVfaXA9NzcuODguMS4xMTUK
X-Yandex-Hint: bGFiZWw9U3lzdE1ldGthU086cGVvcGxlCmxhYmVsPVN5c3RNZXRrYVNPOnRydXN0XzYKbGFiZWw9U3lzdE1ldGthU086dF9wZW9wbGUKc2Vzc2lvbl9pZD03ZGxOVVhIYnJqLVQ4U3FTRlYzCmlwZnJvbT03Ny44OC4xLjExNQo=
From:   Vadim Fedorenko <vfedorenko@yandex-team.ru>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@yandex-team.ru>
Subject: [PATCH v2] ipvs: allow tunneling with gre encapsulation
Date:   Mon,  1 Jul 2019 01:28:49 +0300
Message-Id: <1561933729-5333-1-git-send-email-vfedorenko@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

windows real servers can handle gre tunnels, this patch allows
gre encapsulation with the tunneling method, thereby letting ipvs
be load balancer for windows-based services

Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
---
 include/uapi/linux/ip_vs.h      |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c  |  1 +
 net/netfilter/ipvs/ip_vs_xmit.c | 76 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index e4f1806..4102ddc 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -128,6 +128,7 @@
 enum {
 	IP_VS_CONN_F_TUNNEL_TYPE_IPIP = 0,	/* IPIP */
 	IP_VS_CONN_F_TUNNEL_TYPE_GUE,		/* GUE */
+	IP_VS_CONN_F_TUNNEL_TYPE_GRE,		/* GRE */
 	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
 };
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 84384d8..998353b 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -525,6 +525,7 @@ static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
 			port = dest->tun_port;
 			break;
 		case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
+		case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
 			port = 0;
 			break;
 		default:
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 71fc6d6..37cc674 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -29,6 +29,7 @@
 #include <linux/tcp.h>                  /* for tcphdr */
 #include <net/ip.h>
 #include <net/gue.h>
+#include <net/gre.h>
 #include <net/tcp.h>                    /* for csum_tcpudp_magic */
 #include <net/udp.h>
 #include <net/icmp.h>                   /* for icmp_send */
@@ -389,6 +390,13 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 			    skb->ip_summed == CHECKSUM_PARTIAL)
 				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
 		}
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+			__be16 tflags = 0;
+
+			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+				tflags |= TUNNEL_CSUM;
+			mtu -= gre_calc_hlen(tflags);
+		}
 		if (mtu < 68) {
 			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
 			goto err_put;
@@ -549,6 +557,13 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 			    skb->ip_summed == CHECKSUM_PARTIAL)
 				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
 		}
+		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+			__be16 tflags = 0;
+
+			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+				tflags |= TUNNEL_CSUM;
+			mtu -= gre_calc_hlen(tflags);
+		}
 		if (mtu < IPV6_MIN_MTU) {
 			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
 				     IPV6_MIN_MTU);
@@ -1079,6 +1094,24 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 	return 0;
 }
 
+static void
+ipvs_gre_encap(struct net *net, struct sk_buff *skb,
+	       struct ip_vs_conn *cp, __u8 *next_protocol)
+{
+	__be16 proto = *next_protocol == IPPROTO_IPIP ?
+				htons(ETH_P_IP) : htons(ETH_P_IPV6);
+	__be16 tflags = 0;
+	size_t hdrlen;
+
+	if (cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+		tflags |= TUNNEL_CSUM;
+
+	hdrlen = gre_calc_hlen(tflags);
+	gre_build_header(skb, hdrlen, tflags, proto, 0, 0);
+
+	*next_protocol = IPPROTO_GRE;
+}
+
 /*
  *   IP Tunneling transmitter
  *
@@ -1153,6 +1186,18 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
 	}
 
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		size_t gre_hdrlen;
+		__be16 tflags = 0;
+
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			tflags |= TUNNEL_CSUM;
+
+		gre_hdrlen = gre_calc_hlen(tflags);
+
+		max_headroom += gre_hdrlen;
+	}
+
 	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
 	dfp = sysctl_pmtu_disc(ipvs) ? &df : NULL;
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
@@ -1174,6 +1219,13 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 		}
 	}
 
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			gso_type |= SKB_GSO_GRE_CSUM;
+		else
+			gso_type |= SKB_GSO_GRE;
+	}
+
 	if (iptunnel_handle_offloads(skb, gso_type))
 		goto tx_error;
 
@@ -1194,6 +1246,8 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 		udp_set_csum(!check, skb, saddr, cp->daddr.ip, skb->len);
 	}
 
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE)
+		ipvs_gre_encap(net, skb, cp, &next_protocol);
 
 	skb_push(skb, sizeof(struct iphdr));
 	skb_reset_network_header(skb);
@@ -1289,6 +1343,18 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
 	}
 
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		size_t gre_hdrlen;
+		__be16 tflags = 0;
+
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			tflags |= TUNNEL_CSUM;
+
+		gre_hdrlen = gre_calc_hlen(tflags);
+
+		max_headroom += gre_hdrlen;
+	}
+
 	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
 					 &next_protocol, &payload_len,
 					 &dsfield, &ttl, NULL);
@@ -1308,6 +1374,13 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 		}
 	}
 
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
+		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
+			gso_type |= SKB_GSO_GRE_CSUM;
+		else
+			gso_type |= SKB_GSO_GRE;
+	}
+
 	if (iptunnel_handle_offloads(skb, gso_type))
 		goto tx_error;
 
@@ -1328,6 +1401,9 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
 		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
 	}
 
+	if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE)
+		ipvs_gre_encap(net, skb, cp, &next_protocol);
+
 	skb_push(skb, sizeof(struct ipv6hdr));
 	skb_reset_network_header(skb);
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-- 
1.9.1

