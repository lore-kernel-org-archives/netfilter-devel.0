From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Mon, 25 Feb 2013 20:20:47 +0000
Message-ID: <512BC79F.1070708@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070508060508000400070208"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51269 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3BYUVK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2013 15:21:10 -0500
Received: by mail-lb0-f179.google.com with SMTP id j14so2501513lbo.24
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2013 12:21:09 -0800 (PST)
In-Reply-To: <20130225154848.GA20609@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070508060508000400070208
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

> Could you develop some example usage of your extension?
Sure. As part of the services we provide, we need to "meter" and/or restrict user traffic. Since we value everything in "megabytes" (a misnomer, actually, since it is really Mibibytes we all speak of), it is much easier to get specific "counters" shown, or, locked as, MiB.

Also, for some other types, the traffic is not that big, so a higher "resolution" (i.e. KiB or plain bytes, formatted "nicely") is required and needs to be used.

> Yes, this is how our (limited) revision infrastructure works at this
> moment.
Thank you Pablo.

I've given up on my initial idea, which was to create this custom formatting (as well as object creation) at the point where the first iptables statement is created for a particular nfacct object, so I adopted a "plan b", where everything is done via the "nfacct" executable.

At the end, I've left iptables alone, and dealt with only the other 3 (core) nfacct components, which do the job quite nicely. 

If there is interest in what I've done, or anyone from this list finds this useful, here is a full verbatim of what I've done. I am also attaching 3 patches, which cover what I describe below - don't know what is the formal "submission" process, but if some of the Netfilter guys find this useful or wish to expand on what I've done, I'll gladly prepare a formal manual pages/text/notes, if required - just let me know and I'll gladly do that.

On the other hand, if you have a bit of critique or find something I've done wrong in the code - please do not hesitate and fire away!

The additional functionality I've implemented is to modify the original nfacct components (nfacct executable, libnfnetlink_acct userspace library and nfacct kernel component) to store and display "bytes" and "packets" numbers according to custom format, specified at nfacct object creation time (in other words, during "nfacct add"). 

The format of "bytes" and "packets" can be independently specified. In other words, the format for showing "packet" numbers can be different from the format used for "bytes" for each individual nfacct object.

This (custom) format can be specified at object creation time and takes the following form:

nfacct add <object-name> [[fmt][,fmt]] 

The first component indicates the format for "packets"; the second, if specified, the format for "bytes", where "fmt" is one the following :

def: 00000000000001048576    - default format, as is the case at present
3pl:            1,048,576    - display numbers in "triplets", separated by the "thousand separator" symbol, which is locale-dependent
iec: 		  133.012MiB - display numbers according to the IEC standard (KiB/MiB...) - the suffix is "automatically" determined depending on the value
kib:	      136,204.288KiB - same as above, but the value and therefore the suffix is "locked" as KiB (kibibytes)
mib:		  133.012MiB - same as above, but the value and therefore the suffix is "locked" as MiB (mibibytes)
gib:		    0.130GiB - same as above, but the value and therefore the suffix is "locked" as GiB (gibibytes)
tib:		1,008.345TiB - same as above, but the value and therefore the suffix is "locked" as TiB (tebibytes)
pib:		1,008.345PiB - same as above, but the value and therefore the suffix is "locked" as PiB (pebibytes)
eib:		1,008.345EiB - same as above, but the value and therefore the suffix is "locked" as EiB (exbibytes)
si:		  139.473MB  - display numbers according to the "old" SI standard (KB/MB...) - the suffix is "automatically" determined depending on the value
kb:	      139,473.191KB  - same as above, but the value and therefore the suffix is "locked" as KB (kilobytes)
mb:		  139.473MB  - same as above, but the value and therefore the suffix is "locked" as MB (megabytes)
gb:		    0.139GB  - same as above, but the value and therefore the suffix is "locked" as GB (gigabytes)
tb:		1,082.702TB  - same as above, but the value and therefore the suffix is "locked" as TB (terabytes)
pb:		1,082.702PB  - same as above, but the value and therefore the suffix is "locked" as PB (petabytes)
eb:		1,082.702EB  - same as above, but the value and therefore the suffix is "locked" as EB (exabytes)

