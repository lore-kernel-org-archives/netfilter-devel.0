Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166C4C46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Jan 2023 13:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjAKNoI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 08:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbjAKNnK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 08:43:10 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034CD2E4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2023 05:42:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pFbNE-0003o3-Ff; Wed, 11 Jan 2023 14:42:36 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf] netfilter: conntrack: handle tcp challenge acks during connection reuse
Date:   Wed, 11 Jan 2023 14:42:32 +0100
Message-Id: <20230111134232.2631-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When a connection is re-used, following can happen:
[ connection starts to close, fin sent in either direction ]
 > syn   # initator quickly reuses connection
 < ack   # peer sends a challenge ack
 > rst   # rst, sequence number == ack_seq of previous challenge ack
 > syn   # this syn is expected to pass

Problem is that the rst will fail window validation, so it gets
tagged as invalid.

If ruleset drops such packets, we get repeated syn-retransmits until
initator gives up or peer starts responding with syn/ack.

Before the commit indicated in the "Fixes" tag below this used to work:

The challenge-ack made conntrack re-init state based on the challenge
ack itself, so the following rst would pass window validation.

Add challenge-ack support: If we get ack for syn, record the ack_seq,
and then check if the rst sequence number matches the last ack number
seen in reverse direction.

Fixes: c7aab4f17021 ("netfilter: nf_conntrack_tcp: re-init for syn packets only")
Reported-by: Michal Tesar <mtesar@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 656631083177..3ac1af6f59fc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1068,6 +1068,13 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 				ct->proto.tcp.last_flags |=
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
+
+		/* possible challenge ack reply to syn */
+		if (old_state == TCP_CONNTRACK_SYN_SENT &&
+		    index == TCP_ACK_SET &&
+		    dir == IP_CT_DIR_REPLY)
+			ct->proto.tcp.last_ack = ntohl(th->ack_seq);
+
 		spin_unlock_bh(&ct->lock);
 		nf_ct_l4proto_log_invalid(skb, ct, state,
 					  "packet (index %d) in dir %d ignored, state %s",
@@ -1193,6 +1200,14 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			 * segments we ignored. */
 			goto in_window;
 		}
+
+		/* Reset in response to a challenge-ack we let through earlier */
+		if (old_state == TCP_CONNTRACK_SYN_SENT &&
+		    ct->proto.tcp.last_index == TCP_ACK_SET &&
+		    ct->proto.tcp.last_dir == IP_CT_DIR_REPLY &&
+		    ntohl(th->seq) == ct->proto.tcp.last_ack)
+			goto in_window;
+
 		break;
 	default:
 		/* Keep compilers happy. */
-- 
2.38.2

