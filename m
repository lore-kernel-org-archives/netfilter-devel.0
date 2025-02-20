Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EFD1F150B
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Feb 2025 12:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740053176; cv=none; b=eq4Eqg9twuLaxDZEu4HnwcmGtN2dvCVfTaI9qmAry0s9WI7Ok/TPF4I/YCCEPaSxZXaaZc7xkWBAxoa2TLI2xd2vv/ZvjOuwhXUDzDUhAMQ7JtunyLI5AVwYSe8crRE9X4RXN5biuICjZem+bEs9SbFUNftUv+m5AKfndkIe3ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740053176; c=relaxed/simple;
	bh=5sjUorc1lJ5hCyDJ7x3azIcNWFvuYsCejpfWvUSlACU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fNXT981GNkW5OIaYS3W1dehY7/7VHxFC/zE+hGJfDJ21NxWOpGhLU/D7LBR6/KLIkUvOUe0bJg5rqm2jcdG7DCnWpMytkXeNQDZeGvcqpnNpUpXKooC2wN8mIpP0RSYPdsGoXVQqQXBUySkiMHB73299VLtNjavPg5INgUpQItM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GEDz6zzX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UQJ9c4Ub; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GEDz6zzX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UQJ9c4Ub"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5496A602DB; Thu, 20 Feb 2025 13:06:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740053171;
	bh=7e+b9ovH8d/FZygPuRnLEJxEr0Oo6PZU9x5tObqH4mk=;
	h=From:To:Cc:Subject:Date:From;
	b=GEDz6zzXrozmK8x/gts2TWttNljRx1BzD5ZtdayHiy7h0L/5238tAIUsNFIYGWTt6
	 VpsFMFEX7q8kcPxH2VLtY83PAf+S7eqWejzH/pwKhHj/ZUWcxGgtxyt8k3LqBuJb4H
	 iu6RN38ON7WrvEDSA8iElUy5mEGLO5ElESkrZnvdJ4Bsu/eyW5PVaMwGlPXKxzN0wN
	 R1BcNWjGIMAeaoHMTJDwu1Ofr0vHnMPz7TeJA2bTcUHI980agXvjOiV533L2BtzcYM
	 OeNdH0BInBGY3Ux7uumzNCH0eULYq0xpq5l7diLzkJnUND74pWxt4NqYLRhipuJ4dV
	 goF3em2G3JCgw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D3120602DB;
	Thu, 20 Feb 2025 13:06:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740053169;
	bh=7e+b9ovH8d/FZygPuRnLEJxEr0Oo6PZU9x5tObqH4mk=;
	h=From:To:Cc:Subject:Date:From;
	b=UQJ9c4Ub8j8Ug7GugtWBSJp2zH3mMDLpc7JQ9Q9VoD65T3obbtFjS8BwyG5aytpCZ
	 FFVdxHlvPJiABwFY1AMl7KNReGgd7EmOl5cwpygkw0QM2h5IPjMIXIjQpTB4woTFoJ
	 4XFcti9lg+wzb0sw/piKh2aqpdAoAy2qRLyJCXH/6ZBb8Q4+Zp3fJFiy2Sc/g879E5
	 fF86RAXPH37/+RJbhthDT4T/w15X5MziojxxwUiXqgyRPakvVJb61rxz56yMeO8XvL
	 nyttU0L7DGYiPXE675odBytZclCzY3SlCNsJV5IigMKu5ZTjliWRfj1RyAjoZAKThv
	 FMKf6PMLKxM+w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	kadlec@netfilter.org,
	edumazet@google.com
Subject: [PATCH nf] netfilter: conntrack: correct sequence on reinitialized TCP connection
Date: Thu, 20 Feb 2025 13:06:05 +0100
Message-Id: <20250220120605.678604-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Although RFC 793 states that sender "... must only be sure to use
sequence numbers larger than those recently used" when TCP connection is
reinitialized, it is not possible for a middlebox to guarantee that a
(malicious) sender complies with the RFC.

One possible solution is to remove the after(end, sender->td_end),
however, that would make it easier for an attacker to overwrite the
victim's conntrack state with arbitrary ones.

Instead, let this syn packet go through as ignored and annotate its
state to wait for server to deliver a syn-ack that proves that client is
really trying to reach the server. This is similar to the existing code
under TCP_CONNTRACK_IGNORE section where firewall is out-of-sync.

(malicious) sender can still possibly override the victim's state via
syn flood, let just this syn-ack packet continue its travel and enter
liberal mode in that case, we cannot make the scenario work universally.

Note that we can only tolerate one 'unknown last ignored' state and we
can check if syn-ack carries the right sequence number saved in the
state. All other scenarios require synproxy configuration where
conntrack keeps no state.

Extend last_flags field to 16-bit to store IP_CT_TCP_REINIT, this flag
is not exposed to userspace through uapi.

