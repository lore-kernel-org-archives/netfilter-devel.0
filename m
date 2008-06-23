From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnfnetlink: mark functions as extern C
Date: Mon, 23 Jun 2008 09:59:33 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806230959020.22994@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41375 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYFWH7e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:59:34 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 079ff9c9c82629115711410d52bc88b84bbc3a8e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jun 23 09:58:34 2008 +0200

mark functions as extern C

This is needed when #included from C++.

Reported-by: Simon <turner25@gmail.com>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libnfnetlink/libnfnetlink.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/libnfnetlink/libnfnetlink.h b/include/libnfnetlink/libnfnetlink.h
index 3c64aac..83874e3 100644
--- a/include/libnfnetlink/libnfnetlink.h
+++ b/include/libnfnetlink/libnfnetlink.h
@@ -31,6 +31,10 @@
 
 #define NFNL_BUFFSIZE		8192
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct nfnlhdr {
 	struct nlmsghdr nlh;
 	struct nfgenmsg nfmsg;
@@ -202,6 +206,10 @@ int nlif_index2name(struct nlif_handle *nlif_handle,
 		    unsigned int if_index, 
 		    char *name);
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 /* Pablo: What is the equivalence of be64_to_cpu in userspace?
  * 
  * Harald: Good question.  I don't think there's a standard way [yet?], 

