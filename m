From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 44/50] netfilter: nat: skip checksum on offload SCTP packets
Date: Wed,  7 Dec 2016 22:52:50 +0100
Message-ID: <1481147576-5690-45-git-send-email-pablo@netfilter.org>
References: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1481147576-5690-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

SCTP GSO and hardware can do CRC32c computation after netfilter processing,
so we can avoid calling sctp_compute_checksum() on skb if skb->ip_summed
is equal to CHECKSUM_PARTIAL. Moreover, set skb->ip_summed to CHECKSUM_NONE
when the NAT code computes the CRC, to prevent offloaders from computing
it again (on ixgbe this resulted in a transmission with wrong L4 checksum).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto_sctp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index 2e14108ff697..31d358691af0 100644
--- a/net/netfilter/nf_nat_proto_sctp.c
+++ b/net/netfilter/nf_nat_proto_sctp.c
@@ -47,7 +47,10 @@ sctp_manip_pkt(struct sk_buff *skb,
 		hdr->dest = tuple->dst.u.sctp.port;
 	}
 
-	hdr->checksum = sctp_compute_cksum(skb, hdroff);
+	if (skb->ip_summed != CHECKSUM_PARTIAL) {
+		hdr->checksum = sctp_compute_cksum(skb, hdroff);
+		skb->ip_summed = CHECKSUM_NONE;
+	}
 
 	return true;
 }
-- 
2.1.4
