Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA60C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B59C86525F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 15:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCIPqa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 10:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbhCIPp7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 10:45:59 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C4DC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 07:45:59 -0800 (PST)
Received: from localhost ([::1]:56676 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJeYX-000171-Ko; Tue, 09 Mar 2021 16:45:57 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 07/10] obj: Drop type parameter from snprintf callback
Date:   Tue,  9 Mar 2021 16:45:13 +0100
Message-Id: <20210309154516.4987-8-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210309154516.4987-1-phil@nwl.cc>
References: <20210309154516.4987-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Objects don't support any other output type than NFTNL_OUTPUT_DEFAULT,
so just drop the parameter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/obj.h        |  2 +-
 src/obj/counter.c    | 22 ++--------------------
 src/obj/ct_expect.c  | 22 +++-------------------
 src/obj/ct_helper.c  | 22 +++-------------------
 src/obj/ct_timeout.c | 22 +++-------------------
 src/obj/limit.c      | 23 +++--------------------
 src/obj/quota.c      | 23 +++--------------------
 src/obj/secmark.c    | 23 +++--------------------
 src/obj/synproxy.c   | 20 +++-----------------
 src/obj/tunnel.c     | 21 ++-------------------
 src/object.c         |  3 +--
 11 files changed, 27 insertions(+), 176 deletions(-)

diff --git a/include/obj.h b/include/obj.h
index d9e856ab2bfbf..60dc8533b30f3 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -109,7 +109,7 @@ struct obj_ops {
 	const void *(*get)(const struct nftnl_obj *e, uint16_t type, uint32_t *data_len);
 	int	(*parse)(struct nftnl_obj *e, struct nlattr *attr);
 	void	(*build)(struct nlmsghdr *nlh, const struct nftnl_obj *e);
-	int	(*snprintf)(char *buf, size_t len, uint32_t type, uint32_t flags, const struct nftnl_obj *e);
+	int	(*snprintf)(char *buf, size_t len, uint32_t flags, const struct nftnl_obj *e);
 };
 
 extern struct obj_ops obj_ops_counter;
diff --git a/src/obj/counter.c b/src/obj/counter.c
index 1baba4e149414..ef0cd203e3a1b 100644
--- a/src/obj/counter.c
+++ b/src/obj/counter.c
@@ -109,8 +109,8 @@ nftnl_obj_counter_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_counter_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_obj *e)
+static int nftnl_obj_counter_snprintf(char *buf, size_t len, uint32_t flags,
+				      const struct nftnl_obj *e)
 {
 	struct nftnl_obj_counter *ctr = nftnl_obj_data(e);
 
@@ -118,24 +118,6 @@ static int nftnl_obj_counter_snprintf_default(char *buf, size_t len,
 			ctr->pkts, ctr->bytes);
 }
 
