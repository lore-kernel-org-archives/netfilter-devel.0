Return-Path: <SRS0=FL4W=WF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED4BC31E40
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA7C2086A
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Aug 2019 10:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfHIKn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 06:43:58 -0400
Received: from correo.us.es ([193.147.175.20]:36096 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbfHIKn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 06:43:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15910C3280
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0629CDA72F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EFEA4ADF8; Fri,  9 Aug 2019 12:43:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EB494DA72F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:53 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 09 Aug 2019 12:43:53 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (149.103.108.93.rev.vodafone.pt [93.108.103.149])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 67EB04265A2F
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Aug 2019 12:43:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_flow_table: teardown flow timeout race
Date:   Fri,  9 Aug 2019 12:42:37 +0200
Message-Id: <20190809104237.2553-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190809104237.2553-1-pablo@netfilter.org>
References: <20190809104237.2553-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Flows that are in teardown state (due to RST / FIN TCP packet) still
have their offload flag set on. Hence, the conntrack garbage collector
may race to undo the timeout adjustment that the fixup routine performs,
leaving the conntrack entry in place with the internal offload timeout
(one day).

Update teardown flow state to ESTABLISHED and set tracking to liberal,
then once the offload bit is cleared, adjust timeout if it is more than
the default fixup timeout (conntrack might already have set a lower
timeout from the packet path).

Fixes: da5984e51063 ("netfilter: nf_flow_table: add support for sending flows back to the slow path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 68a24471ffee..80a8f9ae4c93 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -111,15 +111,16 @@ static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
 #define NF_FLOWTABLE_TCP_PICKUP_TIMEOUT	(120 * HZ)
 #define NF_FLOWTABLE_UDP_PICKUP_TIMEOUT	(30 * HZ)
 
-static void flow_offload_fixup_ct(struct nf_conn *ct)
+static inline __s32 nf_flow_timeout_delta(unsigned int timeout)
+{
+	return (__s32)(timeout - (u32)jiffies);
+}
+
+static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
 {
 	const struct nf_conntrack_l4proto *l4proto;
+	int l4num = nf_ct_protonum(ct);
 	unsigned int timeout;
-	int l4num;
-
-	l4num = nf_ct_protonum(ct);
-	if (l4num == IPPROTO_TCP)
-		flow_offload_fixup_tcp(&ct->proto.tcp);
 
 	l4proto = nf_ct_l4proto_find(l4num);
 	if (!l4proto)
@@ -132,7 +133,20 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	else
 		return;
 
-	ct->timeout = nfct_time_stamp + timeout;
+	if (nf_flow_timeout_delta(ct->timeout) > (__s32)timeout)
+		ct->timeout = nfct_time_stamp + timeout;
+}
+
+static void flow_offload_fixup_ct_state(struct nf_conn *ct)
+{
+	if (nf_ct_protonum(ct) == IPPROTO_TCP)
+		flow_offload_fixup_tcp(&ct->proto.tcp);
+}
+
+static void flow_offload_fixup_ct(struct nf_conn *ct)
+{
+	flow_offload_fixup_ct_state(ct);
+	flow_offload_fixup_ct_timeout(ct);
 }
 
 void flow_offload_free(struct flow_offload *flow)
@@ -210,7 +224,7 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
-	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
+	return nf_flow_timeout_delta(flow->timeout) <= 0;
 }
 
 static void flow_offload_del(struct nf_flowtable *flow_table,
@@ -230,6 +244,8 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 	if (nf_flow_has_expired(flow))
 		flow_offload_fixup_ct(e->ct);
+	else if (flow->flags & FLOW_OFFLOAD_TEARDOWN)
+		flow_offload_fixup_ct_timeout(e->ct);
 
 	flow_offload_free(flow);
 }
@@ -241,7 +257,7 @@ void flow_offload_teardown(struct flow_offload *flow)
 	flow->flags |= FLOW_OFFLOAD_TEARDOWN;
 
 	e = container_of(flow, struct flow_offload_entry, flow);
-	flow_offload_fixup_ct(e->ct);
+	flow_offload_fixup_ct_state(e->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.11.0

