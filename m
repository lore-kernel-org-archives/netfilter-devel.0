Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E0FC2D0E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F3D5206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgC3AiQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:38:16 -0400
Received: from correo.us.es ([193.147.175.20]:57126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbgC3AhV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E3A45DA72F
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2D09100A42
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C7D69100A4B; Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6FE2100A42;
        Mon, 30 Mar 2020 02:37:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A0F6842EF42A;
        Mon, 30 Mar 2020 02:37:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/26] netfilter: flowtable: fix NULL pointer dereference in tunnel offload support
Date:   Mon, 30 Mar 2020 02:36:48 +0200
Message-Id: <20200330003708.54017-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

The tc ct action does not cache the route in the flowtable entry.

Fixes: 88bf6e4114d5 ("netfilter: flowtable: add tunnel encap/decap action offload support")
Fixes: cfab6dbd0ecf ("netfilter: flowtable: add tunnel match offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ad549317af30..a68136a8d750 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -92,7 +92,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
-	if (other_dst->lwtstate) {
+	if (other_dst && other_dst->lwtstate) {
 		tun_info = lwt_tun_info(other_dst->lwtstate);
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
@@ -483,7 +483,7 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 	struct dst_entry *dst;
 
 	dst = flow->tuplehash[dir].tuple.dst_cache;
-	if (dst->lwtstate) {
+	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
 		tun_info = lwt_tun_info(dst->lwtstate);
@@ -503,7 +503,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 	struct dst_entry *dst;
 
 	dst = flow->tuplehash[!dir].tuple.dst_cache;
-	if (dst->lwtstate) {
+	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
 		tun_info = lwt_tun_info(dst->lwtstate);
-- 
2.11.0

