From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] Add stdint header and type corrections
Date: Wed, 29 Feb 2012 08:15:39 +0100
Message-ID: <1330499742-28091-4-git-send-email-jengelh@medozas.de>
References: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48519 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965457Ab2B2HPu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:15:50 -0500
In-Reply-To: <1330499742-28091-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1. stdint.h is needed since you use uintXX_t in various places.
2. mnl_attr_get_type yields uint16_t, prefer to use it.
3. Since ->nlattr_max is uint32_t, most dependent uses should be
   unsigned too.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .../libnetfilter_cttimeout.h                       |    1 +
 src/libnetfilter_cttimeout.c                       |   11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h b/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
index be37636..89e00b6 100644
--- a/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
+++ b/include/libnetfilter_cttimeout/libnetfilter_cttimeout.h
@@ -1,6 +1,7 @@
 #ifndef _LIBNETFILTER_CTTIMEOUT_H_
 #define _LIBNETFILTER_CTTIMEOUT_H_
 
+#include <stdint.h>
 #include <sys/types.h>
 #include <linux/netfilter/nfnetlink_conntrack.h>
 
diff --git a/src/libnetfilter_cttimeout.c b/src/libnetfilter_cttimeout.c
index 6050514..707543a 100644
--- a/src/libnetfilter_cttimeout.c
+++ b/src/libnetfilter_cttimeout.c
@@ -11,6 +11,7 @@
 
 #include <time.h>
 #include <endian.h>
+#include <stdint.h>
 #include <stdlib.h>
 #include <string.h>
 #include <netinet/in.h>
@@ -432,7 +433,7 @@ static int
 timeout_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
-	int type = mnl_attr_get_type(attr);
+	uint16_t type = mnl_attr_get_type(attr);
 
 	if (mnl_attr_type_valid(attr, CTA_TIMEOUT_MAX) < 0)
 		return MNL_CB_OK;
@@ -468,7 +469,7 @@ timeout_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 }
 
 struct _container_policy_cb {
-	int nlattr_max;
+	unsigned int nlattr_max;
 	void *tb;
 };
 
@@ -477,7 +478,7 @@ parse_timeout_attr_policy_cb(const struct nlattr *attr, void *data)
 {
 	struct _container_policy_cb *data_cb = data;
         const struct nlattr **tb = data_cb->tb;
-        int type = mnl_attr_get_type(attr);
+	uint16_t type = mnl_attr_get_type(attr);
 
         if (mnl_attr_type_valid(attr, data_cb->nlattr_max) < 0)
                 return MNL_CB_OK;
@@ -495,13 +496,13 @@ parse_timeout_attr_policy_cb(const struct nlattr *attr, void *data)
 static void
 timeout_parse_attr_data(struct nfct_timeout *t, const struct nlattr *nest)
 {
-	int nlattr_max = timeout_protocol[t->l4num].nlattr_max;
+	unsigned int nlattr_max = timeout_protocol[t->l4num].nlattr_max;
 	struct nlattr *tb[nlattr_max];
 	struct _container_policy_cb cnt = {
 		.nlattr_max = nlattr_max,
 		.tb = tb,
 	};
-	int i;
+	unsigned int i;
 
 	memset(tb, 0, sizeof(struct nlattr *) * nlattr_max);
 
-- 
1.7.7

