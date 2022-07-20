Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FA9C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 17:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiGTRwq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 13:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiGTRwo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 13:52:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0984A5C9E0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 10:52:44 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oEDsI-0008Ly-Du; Wed, 20 Jul 2022 19:52:42 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     kadlec@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/3] netfilter: conntrack: ignore overly delayed tcp packets
Date:   Wed, 20 Jul 2022 19:52:27 +0200
Message-Id: <20220720175228.17880-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720175228.17880-1-fw@strlen.de>
References: <20220720175228.17880-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If 'nf_conntrack_tcp_loose' is off (the default), tcp packets that are
outside of the current window are marked as INVALID.

nf/iptables rulesets often drop such packets via 'ct state invalid' or
similar checks.  In addition, they may log suck an event.

Since they are not invalid in a strict sense, just ignore them.

Conntrack won't extend timeout or change state for such packets but
they will still be treated as being part of the connection.

So, 'state invalid' rules won't match them anymore.
This allows the receiver to immediately respond with an ack.
This doesn't happen as-is if invalid packets get discarded.

The else branch of the conditional becomes obsolete.
Next patch will reformant the now always-true if condition.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 45 ++++++++++++--------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 01dc34ead0a4..c72588382421 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -48,6 +48,7 @@ static const char *const tcp_conntrack_names[] = {
 };
 
 enum nf_ct_tcp_action {
+	NFCT_TCP_IGNORE,
 	NFCT_TCP_INVALID,
 	NFCT_TCP_ACCEPT,
 };
@@ -510,8 +511,6 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	      const struct nf_hook_state *hook_state)
 {
 	struct ip_ct_tcp *state = &ct->proto.tcp;
-	struct net *net = nf_ct_net(ct);
-	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	__u32 seq, ack, sack, end, win, swin;
@@ -627,9 +626,17 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
+	if (!in_recv_win)
+		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
+					  "SEQ is under lower bound %u (already ACKed data retransmitted)",
+					  sender->td_end - receiver->td_maxwin - 1);
+	if (!after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1))
+		return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
+					  "ignored ACK under lower bound %u (possible overly delayed)",
+					  receiver->td_end - MAXACKWINDOW(sender) - 1);
+
 
-	if (in_recv_win &&
-	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
+	if (1) {
 		/*
 		 * Take into account window scaling (RFC 1323).
 		 */
@@ -686,24 +693,6 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 				state->retrans = 0;
 			}
 		}
-	} else {
-		if (sender->flags & IP_CT_TCP_FLAG_BE_LIBERAL ||
-		    tn->tcp_be_liberal)
-			return NFCT_TCP_ACCEPT;
-		{
-			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
-			"%s",
-			before(seq, sender->td_maxend + 1) ?
-			in_recv_win ?
-			before(sack, receiver->td_end + 1) ?
-			after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1) ? "BUG"
-			: "ACK is under the lower bound (possible overly delayed ACK)"
-			: "ACK is over the upper bound (ACKed data not seen yet)"
-			: "SEQ is under the lower bound (already ACKed data retransmitted)"
-			: "SEQ is over the upper bound (over the window of the receiver)");
-		}
-
-		return NFCT_TCP_INVALID;
 	}
 
 	return NFCT_TCP_ACCEPT;
@@ -868,6 +857,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	struct nf_conntrack_tuple *tuple;
 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
+	enum nf_ct_tcp_action res;
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -1133,10 +1123,17 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		break;
 	}
 
-	if (!tcp_in_window(ct, dir, index,
-			   skb, dataoff, th, state)) {
+	res = tcp_in_window(ct, dir, index,
+			    skb, dataoff, th, state);
+	switch (res) {
+	case NFCT_TCP_IGNORE:
+		spin_unlock_bh(&ct->lock);
+		return NF_ACCEPT;
+	case NFCT_TCP_INVALID:
 		spin_unlock_bh(&ct->lock);
 		return -NF_ACCEPT;
+	case NFCT_TCP_ACCEPT:
+		break;
 	}
      in_window:
 	/* From now on we have got in-window packets */
-- 
2.35.1

