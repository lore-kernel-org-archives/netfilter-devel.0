From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH 2/3 libnetfilter_acct] numerous changes and improvements in
 the user space library
Date: Sat, 23 Mar 2013 12:17:43 +0000
Message-ID: <514D9D67.8000802@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:43450 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWMSH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:18:07 -0400
Received: by mail-la0-f51.google.com with SMTP id fo13so8678056lab.24
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2013 05:18:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following is the second patch in a series of 3 patches, dealing with the
libnetfilter_acct user space library changes as following:

* added over 15 possible format options for number formatting.

* added a new nfacct_snprintf_with_options function, allowing customized
  options to be specified, including column width and format to be used.

* added a variety of new interface functions to get/set nfacct option
  properties.

* added 4 new nfacct_snprintf formats:
  - SAVE: for printing in a format suitable for 'restore';
  - BONLY: for printing only the 'bytes' and 'name' columns of accounting
    objects when list/get commands are specified;
  - EXTENDED: for printing all properties of accounting objects; and
  - NUMONLY: for printing "numbers-only" (formatted) of accounting objects,
    which is useful for determining the maximum column width of all
    accounting objects to be used when printed with the 'list' command.

* the output template format for the 'list' command has been changed slightly
  to accommodate new output (plain), which I think is better than the old one.

* backwards compatibility with the old (not updated) version of nfacct
  (executable) has been re-established.

* all accounting object names are now properly encoded and displayed with
  the 'list' and 'get' commands - this was one flaw with the current
  implementation which has now been corrected. It allowed account names
  which were not properly encoded (and containing '<' or '&' for example)
  to be displayed unencoded when xml output was selected. This was certain
  to brake xml parsers which were about to use this output as it did not
  conform to the xml specification.

* all plain-text output for each column (packets, bytes, byte threshold)
  can now be formatted, according to the maximum width used by all
  accounting objects. This wasn't possible before, which caused all values
  to be shown as zero-leading, fixed-width numbers, and that made reading
  very uncomfortable and difficult. With the new snprintf function, it is
  now possible to determine the width which needs to be used for each
  column and show the accounting object numbers properly aligned.

Signed-off-by: George Ivanov <gogo@xp1.wyse.network>
Signed-off-by: Michael Zintakis <michael.zintakis@googlemail.com>
---
 include/libnetfilter_acct/libnetfilter_acct.h |   55 ++
 include/linux/netfilter/nfnetlink_acct.h      |    2 +
 src/libnetfilter_acct.c                       |  763 ++++++++++++++++++++++++-
 src/libnetfilter_acct.map                     |   13 +
 4 files changed, 812 insertions(+), 21 deletions(-)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index 18f90c4..5df56d9 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -11,19 +11,67 @@ enum nfacct_attr_type {
 	NFACCT_ATTR_NAME = 0,
 	NFACCT_ATTR_PKTS,
 	NFACCT_ATTR_BYTES,
+	NFACCT_ATTR_BTHR,
+	NFACCT_ATTR_FMT,
+};
+
+struct nfacct_options;
+
+enum nfacct_option_type {
+	NFACCT_OPT_FMT = 0,
+	NFACCT_OPT_PCW,
+	NFACCT_OPT_BCW,
+	NFACCT_OPT_BTCW,
+};
+
+enum nfacct_format {
+	FMT_DEFAULT=0,
+	FMT_NONE,
+	FMT_TRIPLETS,
+	FMT_IEC,
+	FMT_IEC_KIBIBYTE,
+	FMT_IEC_MEBIBYTE,
+	FMT_IEC_GIBIBYTE,
+	FMT_IEC_TEBIBYTE,
+	FMT_IEC_PEBIBYTE,
+	FMT_IEC_EXBIBYTE,
+	FMT_SI,
+	FMT_SI_KILOBYTE,
+	FMT_SI_MEGABYTE,
+	FMT_SI_GIGABYTE,
+	FMT_SI_TERABYTE,
+	FMT_SI_PETABYTE,
+	FMT_SI_EXABYTE,
+	FMT_MAX,
 };
 
 struct nfacct *nfacct_alloc(void);
 void nfacct_free(struct nfacct *nfacct);
 
