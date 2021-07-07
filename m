Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 035E3C07E95
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBDF761CC4
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhGGQVd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 12:21:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55112 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhGGQVb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 12:21:31 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8EFDD62440;
        Wed,  7 Jul 2021 18:18:38 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 02/11] netfilter: conntrack: do not renew entry stuck in tcp SYN_SENT state
Date:   Wed,  7 Jul 2021 18:18:35 +0200
Message-Id: <20210707161844.20827-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Consider:
  client -----> conntrack ---> Host

client sends a SYN, but $Host is unreachable/silent.
Client eventually gives up and the conntrack entry will time out.

However, if the client is restarted with same addr/port pair, it
may prevent the conntrack entry from timing out.

This is noticeable when the existing conntrack entry has no NAT
transformation or an outdated one and port reuse happens either
on client or due to a NAT middlebox.

This change prevents refresh of the timeout for SYN retransmits,
so entry is going away after nf_conntrack_tcp_timeout_syn_sent
seconds (default: 60).

Entry will be re-created on next connection attempt, but then
nat rules will be evaluated again.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index f7e8baf59b51..eb4de92077a8 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1134,6 +1134,16 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			nf_ct_kill_acct(ct, ctinfo, skb);
 			return NF_ACCEPT;
 		}
+
+		if (index == TCP_SYN_SET && old_state == TCP_CONNTRACK_SYN_SENT) {
+			/* do not renew timeout on SYN retransmit.
+			 *
+			 * Else port reuse by client or NAT middlebox can keep
+			 * entry alive indefinitely (including nat info).
+			 */
+			return NF_ACCEPT;
+		}
+
 		/* ESTABLISHED without SEEN_REPLY, i.e. mid-connection
 		 * pickup with loose=1. Avoid large ESTABLISHED timeout.
 		 */
-- 
2.20.1

