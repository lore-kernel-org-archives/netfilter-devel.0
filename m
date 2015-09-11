From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH lnf-log 1/3] include: Sync with kernel headers
Date: Fri, 11 Sep 2015 12:12:11 +0900
Message-ID: <20150911031210.GE7380@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33132 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbbIKDMQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 23:12:16 -0400
Received: by pacex6 with SMTP id ex6so61416674pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 20:12:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150911030530.GA7380@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/libnetfilter_log/linux_nfnetlink_log.h | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/libnetfilter_log/linux_nfnetlink_log.h b/include/libnetfilter_log/linux_nfnetlink_log.h
index 9f38277..081e7f9 100644
--- a/include/libnetfilter_log/linux_nfnetlink_log.h
+++ b/include/libnetfilter_log/linux_nfnetlink_log.h
@@ -1,16 +1,12 @@
 #ifndef _NFNETLINK_LOG_H
 #define _NFNETLINK_LOG_H
 
-#ifndef aligned_u64
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
-#endif
-
 /* This file describes the netlink messages (i.e. 'protocol packets'),
  * and not any kind of function definitions.  It is shared between kernel and
  * userspace.  Don't put kernel specific stuff in here */
 
 #include <linux/types.h>
-#include <libnfnetlink/linux_nfnetlink.h>
+#include <linux/netfilter/nfnetlink.h>
 
 enum nfulnl_msg_types {
 	NFULNL_MSG_PACKET,		/* packet from kernel to userspace */
@@ -55,6 +51,8 @@ enum nfulnl_attr_type {
 	NFULA_HWTYPE,			/* hardware type */
 	NFULA_HWHEADER,			/* hardware header */
 	NFULA_HWLEN,			/* hardware header length */
+	NFULA_CT,			/* nf_conntrack_netlink.h */
+	NFULA_CT_INFO,			/* enum ip_conntrack_info */
 
 	__NFULA_MAX
 };
@@ -97,5 +95,6 @@ enum nfulnl_attr_config {
 
 #define NFULNL_CFG_F_SEQ	0x0001
 #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
+#define NFULNL_CFG_F_CONNTRACK	0x0004
 
 #endif /* _NFNETLINK_LOG_H */
-- 
2.1.4

