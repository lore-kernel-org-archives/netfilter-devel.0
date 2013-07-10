From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH v3 libnetfilter_acct 11/29] add variable width and on-the-fly formatting
Date: Wed, 10 Jul 2013 19:25:09 +0100
Message-ID: <1373480727-11254-12-git-send-email-michael.zintakis@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:57579 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3GJS0G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:26:06 -0400
Received: by mail-la0-f52.google.com with SMTP id fo12so6070550lab.11
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2013 11:26:05 -0700 (PDT)
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* add a separate nfacct_options struct with its get/set functions, allowing
userspace programs, like nfacct, to specify the width of the columns which
are to be printed, so that they are no longer hard-coded into the printing
template itself. This allows column width to be "adjusted", depending on the
value of each property;

* add a separate NFACCT_SNPRINTF_F_NUMONLY template, which prints the
numbers-only properties of the accounting objects (formatted - see below) -
useful to the nfnetlink callback function in order to determine the maximum
column width, which needs to be used to print each column.

* add a new nfacct_snprintf_with_options function enhancing the existing API
to enable "options" to be specified during printing properties of nfacct
objects.

* allow on-the-fly formatting, using over 14 different formats when printing
accounting objects. This formatting, if specified, applies to *all*
accounting objects.

Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 configure.ac                                  |   2 +-
 include/libnetfilter_acct/libnetfilter_acct.h |  75 ++++
 src/libnetfilter_acct.c                       | 512 ++++++++++++++++++++++++--
 src/libnetfilter_acct.map                     |  10 +
 4 files changed, 569 insertions(+), 30 deletions(-)

diff --git a/configure.ac b/configure.ac
index ad1bef8..e8f21e7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -29,7 +29,7 @@ esac
 regular_CPPFLAGS="-D_FILE_OFFSET_BITS=64 -D_REENTRANT"
 regular_CFLAGS="-Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wshadow -Wstrict-prototypes \
-	-Wformat=2 -pipe"
+	-Wformat=2 -Wno-format-nonliteral -pipe"
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([regular_CFLAGS])
 AC_CONFIG_FILES([Makefile src/Makefile include/Makefile include/libnetfilter_acct/Makefile include/linux/Makefile include/linux/netfilter/Makefile examples/Makefile libnetfilter_acct.pc doxygen.cfg])
diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index aec26d3..3328fdb 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -16,9 +16,62 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_BYTES,
 };
 
+struct nfacct_options;
+
+enum nfacct_option_type {
+	NFACCT_OPT_FMT = 0,	/* number format option 	*/
+	NFACCT_OPT_PCW,		/* packets count column width 	*/
+	NFACCT_OPT_BCW,		/* bytes count column width 	*/
+};
+
+enum nfacct_format {
+	NFACCT_FMT_DEFAULT=0,
+	NFACCT_FMT_NONE,
+	NFACCT_FMT_TRIPLETS,
+	NFACCT_FMT_IEC,
+	NFACCT_FMT_IEC_KIBIBYTE,
+	NFACCT_FMT_IEC_MEBIBYTE,
+	NFACCT_FMT_IEC_GIBIBYTE,
+	NFACCT_FMT_IEC_TEBIBYTE,
+	NFACCT_FMT_IEC_PEBIBYTE,
+	NFACCT_FMT_IEC_EXBIBYTE,
+	NFACCT_FMT_SI,
+	NFACCT_FMT_SI_KILOBYTE,
+	NFACCT_FMT_SI_MEGABYTE,
+	NFACCT_FMT_SI_GIGABYTE,
+	NFACCT_FMT_SI_TERABYTE,
+	NFACCT_FMT_SI_PETABYTE,
+	NFACCT_FMT_SI_EXABYTE,
+	NFACCT_FMT_MAX,
+};
+
+static const char *nfacct_fmt_keys[NFACCT_FMT_MAX + 1] = {
+	[NFACCT_FMT_DEFAULT] 		= "def",
+	[NFACCT_FMT_NONE] 		= "raw",
+	[NFACCT_FMT_TRIPLETS] 		= "3pl",
+	[NFACCT_FMT_IEC] 		= "iec",
+	[NFACCT_FMT_IEC_KIBIBYTE] 	= "kib",
+	[NFACCT_FMT_IEC_MEBIBYTE] 	= "mib",
+	[NFACCT_FMT_IEC_GIBIBYTE] 	= "gib",
+	[NFACCT_FMT_IEC_TEBIBYTE] 	= "tib",
+	[NFACCT_FMT_IEC_PEBIBYTE] 	= "pib",
+	[NFACCT_FMT_IEC_EXBIBYTE] 	= "eib",
+	[NFACCT_FMT_SI] 		= "si",
+	[NFACCT_FMT_SI_KILOBYTE] 	= "kb",
+	[NFACCT_FMT_SI_MEGABYTE] 	= "mb",
+	[NFACCT_FMT_SI_GIGABYTE] 	= "gb",
+	[NFACCT_FMT_SI_TERABYTE] 	= "tb",
+	[NFACCT_FMT_SI_PETABYTE] 	= "pb",
+	[NFACCT_FMT_SI_EXABYTE] 	= "eb",
+	[NFACCT_FMT_MAX] 		= "",
+};
+
 struct nfacct *nfacct_alloc(void);
 void nfacct_free(struct nfacct *nfacct);
 
