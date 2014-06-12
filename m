From: Ana Rey <anarey@gmail.com>
Subject: [PATCH] netfilter: nf_tables: add pktype support to meta expression
Date: Thu, 12 Jun 2014 19:17:52 +0200
Message-ID: <1402593473-4904-2-git-send-email-anarey@gmail.com>
References: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ana Rey <anarey@gmail.com>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33436 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFLRSI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:18:08 -0400
Received: by mail-wg0-f41.google.com with SMTP id a1so1575384wgh.0
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2014 10:18:07 -0700 (PDT)
In-Reply-To: <1402593473-4904-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joint work with =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Ana Rey <anarey@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_meta.c                 | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/li=
nux/netfilter/nf_tables.h
index 2a88f64..9eb5153 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -571,6 +571,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_PKTTYPE: Packet class
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -592,6 +593,7 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_PKTTYPE,
 };
=20
 /**
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 852b178..1d9d5b3 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -14,6 +14,9 @@
 #include <linux/netlink.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_tables.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <net/dst.h>
 #include <net/sock.h>
 #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
@@ -124,6 +127,19 @@ void nft_meta_get_eval(const struct nft_expr *expr=
,
 		dest->data[0] =3D skb->secmark;
 		break;
 #endif
+	case NFT_META_PKTTYPE:
+		dest->data[0] =3D skb->pkt_type;
+		if (skb->pkt_type !=3D PACKET_LOOPBACK)
+			dest->data[0] =3D skb->pkt_type;
+		else if (expr->ops->type->family =3D=3D NFPROTO_IPV4 &&
+			 ipv4_is_multicast(ip_hdr(skb)->daddr))
+			dest->data[0] =3D PACKET_MULTICAST;
+		else if (expr->ops->type->family =3D=3D NFPROTO_IPV6 &&
+			 ipv6_hdr(skb)->daddr.s6_addr[0] =3D=3D 0xFF)
+			dest->data[0] =3D PACKET_MULTICAST;
+		else
+			dest->data[0] =3D PACKET_BROADCAST;
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -194,6 +210,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
+	case NFT_META_PKTTYPE:
 #endif
 		break;
 	default:
--=20
2.0.0

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
