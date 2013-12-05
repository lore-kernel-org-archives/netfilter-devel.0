From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: libmnl [PATCH 4/5] document: mnl_socket_open
Date: Thu, 5 Dec 2013 19:17:03 +0900
Message-ID: <CAGCkEt2ic1mGERXRz__T8mgN-oARuS_37vAY55W8evaozqQcdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:56862 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3LEKRF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:17:05 -0500
Received: by mail-qe0-f50.google.com with SMTP id 1so14965038qec.37
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2013 02:17:03 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Thu, 28 Nov 2013 08:23:35 +0900
Subject: [PATCH 4/5] document: mnl_socket_open

fix return value on error
---
 src/socket.c |    2 +-
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
1.7.10.4
