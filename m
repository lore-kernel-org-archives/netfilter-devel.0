Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD48C3B1A1
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52C902168B
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392562AbgBNRYW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:24:22 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:40762 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389179AbgBNRYW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:24:22 -0500
Received: from localhost ([::1]:53852 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j2ehQ-0004PX-Uo; Fri, 14 Feb 2020 18:24:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] src: Fix nftnl_assert() on data_len
Date:   Fri, 14 Feb 2020 18:24:17 +0100
Message-Id: <20200214172417.11217-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Typical idiom for *_get_u*() getters is to call *_get_data() and make
sure data_len matches what each of them is returning. Yet they shouldn't
trust *_get_data() to write into passed pointer to data_len since for
chains and NFTNL_CHAIN_DEVICES attribute, it does not. Make sure these
assert() calls trigger in those cases.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/chain.c | 8 ++++----
 src/rule.c  | 6 +++---
 src/set.c   | 4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index b4066e4d4e888..62a9249b57930 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -385,7 +385,7 @@ const char *nftnl_chain_get_str(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_get_u32);
 uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint32_t *val = nftnl_chain_get_data(c, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(uint32_t));
@@ -396,7 +396,7 @@ uint32_t nftnl_chain_get_u32(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_get_s32);
 int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const int32_t *val = nftnl_chain_get_data(c, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(int32_t));
@@ -407,7 +407,7 @@ int32_t nftnl_chain_get_s32(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_get_u64);
 uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint64_t *val = nftnl_chain_get_data(c, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(int64_t));
@@ -418,7 +418,7 @@ uint64_t nftnl_chain_get_u64(const struct nftnl_chain *c, uint16_t attr)
 EXPORT_SYMBOL(nftnl_chain_get_u8);
 uint8_t nftnl_chain_get_u8(const struct nftnl_chain *c, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint8_t *val = nftnl_chain_get_data(c, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(int8_t));
diff --git a/src/rule.c b/src/rule.c
index 8d7e0681cb42c..ffdbbf8e08140 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -249,7 +249,7 @@ const char *nftnl_rule_get_str(const struct nftnl_rule *r, uint16_t attr)
 EXPORT_SYMBOL(nftnl_rule_get_u32);
 uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint32_t *val = nftnl_rule_get_data(r, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(uint32_t));
@@ -260,7 +260,7 @@ uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr)
 EXPORT_SYMBOL(nftnl_rule_get_u64);
 uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint64_t *val = nftnl_rule_get_data(r, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(uint64_t));
@@ -271,7 +271,7 @@ uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr)
 EXPORT_SYMBOL(nftnl_rule_get_u8);
 uint8_t nftnl_rule_get_u8(const struct nftnl_rule *r, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint8_t *val = nftnl_rule_get_data(r, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(uint8_t));
diff --git a/src/set.c b/src/set.c
index 651dcfa56022d..6a6f19bc7fbbf 100644
--- a/src/set.c
+++ b/src/set.c
@@ -303,7 +303,7 @@ const char *nftnl_set_get_str(const struct nftnl_set *s, uint16_t attr)
 EXPORT_SYMBOL(nftnl_set_get_u32);
 uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint32_t *val = nftnl_set_get_data(s, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(uint32_t));
@@ -314,7 +314,7 @@ uint32_t nftnl_set_get_u32(const struct nftnl_set *s, uint16_t attr)
 EXPORT_SYMBOL(nftnl_set_get_u64);
 uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
 {
-	uint32_t data_len;
+	uint32_t data_len = 0;
 	const uint64_t *val = nftnl_set_get_data(s, attr, &data_len);
 
 	nftnl_assert(val, attr, data_len == sizeof(uint64_t));
-- 
2.24.1

