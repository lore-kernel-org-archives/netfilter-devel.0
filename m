Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7570FC07E95
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C05561C99
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jul 2021 16:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhGGQVp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jul 2021 12:21:45 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55184 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhGGQVj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jul 2021 12:21:39 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 09E4063116;
        Wed,  7 Jul 2021 18:18:45 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 11/11] netfilter: uapi: refer to nfnetlink_conntrack.h, not nf_conntrack_netlink.h
Date:   Wed,  7 Jul 2021 18:18:44 +0200
Message-Id: <20210707161844.20827-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Duncan Roe <duncan_roe@optusnet.com.au>

nf_conntrack_netlink.h does not exist, refer to nfnetlink_conntrack.h instead.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nfnetlink_log.h   | 2 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_log.h b/include/uapi/linux/netfilter/nfnetlink_log.h
index 45c8d3b027e0..0af9c113d665 100644
--- a/include/uapi/linux/netfilter/nfnetlink_log.h
+++ b/include/uapi/linux/netfilter/nfnetlink_log.h
@@ -61,7 +61,7 @@ enum nfulnl_attr_type {
 	NFULA_HWTYPE,			/* hardware type */
 	NFULA_HWHEADER,			/* hardware header */
 	NFULA_HWLEN,			/* hardware header length */
-	NFULA_CT,                       /* nf_conntrack_netlink.h */
+	NFULA_CT,                       /* nfnetlink_conntrack.h */
 	NFULA_CT_INFO,                  /* enum ip_conntrack_info */
 	NFULA_VLAN,			/* nested attribute: packet vlan info */
 	NFULA_L2HDR,			/* full L2 header */
diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index bcb2cb5d40b9..aed90c4df0c8 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -51,11 +51,11 @@ enum nfqnl_attr_type {
 	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
-	NFQA_CT,			/* nf_conntrack_netlink.h */
+	NFQA_CT,			/* nfnetlink_conntrack.h */
 	NFQA_CT_INFO,			/* enum ip_conntrack_info */
 	NFQA_CAP_LEN,			/* __u32 length of captured packet */
 	NFQA_SKB_INFO,			/* __u32 skb meta information */
-	NFQA_EXP,			/* nf_conntrack_netlink.h */
+	NFQA_EXP,			/* nfnetlink_conntrack.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
 	NFQA_SECCTX,			/* security context string */
-- 
2.20.1

