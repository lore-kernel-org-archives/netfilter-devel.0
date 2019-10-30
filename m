Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5629CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79B9420659
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfJ3RuE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:50:04 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45232 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfJ3RuE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:50:04 -0400
Received: from localhost ([::1]:58322 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPs6c-000828-Mk; Wed, 30 Oct 2019 18:50:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 2/2] Deprecate untyped data setters
Date:   Wed, 30 Oct 2019 18:49:48 +0100
Message-Id: <20191030174948.12493-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030174948.12493-1-phil@nwl.cc>
References: <20191030174948.12493-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These functions make assumptions on size of passed data pointer and
therefore tend to hide programming mistakes. Instead either one of the
type-specific setters or the generic *_set_data() setter should be used.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/libnftnl/chain.h     | 2 +-
 include/libnftnl/flowtable.h | 2 +-
 include/libnftnl/gen.h       | 2 +-
 include/libnftnl/object.h    | 2 +-
 include/libnftnl/rule.h      | 2 +-
 include/libnftnl/set.h       | 2 +-
 include/libnftnl/table.h     | 2 +-
 src/chain.c                  | 2 +-
 src/flowtable.c              | 2 +-
 src/gen.c                    | 2 +-
 src/object.c                 | 2 +-
 src/rule.c                   | 2 +-
 src/set.c                    | 2 +-
 src/table.c                  | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/libnftnl/chain.h b/include/libnftnl/chain.h
index f84a2a3a20f2a..33d04e19b05fa 100644
--- a/include/libnftnl/chain.h
+++ b/include/libnftnl/chain.h
@@ -38,7 +38,7 @@ enum nftnl_chain_attr {
 
 bool nftnl_chain_is_set(const struct nftnl_chain *c, uint16_t attr);
 void nftnl_chain_unset(struct nftnl_chain *c, uint16_t attr);
-void nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void *data);
+void nftnl_chain_set(struct nftnl_chain *t, uint16_t attr, const void *data) __attribute__((deprecated));
 int nftnl_chain_set_data(struct nftnl_chain *t, uint16_t attr,
 			     const void *data, uint32_t data_len);
 void nftnl_chain_set_u8(struct nftnl_chain *t, uint16_t attr, uint8_t data);
diff --git a/include/libnftnl/flowtable.h b/include/libnftnl/flowtable.h
index 6f6801803ca52..028095ec106c5 100644
--- a/include/libnftnl/flowtable.h
+++ b/include/libnftnl/flowtable.h
@@ -33,7 +33,7 @@ enum nftnl_flowtable_attr {
 
 bool nftnl_flowtable_is_set(const struct nftnl_flowtable *c, uint16_t attr);
 void nftnl_flowtable_unset(struct nftnl_flowtable *c, uint16_t attr);
-void nftnl_flowtable_set(struct nftnl_flowtable *t, uint16_t attr, const void *data);
+void nftnl_flowtable_set(struct nftnl_flowtable *t, uint16_t attr, const void *data) __attribute__((deprecated));
 int nftnl_flowtable_set_data(struct nftnl_flowtable *t, uint16_t attr,
 			     const void *data, uint32_t data_len);
 void nftnl_flowtable_set_u32(struct nftnl_flowtable *t, uint16_t attr, uint32_t data);
diff --git a/include/libnftnl/gen.h b/include/libnftnl/gen.h
index c56a63ca2508b..846b8e0bc5c4e 100644
--- a/include/libnftnl/gen.h
+++ b/include/libnftnl/gen.h
@@ -25,7 +25,7 @@ enum {
 
 bool nftnl_gen_is_set(const struct nftnl_gen *gen, uint16_t attr);
 void nftnl_gen_unset(struct nftnl_gen *gen, uint16_t attr);
-int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data);
+int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data) __attribute__((deprecated));
 int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 		       const void *data, uint32_t data_len);
 const void *nftnl_gen_get(const struct nftnl_gen *gen, uint16_t attr);
diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index c5ea88e5c3a41..221b15c20988d 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -124,7 +124,7 @@ bool nftnl_obj_is_set(const struct nftnl_obj *ne, uint16_t attr);
 void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
 void nftnl_obj_set_data(struct nftnl_obj *ne, uint16_t attr, const void *data,
 			uint32_t data_len);
-void nftnl_obj_set(struct nftnl_obj *ne, uint16_t attr, const void *data);
+void nftnl_obj_set(struct nftnl_obj *ne, uint16_t attr, const void *data) __attribute__((deprecated));
 void nftnl_obj_set_u8(struct nftnl_obj *ne, uint16_t attr, uint8_t val);
 void nftnl_obj_set_u16(struct nftnl_obj *ne, uint16_t attr, uint16_t val);
 void nftnl_obj_set_u32(struct nftnl_obj *ne, uint16_t attr, uint32_t val);
diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index 78bfead132368..e5d1ca0534b7a 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -35,7 +35,7 @@ enum nftnl_rule_attr {
 
 void nftnl_rule_unset(struct nftnl_rule *r, uint16_t attr);
 bool nftnl_rule_is_set(const struct nftnl_rule *r, uint16_t attr);
-int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data);
+int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data) __attribute__((deprecated));
 int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 			const void *data, uint32_t data_len);
 void nftnl_rule_set_u32(struct nftnl_rule *r, uint16_t attr, uint32_t val);
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index 2ea2e9a56ce4f..db3fa686d60a2 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -42,7 +42,7 @@ struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set);
 
 bool nftnl_set_is_set(const struct nftnl_set *s, uint16_t attr);
 void nftnl_set_unset(struct nftnl_set *s, uint16_t attr);
