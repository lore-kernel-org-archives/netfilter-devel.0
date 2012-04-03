From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/1] netfilter: conntrack: drop malformed IPv4 packets
Date: Tue,  3 Apr 2012 22:02:01 +0200
Message-ID: <1333483321-16868-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1333483321-16868-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:34363 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab2DCUCE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:02:04 -0400
In-Reply-To: <1333483321-16868-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It was reported that the Linux kernel sometimes logs:

klogd: [2629147.402413] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 447!
klogd: [1072212.887368] kernel BUG at net / netfilter /
nf_conntrack_proto_tcp.c: 392

ipv4_get_l4proto() in nf_conntrack_l3proto_ipv4.c and tcp_error() in
nf_conntrack_proto_tcp.c should catch malformed packets, so the errors
at the indicated lines - TCP options parsing - should not happen.
However, tcp_error() relies on the "dataoff" offset to the TCP header,
calculated by ipv4_get_l4proto().  But ipv4_get_l4proto() does not check
bogus ihl values in IPv4 packets, which then can slip through tcp_error()
and get caught at the TCP options parsing routines.

The patch fixes ipv4_get_l4proto() by dropping packets with bogus
ihl value.

The patch closes netfilter bugzilla id 771.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index de9da21..6a5f038 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -84,6 +84,14 @@ static int ipv4_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 	*dataoff = nhoff + (iph->ihl << 2);
 	*protonum = iph->protocol;
 
+	/* Check bogus IP headers */
+	if (*dataoff > skb->len) {
+		pr_debug("nf_conntrack_ipv4: drop bogus IPv4 packet: "
+			 "nhoff %u, ihl %u, skblen %u\n",
+			 nhoff, iph->ihl << 2, skb->len);
+		return -NF_DROP;
+	}
+
 	return NF_ACCEPT;
 }
 
-- 
1.7.0.4