+struct nfacct_options *nfacct_options_alloc(void);
+void nfacct_options_free(struct nfacct_options *options);
+
 void nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type, const void *data);
 void nfacct_attr_set_str(struct nfacct *nfacct, enum nfacct_attr_type type, const char *name);
 void nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type, uint64_t value);
+void nfacct_attr_set_u32(struct nfacct *nfacct, enum nfacct_attr_type type, uint32_t value);
 void nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type);
 
 const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type);
 const char *nfacct_attr_get_str(struct nfacct *nfacct, enum nfacct_attr_type type);
 uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type);
+uint32_t nfacct_attr_get_u32(struct nfacct *nfacct, enum nfacct_attr_type type);
+
+void nfacct_option_set(struct nfacct_options *options, enum nfacct_option_type type, const void *data);
+void nfacct_option_set_u32(struct nfacct_options *options, enum nfacct_option_type type, uint32_t value);
+void nfacct_option_set_tsize(struct nfacct_options *options, enum nfacct_option_type type, size_t value);
+void nfacct_option_unset(struct nfacct_options *options, enum nfacct_option_type type);
+
+const void *nfacct_option_get(struct nfacct_options *options, enum nfacct_option_type type);
+uint32_t nfacct_option_get_u32(struct nfacct_options *options, enum nfacct_option_type type);
+size_t nfacct_option_get_tsize(struct nfacct_options *options, enum nfacct_option_type type);
+
+void parse_nfacct_name(char *buf, const char *name);
 
 struct nlmsghdr;
 
@@ -33,10 +81,17 @@ int nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct
 
 #define NFACCT_SNPRINTF_F_FULL		(1 << 0)
 #define NFACCT_SNPRINTF_F_TIME		(1 << 1)
+#define NFACCT_SNPRINTF_F_NUMONLY	(1 << 2) /* print "numbers-only" (formatted),
+						    useful for determining max column width   */
+#define NFACCT_SNPRINTF_F_BONLY		(1 << 3) /* print only the "bytes" and "name" columns */
+#define NFACCT_SNPRINTF_F_EXTENDED	(1 << 4) /* print packets, bytes, threshold and names */
+#define NFACCT_SNPRINTF_F_SAVE		(1 << 5) /* print in a format suitable for 'restore'  */
 
 #define NFACCT_SNPRINTF_T_PLAIN 0
 #define NFACCT_SNPRINTF_T_XML 1
 
 int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct, uint16_t type, uint16_t flags);
+int nfacct_snprintf_with_options(char *buf, size_t size, struct nfacct *nfacct,
+				uint16_t type, uint16_t flags, struct nfacct_options *options);
 
 #endif
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index c7b6269..f07e825 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -18,6 +18,8 @@ enum nfnl_acct_type {
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
+	NFACCT_BTHR,
+	NFACCT_FMT,
 	NFACCT_USE,
 	__NFACCT_MAX
 };
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index ba89e2d..b948de3 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -13,6 +13,7 @@
 #include <endian.h>
 #include <stdlib.h>
 #include <string.h>
+#include <locale.h>
 #include <inttypes.h>
 
 #include <libmnl/libmnl.h>
@@ -60,6 +61,21 @@ struct nfacct {
 	char		name[NFACCT_NAME_MAX];
 	uint64_t	pkts;
 	uint64_t	bytes;
+	uint64_t	bthr;
+	/*
+	 * Structure of fmt:
+	 * <- reserved: 16 bits ->
+	 * <- packets format: 8 bits-><-bytes format: 8 bits ->
+	 */
+	uint32_t	fmt;
+	uint32_t	bitset;
+};
+
+struct nfacct_options {
+	uint32_t	fmt;
+	size_t		pcw;
+	size_t		bcw;
+	size_t		btcw;
 	uint32_t	bitset;
 };
 
