From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 1/3] autotools conversion: added a missing 'Makefile.am' under 'include/linux/netfilter/'.
Date: Wed, 12 Nov 2014 17:41:04 +0100
Message-ID: <1415810466-9410-2-git-send-email-giorgio.nicole@arcor.de>
References: <1415810466-9410-1-git-send-email-giorgio.nicole@arcor.de>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:58457 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbaKLQlS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:41:18 -0500
Received: from mail-in-17-z2.arcor-online.net (mail-in-17-z2.arcor-online.net [151.189.8.34])
	by mx.arcor.de (Postfix) with ESMTP id 938FB35A940
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2014 17:41:16 +0100 (CET)
In-Reply-To: <1415810466-9410-1-git-send-email-giorgio.nicole@arcor.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was forgotten in the commit id: 85035b6c6a1618e7ba726fe6306c804fc1b6c4e8

Signed-off-by: Giorgio Dal Molin <giorgio.nicole@arcor.de>
---
 include/linux/netfilter/Makefile.am | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 include/linux/netfilter/Makefile.am

diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
new file mode 100644
index 0000000..54b59b5
--- /dev/null
+++ b/include/linux/netfilter/Makefile.am
@@ -0,0 +1,5 @@
+noinst_HEADERS = 	nf_conntrack_common.h		\
+			nf_conntrack_tuple_common.h	\
+			nf_nat.h			\
+			nf_tables.h			\
+			nfnetlink.h
-- 
2.1.3

