From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next] NAT: skip checksum on offload SCTP packets
Date: Mon,  5 Dec 2016 15:33:57 +0100
Message-ID: <d2c914edb023e502a839f8ff7037028311007cfe.1480948288.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbcLEPAD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Dec 2016 10:00:03 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SCTP GSO and hardware can do CRC32c computation after netfilter processing,
so we can avoid calling sctp_compute_checksum() on skb if skb->ip_summed
is equal to CHECKSUM_PARTIAL. Moreover, set skb->ip_summed to CHECKSUM_NONE
when the NAT code computes the CRC, to prevent offloaders from computing
it again (on ixgbe this resulted in a transmission with wrong L4 checksum).

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---

Notes:
    on a veth pair, where GSO is available and some performance evaluation
    can be done, a netperf SCTP_STREAM has been run recording the number
    of invocations of crc32c() versus the number of invocations of
    sctp_manip_pkt(), before and after the patch was applied:
    
      $perf record -e "probe:crc32c,probe:sctp_manip_pkt" -aR -- \
         $netperf -H $host -t SCTP_STREAM -p 2000 -l 30
    
      $perf script | grep crc32c | wc -l
      $perf script | grep sctp_manip_pkt | wc -l
    
      nf_nat_proto_sctp.c | crc32c hits | sctp_manip_pkt hits | throughput
     ---------------------+-------------+---------------------+------------
      unpatched           |       10493 |                3314 | 1.17 Gbit/s
      patched             |        6100 |                3326 | 1.19 Gbit/s

 net/netfilter/nf_nat_proto_sctp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_proto_sctp.c b/net/netfilter/nf_nat_proto_sctp.c
index 2e14108..31d3586 100644
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
2.7.4