@@ -91,6 +107,28 @@ void nfacct_free(struct nfacct *nfacct)
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
@@ -114,6 +152,14 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_BTHR:
+		nfacct->bthr = *((uint64_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_BTHR);
+		break;
+	case NFACCT_ATTR_FMT:
+		nfacct->fmt = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_FMT);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -147,6 +193,20 @@ nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type,
 EXPORT_SYMBOL(nfacct_attr_set_u64);
 
 /**
+ * nfacct_attr_set_u32 - set one attribute the accounting object
+ * \param nfacct pointer to the accounting object
+ * \param type attribute type you want to set
+ * \param value unsigned 32-bit integer
+ */
+void
+nfacct_attr_set_u32(struct nfacct *nfacct, enum nfacct_attr_type type,
+		    uint32_t value)
+{
+	nfacct_attr_set(nfacct, type, &value);
+}
+EXPORT_SYMBOL(nfacct_attr_set_u32);
+
+/**
  * nfacct_attr_unset - unset one attribute the accounting object
  * \param nfacct pointer to the accounting object
  * \param type attribute type you want to set
@@ -164,6 +224,12 @@ nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 	case NFACCT_ATTR_BYTES:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_BTHR:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_BTHR);
+		break;
+	case NFACCT_ATTR_FMT:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_FMT);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_unset);
@@ -193,6 +259,14 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 		if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 			ret = &nfacct->bytes;
 		break;
+	case NFACCT_ATTR_BTHR:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_BTHR))
+			ret = &nfacct->bthr;
+		break;
+	case NFACCT_ATTR_FMT:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
+			ret = &nfacct->fmt;
+		break;
 	}
 	return ret;
 }
@@ -228,21 +302,559 @@ uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 }
 EXPORT_SYMBOL(nfacct_attr_get_u64);
 
+/**
+ * nfacct_attr_get_u32 - get one attribute the accounting object
+ * \param nfacct pointer to the accounting object
+ * \param type attribute type you want to get
+ *
+ * This function returns a unsigned 32-bits integer. If the attribute is
+ * unsupported, this returns NULL.
+ */
+uint32_t nfacct_attr_get_u32(struct nfacct *nfacct, enum nfacct_attr_type type)
+{
+	const void *ret = nfacct_attr_get(nfacct, type);
+	return ret ? *((uint32_t *)ret) : 0;
+}
+EXPORT_SYMBOL(nfacct_attr_get_u32);
+
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
+		options->fmt = *((uint32_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_FMT);
+		break;
+	case NFACCT_OPT_PCW:
+		options->pcw = *((uint32_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_PCW);
+		break;
+	case NFACCT_OPT_BCW:
+		options->bcw = *((uint32_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_BCW);
+		break;
+	case NFACCT_OPT_BTCW:
+		options->btcw = *((uint32_t *) data);
+		options->bitset |= (1 << NFACCT_OPT_BTCW);
+		break;
+	}
+}
+EXPORT_SYMBOL(nfacct_option_set);
+
+/**
+ * nfacct_option_set_u32 - set one option in the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to set
+ * \param value unsigned 32-bit integer
+ */
+void
+nfacct_option_set_u32(struct nfacct_options *options,
+		      enum nfacct_option_type type,
+		      uint32_t value)
+{
+	nfacct_option_set(options, type, &value);
+}
+EXPORT_SYMBOL(nfacct_option_set_u32);
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
+	case NFACCT_OPT_BTCW:
+		options->bitset &= ~(1 << NFACCT_OPT_BTCW);
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
+	case NFACCT_OPT_BTCW:
+		if (options->bitset & (1 << NFACCT_OPT_BTCW))
+			ret = &options->btcw;
+		break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(nfacct_option_get);
+
+/**
+ * nfacct_option_get_u32 - get one option from the accounting options object
+ * \param options pointer to the accounting options object
+ * \param type option type you want to get
+ *
+ * This function returns a unsigned 32-bits integer. If the option is
+ * unsupported, this returns NULL.
+ */
+uint32_t nfacct_option_get_u32(struct nfacct_options *options,
+				enum nfacct_option_type type)
+{
+	const void *ret = nfacct_option_get(options, type);
+	return ret ? *((uint32_t *)ret) : 0;
+}
+EXPORT_SYMBOL(nfacct_option_get_u32);
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
+#define KiB ((unsigned long long)   1 << 10)
+#define MiB ((unsigned long long) KiB << 10)
+#define GiB ((unsigned long long) MiB << 10)
+#define TiB ((unsigned long long) GiB << 10)
+#define PiB ((unsigned long long) TiB << 10)
+#define EiB ((unsigned long long) PiB << 10)
+#define KB ((unsigned long long)  1*1000)
+#define MB ((unsigned long long) KB*1000)
+#define GB ((unsigned long long) MB*1000)
+#define TB ((unsigned long long) GB*1000)
+#define PB ((unsigned long long) TB*1000)
+#define EB ((unsigned long long) PB*1000)
+
+#define STR_FMT_PLAIN_NUMONLY	"%s %s %s"
+#define STR_FMT_PLAIN_SAVE	"%s %s,%s %"PRIu64" %"PRIu64" %"PRIu64
+#define STR_FMT_PLAIN_EXTENDED	"[ pkts = %%%zus  bytes = %%%zus%s" \
+				" thr = %%%zus ] = %%s"
+#define STR_FMT_PLAIN_BONLY	"[ bytes = %%%zus%s ] = %%s"
+#define STR_FMT_PLAIN_NEW	"[ pkts = %%%zus  bytes = %%%zus%s ] = %%s"
+#define STR_FMT_PLAIN		"{ pkts = %%%zus, bytes = %%%zus%s } = %%s;"
+#define STR_FMT_XML_BONLY	"<obj><name>%s</name>"	\
+				"<bytes>%s%s</bytes>"
+#define STR_FMT_XML		"<obj><name>%s</name>"	\
+				"<pkts>%s</pkts>"	\
+				"<bytes>%s%s</bytes>"
+#define STR_FMT_XML_EXTENDED	STR_FMT_XML		\
+				"<threshold>%s</threshold>"
+#define STR_FMT_DEFAULT		"%020.0f%s"
+#define STR_FMT_NONE		"%.0f%s"
+#define STR_FMT_TRIPLETS	"%'.0f%s"
+#define STR_FMT_SI_IEC		"%'.3f%s"
+
+#define NFACCT_NUM_DEFAULT	{ .value = 0., .str = "" }
+
+struct nfacct_number {
+	float value;
+	char str[30];
+};
+
+struct fmt_key {
+	uint64_t num;
+	char name[4];
+	char fmt[4];
+};
+
+static struct fmt_key fmt_keys[] = {
+	[FMT_DEFAULT] 		= { .num = 1, .name = "", .fmt = "def" },
+	[FMT_NONE] 		= { .num = 1, .name = "", .fmt = "raw" },
+	[FMT_TRIPLETS] 		= { .num = 1, .name = "", .fmt = "3pl" },
+	[FMT_IEC] 		= { .num = 1, .name = "", .fmt = "iec" },
+	[FMT_IEC_KIBIBYTE] 	= { .num = KiB,	.name = "KiB", .fmt = "kib" },
+	[FMT_IEC_MEBIBYTE] 	= { .num = MiB,	.name = "MiB", .fmt = "mib" },
+	[FMT_IEC_GIBIBYTE] 	= { .num = GiB,	.name = "GiB", .fmt = "gib" },
+	[FMT_IEC_TEBIBYTE] 	= { .num = TiB,	.name = "TiB", .fmt = "tib" },
+	[FMT_IEC_PEBIBYTE] 	= { .num = PiB,	.name = "PiB", .fmt = "pib" },
+	[FMT_IEC_EXBIBYTE] 	= { .num = EiB,	.name = "EiB", .fmt = "eib" },
+	[FMT_SI] 		= { .num = 1, .name = "", .fmt = "si" },
+	[FMT_SI_KILOBYTE] 	= { .num = KB, .name = "KB", .fmt = "kb" },
+	[FMT_SI_MEGABYTE] 	= { .num = MB, .name = "MB", .fmt = "mb" },
+	[FMT_SI_GIGABYTE] 	= { .num = GB, .name = "GB", .fmt = "gb" },
+	[FMT_SI_TERABYTE] 	= { .num = TB, .name = "TB", .fmt = "tb" },
+	[FMT_SI_PETABYTE] 	= { .num = PB, .name = "PB", .fmt = "pb" },
+	[FMT_SI_EXABYTE] 	= { .num = EB, .name = "EB", .fmt = "eb" },
+};
+
+#define SET_RET(x) 	nf->value /= fmt_keys[x].num; \
+			name = fmt_keys[x].name;
+#define SET_FMT(x) 	STR_FMT_##x
+#define GET_FMT(x)	fmt_keys[x].fmt
+#define SET_RET_FMT(x)	\
+	snprintf(nf->str,sizeof(nf->str),SET_FMT(x),nf->value, name)
+
+static void
+format_number(struct nfacct_number *nf, const uint64_t val,
+		const enum nfacct_format fmt)
+{
+	nf->value = (float) val;
+	char *name = "";
+	switch (fmt) {	
+	case FMT_IEC:
+		if (nf->value >= EiB) {
+			SET_RET(FMT_IEC_EXBIBYTE);
+	        } else if (nf->value >= PiB) {
+			SET_RET(FMT_IEC_PEBIBYTE);
+	        } else if (nf->value >= TiB) {
+			SET_RET(FMT_IEC_TEBIBYTE);
+	        } else if (nf->value >= GiB) {
+			SET_RET(FMT_IEC_GIBIBYTE);
+	        } else if (nf->value >= MiB) {
+			SET_RET(FMT_IEC_MEBIBYTE);
+	        } else if (nf->value >= KiB) {
+			SET_RET(FMT_IEC_KIBIBYTE);
+		}
+		SET_RET_FMT(SI_IEC);
+		break;
+	case FMT_SI:
+		if (nf->value >= EB) {
+			SET_RET(FMT_SI_EXABYTE);
+	        } else if (nf->value >= PB) {
+			SET_RET(FMT_SI_PETABYTE);
+	        } else if (nf->value >= TB) {
+			SET_RET(FMT_SI_TERABYTE);
+	        } else if (nf->value >= GB) {
+			SET_RET(FMT_SI_GIGABYTE);
+	        } else if (nf->value >= MB) {
+			SET_RET(FMT_SI_MEGABYTE);
+	        } else if (nf->value >= KB) {
+			SET_RET(FMT_SI_KILOBYTE);
+		}
+		SET_RET_FMT(SI_IEC);
+		break;
+	case FMT_IEC_EXBIBYTE:
+	case FMT_IEC_PEBIBYTE:
+	case FMT_IEC_TEBIBYTE:
+	case FMT_IEC_GIBIBYTE:
+	case FMT_IEC_MEBIBYTE:
+	case FMT_IEC_KIBIBYTE:
+	case FMT_SI_EXABYTE:
+	case FMT_SI_PETABYTE:
+	case FMT_SI_TERABYTE:
+	case FMT_SI_GIGABYTE:
+	case FMT_SI_MEGABYTE:
+	case FMT_SI_KILOBYTE:
+		SET_RET(fmt);
+		SET_RET_FMT(SI_IEC);
+		break;
+	case FMT_DEFAULT:
+		SET_RET(FMT_DEFAULT);
+		SET_RET_FMT(DEFAULT);
+		break;
+	case FMT_NONE:
+		SET_RET(FMT_NONE);
+		SET_RET_FMT(NONE);
+		break;
+	case FMT_TRIPLETS:
+		SET_RET(FMT_TRIPLETS);
+		SET_RET_FMT(TRIPLETS);
+	default:
+		break;
+	}
+}
+
+void parse_nfacct_name(char *buf, const char *name) {
+	static const char no_quote_chars[] = ",._-0123456789"
+		"abcdefghijklmnopqrstuvwxyz"
+		"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
+	static const char escape_chars[] = "\"\\'";
+	size_t length;
+	const char *p;
+
+	if (buf == NULL)
+		return;
+
+	buf[0] = '\0';
+	if (name == NULL)
+		return;
+
+	length = strspn(name, no_quote_chars);
+
+	if (length > 0 && name[length] == 0) {
+		/* no quoting required */
+		strncat(buf, name, length);
+	} else {
+		/* there is at least one character in the name, which
+		   we have to quote.  Write double quotes around the
+		   name and escape special characters with a backslash */
+		strncat(buf,"\"",1);
+
+		for (p = strpbrk(name, escape_chars); p != NULL;
+		     p = strpbrk(name, escape_chars)) {
+			if (p > name) {
+				strncat(buf,name, p - name);
+			}
+			strncat(buf,"\\",1);
+			strncat(buf,p,1);
+			name = p + 1;
+		}
+
+		/* strcat the rest and finish the double quoted
+		   string */
+		strncat(buf,name,strlen(name));
+		strncat(buf,"\"",1);
+	}
+}
+
+static
+void parse_nfacct_name_xml(char *buf, const char *name) {
+	static const char escape_chars[] = "\"'<>&";
+	int length;
+	int n;
+	char e[10];
+	const char *p;
+
+	if (buf == NULL)
+		return;
+
+	buf[0] = '\0';
+	if (name == NULL)
+		return;
+
+	length = strcspn(name, escape_chars);
+	if (length > 0 && name[length] == 0) {
+		/* no escaping required */
+		strncat(buf, name, length);
+	} else {
+		for (p = strpbrk(name, escape_chars); p != NULL;
+		     p = strpbrk(name, escape_chars)) {
+			if (p > name)
+				strncat(buf, name, p - name);
+
+			n = *p;
+			snprintf(e, sizeof(e), "&#%d;", n);
+			strncat(buf, e, strlen(e));
+			name = p + 1;
+		}
+
+		/* strncat the rest */
+		strncat(buf, name, length);
+	}
+}
+
+#define DEFAULT_LOCALE "en_GB"
+
+static void init_locale(void) {
+	char *lang;
+	char *env = "LANG";
+	lang = getenv(env);
+	setlocale(LC_ALL,(lang == NULL ? DEFAULT_LOCALE : lang));
+}
+
+/* fmt fundamentals */
+#define __offset_fmt		0
+#define __offset_bytes		__offset_fmt
+#define __offset_pkt		8
+#define __size_fmt		0xffff
+#define __size_bytes		0xff
+#define __size_pkt		__size_bytes
+
+/* internal fmt help functions */
+#define __get_mask(x)		((uint32_t)__size_##x << __offset_##x)
+#define __get_value(x,f)	(((uint32_t)x & __get_mask(f)) >> __offset_##f)
+
+/* fmt help functions */
+#define get_fmt(x)		__get_value(x,fmt)
+#define get_bytes_fmt(x)	__get_value(x,bytes)
+#define get_pkt_fmt(x)		__get_value(x,pkt)
+
+#define PRINT_THR(x,y)		((x != 0 && y > x) ? "+" : " ")
+
 static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
-		      uint16_t flags)
+			uint16_t flags, struct nfacct_options *options)
 {
 	int ret;
+	bool compat = (options == NULL);
+	uint32_t fmt;
+	size_t pcw, bcw, btcw;
+	uint64_t pkts = 0, bytes = 0, thr = 0;
+	char nfacct_name[NFACCT_NAME_MAX * 2 + 4];
+	char fmt_str[sizeof(STR_FMT_PLAIN) +
+		     sizeof(STR_FMT_DEFAULT) * 2 + 10];
+	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
+			     bn = NFACCT_NUM_DEFAULT,
+			     tn = NFACCT_NUM_DEFAULT;
+
+	if (compat) {
+		fmt = FMT_MAX;
+		pcw = 0;
+		bcw = 0;
+		btcw = 0;
+	} else {
+		fmt = nfacct_option_get_u32(options, NFACCT_OPT_FMT);
+		pcw = nfacct_option_get_tsize(options, NFACCT_OPT_PCW);
+		bcw = nfacct_option_get_tsize(options, NFACCT_OPT_BCW);
+		btcw = nfacct_option_get_tsize(options, NFACCT_OPT_BTCW);
+	}
+	if (flags & NFACCT_SNPRINTF_F_BONLY) {
+		/* print bytes + name only */
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
+
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+		snprintf(fmt_str, sizeof(fmt_str), STR_FMT_PLAIN_BONLY, bcw,
+			 PRINT_THR(thr,bytes));
+		parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		ret = snprintf(buf, rem, fmt_str, bn.str, nfacct_name);
+	} else if (flags & NFACCT_SNPRINTF_F_FULL) {
+		/* default: print pkts + bytes + name */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
 
-	if (flags & NFACCT_SNPRINTF_F_FULL) {
-		ret = snprintf(buf, rem,
-			"{ pkts = %.20"PRIu64", bytes = %.20"PRIu64" } = %s;",
+		format_number(&pn, pkts, get_pkt_fmt(fmt));
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+		snprintf(fmt_str,sizeof(fmt_str),
+			 (compat ? STR_FMT_PLAIN : STR_FMT_PLAIN_NEW),pcw,bcw,
+			 (compat ? "" : PRINT_THR(thr,bytes)));
+		
+		if (!compat) {
+			parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		}
+		ret = snprintf(buf, rem, fmt_str,
+				pn.str, bn.str,
+				(compat ? nfacct_attr_get_str(nfacct,
+						NFACCT_ATTR_NAME) :
+				nfacct_name));
+	} else if (flags & NFACCT_SNPRINTF_F_EXTENDED) {
+		/* print pkts + bytes + threshold + name */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, get_pkt_fmt(fmt));
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+
+		if (thr)
+			format_number(&tn, thr, get_bytes_fmt(fmt));
+
+		snprintf(fmt_str,sizeof(fmt_str),STR_FMT_PLAIN_EXTENDED,pcw,
+			 bcw,PRINT_THR(thr,bytes), btcw);
+		parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		ret = snprintf(buf, rem, fmt_str, pn.str, bn.str,
+				(thr ? tn.str : "-"), nfacct_name);
+	} else if (flags & NFACCT_SNPRINTF_F_NUMONLY) {
+		/* numbers only: used to determine the maximum column width */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, get_pkt_fmt(fmt));
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+
+		if (thr)
+			format_number(&tn, thr, get_bytes_fmt(fmt));
+
+		ret = snprintf(buf, rem, STR_FMT_PLAIN_NUMONLY,
+				pn.str, bn.str, (thr ? tn.str : "-"));
+	} else if (flags & NFACCT_SNPRINTF_F_SAVE) {
+		/* save: format useful for 'restore' */
+		fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+		parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+
+		ret = snprintf(buf, rem, STR_FMT_PLAIN_SAVE,
+				nfacct_name,
+				GET_FMT(get_pkt_fmt(fmt)),
+				GET_FMT(get_bytes_fmt(fmt)),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
+				nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR));
+
 	} else {
-		ret = snprintf(buf, rem, "%s\n",
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
+		/* print out name only */
+		parse_nfacct_name(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		ret = snprintf(buf, rem, "%s\n", nfacct_name);
 	}
 
 	return ret;
@@ -288,19 +900,88 @@ nfacct_snprintf_xml_localtime(char *buf, unsigned int rem, const struct tm *tm)
 
 static int
 nfacct_snprintf_xml(char *buf, size_t rem, struct nfacct *nfacct,
-		    uint16_t flags)
+		    uint16_t flags, struct nfacct_options *options)
 {
 	int ret = 0;
+	bool compat = (options == NULL);
 	unsigned int size = 0, offset = 0;
+	uint32_t fmt;
+	uint64_t pkts = 0, bytes = 0, thr = 0;
+	char nfacct_name[NFACCT_NAME_MAX * 6 + 1];
+	struct nfacct_number pn = NFACCT_NUM_DEFAULT,
+			     bn = NFACCT_NUM_DEFAULT,
+			     tn = NFACCT_NUM_DEFAULT;
 
-	ret = snprintf(buf, rem,
-			"<obj><name>%s</name>"
-			"<pkts>%.20"PRIu64"</pkts>"
-			"<bytes>%.20"PRIu64"</bytes>",
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
+ 	if (compat) {
+		fmt = FMT_MAX;
+	} else {
+		fmt = nfacct_option_get_u32(options, NFACCT_OPT_FMT);
+	}
+	if (flags & NFACCT_SNPRINTF_F_BONLY) {
+		/* print name + bytes only */
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
+
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+		parse_nfacct_name_xml(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		ret = snprintf(buf, rem, STR_FMT_XML_BONLY,
+				nfacct_name, bn.str, PRINT_THR(thr,bytes));
+		BUFFER_SIZE(ret, size, rem, offset);
+	} else if (flags & NFACCT_SNPRINTF_F_EXTENDED) {
+		/* print name + pkts + bytes + threshold */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, get_pkt_fmt(fmt));
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+		if (thr)
+			format_number(&tn, thr, get_bytes_fmt(fmt));
+
+		parse_nfacct_name_xml(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		ret = snprintf(buf, rem, STR_FMT_XML_EXTENDED,
+				nfacct_name, pn.str, bn.str,
+				PRINT_THR(thr,bytes), (thr ? tn.str : "-"));
+		BUFFER_SIZE(ret, size, rem, offset);
+	} else {
+		/* default/everything else: print name + pkts + bytes */
+		pkts = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS);
+		bytes = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES);
+		thr = nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BTHR);
+
+		if (fmt == FMT_MAX)
+			fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+
+		if (get_fmt(fmt) > FMT_NONE)
+			init_locale();
+
+		format_number(&pn, pkts, get_pkt_fmt(fmt));
+		format_number(&bn, bytes, get_bytes_fmt(fmt));
+		if (!compat) {
+			parse_nfacct_name_xml(nfacct_name,
+				nfacct_attr_get_str(nfacct,NFACCT_ATTR_NAME));
+		}
+		ret = snprintf(buf, rem, STR_FMT_XML,
+				(compat ? nfacct_attr_get_str(nfacct,
+						NFACCT_ATTR_NAME) :
+				nfacct_name) ,pn.str,bn.str,
+				(compat ? "" : PRINT_THR(thr,bytes)));
 	BUFFER_SIZE(ret, size, rem, offset);
+	}
 
 	if (flags & NFACCT_SNPRINTF_F_TIME) {
 		time_t t;
@@ -322,27 +1003,29 @@ err:
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
-
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
@@ -350,6 +1033,25 @@ int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
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
@@ -424,6 +1126,12 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_BTHR))
+		mnl_attr_put_u64(nlh, NFACCT_BTHR, htobe64(nfacct->bthr));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
+		mnl_attr_put_u32(nlh, NFACCT_FMT, htobe32(nfacct->fmt));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
@@ -444,11 +1152,18 @@ static int nfacct_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 		break;
 	case NFACCT_PKTS:
 	case NFACCT_BYTES:
