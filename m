Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BABC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 11:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC2960524
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Oct 2021 11:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhJLLSw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Oct 2021 07:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbhJLLSw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Oct 2021 07:18:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC978C061570
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 04:16:50 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so1692830pjq.0
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Oct 2021 04:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7IuhC8aLvvSvDYBGShh01VmZDb5wgZvI8ESTYYxtpJE=;
        b=QrZG4k7kBJioH+5yShRVUVdPTvxIklo5rH2L8P4XyaTsm8rn+rfRJNNFtNMmgNzgIS
         KRApq/TRoS8k1ZzD4Nz00QVDSguOwgQs9av8ffZWHvR4AtFRwRRna/e4M8YddbLXdf3p
         yuPmy96tBNTXZrsyyKIoQVGXpEM6tC8b10XZYUsUNXZvHAUTwOvP/ueameMfftmTuRaS
         d0+Mm1bpWWHD3YB7nT7xunXPUg2KZ0L5BnorLf8eR/CYYE8aWyqSMFG9iDlrArdgM2/y
         TJle1tYD5h8gVnp2irLCB9/ekr/Rfi8phfoSKL/oU+F2Iw/hw/Rfls+/lZBq+8sPGzfQ
         CzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=7IuhC8aLvvSvDYBGShh01VmZDb5wgZvI8ESTYYxtpJE=;
        b=kzxX++iVN4FNxVbrUuM1WdvA3a6mfXMsCdLlvsxbwnOTOSN151LvjkP6Z9T86LHaAu
         5/KdpAAf1qIfqdAv2jRBtt43onqfgx+wu1+XJ95iWIy13cLbhyAdcGbpklcvzS+nzYDj
         omup0G+ZyGN952VJNWrucXVzqUB4EELtHfUbpGRDh6dZccEAe6oibxIG2J+I9hI1gqKO
         nFD/tKIbCrsVp3yOCX9PwMyCf5cQo+v38Rz7lWkuselosDLEjB32meu9ZS/1JVplJyX+
         K1mqYmf1zl9auGGKvWag/cDHWHDCYvrlVnfHsyJK5HPg+0RNFqZmsdIv+XJPqPVVQcwV
         o4Wg==
X-Gm-Message-State: AOAM533/ehdCdFMDV7sTNI6VuqA4/zazP/4Lpj/ZAJlDS6DNc3m1aH4A
        YM9q9ipeRRx9RRoDkcTMwT7ETioOqIs=
X-Google-Smtp-Source: ABdhPJxkppHi3BwOxKmLSPNX12VkflY1uAAQBeRFymJhIfGXNhdJ/2Z5KPXQIllpX9t8Tc2aTqL+zw==
X-Received: by 2002:a17:90a:1a06:: with SMTP id 6mr5340343pjk.150.1634037410426;
        Tue, 12 Oct 2021 04:16:50 -0700 (PDT)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id om5sm2636026pjb.36.2021.10.12.04.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 04:16:50 -0700 (PDT)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCH ulogd 2/2] NFLOG: attach struct nf_conntrack
Date:   Tue, 12 Oct 2021 20:16:37 +0900
Message-Id: <20211012111636.81419-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

put nf_conntrack in ct output key when 'attach_conntrack' is specified.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 input/packet/Makefile.am          |  5 ++-
 input/packet/ulogd_inppkt_NFLOG.c | 68 +++++++++++++++++++++++++++++--
 2 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 1c3151d..0f9c316 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_LOG_CFLAGS}
+AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_LOG_CFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
 
 pkglib_LTLIBRARIES = ulogd_inppkt_UNIXSOCK.la
@@ -13,7 +13,8 @@ pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
 endif
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
+ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS) \
+                                 $(LIBNETFILTER_CONNTRACK_LIBS)
 
 ulogd_inppkt_ULOG_la_SOURCES = ulogd_inppkt_ULOG.c
 ulogd_inppkt_ULOG_la_LDFLAGS = -avoid-version -module
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index ea6fb0e..c8b1836 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -12,6 +12,11 @@
 #include <ulogd/ulogd.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
+#ifdef BUILD_NFCT
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#endif
+
 
 #ifndef NFLOG_GROUP_DEFAULT
 #define NFLOG_GROUP_DEFAULT	0
@@ -148,6 +153,7 @@ enum nflog_keys {
 	NFLOG_KEY_RAW_MAC_SADDR,
 	NFLOG_KEY_RAW_MAC_ADDRLEN,
 	NFLOG_KEY_RAW,
+	NFLOG_KEY_RAW_CT,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -319,11 +325,53 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw",
 	},
+	[NFLOG_KEY_RAW_CT] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "ct",
+	},
 };
 
+#ifdef BUILD_NFCT
+struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg) {
+        struct nlattr *attr, *ctattr = NULL;
+        struct nf_conntrack *ct = NULL;
+        struct nlmsghdr *nlh
+                = (struct nlmsghdr *)((void *)nfmsg - sizeof(*nlh));
+
+        mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
+                if (mnl_attr_get_type(attr) == NFULA_CT) {
+                        ctattr = attr;
+                        break;
+                }
+        }
+        if (ctattr == NULL)
+                return NULL;
+
+        ct = nfct_new();
+        if (ct == NULL) {
+                ulogd_log(ULOGD_ERROR, "failed to allocate nfct\n");
+                return NULL;
+        }
+        if (nfct_payload_parse(mnl_attr_get_payload(ctattr),
+                               mnl_attr_get_payload_len(ctattr),
+                               nfmsg->nfgen_family, ct) < 0) {
+                ulogd_log(ULOGD_ERROR, "failed to parse nfct payload\n");
+                nfct_destroy(ct);
+                return NULL;
+        }
+
+        return ct;
+}
+#else
+void *build_ct(struct nfgenmsg *nfmsg) {
+        return NULL;
+}
+#endif
+
 static inline int
 interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
-	      struct nflog_data *ldata)
+	      struct nflog_data *ldata, void *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
@@ -404,6 +452,9 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
 
 	okey_set_ptr(&ret[NFLOG_KEY_RAW], ldata);
 
+        if (ct != NULL)
+                okey_set_ptr(&ret[NFLOG_KEY_RAW_CT], ct);
+
 	ulogd_propagate_results(upi);
 	return 0;
 }
@@ -479,15 +530,24 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 	struct ulogd_pluginstance *upi = data;
 	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
+        void *ct = build_ct(nfmsg);
 
 	/* since we support the re-use of one instance in several 
 	 * different stacks, we duplicate the message to let them know */
 	llist_for_each_entry(npi, &upi->plist, plist) {
-		ret = interp_packet(npi, nfmsg->nfgen_family, nfa);
+		ret = interp_packet(npi, nfmsg->nfgen_family, nfa, ct);
 		if (ret != 0)
-			return ret;
+                        goto release_ct;
 	}
-	return interp_packet(upi, nfmsg->nfgen_family, nfa);
+        ret = interp_packet(upi, nfmsg->nfgen_family, nfa, ct);
+
+release_ct:
+#ifdef BUILD_NFCT
+        if (ct != NULL)
+                nfct_destroy(ct);
+#endif
+
+        return ret;
 }
 
 static int configure(struct ulogd_pluginstance *upi,
-- 
2.30.2