+struct nfacct_options *nfacct_options_alloc(void);
+void nfacct_options_free(struct nfacct_options *options);
+
 void nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type, const void *data);
 void nfacct_attr_set_str(struct nfacct *nfacct, enum nfacct_attr_type type, const char *name);
 void nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type, uint64_t value);
@@ -28,6 +81,22 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type);
 const char *nfacct_attr_get_str(struct nfacct *nfacct, enum nfacct_attr_type type);
 uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type);
 
+void nfacct_option_set(struct nfacct_options *options,
+			enum nfacct_option_type type, const void *data);
+void nfacct_option_set_u16(struct nfacct_options *options,
+			enum nfacct_option_type type, uint16_t value);
+void nfacct_option_set_tsize(struct nfacct_options *options,
+			enum nfacct_option_type type, size_t value);
+void nfacct_option_unset(struct nfacct_options *options,
+			enum nfacct_option_type type);
+
+const void *nfacct_option_get(struct nfacct_options *options,
+			enum nfacct_option_type type);
+uint16_t nfacct_option_get_u16(struct nfacct_options *options,
+			enum nfacct_option_type type);
+size_t nfacct_option_get_tsize(struct nfacct_options *options,
+			enum nfacct_option_type type);
+
 void parse_nfacct_name(char *buf, const char *name);
 
 struct nlmsghdr;
@@ -45,10 +114,16 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 /* print only the bytes and name columns */
 #define NFACCT_SNPRINTF_F_BONLY		(1 << 3)
 
+/* print numbers only (formatted), useful for determining max column width */
+#define NFACCT_SNPRINTF_F_NUMONLY	(1 << 4)
+
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
 
 int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct, uint16_t type, uint16_t flags);
+int nfacct_snprintf_with_options(char *buf, size_t size, struct nfacct *nfacct,
+				uint16_t type, uint16_t flags,
+				struct nfacct_options *options);
 
 #ifdef __cplusplus
 } /* extern "C" */
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index 23f7616..440bc0b 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -13,6 +13,7 @@
 #include <endian.h>
 #include <stdlib.h>
 #include <string.h>
+#include <locale.h>
 #include <inttypes.h>
 
 #include <libmnl/libmnl.h>
@@ -63,6 +64,13 @@ struct nfacct {
 	uint32_t	bitset;
 };
 
