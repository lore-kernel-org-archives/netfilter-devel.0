From: Ana Rey <anarey@gmail.com>
Subject: [PATCH v4] netfilter: nf_tables: add pkttype support to meta expression
Date: Wed,  6 Aug 2014 13:52:49 +0200
Message-ID: <1407325969-14531-1-git-send-email-anarey@gmail.com>
References: <1402643720-6915-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?q?=C3=81lvaro=20Neira=20Ayuso?= <alvaroneay@gmail.com>,
	Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:32834 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaHFLuw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:50:52 -0400
Received: by mail-wi0-f169.google.com with SMTP id n3so9368836wiv.4
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2014 04:50:51 -0700 (PDT)
In-Reply-To: <1402643720-6915-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46rom: =C3=81lvaro Neira Ayuso <alvaroneay@gmail.com>

Add pkttype support for ip, ipv6 and inet families of tables.

This allows you to fetch the meta packet type based on the link layer
information. The loopback traffic is a special case, the packet type
is guessed from the network layer header.

No special handling for bridge and arp since we're not going to see
such traffic in the loopback interface.

Joint work with Alvaro Neira Ayuso <alvaroneay@gmail.com>

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Signed-off-by: Ana Rey <anarey@gmail.com>

---

[Changes in v4:]
* Improvements in the description of this path.
* Replace the PACKET_HOST by PACKET_BROADCAST so this looks
exactly like xt_pkttype
* Remove NFPROTO_INET because the pkt->ops->pf is already allowing
you to indentify this family.

These improvements were suggested by Pablo Neira.

[Changes in v3:]
* Add support for NFPROTO_INET when handing the loopback case.
(NFPROTO_BRIDGE and NFPROTO_ARP families do not make sense when
handing the loopback case)

* Delete the broadcast case when handing the lookback case. This does n=
ot make
sense.

* Fix the description of NFT_META_PKTTYPE key.

[Changes in v2]
Put "case NFT_META_PKTTYPE:" outside of the #ifdef CONFIG_NETWORK_SECMA=
RK.
It was a mistake.
Thanks to Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> for
reporting this mistake.


 include/uapi/linux/netfilter/nf_tables.h |    2 ++
 net/netfilter/nft_meta.c                 |   27 ++++++++++++++++++++++=
+++++
 2 files changed, 29 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/li=
nux/netfilter/nf_tables.h
index 801bdd1..72ad208 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -571,6 +571,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_PKTTYPE: Packet type
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
index 852b178..dbf7fe1 100644
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
@@ -124,6 +127,29 @@ void nft_meta_get_eval(const struct nft_expr *expr=
,
 		dest->data[0] =3D skb->secmark;
 		break;
 #endif
+	case NFT_META_PKTTYPE:
+		if (skb->pkt_type !=3D PACKET_LOOPBACK) {
+			dest->data[0] =3D skb->pkt_type;
+			break;
+		}
+
+		switch (pkt->ops->pf) {
+		case NFPROTO_IPV4:
+			if (ipv4_is_multicast(ip_hdr(skb)->daddr))
+				dest->data[0] =3D PACKET_MULTICAST;
+			else
+				dest->data[0] =3D PACKET_BROADCAST;
+			break;
+		case NFPROTO_IPV6:
+			if (ipv6_hdr(skb)->daddr.s6_addr[0] =3D=3D 0xFF)
+				dest->data[0] =3D PACKET_MULTICAST;
+			else
+				dest->data[0] =3D PACKET_BROADCAST;
+			break;
+		default:
+			goto err;
+		}
+		break;
 	default:
 		WARN_ON(1);
 		goto err;
@@ -195,6 +221,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
 #endif
+	case NFT_META_PKTTYPE:
 		break;
 	default:
 		return -EOPNOTSUPP;
--=20
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
