From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nft] mnl: print netlink message if if --debug=netlink in mnl_talk()
Date: Sat, 28 Dec 2013 01:01:13 +0100
Message-ID: <1388188874-7667-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51022 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933Ab3L1ABW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Dec 2013 19:01:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Useful for debugging purposes.
---
 src/mnl.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index fe218fc..a711b5e 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -38,6 +38,11 @@ mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
 	uint32_t portid = mnl_socket_get_portid(nf_sock);
 	int ret;
 
+#ifdef DEBUG
+	if (debug_level & DEBUG_NETLINK)
+		mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
+#endif
+
 	if (mnl_socket_sendto(nf_sock, data, len) < 0)
 		return -1;
 
-- 
1.7.10.4

