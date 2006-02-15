From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: nf_conntrack: Fix TCP/UDP HW checksum handling
	for IPv6 packet
Date: Thu, 16 Feb 2006 00:00:33 +0100 (MET)
Message-ID: <20060215230033.25078.39539.sendpatchset@localhost.localdomain>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: Fix TCP/UDP HW checksum handling for IPv6 packet

If skb->ip_summed is CHECKSUM_HW here, skb->csum includes checksum
of actual IPv6 header and extension headers. Then such excess
checksum must be subtruct when nf_conntrack calculates TCP/UDP checksum
with pseudo IPv6 header. Spotted by Ben Skeggs.

Signeded-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signeded-off-by: Patrick McHardy <kaber@trash.net>

---
commit ede836cd3164896d741dff1a8d7c1dc0b9b1fdf6
tree a2503b7297d25266e6d06a7f17ce5b7e740fd42a
parent a01ef7ba3866e0c920f804f153166f162bcb2a1f
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 15 Feb 2006 11:13:55 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 15 Feb 2006 11:13:55 +0100

 net/netfilter/nf_conntrack_proto_tcp.c |    4 +++-
 net/netfilter/nf_conntrack_proto_udp.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index df99138..6492ed6 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -864,7 +864,9 @@ static int csum6(const struct sk_buff *s
 {
 	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
 			       skb->len - dataoff, IPPROTO_TCP,
-			       skb->ip_summed == CHECKSUM_HW ? skb->csum
+			       skb->ip_summed == CHECKSUM_HW
+			       ? csum_sub(skb->csum,
+					  skb_checksum(skb, 0, dataoff, 0))
 			       : skb_checksum(skb, dataoff, skb->len - dataoff,
 					      0));
 }
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 4264dd0..831d206 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -161,7 +161,9 @@ static int csum6(const struct sk_buff *s
 {
 	return csum_ipv6_magic(&skb->nh.ipv6h->saddr, &skb->nh.ipv6h->daddr,
 			       skb->len - dataoff, IPPROTO_UDP,
-			       skb->ip_summed == CHECKSUM_HW ? skb->csum
+			       skb->ip_summed == CHECKSUM_HW
+			       ? csum_sub(skb->csum,
+					  skb_checksum(skb, 0, dataoff, 0))
 			       : skb_checksum(skb, dataoff, skb->len - dataoff,
 					      0));
 }
