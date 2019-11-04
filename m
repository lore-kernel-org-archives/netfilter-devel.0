Return-Path: <SRS0=62bg=Y4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FB9CA9EB5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 20:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A19020848
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 20:21:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfKDUVL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Nov 2019 15:21:11 -0500
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:53516
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfKDUVL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Nov 2019 15:21:11 -0500
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iRiqa-0006kB-Nf; Mon, 04 Nov 2019 21:21:08 +0100
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH libnftnl] flowtable: add support for handle attribute
Date:   Mon,  4 Nov 2019 21:19:58 +0100
Message-Id: <20191104201958.25815-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add code to implement NFTA_FLOWTABLE_HANDLE

Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 include/libnftnl/flowtable.h |  3 +++
 src/flowtable.c              | 36 ++++++++++++++++++++++++++++++++++++
 src/libnftnl.map             |  2 ++
 tests/nft-flowtable-test.c   | 20 ++++++++++++--------
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/include/libnftnl/flowtable.h b/include/libnftnl/flowtable.h
index 028095ec106c..bdff114aba54 100644
--- a/include/libnftnl/flowtable.h
+++ b/include/libnftnl/flowtable.h
@@ -27,6 +27,7 @@ enum nftnl_flowtable_attr {
 	NFTNL_FLOWTABLE_DEVICES,
 	NFTNL_FLOWTABLE_SIZE,
 	NFTNL_FLOWTABLE_FLAGS,
+	NFTNL_FLOWTABLE_HANDLE,
 	__NFTNL_FLOWTABLE_MAX
 };
 #define NFTNL_FLOWTABLE_MAX (__NFTNL_FLOWTABLE_MAX - 1)
@@ -38,6 +39,7 @@ int nftnl_flowtable_set_data(struct nftnl_flowtable *t, uint16_t attr,
 			     const void *data, uint32_t data_len);
 void nftnl_flowtable_set_u32(struct nftnl_flowtable *t, uint16_t attr, uint32_t data);
 void nftnl_flowtable_set_s32(struct nftnl_flowtable *t, uint16_t attr, int32_t data);
+void nftnl_flowtable_set_u64(struct nftnl_flowtable *t, uint16_t attr, uint64_t data);
 int nftnl_flowtable_set_str(struct nftnl_flowtable *t, uint16_t attr, const char *str);
 void nftnl_flowtable_set_array(struct nftnl_flowtable *t, uint16_t attr, const char **data);
 
@@ -47,6 +49,7 @@ const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c, uint16_t a
 const char *nftnl_flowtable_get_str(const struct nftnl_flowtable *c, uint16_t attr);
 uint32_t nftnl_flowtable_get_u32(const struct nftnl_flowtable *c, uint16_t attr);
 int32_t nftnl_flowtable_get_s32(const struct nftnl_flowtable *c, uint16_t attr);
+uint64_t nftnl_flowtable_get_u64(const struct nftnl_flowtable *c, uint16_t attr);
 const char **nftnl_flowtable_get_array(const struct nftnl_flowtable *t, uint16_t attr);
 
 struct nlmsghdr;
diff --git a/src/flowtable.c b/src/flowtable.c
index ed91357a8c45..ec89b952e47d 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -32,6 +32,7 @@ struct nftnl_flowtable {
 	uint32_t		ft_flags;
 	uint32_t		use;
 	uint32_t		flags;
+	uint64_t		handle;
 };
 
 EXPORT_SYMBOL(nftnl_flowtable_alloc);
@@ -84,6 +85,7 @@ void nftnl_flowtable_unset(struct nftnl_flowtable *c, uint16_t attr)
 	case NFTNL_FLOWTABLE_USE:
 	case NFTNL_FLOWTABLE_FAMILY:
 	case NFTNL_FLOWTABLE_FLAGS:
+	case NFTNL_FLOWTABLE_HANDLE:
 		break;
 	case NFTNL_FLOWTABLE_DEVICES:
 		for (i = 0; i < c->dev_array_len; i++)
