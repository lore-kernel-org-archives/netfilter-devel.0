Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819B4C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 15:09:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238919AbiELPI7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 11:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352937AbiELPI4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 11:08:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E196A1D7359
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 08:08:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1npAQt-0003v4-Rd; Thu, 12 May 2022 17:08:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: conntrack: remove pr_debug callsites from tcp tracker
Date:   Thu, 12 May 2022 17:08:47 +0200
Message-Id: <20220512150847.22858-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They are either obsolete or useless.

Those in the normal processing path cannot be enabled on a production
system; they generate too much noise.

One pr_debug call resides in an error path and does provide useful info,
merge it with the existing nf_log_invalid().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 52 ++------------------------
 1 file changed, 4 insertions(+), 48 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 8ec55cd72572..68692d36d6c9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -485,7 +485,6 @@ static bool tcp_in_window(struct nf_conn *ct,
 	struct nf_tcp_net *tn = nf_tcp_pernet(net);
 	struct ip_ct_tcp_state *sender = &state->seen[dir];
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
-	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
 	u16 win_raw;
 	s32 receiver_offset;
@@ -508,18 +507,6 @@ static bool tcp_in_window(struct nf_conn *ct,
 	ack -= receiver_offset;
 	sack -= receiver_offset;
 
-	pr_debug("tcp_in_window: START\n");
-	pr_debug("tcp_in_window: ");
-	nf_ct_dump_tuple(tuple);
-	pr_debug("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
-		 seq, ack, receiver_offset, sack, receiver_offset, win, end);
-	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
-
 	if (sender->td_maxwin == 0) {
 		/*
 		 * Initialize sender data.
@@ -606,27 +593,10 @@ static bool tcp_in_window(struct nf_conn *ct,
 		 */
 		seq = end = sender->td_end;
 
-	pr_debug("tcp_in_window: ");
-	nf_ct_dump_tuple(tuple);
-	pr_debug("seq=%u ack=%u+(%d) sack=%u+(%d) win=%u end=%u\n",
-		 seq, ack, receiver_offset, sack, receiver_offset, win, end);
-	pr_debug("tcp_in_window: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
-
 	/* Is the ending sequence in the receive window (if available)? */
 	in_recv_win = !receiver->td_maxwin ||
 		      after(end, sender->td_end - receiver->td_maxwin - 1);
 
-	pr_debug("tcp_in_window: I=%i II=%i III=%i IV=%i\n",
-		 before(seq, sender->td_maxend + 1),
-		 (in_recv_win ? 1 : 0),
-		 before(sack, receiver->td_end + 1),
-		 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
-
 	if (before(seq, sender->td_maxend + 1) &&
 	    in_recv_win &&
 	    before(sack, receiver->td_end + 1) &&
@@ -707,11 +677,6 @@ static bool tcp_in_window(struct nf_conn *ct,
 		}
 	}
 
-	pr_debug("tcp_in_window: res=%u sender end=%u maxend=%u maxwin=%u "
-		 "receiver end=%u maxend=%u maxwin=%u\n",
-		 res, sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin);
-
 	return res;
 }
 
@@ -781,8 +746,6 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	enum tcp_conntrack new_state;
 	struct net *net = nf_ct_net(ct);
 	const struct nf_tcp_net *tn = nf_tcp_pernet(net);
-	const struct ip_ct_tcp_state *sender = &ct->proto.tcp.seen[0];
-	const struct ip_ct_tcp_state *receiver = &ct->proto.tcp.seen[1];
 
 	/* Don't need lock here: this conntrack not in circulation yet */
 	new_state = tcp_conntracks[0][get_conntrack_index(th)][TCP_CONNTRACK_NONE];
@@ -835,14 +798,6 @@ static noinline bool tcp_new(struct nf_conn *ct, const struct sk_buff *skb,
 
 	/* tcp_packet will set them */
 	ct->proto.tcp.last_index = TCP_NONE_SET;
-
-	pr_debug("%s: sender end=%u maxend=%u maxwin=%u scale=%i "
-		 "receiver end=%u maxend=%u maxwin=%u scale=%i\n",
-		 __func__,
-		 sender->td_end, sender->td_maxend, sender->td_maxwin,
-		 sender->td_scale,
-		 receiver->td_end, receiver->td_maxend, receiver->td_maxwin,
-		 receiver->td_scale);
 	return true;
 }
 
@@ -1041,10 +996,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		}
 
 		/* Invalid packet */
-		pr_debug("nf_ct_tcp: Invalid dir=%i index=%u ostate=%u\n",
-			 dir, get_conntrack_index(th), old_state);
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, state, "invalid state");
+		nf_ct_l4proto_log_invalid(skb, ct, state,
+					  "packet (index %d) in dir %d invalid, state %s",
+					  index, dir,
+					  tcp_conntrack_names[old_state]);
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_TIME_WAIT:
 		/* RFC5961 compliance cause stack to send "challenge-ACK"
-- 
2.35.1

