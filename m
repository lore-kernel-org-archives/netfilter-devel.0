Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070FFECAAA3
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Aug 2022 13:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiHZNcz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Aug 2022 09:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245434AbiHZNcy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Aug 2022 09:32:54 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B451CDC5CF
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Aug 2022 06:32:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oRZS8-0002gH-6A; Fri, 26 Aug 2022 15:32:52 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next 4/4] netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst
Date:   Fri, 26 Aug 2022 15:32:27 +0200
Message-Id: <20220826133227.3673-5-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220826133227.3673-1-fw@strlen.de>
References: <20220826133227.3673-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In case the endpoints and conntrack go out-of-sync, i.e. there is
disagreement wrt. validy of sequence/ack numbers between conntracks
internal state and those of the endpoints, connections can hang for a
long time (until ESTABLISHED timeout).

This adds a check to detect a fin/fin exchange even if those are
invalid.  The timeout is then lowered to UNACKED (default 300s).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: new patch.

 net/netfilter/nf_conntrack_proto_tcp.c | 58 ++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a2630647a4bb..fd345c40bed9 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -716,6 +716,63 @@ tcp_in_window(struct nf_conn *ct, enum ip_conntrack_dir dir,
 	return NFCT_TCP_ACCEPT;
 }
 
+static void __cold nf_tcp_handle_invalid(struct nf_conn *ct,
+					 enum ip_conntrack_dir dir,
+					 int index,
+					 const struct sk_buff *skb,
+					 const struct nf_hook_state *hook_state)
+{
+	const unsigned int *timeouts;
+	const struct nf_tcp_net *tn;
+	unsigned int timeout;
+	u32 expires;
+
+	if (!test_bit(IPS_ASSURED_BIT, &ct->status) ||
+	    test_bit(IPS_FIXED_TIMEOUT_BIT, &ct->status))
+		return;
+
+	/* We don't want to have connections hanging around in ESTABLISHED
+	 * state for long time 'just because' conntrack deemed a FIN/RST
+	 * out-of-window.
+	 *
+	 * Shrink the timeout just like when there is unacked data.
+	 * This speeds up eviction of 'dead' connections where the
+	 * connection and conntracks internal state are out of sync.
+	 */
+	switch (index) {
+	case TCP_RST_SET:
+	case TCP_FIN_SET:
+		break;
+	default:
+		return;
+	}
+
+	if (ct->proto.tcp.last_dir != dir &&
+	    (ct->proto.tcp.last_index == TCP_FIN_SET ||
+	     ct->proto.tcp.last_index == TCP_RST_SET)) {
+		expires = nf_ct_expires(ct);
+		if (expires < 120 * HZ)
+			return;
+
+		tn = nf_tcp_pernet(nf_ct_net(ct));
+		timeouts = nf_ct_timeout_lookup(ct);
+		if (!timeouts)
+			timeouts = tn->timeouts;
+
+		timeout = READ_ONCE(timeouts[TCP_CONNTRACK_UNACK]);
+		if (expires > timeout) {
+			nf_ct_l4proto_log_invalid(skb, ct, hook_state,
+					  "packet (index %d, dir %d) response for index %d lower timeout to %u",
+					  index, dir, ct->proto.tcp.last_index, timeout);
+
+			WRITE_ONCE(ct->timeout, timeout + nfct_time_stamp);
+		}
+	} else {
+                ct->proto.tcp.last_index = index;
+                ct->proto.tcp.last_dir = dir;
+	}
+}
+
 /* table of valid flag combinations - PUSH, ECE and CWR are always valid */
 static const u8 tcp_valid_flags[(TCPHDR_FIN|TCPHDR_SYN|TCPHDR_RST|TCPHDR_ACK|
 				 TCPHDR_URG) + 1] =
@@ -1148,6 +1205,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 		spin_unlock_bh(&ct->lock);
 		return NF_ACCEPT;
 	case NFCT_TCP_INVALID:
+		nf_tcp_handle_invalid(ct, dir, index, skb, state);
 		spin_unlock_bh(&ct->lock);
 		return -NF_ACCEPT;
 	case NFCT_TCP_ACCEPT:
-- 
2.35.1

