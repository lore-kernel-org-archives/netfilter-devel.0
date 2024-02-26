Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 499FE131724
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Feb 2024 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708967497; cv=none; b=pOWCBHFJmMwcKPDfhz79actxnZcbLk4Sf78cf3yaCBASVaBiZ/c3KejQU2+ROdpb6ibHENS2RIhFrdZALnP0L6GCadmxD0j+tRz++VH9EhM7oyCzupWV94Ib/quHrcpi0GxH2MLF8IicatFzdVmIKYRUf225dpurqlmtxb6FTgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708967497; c=relaxed/simple;
	bh=SmTtszsDiLOdUUElUnhPTB50N1PwEJjjFFqNLCGlObI=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CX4ND19d7DEP9/oS+AibXwic24fC8VRzU1IMEaJ+UV4GfYECYZXDZO/93muPgjWhfUvbBOPC0Px6fRryG1DHqC8ElBCNQE/69jCXF+ZrSFf+xdp5Rhfhn1fwUtJRZZqT21votU3ceF2/YCsygRAX68vLlAIi44rprq+YZizIc+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 3/3] utils: remove unused code
Date: Mon, 26 Feb 2024 18:11:27 +0100
Message-Id: <20240226171127.256640-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240226171127.256640-1-pablo@netfilter.org>
References: <20240226171127.256640-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove several internal code that have no use these days:

- nftnl_str2family
- nftnl_strtoi
- nftnl_get_value
- enum nftnl_type

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/utils.h |  19 -----
 src/utils.c     | 194 ------------------------------------------------
 2 files changed, 213 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 8af5a8e973fa..ff76f77ebb35 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -68,27 +68,8 @@ void __nftnl_assert_attr_exists(uint16_t attr, uint16_t attr_max,
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 const char *nftnl_family2str(uint32_t family);
-int nftnl_str2family(const char *family);
-
-enum nftnl_type {
-	NFTNL_TYPE_U8,
-	NFTNL_TYPE_U16,
-	NFTNL_TYPE_U32,
-	NFTNL_TYPE_U64,
-	NFTNL_TYPE_S8,
-	NFTNL_TYPE_S16,
-	NFTNL_TYPE_S32,
-	NFTNL_TYPE_S64,
-};
-
-int nftnl_strtoi(const char *string, int base, void *number, enum nftnl_type type);
-int nftnl_get_value(enum nftnl_type type, void *val, void *out);
 
 const char *nftnl_verdict2str(uint32_t verdict);
-int nftnl_str2verdict(const char *verdict, int *verdict_num);
-
-const char *nftnl_cmd2tag(enum nftnl_cmd_type cmd);
-uint32_t nftnl_str2cmd(const char *cmd);
 
 enum nftnl_cmd_type nftnl_flag2cmd(uint32_t flags);
 
diff --git a/src/utils.c b/src/utils.c
index 3617837c9a5f..ffbad89a0dad 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -39,146 +39,6 @@ const char *nftnl_family2str(uint32_t family)
 	return nftnl_family_str[family];
 }
 