+struct nfacct_options {
+	uint16_t	fmt;
+	size_t		pcw;
+	size_t		bcw;
+	uint32_t	bitset;
+};
+
 /**
  * \defgroup nfacct Accounting object handling
  * @{
@@ -91,6 +99,28 @@ void nfacct_free(struct nfacct *nfacct)
 EXPORT_SYMBOL(nfacct_free);
 
 /**
+ * nfacct_options_alloc - allocate a new accounting options object
+ *
+ * In case of success, this function returns a valid pointer, otherwise NULL
+ * s returned and errno is appropriately set.
+ */
+struct nfacct_options *nfacct_options_alloc(void)
+{
+	return calloc(1, sizeof(struct nfacct_options));
+}
+EXPORT_SYMBOL(nfacct_options_alloc);
+
+/**
+ * nfacct_options_free - release one accounting options object
+ * \param nfacct pointer to the accounting options object
+ */
+void nfacct_options_free(struct nfacct_options *options)
+{
+	free(options);
+}
+EXPORT_SYMBOL(nfacct_options_free);
+
+/**
  * nfacct_attr_set - set one attribute of the accounting object
  * \param nfacct pointer to the accounting object
  * \param type attribute type you want to set
@@ -228,18 +258,294 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 }
 EXPORT_SYMBOL(nfacct_attr_get_u64);
 
+/**
+ * nfacct_option_set - set one option of the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to set
+ * \param data pointer to data that will be used to set this option
+ */
+void
+nfacct_option_set(struct nfacct_options *options,
+		enum nfacct_option_type type,
+		const void *data)
+{
+	switch(type) {
+	case NFACCT_OPT_FMT:
+		options->fmt = *((uint16_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_FMT);
+		break;
+	case NFACCT_OPT_PCW:
+		options->pcw = *((size_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_PCW);
+		break;
+	case NFACCT_OPT_BCW:
+		options->bcw = *((size_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_BCW);
+		break;
+	}
+}
+EXPORT_SYMBOL(nfacct_option_set);
+
+/**
+ * nfacct_option_set_u16 - set one option in the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to set
+ * \param value unsigned 16-bit integer
+ */
+void
+nfacct_option_set_u16(struct nfacct_options *options,
+		      enum nfacct_option_type type,
+		      uint16_t value)
+{
+	nfacct_option_set(options, type, &value);
+}
+EXPORT_SYMBOL(nfacct_option_set_u16);
+
+/**
+ * nfacct_attr_set_tsize - set one options in the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to set
+ * \param value size_t (arch-dependent) integer
+ */
+void
+nfacct_option_set_tsize(struct nfacct_options *options,
+			enum nfacct_option_type type,
+			size_t value)
+{
+	nfacct_option_set(options, type, &value);
+}
+EXPORT_SYMBOL(nfacct_option_set_tsize);
+
+/**
+ * nfacct_option_unset - unset one option in the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to unset
+ */
+void
+nfacct_option_unset(struct nfacct_options *options,
+		    enum nfacct_option_type type)
+{
+	switch(type) {
+	case NFACCT_OPT_FMT:
+		options->bitset &= ~(1 << NFACCT_OPT_FMT);
+		break;
+	case NFACCT_OPT_PCW:
+		options->bitset &= ~(1 << NFACCT_OPT_PCW);
+		break;
+	case NFACCT_OPT_BCW:
+		options->bitset &= ~(1 << NFACCT_OPT_BCW);
+		break;
+	}
+}
+EXPORT_SYMBOL(nfacct_option_unset);
+
+/**
+ * nfacct_option_get - get one option from the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to get
+ *
+ * This function returns a valid pointer to the option data. If a
+ * unsupported option is used, this returns NULL.
+ */
+const void *nfacct_option_get(struct nfacct_options *options,
+			      enum nfacct_option_type type)
+{
+	const void *ret = NULL;
+
+	switch(type) {
+	case NFACCT_OPT_FMT:
+		if (options->bitset & (1 << NFACCT_OPT_FMT))
+			ret = &options->fmt;
+		break;
+	case NFACCT_OPT_PCW:
+		if (options->bitset & (1 << NFACCT_OPT_PCW))
+			ret = &options->pcw;
+		break;
+	case NFACCT_OPT_BCW:
+		if (options->bitset & (1 << NFACCT_OPT_BCW))
+			ret = &options->bcw;
+		break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(nfacct_option_get);
+
+/**
+ * nfacct_option_get_u16 - get one option from the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to get
+ *
+ * This function returns a unsigned 16-bits integer. If the option is
+ * unsupported, this returns NULL.
+ */
+uint16_t nfacct_option_get_u16(struct nfacct_options *options,
+				enum nfacct_option_type type)
+{
+	const void *ret = nfacct_option_get(options, type);
+	return ret ? *((uint16_t *)ret) : 0;
+}
+EXPORT_SYMBOL(nfacct_option_get_u16);
+
+/**
+ * nfacct_attr_get_tsize - get one option from the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to get
+ *
+ * This function returns a size_t (arch-dependent) integer. If the option is
+ * unsupported, this returns NULL.
+ */
+size_t nfacct_option_get_tsize(struct nfacct_options *options,
+				enum nfacct_option_type type)
+{
+	const void *ret = nfacct_option_get(options, type);
+	return ret ? *((size_t *)ret) : 0;
+}
+EXPORT_SYMBOL(nfacct_option_get_tsize);
+
+#define KiB ((uint64_t)   1 << 10)
+#define MiB ((uint64_t) KiB << 10)
+#define GiB ((uint64_t) MiB << 10)
+#define TiB ((uint64_t) GiB << 10)
+#define PiB ((uint64_t) TiB << 10)
+#define EiB ((uint64_t) PiB << 10)
+#define KB ((uint64_t)  1*1000)
+#define MB ((uint64_t) KB*1000)
+#define GB ((uint64_t) MB*1000)
+#define TB ((uint64_t) GB*1000)
+#define PB ((uint64_t) TB*1000)
+#define EB ((uint64_t) PB*1000)
+
+#define NFACCT_STR_PLAIN_NUMONLY	"%s %s"
 #define NFACCT_STR_PLAIN_SAVE_BASE	"name=%s pkts=%"PRIu64 \
 					" bytes=%"PRIu64
-#define NFACCT_STR_PLAIN		"{ pkts = %.20"PRIu64", " \
-					"bytes = %.20"PRIu64" } = %s"
-#define NFACCT_STR_PLAIN_BONLY		"{ bytes = %.20"PRIu64 " } = %s"
+#define NFACCT_STR_PLAIN_NEW		"[ pkts = %%%zus" \
+					" bytes = %%%zus ] = %%s"
+#define NFACCT_STR_PLAIN		"{ pkts = %%%zus, " \
+					"bytes = %%%zus } = %%s;"
+#define NFACCT_STR_PLAIN_BONLY		"[ bytes = %%%zus ] = %%s"
 #define NFACCT_XML_NAME			"<name>%s</name>"
-#define NFACCT_XML_PKTS			"<pkts>%.20"PRIu64"</pkts>"
-#define NFACCT_XML_BYTES		"<bytes>%.20"PRIu64"</bytes>"
+#define NFACCT_XML_PKTS			"<pkts fmt=\"%s\">%s</pkts>"
+#define NFACCT_XML_BYTES		"<bytes fmt=\"%s\">%s</bytes>"
 #define NFACCT_STR_XML_BONLY		"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_BYTES
+#define NFACCT_STR_XML_COMPAT		"<obj><name>%s</name>"	\
+					"<pkts>%s</pkts>"	\
+					"<bytes>%s</bytes>"
 #define NFACCT_STR_XML			"<obj>"	NFACCT_XML_NAME \
 					NFACCT_XML_PKTS NFACCT_XML_BYTES
+#define NFACCT_STR_DEFAULT		"%020.0f%s"
+#define NFACCT_STR_NONE			"%.0f%s"
+#define NFACCT_STR_TRIPLETS		"%'.0f%s"
+#define NFACCT_STR_SI_IEC		"%'.3f%s"
+
+#define NFACCT_NUM_DEFAULT		{ .value = 0., .str = "" }
+
+struct nfacct_number {
+	float value;
+	char str[30];
+};
+
+struct nfacct_num {
+	uint64_t num;
+	char name[4];
+};
+
+static struct nfacct_num nfacct_num_keys[] = {
+	[NFACCT_FMT_DEFAULT] 		= { .num = 1, .name = "" },
+	[NFACCT_FMT_NONE] 		= { .num = 1, .name = "" },
+	[NFACCT_FMT_TRIPLETS] 		= { .num = 1, .name = "" },
+	[NFACCT_FMT_IEC] 		= { .num = 1, .name = "" },
+	[NFACCT_FMT_IEC_KIBIBYTE] 	= { .num = KiB,	.name = "KiB" },
+	[NFACCT_FMT_IEC_MEBIBYTE] 	= { .num = MiB,	.name = "MiB" },
+	[NFACCT_FMT_IEC_GIBIBYTE] 	= { .num = GiB,	.name = "GiB" },
+	[NFACCT_FMT_IEC_TEBIBYTE] 	= { .num = TiB,	.name = "TiB" },
+	[NFACCT_FMT_IEC_PEBIBYTE] 	= { .num = PiB,	.name = "PiB" },
+	[NFACCT_FMT_IEC_EXBIBYTE] 	= { .num = EiB,	.name = "EiB" },
+	[NFACCT_FMT_SI] 		= { .num = 1, .name = "" },
+	[NFACCT_FMT_SI_KILOBYTE] 	= { .num = KB, .name = "KB" },
+	[NFACCT_FMT_SI_MEGABYTE] 	= { .num = MB, .name = "MB" },
+	[NFACCT_FMT_SI_GIGABYTE] 	= { .num = GB, .name = "GB" },
+	[NFACCT_FMT_SI_TERABYTE] 	= { .num = TB, .name = "TB" },
+	[NFACCT_FMT_SI_PETABYTE] 	= { .num = PB, .name = "PB" },
+	[NFACCT_FMT_SI_EXABYTE] 	= { .num = EB, .name = "EB" },
+};
+
+#define NFACCT_SET_RET(x)	nf->value /= nfacct_num_keys[x].num; \
+				name = nfacct_num_keys[x].name;
+#define NFACCT_SET_STR_FMT(x) 	NFACCT_STR_##x
+#define NFACCT_GET_FMT(x)	nfacct_fmt_keys[x]
+#define NFACCT_SET_RET_FMT(x)	snprintf(nf->str,sizeof(nf->str), \
+				NFACCT_SET_STR_FMT(x),nf->value, name)
+
+static void
+format_number(struct nfacct_number *nf, const uint64_t val,
+		const enum nfacct_format fmt)
+{
+	nf->value = (float) val;
+	char *name = "";
+	switch (fmt) {	
+	case NFACCT_FMT_IEC:
+		if (nf->value >= EiB) {
+			NFACCT_SET_RET(NFACCT_FMT_IEC_EXBIBYTE);
+	        } else if (nf->value >= PiB) {
+			NFACCT_SET_RET(NFACCT_FMT_IEC_PEBIBYTE);
+	        } else if (nf->value >= TiB) {
+			NFACCT_SET_RET(NFACCT_FMT_IEC_TEBIBYTE);
+	        } else if (nf->value >= GiB) {
+			NFACCT_SET_RET(NFACCT_FMT_IEC_GIBIBYTE);
+	        } else if (nf->value >= MiB) {
+			NFACCT_SET_RET(NFACCT_FMT_IEC_MEBIBYTE);
+	        } else if (nf->value >= KiB) {
+			NFACCT_SET_RET(NFACCT_FMT_IEC_KIBIBYTE);
+		}
+		NFACCT_SET_RET_FMT(SI_IEC);
+		break;
+	case NFACCT_FMT_SI:
+		if (nf->value >= EB) {
+			NFACCT_SET_RET(NFACCT_FMT_SI_EXABYTE);
+	        } else if (nf->value >= PB) {
+			NFACCT_SET_RET(NFACCT_FMT_SI_PETABYTE);
+	        } else if (nf->value >= TB) {
+			NFACCT_SET_RET(NFACCT_FMT_SI_TERABYTE);
+	        } else if (nf->value >= GB) {
+			NFACCT_SET_RET(NFACCT_FMT_SI_GIGABYTE);
+	        } else if (nf->value >= MB) {
+			NFACCT_SET_RET(NFACCT_FMT_SI_MEGABYTE);
+	        } else if (nf->value >= KB) {
+			NFACCT_SET_RET(NFACCT_FMT_SI_KILOBYTE);
+		}
+		NFACCT_SET_RET_FMT(SI_IEC);
+		break;
+	case NFACCT_FMT_IEC_EXBIBYTE:
+	case NFACCT_FMT_IEC_PEBIBYTE:
+	case NFACCT_FMT_IEC_TEBIBYTE:
+	case NFACCT_FMT_IEC_GIBIBYTE:
+	case NFACCT_FMT_IEC_MEBIBYTE:
+	case NFACCT_FMT_IEC_KIBIBYTE:
+	case NFACCT_FMT_SI_EXABYTE:
+	case NFACCT_FMT_SI_PETABYTE:
+	case NFACCT_FMT_SI_TERABYTE:
+	case NFACCT_FMT_SI_GIGABYTE:
+	case NFACCT_FMT_SI_MEGABYTE:
+	case NFACCT_FMT_SI_KILOBYTE:
+		NFACCT_SET_RET(fmt);
+		NFACCT_SET_RET_FMT(SI_IEC);
+		break;
+	case NFACCT_FMT_DEFAULT:
+		NFACCT_SET_RET(NFACCT_FMT_DEFAULT);
+		NFACCT_SET_RET_FMT(DEFAULT);
+		break;
+	case NFACCT_FMT_NONE:
+		NFACCT_SET_RET(NFACCT_FMT_NONE);
+		NFACCT_SET_RET_FMT(NONE);
+		break;
+	case NFACCT_FMT_TRIPLETS:
+		NFACCT_SET_RET(NFACCT_FMT_TRIPLETS);
+		NFACCT_SET_RET_FMT(TRIPLETS);
+	default:
+		break;
+	}
+}
 
 void
 parse_nfacct_name(char *buf, const char *name)
@@ -324,34 +630,130 @@ void parse_nfacct_name_xml(char *buf, const char *name)
 	}
 }
 
+#define NFACCT_DEFAULT_LOCALE "en_GB"
+
+static void init_locale(void) {
+	char *lang;
+	char *env = "LANG";
+	lang = getenv(env);
+	setlocale(LC_ALL,(lang == NULL ? NFACCT_DEFAULT_LOCALE : lang));
+}
+
+/* fmt field bit definitions */
+#define _nfacct_offset_fmt	0
+#define _nfacct_offset_bytes	_nfacct_offset_fmt
+#define _nfacct_offset_pkts	8
+#define _nfacct_bitsize_fmt	0xffff
+#define _nfacct_bitsize_bytes	0xff
+#define _nfacct_bitsize_pkts	_nfacct_bitsize_bytes
+
+/* internal fmt help functions */
+#define _nfacct_get_mask(x)	((uint16_t)_nfacct_bitsize_##x \
+				<< _nfacct_offset_##x)
+#define _nfacct_get_value(x,f)	(((uint16_t)x & \
+				_nfacct_get_mask(f)) >> _nfacct_offset_##f)
+
+/* fmt help functions */
+#define nfacct_get_fmt(x)		_nfacct_get_value(x,fmt)
+#define nfacct_get_bytes_fmt(x)		_nfacct_get_value(x,bytes)
+#define nfacct_get_pkt_fmt(x)		_nfacct_get_value(x,pkts)
+
 static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
-		      uint16_t flags)
+		      uint16_t flags, struct nfacct_options *options)
 {
-	int ret;
+	int ret = 0;
+	bool compat = (options == NULL);
+	uint16_t fmt;
+	uint64_t pkts = 0, bytes = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 2 + 4];
+	char fmt_str[sizeof(NFACCT_STR_PLAIN_NEW) +
+		     sizeof(NFACCT_STR_DEFAULT) * 5 + 10];
+	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
+			     bn = NFACCT_NUM_DEFAULT;
 
