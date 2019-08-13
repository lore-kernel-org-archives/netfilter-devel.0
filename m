Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4369C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 08:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83105206C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 08:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfHMIvg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 04:51:36 -0400
Received: from correo.us.es ([193.147.175.20]:37278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfHMIvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 04:51:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A016CDA72B
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 10:51:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 924A7DA704
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 10:51:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88206DA730; Tue, 13 Aug 2019 10:51:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4725ADA704
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 10:51:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Aug 2019 10:51:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.218.116])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1EA8E4265A32
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 10:51:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nft_flow_offload: skip tcp rst and fin packets
Date:   Tue, 13 Aug 2019 10:51:27 +0200
Message-Id: <20190813085127.3860-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

TCP rst and fin packets do not qualify to place a flow into the
flowtable. Most likely there will be no more packets after connection
closure. Without this patch, this flow entry expires and connection
tracking picks up the entry in ESTABLISHED state using the fixup
timeout, which makes this look inconsistent to the user for a connection
that is actually already closed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index aa5f571d4361..6dc54c2ca856 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -73,10 +73,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
 	enum ip_conntrack_info ctinfo;
+	struct tcphdr *tcph = NULL;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
-	bool is_tcp = false;
 	struct nf_conn *ct;
 	int ret;
 
@@ -89,7 +89,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 
 	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
 	case IPPROTO_TCP:
-		is_tcp = true;
+		tcph = (void *)(skb_network_header(pkt->skb) + pkt->xt.thoff);
+		if (unlikely(tcph->fin || tcph->rst))
+			goto out;
 		break;
 	case IPPROTO_UDP:
 		break;
@@ -115,7 +117,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (!flow)
 		goto err_flow_alloc;
 
-	if (is_tcp) {
+	if (tcph) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
 	}
-- 
2.11.0


