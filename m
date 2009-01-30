From: Eric Leblond <eric@inl.fr>
Subject: [iptables] xt_NFLOG: Set default NFLOG qthreshold to 0
Date: Fri, 30 Jan 2009 23:31:47 +0100
Message-ID: <1233354708-22009-3-git-send-email-eric@inl.fr>
References: <1233354708-22009-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:51952 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753803AbZA3Wbv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:31:51 -0500
In-Reply-To: <1233354708-22009-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By setting default NFLOG qthreshold to 0, userspace does not overwrite
the per-instance value.
---
 include/linux/netfilter/xt_NFLOG.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index cdcd0ed..4b36aeb 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -2,7 +2,7 @@
 #define _XT_NFLOG_TARGET
 
 #define XT_NFLOG_DEFAULT_GROUP		0x1
-#define XT_NFLOG_DEFAULT_THRESHOLD	1
+#define XT_NFLOG_DEFAULT_THRESHOLD	0
 
 #define XT_NFLOG_MASK			0x0
 
-- 
1.6.1

