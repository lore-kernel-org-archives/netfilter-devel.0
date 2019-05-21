Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78846C04AB4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D128216B7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfEULbU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 07:31:20 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35494 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfEULbT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 07:31:19 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hT2zF-0008Tp-Tu; Tue, 21 May 2019 13:31:18 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     marcmicalizzi@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/5] netfilter: nft_flow_offload: set liberal tracking mode for tcp
Date:   Tue, 21 May 2019 13:24:31 +0200
Message-Id: <20190521112434.11767-3-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521112434.11767-1-fw@strlen.de>
References: <20190521112434.11767-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Without it, whenever a packet has to be pushed up the stack (e.g. because
of mtu mismatch), then conntrack will flag packets as invalid, which in
turn breaks NAT.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_flow_offload.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 69d7a8439c7a..bde63d9c3c4e 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -72,6 +72,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nf_flow_route route;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
+	bool is_tcp = false;
 	struct nf_conn *ct;
 	int ret;
 
@@ -84,6 +85,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 
 	switch (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum) {
 	case IPPROTO_TCP:
+		is_tcp = true;
+		break;
 	case IPPROTO_UDP:
 		break;
 	default:
@@ -108,6 +111,11 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (!flow)
 		goto err_flow_alloc;
 
+	if (is_tcp) {
+		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+		ct->proto.tcp.seen[1].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
+	}
+
 	ret = flow_offload_add(flowtable, flow);
 	if (ret < 0)
 		goto err_flow_add;
-- 
2.21.0

