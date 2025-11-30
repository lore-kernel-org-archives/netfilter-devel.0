Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629622C0261
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2025 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764523137; cv=none; b=iZrybMh8O5GvbdmVWCM4rCy83YyQfKysoaCpGSGLNhDbJaih5OwgjyQbpU5H3r7eMRSdSyB/PGXrkyHsfzNwUjYfNrO1Afpu54vP4niI+9J98ZhFSUw2g3lfOlpQPNIE2Mhk836nodbotF9wrBZhsqzFDhhN0N7dlnaUW5mBbBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764523137; c=relaxed/simple;
	bh=IWnLA6jKzT2jX8yujm0ezjEe/jzO7sDLhXw/6HuOS84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iro01Kw8or99qevJ3ifDhAmlzTQlJ+e83Mwkq9hnelxl5ZuL/ZVQV+GaWTPfdgi6UwLaeQ6Y9Sq4+vCn557iQwDl/gMDZBKe+iZmtvSoDWW5F5Rd3m+vn3PRwGjqu7SFnEXunz22kw+QVgizaftee6pyxx+kvbGWyo82Q+MYWHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NUBFiio2; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NUBFiio2"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so5073217a12.2
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Nov 2025 09:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764523132; x=1765127932; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qpketwB83/ZBGgms2stCtuCEnyyCazuZpfJpyVjW0do=;
        b=NUBFiio2QBq6NnrQzs8gtloWM7tVSdPltiT16Ts+OByc1lsKpC7FolqvWmIivLrxtL
         pDr0+cukmCn436lc+TdJj1Mcg82Zo1BX6ZlrRDC/jIt2d6KTJoWP1yLvaYx/M/oBPBwu
         kO4wyKw6hj6S63VrGfli3pzcgMZK5myRe4rdyGIX3phzHE68aHnzFnXtSsidhscIzaFF
         D27HVZwVJuHGVZcsJJLv46o+jwNaJGUh+GU5xU8DeSq2RTWzBNt7WYGALEFYLEhiOnu0
         +YSxUtMTpZraMLO5xsaivGzSgrbnBRl1JQEUi7ws7GW2tlondH7blR2tFciahA4xCxey
         It0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764523132; x=1765127932;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qpketwB83/ZBGgms2stCtuCEnyyCazuZpfJpyVjW0do=;
        b=LTGBqTzr97zW44g/+ZFQlnpiJUuVAGvcn0c8gu7JB5ri53HCYgs292B+0pDrzRiyUk
         MlxFz8L43/Zal0/PfwhT6n0W6Vn1AIiwGRT+/DKuFoihn4lm/skAyIAtSxsfRyMDTV2h
         NsKjq9ymhs2aYNEurKwnKYiv4GeUtU4wwY+jfRzaz3JU57G9Zi9QPOj+gf9PDhwxmXO/
         LPKXEQ/XF8WZnviwjMIEPajIM7md7/FktCZ0jIySlY1VtdGO8MdlnUY1hy7fKyxU1TYe
         4Lo3e+LjJKgM+N5fenCSBXgDVJIYGXejmAvZRJDSK/0I7ETuh/vY+L77Oc7c9QUmiDOy
         YiQA==
X-Gm-Message-State: AOJu0YyMp2sDkMJ5tMa9NtIT4w8hoLtIch9K7XTrQ7deUgzGhaQea6tZ
	S9gYOCcM+LCkrbl1hNhvxCp5KK+G5itrVtY9qZUxiZ39DMqTX82oGBeXLIzrng==
X-Gm-Gg: ASbGncszu6bBGlz/JXcIrdQcHbskihi6LtG6Yap0E9YMk7LQhL51GuFos46GOG4pyxH
	rNuuY9Im+PsD3h2Ci0+hGCxkbyoMBItD5LavyDSm2a9Pu2f0HbTWMUmonMhzoAmFxjFL1ukdW3m
	NUaFy21u6YD4DjmUmirJZ+HxdRZIEir/mp+A7lC+FRYi0mpnWRsuUs/Fk7zzJ0lZq7UL7E0Qgy3
	1dbTIOJP0YrVaYVwdLw3QzuxKKl9bPGu6mVfHhEVlZULLTU/KKYgejSLaf03LqDrPPKt1XJIrHQ
	KvblhT4Mcx57vWcXUPBhWwqAKPgx1VQWdZBcp0X2u1VsD4CF7IqmVLelrf/pUU/HkrGwelB8jMt
	/lChiL7o8+lWra9mUBKwUOsBzpt2QVBFvoTEhPgbGUmx8KPcsh3xAFBgJ0Cv92hSEwsBQQvIkVv
	7K6uvYZ/4yR45/NQ==
X-Google-Smtp-Source: AGHT+IEkQdeqUbMX3rLcoFAOvZPy38ArueyUuMNtRWNcomwuNkEr1dwBS/hEDb+fFvsXnQN6uNX9yA==
X-Received: by 2002:a17:907:7248:b0:b76:23b0:7d6f with SMTP id a640c23a62f3a-b76718cef3amr3550049366b.56.1764523132048;
        Sun, 30 Nov 2025 09:18:52 -0800 (PST)
Received: from ice-home.lan ([92.253.236.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f519e331sm1003143166b.24.2025.11.30.09.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 09:18:51 -0800 (PST)
From: Serhii Ivanov <icegood1980@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Serhii Ivanov <icegood1980@gmail.com>
Subject: [PATCH] Update nlog plufin to provide more information to other ones
Date: Sun, 30 Nov 2025 19:18:47 +0200
Message-ID: <20251130171847.2585455-1-icegood1980@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CT_INFO is absolutely necessary while rther are not due to presence of
NFLOG_KEY_RAW. Anyway i did this way

Added missed dependency on LIBMNL here
---
 configure.ac                      |   3 +-
 input/packet/Makefile.am          |   5 +-
 input/packet/ulogd_inppkt_NFLOG.c | 105 ++++++++++++++++++++++--------
 3 files changed, 83 insertions(+), 30 deletions(-)

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
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 20c51ec..79a7ddb 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,6 +1,6 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS}
+AM_CPPFLAGS += ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS} ${LIBMNL_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
 
@@ -12,6 +12,7 @@ pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
 ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
-ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS) \
+ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBMNL_LIBS) \
+				$(LIBNETFILTER_LOG_LIBS) \
 				$(LIBNETFILTER_CONNTRACK_LIBS)
 endif
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index b7042be..1e69369 100644
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
 
+struct conn_track_info {
+    struct nf_conntrack *ct;
+    uint32_t info;
+};
 
 #ifndef NFLOG_GROUP_DEFAULT
 #define NFLOG_GROUP_DEFAULT	0
@@ -154,6 +159,8 @@ enum nflog_keys {
 	NFLOG_KEY_OOB_SEQ_LOCAL,
 	NFLOG_KEY_OOB_SEQ_GLOBAL,
 	NFLOG_KEY_OOB_FAMILY,
+	NFLOG_KEY_OOB_VERSION,
+	NFLOG_KEY_OOB_RES_ID,
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
+void build_ct(struct nfgenmsg *nfmsg, struct conn_track_info *res)
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
+	      struct nflog_data *ldata, struct conn_track_info *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
@@ -396,8 +442,9 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
 	uint32_t uid;
 	uint32_t gid;
 
-	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], 
-		    pf_family);
+	okey_set_u8(&ret[NFLOG_KEY_OOB_FAMILY], header->nfgen_family);
+	okey_set_u16(&ret[NFLOG_KEY_OOB_RES_ID], ntohs(header->res_id));
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
+	struct conn_track_info ct;
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
-- 
2.51.0

