Return-Path: <SRS0=HMuw=IE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B426C43619
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D0E06501A
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Mar 2021 12:13:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbhCFMMy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Mar 2021 07:12:54 -0500
Received: from correo.us.es ([193.147.175.20]:46348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhCFMMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Mar 2021 07:12:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4906FC517A
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B788DA78F
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Mar 2021 13:12:32 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 20F08DA72F; Sat,  6 Mar 2021 13:12:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EC719DA73D;
        Sat,  6 Mar 2021 13:12:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Mar 2021 13:12:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id C278742DC6E2;
        Sat,  6 Mar 2021 13:12:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/9] netfilter: conntrack: avoid misleading 'invalid' in log message
Date:   Sat,  6 Mar 2021 13:12:18 +0100
Message-Id: <20210306121223.28711-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210306121223.28711-1-pablo@netfilter.org>
References: <20210306121223.28711-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The packet is not flagged as invalid: conntrack will accept it and
its associated with the conntrack entry.

This happens e.g. when receiving a retransmitted SYN in SYN_RECV state.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1d7e1c595546..ec23330687a5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -982,8 +982,10 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, "invalid packet ignored in "
-					  "state %s ", tcp_conntrack_names[old_state]);
+		nf_ct_l4proto_log_invalid(skb, ct,
+					  "packet (index %d) in dir %d ignored, state %s",
+					  index, dir,
+					  tcp_conntrack_names[old_state]);
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Special case for SYN proxy: when the SYN to the server or
-- 
2.20.1

