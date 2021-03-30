Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F01C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 23:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98A22619DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 23:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhC3XHF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 19:07:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46604 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbhC3XG5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 19:06:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A602463E4D;
        Wed, 31 Mar 2021 01:06:42 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf] netfilter: conntrack: do not print icmpv6 as unknown via /proc
Date:   Wed, 31 Mar 2021 01:06:53 +0200
Message-Id: <20210330230653.160939-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

/proc/net/nf_conntrack shows icmpv6 as unknown.

Fixes: 09ec82f5af99 ("netfilter: conntrack: remove protocol name from l4proto struct")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_standalone.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ee702d374b0..c6c0cb465664 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -266,6 +266,7 @@ static const char* l4proto_name(u16 proto)
 	case IPPROTO_GRE: return "gre";
 	case IPPROTO_SCTP: return "sctp";
 	case IPPROTO_UDPLITE: return "udplite";
+	case IPPROTO_ICMPV6: return "icmpv6";
 	}
 
 	return "unknown";
-- 
2.30.2

