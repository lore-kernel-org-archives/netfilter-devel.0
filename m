From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] nfnetlink_log: do not expose NFULNL_COPY_DISABLED to
	user-space
Date: Wed, 14 Jul 2010 13:49:14 +0200
Message-ID: <20100714114914.4622.56919.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294Ab0GNLtY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Jul 2010 07:49:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch moves NFULNL_COPY_PACKET definition from
linux/netfilter/nfnetlink_log.h to net/netfilter/nfnetlink_log.h
since this copy mode is only for internal use.

I have also changed the value from 0x03 to 0xff. Thus, we avoid
a gap from user-space that may confuse users if we add new
copy modes in the future.

This change was introduced in:
http://www.spinics.net/lists/netfilter-devel/msg13535.html

Since this change is not included in any stable Linux kernel,
I think it's safe to make this change now. Anyway, this copy
mode does not make any sense from user-space, so this patch
should not break any existing setup.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_log.h |    2 +-
 include/net/netfilter/nfnetlink_log.h   |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index 1d0b84a..ea9b8d3 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -89,7 +89,7 @@ enum nfulnl_attr_config {
 #define NFULNL_COPY_NONE	0x00
 #define NFULNL_COPY_META	0x01
 #define NFULNL_COPY_PACKET	0x02
-#define NFULNL_COPY_DISABLED	0x03
+/* 0xff is reserved, don't use it for new copy modes. */
 
 #define NFULNL_CFG_F_SEQ	0x0001
 #define NFULNL_CFG_F_SEQ_GLOBAL	0x0002
diff --git a/include/net/netfilter/nfnetlink_log.h b/include/net/netfilter/nfnetlink_log.h
index b0569ff..e2dec42 100644
--- a/include/net/netfilter/nfnetlink_log.h
+++ b/include/net/netfilter/nfnetlink_log.h
@@ -10,5 +10,7 @@ nfulnl_log_packet(u_int8_t pf,
 		  const struct nf_loginfo *li_user,
 		  const char *prefix);
 
+#define NFULNL_COPY_DISABLED    0xff
+
 #endif /* _KER_NFNETLINK_LOG_H */
 

