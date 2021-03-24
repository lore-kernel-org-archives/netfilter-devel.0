Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AF3C433FB
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B04CC619E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Mar 2021 01:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhCXBbu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 21:31:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60584 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbhCXBbU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 21:31:20 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 77835630CA;
        Wed, 24 Mar 2021 02:31:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next,v2 18/24] net: flow_offload: add FLOW_ACTION_PPPOE_PUSH
Date:   Wed, 24 Mar 2021 02:30:49 +0100
Message-Id: <20210324013055.5619-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210324013055.5619-1-pablo@netfilter.org>
References: <20210324013055.5619-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add an action to represent the PPPoE hardware offload support that
includes the session ID.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes.

 include/net/flow_offload.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index fde025c57b4f..dc5c1e69cd9f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -147,6 +147,7 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_POP,
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
+	FLOW_ACTION_PPPOE_PUSH,
 	NUM_FLOW_ACTIONS,
 };
 
@@ -274,6 +275,9 @@ struct flow_action_entry {
 			u32		num_entries;
 			struct action_gate_entry *entries;
 		} gate;
+		struct {				/* FLOW_ACTION_PPPOE_PUSH */
+			u16		sid;
+		} pppoe;
 	};
 	struct flow_action_cookie *cookie; /* user defined action cookie */
 };
-- 
2.20.1

