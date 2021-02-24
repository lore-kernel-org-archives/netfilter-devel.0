Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D5FC433DB
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC34C64EF1
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Feb 2021 16:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbhBXQYZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhBXQYW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Feb 2021 11:24:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDF6C061786
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Feb 2021 08:23:41 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lEwwu-00031a-12; Wed, 24 Feb 2021 17:23:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 2/3] netfilter: conntrack: avoid misleading 'invalid' in log message
Date:   Wed, 24 Feb 2021 17:23:20 +0100
Message-Id: <20210224162321.4899-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210224162321.4899-1-fw@strlen.de>
References: <20210224162321.4899-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The packet is not flagged as invalid: conntrack will accept it and
its associated with the conntrack entry.

This happens e.g. when receiving a retransmitted SYN in SYN_RECV state.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1d7e1c595546..ec23330687a5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -982,8 +982,10 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 					IP_CT_EXP_CHALLENGE_ACK;
 		}
 		spin_unlock_bh(&ct->lock);
-		nf_ct_l4proto_log_invalid(skb, ct, "invalid packet ignored in "
-					  "state %s ", tcp_conntrack_names[old_state]);
+		nf_ct_l4proto_log_invalid(skb, ct,
+					  "packet (index %d) in dir %d ignored, state %s",
+					  index, dir,
+					  tcp_conntrack_names[old_state]);
 		return NF_ACCEPT;
 	case TCP_CONNTRACK_MAX:
 		/* Special case for SYN proxy: when the SYN to the server or
-- 
2.26.2