Cc: <stable+noautosel@kernel.org>
Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_tcp.h |   5 +-
 net/netfilter/nf_conntrack_proto_tcp.c     | 140 +++++++++++++++------
 2 files changed, 106 insertions(+), 39 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index f9e3a663037b..af8bd740f2bb 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -14,6 +14,9 @@ struct ip_ct_tcp_state {
 	u_int8_t	flags;		/* per direction options */
 };
 
+/* unexpected SYN packet with smaller sequence number while in SYN_SENT. */
+#define IP_CT_TCP_REINIT		0x100
+
 struct ip_ct_tcp {
 	struct ip_ct_tcp_state seen[2];	/* connection parameters per direction */
 	u_int8_t	state;		/* state of the connection (enum tcp_conntrack) */
@@ -26,8 +29,8 @@ struct ip_ct_tcp {
 	u_int32_t	last_end;	/* Last seq + len */
 	u_int16_t	last_win;	/* Last window advertisement seen in dir */
 	/* For SYN packets while we may be out-of-sync */
+	u_int16_t	last_flags;	/* Last flags set */
 	u_int8_t	last_wscale;	/* Last window scaling factor seen */
-	u_int8_t	last_flags;	/* Last flags set */
 };
 
 #endif /* _NF_CONNTRACK_TCP_H */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 0c1d086e96cb..33381cfb26af 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -480,6 +480,39 @@ static void tcp_init_sender(struct ip_ct_tcp_state *sender,
 	}
 }
 
+static void nf_ct_tcp_state_annotate(struct nf_conn *ct,
+				     const struct sk_buff *skb,
+				     const struct tcphdr *th,
+				     unsigned int dataoff,
+				     enum ip_conntrack_dir dir,
+				     unsigned int index)
+{
+	ct->proto.tcp.last_index = index;
+	ct->proto.tcp.last_dir = dir;
+	ct->proto.tcp.last_seq = ntohl(th->seq);
+	ct->proto.tcp.last_end =
+	    segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
+	ct->proto.tcp.last_win = ntohs(th->window);
+}
+
+static void nf_ct_tcp_state_syn_annotate(struct nf_conn *ct,
+					 const struct sk_buff *skb,
+					 const struct tcphdr *th,
+					 unsigned int dataoff)
+{
+	struct ip_ct_tcp_state seen = {};
+
+	ct->proto.tcp.last_flags = 0;
+	ct->proto.tcp.last_wscale = 0;
+	tcp_options(skb, dataoff, th, &seen);
+	if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
+		ct->proto.tcp.last_flags |= IP_CT_TCP_FLAG_WINDOW_SCALE;
+		ct->proto.tcp.last_wscale = seen.td_scale;
+	}
+	if (seen.flags & IP_CT_TCP_FLAG_SACK_PERM)
+		ct->proto.tcp.last_flags |= IP_CT_TCP_FLAG_SACK_PERM;
+}
+
 __printf(6, 7)
 static enum nf_ct_tcp_action nf_tcp_log_invalid(const struct sk_buff *skb,
 						const struct nf_conn *ct,
@@ -574,7 +607,6 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 
 		}
 	} else if (tcph->syn &&
-		   after(end, sender->td_end) &&
 		   (state->state == TCP_CONNTRACK_SYN_SENT ||
 		    state->state == TCP_CONNTRACK_SYN_RECV)) {
 		/*
@@ -584,13 +616,30 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 		 *
 		 * Re-init state for this direction, just like for the first
 		 * syn(-ack) reply, it might differ in seq, ack or tcp options.
+		 *
+		 * However, if the sequence number is smaller than expected,
+		 * then let the packet go through and wait for server to reply
+		 * with a syn-ack to confirm this is legitimate.
+		 *
+		 * Note that syn retransmissions do not fall under either of
+		 * the following two conditions.
 		 */
-		tcp_init_sender(sender, receiver,
-				skb, dataoff, tcph,
-				end, win, dir);
+		if (after(end, sender->td_end)) {
+			tcp_init_sender(sender, receiver,
+					skb, dataoff, tcph,
+					end, win, dir);
+
+			if (dir == IP_CT_DIR_REPLY && !tcph->ack)
+				return NFCT_TCP_ACCEPT;
+		} else if (before(end, sender->td_end) &&
+			   dir == IP_CT_DIR_ORIGINAL && !tcph->ack) {
+			nf_ct_tcp_state_annotate(ct, skb, tcph, dataoff, dir, index);
+			nf_ct_tcp_state_syn_annotate(ct, skb, tcph, dataoff);
+			ct->proto.tcp.last_flags |= IP_CT_TCP_REINIT;
 
-		if (dir == IP_CT_DIR_REPLY && !tcph->ack)
-			return NFCT_TCP_ACCEPT;
+			return nf_tcp_log_invalid(skb, ct, hook_state, sender, NFCT_TCP_IGNORE,
+						  "ignored SYN with SEQ before the previous one");
+		}
 	}
 
 	if (!(tcph->ack)) {
@@ -959,6 +1008,24 @@ static void nf_ct_tcp_state_reset(struct ip_ct_tcp_state *state)
 	state->flags		&= IP_CT_TCP_FLAG_BE_LIBERAL;
 }
 
