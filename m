From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Thu, 12 Dec 2013 10:19:34 -0500
Message-ID: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43971 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLPVq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:21:46 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so668044pdj.32
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Dec 2013 07:21:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Think about the following scenario:

+--------+      +-------+      +----------+
| Server +------+ NAT 1 +------| Client 1 |
+---+----+      +-------+      +----------+
    |
    |           +-------+      +----------+
    +-----------+ NAT 2 +------| Client 2 |
                +-------+      +----------+

The following UDP punching steps are used to to establish a direct session
between Client 1 and Client 2 with the help from Server.

1. Client 1 sends a UDP packet to Server, and Server learned the public IP and
   port of Client 1.
2. Client 2 sends a UDP packet to Server, and Server learned the public IP and
   port of Client 2.
3. Server tells Client 1 the public IP and port of Client 2.
4. Server tells Client 2 the public IP and port of Client 1.
5. Client 1 sends UDP packets to the public IP and port of Client 2.
6. Client 2 sends UDP packets to the public IP and port of Client 1.

If both NAT 1 and NAT 2 are Cone NAT, Client 1 and Client 2 can communicate
with each other directly.

Linux tries its best to be a Port Restricted NAT. But there is a race condition
between 5 and 6.

Suppose the packet from Client 1 to the public IP and port of Client 2 reaches
NAT 2 before the packet from Client 2 to the public IP and port of Client 1,
and it belongs to a new session to NAT 2 itself since there isn't any
corresponding conntrack in NAT 2, and it is likely that port isn't opened at
NAT 2, so at last, a Port Unreachable ICMP packet will be delivered to Client 1.

Then, the packet from Client 2 to the public IP and port of Client 1 reaches
NAT 2, and NAT 2 fails to use the same public IP and port of the packet sent
to Server as the source IP and port, because the corresponding tuple is in use,
at last, NAT 2 has to allocate a new pair of IP and port.

One and simplest solution is killing unreplied conntracks by ICMP errors.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index a338dad..6210820 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -135,6 +135,7 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	const struct nf_conntrack_l4proto *innerproto;
 	const struct nf_conntrack_tuple_hash *h;
 	u16 zone = tmpl ? nf_ct_zone(tmpl) : NF_CT_DEFAULT_ZONE;
+	struct nf_conn *ct;
 
 	NF_CT_ASSERT(skb->nfct == NULL);
 
@@ -169,8 +170,12 @@ icmp_error_message(struct net *net, struct nf_conn *tmpl, struct sk_buff *skb,
 	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
 		*ctinfo += IP_CT_IS_REPLY;
 
+	ct = nf_ct_tuplehash_to_ctrack(h);
+	if (!test_bit(IPS_SEEN_REPLY, &ct->status))
+		nf_ct_kill_acct(ct, *ctinfo, skb);
+
 	/* Update skb to refer to this connection */
-	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
+	skb->nfct = &ct->ct_general;
 	skb->nfctinfo = *ctinfo;
 	return NF_ACCEPT;
 }
-- 
1.7.9.5

