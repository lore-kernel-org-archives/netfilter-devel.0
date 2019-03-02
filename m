Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18637C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1DA520838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfCBSgl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:36:41 -0500
Received: from mail.us.es ([193.147.175.20]:36154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727472AbfCBSgd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:36:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62F721361B1
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F992DA797
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:36:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44EA9DA864; Sat,  2 Mar 2019 19:36:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C069DDA844;
        Sat,  2 Mar 2019 19:36:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:36:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7737B4265A2F;
        Sat,  2 Mar 2019 19:36:27 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 19/29] netfilter: conntrack: tcp: only close if RST matches exact sequence
Date:   Sat,  2 Mar 2019 19:36:03 +0100
Message-Id: <20190302183613.3159-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183613.3159-1-pablo@netfilter.org>
References: <20190302183613.3159-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

TCP resets cause instant transition from established to closed state
provided the reset is in-window.  Endpoints that implement RFC 5961
require resets to match the next expected sequence number.
RST segments that are in-window (but that do not match RCV.NXT) are
ignored, and a "challenge ACK" is sent back.

Main problem for conntrack is that its a middlebox, i.e.  whereas an end
host might have ACK'd SEQ (and would thus accept an RST with this
sequence number), conntrack might not have seen this ACK (yet).

Therefore we can't simply flag RSTs with non-exact match as invalid.

This updates RST processing as follows:

1. If the connection is in a state other than ESTABLISHED, nothing is
   changed, RST is subject to normal in-window check.

2. If the RSTs sequence number either matches exactly RCV.NXT,
   connection state moves to CLOSE.

3. The same applies if the RST sequence number aligns with a previous
   packet in the same direction.

In all other cases, the connection remains in ESTABLISHED state.
If the normal-in-window check passes, the timeout will be lowered
to that of CLOSE.

If the peer sends a challenge ack, connection timeout will be reset.

If the challenge ACK triggers another RST (RST was valid after all),
this 2nd RST will match expected sequence and conntrack state changes to
CLOSE.

If no challenge ACK is received, the connection will time out after
CLOSE seconds (10 seconds by default), just like without this patch.

Packetdrill test case:

0.000 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
0.000 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
0.000 bind(3, ..., ...) = 0
0.000 listen(3, 1) = 0

0.100 < S 0:0(0) win 32792 <mss 1460,sackOK,nop,nop,nop,wscale 7>
0.100 > S. 0:0(0) ack 1 win 64240 <mss 1460,nop,nop,sackOK,nop,wscale 7>
0.200 < . 1:1(0) ack 1 win 257
0.200 accept(3, ..., ...) = 4

// Receive a segment.
0.210 < P. 1:1001(1000) ack 1 win 46
0.210 > . 1:1(0) ack 1001

// Application writes 1000 bytes.
0.250 write(4, ..., 1000) = 1000
0.250 > P. 1:1001(1000) ack 1001

// First reset, old sequence. Conntrack (correctly) considers this
// invalid due to failed window validation (regardless of this patch).
0.260 < R  2:2(0) ack 1001 win 260

// 2nd reset, but too far ahead sequence.  Same: correctly handled
// as invalid.
0.270 < R 99990001:99990001(0) ack 1001 win 260

// in-window, but not exact sequence.
// Current Linux kernels might reply with a challenge ack, and do not
// remove connection.
// Without this patch, conntrack state moves to CLOSE.
// With patch, timeout is lowered like CLOSE, but connection stays
// in ESTABLISHED state.
0.280 < R 1010:1010(0) ack 1001 win 260

// Expect challenge ACK
0.281 > . 1001:1001(0) ack 1001 win 501

// With or without this patch, RST will cause connection
// to move to CLOSE (sequence number matches)
// 0.282 < R 1001:1001(0) ack 1001 win 260

// ACK
0.300 < . 1001:1001(0) ack 1001 win 257

// more data could be exchanged here, connection
// is still established

// Client closes the connection.
0.610 < F. 1001:1001(0) ack 1001 win 260
0.650 > . 1001:1001(0) ack 1002

// Close the connection without reading outstanding data
0.700 close(4) = 0

// so one more reset.  Will be deemed acceptable with patch as well:
// connection is already closing.
0.701 > R. 1001:1001(0) ack 1002 win 501
// End packetdrill test case.