+static void nf_ct_tcp_state_resync(struct nf_conn *ct,
+				   enum ip_conntrack_dir dir)
+{
+	ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_end =
+					ct->proto.tcp.last_end;
+	ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxend =
+					ct->proto.tcp.last_end;
+	ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxwin =
+					ct->proto.tcp.last_win == 0 ?
+						1 : ct->proto.tcp.last_win;
+	ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_scale =
+					ct->proto.tcp.last_wscale;
+	ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
+	ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
+					ct->proto.tcp.last_flags;
+	nf_ct_tcp_state_reset(&ct->proto.tcp.seen[dir]);
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -1052,27 +1119,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			 */
 			old_state = TCP_CONNTRACK_SYN_SENT;
 			new_state = TCP_CONNTRACK_SYN_RECV;
-			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_end =
-				ct->proto.tcp.last_end;
-			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxend =
-				ct->proto.tcp.last_end;
-			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_maxwin =
-				ct->proto.tcp.last_win == 0 ?
-					1 : ct->proto.tcp.last_win;
-			ct->proto.tcp.seen[ct->proto.tcp.last_dir].td_scale =
-				ct->proto.tcp.last_wscale;
-			ct->proto.tcp.last_flags &= ~IP_CT_EXP_CHALLENGE_ACK;
-			ct->proto.tcp.seen[ct->proto.tcp.last_dir].flags =
-				ct->proto.tcp.last_flags;
-			nf_ct_tcp_state_reset(&ct->proto.tcp.seen[dir]);
+			nf_ct_tcp_state_resync(ct, dir);
 			break;
 		}
-		ct->proto.tcp.last_index = index;
-		ct->proto.tcp.last_dir = dir;
-		ct->proto.tcp.last_seq = ntohl(th->seq);
-		ct->proto.tcp.last_end =
-		    segment_seq_plus_len(ntohl(th->seq), skb->len, dataoff, th);
-		ct->proto.tcp.last_win = ntohs(th->window);
+
+		nf_ct_tcp_state_annotate(ct, skb, th, dataoff, dir, index);
 
 		/* a) This is a SYN in ORIGINAL. The client and the server
 		 * may be in sync but we are not. In that case, we annotate
@@ -1082,20 +1133,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		 * responds with a challenge ACK if implementing RFC5961.
 		 */
 		if (index == TCP_SYN_SET && dir == IP_CT_DIR_ORIGINAL) {
-			struct ip_ct_tcp_state seen = {};
+			nf_ct_tcp_state_syn_annotate(ct, skb, th, dataoff);
 
-			ct->proto.tcp.last_flags =
-			ct->proto.tcp.last_wscale = 0;
-			tcp_options(skb, dataoff, th, &seen);
-			if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
-				ct->proto.tcp.last_flags |=
-					IP_CT_TCP_FLAG_WINDOW_SCALE;
-				ct->proto.tcp.last_wscale = seen.td_scale;
-			}
-			if (seen.flags & IP_CT_TCP_FLAG_SACK_PERM) {
-				ct->proto.tcp.last_flags |=
-					IP_CT_TCP_FLAG_SACK_PERM;
-			}
 			/* Mark the potential for RFC5961 challenge ACK,
 			 * this pose a special problem for LAST_ACK state
 			 * as ACK is intrepretated as ACKing last FIN.
@@ -1164,6 +1203,31 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		ct->proto.tcp.last_flags |= IP_CT_TCP_SIMULTANEOUS_OPEN;
 		break;
 	case TCP_CONNTRACK_SYN_RECV:
+		if (ct->proto.tcp.last_flags & IP_CT_TCP_REINIT) {
+			/* b) This SYN/ACK acknowledges a SYN that we earlier
+			 * ignored as invalid. This means that the client and
+			 * the server are both in sync, while the firewall is
+			 * not. We get in sync from the previously annotated
+			 * values.
+			 */
+			if (ntohl(th->ack_seq) == ct->proto.tcp.last_end) {
+				/* expected SYN/ACK acknowledges a SYN, get
+				 * in sync from last state.
+				 */
+				nf_ct_tcp_state_resync(ct, dir);
+			} else {
+				/* unexpected SYN/ACK acknowledges a SYN,
+				 * a late SYN has overridden last state.
+				 * Maybe under SYN flood? Its history is lost
+				 * for us, enable liberal tracking mode.
+				 */
+				ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+				ct->proto.tcp.seen[!dir].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+				nf_ct_l4proto_log_invalid(skb, ct, state,
+							  "SYN-ACK with unexpected ACK number after a TCP reinitialization");
+			}
+		}
+
 		if (dir == IP_CT_DIR_REPLY && index == TCP_ACK_SET &&
 		    ct->proto.tcp.last_flags & IP_CT_TCP_SIMULTANEOUS_OPEN)
 			new_state = TCP_CONNTRACK_ESTABLISHED;
-- 
2.30.2

