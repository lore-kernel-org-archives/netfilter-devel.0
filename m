Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70BD3CE79DD
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbjITObM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbjITObL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:31:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5D3DD
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 07:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695220219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QiWRlx/fVnDIDHJq0728x3jSc6CUqx0zfXucjT+EbuI=;
        b=N6a/w0j8l+f8/U9bT2JbIy9IOrS+aSAJB+LqXgAKQh7Bn4XLh9Rc7v+E+RUqD1ZqyAz+VN
        Yesz5RAqOvfxkwBtxBXCFJfeKF6dY5ioFCmTHfXfk/cTjWv8Q89yrCGuPd6VYhH7+WLoQs
        mjhTQr02krLCLdvFbdQHUvH/GEqde8s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-351-4q8S_RkNM2OmALPX13Z6AQ-1; Wed, 20 Sep 2023 10:30:16 -0400
X-MC-Unique: 4q8S_RkNM2OmALPX13Z6AQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FE6189C6A7
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 14:30:16 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E7DC10F1BE7;
        Wed, 20 Sep 2023 14:30:15 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 8/9] datatype: use __attribute__((packed)) instead of enum bitfields
Date:   Wed, 20 Sep 2023 16:26:09 +0200
Message-ID: <20230920142958.566615-9-thaller@redhat.com>
In-Reply-To: <20230920142958.566615-1-thaller@redhat.com>
References: <20230920142958.566615-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At some places we use bitfields of those enums, to save space inside the
structure. We can achieve that in a better way, by using GCC's
__attribute__((packed)) on the enum type.

It's better because a :8 bitfield makes the assumption that all enum
values (valid or invalid) fit into that field. With packed enums, we
don't need that assumption as the field can hold all possible numbers
that the enum type can hold. This reduces the places we need to worry
about truncating a value to casts between other types and the enum.
Those places already require us to be careful.

On the other hand, previously casting an int (or uint32_t) likely didn't
cause a truncation as the underlying type was large enough. So we could
check for invalid enum values after the cast. We might do that at
places. For example, we do

	key  = nftnl_expr_get_u32(nle, NFTNL_EXPR_META_KEY);
	expr = meta_expr_alloc(loc, key);

where we cast from an uint32_t to an enum without checking. Note that
`enum nft_meta_keys` is not packed by this patch. But this is an example
how things could be wrong. But the bug already exits before: don't make
assumption about the underlying enum type and take care of truncation
during casts.

This makes the change potentially dangerous, and it's hard to be sure
that it doesn't uncover bugs (due tow rong assumptions about enum types).

Note that we were already using the GCC-ism __attribute__((packed))
previously, however on a struct and not on an enum. Anyway. It seems
unlikely that we support any other compilers than GCC/Clang. Those both
support this attribute.  We should not worry about portability towards
hypothetical compilers (the C standard), unless there is a real compiler
that we can use and test and shows a problem with this. Especially when
we support both GCC and Clang, which themselves are ubiquitous and
accessible to all users (as they also need to build the kernel in the
first place).

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 include/datatype.h   |  1 +
 include/expression.h |  8 +++++---
 include/proto.h      | 11 +++++++----
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 202935bd322f..c8b3b77ad0c0 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -112,6 +112,7 @@ enum datatypes {
  * @BYTEORDER_HOST_ENDIAN:	host endian
  * @BYTEORDER_BIG_ENDIAN:	big endian
  */
+__attribute__((packed))
 enum byteorder {
 	BYTEORDER_INVALID,
 	BYTEORDER_HOST_ENDIAN,
diff --git a/include/expression.h b/include/expression.h
index aede223db741..11a1dbf00b8c 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -45,6 +45,7 @@
  * @EXPR_SET_ELEM_CATCHALL catchall element expression
  * @EXPR_FLAGCMP	flagcmp expression
  */
+__attribute__((packed))
 enum expr_types {
 	EXPR_INVALID,
 	EXPR_VERDICT,
@@ -80,6 +81,7 @@ enum expr_types {
 	EXPR_MAX = EXPR_FLAGCMP
 };
 
+__attribute__((packed))
 enum ops {
 	OP_INVALID,
 	OP_IMPLICIT,
@@ -247,9 +249,9 @@ struct expr {
 	unsigned int		flags;
 
 	const struct datatype	*dtype;
-	enum byteorder		byteorder:8;
-	enum expr_types		etype:8;
-	enum ops		op:8;
+	enum byteorder		byteorder;
+	enum expr_types		etype;
+	enum ops		op;
 	unsigned int		len;
 	struct cmd		*cmd;
 
diff --git a/include/proto.h b/include/proto.h
index 3a20ff8c4071..3756a4ab79a4 100644
--- a/include/proto.h
+++ b/include/proto.h
@@ -13,6 +13,7 @@
  * @PROTO_BASE_NETWORK_HDR:	network layer header
  * @PROTO_BASE_TRANSPORT_HDR:	transport layer header
  */
+__attribute__((packed))
 enum proto_bases {
 	PROTO_BASE_INVALID,
 	PROTO_BASE_LL_HDR,
@@ -26,6 +27,7 @@ enum proto_bases {
 extern const char *proto_base_names[];
 extern const char *proto_base_tokens[];
 
+__attribute__((packed))
 enum icmp_hdr_field_type {
 	PROTO_ICMP_ANY = 0,
 	PROTO_ICMP_ECHO,	/* echo and reply */
@@ -52,9 +54,9 @@ struct proto_hdr_template {
 	const struct datatype		*dtype;
 	uint16_t			offset;
 	uint16_t			len;
-	enum byteorder			byteorder:8;
+	enum byteorder			byteorder;
 	enum nft_meta_keys		meta_key:8;
-	enum icmp_hdr_field_type	icmp_dep:8;
+	enum icmp_hdr_field_type	icmp_dep;
 };
 
 #define PROTO_HDR_TEMPLATE(__token, __dtype,  __byteorder, __offset, __len)\
@@ -77,6 +79,7 @@ struct proto_hdr_template {
 #define PROTO_UPPER_MAX		16
 #define PROTO_HDRS_MAX		20
 
+__attribute__((packed))
 enum proto_desc_id {
 	PROTO_DESC_UNKNOWN	= 0,
 	PROTO_DESC_AH,
@@ -119,8 +122,8 @@ enum proto_desc_id {
  */
 struct proto_desc {
 	const char			*name;
-	enum proto_desc_id		id:8;
-	enum proto_bases		base:8;
+	enum proto_desc_id		id;
+	enum proto_bases		base;
 	enum nft_payload_csum_types	checksum_type:8;
 	uint16_t			checksum_key;
 	uint16_t			protocol_key;
-- 
2.41.0

