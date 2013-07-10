From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 9/29] add *_SAVE template allowing save/restore
Date: Wed, 10 Jul 2013 19:25:07 +0100
Message-ID: <1373480727-11254-10-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:55991 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab3GJSZ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:25:58 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so5942841lab.25
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:25:56 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add NFACCT_SNPRINTF_F_SAVE plaintext template, allowing printing of
accounting objects in a format suitable for the 'restore' command.
All nfacct properties are listed as name=value pairs, properly encoding space
and other "odd" characters when needed. Example:

name="ALL IN net 17" pkts=1234 bytes=3456789

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |  3 +++
 src/libnetfilter_acct.c                       | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index 9f66c39..ecf8280 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -39,6 +39,9 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 #define NFACCT_SNPRINTF_F_FULL		(1 << 0)
 #define NFACCT_SNPRINTF_F_TIME		(1 << 1)
 
+/* print in a format suitable for 'restore' */
+#define NFACCT_SNPRINTF_F_SAVE		(1 << 2)
+
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
 
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 493be3b..e4fdf84 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -228,6 +228,9 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 }
 EXPORT_SYMBOL(nfacct_attr_get_u64);
 
+#define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s pkts=%"PRIu64 \
+					" bytes=%"PRIu64
+
 void
 parse_nfacct_name(char *buf, const char *name)
 {
@@ -321,12 +324,20 @@ nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 	parse_nfacct_name(nfacct_name,
 			  nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
+		/* default: print pkts + bytes + name */
 		ret = snprintf(buf, rem,
 			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64" } = %s;",
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
 			nfacct_name);
+	} else if (flags & NFACCT_SNPRINTF_F_SAVE) {
+		/* save: format useful for 'restore' */
+		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_SAVE_BASE,
+			       nfacct_name,
+			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_PKTS),
+			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BYTES));
 	} else {
+		/* print out name only */
 		ret = snprintf(buf, rem, "%s\n", nfacct_name);
 	}
 
-- 
1.8.3.1