-	parse_nfacct_name(nfacct_name,
-			  nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
 		/* default: print pkts + bytes + name */
-		ret = snprintf(buf, rem, NFACCT_STR_PLAIN,
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			nfacct_name);
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		parse_nfacct_name(nfacct_name,
+				  nfacct_attr_get_str(nfacct,
+						      NFACCT_ATTR_NAME));
+
+		if (compat) {
+			fmt = NFACCT_FMT_MAX;
+			snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN,
+				 (size_t)0, (size_t)0);
+		} else {
+			fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
+			snprintf(fmt_str, sizeof(fmt_str),
+				NFACCT_STR_PLAIN_NEW,
+				 nfacct_option_get_tsize(options,
+							 NFACCT_OPT_PCW),
+				 nfacct_option_get_tsize(options,
+							 NFACCT_OPT_BCW));
+		}
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = NFACCT_FMT_DEFAULT;
+
+		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, nfacct_get_pkt_fmt(fmt));
+		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
+
+		ret = snprintf(buf, rem, fmt_str, pn.str, bn.str,
+				nfacct_name);
 	} else if (flags & NFACCT_SNPRINTF_F_SAVE) {
 		/* save: format useful for 'restore' */
+		parse_nfacct_name(nfacct_name,
+				  nfacct_attr_get_str(nfacct,
+						      NFACCT_ATTR_NAME));
 		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_SAVE_BASE,
 			       nfacct_name,
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_PKTS),
 			       nfacct_attr_get_u64(nfacct,NFACCT_ATTR_BYTES));
 	} else if (flags & NFACCT_SNPRINTF_F_BONLY) {
 		/* print bytes + name only */
-		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_BONLY,
-				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-				nfacct_name);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,
+						    NFACCT_ATTR_NAME));
+		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = NFACCT_FMT_DEFAULT;
+
+		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
+			init_locale();
+
+		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
+		snprintf(fmt_str, sizeof(fmt_str), NFACCT_STR_PLAIN_BONLY,
+			 nfacct_option_get_tsize(options,NFACCT_OPT_BCW));
+		ret = snprintf(buf, rem, fmt_str, bn.str, nfacct_name);
+	} else if (flags & NFACCT_SNPRINTF_F_NUMONLY) {
+		/* numbers only: to determine the maximum column width */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = NFACCT_FMT_DEFAULT;
+
+		if (nfacct_get_fmt(fmt) > NFACCT_FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, nfacct_get_pkt_fmt(fmt));
+		format_number(&bn, bytes, nfacct_get_bytes_fmt(fmt));
+
+		ret = snprintf(buf, rem, NFACCT_STR_PLAIN_NUMONLY,
+				pn.str, bn.str);
 	} else {
 		/* print out name only */
+		parse_nfacct_name(nfacct_name,
+				  nfacct_attr_get_str(nfacct,
+						      NFACCT_ATTR_NAME));
 		ret = snprintf(buf, rem, "%s\n", nfacct_name);
 	}
 
