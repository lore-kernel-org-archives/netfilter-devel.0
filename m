Return-Path: <SRS0=nYb5=ZV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121B1C432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 09:10:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1622215A5
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Nov 2019 09:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfK2JKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 04:10:25 -0500
Received: from correo.us.es ([193.147.175.20]:37006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfK2JKZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 04:10:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5863FC2B26
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 10:10:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A2E8DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 10:10:21 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 499B6DA701; Fri, 29 Nov 2019 10:10:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29423DA702
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 10:10:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 Nov 2019 10:10:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (barqueta.lsi.us.es [150.214.188.150])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 238B142EE38E
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2019 10:10:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_flow_table_offload: add IPv6 match description
Date:   Fri, 29 Nov 2019 10:10:17 +0100
Message-Id: <20191129091017.188647-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing IPv6 matching description to flow_rule object.

Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dd78ae5441e9..c94ebad78c5c 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -28,6 +28,7 @@ struct nf_flow_key {
 	struct flow_dissector_key_basic			basic;
 	union {
 		struct flow_dissector_key_ipv4_addrs	ipv4;
+		struct flow_dissector_key_ipv6_addrs	ipv6;
 	};
 	struct flow_dissector_key_tcp			tcp;
 	struct flow_dissector_key_ports			tp;
@@ -57,6 +58,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV6_ADDRS, ipv6);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
@@ -69,9 +71,18 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 		key->ipv4.dst = tuple->dst_v4.s_addr;
 		mask->ipv4.dst = 0xffffffff;
 		break;
+       case AF_INET6:
+		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV6_ADDRS;
+		key->basic.n_proto = htons(ETH_P_IPV6);
+		key->ipv6.src = tuple->src_v6;
+		memset(&mask->ipv6.src, 0xff, sizeof(mask->ipv6.src));
+		key->ipv6.dst = tuple->dst_v6;
+		memset(&mask->ipv6.dst, 0xff, sizeof(mask->ipv6.dst));
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
+	match->dissector.used_keys |= BIT(key->control.addr_type);
 	mask->basic.n_proto = 0xffff;
 
 	switch (tuple->l4proto) {
@@ -96,7 +107,6 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 
 	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
-				      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
 				      BIT(FLOW_DISSECTOR_KEY_PORTS);
 	return 0;
 }
-- 
2.11.0

