Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBD2C76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8097E2186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbfGSQpt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:45:49 -0400
Received: from mail.us.es ([193.147.175.20]:49916 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731912AbfGSQpt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:45:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CCC2CBAF03
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA65FD190F
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AC9A6DA704; Fri, 19 Jul 2019 18:45:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B54E9D2F98;
        Fri, 19 Jul 2019 18:45:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:45:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 349804265A2F;
        Fri, 19 Jul 2019 18:45:31 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 07/14] netfilter: conntrack: always store window size un-scaled
Date:   Fri, 19 Jul 2019 18:45:10 +0200
Message-Id: <20190719164517.29496-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164517.29496-1-pablo@netfilter.org>
References: <20190719164517.29496-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Jakub Jankowski reported following oddity:

After 3 way handshake completes, timeout of new connection is set to
max_retrans (300s) instead of established (5 days).

shortened excerpt from pcap provided:
25.070622 IP (flags [DF], proto TCP (6), length 52)
10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
26.070462 IP (flags [DF], proto TCP (6), length 48)
10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
27.070449 IP (flags [DF], proto TCP (6), length 40)
10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0

Turns out the last_win is of u16 type, but we store the scaled value:
512 << 8 (== 0x20000) becomes 0 window.

The Fixes tag is not correct, as the bug has existed forever, but
without that change all that this causes might cause is to mistake a
window update (to-nonzero-from-zero) for a retransmit.

Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
Reported-by: Jakub Jankowski <shasta@toxcorp.com>
Tested-by: Jakub Jankowski <shasta@toxcorp.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index d5fdfa00d683..85c1f8c213b0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -472,6 +472,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
+	u16 win_raw;
 	s32 receiver_offset;
 	bool res, in_recv_win;
 
@@ -480,7 +481,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	 */
 	seq = ntohl(tcph->seq);
 	ack = sack = ntohl(tcph->ack_seq);
-	win = ntohs(tcph->window);
+	win_raw = ntohs(tcph->window);
+	win = win_raw;
 	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
 
 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
@@ -655,14 +657,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			    && state->last_seq == seq
 			    && state->last_ack == ack
 			    && state->last_end == end
-			    && state->last_win == win)
+			    && state->last_win == win_raw)
 				state->retrans++;
 			else {
 				state->last_dir = dir;
 				state->last_seq = seq;
 				state->last_ack = ack;
 				state->last_end = end;
-				state->last_win = win;
+				state->last_win = win_raw;
 				state->retrans = 0;
 			}
 		}
-- 
2.11.0


