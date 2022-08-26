Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1544AECAAD4
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 13:32:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235903AbiHZNcn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 09:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiHZNcm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 09:32:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B4119C1D
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2022 06:32:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oRZRv-0002fd-QN; Fri, 26 Aug 2022 15:32:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 1/4] netfilter: conntrack: prepare tcp_in_window for ternary return value
Date:   Fri, 26 Aug 2022 15:32:24 +0200
Message-Id: <20220826133227.3673-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220826133227.3673-1-fw@strlen.de>
References: <20220826133227.3673-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

tcp_in_window returns true if the packet is in window and false if it is
not.

If its outside of window, packet will be treated as INVALID.

There are corner cases where the packet should still be tracked, because
rulesets may drop or log such packets, even though they can occur during
normal operation, such as overly delayed acks.

In extreme cases, connection may hang forever because conntrack state
differs from real state.

There is no retransmission for ACKs.

In case of ACK loss after conntrack processing, its possible that a
connection can be stuck because the actual retransmits are considered
stale ("SEQ is under the lower bound (already ACKed data
retransmitted)".

The problem is made worse by carrier-grade-nat which can also result
in stale packets from old connections to get treated as 'recent' packets
in conntrack (it doesn't support tcp timestamps at this time).

Prepare tcp_in_window() to return an enum that tells the desired
action (in-window/accept, bogus/drop).

A third action (accept the packet as in-window, but do not change
state) is added in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: rebase.

 net/netfilter/nf_conntrack_proto_tcp.c | 134 ++++++++++++++++---------
 1 file changed, 86 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a634c72b1ffc..a2cda7f76f4e 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -47,6 +47,11 @@ static const char *const tcp_conntrack_names[] = {
 	"SYN_SENT2",
 };
 
+enum nf_ct_tcp_action {
+	NFCT_TCP_INVALID,
+	NFCT_TCP_ACCEPT,
+};
+
 #define SECS * HZ
 #define MINS * 60 SECS
 #define HOURS * 60 MINS
@@ -472,13 +477,37 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 	}
 }
 
-static bool tcp_in_window(struct nf_conn *ct,
-			  enum ip_conntrack_dir dir,
-			  unsigned int index,
-			  const struct sk_buff *skb,
-			  unsigned int dataoff,
-			  const struct tcphdr *tcph,
-			  const struct nf_hook_state *hook_state)
+__printf(6, 7)
+static enum nf_ct_tcp_action nf_tcp_log_invalid(const struct sk_buff *skb,
+						const struct nf_conn *ct,
+						const struct nf_hook_state *state,
+						const struct ip_ct_tcp_state *sender,
+						enum nf_ct_tcp_action ret,
+						const char *fmt, ...)
+{
+	const struct nf_tcp_net *tn = nf_tcp_pernet(nf_ct_net(ct));
+	struct va_format vaf;
+	va_list args;
+	bool be_liberal;
+
+	be_liberal = sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL || tn->tcp_be_liberal;
+	if (be_liberal)
+		return NFCT_TCP_ACCEPT;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	nf_ct_l4proto_log_invalid(skb, ct, state, "%pV", &vaf);
+	va_end(args);
+
+	return ret;
+}
+
+static enum nf_ct_tcp_action
+tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
+	      unsigned int index, const struct sk_buff *skb,
+	      unsigned int dataoff, const struct tcphdr *tcph,
+	      const struct nf_hook_state *hook_state)
 {
 	struct ip_ct_tcp *state = &ct->proto.tcp;
 	struct net *net = nf_ct_net(ct);
@@ -486,9 +515,9 @@ static bool tcp_in_window(struct nf_conn *ct,
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	__u32 seq, ack, sack, end, win, swin;
-	u16 win_raw;
+	bool in_recv_win, seq_ok;
 	s32 receiver_offset;
-	bool res, in_recv_win;
+	u16 win_raw;
 
 	/*
 	 * Get the required data from the packet.
@@ -517,7 +546,7 @@ static bool tcp_in_window(struct nf_conn *ct,
 					end, win);
 			if (!tcph->ack)
 				/* Simultaneous open */
-				return true;
+				return NFCT_TCP_ACCEPT;
 		} else {
 			/*
 			 * We are in the middle of a connection,
@@ -584,13 +613,52 @@ static bool tcp_in_window(struct nf_conn *ct,
 		 */
 		seq = end = sender->td_end;
 
+	seq_ok = before(seq, sender->td_maxend + 1);
+	if (!seq_ok) {
+		u32 overshot = end - sender->td_maxend + 1;
+		bool ack_ok;
+
+		ack_ok = after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1);
+		in_recv_win = receiver->td_maxwin &&
+			      after(end, sender->td_end - receiver->td_maxwin - 1);
+
+		if (in_recv_win &&
+		    ack_ok &&
+		    overshot <= receiver->td_maxwin &&
+		    before(sack, receiver->td_end + 1)) {
+			/* Work around TCPs that send more bytes than allowed by
+			 * the receive window.
+			 *
+			 * If the (marked as invalid) packet is allowed to pass by
+			 * the ruleset and the peer acks this data, then its possible
+			 * all future packets will trigger 'ACK is over upper bound' check.
+			 *
+			 * Thus if only the sequence check fails then do update td_end so
+			 * possible ACK for this data can update internal state.
+			 */
+			sender->td_end = end;
+			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
+
+			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
+						  "%u bytes more than expected", overshot);
+			return NFCT_TCP_ACCEPT;
+		}
+
+		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
+					  "SEQ is over upper bound %u (over the window of the receiver)",
+					  sender->td_maxend + 1);
+	}
+
+	if (!before(sack, receiver->td_end + 1))
+		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_INVALID,
+					  "ACK is over upper bound %u (ACKed data not seen yet)",
+					  receiver->td_end + 1);
+
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
 
