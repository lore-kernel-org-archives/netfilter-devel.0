From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] const-ify arguments of functions
Date: Wed, 29 Feb 2012 08:15:41 +0100
Message-ID: <1330499742-28091-6-git-send-email-jengelh@medozas.de>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48518 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966123Ab2B2HPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:50 -0500
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .../libnetfilter_cttimeout.h                       |    4 ++--
 src/libnetfilter_cttimeout.c                       |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h b/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
index 89e00b6..172e7f9 100644
--- a/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
+++ b/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
@@ -99,9 +99,9 @@ void nfct_timeout_policy_attr_unset(struct nfct_timeout *t, uint32_t type);
 struct nlmsghdr;
 
 struct nlmsghdr *nfct_timeout_nlmsg_build_hdr(char *buf, uint8_t cmd, uint16_t flags, uint32_t seq);
-void nfct_timeout_nlmsg_build_payload(struct nlmsghdr *, struct nfct_timeout *);
+void nfct_timeout_nlmsg_build_payload(struct nlmsghdr *, const struct nfct_timeout *);
 int nfct_timeout_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfct_timeout *);
 
-int nfct_timeout_snprintf(char *buf, size_t size, struct nfct_timeout *, unsigned int flags);
+int nfct_timeout_snprintf(char *buf, size_t size, const struct nfct_timeout *, unsigned int flags);
 
 #endif
diff --git a/src/libnetfilter_cttimeout.c b/src/libnetfilter_cttimeout.c
index 1f7c63e..c7060ff 100644
--- a/src/libnetfilter_cttimeout.c
+++ b/src/libnetfilter_cttimeout.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(nfct_timeout_policy_attr_unset);
  * This function returns -1 in case that some mandatory attributes are
  * missing. On sucess, it returns 0.
  */
-int nfct_timeout_snprintf(char *buf, size_t size, struct nfct_timeout *t,
+int nfct_timeout_snprintf(char *buf, size_t size, const struct nfct_timeout *t,
 			  unsigned int flags)
 {
 	int ret = 0;
@@ -401,7 +401,8 @@ EXPORT_SYMBOL(nfct_timeout_nlmsg_build_hdr);
  * \param t: pointer to a conntrack timeout object
  */
 void
-nfct_timeout_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfct_timeout *t)
+nfct_timeout_nlmsg_build_payload(struct nlmsghdr *nlh,
+				 const struct nfct_timeout *t)
 {
 	int i;
 	struct nlattr *nest;
-- 
1.7.7

