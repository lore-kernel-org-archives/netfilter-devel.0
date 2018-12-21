From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 29/37] netfilter: conntrack: udp: only extend timeout to stream mode after 2s
Date: Fri, 21 Dec 2018 01:28:33 +0100
Message-ID: <20181221002841.28587-30-pablo@netfilter.org>
References: <20181221002841.28587-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181221002841.28587-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Currently DNS resolvers that send both A and AAAA queries from same source port
can trigger stream mode prematurely, which results in non-early-evictable conntrack entry
for three minutes, even though DNS requests are done in a few milliseconds.

Add a two second grace period where we continue to use the ordinary
30-second default timeout.  Its enough for DNS request/response traffic,
even if two request/reply packets are involved.

ASSURED is still set, else conntrack (and thus a possible
NAT mapping ...) gets zapped too in case conntrack table runs full.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h   |  5 +++++
 net/netfilter/nf_conntrack_proto_udp.c | 16 +++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 7e012312cd61..249d0a5b12b8 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -27,12 +27,17 @@
 
 #include <net/netfilter/nf_conntrack_tuple.h>
 
+struct nf_ct_udp {
+	unsigned long	stream_ts;
+};
+
 /* per conntrack: protocol private data */
 union nf_conntrack_proto {
 	/* insert conntrack proto private data here */
 	struct nf_ct_dccp dccp;
 	struct ip_ct_sctp sctp;
 	struct ip_ct_tcp tcp;
+	struct nf_ct_udp udp;
 	struct nf_ct_gre gre;
 	unsigned int tmpl_padto;
 };
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index c879d8d78cfd..9f2e05adba69 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -100,11 +100,21 @@ static int udp_packet(struct nf_conn *ct,
 	if (!timeouts)
 		timeouts = udp_get_timeouts(nf_ct_net(ct));
 
+	if (!nf_ct_is_confirmed(ct))
+		ct->proto.udp.stream_ts = 2 * HZ + jiffies;
+
 	/* If we've seen traffic both ways, this is some kind of UDP
-	   stream.  Extend timeout. */
+	 * stream. Set Assured.
+	 */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
-		nf_ct_refresh_acct(ct, ctinfo, skb,
-				   timeouts[UDP_CT_REPLIED]);
+		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
+
+		/* Still active after two seconds? Extend timeout. */
+		if (time_after(jiffies, ct->proto.udp.stream_ts))
+			extra = timeouts[UDP_CT_REPLIED];
+
+		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
-- 
2.11.0
