From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfq: mark functions as extern C
Date: Mon, 23 Jun 2008 09:56:36 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806230955540.22994@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41359 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYFWH4i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:56:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7f2678a05bd590f18fa6688785ba11ec6845007b
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jun 23 09:54:14 2008 +0200

mark functions as extern C
    
This is needed when #included from C++.
    
Reported-by: Simon <turner25@gmail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libnetfilter_queue/libipq.h             |    8 ++++++++
 include/libnetfilter_queue/libnetfilter_queue.h |    8 +++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/libnetfilter_queue/libipq.h b/include/libnetfilter_queue/libipq.h
index c33f7e4..0f0df22 100644
--- a/include/libnetfilter_queue/libipq.h
+++ b/include/libnetfilter_queue/libipq.h
@@ -50,6 +50,10 @@ typedef unsigned long ipq_id_t;
 #define MSG_TRUNC 0x20
 #endif
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct ipq_handle
 {
 	struct nfq_handle *nfqnlh;
@@ -84,5 +88,9 @@ int ipq_ctl(const struct ipq_handle *h, int request, ...);
 char *ipq_errstr(void);
 void ipq_perror(const char *s);
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 #endif	/* _LIBIPQ_H */
 
diff --git a/include/libnetfilter_queue/libnetfilter_queue.h b/include/libnetfilter_queue/libnetfilter_queue.h
index 6695c3d..1a72c51 100644
--- a/include/libnetfilter_queue/libnetfilter_queue.h
+++ b/include/libnetfilter_queue/libnetfilter_queue.h
@@ -18,6 +18,10 @@
 
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct nfq_handle;
 struct nfq_q_handle;
 struct nfq_data;
@@ -94,6 +98,8 @@ extern struct nfqnl_msg_packet_hw *nfq_get_packet_hw(struct nfq_data *nfad);
 /* return -1 if problem, length otherwise */
 extern int nfq_get_payload(struct nfq_data *nfad, char **data);
 
-
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
 
 #endif	/* __LIBNFQNETLINK_H */

