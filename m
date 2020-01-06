Return-Path: <SRS0=Xvwf=23=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39FAFC33C8C
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 11:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 131B12071A
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jan 2020 11:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgAFLsB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 06:48:01 -0500
Received: from correo.us.es ([193.147.175.20]:35980 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgAFLsB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 06:48:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29667F2DE5
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 12:47:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A313DA705
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 12:47:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0FD49DA702; Mon,  6 Jan 2020 12:47:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 144E3DA70E
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 12:47:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Jan 2020 12:47:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 00F5C41E4800
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Jan 2020 12:47:55 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: flowtable: restrict flow dissector match on meta ingress device
Date:   Mon,  6 Jan 2020 12:47:53 +0100
Message-Id: <20200106114753.7765-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set on FLOW_DISSECTOR_KEY_META meta key using flow tuple ingress interface.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 4d1e81e2880f..b879e673953f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -24,6 +24,7 @@ struct flow_offload_work {
 };
 
 struct nf_flow_key {
+	struct flow_dissector_key_meta			meta;
 	struct flow_dissector_key_control		control;
 	struct flow_dissector_key_basic			basic;
 	union {
@@ -55,6 +56,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	struct nf_flow_key *mask = &match->mask;
 	struct nf_flow_key *key = &match->key;
 
+	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_META, meta);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_CONTROL, control);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_BASIC, basic);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_IPV4_ADDRS, ipv4);
@@ -62,6 +64,9 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
+	key->meta.ingress_ifindex = tuple->iifidx;
+	mask->meta.ingress_ifindex = 0xffffffff;
+
 	switch (tuple->l3proto) {
 	case AF_INET:
 		key->control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
@@ -105,7 +110,8 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	key->tp.dst = tuple->dst_port;
 	mask->tp.dst = 0xffff;
 
-	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_CONTROL) |
+	match->dissector.used_keys |= BIT(FLOW_DISSECTOR_KEY_META) |
+				      BIT(FLOW_DISSECTOR_KEY_CONTROL) |
 				      BIT(FLOW_DISSECTOR_KEY_BASIC) |
 				      BIT(FLOW_DISSECTOR_KEY_PORTS);
 	return 0;
-- 
2.11.0

