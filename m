Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BDC2745E
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2025 17:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764522105; cv=none; b=IPqdeCiVCrdU+sRMFJtgWPn+uewUgeIZ6lgpfXgdsl33tRc7Wfxe4ucaROKrOYlhVyi3cvYo2RP+DZub4aPEk/jXa3Y8lSM33/Qy7FNdw+t5jjjnnKgXRLJakjW51yajz7otyt0nNh8fNbQwoIKvWqCodTqjte9x2Yid0OodFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764522105; c=relaxed/simple;
	bh=WxaWP81NPu7alnpdF7kXrIg7V8ti7RB1mxc70uzLQBo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HMihBi2Xd4VB4bGdFGc+w1O8rMos1VPYg23Rlqp/u+10JzrmHnuAtumWuqbp5qG5OJQ2O1kQP+EjCX5TlhyAKwwocJlsDIr560plfamPby60SnwjBmrBFobMN6ebBclFAF/1srm/aL1WujfeEmWz5BM7Flp+OA6WxI3B+/WV0PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J1nJbYUF; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1nJbYUF"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so5061189a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2025 09:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764522101; x=1765126901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MzQUdvGE6fkde/LXluzPOQDUTc+rpO6Qbj03y/BWBAA=;
        b=J1nJbYUFj1HCy+cnb8vEz2BMJ+5kOtRvYn7cKJNn1VqrGCrYfKPu/Xv7y1paIa6EIo
         SfxYj9utxBoEG8ApjAWxfZMmO+AdaI1g34AqN8M7pQ/OBOvUZUCpY/R57pUxbOnov01Q
         Wp99sfPQjQ4od0Csd1tGaDZv/osiO9SlNyx+ey/zYAEaAvKbJAL4Ok0WMNUwc3I83i+K
         vll91DGbILP7UQIpt43AwnRiR+RXtR5+e0XI2PFu7Qw5Dlx6Z9cREGuP6EJqiJSeE/TQ
         4xaObqJJPOCQ8nO1Hk6Dooad/oiyliR2JFg2yoqwH2mB+OPKdEjVTxCFJNgW16nWLJsr
         lSXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764522101; x=1765126901;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MzQUdvGE6fkde/LXluzPOQDUTc+rpO6Qbj03y/BWBAA=;
        b=tPz4A/v5CbvV0htWep22onuFPvc0Ga37stS3fLMu/3Von/IJRKueSimpXcXZJP56zF
         LNDZ2um8vLwwtL+TDofsKXFJ2qjmE7ylGLmDJ9CPVCDPyj3ZcWTur0EVvVisu6NJDn8l
         k0TDeuo+Un/kotGEer1UAWttr9UUU73769i7m9/IhhIppf6ooWy+e52oul0W5V5mZIk7
         l9ri21dBwOG6tbC35iWPHkVaqrzzZzNMMkA7ef6zuak2YMQKlPQD/wE+BMksQoRO1sWG
         b2Ic0n9kTuxXb34g4tXnfPJbTjBn9MS36yxzuBIm+HYV7ut9OjI5SSsIvqqa/O5qvbpw
         iAXQ==
X-Gm-Message-State: AOJu0YwNjqJMBoqh/HfE9TSj/IgkWuTnnpnwNIzZuxD4AcBP8wnL7oku
	DvJAvko2rRtIZhqPLPSz+I79CjxXk7i0V7o5cq0XQOFuNLYpUI9WZPR9kbFIsQ==
X-Gm-Gg: ASbGncvDHql8tUcoFlySWJI5x9bYbkjjqoefh1Ro45GBFMrRpzinRN0w2nUnjK0OZqz
	Ith8TV7BR9aK7loa0gQ2VavZzEjD1IZkPsA44+5LBFMYVc+16lre8ZIMVBle2Uj8xjZxe4kVoAT
	gtpmeI4Uoq+UtzxjQfzBFmZ0p07YysFn4mGDnp5C3q3F1ldT99E1vI4iKYDwQ5u/VNk92VCa83A
	RiAj6vsoybvaChoxeuaveKzk7XSsWGy5YR6e6Roy9AyykZ1iA6fwKRrBecmhYnw1101+QWaLixJ
	Sh8g19pr/BVFoiJZB3FZyVxtAUmnFx3KNGjkNlwH/MEI+Lr57ipe2mv6JhhILzVvAQTgkF/2QCa
	kgXmic4kfWIDC4NpyW/VUFX1Q+qwEw91I74wlKv6cVPhy7c6y9gW0QRAS4Mw85iiIU+JbDE3rOm
	QUY8GOgaUOvhBAjJ55TBTZqim4