@@ -398,28 +800,58 @@ nfacct_snprintf_xml_localtime(char *buf, unsigned int rem, const struct tm *tm)
 
 static int
 nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
-		    uint16_t flags)
+		    uint16_t flags, struct nfacct_options *options)
 {
 	int ret = 0;
+	bool compat = (options == NULL);
 	unsigned int size = 0, offset = 0;
+	uint16_t fmt;
+	uint64_t pkts = 0, bytes = 0;
 	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];
+	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
+			     bn = NFACCT_NUM_DEFAULT;
 
 	parse_nfacct_name_xml(nfacct_name,
 				nfacct_attr_get_str(nfacct,
 						    NFACCT_ATTR_NAME));
+	if (compat) {
+		fmt = NFACCT_FMT_MAX;
+	} else {
+		fmt = nfacct_option_get_u16(options, NFACCT_OPT_FMT);
+	}
 	if (flags & NFACCT_SNPRINTF_F_BONLY) {
 		/* print name + bytes only */
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = NFACCT_FMT_DEFAULT;
+
+		format_number(&bn, bytes, NFACCT_FMT_NONE);
 		ret = snprintf(buf, rem, NFACCT_STR_XML_BONLY, nfacct_name,
-				nfacct_attr_get_u64(nfacct,
-						    NFACCT_ATTR_BYTES));
+				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				bn.str);
 		BUFFER_SIZE(ret, size, rem, offset);
 	} else {
 		/* default/everything else: print name + pkts + bytes */
-		ret = snprintf(buf, rem, NFACCT_STR_XML, nfacct_name,
-				nfacct_attr_get_u64(nfacct,
-						    NFACCT_ATTR_BYTES),
-				nfacct_attr_get_u64(nfacct,
-						    NFACCT_ATTR_PKTS));
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+
+		if (fmt == NFACCT_FMT_MAX)
+			fmt = NFACCT_FMT_DEFAULT;
+
+		format_number(&pn, pkts, NFACCT_FMT_NONE);
+		format_number(&bn, bytes, NFACCT_FMT_NONE);
+
+		if (compat) {
+			ret = snprintf(buf, rem, NFACCT_STR_XML_COMPAT,
+					nfacct_name, pn.str, bn.str);
+		} else {
+			ret = snprintf(buf, rem, NFACCT_STR_XML, nfacct_name,
+				NFACCT_GET_FMT(nfacct_get_pkt_fmt(fmt)),
+				pn.str,
+				NFACCT_GET_FMT(nfacct_get_bytes_fmt(fmt)),
+				bn.str);
+		}
 		BUFFER_SIZE(ret, size, rem, offset);
 	}
 
