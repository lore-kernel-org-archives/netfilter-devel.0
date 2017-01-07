From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/2] netfilter: nft_meta: deal with PACKET_LOOPBACK in netdev family
Date: Sat,  7 Jan 2017 21:33:55 +0800
Message-ID: <1483796035-54792-2-git-send-email-zlpnobody@163.com>
References: <1483796035-54792-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:51360 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932596AbdAGNep (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Jan 2017 08:34:45 -0500
In-Reply-To: <1483796035-54792-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

After adding the following nft rule, then ping 224.0.0.1:
  # nft add rule netdev t c pkttype host counter

The warning complain message will be printed out again and again:
  WARNING: CPU: 0 PID: 10182 at net/netfilter/nft_meta.c:163 \
           nft_meta_get_eval+0x3fe/0x460 [nft_meta]
  [...]
  Call Trace:
  <IRQ>
  dump_stack+0x85/0xc2
  __warn+0xcb/0xf0
  warn_slowpath_null+0x1d/0x20
  nft_meta_get_eval+0x3fe/0x460 [nft_meta]
  nft_do_chain+0xff/0x5e0 [nf_tables]

So we should deal with PACKET_LOOPBACK in netdev family too. For ipv4,
convert it to PACKET_BROADCAST/MULTICAST according to the destination
address's type; For ipv6, convert it to PACKET_MULTICAST directly.

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_meta.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 9a22b24..e1f5ca9 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -156,8 +156,34 @@ void nft_meta_get_eval(const struct nft_expr *expr,
 		case NFPROTO_IPV6:
 			*dest = PACKET_MULTICAST;
 			break;
+		case NFPROTO_NETDEV:
+			switch (skb->protocol) {
+			case htons(ETH_P_IP): {
+				int noff = skb_network_offset(skb);
+				struct iphdr *iph, _iph;
+
+				iph = skb_header_pointer(skb, noff,
+							 sizeof(_iph), &_iph);
+				if (!iph)
+					goto err;
+
+				if (ipv4_is_multicast(iph->daddr))
+					*dest = PACKET_MULTICAST;
+				else
+					*dest = PACKET_BROADCAST;
+
+				break;
+			}
+			case htons(ETH_P_IPV6):
+				*dest = PACKET_MULTICAST;
+				break;
+			default:
+				WARN_ON_ONCE(1);
+				goto err;
+			}
+			break;
 		default:
-			WARN_ON(1);
+			WARN_ON_ONCE(1);
 			goto err;
 		}
 		break;
-- 
2.5.5


