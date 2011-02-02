From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2] netfilter: nf_ct_tcp: disable pick by default for first
	ACK packet seen
Date: Wed, 02 Feb 2011 15:03:28 +0100
Message-ID: <20110202140328.12173.27571.stgit@decadence>
References: <20110202140007.12173.41157.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56865 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754323Ab1BBODd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:03:33 -0500
In-Reply-To: <20110202140007.12173.41157.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch disables a by-default TCP connection pickup facility that
allows entering TCP Established if a TCP ACK packet is seen as first
packet in the original direction. With this patch, this state pickup
facility is only enabled if nf_ct_tcp_loose > 0.

If pickup is disabled, it means that the user wants strict TCP
tracking. The current behaviour assumes the opposite.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 3fb2b73..407b87c 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -193,9 +193,9 @@ static const u8 tcp_conntracks[2][6][TCP_CONNTRACK_MAX] = {
  *	sCL -> sCL
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sS2	*/
-/*ack*/	   { sES, sIV, sES, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*ack*/	   { sIV, sIV, sES, sES, sCW, sCW, sTW, sTW, sCL, sIV },
 /*
- *	sNO -> sES	Assumed.
+ *	sNO -> sIV	if pickup is enabled, enter sES. See tcp_new()
  *	sSS -> sIV	ACK is invalid: we haven't seen a SYN/ACK yet.
  *	sS2 -> sIV
  *	sSR -> sES	Established state is reached.
@@ -1061,14 +1061,21 @@ static bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	struct tcphdr _tcph;
 	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
 	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
+	unsigned int index;
 
 	th = skb_header_pointer(skb, dataoff, sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
 
+	index = get_conntrack_index(th);
 	/* Don't need lock here: this conntrack not in circulation yet */
-	new_state
-		= tcp_conntracks[0][get_conntrack_index(th)]
-		[TCP_CONNTRACK_NONE];
+	new_state = tcp_conntracks[0][index][TCP_CONNTRACK_NONE];
+
+	/* We assume TCP established if the first packet that we see is
+	 * an ACK, the picking up facility has to be enabled, of course. */
+	if (nf_ct_tcp_loose > 0 && index == TCP_ACK_SET &&
+	    new_state == TCP_CONNTRACK_MAX) {
+		new_state = TCP_CONNTRACK_ESTABLISHED;
+	}
 
 	/* Invalid: delete conntrack */
 	if (new_state >= TCP_CONNTRACK_MAX) {

