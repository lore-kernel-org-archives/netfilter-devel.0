Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36503C388F7
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D039B24656
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900148AbgJVR3j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:29:39 -0400
Received: from correo.us.es ([193.147.175.20]:54106 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900109AbgJVR3h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFDC41C4399
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFC0EDA84A
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A4BC3DA722; Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6C980DA84A;
        Thu, 22 Oct 2020 19:29:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 41B6C42EE38E;
        Thu, 22 Oct 2020 19:29:33 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/7] ipvs: adjust the debug info in function set_tcp_state
Date:   Thu, 22 Oct 2020 19:29:19 +0200
Message-Id: <20201022172925.22770-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "longguang.yue" <bigclouds@163.com>

Outputting client,virtual,dst addresses info when tcp state changes,
which makes the connection debug more clear

Signed-off-by: longguang.yue <bigclouds@163.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index dc2e7da2742a..7da51390cea6 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -539,8 +539,8 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 	if (new_state != cp->state) {
 		struct ip_vs_dest *dest = cp->dest;
 
-		IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] %s:%d->"
-			      "%s:%d state: %s->%s conn->refcnt:%d\n",
+		IP_VS_DBG_BUF(8, "%s %s [%c%c%c%c] c:%s:%d v:%s:%d "
+			      "d:%s:%d state: %s->%s conn->refcnt:%d\n",
 			      pd->pp->name,
 			      ((state_off == TCP_DIR_OUTPUT) ?
 			       "output " : "input "),
@@ -548,10 +548,12 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			      th->fin ? 'F' : '.',
 			      th->ack ? 'A' : '.',
 			      th->rst ? 'R' : '.',
-			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
-			      ntohs(cp->dport),
 			      IP_VS_DBG_ADDR(cp->af, &cp->caddr),
 			      ntohs(cp->cport),
+			      IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
+			      ntohs(cp->vport),
+			      IP_VS_DBG_ADDR(cp->daf, &cp->daddr),
+			      ntohs(cp->dport),
 			      tcp_state_name(cp->state),
 			      tcp_state_name(new_state),
 			      refcount_read(&cp->refcnt));
-- 
2.20.1

