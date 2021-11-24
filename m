Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22F1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 17:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbhKXR0e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:26:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbhKXR0b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 12:26:31 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292E1C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 09:23:21 -0800 (PST)
Received: from localhost ([::1]:44844 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mpvzL-00016n-E5; Wed, 24 Nov 2021 18:23:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 7/7] set: Introduce nftnl_set_elem_snprintf_desc()
Date:   Wed, 24 Nov 2021 18:22:42 +0100
Message-Id: <20211124172242.11402-8-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124172242.11402-1-phil@nwl.cc>
References: <20211124172242.11402-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new API function allows to print set elements' data properly
formatted according to field size and byteorder by accepting a struct
nftnl_set_desc pointer.

Pass the desc pointer internally along by extending
nftnl_set_elem_snprintf_default() signature and introduce a small helper
to call the right data reg printing routine depending on data reg type.

Since the new function is very similar to nftnl_set_elem_cmd_snprintf(),
make it replace the latter.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/data_reg.h     |  6 +++++
 include/libnftnl/set.h |  4 ++++
 include/set_elem.h     |  3 ---
 src/expr/data_reg.c    |  2 +-
 src/libnftnl.map       |  4 ++++
 src/set.c              |  5 +++--
 src/set_elem.c         | 50 +++++++++++++++++++++++++++---------------
 7 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/include/data_reg.h b/include/data_reg.h
index 3f24b6725e148..c9ab318266113 100644
--- a/include/data_reg.h
+++ b/include/data_reg.h
@@ -30,6 +30,12 @@ union nftnl_data_reg {
 	};
 };
 
+int
+nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
+				      const union nftnl_data_reg *reg,
+				      uint32_t flags, uint16_t byteorder_bits,
+				      const uint8_t *lengths);
+
 int nftnl_data_reg_snprintf(char *buf, size_t size,
 			    const union nftnl_data_reg *reg,
 			    uint32_t flags, int reg_type,
diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index d19635716b581..9d9891c516624 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -163,6 +163,10 @@ int nftnl_set_elem_parse(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 		       const char *data, struct nftnl_parse_err *err);
 int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type type,
 			    FILE *fp, struct nftnl_parse_err *err);
+int nftnl_set_elem_snprintf_desc(char *buf, size_t size,
+				 const struct nftnl_set_elem *e,
+				 const struct nftnl_set_desc *desc,
+				 uint32_t type, uint32_t flags);
 int nftnl_set_elem_snprintf(char *buf, size_t size, const struct nftnl_set_elem *s, uint32_t type, uint32_t flags);
 int nftnl_set_elem_fprintf(FILE *fp, const struct nftnl_set_elem *se, uint32_t type, uint32_t flags);
 
diff --git a/include/set_elem.h b/include/set_elem.h
index 76280051bb803..9239557469feb 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -20,7 +20,4 @@ struct nftnl_set_elem {
 	} user;
 };
 
-int nftnl_set_elem_snprintf_default(char *buf, size_t size,
-				    const struct nftnl_set_elem *e);
-
 #endif
diff --git a/src/expr/data_reg.c b/src/expr/data_reg.c
index 6cbf0c4860cda..c85c9e5b3dbe2 100644
--- a/src/expr/data_reg.c
+++ b/src/expr/data_reg.c
@@ -56,7 +56,7 @@ print_data(char *buf, size_t size, uint8_t *data, size_t len, bool nbo)
 	return offset;
 }
 