@@ -443,27 +875,30 @@ err:
 }
 
 /**
- * nfacct_snprintf - print accounting object into one buffer
+ * nfacct_snprintf_with_options - print accounting object into one buffer
  * \param buf: pointer to buffer that is used to print the object
  * \param size: size of the buffer (or remaining room in it).
  * \param nfacct: pointer to a valid accounting object.
  * \param type: format output type, NFACCT_SNPRINTF_T_[PLAIN|XML]
  * \param flags: output flags (NFACCT_SNPRINTF_F_FULL).
+ * \param options: nfacct options structure.
  *
  * This function returns -1 in case that some mandatory attributes are
  * missing. On sucess, it returns 0.
  */
-int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
-		    uint16_t type, uint16_t flags)
+int nfacct_snprintf_with_options(char *buf, size_t size,
+				struct nfacct *nfacct,
+				uint16_t type, uint16_t flags,
+				struct nfacct_options *options)
 {
 	int ret = 0;
 
 	switch(type) {
 	case NFACCT_SNPRINTF_T_PLAIN:
-		ret = nfacct_snprintf_plain(buf, size, nfacct, flags);
+		ret = nfacct_snprintf_plain(buf,size,nfacct,flags,options);
 		break;
 	case NFACCT_SNPRINTF_T_XML:
-		ret = nfacct_snprintf_xml(buf, size, nfacct, flags);
+		ret = nfacct_snprintf_xml(buf,size,nfacct,flags,options);
 		break;
 	default:
 		ret = -1;
@@ -471,6 +906,25 @@ int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
 	}
 	return ret;
 }