With patch, this generates following conntrack events:
   [NEW] 120 SYN_SENT src=10.0.2.1 dst=10.0.0.1 sport=5437 dport=80 [UNREPLIED]
[UPDATE] 60 SYN_RECV src=10.0.2.1 dst=10.0.0.1 sport=5437 dport=80
[UPDATE] 432000 ESTABLISHED src=10.0.2.1 dst=10.0.0.1 sport=5437 dport=80 [ASSURED]
[UPDATE] 120 FIN_WAIT src=10.0.2.1 dst=10.0.0.1 sport=5437 dport=80 [ASSURED]
[UPDATE] 60 CLOSE_WAIT src=10.0.2.1 dst=10.0.0.1 sport=5437 dport=80 [ASSURED]
[UPDATE] 10 CLOSE src=10.0.2.1 dst=10.0.0.1 sport=5437 dport=80 [ASSURED]

Without patch, first RST moves connection to close, whereas socket state
does not change until FIN is received.
   [NEW] 120 SYN_SENT src=10.0.2.1 dst=10.0.0.1 sport=5141 dport=80 [UNREPLIED]
[UPDATE] 60 SYN_RECV src=10.0.2.1 dst=10.0.0.1 sport=5141 dport=80
[UPDATE] 432000 ESTABLISHED src=10.0.2.1 dst=10.0.0.1 sport=5141 dport=80 [ASSURED]
[UPDATE] 10 CLOSE src=10.0.2.1 dst=10.0.0.1 sport=5141 dport=80 [ASSURED]

Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 50 +++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 01c748fa8913..a06875a466a4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -828,6 +828,12 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	return true;
 }
 
+static bool nf_conntrack_tcp_established(const struct nf_conn *ct)
+{
+	return ct->proto.tcp.state == TCP_CONNTRACK_ESTABLISHED &&
+	       test_bit(IPS_ASSURED_BIT, &ct->status);
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -1030,16 +1036,38 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			new_state = TCP_CONNTRACK_ESTABLISHED;
 		break;
 	case TCP_CONNTRACK_CLOSE:
-		if (index == TCP_RST_SET
-		    && (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET)
-		    && before(ntohl(th->seq), ct->proto.tcp.seen[!dir].td_maxack)) {
-			/* Invalid RST  */
-			spin_unlock_bh(&ct->lock);
-			nf_ct_l4proto_log_invalid(skb, ct, "invalid rst");
-			return -NF_ACCEPT;
+		if (index != TCP_RST_SET)
+			break;
+
+		if (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET) {
+			u32 seq = ntohl(th->seq);
+
+			if (before(seq, ct->proto.tcp.seen[!dir].td_maxack)) {
+				/* Invalid RST  */
+				spin_unlock_bh(&ct->lock);
+				nf_ct_l4proto_log_invalid(skb, ct, "invalid rst");
+				return -NF_ACCEPT;
+			}
+
+			if (!nf_conntrack_tcp_established(ct) ||
+			    seq == ct->proto.tcp.seen[!dir].td_maxack)
+				break;
+
+			/* Check if rst is part of train, such as
+			 *   foo:80 > bar:4379: P, 235946583:235946602(19) ack 42
+			 *   foo:80 > bar:4379: R, 235946602:235946602(0)  ack 42
+			 */
+			if (ct->proto.tcp.last_index == TCP_ACK_SET &&
+			    ct->proto.tcp.last_dir == dir &&
+			    seq == ct->proto.tcp.last_end)
+				break;
+
+			/* ... RST sequence number doesn't match exactly, keep
+			 * established state to allow a possible challenge ACK.
+			 */
+			new_state = old_state;
 		}
-		if (index == TCP_RST_SET
-		    && ((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
+		if (((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
 			 && ct->proto.tcp.last_index == TCP_SYN_SET)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)
 			    && ct->proto.tcp.last_index == TCP_ACK_SET))
@@ -1055,7 +1083,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			 * segments we ignored. */
 			goto in_window;
 		}
-		/* Just fall through */
+		break;
 	default:
 		/* Keep compilers happy. */
 		break;
@@ -1090,6 +1118,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
+	else if (unlikely(index == TCP_RST_SET))
+		timeout = timeouts[TCP_CONNTRACK_CLOSE];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
 		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
-- 
2.11.0