A note about the "iec" and "si" values: when the "iec" and "si" formats are specified, then the suffixes are determined "automatically", depending on the value of the actual number. For example, a value of 1048576 bytes will be shown as "1.000MiB" (or "1.049MB" respectively, if "si" is used). However, a value of 999999 bytes will be shown as "976.561KiB" (or 999.999KB respectively).

Another note on the locale-specific format where the "thousand separator" or "decimal point" symbols are used: these are determined "automatically" and depend on the language settings on the particular machine/server/embedded device on which libnfnetlink_acct userspace library is installed. If that locale cannot be determined, then "en_GB" is used (; 

Also, if the "fmt" value for a particular component ("packets" or "bytes") is not specified, then the default ("def") is assumed. For example: 

a) "nfacct add in12 ,mib" is the equivalent of "nfacct add in12 def,mib";
b) "nfacct add in12 3pl," is the equivalent of "nfacct add in12 3pl,def"; and
c) "nfacct add in12 ," is the equivalent of "nfacct add in12", as well as "nfacct add in12 def,def";

Another point worth mentioning: if only one "fmt" component is specified, it is assumed that the specified format applies to *both* "bytes" and "packets". In other words:

a) "nfacct add in12 3pl" is the equivalent of "nfacct add in12 3pl,3pl"

Finally, I've tested these patches against "peculiar" userspace/kernel combination (i.e. old nfacct/libnfnetlink -> new kernel and vice-versa) - they seem to work OK.

--------------070508060508000400070208
Content-Type: text/plain;
 name="kernel-num-format.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel-num-format.patch"

--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -32,6 +32,7 @@
 struct nf_acct {
 	atomic64_t		pkts;
 	atomic64_t		bytes;
+	atomic_t		fmt;
 	struct list_head	head;
 	atomic_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
@@ -63,9 +64,14 @@
 
 	if (matching) {
 		if (nlh->nlmsg_flags & NLM_F_REPLACE) {
-			/* reset counters if you request a replacement. */
+			/* reset counters if you request a replacement... */
 			atomic64_set(&matching->pkts, 0);
 			atomic64_set(&matching->bytes, 0);
+			/* ... and change the format */
+			if (tb[NFACCT_FMT]) {
+				atomic_set(&matching->fmt,
+				   be32_to_cpu(nla_get_be32(tb[NFACCT_FMT])));
+			}
 			return 0;
 		}
 		return -EBUSY;
@@ -85,6 +91,10 @@
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
+	if (tb[NFACCT_FMT]) {
+		atomic_set(&nfacct->fmt,
+			   be32_to_cpu(nla_get_be32(tb[NFACCT_FMT])));
+	}
 	atomic_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &nfnl_acct_list);
 	return 0;
@@ -121,6 +131,7 @@
 	}
 	if (nla_put_be64(skb, NFACCT_PKTS, cpu_to_be64(pkts)) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes)) ||
+	    nla_put_be32(skb, NFACCT_FMT, htonl(atomic_read(&acct->fmt))) ||
 	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
 		goto nla_put_failure;
 
@@ -265,6 +276,7 @@
 	[NFACCT_NAME] = { .type = NLA_NUL_STRING, .len = NFACCT_NAME_MAX-1 },
 	[NFACCT_BYTES] = { .type = NLA_U64 },
 	[NFACCT_PKTS] = { .type = NLA_U64 },
+	[NFACCT_FMT] = { .type = NLA_U32 },
 };
 
 static const struct nfnl_callback nfnl_acct_cb[NFNL_MSG_ACCT_MAX] = {
--- a/include/uapi/linux/netfilter/nfnetlink_acct.h
+++ b/include/uapi/linux/netfilter/nfnetlink_acct.h
@@ -18,6 +18,7 @@
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
+	NFACCT_FMT,
 	NFACCT_USE,
 	__NFACCT_MAX
 };