-static int nftnl_obj_counter_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_counter_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_counter = {
 	.name		= "counter",
 	.type		= NFT_OBJECT_COUNTER,
diff --git a/src/obj/ct_expect.c b/src/obj/ct_expect.c
index 0b4eb8fe541d9..c29f99c419dcb 100644
--- a/src/obj/ct_expect.c
+++ b/src/obj/ct_expect.c
@@ -151,8 +151,9 @@ nftnl_obj_ct_expect_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_ct_expect_snprintf_default(char *buf, size_t len,
-						const struct nftnl_obj *e)
+static int nftnl_obj_ct_expect_snprintf(char *buf, size_t len,
+					uint32_t flags,
+					const struct nftnl_obj *e)
 {
 	int ret = 0;
 	int offset = 0, remain = len;
@@ -187,23 +188,6 @@ static int nftnl_obj_ct_expect_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_obj_ct_expect_snprintf(char *buf, size_t len, uint32_t type,
-					uint32_t flags,
-					const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_ct_expect_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_ct_expect = {
 	.name		= "ct_expect",
 	.type		= NFT_OBJECT_CT_EXPECT,
diff --git a/src/obj/ct_helper.c b/src/obj/ct_helper.c
index d91f636d4c64c..c52032a9895c3 100644
--- a/src/obj/ct_helper.c
+++ b/src/obj/ct_helper.c
@@ -131,8 +131,9 @@ nftnl_obj_ct_helper_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_ct_helper_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_obj *e)
+static int nftnl_obj_ct_helper_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_obj *e)
 {
 	struct nftnl_obj_ct_helper *helper = nftnl_obj_data(e);
 
@@ -140,23 +141,6 @@ static int nftnl_obj_ct_helper_snprintf_default(char *buf, size_t len,
 			helper->name, helper->l3proto, helper->l4proto);
 }
 
-static int nftnl_obj_ct_helper_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_ct_helper_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_ct_helper = {
 	.name		= "ct_helper",
 	.type		= NFT_OBJECT_CT_HELPER,
diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index c3f577bdecd90..a2e5b4fe6de99 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -257,8 +257,9 @@ nftnl_obj_ct_timeout_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_ct_timeout_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_obj *e)
+static int nftnl_obj_ct_timeout_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_obj *e)
 {
 	int ret = 0;
 	int offset = 0, remain = len;
@@ -307,23 +308,6 @@ static int nftnl_obj_ct_timeout_snprintf_default(char *buf, size_t len,
 	return offset;
 }
 
-static int nftnl_obj_ct_timeout_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_ct_timeout_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_ct_timeout = {
 	.name		= "ct_timeout",
 	.type		= NFT_OBJECT_CT_TIMEOUT,
diff --git a/src/obj/limit.c b/src/obj/limit.c
index 60b01592e4c50..8b40f9d0976ff 100644
--- a/src/obj/limit.c
+++ b/src/obj/limit.c
@@ -148,8 +148,9 @@ static int nftnl_obj_limit_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_limit_snprintf_default(char *buf, size_t len,
-					    const struct nftnl_obj *e)
+static int nftnl_obj_limit_snprintf(char *buf, size_t len,
+				    uint32_t flags,
+				    const struct nftnl_obj *e)
 {
 	struct nftnl_obj_limit *limit = nftnl_obj_data(e);
 
@@ -158,24 +159,6 @@ static int nftnl_obj_limit_snprintf_default(char *buf, size_t len,
 			limit->burst, limit->type, limit->flags);
 }
 
-static int nftnl_obj_limit_snprintf(char *buf, size_t len, uint32_t type,
-				    uint32_t flags,
-				    const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_limit_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_limit = {
 	.name		= "limit",
 	.type		= NFT_OBJECT_LIMIT,
diff --git a/src/obj/quota.c b/src/obj/quota.c
index 1914037d3f70d..8ab33005daeea 100644
--- a/src/obj/quota.c
+++ b/src/obj/quota.c
@@ -125,8 +125,9 @@ nftnl_obj_quota_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_quota_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_obj *e)
+static int nftnl_obj_quota_snprintf(char *buf, size_t len,
+				       uint32_t flags,
+				       const struct nftnl_obj *e)
 {
 	struct nftnl_obj_quota *quota = nftnl_obj_data(e);
 
@@ -134,24 +135,6 @@ static int nftnl_obj_quota_snprintf_default(char *buf, size_t len,
 			quota->bytes, quota->flags);
 }
 
-static int nftnl_obj_quota_snprintf(char *buf, size_t len, uint32_t type,
-				       uint32_t flags,
-				       const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_quota_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_quota = {
 	.name		= "quota",
 	.type		= NFT_OBJECT_QUOTA,
diff --git a/src/obj/secmark.c b/src/obj/secmark.c
index e27b5faf2d39f..2ccc803bacf4e 100644
--- a/src/obj/secmark.c
+++ b/src/obj/secmark.c
@@ -98,30 +98,13 @@ nftnl_obj_secmark_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_secmark_snprintf_default(char *buf, size_t len,
-					       const struct nftnl_obj *e)
-{
-	struct nftnl_obj_secmark *secmark = nftnl_obj_data(e);
-
-	return snprintf(buf, len, "context %s ", secmark->ctx);
-}
-
-static int nftnl_obj_secmark_snprintf(char *buf, size_t len, uint32_t type,
+static int nftnl_obj_secmark_snprintf(char *buf, size_t len,
 				       uint32_t flags,
 				       const struct nftnl_obj *e)
 {
-	if (len)
-		buf[0] = '\0';
+	struct nftnl_obj_secmark *secmark = nftnl_obj_data(e);
 
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_secmark_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
+	return snprintf(buf, len, "context %s ", secmark->ctx);
 }
 
 struct obj_ops obj_ops_secmark = {
diff --git a/src/obj/synproxy.c b/src/obj/synproxy.c
index 56ebc85b02d63..e3a991bc6e023 100644
--- a/src/obj/synproxy.c
+++ b/src/obj/synproxy.c
@@ -117,8 +117,9 @@ static int nftnl_obj_synproxy_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_synproxy_snprintf_default(char *buf, size_t size,
-					       const struct nftnl_obj *e)
+static int nftnl_obj_synproxy_snprintf(char *buf, size_t size,
+				    uint32_t flags,
+				    const struct nftnl_obj *e)
 {
 	struct nftnl_obj_synproxy *synproxy = nftnl_obj_data(e);
         int ret, offset = 0, len = size;
@@ -133,21 +134,6 @@ static int nftnl_obj_synproxy_snprintf_default(char *buf, size_t size,
         return offset;
 }
 
-static int nftnl_obj_synproxy_snprintf(char *buf, size_t len, uint32_t type,
-				    uint32_t flags,
-				    const struct nftnl_obj *e)
-{
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_synproxy_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_synproxy = {
 	.name		= "synproxy",
 	.type		= NFT_OBJECT_SYNPROXY,
diff --git a/src/obj/tunnel.c b/src/obj/tunnel.c
index 100aa099c6e97..5ede6bd545b38 100644
--- a/src/obj/tunnel.c
+++ b/src/obj/tunnel.c
@@ -530,31 +530,14 @@ nftnl_obj_tunnel_parse(struct nftnl_obj *e, struct nlattr *attr)
 	return 0;
 }
 
-static int nftnl_obj_tunnel_snprintf_default(char *buf, size_t len,
-					     const struct nftnl_obj *e)
+static int nftnl_obj_tunnel_snprintf(char *buf, size_t len,
+				     uint32_t flags, const struct nftnl_obj *e)
 {
 	struct nftnl_obj_tunnel *tun = nftnl_obj_data(e);
 
 	return snprintf(buf, len, "id %u ", tun->id);
 }
 
-static int nftnl_obj_tunnel_snprintf(char *buf, size_t len, uint32_t type,
-				     uint32_t flags, const struct nftnl_obj *e)
-{
-	if (len)
-		buf[0] = '\0';
-
-	switch (type) {
-	case NFTNL_OUTPUT_DEFAULT:
-		return nftnl_obj_tunnel_snprintf_default(buf, len, e);
-	case NFTNL_OUTPUT_XML:
-	case NFTNL_OUTPUT_JSON:
-	default:
-		break;
-	}
-	return -1;
-}
-
 struct obj_ops obj_ops_tunnel = {
 	.name		= "tunnel",
 	.type		= NFT_OBJECT_TUNNEL,
diff --git a/src/object.c b/src/object.c
index 46e79168daa76..2d15629eb0f95 100644
--- a/src/object.c
+++ b/src/object.c
@@ -396,8 +396,7 @@ static int nftnl_obj_snprintf_dflt(char *buf, size_t size,
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (obj->ops) {
-		ret = obj->ops->snprintf(buf + offset, remain, type, flags,
-					 obj);
+		ret = obj->ops->snprintf(buf + offset, remain, flags, obj);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 	ret = snprintf(buf + offset, remain, "]");
-- 
2.30.1

