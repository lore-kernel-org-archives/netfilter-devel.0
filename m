Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1306522157B
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2025 09:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762680292; cv=none; b=JHnA1lt/58jfWaodhTjtu60k868K8cq0i/Bcp9yN7LqVlIBhgA3orNJwUG9OGi+L1bGKrqrHMZX8mKeh/tlxipbRGDG36dcWsVTNbVi/gDIx+ujQCaHxLpzU0RodALIkvnhbz0N7olLpaJqfYzyb6pu5gQK+gAmjtna065BVFJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762680292; c=relaxed/simple;
	bh=Oe+LRhFnEc8MwBBctSLo1YfAEL2pLUHbLbscp7kK1zI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=izGVzSdJRvvtKihG5XpVv9zD+u5gs6uPH+VNNDEjS3lxnuXiMCD/sE3LfqRFBu8PBtdmLtJgNyAKg7gAPoyjvUCgB54IQcgXtzb+BhbxLtCQop4mfbPZfSDvqtuJTVIC2UXVnLUQz+TkivjJBvWCiLkfJEilbKs+7mlj3p9lxas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BGyOg2/T; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGyOg2/T"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b3e9d633b78so366069966b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2025 01:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762680288; x=1763285088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WygHw5/wCF4tFn2XSSS6W9oJV1iS43L87AX1gdJKqbQ=;
        b=BGyOg2/TngzIsvnbPxSaoidLLlr+7HACN0a4SQZNuBCtWzSxXgBMt+YeeKjiQxNI1c
         q6mBued9rkRAoOKLbbCe+O0e1N1OjlYllQOwk4OzaPzVEV/I6liGtMR7YKdtGLk5rMsX
         REtZ1YQxcWh8kYArFjaLDacSC9RyBk3HhD0kydeRHD5JiMCg8vp+Ox5oUu3GPIvoNO5R
         KBrC/ZyCsvPQI/qMtjSzCPDlloBgNWfDn0zKD4xISx5vXCUqJUCJGR25g/E1b9VEcVBe
         CHsqnt3/S6g+8sMJJcRnpLuJ6NHdGP1yREIUVPknItCbEn5FtLkDrACpKK4K5I6CkuHd
         nY3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762680288; x=1763285088;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WygHw5/wCF4tFn2XSSS6W9oJV1iS43L87AX1gdJKqbQ=;
        b=WiSRWAh/hBIK+eOur/z+GW3qp6o0pZouXU7nFtOLw14eEmnAH73iSslOomUQYgEMbr
         inxp2Ml0BF1Dkbmf9MSjsjPd1P9MBpvUqT/tegrhFbd89ssFSTTwF2pwpCvU4kTyPpS7
         TlgMu81OwhTAfrNAhtmwOOgVZIPtycpsCJlN9Ff4izGqfhJT96c5Ynyc4SISWyvanAxX
         QnXZyaAIs2CZsO/I5deo+37iDXuCJXHNhdPni/CRgfrFjKQwJLZWdY5Q43VZUnaw3vfc
         tZPWDHI1XZmHu88wI1W5zooGX3t+vpWTYYoUy0Y8my1HV8sQPFZlqjkbU4aXpFdjQUDr
         J/EQ==
X-Gm-Message-State: AOJu0YxQ4Jr+o6hbfhf0VbE42VAcPDyxZ/vwYLcbj/eYoEjCyTNkCtVR
	7aQ8bGZ2Etoh36/UlViffuGBTf++JCSG1IwyB/B4O9iFuLW+l+BhVKU24RU9ohZy06k=
X-Gm-Gg: ASbGncs8gMB+tHzsberdVZUYd9ntSM5otyRFgoE9Km78BWqro7KT24J1cbp2mAPX7xm
	x8y40LPrppp69D0Rjd4ljUfvOdw+sYgN0qYQzu7GentqmpvakNP78SBK+oevM6MGx2rjilSM4kL
	w0N31h5Zsafi6GnfoD/e394521SfiPi8BJHc+wO6e6gjIb5uxgZaevvKhkAwE0Bt83H7MDZXdhH
	RSSf18gnXYx6+0NzkbL57LUOGBm2CB7uQ2xklMESUv6vftu1uTd2+VHzYCq5Tz4G89Kgn4Lv4bN
	zp1lx7XNBOw65ZK9hYLjzmlXwQ8vqfA7upRM/N1MRRFFVa2NgS7ES3gOPpzrG96n0T7/zi1+EbH
	SpSmJ9GGiKT+b66mYUMXg2KSIqWIIUIK+G222N+4dzW3ueKIOS17dOCuCQqdb38jUBGa9cPsz6V
	zvf+FqnYq4BOBpHKSpbhW+webJ
X-Google-Smtp-Source: AGHT+IG6+wZH12ntItlM10Hkr2ZsWaF//z6tJn2ZixCamvidknEkZeAL5vZ6pP/kX2e5eTRqEdbD1Q==
X-Received: by 2002:a17:906:4fd0:b0:b70:4f7d:24f8 with SMTP id a640c23a62f3a-b72dff16e88mr445647266b.22.1762680287899;
        Sun, 09 Nov 2025 01:24:47 -0800 (PST)
