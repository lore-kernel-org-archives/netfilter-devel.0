From: pablo@netfilter.org
Subject: [PATCH] [libnetfilter_conntrack] refresh our public copy of nfnetlink_conntrack.h
Date: Thu, 29 Nov 2012 19:38:38 +0100
Message-ID: <1354214318-8769-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41758 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2K2SjI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:39:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

To include: IPCTNL_MSG_CT_GET_DYING and IPCTNL_MSG_CT_GET_UNCONFIRMED

[ This is required by: http://patchwork.ozlabs.org/patch/202751/ ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 1e32c7f..39366c4 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -13,6 +13,8 @@ enum cntl_msg_types {
 	IPCTNL_MSG_CT_GET_CTRZERO,
 	IPCTNL_MSG_CT_GET_STATS_CPU,
 	IPCTNL_MSG_CT_GET_STATS,
+	IPCTNL_MSG_CT_GET_DYING,
+	IPCTNL_MSG_CT_GET_UNCONFIRMED,
 
 	IPCTNL_MSG_MAX
 };
-- 
1.7.10.4