--------------070508060508000400070208
Content-Type: text/plain;
 name="libnetfilter_acct-num-format.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnetfilter_acct-num-format.patch"

--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -11,6 +11,27 @@
 	NFACCT_ATTR_NAME = 0,
 	NFACCT_ATTR_PKTS,
 	NFACCT_ATTR_BYTES,
+	NFACCT_ATTR_FMT,
+};
+
+enum nfacct_format {
+	FMT_DEFAULT=0,		/*   00001048576 			*/
+	FMT_TRIPLETS,		/*     1,048,576 - locale-dependent 	*/
+	FMT_IEC,		/*       133.012MiB - dynamic 		*/
+	FMT_IEC_KIBIBYTE,	/*     1,145.178KiB - fixed   		*/
+	FMT_IEC_MEBIBYTE,	/*     1,145.178MiB - fixed   		*/
+	FMT_IEC_GIBIBYTE,	/*     1,145.178GiB - fixed   		*/
+	FMT_IEC_TEBIBYTE,	/*     1,145.178TiB - fixed   		*/
+	FMT_IEC_PEBIBYTE,	/*     1,145.178PiB - fixed   		*/
+	FMT_IEC_EXBIBYTE,	/*     1,145.178EiB - fixed   		*/
+	FMT_SI,			/*       133.012MB  - dynamic 		*/
+	FMT_SI_KILOBYTE,	/*     1,145.178KB  - fixed   		*/
+	FMT_SI_MEGABYTE,	/*     1,145.178MB  - fixed   		*/
+	FMT_SI_GIGABYTE,	/*     1,145.178GB  - fixed   		*/
+	FMT_SI_TERABYTE,	/*     1,145.178TB  - fixed   		*/
+	FMT_SI_PETABYTE,	/*     1,145.178PB  - fixed   		*/
+	FMT_SI_EXABYTE,		/*     1,145.178EB  - fixed   		*/
+	FMT_MAX,
 };
 
 struct nfacct *nfacct_alloc(void);
@@ -19,11 +40,13 @@
 void nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type, const void *data);
 void nfacct_attr_set_str(struct nfacct *nfacct, enum nfacct_attr_type type, const char *name);
 void nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type, uint64_t value);
+void nfacct_attr_set_u32(struct nfacct *nfacct, enum nfacct_attr_type type, uint32_t value);
 void nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type);
 
 const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type);
 const char *nfacct_attr_get_str(struct nfacct *nfacct, enum nfacct_attr_type type);
 uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type);
+uint32_t nfacct_attr_get_u32(struct nfacct *nfacct, enum nfacct_attr_type type);
 
 struct nlmsghdr;
 
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -18,6 +18,7 @@
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
+	NFACCT_FMT,
 	NFACCT_USE,
 	__NFACCT_MAX
 };
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -13,6 +13,7 @@
 #include <endian.h>
 #include <stdlib.h>
 #include <string.h>
+#include <locale.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -59,6 +60,7 @@
 	char		name[NFACCT_NAME_MAX];
 	uint64_t	pkts;
 	uint64_t	bytes;
+	uint32_t	fmt;
 	uint32_t	bitset;
 };
 
@@ -113,6 +115,10 @@
 		nfacct->bytes = *((uint64_t *) data);
 		nfacct->bitset |= (1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_FMT:
+		nfacct->fmt = *((uint32_t *) data);
+		nfacct->bitset |= (1 << NFACCT_ATTR_FMT);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_set);
@@ -146,6 +152,20 @@
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
@@ -163,6 +183,9 @@
 	case NFACCT_ATTR_BYTES:
 		nfacct->bitset &= ~(1 << NFACCT_ATTR_BYTES);
 		break;
+	case NFACCT_ATTR_FMT:
+		nfacct->bitset &= ~(1 << NFACCT_ATTR_FMT);
+		break;
 	}
 }
 EXPORT_SYMBOL(nfacct_attr_unset);