Received: from ice-home.lan ([92.253.236.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bdbd1ecfsm741295766b.10.2025.11.09.01.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Nov 2025 01:24:47 -0800 (PST)
From: Serhii Ivanov <icegood1980@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Serhii Ivanov <icegood1980@gmail.com>
Subject: [PATCH] Added netfilter output plugin with ability to write into pcap nflog packets
Date: Sun,  9 Nov 2025 11:23:05 +0200
Message-ID: <20251109092304.1279619-2-icegood1980@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend inpit nflog plugin
to get more information

Chenged conmfiguration files for
proper dependencies to ntlog/ct/ctacc

Signed-off-by: Serhii Ivanov <icegood1980@gmail.com>
---
 configure.ac                          |   3 +-
 include/ulogd/ulogd.h                 |   2 +-
 input/packet/Makefile.am              |  18 +-
 input/packet/ulogd_inppkt_NFLOG.c     | 111 +++--
 output/Makefile.am                    |  30 +-
 output/pcap/Makefile.am               |  15 +
 output/pcap/ulogd_output_PCAP_NFLOG.c | 573 ++++++++++++++++++++++++++
 output/ulogd_output_XML.c             |   3 +-
 src/ulogd.c                           |   1 +
 ulogd.conf.in                         |   1 +
 10 files changed, 705 insertions(+), 52 deletions(-)
 create mode 100644 output/pcap/ulogd_output_PCAP_NFLOG.c

diff --git a/configure.ac b/configure.ac
index daaf69f..5b55e1c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -45,7 +45,8 @@ AC_ARG_ENABLE([nflog],
               [enable_nflog=$enableval],
               [enable_nflog=yes])
 AS_IF([test "x$enable_nflog" = "xyes"],
-      [PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.2])
+      [PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.5])
+      PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.2])
        AC_DEFINE([BUILD_NFLOG], [1], [Building nflog module])],
       [enable_nflog=no])
 AM_CONDITIONAL([BUILD_NFLOG], [test "x$enable_nflog" = "xyes"])
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 29082df..b0d2236 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -19,7 +19,7 @@
 #include <inttypes.h>
 #include <netinet/in.h>
 #include <string.h>
-#include <config.h>
+#include <config.h> // all config stuff there
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 20c51ec..f63cc6e 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,17 +1,21 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS}
-
 pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
 
 ulogd_inppkt_UNIXSOCK_la_SOURCES = ulogd_inppkt_UNIXSOCK.c
 ulogd_inppkt_UNIXSOCK_la_LDFLAGS = -avoid-version -module
 
 if BUILD_NFLOG
-pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
+    AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
+
+    pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
 
-ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
-ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS) \
-				$(LIBNETFILTER_CONNTRACK_LIBS)
+    ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
+    ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
+    ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS)
+
+if BUILD_NFCT
+    AM_CPPFLAGS += $(LIBMNL_CFLAGS) ${LIBNETFILTER_CONNTRACK_CFLAGS}
+    ulogd_inppkt_NFLOG_la_LIBADD += $(LIBMNL_LIBS) $(LIBNETFILTER_CONNTRACK_LIBS)
+endif
 endif
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index b7042be..4840ddc 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -16,10 +16,15 @@
 #ifdef BUILD_NFCT
 #include <libmnl/libmnl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 #else
 struct nf_conntrack;
 #endif
 
+struct connttrack {
+    struct nf_conntrack *ct;
+    uint32_t info;
+};
 
 #ifndef NFLOG_GROUP_DEFAULT
 #define NFLOG_GROUP_DEFAULT	0
@@ -154,6 +159,8 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_SEQ_LOCAL,
 	NFLOG_KEY_OOB_SEQ_GLOBAL,
 	NFLOG_KEY_OOB_FAMILY,
+    NFLOG_KEY_OOB_VERSION,
+    NFLOG_KEY_OOB_RES_ID,
 	NFLOG_KEY_OOB_PROTOCOL,
 	NFLOG_KEY_OOB_UID,
 	NFLOG_KEY_OOB_GID,
@@ -163,6 +170,7 @@ enum nflog_keys {
 	NFLOG_KEY_RAW_MAC_ADDRLEN,
 	NFLOG_KEY_RAW,
 	NFLOG_KEY_RAW_CT,
+	NFLOG_KEY_CT_INFO,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -304,6 +312,24 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "oob.family",
 	},
+	[NFLOG_KEY_OOB_VERSION] = {
+		.type = ULOGD_RET_UINT8,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.version",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_NETFILTER,
+			.field_id = IPFIX_NF_hook,
+		},
+	},
+	[NFLOG_KEY_OOB_RES_ID] = {
+		.type = ULOGD_RET_UINT16,
+		.flags = ULOGD_RETF_NONE,
+		.name = "oob.resid",
+		.ipfix = {
+			.vendor = IPFIX_VENDOR_IETF,
+			.field_id = IPFIX_flowStartSeconds,
+		},
+	},
 	[NFLOG_KEY_OOB_PROTOCOL] = {
 		.type = ULOGD_RET_UINT16,
 		.flags = ULOGD_RETF_NONE,
@@ -339,47 +365,67 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "ct",
 	},
+	[NFLOG_KEY_CT_INFO] = {
+		.type = ULOGD_RET_UINT32,
+		.flags = ULOGD_RETF_NONE,
+		.name = "ct_info",
+	},
 };
 
-struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg)
+void build_ct(struct nfgenmsg *nfmsg, struct connttrack *res)
 {
 #ifdef BUILD_NFCT
 	struct nlmsghdr *nlh =
 		(struct nlmsghdr *)((void *)nfmsg - sizeof(*nlh));
 	struct nlattr *attr, *ctattr = NULL;
-	struct nf_conntrack *ct;
+	int found = 0;
+
+	res->ct = NULL;
+	res->info = (uint32_t)-1;
 
 	mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
-		if (mnl_attr_get_type(attr) == NFULA_CT) {
-			ctattr = attr;
+		switch (mnl_attr_get_type(attr)) {
+			case NFULA_CT:
+			{
+				ctattr = attr;
+				found |= 1;
+				break;
+			}
+			case NFULA_CT_INFO: {
+				res->info = ntohl(mnl_attr_get_u32(attr));
+				found |= 2;
+				break;
+			}
+        }
+		if (found == 3) {
 			break;
 		}
 	}
-	if (!ctattr)
-		return NULL;
 
-	ct = nfct_new();
-	if (!ct) {
+	if (!ctattr) {
+		ulogd_log(ULOGD_INFO, "ct attribute not present\n");
+        return;
+    }
+
+	res->ct = nfct_new();
+	if (!res->ct) {
 		ulogd_log(ULOGD_ERROR, "failed to allocate nfct\n");
-		return NULL;
+		return;
 	}
 	if (nfct_payload_parse(mnl_attr_get_payload(ctattr),
 			       mnl_attr_get_payload_len(ctattr),
-			       nfmsg->nfgen_family, ct) < 0) {
+			       nfmsg->nfgen_family, res->ct) < 0) {
 		ulogd_log(ULOGD_ERROR, "failed to parse nfct payload\n");
-		nfct_destroy(ct);
-		return NULL;
+		nfct_destroy(res->ct);
+		res->ct = NULL;
+		return;
 	}
-
-	return ct;
-#else
-	return NULL;
 #endif
 }
 
 static inline int
-interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
-	      struct nflog_data *ldata, struct nf_conntrack *ct)
+interp_packet(struct ulogd_pluginstance *upi, struct nfgenmsg *header,
+	      struct nflog_data *ldata, struct connttrack *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
@@ -396,8 +442,9 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
 	uint32_t uid;
 	uint32_t gid;
 
-	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], 
-		    pf_family);
+	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], header->nfgen_family);
+    okey_set_u16(&ret[NFLOG_KEY_OOB_RES_ID], ntohs(header->res_id));
+	okey_set_u8(&ret[NFLOG_KEY_OOB_VERSION], header->version);
 	okey_set_u8(&ret[NFLOG_KEY_RAW_LABEL],
 		    label_ce(upi->config_kset).u.value);
 
@@ -460,8 +507,10 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
 
 	okey_set_ptr(&ret[NFLOG_KEY_RAW], ldata);
 
-	if (ct != NULL)
-		okey_set_ptr(&ret[NFLOG_KEY_RAW_CT], ct);
+	if (ct->ct != NULL) {
+		okey_set_ptr(&ret[NFLOG_KEY_RAW_CT], ct->ct);
+		okey_set_u32(&ret[NFLOG_KEY_CT_INFO], ct->info);
+	}
 
 	ulogd_propagate_results(upi);
 	return 0;
