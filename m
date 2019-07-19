Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 786EEC76196
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57A9B2186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732131AbfGSQqb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:46:31 -0400
Received: from mail.us.es ([193.147.175.20]:50226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732122AbfGSQqb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:46:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29E37BAEE7
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:46:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 19A7B58F
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2019 18:46:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0F3AEDA732; Fri, 19 Jul 2019 18:46:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D38A58F;
        Fri, 19 Jul 2019 18:46:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:46:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 82F544265A2F;
        Fri, 19 Jul 2019 18:46:26 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/14] netfilter: synproxy: fix rst sequence number mismatch
Date:   Fri, 19 Jul 2019 18:46:15 +0200
Message-Id: <20190719164618.29581-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719164618.29581-1-pablo@netfilter.org>
References: <20190719164618.29581-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

14:51:00.024418 IP 192.168.122.1.41462 > netfilter.90: Flags [S], seq
4023580551,
14:51:00.024454 IP netfilter.90 > 192.168.122.1.41462: Flags [S.], seq
727560212, ack 4023580552,
14:51:00.024524 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,

Note: here, synproxy will send a SYN to the real server, as the 3whs was
completed sucessfully. Instead of a syn/ack that we can intercept, we instead
received a reset packet from the real backend, that we forward to the original
client. However, we don't use the correct sequence number, so the reset is not
effective in closing the connection coming from the client.

14:51:00.024550 IP netfilter.90 > 192.168.122.1.41462: Flags [R.], seq
3567407084,
14:51:00.231196 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:00.647911 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,
14:51:01.474395 IP 192.168.122.1.41462 > netfilter.90: Flags [.], ack 1,

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_synproxy_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 09718e5a9e41..c769462a839e 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -687,7 +687,7 @@ ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 	state = &ct->proto.tcp;
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
 			break;
@@ -1111,7 +1111,7 @@ ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 	state = &ct->proto.tcp;
 	switch (state->state) {
 	case TCP_CONNTRACK_CLOSE:
-		if (th->rst && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (th->rst && CTINFO2DIR(ctinfo) != IP_CT_DIR_ORIGINAL) {
 			nf_ct_seqadj_init(ct, ctinfo, synproxy->isn -
 						      ntohl(th->seq) + 1);
 			break;
-- 
2.11.0


