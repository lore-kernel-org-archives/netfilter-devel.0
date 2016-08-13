From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nfnetlink_log: add "nf-logger-3-1" module alias name
Date: Sat, 13 Aug 2016 22:46:04 +0800
Message-ID: <1471099564-3743-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:34523 "EHLO m12-16.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbcHMOqn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Aug 2016 10:46:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Otherwise, if nfnetlink_log.ko is not loaded, we cannot add rules
to log packets to the userspace when we specify it with arp family,
such as:

  # nft add rule arp filter input log group 0
  <cmdline>:1:1-37: Error: Could not process rule: No such file or
  directory
  add rule arp filter input log group 0
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nfnetlink_log.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index cbcfdfb..6577db5 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1147,6 +1147,7 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_ULOG);
 MODULE_ALIAS_NF_LOGGER(AF_INET, 1);
 MODULE_ALIAS_NF_LOGGER(AF_INET6, 1);
 MODULE_ALIAS_NF_LOGGER(AF_BRIDGE, 1);
+MODULE_ALIAS_NF_LOGGER(3, 1); /* NFPROTO_ARP */
 
 module_init(nfnetlink_log_init);
 module_exit(nfnetlink_log_fini);
-- 
2.5.5


