From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] Add extern "C" guard for C++ compilation mode
Date: Wed, 29 Feb 2012 08:15:42 +0100
Message-ID: <1330499742-28091-7-git-send-email-jengelh@medozas.de>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48529 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030751Ab2B2HPv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:51 -0500
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .../libnetfilter_cttimeout.h                       |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h b/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
index 172e7f9..5a548fa 100644
--- a/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
+++ b/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
@@ -5,6 +5,10 @@
 #include <sys/types.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 struct nfct_timeout;
 
 struct nfct_timeout *nfct_timeout_alloc(void);
@@ -104,4 +108,8 @@ int nfct_timeout_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfct_tim
 
 int nfct_timeout_snprintf(char *buf, size_t size, const struct nfct_timeout *, unsigned int flags);
 
+#ifdef __cplusplus
+} /* extern "C" */
 #endif
+
+#endif /* _LIBNETFILTER_CTTIMEOUT_H_ */
-- 
1.7.7

