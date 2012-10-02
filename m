From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH] includes: add definitions of nfnl_tables
Date: Tue,  2 Oct 2012 15:07:12 +0200
Message-ID: <1349183232-4212-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1349183171-4136-2-git-send-email-nicolas.dichtel@6wind.com>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:39285 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab2JBNCh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:02:37 -0400
In-Reply-To: <1349183171-4136-2-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 include/libnfnetlink/linux_nfnetlink.h        | 3 +++
 include/libnfnetlink/linux_nfnetlink_compat.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/libnfnetlink/linux_nfnetlink.h b/include/libnfnetlink/linux_nfnetlink.h
index 76a8550..82785d9 100644
--- a/include/libnfnetlink/linux_nfnetlink.h
+++ b/include/libnfnetlink/linux_nfnetlink.h
@@ -18,6 +18,8 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_TABLES,
+#define NFNLGRP_TABLES			NFNLGRP_TABLES
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
@@ -47,6 +49,7 @@ struct nfgenmsg {
 #define NFNL_SUBSYS_QUEUE		3
 #define NFNL_SUBSYS_ULOG		4
 #define NFNL_SUBSYS_COUNT		5
+#define NFNL_SUBSYS_TABLES		10
 
 #ifdef __KERNEL__
 
diff --git a/include/libnfnetlink/linux_nfnetlink_compat.h b/include/libnfnetlink/linux_nfnetlink_compat.h
index e145176..2546e01 100644
--- a/include/libnfnetlink/linux_nfnetlink_compat.h
+++ b/include/libnfnetlink/linux_nfnetlink_compat.h
@@ -10,6 +10,7 @@
 #define NF_NETLINK_CONNTRACK_EXP_NEW		0x00000008
 #define NF_NETLINK_CONNTRACK_EXP_UPDATE		0x00000010
 #define NF_NETLINK_CONNTRACK_EXP_DESTROY	0x00000020
+#define NF_NETLINK_TABLES			0x00000040
 
 /* Generic structure for encapsulation optional netfilter information.
  * It is reminiscent of sockaddr, but with sa_family replaced
-- 
1.7.12