X-Google-Smtp-Source: AGHT+IFdgk8zgyo8GF0Zu5DEsLJogFgA7kNpZvxaL/UeJqvH1cTSWpQmzwmJ4Z25uWZPPZDCAhw7bg==
X-Received: by 2002:a17:906:2c0d:b0:b76:da45:e3d6 with SMTP id a640c23a62f3a-b76da45e557mr1531770566b.16.1764522100652;
        Sun, 30 Nov 2025 09:01:40 -0800 (PST)
Received: from ice-home.lan ([92.253.236.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f519a41asm957679766b.16.2025.11.30.09.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 09:01:40 -0800 (PST)
From: Serhii Ivanov <icegood1980@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Serhii Ivanov <icegood1980@gmail.com>
Subject: [PATCH] Added netfilter output plugin with ability to write into pcap nflog packets
Date: Sun, 30 Nov 2025 19:00:31 +0200
Message-ID: <20251130170030.2574562-2-icegood1980@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To be able analyze such logs right in wireshark
via nflog packet type
especially with connection track information

Signed-off-by: Serhii Ivanov <icegood1980@gmail.com>
---
 output/pcap/Makefile.am               |  10 +-
 output/pcap/ulogd_output_PCAP_NFLOG.c | 571 ++++++++++++++++++++++++++
 ulogd.conf.in                         |   1 +
 3 files changed, 581 insertions(+), 1 deletion(-)
 create mode 100644 output/pcap/ulogd_output_PCAP_NFLOG.c

diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index b5064ea..6174792 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,9 +1,17 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS += $(libpcap_CFLAGS)
+AM_CPPFLAGS += $(libpcap_CFLAGS) ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
 ulogd_output_PCAP_la_LIBADD  = ${libpcap_LIBS}
 ulogd_output_PCAP_la_LDFLAGS = -avoid-version -module
+
+if BUILD_NFLOG
+    pkglib_LTLIBRARIES += ulogd_output_PCAP_NFLOG.la
+
+    ulogd_output_PCAP_NFLOG_la_SOURCES = ulogd_output_PCAP_NFLOG.c
+    ulogd_output_PCAP_NFLOG_la_LIBADD = ${libpcap_LIBS} $(LIBNETFILTER_LOG_LIBS) $(LIBNETFILTER_CONNTRACK_LIBS)
+    ulogd_output_PCAP_NFLOG_la_LDFLAGS = -avoid-version -module
+endif
diff --git a/output/pcap/ulogd_output_PCAP_NFLOG.c b/output/pcap/ulogd_output_PCAP_NFLOG.c
new file mode 100644
index 0000000..ed85cbe
--- /dev/null
+++ b/output/pcap/ulogd_output_PCAP_NFLOG.c
@@ -0,0 +1,571 @@
+/*
+ * ulogd_output_PCAP_CT.c - ULOGD plugin to merge packet and flow data
+ *
+ * Enriches NFLOG packets with connection tracking flow information
+ * by querying the NFCT table on each packet.
+ *
+ * Stack configuration:
+ * stack=log42:NFLOG,pcapct42:PCAP_NFLOG
+ */
+
+#include <errno.h>
+#include <endian.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <time.h>
+#include <sys/time.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nfnetlink_log.h>
+#include <libnetfilter_log/libnetfilter_log.h>
+#include <ulogd/ulogd.h>
+#include <ulogd/conffile.h>
+#include <sys/stat.h>
+
+#ifdef BUILD_NFCT
+	#include <linux/netfilter/nfnetlink_conntrack.h>
+	#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+	#include <linux/netfilter/nf_conntrack_common.h>
+#endif
+
+#include <pcap/pcap.h>  // for pcap_file_header, PCAP_VERSION_MAJOR/MINOR
+
+#define LINKTYPE_NFLOG  0xEF
+#define TCPDUMP_MAGIC   0xa1b2c3d4
+
+static struct config_keyset pcap_nflog_kset = {
+	.num_ces = 2,
+	.ces = {
+		[0] = { .key = "file", .type = CONFIG_TYPE_STRING, .options = CONFIG_OPT_NONE, .u.string = "/tmp/ulogd_enriched.pcap" },
+		[1] = { .key = "sync", .type = CONFIG_TYPE_INT,	.options = CONFIG_OPT_NONE, .u.value = 1 }
+	}
+};
+
+struct pcap_nflog_data {
+	FILE *output_file;
+};
+
+enum pcap_nflog_input_keys_id {
+	NFLOG_KEY_RAW_MAC = 0,
+	NFLOG_KEY_RAW_PCKT,
+	NFLOG_KEY_RAW_PCKTLEN,
+	NFLOG_KEY_RAW_PCKTCOUNT,
+	NFLOG_KEY_OOB_PREFIX,
+	NFLOG_KEY_OOB_TIME_SEC,
+	NFLOG_KEY_OOB_TIME_USEC,
+	NFLOG_KEY_OOB_MARK,
+	NFLOG_KEY_OOB_IFINDEX_IN,
+	NFLOG_KEY_OOB_IFINDEX_OUT,
+	NFLOG_KEY_OOB_HOOK,
+	NFLOG_KEY_RAW_MAC_LEN,
+	NFLOG_KEY_OOB_SEQ_LOCAL,
+	NFLOG_KEY_OOB_SEQ_GLOBAL,
+	NFLOG_KEY_OOB_FAMILY,
+	NFLOG_KEY_OOB_VERSION,
+	NFLOG_KEY_OOB_RES_ID,
+	NFLOG_KEY_OOB_PROTOCOL,
+	NFLOG_KEY_OOB_UID,
+	NFLOG_KEY_OOB_GID,
+	NFLOG_KEY_RAW_LABEL,
+	NFLOG_KEY_RAW_TYPE,
+	NFLOG_KEY_RAW_MAC_SADDR,
+	NFLOG_KEY_RAW_MAC_ADDRLEN,
+	NFLOG_KEY_RAW,
+	NFLOG_KEY_RAW_CT,
+	NFLOG_KEY_CT_INFO,
+	__PCAP_NFLOG_INPUT_KEY_MAX
+};
+
+static struct ulogd_key pcap_nflog_input_keys[] = {
+	[NFLOG_KEY_RAW_MAC] = { .type = ULOGD_RET_RAW,	.name = "raw.mac" },
+	[NFLOG_KEY_RAW_PCKT] = { .type = ULOGD_RET_RAW,	.name = "raw.pkt" },
+	[NFLOG_KEY_RAW_PCKTLEN] = { .type = ULOGD_RET_UINT32, .name = "raw.pktlen" },
+	[NFLOG_KEY_RAW_PCKTCOUNT] = { .type = ULOGD_RET_UINT32, .name = "raw.pktcount" },
+	[NFLOG_KEY_OOB_PREFIX] = { .type = ULOGD_RET_STRING, .name = "oob.prefix" },
+	[NFLOG_KEY_OOB_TIME_SEC] = { .type = ULOGD_RET_UINT32, .name = "oob.time.sec" },
+	[NFLOG_KEY_OOB_TIME_USEC] = { .type = ULOGD_RET_UINT32, .name = "oob.time.usec" },
+	[NFLOG_KEY_OOB_MARK] = { .type = ULOGD_RET_UINT32, .name = "oob.mark" },
+	[NFLOG_KEY_OOB_IFINDEX_IN] = { .type = ULOGD_RET_UINT32, .name = "oob.ifindex_in" },
+	[NFLOG_KEY_OOB_IFINDEX_OUT]= { .type = ULOGD_RET_UINT32, .name = "oob.ifindex_out" },
+	[NFLOG_KEY_OOB_HOOK] = { .type = ULOGD_RET_UINT8,  .name = "oob.hook" },
+	[NFLOG_KEY_RAW_MAC_LEN] = { .type = ULOGD_RET_UINT16, .name = "raw.mac_len" },
+	[NFLOG_KEY_OOB_SEQ_LOCAL] = { .type = ULOGD_RET_UINT32, .name = "oob.seq.local" },
+	[NFLOG_KEY_OOB_SEQ_GLOBAL] = { .type = ULOGD_RET_UINT32, .name = "oob.seq.global" },
+	[NFLOG_KEY_OOB_FAMILY] = { .type = ULOGD_RET_UINT8,  .name = "oob.family" },
+	[NFLOG_KEY_OOB_VERSION] = { .type = ULOGD_RET_UINT8,  .name = "oob.version" },
+	[NFLOG_KEY_OOB_RES_ID] = { .type = ULOGD_RET_UINT16,  .name = "oob.resid" },
+	[NFLOG_KEY_OOB_PROTOCOL] = { .type = ULOGD_RET_UINT16, .name = "oob.protocol" },
+	[NFLOG_KEY_OOB_UID] = { .type = ULOGD_RET_UINT32, .name = "oob.uid" },
+	[NFLOG_KEY_OOB_GID] = { .type = ULOGD_RET_UINT32, .name = "oob.gid" },
+	[NFLOG_KEY_RAW_LABEL] = { .type = ULOGD_RET_UINT8,  .name = "raw.label" },
+	[NFLOG_KEY_RAW_TYPE] = { .type = ULOGD_RET_UINT16, .name = "raw.type" },
+	[NFLOG_KEY_RAW_MAC_SADDR] = { .type = ULOGD_RET_RAW,	.name = "raw.mac.saddr" },
+	[NFLOG_KEY_RAW_MAC_ADDRLEN]= { .type = ULOGD_RET_UINT16, .name = "raw.mac.addrlen" },
+	[NFLOG_KEY_RAW] = { .type = ULOGD_RET_RAW,	.name = "raw" },
+	[NFLOG_KEY_RAW_CT] = { .type = ULOGD_RET_RAW,	.name = "ct" },
+	[NFLOG_KEY_CT_INFO] = { .type = ULOGD_RET_UINT32, .name = "ct_info" },
+};
+
+#define get(proc,key) (pp_is_valid(pi->input.keys, key) ? ikey_get_ ## proc (&pi->input.keys[key]) : 0)
+
+#define write_section_proc(section, type, getter) \
+{ \
+	uint##type##_t temp = getter; \
+	if (write_nflog_tlv(&buf_ptr, buf_end, section, &temp, sizeof(temp)) < 0) { \
+		return -1; \
+	} \
+}
+
+#define write_section(section, key, type, convert) write_section_proc(section, type, convert(get(u##type, key)))
+
+#define write_u32_section(section, key) write_section(section, key, 32, htonl)
+#define write_u16_section(section, key) write_section(section, key, 16, htons)
+
+static int write_pcap_header(FILE *f)
+{
+	struct pcap_file_header pcfh;
+	pcfh.magic = TCPDUMP_MAGIC;
+	pcfh.version_major = PCAP_VERSION_MAJOR;
+	pcfh.version_minor = PCAP_VERSION_MINOR;
+	pcfh.thiszone = 0;
+	pcfh.sigfigs = 0;
+	pcfh.snaplen = 4096;
+	pcfh.linktype = LINKTYPE_NFLOG;
+
+	return fwrite(&pcfh, sizeof(pcfh), 1, f) == 1 ? 0 : -1;
+}
+
+static int write_nflog_tlv(char **buf, const char *buf_end, uint16_t type,
+		const void *data, uint16_t data_len)
+{
+	uint16_t tlv_len = data_len + 4;
+	uint16_t padded_len = (tlv_len + 3) & ~3;
+
+	int delta = *buf + padded_len - buf_end;
+	if (0 <= delta) {
+		ulogd_log(ULOGD_NOTICE, "Cannot write %u. No space left in buffer (above = %d)\n", type, delta);
+		return -1;
+	}
+
+	*(uint16_t*)*buf = tlv_len;
+	*(uint16_t*)(*buf + 2) = type;
+	memcpy(*buf + 4, data, data_len);
+
+	if (padded_len > tlv_len)
+		memset(*buf + tlv_len, 0, padded_len - tlv_len);
+
+	*buf += padded_len;
+	return padded_len;
+}
+
+static uint64_t u32_to_be64(uint32_t x) {
+	uint64_t v = (uint64_t)x;
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	v = __builtin_bswap64(v);
+#endif
+	return v;
+}
+
+#define nfct_get_attr_(ct, attr_id) (const char*)nfct_get_attr(ct, attr_id)
+
+#define print_ct(fmt, ...) \
+{ \
+	int res = snprintf(flow_info + pos, sizeof(flow_info) - pos, fmt "\n", __VA_ARGS__); \
+	if (res < 0) { \
+		ulogd_log(ULOGD_NOTICE, "CT: cannot write to buffer: %m\n"); \
+		goto print_ct_section; \
+	} \
+	pos += res; \
+}
+
+#define print_ct_attribute(attr_id, format, type) \
+{ \
+	if (nfct_attr_is_set(ct, attr_id)) { \
+		print_ct(format, nfct_get_attr_##type(ct, attr_id)); \
+	} \
+	if (pos >= sizeof(flow_info)) { \
+		goto print_ct_section; \
+	} \
+}
+
+#define print_ct_attribute_pair(attr1, attr2, format, type) \
+{ \
+	if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
+		print_ct(format, nfct_get_attr_##type(ct, attr1), nfct_get_attr_##type(ct, attr2)); \
+	} \
+	if (pos >= sizeof(flow_info)) { \
+		goto print_ct_section; \
+	} \
+}
+
+#define print_ct_ip4_pair(attr1, attr2, format) \
+{ \
+	if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
+		uint32_t ip1_be = nfct_get_attr_u32(ct, attr1); \
+		uint32_t ip2_be = nfct_get_attr_u32(ct, attr2); \
+		\
+		struct in_addr attr1_ip = { .s_addr = ip1_be }; \
+		struct in_addr attr2_ip = { .s_addr = ip2_be }; \
+		\
+		print_ct(format, inet_ntoa(attr1_ip), inet_ntoa(attr2_ip)); \
+	} \
+	\
+	if (pos >= sizeof(flow_info)) { \
+		goto print_ct_section; \
+	} \
+}
+
+#define print_ct_ip6_pair(attr1, attr2, format) \
+{ \
+	if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
+		const void * ip1_raw = nfct_get_attr(ct, attr1); \
+		const void * ip2_raw = nfct_get_attr(ct, attr2); \
+		\
+		char ip1_str[INET6_ADDRSTRLEN]; \
+		char ip2_str[INET6_ADDRSTRLEN]; \
+		\
+		inet_ntop(AF_INET6, ip1_raw, ip1_str, INET6_ADDRSTRLEN); \
+		inet_ntop(AF_INET6, ip2_raw, ip2_str, INET6_ADDRSTRLEN); \
+		\
+		print_ct(format, ip1_str, ip2_str); \
+	} \
+	\
+	if (pos >= sizeof(flow_info)) { \
+		goto print_ct_section; \
+	} \
+}
+
+static int write_pcap_nflog_packet(struct ulogd_pluginstance *pi, FILE *of)
+{
+	char buffer[4096];
+	char *buf_ptr = buffer;
+	const char *buf_end = buffer + sizeof(buffer);
+#ifdef BUILD_NFCT
+	struct nf_conntrack *ct = get(ptr, NFLOG_KEY_RAW_CT);
+#endif
+	struct nflog_data *nflog = get(ptr, NFLOG_KEY_RAW);
+
+	struct nfgenmsg pkt_hdr = {
+		.nfgen_family=get(u8, NFLOG_KEY_OOB_FAMILY),
+		.version=get(u8, NFLOG_KEY_OOB_VERSION),
+		.res_id=htons(get(u16, NFLOG_KEY_OOB_RES_ID))};
+	memcpy(buf_ptr, &pkt_hdr, sizeof(pkt_hdr));
+	buf_ptr += sizeof(pkt_hdr);
+
+	// ---  NFULA_PACKET_HDR  ---
+	{	struct nfulnl_msg_packet_hdr pkt_hdr_tlv = {
+			.hw_protocol = htons(get(u16, NFLOG_KEY_OOB_PROTOCOL)),
+			.hook = get(u8, NFLOG_KEY_OOB_HOOK),
+			._pad = 0
+		};
+		if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PACKET_HDR,
+				&pkt_hdr_tlv, sizeof(pkt_hdr_tlv)) < 0) {
+			return -1;
+		}
+	}
+
+	// --- NFULA_MARK --- 
+	write_u32_section(NFULA_MARK, NFLOG_KEY_OOB_MARK);
+
+	// --- NFULA_TIMESTAMP --- 
+	{
+		struct nfulnl_msg_packet_timestamp ts = {
+			.sec = u32_to_be64(get(u32, NFLOG_KEY_OOB_TIME_SEC)),
+			.usec = u32_to_be64(get(u32, NFLOG_KEY_OOB_TIME_USEC))
+		};
+		
+		if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_TIMESTAMP, &ts, sizeof(ts)) < 0) {
+			return -1;
+		}
+	}
+
+	// --- NFULA_IFINDEX_INDEV --- 
+	write_u32_section(NFULA_IFINDEX_INDEV, NFLOG_KEY_OOB_IFINDEX_IN);
+
+	// --- NFULA_IFINDEX_OUTDEV --- 
+	write_u32_section(NFULA_IFINDEX_OUTDEV, NFLOG_KEY_OOB_IFINDEX_OUT);
+
+	// --- NFULA_IFINDEX_PHYSINDEV --- 
+	write_section_proc(NFULA_IFINDEX_PHYSINDEV, 32, htonl(nflog_get_physindev(nflog)));
+
+	// --- NFULA_IFINDEX_PHYSOUTDEV --- 
+	write_section_proc(NFULA_IFINDEX_PHYSOUTDEV, 32, htonl(nflog_get_physoutdev(nflog)));
+
+	// ---  NFULA_HWADDR  ---
+	{
+		uint16_t len = get(u16, NFLOG_KEY_RAW_MAC_ADDRLEN);
+
+		if (len > 0) {
+			struct nfulnl_msg_packet_hw temp = {
+				.hw_addrlen = htons(len),
+				.hw_addr = {0},
+			};
+			if (pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_MAC_SADDR)) {
+				void* value = ikey_get_ptr(&pi->input.keys[NFLOG_KEY_RAW_MAC_SADDR]);
+				if (value) {
+					memcpy(&temp.hw_addr, value, len);
+				}
+			}
+			if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_HWADDR, &temp, sizeof(temp)) < 0) {
+				return -1;
+			}
+		}
+	}
+
+	// ---  NFULA_PAYLOAD  ---
+	{
+		void *pkt_data = get(ptr, NFLOG_KEY_RAW_PCKT);
+		uint32_t pkt_len = get(u32, NFLOG_KEY_RAW_PCKTLEN);
+
+		if (pkt_data) {
+			if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PAYLOAD, pkt_data, pkt_len) < 0) {
+				return -1;
+			}
+		}
+	}
+
+	// ---  NFULA_PREFIX  ---
+	{	char *prefix = (char *)get(ptr, NFLOG_KEY_OOB_PREFIX);
+
+		if (prefix) {
+			if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PREFIX, prefix, strlen(prefix)) < 0) {
+				return -1;
+			}
+		}
+	}
+
+	// --- NFULA_UID ---
+	write_u32_section(NFULA_UID, NFLOG_KEY_OOB_UID);
+
+	// --- NFULA_SEQ ---
+	write_u32_section(NFULA_SEQ, NFLOG_KEY_OOB_SEQ_LOCAL);
+
+	// --- NFULA_SEQ_GLOBAL ---
+	write_u32_section(NFULA_SEQ_GLOBAL, NFLOG_KEY_OOB_SEQ_GLOBAL);
+
+	// --- NFULA_GID ---
+	write_u32_section(NFULA_GID, NFLOG_KEY_OOB_GID);
+
+	// --- NFULA_HWTYPE ---
+	write_u16_section(NFULA_HWTYPE, NFLOG_KEY_RAW_TYPE);
+	// --- NFULA_HWLEN ---
+	write_u16_section(NFULA_HWLEN, NFLOG_KEY_RAW_MAC_LEN);
+	// --- NFULA_HWHEADER ---
+	{
+		char *data = get(ptr, NFLOG_KEY_RAW_MAC);
+		size_t len = get(u16, NFLOG_KEY_RAW_MAC_LEN);
+
+		if ((len > 0) && (data != NULL)) {
+			if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_HWHEADER, data, len) < 0) {
+				return -1;
+			}
+		}
+	}
+#ifdef BUILD_NFCT
+	if (ct != NULL) {
+		char flow_info[2048];
+		size_t pos = 0;
+
+		// --- NFULA_CT_INFO ---
+		write_u32_section(NFULA_CT_INFO, NFLOG_KEY_CT_INFO);
+
+		// --- NFULA_CT ---
+		print_ct_attribute(ATTR_ID, "id=%u", u32);
+		print_ct_attribute(ATTR_USE, "use=%u", u32);
+		print_ct_attribute(ATTR_STATUS, "status=0x%08x", u32);
+		print_ct_attribute(ATTR_TIMEOUT, "timeout=%u", u32);
+		print_ct_attribute(ATTR_MARK, "mark=%u", u32);
+		print_ct_attribute(ATTR_SECMARK, "security mark=%u", u32);
+		
+		print_ct_attribute_pair(ATTR_ORIG_COUNTER_PACKETS, ATTR_ORIG_COUNTER_BYTES, "orig packets/bytes=%lu/%lu", u64);
+		print_ct_attribute_pair(ATTR_REPL_COUNTER_PACKETS, ATTR_REPL_COUNTER_BYTES, "repl packets/bytes=%lu/%lu", u64);
+		
+		print_ct_ip4_pair(ATTR_ORIG_IPV4_SRC, ATTR_ORIG_IPV4_DST, "orig ip4 src/dest=%s/%s");
+		print_ct_ip6_pair(ATTR_ORIG_IPV6_SRC, ATTR_ORIG_IPV6_DST, "orig ip6 src/dest=%s/%s");
+		print_ct_attribute_pair(ATTR_ORIG_PORT_SRC, ATTR_ORIG_PORT_DST, "orig port src/dest=%u/%u", u16);
+
+
+		print_ct_ip4_pair(ATTR_REPL_IPV4_SRC, ATTR_REPL_IPV4_DST, "repl ip4 src/dest=%s/%s");
+		print_ct_ip6_pair(ATTR_REPL_IPV6_SRC, ATTR_REPL_IPV6_DST, "repl ip6 src/dest=%s/%s");
+		print_ct_attribute_pair(ATTR_REPL_PORT_SRC, ATTR_REPL_PORT_DST, "repl port src/dest=%u/%u", u16);
+		
+		print_ct_attribute_pair(ATTR_ORIG_L3PROTO, ATTR_REPL_L3PROTO, "l3proto orig/repl=%u/%u", u8);
+		print_ct_attribute_pair(ATTR_ORIG_L4PROTO, ATTR_REPL_L4PROTO, "l4proto orig/repl=%u/%u", u8);
+
+		print_ct_ip4_pair(ATTR_MASTER_IPV4_SRC, ATTR_MASTER_IPV4_DST, "master ip4 src/dest=%s/%s");
+		print_ct_ip6_pair(ATTR_MASTER_IPV6_SRC, ATTR_MASTER_IPV6_DST, "master ip6 src/dest=%s/%s");
+		print_ct_attribute_pair(ATTR_MASTER_PORT_SRC, ATTR_MASTER_PORT_DST, "master port src/dest=%u/%u", u16);
+		print_ct_attribute_pair(ATTR_MASTER_L3PROTO, ATTR_MASTER_L4PROTO, "master proto l3/l4=%u/%u", u8);
+
+		print_ct_attribute(ATTR_ZONE, "zone=%u", u16);
+		print_ct_attribute_pair(ATTR_ORIG_ZONE, ATTR_REPL_ZONE, "zone orig/repl=%u/%u", u16);
+		// tcp
+		print_ct_attribute(ATTR_TCP_STATE, "tcp_state=%u", u8);
+		print_ct_attribute_pair(ATTR_TCP_FLAGS_ORIG, ATTR_TCP_FLAGS_REPL, "tcp_flags orig/repl=%u/%u", u8);
+		print_ct_attribute_pair(ATTR_TCP_MASK_ORIG, ATTR_TCP_MASK_REPL, "tcp_mask orig/repl=%u/%u", u8);
+		// icmp
+		print_ct_attribute(ATTR_ICMP_TYPE, "icmp_type=%u", u8);
+		print_ct_attribute(ATTR_ICMP_CODE, "icmp_code=%u", u8);
+		print_ct_attribute(ATTR_ICMP_ID, "icmp_id=%u", u16);
+		// SCTP
+		print_ct_attribute(ATTR_SCTP_STATE, "sctp_state=%u", u8);
+		print_ct_attribute_pair(ATTR_SCTP_VTAG_ORIG, ATTR_SCTP_VTAG_REPL, "sctp vtag orig/repl=%u/%u", u8);
+		// DCCP
+		print_ct_attribute(ATTR_DCCP_STATE, "dccp_state=%u", u8);
+		print_ct_attribute(ATTR_DCCP_ROLE, "dccp_role=%u", u8);
+		print_ct_attribute(ATTR_DCCP_HANDSHAKE_SEQ, "dccp_handshake_seq=%lu", u64);
+
+		print_ct_attribute(ATTR_HELPER_NAME, "helper=%s", );
+		print_ct_attribute(ATTR_HELPER_INFO, "helper info=%s", );
+		print_ct_attribute(ATTR_SECCTX, "sec context=%s", );
+
+		// NAT
+		print_ct_ip4_pair(ATTR_SNAT_IPV4, ATTR_DNAT_IPV4, "NAT ip4 src/dest=%s/%s");
+		print_ct_ip6_pair(ATTR_SNAT_IPV6, ATTR_DNAT_IPV6, "NAT ip6 src/dest=%s/%s");
+		print_ct_attribute_pair(ATTR_SNAT_PORT, ATTR_DNAT_PORT, "NAT port src/dest=%u/%u", u16);
+
+		print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_CORRECTION_POS, ATTR_REPL_NAT_SEQ_CORRECTION_POS, "NAT SEQ Corr Pos orig/repl=%u/%u", u32);
+		print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE, ATTR_REPL_NAT_SEQ_OFFSET_BEFORE, "NAT SEQ Offset Bef orig/repl=%u/%u", u32);
+		print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ATTR_REPL_NAT_SEQ_OFFSET_AFTER, "NAT SEQ Offset After orig/repl=%u/%u", u32);
+
+print_ct_section:
+		if (pos > 0)
+			flow_info[pos - 1] = '\0';
+
+		if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_CT, flow_info, pos) < 0) {
+			return -1;
+		}
+	}
+#endif
+	size_t total_len = buf_ptr - buffer;
+	// ---  PCAP record header  ---
+	struct {
+		uint32_t ts_sec;
+		uint32_t ts_usec;
+		uint32_t caplen;
+		uint32_t len;
+	} ph;
+
+	ph.ts_sec = get(u32, NFLOG_KEY_OOB_TIME_SEC);
+	ph.ts_usec = get(u32, NFLOG_KEY_OOB_TIME_USEC);
+	ph.caplen = total_len;   // length of data written
+	ph.len = total_len;   // original length on wire
+
+	/* Write PCAP record */
+	if ((fwrite(&ph, sizeof(ph), 1, of) != 1) || (fwrite(buffer, total_len, 1, of) != 1)) {
+		ulogd_log(ULOGD_NOTICE, "Cannot write pcap record\n");
+		return -1;
+	}
+
+	if (pi->config_kset->ces[1].u.value)
+		fflush(of);
+
+	return 0;
+}
+
+static int pcap_nflog_output(struct ulogd_pluginstance *pi)
+{
+	struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+
+	if (!pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_PCKT) || !pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_PCKTLEN)) {
+		ulogd_log(ULOGD_NOTICE, "Cannot get payload. Skipping packet\n");
+		return -1;
+	}
+
+	if (!get(ptr, NFLOG_KEY_RAW)) {
+		ulogd_log(ULOGD_NOTICE, "No nflog pointer present\n");
+		return -1;
+	}
+
+	return write_pcap_nflog_packet(pi, data->output_file);
+}
+
+static int reopen_file(struct ulogd_pluginstance *pi)
+{
+	const char *filename = pi->config_kset->ces[0].u.string;
+	struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+
+	if (data->output_file)
+		fclose(data->output_file);
+	data->output_file = NULL;
+	
+	FILE *of = fopen(filename, "a");
+	if (!of) {
+		ulogd_log(ULOGD_ERROR, "Cannot create output file %s: %m\n", filename);
+		return -EPERM;
+	}
+	data->output_file = of;
+
+	int empty = 1;
+	struct stat st;
+
+	if (stat(filename, &st) == 0) {
+		empty = st.st_size == 0;
+	}
+
+	if (!empty) {
+		return 0;
+	} else {
+		ulogd_log(ULOGD_NOTICE, "Output '%s' is empty. To write header\n", filename);
+	}
+	
+	if (write_pcap_header(data->output_file) < 0) {
+		ulogd_log(ULOGD_ERROR, "Cannot write header to file '%s'\n", filename);
+		fclose(data->output_file);
+		data->output_file = NULL;
+		return -ENOSPC;
+	}
+	return 0;
+}
+
+static int pcap_nflog_init(struct ulogd_pluginstance *pi)
+{
+	struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+	memset(data, 0, sizeof(*data));
+
+	return reopen_file(pi);
+}
+
+static int pcap_nflog_destroy(struct ulogd_pluginstance *pi)
+{
+	struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+
+	if (data->output_file) {
+		fclose(data->output_file);
+		data->output_file = NULL;
+	}
+	return 0;
+}
+
+static void pcap_nflog_signal(struct ulogd_pluginstance *upi, int signal)
+{
+	ulogd_log(ULOGD_INFO, "pcap_nflog_signal: Delivered %d \n", signal);
+	if (signal == SIGHUP) {
+		ulogd_log(ULOGD_NOTICE, "reopening capture file\n");
+		reopen_file(upi);
+	}
+}
+
+static struct ulogd_plugin pcap_nflog_plugin = {
+	.name = "PCAP_NFLOG",
+	.input = { .keys = pcap_nflog_input_keys, .num_keys = ARRAY_SIZE(pcap_nflog_input_keys),
+		.type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_RAW },
+	.output = { .type = ULOGD_DTYPE_SINK },
+	.config_kset = &pcap_nflog_kset,
+	.priv_size = sizeof(struct pcap_nflog_data),
+	.start = pcap_nflog_init,
+	.stop = pcap_nflog_destroy,
+	.signal = &pcap_nflog_signal,
+	.interp = pcap_nflog_output,
+	.version = VERSION,
+};
+
+void __attribute__ ((constructor)) init(void)
+{
+	ulogd_register_plugin(&pcap_nflog_plugin);
+}
\ No newline at end of file
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 77d7086..8c91e1f 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -43,6 +43,7 @@ logfile="/var/log/ulogd.log"
 #plugin="@pkglibdir@/ulogd_output_GPRINT.so"
 #plugin="@pkglibdir@/ulogd_output_NACCT.so"
 #plugin="@pkglibdir@/ulogd_output_PCAP.so"
+#plugin="@pkglibdir@/ulogd_output_PCAP_NFLOG.so"
 #plugin="@pkglibdir@/ulogd_output_PGSQL.so"
 #plugin="@pkglibdir@/ulogd_output_MYSQL.so"
 #plugin="@pkglibdir@/ulogd_output_DBI.so"
-- 
2.51.0

