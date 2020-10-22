Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4353BC388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA59C24641
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900434AbgJVR3w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:29:52 -0400
Received: from correo.us.es ([193.147.175.20]:54120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2899801AbgJVR3i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A01081C4393
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EC56DA853
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8318BDA84A; Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1692ADA84D;
        Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:34 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id DE13D42EE38E;
        Thu, 22 Oct 2020 19:29:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/7] netfilter: conntrack: connection timeout after re-register
Date:   Thu, 22 Oct 2020 19:29:20 +0200
Message-Id: <20201022172925.22770-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

If the first packet conntrack sees after a re-register is an outgoing
keepalive packet with no data (SEG.SEQ = SND.NXT-1), td_end is set to
SND.NXT-1.
When the peer correctly acknowledges SND.NXT, tcp_in_window fails
check III (Upper bound for valid (s)ack: sack <= receiver.td_end) and
returns false, which cascades into nf_conntrack_in setting
skb->_nfct = 0 and in later conntrack iptables rules not matching.
In cases where iptables are dropping packets that do not match
conntrack rules this can result in idle tcp connections to time out.

v2: adjust td_end when getting the reply rather than when sending out
    the keepalive packet.

Fixes: f94e63801ab2 ("netfilter: conntrack: reset tcp maxwin on re-register")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index e8c86ee4c1c4..c8fb2187ad4b 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -541,13 +541,20 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			swin = win << sender->td_scale;
 			sender->td_maxwin = (swin == 0 ? 1 : swin);
 			sender->td_maxend = end + sender->td_maxwin;
-			/*
-			 * We haven't seen traffic in the other direction yet
-			 * but we have to tweak window tracking to pass III
-			 * and IV until that happens.
-			 */
-			if (receiver->td_maxwin == 0)
+			if (receiver->td_maxwin == 0) {
+				/* We haven't seen traffic in the other
+				 * direction yet but we have to tweak window
+				 * tracking to pass III and IV until that
+				 * happens.
+				 */
 				receiver->td_end = receiver->td_maxend = sack;
+			} else if (sack == receiver->td_end + 1) {
+				/* Likely a reply to a keepalive.
+				 * Needed for III.
+				 */
+				receiver->td_end++;
+			}
+
 		}
 	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
 		     && dir == IP_CT_DIR_ORIGINAL)
-- 
2.20.1

