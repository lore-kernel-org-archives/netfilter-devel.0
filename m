Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0859CC432BE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Aug 2021 11:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF1BA60ED3
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Aug 2021 11:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhHRL5U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Aug 2021 07:57:20 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60376 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbhHRL5S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Aug 2021 07:57:18 -0400
Received: from localhost.localdomain (unknown [213.94.13.0])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9EC5D60075
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Aug 2021 13:55:54 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: ctnetlink: missing counters and timestamp in nfnetlink_{log,queue}
Date:   Wed, 18 Aug 2021 13:56:39 +0200
Message-Id: <20210818115639.10032-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add counters and timestamps (if available) to the conntrack object
that is represented in nfnetlink_log and _queue messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index eb35c6151fb0..0677531ce8db 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2669,6 +2669,8 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
 	       + ctnetlink_secctx_size(ct)
+	       + ctnetlink_acct_size(ct)
+	       + ctnetlink_timestamp_size(ct)
 #if IS_ENABLED(CONFIG_NF_NAT)
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
 	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
@@ -2726,6 +2728,10 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 	if (ctnetlink_dump_protoinfo(skb, ct, false) < 0)
 		goto nla_put_failure;
 
+	if (ctnetlink_dump_acct(skb, ct, IPCTNL_MSG_CT_GET) < 0 ||
+	    ctnetlink_dump_timestamp(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nla_put_failure;
 
-- 
2.20.1