@@ -102,6 +104,7 @@ static uint32_t nftnl_flowtable_validate[NFTNL_FLOWTABLE_MAX + 1] = {
 	[NFTNL_FLOWTABLE_PRIO]		= sizeof(int32_t),
 	[NFTNL_FLOWTABLE_FAMILY]	= sizeof(uint32_t),
 	[NFTNL_FLOWTABLE_FLAGS]		= sizeof(uint32_t),
+	[NFTNL_FLOWTABLE_HANDLE]	= sizeof(uint64_t),
 };
 
 EXPORT_SYMBOL(nftnl_flowtable_set_data);
@@ -166,6 +169,9 @@ int nftnl_flowtable_set_data(struct nftnl_flowtable *c, uint16_t attr,
 	case NFTNL_FLOWTABLE_FLAGS:
 		memcpy(&c->ft_flags, data, sizeof(c->ft_flags));
 		break;
+	case NFTNL_FLOWTABLE_HANDLE:
+		memcpy(&c->handle, data, sizeof(c->handle));
+		break;
 	}
 	c->flags |= (1 << attr);
 	return 0;
@@ -195,6 +201,12 @@ int nftnl_flowtable_set_str(struct nftnl_flowtable *c, uint16_t attr, const char
 	return nftnl_flowtable_set_data(c, attr, str, strlen(str) + 1);
 }
 
+EXPORT_SYMBOL(nftnl_flowtable_set_u64);
+void nftnl_flowtable_set_u64(struct nftnl_flowtable *c, uint16_t attr, uint64_t data)
+{
+	nftnl_flowtable_set_data(c, attr, &data, sizeof(uint64_t));
+}
+
 EXPORT_SYMBOL(nftnl_flowtable_get_data);
 const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 				     uint16_t attr, uint32_t *data_len)
@@ -226,6 +238,9 @@ const void *nftnl_flowtable_get_data(const struct nftnl_flowtable *c,
 	case NFTNL_FLOWTABLE_FLAGS:
 		*data_len = sizeof(int32_t);
 		return &c->ft_flags;
+	case NFTNL_FLOWTABLE_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &c->handle;
 	}
 	return NULL;
 }
@@ -254,6 +269,17 @@ uint32_t nftnl_flowtable_get_u32(const struct nftnl_flowtable *c, uint16_t attr)
 	return val ? *val : 0;
 }
 
+EXPORT_SYMBOL(nftnl_flowtable_get_u64);
+uint64_t nftnl_flowtable_get_u64(const struct nftnl_flowtable *c, uint16_t attr)
+{
+	uint32_t data_len = 0;
+	const uint64_t *val = nftnl_flowtable_get_data(c, attr, &data_len);
+
+	nftnl_assert(val, attr, data_len == sizeof(uint64_t));
+
+	return val ? *val : 0;
+}
+
 EXPORT_SYMBOL(nftnl_flowtable_get_s32);
 int32_t nftnl_flowtable_get_s32(const struct nftnl_flowtable *c, uint16_t attr)
 {
@@ -300,6 +326,8 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_USE, htonl(c->use));
 	if (c->flags & (1 << NFTNL_FLOWTABLE_SIZE))
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_SIZE, htonl(c->size));
+	if (c->flags & (1 << NFTNL_FLOWTABLE_HANDLE))
+		mnl_attr_put_u64(nlh, NFTA_FLOWTABLE_HANDLE, htobe64(c->handle));
 }
 
 static int nftnl_flowtable_parse_attr_cb(const struct nlattr *attr, void *data)
@@ -325,6 +353,10 @@ static int nftnl_flowtable_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_FLOWTABLE_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -461,6 +493,10 @@ int nftnl_flowtable_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_flowtab
 		c->size = ntohl(mnl_attr_get_u32(tb[NFTA_FLOWTABLE_SIZE]));
 		c->flags |= (1 << NFTNL_FLOWTABLE_SIZE);
 	}
+	if (tb[NFTA_FLOWTABLE_HANDLE]) {
+		c->handle = be64toh(mnl_attr_get_u64(tb[NFTA_FLOWTABLE_HANDLE]));
+		c->flags |= (1 << NFTNL_FLOWTABLE_HANDLE);
+	}
 
 	c->family = nfg->nfgen_family;
 	c->flags |= (1 << NFTNL_FLOWTABLE_FAMILY);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index e810c4de445f..8230d1519e8e 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -314,10 +314,12 @@ global:
   nftnl_flowtable_set_u32;
   nftnl_flowtable_set_s32;
   nftnl_flowtable_set_str;