+EXPORT_SYMBOL(nfacct_snprintf_with_options);
+
+/**
+ * nfacct_snprintf - print accounting object into one buffer
+ * \param buf: pointer to buffer that is used to print the object
+ * \param size: size of the buffer (or remaining room in it).
+ * \param nfacct: pointer to a valid accounting object.
+ * \param type: format output type, NFACCT_SNPRINTF_T_[PLAIN|XML]
+ * \param flags: output flags (NFACCT_SNPRINTF_F_FULL).
+ *
+ * This function returns -1 in case that some mandatory attributes are
+ * missing. On sucess, it returns 0.
+ */
+int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
+		    uint16_t type, uint16_t flags)
+{
+	return nfacct_snprintf_with_options(buf, size, nfacct,
+					    type, flags, NULL);
+}
 EXPORT_SYMBOL(nfacct_snprintf);
 
 /**
diff --git a/src/libnetfilter_acct.map b/src/libnetfilter_acct.map
index f12bc8e..ded60a9 100644
--- a/src/libnetfilter_acct.map
+++ b/src/libnetfilter_acct.map
@@ -21,5 +21,15 @@ local: *;
 
 LIBNETFILTER_ACCT_1.1 {
   nfacct_snprintf;
+  nfacct_options_alloc;
+  nfacct_options_free;
+  nfacct_option_set;
+  nfacct_option_set_u16;
+  nfacct_option_set_tsize;
+  nfacct_option_unset;
+  nfacct_option_get;
+  nfacct_option_get_u16;
+  nfacct_option_get_tsize;
   parse_nfacct_name;
+  nfacct_snprintf_with_options;
 } LIBNETFILTER_ACCT_1.0;
-- 
1.8.3.1