-int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data);
+int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data) __attribute__((deprecated));
 int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		       uint32_t data_len);
 void nftnl_set_set_u32(struct nftnl_set *s, uint16_t attr, uint32_t val);
diff --git a/include/libnftnl/table.h b/include/libnftnl/table.h
index 44017c6a9259f..5faec8164bf62 100644
--- a/include/libnftnl/table.h
+++ b/include/libnftnl/table.h
@@ -29,7 +29,7 @@ enum nftnl_table_attr {
 
 bool nftnl_table_is_set(const struct nftnl_table *t, uint16_t attr);
 void nftnl_table_unset(struct nftnl_table *t, uint16_t attr);
-void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data);
+void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data) __attribute__((deprecated));
 int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 			 const void *data, uint32_t data_len);
 const void *nftnl_table_get(const struct nftnl_table *t, uint16_t attr);
diff --git a/src/chain.c b/src/chain.c
index 84e5414f0cee7..d4050d28e77d0 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -284,7 +284,7 @@ int nftnl_chain_set_data(struct nftnl_chain *c, uint16_t attr,
 	return 0;
 }
 
-EXPORT_SYMBOL(nftnl_chain_set);
+void nftnl_chain_set(struct nftnl_chain *c, uint16_t attr, const void *data) __visible;
 void nftnl_chain_set(struct nftnl_chain *c, uint16_t attr, const void *data)
 {
 	nftnl_chain_set_data(c, attr, data, nftnl_chain_validate[attr]);
diff --git a/src/flowtable.c b/src/flowtable.c
index 020f102896442..c6025c7b678a0 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -171,11 +171,11 @@ int nftnl_flowtable_set_data(struct nftnl_flowtable *c, uint16_t attr,
 }
 EXPORT_SYMBOL(nftnl_flowtable_set_data);
 
+void nftnl_flowtable_set(struct nftnl_flowtable *c, uint16_t attr, const void *data) __visible;
 void nftnl_flowtable_set(struct nftnl_flowtable *c, uint16_t attr, const void *data)
 {
 	nftnl_flowtable_set_data(c, attr, data, nftnl_flowtable_validate[attr]);
 }
-EXPORT_SYMBOL(nftnl_flowtable_set);
 
 void nftnl_flowtable_set_u32(struct nftnl_flowtable *c, uint16_t attr, uint32_t data)
 {
diff --git a/src/gen.c b/src/gen.c
index 1fc909930d869..f2ac2ba03b9a4 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -80,7 +80,7 @@ int nftnl_gen_set_data(struct nftnl_gen *gen, uint16_t attr,
 	return 0;
 }
 
-EXPORT_SYMBOL(nftnl_gen_set);
+int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data) __visible;
 int nftnl_gen_set(struct nftnl_gen *gen, uint16_t attr, const void *data)
 {
 	return nftnl_gen_set_data(gen, attr, data, nftnl_gen_validate[attr]);
diff --git a/src/object.c b/src/object.c
index ed8e36df358da..c876addb6532f 100644
--- a/src/object.c
+++ b/src/object.c
@@ -112,7 +112,7 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 	obj->flags |= (1 << attr);
 }
 
-EXPORT_SYMBOL(nftnl_obj_set);
+void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data) __visible;
 void nftnl_obj_set(struct nftnl_obj *obj, uint16_t attr, const void *data)
 {
 	nftnl_obj_set_data(obj, attr, data, nftnl_obj_validate[attr]);
diff --git a/src/rule.c b/src/rule.c
index 8173fcdd863d9..252410b6e62cb 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -168,7 +168,7 @@ int nftnl_rule_set_data(struct nftnl_rule *r, uint16_t attr,
 	return 0;
 }
 
-EXPORT_SYMBOL(nftnl_rule_set);
+int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data) __visible;
 int nftnl_rule_set(struct nftnl_rule *r, uint16_t attr, const void *data)
 {
 	return nftnl_rule_set_data(r, attr, data, nftnl_rule_validate[attr]);
diff --git a/src/set.c b/src/set.c
index 5e49a6d04f2dc..78447c676f512 100644
--- a/src/set.c
+++ b/src/set.c
@@ -195,7 +195,7 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 	return 0;
 }
 
-EXPORT_SYMBOL(nftnl_set_set);
+int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data) __visible;
 int nftnl_set_set(struct nftnl_set *s, uint16_t attr, const void *data)
 {
 	return nftnl_set_set_data(s, attr, data, nftnl_set_validate[attr]);
diff --git a/src/table.c b/src/table.c
index 54259eec7d067..adcfafe5ad576 100644
--- a/src/table.c
+++ b/src/table.c
@@ -117,7 +117,7 @@ int nftnl_table_set_data(struct nftnl_table *t, uint16_t attr,
 	return 0;
 }
 
-EXPORT_SYMBOL(nftnl_table_set);
+void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data) __visible;
 void nftnl_table_set(struct nftnl_table *t, uint16_t attr, const void *data)
 {
 	nftnl_table_set_data(t, attr, data, nftnl_table_validate[attr]);
-- 
2.23.0