+  nftnl_flowtable_set_u64;
   nftnl_flowtable_get;
   nftnl_flowtable_get_u32;
   nftnl_flowtable_get_s32;
   nftnl_flowtable_get_str;
+  nftnl_flowtable_get_u64;
   nftnl_flowtable_parse;
   nftnl_flowtable_parse_file;
   nftnl_flowtable_snprintf;
diff --git a/tests/nft-flowtable-test.c b/tests/nft-flowtable-test.c
index 1311cf2e4594..3edb00ddf319 100644
--- a/tests/nft-flowtable-test.c
+++ b/tests/nft-flowtable-test.c
@@ -17,28 +17,31 @@ static void cmp_nftnl_flowtable(struct nftnl_flowtable *a, struct nftnl_flowtabl
 {
 	if (strcmp(nftnl_flowtable_get_str(a, NFTNL_FLOWTABLE_NAME),
 		   nftnl_flowtable_get_str(b, NFTNL_FLOWTABLE_NAME)) != 0)
-		print_err("Chain name mismatches");
+		print_err("Flowtable name mismatches");
 	if (strcmp(nftnl_flowtable_get_str(a, NFTNL_FLOWTABLE_TABLE),
 		   nftnl_flowtable_get_str(b, NFTNL_FLOWTABLE_TABLE)) != 0)
-		print_err("Chain table mismatches");
+		print_err("Flowtable table mismatches");
 	if (nftnl_flowtable_get_u32(a, NFTNL_FLOWTABLE_FAMILY) !=
 	    nftnl_flowtable_get_u32(b, NFTNL_FLOWTABLE_FAMILY))
-		print_err("Chain family mismatches");
+		print_err("Flowtable family mismatches");
 	if (nftnl_flowtable_get_u32(a, NFTNL_FLOWTABLE_HOOKNUM) !=
 	    nftnl_flowtable_get_u32(b, NFTNL_FLOWTABLE_HOOKNUM))
-		print_err("Chain hooknum mismatches");
+		print_err("Flowtable hooknum mismatches");
 	if (nftnl_flowtable_get_s32(a, NFTNL_FLOWTABLE_PRIO) !=
 	    nftnl_flowtable_get_s32(b, NFTNL_FLOWTABLE_PRIO))
-		print_err("Chain Prio mismatches");
+		print_err("Flowtable prio mismatches");
 	if (nftnl_flowtable_get_u32(a, NFTNL_FLOWTABLE_USE) !=
 	    nftnl_flowtable_get_u32(b, NFTNL_FLOWTABLE_USE))
-		print_err("Chain use mismatches");
+		print_err("Flowtable use mismatches");
 	if (nftnl_flowtable_get_u32(a, NFTNL_FLOWTABLE_SIZE) !=
 	    nftnl_flowtable_get_u32(b, NFTNL_FLOWTABLE_SIZE))
-		print_err("Chain use mismatches");
+		print_err("Flowtable size mismatches");
 	if (nftnl_flowtable_get_u32(a, NFTNL_FLOWTABLE_FLAGS) !=
 	    nftnl_flowtable_get_u32(b, NFTNL_FLOWTABLE_FLAGS))
-		print_err("Chain use mismatches");
+		print_err("Flowtable flags mismatches");
+	if (nftnl_flowtable_get_u64(a, NFTNL_FLOWTABLE_HANDLE) !=
+	    nftnl_flowtable_get_u64(b, NFTNL_FLOWTABLE_HANDLE))
+		print_err("Flowtable handle mismatches");
 }
 
 int main(int argc, char *argv[])
@@ -60,6 +63,7 @@ int main(int argc, char *argv[])
 	nftnl_flowtable_set_u32(a, NFTNL_FLOWTABLE_USE, 0x78123456);
 	nftnl_flowtable_set_u32(a, NFTNL_FLOWTABLE_SIZE, 0x89016745);
 	nftnl_flowtable_set_u32(a, NFTNL_FLOWTABLE_FLAGS, 0x45016723);
+	nftnl_flowtable_set_u64(a, NFTNL_FLOWTABLE_HANDLE, 0x2345016789);
 
 	nlh = nftnl_nlmsg_build_hdr(buf, NFT_MSG_NEWFLOWTABLE, AF_INET,
 				    0, 1234);
-- 
2.11.0