@@ -537,22 +586,24 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 {
 	struct ulogd_pluginstance *upi = data;
 	struct ulogd_pluginstance *npi = NULL;
-	void *ct = build_ct(nfmsg);
+	struct connttrack ct;
 	int ret = 0;
 
+	build_ct(nfmsg, &ct);
+
 	/* since we support the re-use of one instance in several 
 	 * different stacks, we duplicate the message to let them know */
 	llist_for_each_entry(npi, &upi->plist, plist) {
-		ret = interp_packet(npi, nfmsg->nfgen_family, nfa, ct);
+		ret = interp_packet(npi, nfmsg, nfa, &ct);
 		if (ret != 0)
 			goto release_ct;
 	}
-	ret = interp_packet(upi, nfmsg->nfgen_family, nfa, ct);
+	ret = interp_packet(upi, nfmsg, nfa, &ct);
 
 release_ct:
 #ifdef BUILD_NFCT
-	if (ct != NULL)
-		nfct_destroy(ct);
+	if (ct.ct != NULL)
+		nfct_destroy(ct.ct);
 #endif
 
 	return ret;
@@ -598,8 +649,7 @@ static int start(struct ulogd_pluginstance *upi)
 	if ((strlen(target_netns_path) > 0) &&
 	    (join_netns_path(target_netns_path, &source_netns_fd) != ULOGD_IRET_OK)
 	   ) {
-		ulogd_log(ULOGD_FATAL, "error joining target network "
-		                       "namespace\n");
+		ulogd_log(ULOGD_FATAL, "error joining target network namespace\n");
 		goto out_ns;
 	}
 
@@ -611,8 +661,7 @@ static int start(struct ulogd_pluginstance *upi)
 	if ((strlen(target_netns_path) > 0) &&
 	    (join_netns_fd(source_netns_fd, NULL) != ULOGD_IRET_OK)
 	   ) {
-		ulogd_log(ULOGD_FATAL, "error joining source network "
-		                       "namespace\n");
+		ulogd_log(ULOGD_FATAL, "error joining source network namespace\n");
 		goto out_handle;
 	}
 	/* join_netns_fd() closes the fd after successful join */
diff --git a/output/Makefile.am b/output/Makefile.am
index cdb49df..d6e9718 100644
--- a/output/Makefile.am
+++ b/output/Makefile.am
@@ -27,10 +27,6 @@ SUBDIRS = $(OPT_SUBDIR_PCAP) \
 
 include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS += ${LIBNETFILTER_ACCT_CFLAGS} \
-	       ${LIBNETFILTER_CONNTRACK_CFLAGS} \
-	       ${LIBNETFILTER_LOG_CFLAGS}
-
 pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
 			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
 			 ulogd_output_NACCT.la ulogd_output_XML.la \
@@ -55,12 +51,6 @@ ulogd_output_OPRINT_la_LDFLAGS = -avoid-version -module
 ulogd_output_NACCT_la_SOURCES = ulogd_output_NACCT.c
 ulogd_output_NACCT_la_LDFLAGS = -avoid-version -module
 
-ulogd_output_XML_la_SOURCES = ulogd_output_XML.c
-ulogd_output_XML_la_LIBADD  = ${LIBNETFILTER_LOG_LIBS} \
-			      ${LIBNETFILTER_CONNTRACK_LIBS} \
-			      ${LIBNETFILTER_ACCT_LIBS}
-ulogd_output_XML_la_LDFLAGS = -avoid-version -module
-
 ulogd_output_GRAPHITE_la_SOURCES = ulogd_output_GRAPHITE.c
 ulogd_output_GRAPHITE_la_LDFLAGS = -avoid-version -module
 
@@ -69,3 +59,23 @@ ulogd_output_JSON_la_SOURCES = ulogd_output_JSON.c
 ulogd_output_JSON_la_LIBADD  = ${libjansson_LIBS}
 ulogd_output_JSON_la_LDFLAGS = -avoid-version -module
 endif
+
+ulogd_output_XML_la_SOURCES = ulogd_output_XML.c
+ulogd_output_XML_la_LIBADD =
+
+if BUILD_NFLOG
+    AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
+    ulogd_output_XML_la_LIBADD += ${LIBNETFILTER_LOG_LIBS}
+endif
+
+if BUILD_NFCT
+    AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
+    ulogd_output_XML_la_LIBADD += ${LIBNETFILTER_CONNTRACK_LIBS}
+endif
+
+if BUILD_NFACCT
+    AM_CPPFLAGS += ${LIBNETFILTER_ACCT_CFLAGS}
+    ulogd_output_XML_la_LIBADD += ${LIBNETFILTER_ACCT_LIBS}
+endif
+
+ulogd_output_XML_la_LDFLAGS = -avoid-version -module
\ No newline at end of file
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index b5064ea..ecaaa4c 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -7,3 +7,18 @@ pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
 ulogd_output_PCAP_la_LIBADD  = ${libpcap_LIBS}
 ulogd_output_PCAP_la_LDFLAGS = -avoid-version -module
+
+if BUILD_NFLOG
+    AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS}
+
+    pkglib_LTLIBRARIES += ulogd_output_PCAP_NFLOG.la
+
+    ulogd_output_PCAP_NFLOG_la_SOURCES = ulogd_output_PCAP_NFLOG.c
+    ulogd_output_PCAP_NFLOG_la_LIBADD = ${libpcap_LIBS} $(LIBNETFILTER_LOG_LIBS)
+    ulogd_output_PCAP_NFLOG_la_LDFLAGS = -avoid-version -module
+
+if BUILD_NFCT
+    AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
+    ulogd_output_PCAP_NFLOG_la_LIBADD += $(LIBNETFILTER_CONNTRACK_LIBS)
+endif
+endif
diff --git a/output/pcap/ulogd_output_PCAP_NFLOG.c b/output/pcap/ulogd_output_PCAP_NFLOG.c
new file mode 100644
index 0000000..297e27e
--- /dev/null
+++ b/output/pcap/ulogd_output_PCAP_NFLOG.c
@@ -0,0 +1,573 @@
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
+    #include <linux/netfilter/nfnetlink_conntrack.h>
+    #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+    #include <linux/netfilter/nf_conntrack_common.h>
+#endif
+
+#include <pcap/pcap.h>  // for pcap_file_header, PCAP_VERSION_MAJOR/MINOR
+
+#define NFLOG_TLV_FLOW_INFO    19  /* Enriched flow metadata */
+
+#define LINKTYPE_NFLOG  0xEF
+#define TCPDUMP_MAGIC   0xa1b2c3d4
+
+static struct config_keyset pcap_nflog_kset = {
+    .num_ces = 2,
+    .ces = {
+        [0] = { .key = "file", .type = CONFIG_TYPE_STRING, .options = CONFIG_OPT_NONE, .u.string = "/tmp/ulogd_enriched.pcap" },
+        [1] = { .key = "sync", .type = CONFIG_TYPE_INT,    .options = CONFIG_OPT_NONE, .u.value  = 1 }
+    }
+};
+
+struct pcap_nflog_data {
+    FILE *output_file;
+};
+
+enum pcap_nflog_input_keys_id {
+    NFLOG_KEY_RAW_MAC = 0,
+    NFLOG_KEY_RAW_PCKT,
+    NFLOG_KEY_RAW_PCKTLEN,
+    NFLOG_KEY_RAW_PCKTCOUNT,
+    NFLOG_KEY_OOB_PREFIX,
+    NFLOG_KEY_OOB_TIME_SEC,
+    NFLOG_KEY_OOB_TIME_USEC,
+    NFLOG_KEY_OOB_MARK,
+    NFLOG_KEY_OOB_IFINDEX_IN,
+    NFLOG_KEY_OOB_IFINDEX_OUT,
+    NFLOG_KEY_OOB_HOOK,
+    NFLOG_KEY_RAW_MAC_LEN,
+    NFLOG_KEY_OOB_SEQ_LOCAL,
+    NFLOG_KEY_OOB_SEQ_GLOBAL,
+    NFLOG_KEY_OOB_FAMILY,
+    NFLOG_KEY_OOB_VERSION,
+    NFLOG_KEY_OOB_RES_ID,
+    NFLOG_KEY_OOB_PROTOCOL,
+    NFLOG_KEY_OOB_UID,
+    NFLOG_KEY_OOB_GID,
+    NFLOG_KEY_RAW_LABEL,
+    NFLOG_KEY_RAW_TYPE,
+    NFLOG_KEY_RAW_MAC_SADDR,
+    NFLOG_KEY_RAW_MAC_ADDRLEN,
+    NFLOG_KEY_RAW,
+    NFLOG_KEY_RAW_CT,
+    NFLOG_KEY_CT_INFO,
+    __PCAP_NFLOG_INPUT_KEY_MAX
+};
+
+static struct ulogd_key pcap_nflog_input_keys[] = {
+    [NFLOG_KEY_RAW_MAC]        = { .type = ULOGD_RET_RAW,    .name = "raw.mac" },
+    [NFLOG_KEY_RAW_PCKT]       = { .type = ULOGD_RET_RAW,    .name = "raw.pkt" },
+    [NFLOG_KEY_RAW_PCKTLEN]    = { .type = ULOGD_RET_UINT32, .name = "raw.pktlen" },
+    [NFLOG_KEY_RAW_PCKTCOUNT]  = { .type = ULOGD_RET_UINT32, .name = "raw.pktcount" },
+    [NFLOG_KEY_OOB_PREFIX]     = { .type = ULOGD_RET_STRING, .name = "oob.prefix" },
+    [NFLOG_KEY_OOB_TIME_SEC]   = { .type = ULOGD_RET_UINT32, .name = "oob.time.sec" },
+    [NFLOG_KEY_OOB_TIME_USEC]  = { .type = ULOGD_RET_UINT32, .name = "oob.time.usec" },
+    [NFLOG_KEY_OOB_MARK]       = { .type = ULOGD_RET_UINT32, .name = "oob.mark" },
+    [NFLOG_KEY_OOB_IFINDEX_IN] = { .type = ULOGD_RET_UINT32, .name = "oob.ifindex_in" },
+    [NFLOG_KEY_OOB_IFINDEX_OUT]= { .type = ULOGD_RET_UINT32, .name = "oob.ifindex_out" },
+    [NFLOG_KEY_OOB_HOOK]       = { .type = ULOGD_RET_UINT8,  .name = "oob.hook" },
+    [NFLOG_KEY_RAW_MAC_LEN]    = { .type = ULOGD_RET_UINT16, .name = "raw.mac_len" },
+    [NFLOG_KEY_OOB_SEQ_LOCAL]  = { .type = ULOGD_RET_UINT32, .name = "oob.seq.local" },
+    [NFLOG_KEY_OOB_SEQ_GLOBAL] = { .type = ULOGD_RET_UINT32, .name = "oob.seq.global" },
+    [NFLOG_KEY_OOB_FAMILY]     = { .type = ULOGD_RET_UINT8,  .name = "oob.family" },
+    [NFLOG_KEY_OOB_VERSION]     = { .type = ULOGD_RET_UINT8,  .name = "oob.version" },
+    [NFLOG_KEY_OOB_RES_ID]     = { .type = ULOGD_RET_UINT16,  .name = "oob.resid" },
+    [NFLOG_KEY_OOB_PROTOCOL]   = { .type = ULOGD_RET_UINT16, .name = "oob.protocol" },
+    [NFLOG_KEY_OOB_UID]        = { .type = ULOGD_RET_UINT32, .name = "oob.uid" },
+    [NFLOG_KEY_OOB_GID]        = { .type = ULOGD_RET_UINT32, .name = "oob.gid" },
+    [NFLOG_KEY_RAW_LABEL]      = { .type = ULOGD_RET_UINT8,  .name = "raw.label" },
+    [NFLOG_KEY_RAW_TYPE]       = { .type = ULOGD_RET_UINT16, .name = "raw.type" },
+    [NFLOG_KEY_RAW_MAC_SADDR]  = { .type = ULOGD_RET_RAW,    .name = "raw.mac.saddr" },
+    [NFLOG_KEY_RAW_MAC_ADDRLEN]= { .type = ULOGD_RET_UINT16, .name = "raw.mac.addrlen" },
+    [NFLOG_KEY_RAW]            = { .type = ULOGD_RET_RAW,    .name = "raw" },
+    [NFLOG_KEY_RAW_CT]         = { .type = ULOGD_RET_RAW,    .name = "ct" },
+    [NFLOG_KEY_CT_INFO]        = { .type = ULOGD_RET_UINT32, .name = "ct_info" },
+};
+
+#define get(proc,key) (pp_is_valid(pi->input.keys, key) ? ikey_get_ ## proc (&pi->input.keys[key]) : 0)
+
+#define write_section_proc(section, type, getter) \
+{ \
+    uint##type##_t temp = getter; \
+    if (write_nflog_tlv(&buf_ptr, buf_end, section, &temp, sizeof(temp)) < 0) { \
+        return -1; \
+    } \
+}
+
+#define write_section(section, key, type) write_section_proc(section, type, get(u##type, key))
+
+#define write_u32_section(section, key) write_section(section, key, 32)
+#define write_u16_section(section, key) write_section(section, key, 16)
+
+static int write_pcap_header(FILE *f)
+{
+    struct pcap_file_header pcfh;
+    pcfh.magic = TCPDUMP_MAGIC;
+    pcfh.version_major = PCAP_VERSION_MAJOR;
+    pcfh.version_minor = PCAP_VERSION_MINOR;
+    pcfh.thiszone = 0;
+    pcfh.sigfigs = 0;
+    pcfh.snaplen = 4096;
+    pcfh.linktype = LINKTYPE_NFLOG;
+
+    return fwrite(&pcfh, sizeof(pcfh), 1, f) == 1 ? 0 : -1;
+}
+
+static int write_nflog_tlv(char **buf, const char *buf_end, uint16_t type,
+                           const void *data, uint16_t data_len)
+{
+    uint16_t tlv_len = data_len + 4;
+    uint16_t padded_len = (tlv_len + 3) & ~3;
+
+    int delta = *buf + padded_len - buf_end;
+    if (0 <= delta) {
+        ulogd_log(ULOGD_NOTICE, "Cannot write %u. No space left in buffer (above = %d)\n", type, delta);
+        return -1;
+    }
+
+    *(uint16_t*)*buf = tlv_len;
+    *(uint16_t*)(*buf + 2) = type;
+    memcpy(*buf + 4, data, data_len);
+
+    if (padded_len > tlv_len)
+        memset(*buf + tlv_len, 0, padded_len - tlv_len);
+
+    *buf += padded_len;
+    return padded_len;
+}
+
+static uint64_t u32_to_be64(uint32_t x) {
+    uint64_t v = (uint64_t)x;
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+    v = __builtin_bswap64(v);
+#endif
+    return v;
+}
+
+#define nfct_get_attr_(ct, attr_id) (const char*)nfct_get_attr(ct, attr_id)
+
+#define print_ct(fmt, ...) \
+{ \
+    int res = snprintf(flow_info + pos, sizeof(flow_info) - pos, fmt "\n", __VA_ARGS__); \
+    if (res < 0) { \
+        ulogd_log(ULOGD_NOTICE, "CT: cannot write to buffer: %m\n"); \
+        goto print_ct_section; \
+    } \
+    pos += res; \
+}
+
+#define print_ct_attribute(attr_id, format, type) \
+{ \
+    if (nfct_attr_is_set(ct, attr_id)) { \
+        print_ct(format, nfct_get_attr_##type(ct, attr_id)); \
+    } \
+    if (pos >= sizeof(flow_info)) { \
+        goto print_ct_section; \
+    } \
+}
+
+#define print_ct_attribute_pair(attr1, attr2, format, type) \
+{ \
+    if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
+        print_ct(format, nfct_get_attr_##type(ct, attr1), nfct_get_attr_##type(ct, attr2)); \
+    } \
+    if (pos >= sizeof(flow_info)) { \
+        goto print_ct_section; \
+    } \
+}
+
+#define print_ct_ip4_pair(attr1, attr2, format) \
+{ \
+    if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
+        uint32_t ip1_be = nfct_get_attr_u32(ct, attr1); \
+        uint32_t ip2_be = nfct_get_attr_u32(ct, attr2); \
+        \
+        struct in_addr attr1_ip = { .s_addr = ip1_be }; \
+        struct in_addr attr2_ip = { .s_addr = ip2_be }; \
+        \
+        print_ct(format, inet_ntoa(attr1_ip), inet_ntoa(attr2_ip)); \
+    } \
+    \
+    if (pos >= sizeof(flow_info)) { \
+        goto print_ct_section; \
+    } \
+}
+
+#define print_ct_ip6_pair(attr1, attr2, format) \
+{ \
+    if (nfct_attr_is_set(ct, attr1) && nfct_attr_is_set(ct, attr2)) { \
+        const void * ip1_raw = nfct_get_attr(ct, attr1); \
+        const void * ip2_raw = nfct_get_attr(ct, attr2); \
+        \
+        char ip1_str[INET6_ADDRSTRLEN]; \
+        char ip2_str[INET6_ADDRSTRLEN]; \
+        \
+        inet_ntop(AF_INET6, ip1_raw, ip1_str, INET6_ADDRSTRLEN); \
+        inet_ntop(AF_INET6, ip2_raw, ip2_str, INET6_ADDRSTRLEN); \
+        \
+        print_ct(format, ip1_str, ip2_str); \
+    } \
+    \
+    if (pos >= sizeof(flow_info)) { \
+        goto print_ct_section; \
+    } \
+}
+
+static int write_pcap_nflog_packet(struct ulogd_pluginstance *pi, FILE *of)
+{
+    char buffer[4096];
+    char *buf_ptr = buffer;
+    const char *buf_end = buffer + sizeof(buffer);
+#ifdef BUILD_NFCT
+    struct nf_conntrack *ct = get(ptr, NFLOG_KEY_RAW_CT);
+#endif
+    struct nflog_data *nflog = get(ptr, NFLOG_KEY_RAW);
+
+    struct nfgenmsg pkt_hdr = {
+        .nfgen_family=get(u8, NFLOG_KEY_OOB_FAMILY),
+        .version=get(u8, NFLOG_KEY_OOB_VERSION),
+        .res_id=htons(get(u16, NFLOG_KEY_OOB_RES_ID))};
+    memcpy(buf_ptr, &pkt_hdr, sizeof(pkt_hdr));
+    buf_ptr += sizeof(pkt_hdr);
+
+    // ---  NFULA_PACKET_HDR  ---
+    {    struct nfulnl_msg_packet_hdr pkt_hdr_tlv = {
+            .hw_protocol = htons(get(u16, NFLOG_KEY_OOB_PROTOCOL)),
+            .hook = get(u8, NFLOG_KEY_OOB_HOOK),
+            ._pad = 0
+        };
+        if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PACKET_HDR,
+                &pkt_hdr_tlv, sizeof(pkt_hdr_tlv)) < 0) {
+            return -1;
+        }
+    }
+
+    // --- NFULA_MARK --- 
+    write_u32_section(NFULA_MARK, NFLOG_KEY_OOB_MARK);
+
+    // --- NFULA_TIMESTAMP --- 
+    {
+        struct nfulnl_msg_packet_timestamp ts = {
+            .sec = u32_to_be64(get(u32, NFLOG_KEY_OOB_TIME_SEC)),
+            .usec = u32_to_be64(get(u32, NFLOG_KEY_OOB_TIME_USEC))
+        };
+        
+        if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_TIMESTAMP, &ts, sizeof(ts)) < 0) {
+            return -1;
+        }
+    }
+
+    // --- NFULA_IFINDEX_INDEV --- 
+    write_u32_section(NFULA_IFINDEX_INDEV, NFLOG_KEY_OOB_IFINDEX_IN);
+
+    // --- NFULA_IFINDEX_OUTDEV --- 
+    write_u32_section(NFULA_IFINDEX_OUTDEV, NFLOG_KEY_OOB_IFINDEX_OUT);
+
+    // --- NFULA_IFINDEX_PHYSINDEV --- 
+    write_section_proc(NFULA_IFINDEX_PHYSINDEV, 32, nflog_get_physindev(nflog));
+
+    // --- NFULA_IFINDEX_PHYSOUTDEV --- 
+    write_section_proc(NFULA_IFINDEX_PHYSOUTDEV, 32, nflog_get_physoutdev(nflog));
+
+    // ---  NFULA_HWADDR  ---
+    {
+        uint16_t len = get(u16, NFLOG_KEY_RAW_MAC_ADDRLEN);
+
+        if (len > 0) {
+            struct nfulnl_msg_packet_hw temp = {
+                .hw_addrlen = htons(len),
+                .hw_addr = {0},
+            };
+            if (pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_MAC_SADDR)) {
+                void* value = ikey_get_ptr(&pi->input.keys[NFLOG_KEY_RAW_MAC_SADDR]);
+                if (value) {
+                    memcpy(&temp.hw_addr, value, len);
+                }
+            }
+            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_HWADDR, &temp, sizeof(temp)) < 0) {
+                return -1;
+            }
+        }
+    }
+
+    // ---  NFULA_PAYLOAD  ---
+    {
+        void *pkt_data = get(ptr, NFLOG_KEY_RAW_PCKT);
+        uint32_t pkt_len = get(u32, NFLOG_KEY_RAW_PCKTLEN);
+
+        if (pkt_data) {
+            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PAYLOAD, pkt_data, pkt_len) < 0) {
+                return -1;
+            }
+        }
+    }
+
+    // ---  NFULA_PREFIX  ---
+    {    char *prefix = (char *)get(ptr, NFLOG_KEY_OOB_PREFIX);
+
+        if (prefix) {
+            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_PREFIX, prefix, strlen(prefix)) < 0) {
+                return -1;
+            }
+        }
+    }
+
+    // --- NFULA_UID ---
+    write_u32_section(NFULA_UID, NFLOG_KEY_OOB_UID);
+
+    // --- NFULA_SEQ ---
+    write_u32_section(NFULA_SEQ, NFLOG_KEY_OOB_SEQ_LOCAL);
+
+    // --- NFULA_SEQ_GLOBAL ---
+    write_u32_section(NFULA_SEQ_GLOBAL, NFLOG_KEY_OOB_SEQ_GLOBAL);
+
+    // --- NFULA_GID ---
+    write_u32_section(NFULA_GID, NFLOG_KEY_OOB_GID);
+
+    // --- NFULA_HWTYPE ---
+    write_u16_section(NFULA_HWTYPE, NFLOG_KEY_RAW_TYPE);
+    // --- NFULA_HWLEN ---
+    write_u16_section(NFULA_HWLEN, NFLOG_KEY_RAW_MAC_LEN);
+    // --- NFULA_HWHEADER ---
+    {
+        char *data = get(ptr, NFLOG_KEY_RAW_MAC);
+        size_t len = get(u16, NFLOG_KEY_RAW_MAC_LEN);
+
+        if ((len > 0) && (data != NULL)) {
+            if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_HWHEADER, data, len) < 0) {
+                return -1;
+            }
+        }
+    }
+#ifdef BUILD_NFCT
+    if (ct != NULL) {
+        char flow_info[2048];
+        size_t pos = 0;
+
+        // --- NFULA_CT_INFO ---
+        write_u32_section(NFULA_CT_INFO, NFLOG_KEY_CT_INFO);
+
+        // --- NFULA_CT ---
+        print_ct_attribute(ATTR_ID, "id=%u", u32);
+        print_ct_attribute(ATTR_USE, "use=%u", u32);
+        print_ct_attribute(ATTR_STATUS, "status=0x%08x", u32);
+        print_ct_attribute(ATTR_TIMEOUT, "timeout=%u", u32);
+        print_ct_attribute(ATTR_MARK, "mark=%u", u32);
+        print_ct_attribute(ATTR_SECMARK, "security mark=%u", u32);
+        
+        print_ct_attribute_pair(ATTR_ORIG_COUNTER_PACKETS, ATTR_ORIG_COUNTER_BYTES, "orig packets/bytes=%lu/%lu", u64);
+        print_ct_attribute_pair(ATTR_REPL_COUNTER_PACKETS, ATTR_REPL_COUNTER_BYTES, "repl packets/bytes=%lu/%lu", u64);
+        
+        print_ct_ip4_pair(ATTR_ORIG_IPV4_SRC, ATTR_ORIG_IPV4_DST, "orig ip4 src/dest=%s/%s");
+        print_ct_ip6_pair(ATTR_ORIG_IPV6_SRC, ATTR_ORIG_IPV6_DST, "orig ip6 src/dest=%s/%s");
+        print_ct_attribute_pair(ATTR_ORIG_PORT_SRC, ATTR_ORIG_PORT_DST, "orig port src/dest=%u/%u", u16);
+
+
+        print_ct_ip4_pair(ATTR_REPL_IPV4_SRC, ATTR_REPL_IPV4_DST, "repl ip4 src/dest=%s/%s");
+        print_ct_ip6_pair(ATTR_REPL_IPV6_SRC, ATTR_REPL_IPV6_DST, "repl ip6 src/dest=%s/%s");
+        print_ct_attribute_pair(ATTR_REPL_PORT_SRC, ATTR_REPL_PORT_DST, "repl port src/dest=%u/%u", u16);
+        
+        print_ct_attribute_pair(ATTR_ORIG_L3PROTO, ATTR_REPL_L3PROTO, "l3proto orig/repl=%u/%u", u8);
+        print_ct_attribute_pair(ATTR_ORIG_L4PROTO, ATTR_REPL_L4PROTO, "l4proto orig/repl=%u/%u", u8);
+
+        print_ct_ip4_pair(ATTR_MASTER_IPV4_SRC, ATTR_MASTER_IPV4_DST, "master ip4 src/dest=%s/%s");
+        print_ct_ip6_pair(ATTR_MASTER_IPV6_SRC, ATTR_MASTER_IPV6_DST, "master ip6 src/dest=%s/%s");
+        print_ct_attribute_pair(ATTR_MASTER_PORT_SRC, ATTR_MASTER_PORT_DST, "master port src/dest=%u/%u", u16);
+        print_ct_attribute_pair(ATTR_MASTER_L3PROTO, ATTR_MASTER_L4PROTO, "master proto l3/l4=%u/%u", u8);
+
+        print_ct_attribute(ATTR_ZONE, "zone=%u", u16);
+        print_ct_attribute_pair(ATTR_ORIG_ZONE, ATTR_REPL_ZONE, "zone orig/repl=%u/%u", u16);
+        // tcp
+        print_ct_attribute(ATTR_TCP_STATE, "tcp_state=%u", u8);
+        print_ct_attribute_pair(ATTR_TCP_FLAGS_ORIG, ATTR_TCP_FLAGS_REPL, "tcp_flags orig/repl=%u/%u", u8);
+        print_ct_attribute_pair(ATTR_TCP_MASK_ORIG, ATTR_TCP_MASK_REPL, "tcp_mask orig/repl=%u/%u", u8);
+        // icmp
+        print_ct_attribute(ATTR_ICMP_TYPE, "icmp_type=%u", u8);
+        print_ct_attribute(ATTR_ICMP_CODE, "icmp_code=%u", u8);
+        print_ct_attribute(ATTR_ICMP_ID, "icmp_id=%u", u16);
+        // SCTP
+        print_ct_attribute(ATTR_SCTP_STATE, "sctp_state=%u", u8);
+        print_ct_attribute_pair(ATTR_SCTP_VTAG_ORIG, ATTR_SCTP_VTAG_REPL, "sctp vtag orig/repl=%u/%u", u8);
+        // DCCP
+        print_ct_attribute(ATTR_DCCP_STATE, "dccp_state=%u", u8);
+        print_ct_attribute(ATTR_DCCP_ROLE, "dccp_role=%u", u8);
+        print_ct_attribute(ATTR_DCCP_HANDSHAKE_SEQ, "dccp_handshake_seq=%lu", u64);
+
+        print_ct_attribute(ATTR_HELPER_NAME, "helper=%s", );
+        print_ct_attribute(ATTR_HELPER_INFO, "helper info=%s", );
+        print_ct_attribute(ATTR_SECCTX, "sec context=%s", );
+
+        // NAT
+        print_ct_ip4_pair(ATTR_SNAT_IPV4, ATTR_DNAT_IPV4, "NAT ip4 src/dest=%s/%s");
+        print_ct_ip6_pair(ATTR_SNAT_IPV6, ATTR_DNAT_IPV6, "NAT ip6 src/dest=%s/%s");
+        print_ct_attribute_pair(ATTR_SNAT_PORT, ATTR_DNAT_PORT, "NAT port src/dest=%u/%u", u16);
+
+        print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_CORRECTION_POS, ATTR_REPL_NAT_SEQ_CORRECTION_POS, "NAT SEQ Corr Pos orig/repl=%u/%u", u32);
+        print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_OFFSET_BEFORE, ATTR_REPL_NAT_SEQ_OFFSET_BEFORE, "NAT SEQ Offset Bef orig/repl=%u/%u", u32);
+        print_ct_attribute_pair(ATTR_ORIG_NAT_SEQ_OFFSET_AFTER, ATTR_REPL_NAT_SEQ_OFFSET_AFTER, "NAT SEQ Offset After orig/repl=%u/%u", u32);
+
+print_ct_section:
+        if (pos > 0)
+            flow_info[pos - 1] = '\0';
+
+        if (write_nflog_tlv(&buf_ptr, buf_end, NFULA_CT, flow_info, pos) < 0) {
+            return -1;
+        }
+    }
+#endif
+    size_t total_len = buf_ptr - buffer;
+    // ---  PCAP record header  ---
+    struct {
+        uint32_t ts_sec;
+        uint32_t ts_usec;
+        uint32_t caplen;
+        uint32_t len;
+    } ph;
+
+    ph.ts_sec = get(u32, NFLOG_KEY_OOB_TIME_SEC);
+    ph.ts_usec = get(u32, NFLOG_KEY_OOB_TIME_USEC);
+    ph.caplen = total_len;   // length of data written
+    ph.len    = total_len;   // original length on wire
+
+    /* Write PCAP record */
+    if ((fwrite(&ph, sizeof(ph), 1, of) != 1) || (fwrite(buffer, total_len, 1, of) != 1)) {
+        ulogd_log(ULOGD_NOTICE, "Cannot write pcap record\n");
+        return -1;
+    }
+
+    if (pi->config_kset->ces[1].u.value)
+        fflush(of);
+
+    return 0;
+}
+
+static int pcap_nflog_output(struct ulogd_pluginstance *pi)
+{
+    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+
+    if (!pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_PCKT) || !pp_is_valid(pi->input.keys, NFLOG_KEY_RAW_PCKTLEN)) {
+        ulogd_log(ULOGD_NOTICE, "Cannot get payload. Skipping packet\n");
+        return -1;
+    }
+
+        if (!get(ptr, NFLOG_KEY_RAW)) {
+        ulogd_log(ULOGD_NOTICE, "No nflog pointer present\n");
+        return -1;
+    }
+
+    return write_pcap_nflog_packet(pi, data->output_file);
+}
+
+static int reopen_file(struct ulogd_pluginstance *pi)
+{
+    const char *filename = pi->config_kset->ces[0].u.string;
+    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+
+    if (data->output_file)
+        fclose(data->output_file);
+    data->output_file = NULL;
+    
+    FILE *of = fopen(filename, "a");
+    if (!of) {
+        ulogd_log(ULOGD_ERROR, "Cannot create output file %s: %m\n", filename);
+        return -EPERM;
+    }
+    data->output_file = of;
+
+    int empty = 1;
+    struct stat st;
+
+    if (stat(filename, &st) == 0) {
+        empty = st.st_size == 0;
+    }
+
+    if (!empty) {
+        return 0;
+    } else {
+        ulogd_log(ULOGD_NOTICE, "Output '%s' is empty. To write header\n", filename);
+    }
+    
+    if (write_pcap_header(data->output_file) < 0) {
+        ulogd_log(ULOGD_ERROR, "Cannot write header to file '%s'\n", filename);
+        fclose(data->output_file);
+        data->output_file = NULL;
+        return -ENOSPC;
+    }
+    return 0;
+}
+
+static int pcap_nflog_init(struct ulogd_pluginstance *pi)
+{
+    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+    memset(data, 0, sizeof(*data));
+
+    return reopen_file(pi);
+}
+
+static int pcap_nflog_destroy(struct ulogd_pluginstance *pi)
+{
+    struct pcap_nflog_data *data = (struct pcap_nflog_data*)pi->private;
+
+    if (data->output_file) {
+        fclose(data->output_file);
+        data->output_file = NULL;
+    }
+    return 0;
+}
+
+static void pcap_nflog_signal(struct ulogd_pluginstance *upi, int signal)
+{
+    ulogd_log(ULOGD_INFO, "pcap_nflog_signal: Delivered %d \n", signal);
+    if (signal == SIGHUP) {
+        ulogd_log(ULOGD_NOTICE, "reopening capture file\n");
+        reopen_file(upi);
+    }
+}
+
+static struct ulogd_plugin pcap_nflog_plugin = {
+    .name = "PCAP_NFLOG",
+    .input = { .keys = pcap_nflog_input_keys, .num_keys = ARRAY_SIZE(pcap_nflog_input_keys),
+               .type = ULOGD_DTYPE_PACKET | ULOGD_DTYPE_RAW },
+    .output = { .type = ULOGD_DTYPE_SINK },
+    .config_kset = &pcap_nflog_kset,
+    .priv_size = sizeof(struct pcap_nflog_data),
+    .start = pcap_nflog_init,
+    .stop = pcap_nflog_destroy,
+    .signal = &pcap_nflog_signal,
+    .interp = pcap_nflog_output,
+    .version = VERSION,
+};
+
+void __attribute__ ((constructor)) init(void)
+{
+    ulogd_register_plugin(&pcap_nflog_plugin);
+}
\ No newline at end of file
diff --git a/output/ulogd_output_XML.c b/output/ulogd_output_XML.c
index 0e1ae7b..c661174 100644
--- a/output/ulogd_output_XML.c
+++ b/output/ulogd_output_XML.c
@@ -20,7 +20,7 @@
 
 #include <sys/types.h>
 #include <inttypes.h>
-#include "../config.h"
+#include <ulogd/ulogd.h>
 #ifdef BUILD_NFLOG
 #include <libnetfilter_log/libnetfilter_log.h>
 #endif
@@ -30,7 +30,6 @@
 #ifdef BUILD_NFACCT
 #include <libnetfilter_acct/libnetfilter_acct.h>
 #endif
-#include <ulogd/ulogd.h>
 #include <sys/param.h>
 #include <time.h>
 #include <errno.h>
diff --git a/src/ulogd.c b/src/ulogd.c
index 917ae3a..9004286 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1111,6 +1111,7 @@ static int create_stack(const char *option)
 
 	/* add head of pluginstance stack to list of stacks */
 	llist_add(&stack->stack_list, &ulogd_pi_stacks);
+	ulogd_log(ULOGD_DEBUG, "pluginstance stack created: '%s'\n", option);
 	free(buf);
 	return 0;
 
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

