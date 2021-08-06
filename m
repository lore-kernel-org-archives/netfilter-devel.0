Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E068CC4338F
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 11:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C690261102
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Aug 2021 11:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245743AbhHFLwe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:52:34 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33254 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245739AbhHFLwd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Aug 2021 07:52:33 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id CED1B60057;
        Fri,  6 Aug 2021 13:51:37 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/9] netfilter: nf_conntrack_bridge: Fix memory leak when error
Date:   Fri,  6 Aug 2021 13:52:00 +0200
Message-Id: <20210806115207.2976-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806115207.2976-1-pablo@netfilter.org>
References: <20210806115207.2976-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Yajun Deng <yajun.deng@linux.dev>

It should be added kfree_skb_list() when err is not equal to zero
in nf_br_ip_fragment().

v2: keep this aligned with IPv6.
v3: modify iter.frag_list to iter.frag.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_conntrack_bridge.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8d033a75a766..fdbed3158555 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -88,6 +88,12 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 			skb = ip_fraglist_next(&iter);
 		}
+
+		if (!err)
+			return 0;
+
+		kfree_skb_list(iter.frag);
+
 		return err;
 	}
 slow_path:
-- 
2.20.1

