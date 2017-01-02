From: Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH nf-next 2/2] netfilter: conntrack: validate SCTP crc32c in PREROUTING
Date: Mon,  2 Jan 2017 13:29:41 +0100
Message-ID: <a4232d3c9f85c11129cd0292e82d2c81a005096d.1483355460.git.dcaratti@redhat.com>
References: <cover.1483355460.git.dcaratti@redhat.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751440AbdABMaK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Jan 2017 07:30:10 -0500
In-Reply-To: <cover.1483355460.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

implement sctp_error to let nf_conntrack_in validate crc32c on the packet
transport header. Assign skb->ip_summed to CHECKSUM_UNNECESSARY and return
NF_ACCEPT in case of successful validation; otherwise, return -NF_ACCEPT to
let netfilter skip connection tracking, like other protocols do.

Besides preventing corrupted packets from matching conntrack entries, this
fixes functionality of REJECT target: it was not generating any ICMP upon
reception of SCTP packets, because it was computing RFC 1624 checksum on
the packet and systematically mismatching crc32c in the SCTP header.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index a0efde3..44a6474 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -22,7 +22,9 @@
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
+#include <net/sctp/checksum.h>
 
+#include <net/netfilter/nf_log.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
@@ -505,6 +507,34 @@ static bool sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static int sctp_error(struct net *net, struct nf_conn *tpl, struct sk_buff *skb,
+		      unsigned int dataoff, enum ip_conntrack_info *ctinfo,
+		      u8 pf, unsigned int hooknum)
+{
+	const struct sctphdr *sh;
+	struct sctphdr _sctph;
+	const char *logmsg;
+
+	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
+	if (!sh) {
+		logmsg = "nf_ct_sctp: short packet ";
+		goto out_invalid;
+	}
+	if (net->ct.sysctl_checksum && hooknum == NF_INET_PRE_ROUTING &&
+	    skb->ip_summed == CHECKSUM_NONE) {
+		if (sh->checksum != sctp_compute_cksum(skb, dataoff)) {
+			logmsg = "nf_ct_sctp: bad CRC ";
+			goto out_invalid;
+		}
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+	}
+	return NF_ACCEPT;
+out_invalid:
+	if (LOG_INVALID(net, IPPROTO_SCTP))
+		nf_log_packet(net, pf, 0, skb, NULL, NULL, NULL, "%s", logmsg);
+	return -NF_ACCEPT;
+}
+
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -752,6 +782,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 	.packet 		= sctp_packet,
 	.get_timeouts		= sctp_get_timeouts,
 	.new 			= sctp_new,
+	.error			= sctp_error,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= sctp_to_nlattr,
@@ -786,6 +817,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.packet 		= sctp_packet,
 	.get_timeouts		= sctp_get_timeouts,
 	.new 			= sctp_new,
+	.error			= sctp_error,
 	.me 			= THIS_MODULE,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.to_nlattr		= sctp_to_nlattr,
-- 
2.7.4

