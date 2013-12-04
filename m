From: Shawn Landden <shawn@churchofgit.com>
Subject: [PATCH] libmnl: docs were wrong
Date: Wed,  4 Dec 2013 11:06:28 -0800
Message-ID: <1386183988-66330-1-git-send-email-shawn@churchofgit.com>
Cc: Shawn Landden <shawn@churchofgit.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from frostfang.bitronictech.net ([198.20.106.155]:35607 "EHLO
	www.churchofgit.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab3LDTP1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:15:27 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 src/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/socket.c b/src/socket.c
index 6d54563..676a08a 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -107,7 +107,7 @@ EXPORT_SYMBOL(mnl_socket_get_portid);
  * mnl_socket_open - open a netlink socket
  * \param bus the netlink socket bus ID (see NETLINK_* constants)
  *
- * On error, it returns -1 and errno is appropriately set. Otherwise, it
+ * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
 struct mnl_socket *mnl_socket_open(int bus)
-- 
1.8.5.1