-static int
+int
 nftnl_data_reg_value_snprintf_default(char *buf, size_t remain,
 				      const union nftnl_data_reg *reg,
 				      uint32_t flags, uint16_t byteorder_bits,
diff --git a/src/libnftnl.map b/src/libnftnl.map
index ad8f2af060aef..595e424bd5073 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -387,3 +387,7 @@ LIBNFTNL_16 {
 LIBNFTNL_17 {
   nftnl_set_elem_nlmsg_build;
 } LIBNFTNL_16;
+
+LIBNFTNL_18 {
+  nftnl_set_elem_snprintf_desc;
+} LIBNFTNL_17;
diff --git a/src/set.c b/src/set.c
index e793282175eb5..2d2f45e5f129b 100644
--- a/src/set.c
+++ b/src/set.c
@@ -844,8 +844,9 @@ static int nftnl_set_snprintf_default(char *buf, size_t remain,
 		ret = snprintf(buf + offset, remain, "\t");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_set_elem_snprintf_default(buf + offset, remain,
-						      elem);
+		ret = nftnl_set_elem_snprintf_desc(buf + offset, remain,
+						   elem, &s->desc,
+						   NFTNL_OUTPUT_DEFAULT, 0);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
diff --git a/src/set_elem.c b/src/set_elem.c
index 9b18f4def6c47..f911f5b16a102 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -699,26 +699,39 @@ int nftnl_set_elem_parse_file(struct nftnl_set_elem *e, enum nftnl_parse_type ty
 	return -1;
 }
 
-int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
-				    const struct nftnl_set_elem *e)
+static int print_dreg(char *buf, size_t size, const union nftnl_data_reg *reg,
+		      int dregtype, uint16_t byteorder, const uint8_t *lengths)
+{
+	if (dregtype == DATA_VERDICT)
+		return nftnl_data_reg_snprintf(buf, size, reg,
+					       DATA_F_NOPFX, dregtype,
+					       NFTNL_BYTEORDER_UNKNOWN);
+
+	return nftnl_data_reg_value_snprintf_default(buf, size, reg,
+						     DATA_F_NOPFX,
+						     byteorder, lengths);
+}
+
+static int
+nftnl_set_elem_snprintf_default(char *buf, size_t remain,
+				    const struct nftnl_set_elem *e,
+				    const struct nftnl_set_desc *desc)
 {
 	int ret, dregtype = DATA_VALUE, offset = 0, i;
 
 	ret = snprintf(buf, remain, "element ");
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key,
-				      DATA_F_NOPFX, DATA_VALUE,
-				      NFTNL_BYTEORDER_UNKNOWN);
+	ret = print_dreg(buf + offset, remain, &e->key, dregtype,
+			 desc->byteorder & 0xffff, desc->field_len);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	if (e->flags & (1 << NFTNL_SET_ELEM_KEY_END)) {
 		ret = snprintf(buf + offset, remain, " - ");
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
-		ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->key_end,
-					      DATA_F_NOPFX, DATA_VALUE,
-					      NFTNL_BYTEORDER_UNKNOWN);
+		ret = print_dreg(buf + offset, remain, &e->key_end, dregtype,
+				 desc->byteorder & 0xffff, desc->field_len);
 		SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 	}
 
@@ -728,9 +741,8 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 	if (e->flags & (1 << NFTNL_SET_ELEM_VERDICT))
 		dregtype = DATA_VERDICT;
 
-	ret = nftnl_data_reg_snprintf(buf + offset, remain, &e->data,
-				      DATA_F_NOPFX, dregtype,
-				      NFTNL_BYTEORDER_UNKNOWN);
+	ret = print_dreg(buf + offset, remain, &e->data, dregtype,
+			 desc->byteorder >> 16, desc->data_len);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	ret = snprintf(buf + offset, remain, "%u [end]", e->set_elem_flags);
@@ -755,17 +767,18 @@ int nftnl_set_elem_snprintf_default(char *buf, size_t remain,
 	return offset;
 }
 
-static int nftnl_set_elem_cmd_snprintf(char *buf, size_t remain,
-				       const struct nftnl_set_elem *e,
-				       uint32_t cmd, uint32_t type,
-				       uint32_t flags)
+EXPORT_SYMBOL(nftnl_set_elem_snprintf_desc);
+int nftnl_set_elem_snprintf_desc(char *buf, size_t remain,
+				 const struct nftnl_set_elem *e,
+				 const struct nftnl_set_desc *desc,
+				 uint32_t type, uint32_t flags)
 {
 	int ret, offset = 0;
 
 	if (type != NFTNL_OUTPUT_DEFAULT)
 		return -1;
 
-	ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e);
+	ret = nftnl_set_elem_snprintf_default(buf + offset, remain, e, desc);
 	SNPRINTF_BUFFER_SIZE(ret, remain, offset);
 
 	return offset;
@@ -776,11 +789,12 @@ int nftnl_set_elem_snprintf(char *buf, size_t size,
 			    const struct nftnl_set_elem *e,
 			    uint32_t type, uint32_t flags)
 {
+	struct nftnl_set_desc desc = {};
+
 	if (size)
 		buf[0] = '\0';
 
-	return nftnl_set_elem_cmd_snprintf(buf, size, e, nftnl_flag2cmd(flags),
-					 type, flags);
+	return nftnl_set_elem_snprintf_desc(buf, size, e, &desc, type, flags);
 }
 
 static int nftnl_set_elem_do_snprintf(char *buf, size_t size, const void *e,
-- 
2.33.0