@@ -192,6 +215,10 @@
 		if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 			ret = &nfacct->bytes;
 		break;
+	case NFACCT_ATTR_FMT:
+		if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
+			ret = &nfacct->fmt;
+		break;
 	}
 	return ret;
 }
@@ -227,19 +254,180 @@
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
+#define KiB ((unsigned long long) 1 << 10)
+#define MiB ((unsigned long long) 1 << 20)
+#define GiB ((unsigned long long) 1 << 30)
+#define TiB ((unsigned long long) 1 << 40)
+#define PiB ((unsigned long long) 1 << 50)
+#define EiB ((unsigned long long) 1 << 60)
+#define KB ((unsigned long long)  1*1000)
+#define MB ((unsigned long long) KB*1000)
+#define GB ((unsigned long long) MB*1000)
+#define TB ((unsigned long long) GB*1000)
+#define PB ((unsigned long long) TB*1000)
+#define EB ((unsigned long long) PB*1000)
+
+#define STR_FMT_PLAIN		"{ pkts = %s, bytes = %s } = %s;"
+#define STR_FMT_XML		"<obj><name>%s</name>"	\
+				"<pkts>%s</pkts>"	\
+				"<bytes>%s</bytes>"
+#define STR_FMT_DEFAULT		"%020.0f%s"
+#define STR_FMT_TRIPLETS	"%'26.0f%s"
+#define STR_FMT_SI_IEC		"%'26.3f%s"
+#define STR_FMT_XML_DEFAULT	STR_FMT_DEFAULT
+#define STR_FMT_XML_TRIPLETS	"%'.0f%s"
+#define STR_FMT_XML_SI_IEC	"%'.3f%s"
+
+struct nfacct_number {
+	float value;
+	enum nfacct_format fmt;
+	char *fmt_str;
+};
+
+struct fmt_key {
+	unsigned long long num;
+	char name[4];
+};
+
+static struct fmt_key fmt_keys[] = {
+	[FMT_DEFAULT] 		= { .num = 0, .name = "" },
+	[FMT_TRIPLETS] 		= { .num = 0, .name = "" },
+	[FMT_IEC] 		= { .num = 0, .name = "" },
+	[FMT_IEC_KIBIBYTE] 	= { .num = KiB,	.name = "KiB" },
+	[FMT_IEC_MEBIBYTE] 	= { .num = MiB,	.name = "MiB" },
+	[FMT_IEC_GIBIBYTE] 	= { .num = GiB,	.name = "GiB" },
+	[FMT_IEC_TEBIBYTE] 	= { .num = TiB,	.name = "TiB" },
+	[FMT_IEC_PEBIBYTE] 	= { .num = PiB,	.name = "PiB" },
+	[FMT_IEC_EXBIBYTE] 	= { .num = EiB,	.name = "EiB" },
+	[FMT_SI] 		= { .num = 0, .name = "" },
+	[FMT_SI_KILOBYTE] 	= { .num = KB, .name = "KB" },
+	[FMT_SI_MEGABYTE] 	= { .num = MB, .name = "MB" },
+	[FMT_SI_GIGABYTE] 	= { .num = GB, .name = "GB" },
+	[FMT_SI_TERABYTE] 	= { .num = TB, .name = "TB" },
+	[FMT_SI_PETABYTE] 	= { .num = PB, .name = "PB" },
+	[FMT_SI_EXABYTE] 	= { .num = EB, .name = "EB" },
+};
+
+#define SET_RET(x) 			\
+	ret.value /= fmt_keys[x].num;	\
+	ret.fmt = x;
+
+#define SET_RET_FMT(x)			\
+	ret.fmt = fmt;			\
+	ret.fmt_str = xml ? STR_FMT_XML_##x : STR_FMT_##x;
+
+static struct nfacct_number
+format_number(const unsigned long long val, const enum nfacct_format fmt, 
+	      const int xml)
+{
+	struct nfacct_number ret;
+	ret.value = (float) val;
+	SET_RET_FMT(SI_IEC);
+	switch (fmt) {	
+	case FMT_IEC:
+		if (ret.value >= EiB) {
+			SET_RET(FMT_IEC_EXBIBYTE);
+	        } else if (ret.value >= PiB) {
+			SET_RET(FMT_IEC_PEBIBYTE);
+	        } else if (ret.value >= TiB) {
+			SET_RET(FMT_IEC_TEBIBYTE);
+	        } else if (ret.value >= GiB) {
+			SET_RET(FMT_IEC_GIBIBYTE);
+	        } else if (ret.value >= MiB) {
+			SET_RET(FMT_IEC_MEBIBYTE);
+	        } else if (ret.value >= KiB) {
+			SET_RET(FMT_IEC_KIBIBYTE);
+		}
+		break;
+	case FMT_SI:
+		if (ret.value >= EB) {
+			SET_RET(FMT_SI_EXABYTE);
+	        } else if (ret.value >= PB) {
+			SET_RET(FMT_SI_PETABYTE);
+	        } else if (ret.value >= TB) {
+			SET_RET(FMT_SI_TERABYTE);
+	        } else if (ret.value >= GB) {
+			SET_RET(FMT_SI_GIGABYTE);
+	        } else if (ret.value >= MB) {
+			SET_RET(FMT_SI_MEGABYTE);
+	        } else if (ret.value >= KB) {
+			SET_RET(FMT_SI_KILOBYTE);
+		}
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
+		break;
+	case FMT_DEFAULT:
+		SET_RET_FMT(DEFAULT);
+		break;
+	case FMT_TRIPLETS:
+		SET_RET_FMT(TRIPLETS);
+		break;
+	}
+	return ret;
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
 static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
 		      uint16_t flags)
 {
 	int ret;
+	char fmt_str[sizeof(STR_FMT_PLAIN) + 
+		     sizeof(STR_FMT_DEFAULT) * 2 + 10];
+	struct nfacct_number p;
+	struct nfacct_number b;
+	uint32_t fmt;
 
 	if (flags & NFACCT_SNPRINTF_F_FULL) {
-		ret = snprintf(buf, rem,
-			"{ pkts = %.20llu, bytes = %.20llu } = %s;",
-			(unsigned long long)
+		fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+		if (((fmt & 240) >> 4) || (fmt & 15)) // locale-dependent
+			init_locale();
+
+		p = format_number((unsigned long long)
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
-			(unsigned long long)
+				  ((fmt & 240) >> 4), 0);
+		b = format_number((unsigned long long)
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
+				  (fmt & 15), 0);
+		sprintf(fmt_str, STR_FMT_PLAIN,	p.fmt_str, b.fmt_str, "%s");
+		ret = snprintf(buf, rem, fmt_str, 
+				p.value, fmt_keys[p.fmt].name, 
+				b.value, fmt_keys[b.fmt].name,
 			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME));
 	} else {
 		ret = snprintf(buf, rem, "%s\n",
@@ -293,16 +481,26 @@
 {
 	int ret = 0;
 	unsigned int size = 0, offset = 0;
+	char fmt_str[sizeof(STR_FMT_XML) + sizeof(STR_FMT_DEFAULT) * 2 + 10];
+	struct nfacct_number p;
+	struct nfacct_number b;
+	uint32_t fmt;
+
+	fmt = nfacct_attr_get_u32(nfacct, NFACCT_ATTR_FMT);
+	if (((fmt & 240) >> 4) || (fmt & 15)) // locale-dependent
+		init_locale();
 
-	ret = snprintf(buf, rem,
-			"<obj><name>%s</name>"
-			"<pkts>%.20llu</pkts>"
-			"<bytes>%.20llu</bytes>",
-			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
-			(unsigned long long)
+	p = format_number((unsigned long long)
+			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS),
+			  ((fmt & 240) >> 4), 1);
+	b = format_number((unsigned long long)
 			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_BYTES),
-			(unsigned long long)
-			nfacct_attr_get_u64(nfacct, NFACCT_ATTR_PKTS));
+			  (fmt & 15), 1);
+	sprintf(fmt_str, STR_FMT_XML, "%s", p.fmt_str, b.fmt_str);
+	ret = snprintf(buf, rem, fmt_str, 
+			nfacct_attr_get_str(nfacct, NFACCT_ATTR_NAME),
+			p.value, fmt_keys[p.fmt].name, 
+			b.value, fmt_keys[b.fmt].name);
 	BUFFER_SIZE(ret, size, rem, offset);
 
 	if (flags & NFACCT_SNPRINTF_F_TIME) {
@@ -427,6 +625,9 @@
 
 	if (nfacct->bitset & (1 << NFACCT_ATTR_BYTES))
 		mnl_attr_put_u64(nlh, NFACCT_BYTES, htobe64(nfacct->bytes));
+
+	if (nfacct->bitset & (1 << NFACCT_ATTR_FMT))
+		mnl_attr_put_u32(nlh, NFACCT_FMT, htobe32(nfacct->fmt));
 }
 EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
@@ -452,6 +653,12 @@
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
@@ -481,6 +688,9 @@
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_PKTS])));
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES,
 			    be64toh(mnl_attr_get_u64(tb[NFACCT_BYTES])));
