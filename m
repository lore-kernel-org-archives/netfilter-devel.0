From: Arturo Borrero <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] src: xml: implement helper function nft_strtol
Date: Fri, 07 Jun 2013 20:55:41 +0200
Message-ID: <20130607185541.31817.95112.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46159 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757079Ab3FGSzu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:55:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a helper function to handle the XML validations.

The functions works this way:
 * input string (which contains the number)
 * base the number has (e.g. base 10 or 16)
 * pointer to where you want to store the conversed number.
 * datatype, to make additional validations like overflows.

Thus, to get a base 10 uint32_t number from a string:

 if (nft_strtol(string, 10, &number, NFT_STRTOL_U32) != 0)
	return -1

Also, I already have a patch that implements this functions all around the XML parsing code.

Of course, other approach are possibles.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 0 files changed

diff --git a/src/Makefile.am b/src/Makefile.am
index 8a61ce8..bfbcaf7 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -4,7 +4,8 @@ lib_LTLIBRARIES = libnftables.la
 libnftables_la_LIBADD = ${LIBMNL_LIBS}
 libnftables_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libnftables.map \
 			 -version-info $(LIBVERSION)
-libnftables_la_SOURCES = table.c		\
+libnftables_la_SOURCES = utils.c		\
+			 table.c		\
 			 chain.c		\
 			 rule.c			\
 			 set.c			\
diff --git a/src/internal.h b/src/internal.h
index 0c5de21..094b198 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -58,6 +58,22 @@ struct nft_set_elem {
 	uint32_t	flags;
 };
 
+/* utils */
+enum nft_strtol_type {
+	NFT_STRTOL_U8	= 0,
+	NFT_STRTOL_S8,
+	NFT_STRTOL_U16,
+	NFT_STRTOL_S16,
+	NFT_STRTOL_U32,
+	NFT_STRTOL_S32,
+	NFT_STRTOL_U64,
+	NFT_STRTOL_S64,
+	NFT_STRTOL_INT,
+	NFT_STRTOL_UINT,
+};
+
+int nft_strtol(const char *string, int base, void *number, enum nft_strtol_type type);
+
 #define SNPRINTF_BUFFER_SIZE(ret, size, len, offset)	\
 	size += ret;					\
 	if (ret > len)					\
diff --git a/src/utils.c b/src/utils.c
new file mode 100644
index 0000000..9037eec
--- /dev/null
+++ b/src/utils.c
@@ -0,0 +1,115 @@
+#include <internal.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <stdint.h>
+
+int nft_strtol(const char *string, int base, void *number,
+	       enum nft_strtol_type type)
+{
+	int64_t stmp = 0;
+	uint64_t utmp = -1;
+	char *endptr;
+	int is_signed;
+
+	switch (type) {
+	case NFT_STRTOL_U8:
+	case NFT_STRTOL_U16:
+	case NFT_STRTOL_U32:
+	case NFT_STRTOL_U64:
+	case NFT_STRTOL_UINT:
+		is_signed = 0;
+		break;
+	case NFT_STRTOL_S8:
+	case NFT_STRTOL_S16:
+	case NFT_STRTOL_S32:
+	case NFT_STRTOL_S64:
+	case NFT_STRTOL_INT:
+		is_signed = 1;
+		break;
+	default:
+		return -1;
+	}
+
+	if (is_signed == 1) {
+		stmp = strtoll(string, &endptr, base);
+	} else {
+		utmp = strtoull(string, &endptr, base);
+		if (utmp < 0)
+			return -1;
+	}
+
+	if (*endptr)
+		return -1;
+
+
+
+	/* check for each dest type overflow and send back the number*/
+	switch (type) {
+	case NFT_STRTOL_U8:
+		if (utmp > UINT8_MAX)
+			return -1;
+		uint8_t *retv_u8 = (uint8_t *)number;
+		*retv_u8 = (uint8_t)utmp;
+		break;
+	case NFT_STRTOL_S8:
+		if (stmp > INT8_MAX || stmp < INT8_MIN)
+			return -1;
+		int8_t *retv_s8 = (int8_t *)number;
+		*retv_s8 = (int8_t)stmp;
+		break;
+	case NFT_STRTOL_U16:
+		if (utmp > UINT16_MAX)
+			return -1;
+		uint16_t *retv_u16 = (uint16_t *)number;
+		*retv_u16 = (uint16_t)utmp;
+		break;
+	case NFT_STRTOL_S16:
+		if (stmp > INT16_MAX || stmp < INT16_MIN)
+			return -1;
+		int16_t *retv_s16 = (int16_t *)number;
+		*retv_s16 = (int16_t)stmp;
+		break;
+	case NFT_STRTOL_U32:
+		if (utmp > UINT32_MAX)
+			return -1;
+		uint32_t *retv_u32 = (uint32_t *)number;
+		*retv_u32 = (uint32_t)utmp;
+		break;
+	case NFT_STRTOL_S32:
+		if (stmp > INT32_MAX || stmp < INT32_MIN)
+			return -1;
+		int32_t *retv_s32 = (int32_t *)number;
+		*retv_s32 = (int32_t)stmp;
+		break;
+	case NFT_STRTOL_U64:
+		/* note: UINT64_MAX > ULLONG_MAX */
+		if (utmp == ULLONG_MAX)
+			return -1;
+		uint64_t *retv_u64 = (uint64_t *)number;
+		*retv_u64 = (uint64_t)utmp;
+		break;
+	case NFT_STRTOL_S64:
+		/* note: INT64_MAX > LLONG_MAX */
+		if (stmp == LLONG_MAX || stmp == LLONG_MIN)
+			return -1;
+		int64_t *retv_s64 = (int64_t *)number;
+		*retv_s64 = (int64_t)stmp;
+		break;
+	case NFT_STRTOL_UINT:
+		if (utmp > UINT_MAX)
+			return -1;
+		unsigned int *retv_ui = (unsigned int *)number;
+		*retv_ui = (unsigned int)utmp;
+		break;
+	case NFT_STRTOL_INT:
+		if (stmp > INT_MAX || stmp < INT_MIN)
+			return -1;
+		int *retv_si = (int *)number;
+		*retv_si = (int)stmp;
+		break;
+	default:
+		return -1;
+	}
+
+	return 0;
+}