+	case NFACCT_BTHR:
 		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0) {
 			perror("mnl_attr_validate");
 			return MNL_CB_ERROR;
 		}
 		break;
+	case NFACCT_FMT:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
+			perror("mnl_attr_validate");
+			return MNL_CB_ERROR;
+		}
+		break;
 	}
 	tb[type] = attr;
 	return MNL_CB_OK;
@@ -478,6 +1193,12 @@ nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_PKTS])));
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES,
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_BYTES])));
+	if (tb[NFACCT_BTHR])
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BTHR,
+				  be64toh(mnl_attr_get_u64(tb[NFACCT_BTHR])));
+	if (tb[NFACCT_FMT])
+		nfacct_attr_set_u32(nfacct, NFACCT_ATTR_FMT,
+				  be32toh(mnl_attr_get_u32(tb[NFACCT_FMT])));
 
 	return 0;
 }
diff --git a/src/libnetfilter_acct.map b/src/libnetfilter_acct.map
index e71a6b3..b28efaf 100644
--- a/src/libnetfilter_acct.map
+++ b/src/libnetfilter_acct.map
@@ -21,4 +21,17 @@ local: *;
 
 LIBNETFILTER_ACCT_1.1 {
   nfacct_snprintf;
+  nfacct_attr_set_u32;
+  nfacct_attr_get_u32;
+  nfacct_options_alloc;
+  nfacct_options_free;
+  nfacct_option_set;
+  nfacct_option_set_u32;
+  nfacct_option_set_tsize;
+  nfacct_option_unset;
+  nfacct_option_get;
+  nfacct_option_get_u32;
+  nfacct_option_get_tsize;
+  parse_nfacct_name;
+  nfacct_snprintf_with_options;
 } LIBNETFILTER_ACCT_1.0;

