From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] netlink: remove nfsock_open()
Date: Fri,  1 Sep 2017 12:14:06 +0200
Message-ID: <1504260847-5408-2-git-send-email-pablo@netfilter.org>
References: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Cc: phil@nwl.cc, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34332 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751857AbdIAKOT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 06:14:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A76A1190F87
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2017 12:13:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 986F17C69
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2017 12:13:54 +0200 (CEST)
In-Reply-To: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Just merge this code to netlink_open_sock().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 90f8486581fe..b6336e836e88 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -48,22 +48,16 @@ const struct location netlink_location = {
 	.indesc	= &indesc_netlink,
 };
 
-static struct mnl_socket *nfsock_open(void)
-{
-	struct mnl_socket *s;
-
-	s = mnl_socket_open(NETLINK_NETFILTER);
-	if (s == NULL)
-		netlink_init_error();
-	return s;
-}
-
 struct mnl_socket *netlink_open_sock(void)
 {
 	struct mnl_socket *nf_sock;
 
-	nf_sock = nfsock_open();
+	nf_sock = mnl_socket_open(NETLINK_NETFILTER);
+	if (nf_sock == NULL)
+		netlink_init_error();
+
 	fcntl(mnl_socket_get_fd(nf_sock), F_SETFL, O_NONBLOCK);
+
 	return nf_sock;
 }
 
-- 
2.1.4