-	if (before(seq, sender->td_maxend + 1) &&
-	    in_recv_win &&
-	    before(sack, receiver->td_end + 1) &&
+	if (in_recv_win &&
 	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
 		/*
 		 * Take into account window scaling (RFC 1323).
@@ -648,44 +716,12 @@ static bool tcp_in_window(struct nf_conn *ct,
 				state->retrans = 0;
 			}
 		}
-		res = true;
 	} else {
-		res = false;
 		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
 		    tn->tcp_be_liberal)
-			res = true;
-		if (!res) {
-			bool seq_ok = before(seq, sender->td_maxend + 1);
-
-			if (!seq_ok) {
-				u32 overshot = end - sender->td_maxend + 1;
-				bool ack_ok;
-
-				ack_ok = after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1);
-
-				if (in_recv_win &&
-				    ack_ok &&
-				    overshot <= receiver->td_maxwin &&
-				    before(sack, receiver->td_end + 1)) {
-					/* Work around TCPs that send more bytes than allowed by
-					 * the receive window.
-					 *
-					 * If the (marked as invalid) packet is allowed to pass by
-					 * the ruleset and the peer acks this data, then its possible
-					 * all future packets will trigger 'ACK is over upper bound' check.
-					 *
-					 * Thus if only the sequence check fails then do update td_end so
-					 * possible ACK for this data can update internal state.
-					 */
-					sender->td_end = end;
-					sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
-
-					nf_ct_l4proto_log_invalid(skb, ct, hook_state,
-								  "%u bytes more than expected", overshot);
-					return res;
-				}
-			}
+			return NFCT_TCP_ACCEPT;
 
+		{
 			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
 			"%s",
 			before(seq, sender->td_maxend + 1) ?
@@ -697,9 +733,11 @@ static bool tcp_in_window(struct nf_conn *ct,
 			: "SEQ is under the lower bound (already ACKed data retransmitted)"
 			: "SEQ is over the upper bound (over the window of the receiver)");
 		}
+
+		return NFCT_TCP_INVALID;
 	}
 
-	return res;
+	return NFCT_TCP_ACCEPT;
 }
 
 /* table of valid flag combinations - PUSH, ECE and CWR are always valid */
-- 
2.35.1