+	if (tb[NFACCT_FMT])
+		nfacct_attr_set_u32(nfacct, NFACCT_ATTR_FMT,
+				    be32toh(mnl_attr_get_u32(tb[NFACCT_FMT])));
 
 	return 0;
 }

--------------070508060508000400070208
Content-Type: text/plain;
 name="nfacct-num-format.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfacct-num-format.patch"

--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -211,19 +211,61 @@
 	return 0;
 }
 
+static const char *fmt_options[FMT_MAX + 1] =	{ 
+						"def","3pl","iec","kib",
+						"mib","gib","tib","pib","eib",
+						"si","kb","mb", "gb", "tb",
+						"pb","eb",""
+						};
+
+static uint32_t nfacct_parse_format_options(const char *argv) {
+	char *ptr;
+	char *tmp = strdup(argv);
+	int i, j;
+	enum nfacct_format fmt[2] = { FMT_MAX, FMT_MAX };
+
+	for (i = 0; i <= 2 && tmp != NULL; i++) {
+		ptr = strsep(&tmp, ",");
+
+		if (ptr != NULL && strlen(ptr) == 0) {
+			fmt[i] = FMT_DEFAULT;
+		} else {
+			for (j = 0; j <= FMT_MAX && 
+			      strncmp(ptr, fmt_options[j], 3) != 0; j++) { ; }
+
+			if (j >= FMT_MAX)
+				break;
+
+			fmt[i] = j;
+		}
+	}
+
+	if (i > 2 || j >= FMT_MAX)
+		return -1;
+
+	if (fmt[0] == FMT_MAX) 
+		fmt[0] = fmt[1];
+
+	if (fmt[1] == FMT_MAX)
+		fmt[1] = fmt[0];
+
+	return (fmt[0] << 4) | fmt[1];
+}
+
 static int nfacct_cmd_add(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
 	uint32_t portid, seq;
+	uint32_t fmt;
 	struct nfacct *nfacct;
 	int ret;
 
 	if (argc < 3) {
 		nfacct_perror("missing object name");
 		return -1;
-	} else if (argc > 3) {
+	} else if (argc > 4) {
 		nfacct_perror("too many arguments");
 		return -1;
 	}
@@ -236,6 +278,15 @@
 
 	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
 
+	if (argc == 4 && argv[3] != NULL) {
+		fmt = nfacct_parse_format_options(argv[3]);
+		if (fmt == -1) {
+			nfacct_perror("packets/bytes format wrong");
+			return -1;
+		}
+		nfacct_attr_set(nfacct, NFACCT_ATTR_FMT, &fmt);
+	}
+
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_NEW,
 				     NLM_F_CREATE | NLM_F_ACK, seq);

--------------070508060508000400070208--