-int nftnl_str2family(const char *family)
-{
-	int i;
-
-	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
-		if (nftnl_family_str[i] == NULL)
-			continue;
-
-		if (strcmp(nftnl_family_str[i], family) == 0)
-			return i;
-	}
-
-	errno = EAFNOSUPPORT;
-	return -1;
-}
-
-static struct {
-	int len;
-	int64_t min;
-	uint64_t max;
-} basetype[] = {
-	[NFTNL_TYPE_U8]	 = { .len = sizeof(uint8_t), .max = UINT8_MAX },
-	[NFTNL_TYPE_U16] = { .len = sizeof(uint16_t), .max = UINT16_MAX },
-	[NFTNL_TYPE_U32] = { .len = sizeof(uint32_t), .max = UINT32_MAX },
-	[NFTNL_TYPE_U64] = { .len = sizeof(uint64_t), .max = UINT64_MAX },
-	[NFTNL_TYPE_S8]  = { .len = sizeof(int8_t), .min = INT8_MIN, .max = INT8_MAX },
-	[NFTNL_TYPE_S16] = { .len = sizeof(int16_t), .min = INT16_MIN, .max = INT16_MAX },
-	[NFTNL_TYPE_S32] = { .len = sizeof(int32_t), .min = INT32_MIN, .max = INT32_MAX },
-	[NFTNL_TYPE_S64] = { .len = sizeof(int64_t), .min = INT64_MIN, .max = INT64_MAX },
-};
-
-int nftnl_get_value(enum nftnl_type type, void *val, void *out)
-{
-	union {
-		uint8_t u8;
-		uint16_t u16;
-		uint32_t u32;
-		int8_t s8;
-		int16_t s16;
-		int32_t s32;
-	} values;
-	void *valuep = NULL;
-	int64_t sval;
-	uint64_t uval;
-
-	switch (type) {
-	case NFTNL_TYPE_U8:
-	case NFTNL_TYPE_U16:
-	case NFTNL_TYPE_U32:
-	case NFTNL_TYPE_U64:
-		memcpy(&uval, val, sizeof(uval));
-		if (uval > basetype[type].max) {
-			errno = ERANGE;
-			return -1;
-		}
-		break;
-	case NFTNL_TYPE_S8:
-	case NFTNL_TYPE_S16:
-	case NFTNL_TYPE_S32:
-	case NFTNL_TYPE_S64:
-		memcpy(&sval, val, sizeof(sval));
-		if (sval < basetype[type].min ||
-		    sval > (int64_t)basetype[type].max) {
-			errno = ERANGE;
-			return -1;
-		}
-		break;
-	}
-
-	switch (type) {
-	case NFTNL_TYPE_U8:
-		values.u8 = uval;
-		valuep = &values.u8;
-		break;
-	case NFTNL_TYPE_U16:
-		values.u16 = uval;
-		valuep = &values.u16;
-		break;
-	case NFTNL_TYPE_U32:
-		values.u32 = uval;
-		valuep = &values.u32;
-		break;
-	case NFTNL_TYPE_U64:
-		valuep = &uval;
-		break;
-	case NFTNL_TYPE_S8:
-		values.s8 = sval;
-		valuep = &values.s8;
-		break;
-	case NFTNL_TYPE_S16:
-		values.s16 = sval;
-		valuep = &values.s16;
-		break;
-	case NFTNL_TYPE_S32:
-		values.s32 = sval;
-		valuep = &values.s32;
-		break;
-	case NFTNL_TYPE_S64:
-		valuep = &sval;
-		break;
-	}
-	memcpy(out, valuep, basetype[type].len);
-	return 0;
-}
-
-int nftnl_strtoi(const char *string, int base, void *out, enum nftnl_type type)
-{
-	int ret;
-	int64_t sval = 0;
-	uint64_t uval = -1;
-	char *endptr;
-
-	switch (type) {
-	case NFTNL_TYPE_U8:
-	case NFTNL_TYPE_U16:
-	case NFTNL_TYPE_U32:
-	case NFTNL_TYPE_U64:
-		uval = strtoll(string, &endptr, base);
-		ret = nftnl_get_value(type, &uval, out);
-		break;
-	case NFTNL_TYPE_S8:
-	case NFTNL_TYPE_S16:
-	case NFTNL_TYPE_S32:
-	case NFTNL_TYPE_S64:
-		sval = strtoull(string, &endptr, base);
-		ret = nftnl_get_value(type, &sval, out);
-		break;
-	default:
-		errno = EINVAL;
-		return -1;
-	}
-
-	if (*endptr) {
-		errno = EINVAL;
-		return -1;
-	}
-
-	return ret;
-}
-
 const char *nftnl_verdict2str(uint32_t verdict)
 {
 	switch (verdict) {
@@ -209,28 +69,6 @@ const char *nftnl_verdict2str(uint32_t verdict)
 	}
 }
 
-int nftnl_str2verdict(const char *verdict, int *verdict_num)
-{
-	if (strcmp(verdict, "accept") == 0) {
-		*verdict_num = NF_ACCEPT;
-		return 0;
-	} else if (strcmp(verdict, "drop") == 0) {
-		*verdict_num = NF_DROP;
-		return 0;
-	} else if (strcmp(verdict, "return") == 0) {
-		*verdict_num = NFT_RETURN;
-		return 0;
-	} else if (strcmp(verdict, "jump") == 0) {
-		*verdict_num = NFT_JUMP;
-		return 0;
-	} else if (strcmp(verdict, "goto") == 0) {
-		*verdict_num = NFT_GOTO;
-		return 0;
-	}
-
-	return -1;
-}
-
 enum nftnl_cmd_type nftnl_flag2cmd(uint32_t flags)
 {
 	if (flags & NFTNL_OF_EVENT_NEW)
@@ -241,38 +79,6 @@ enum nftnl_cmd_type nftnl_flag2cmd(uint32_t flags)
 	return NFTNL_CMD_UNSPEC;
 }
 
-static const char *cmd2tag[NFTNL_CMD_MAX] = {
-	[NFTNL_CMD_ADD]			= "add",
-	[NFTNL_CMD_INSERT]		= "insert",
-	[NFTNL_CMD_DELETE]		= "delete",
-	[NFTNL_CMD_REPLACE]		= "replace",
-	[NFTNL_CMD_FLUSH]			= "flush",
-};
-
-const char *nftnl_cmd2tag(enum nftnl_cmd_type cmd)
-{
-	if (cmd >= NFTNL_CMD_MAX)
-		return "unknown";
-
-	return cmd2tag[cmd];
-}
-
-uint32_t nftnl_str2cmd(const char *cmd)
-{
-	if (strcmp(cmd, "add") == 0)
-		return NFTNL_CMD_ADD;
-	else if (strcmp(cmd, "insert") == 0)
-		return NFTNL_CMD_INSERT;
-	else if (strcmp(cmd, "delete") == 0)
-		return NFTNL_CMD_DELETE;
-	else if (strcmp(cmd, "replace") == 0)
-		return NFTNL_CMD_REPLACE;
-	else if (strcmp(cmd, "flush") == 0)
-		return NFTNL_CMD_FLUSH;
-
-	return NFTNL_CMD_UNSPEC;
-}
-
 int nftnl_fprintf(FILE *fp, const void *obj, uint32_t cmd, uint32_t type,
 		  uint32_t flags,
 		  int (*snprintf_cb)(char *buf, size_t bufsiz, const void *obj,
-- 
2.30.2

