Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6881DC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 11:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43FA861AFB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Nov 2021 11:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344053AbhKRLRs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Nov 2021 06:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343673AbhKRLPr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Nov 2021 06:15:47 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C14C061202
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 03:09:46 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h24so4843478pjq.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2021 03:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ing1lq7/z9U7jk/RXkoZdumqtzcolqZeW9Y4EmMvJV8=;
        b=UQnwqP2uLxjDikUqeFoH6i66QpN/gO4VK8+BML2pJS9r4D2N7uJzfoaX979FF7tjqN
         KREfAg/3CTnRuWKM1L7gZjn5tdyDmltPl2fx9IygknKDB6RK95Bpc+XlTfy7oCUqLBZb
         gSM6zBueb2xhI0gseXbRLfFKLip0BPAES/i4GFTj/YxgUGiDJN2rjC38L4JBZP/cTSaC
         LfH+Gcx0GJv3fERz+6k11V5Q7uGeop+BW1bz/+/bOCjXXNXPvimCGnKuCUHLSBPVLr93
         7r2ePwVxa8uANlmHI6L39twL1VunhqMefztU4tWcMYV8zuUQNAEdkgO/xAFShgKMQ8EX
         EfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ing1lq7/z9U7jk/RXkoZdumqtzcolqZeW9Y4EmMvJV8=;
        b=AJvrbO75O0puqiWKvuudzrksyttFvhnsle1g8/Mh9dEsN8kAeGo7JL1lRuPeTcVgp8
         tl4pN9/xQMjRHMhgdX6EyKDjnk1j/1jBaNvzNvccqzF+EgYjw5KWkqgLaV3eDk5ElTlf
         R/ftq+FUQpU63WeONfmuoItWATuE+BMp7N3CepjzNOGjWYzYH9+FZb8piuSYaD2jQUs/
         o2fMfDmGup6u2GogcIxNTRdcOSSxkllHshwMg2lL2KSkLqRhvBCXJ3WA9dq8r6jT83em
         2Rx9ti9Owo2ed7aVX8vMTEttsHYBS+HPEbkH1AHNU/4dC9vHVc1TfPgjBYrbrB0d0HvO
         WDpQ==
X-Gm-Message-State: AOAM533ZjprOEQV3TPt7GnpBxVyaEE4Ta8gxHW90UrTIzBO9iEFj92wT
        4uoMeBtRcpdZDGcViyI/WYursr4wGfEvFQ==
X-Google-Smtp-Source: ABdhPJwhwqq1QzaHc5Ssb0/Kbj1xPXBhiBgYjnpPdDZG6JMT5qqvYxSigYJgcOPzu0nrEjKLqGQvAg==
X-Received: by 2002:a17:90a:4b47:: with SMTP id o7mr9563408pjl.92.1637233786405;
        Thu, 18 Nov 2021 03:09:46 -0800 (PST)
Received: from faith.kottiga.ml ([240f:82:1adf:1:cee1:d5ff:fe3f:5153])
        by smtp.gmail.com with ESMTPSA id f21sm3120669pfe.69.2021.11.18.03.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:09:46 -0800 (PST)
Sender: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
From:   Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
To:     netfilter-devel@vger.kernel.org
Cc:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: [PATCHv2 ulogd 2/2] NFLOG: attach struct nf_conntrack
Date:   Thu, 18 Nov 2021 20:09:19 +0900
Message-Id: <20211118110918.18944-1-chamas@h4.dion.ne.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <YX1CnY+TPBZuYC8R@azazel.net>
References: <YX1CnY+TPBZuYC8R@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

put nf_conntrack in ct outputkey when "attach_conntrack" is specified.
But there is no way to show both nflog "raw" and "ct" now.

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
index 449c0c6..34f7fe3 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -12,6 +12,13 @@
 #include <ulogd/ulogd.h>
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnetfilter_log/libnetfilter_log.h>
+#ifdef BUILD_NFCT
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#else
+struct nf_conntrack;
+#endif
+
 
 #ifndef NFLOG_GROUP_DEFAULT
 #define NFLOG_GROUP_DEFAULT	0
@@ -148,6 +155,7 @@ enum nflog_keys {
 	NFLOG_KEY_RAW_MAC_SADDR,
 	NFLOG_KEY_RAW_MAC_ADDRLEN,
 	NFLOG_KEY_RAW,
+	NFLOG_KEY_RAW_CT,
 };
 
 static struct ulogd_key output_keys[] = {
@@ -319,11 +327,51 @@ static struct ulogd_key output_keys[] = {
 		.flags = ULOGD_RETF_NONE,
 		.name = "raw",
 	},
+	[NFLOG_KEY_RAW_CT] = {
+		.type = ULOGD_RET_RAW,
+		.flags = ULOGD_RETF_NONE,
+		.name = "ct",
+	},
 };
 
+struct nf_conntrack *build_ct(struct nfgenmsg *nfmsg) {
+#ifdef BUILD_NFCT
+	struct nlattr *attr, *ctattr = NULL;
+	struct nf_conntrack *ct = NULL;
+	struct nlmsghdr *nlh
+		= (struct nlmsghdr *)((void *)nfmsg - sizeof(*nlh));
+
+	mnl_attr_for_each(attr, nlh, sizeof(struct nfgenmsg)) {
+		if (mnl_attr_get_type(attr) == NFULA_CT) {
+			ctattr = attr;
+			break;
+		}
+	}
+	if (ctattr == NULL)
+		return NULL;
+	
+	ct = nfct_new();
+	if (ct == NULL) {
+		ulogd_log(ULOGD_ERROR, "failed to allocate nfct\n");
+		return NULL;
+	}
+	if (nfct_payload_parse(mnl_attr_get_payload(ctattr),
+			       mnl_attr_get_payload_len(ctattr),
+			       nfmsg->nfgen_family, ct) < 0) {
+		ulogd_log(ULOGD_ERROR, "failed to parse nfct payload\n");
+		nfct_destroy(ct);
+		return NULL;
+	}
+	
+	return ct;
+#else
+	return NULL;
+#endif
+}
+
 static inline int
 interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
-	      struct nflog_data *ldata)
+	      struct nflog_data *ldata, struct nf_conntrack *ct)
 {
 	struct ulogd_key *ret = upi->output.keys;
 
@@ -404,6 +452,9 @@ interp_packet(struct ulogd_pluginstance *upi, uint8_t pf_family,
 
 	okey_set_ptr(&ret[NFLOG_KEY_RAW], ldata);
 
+	if (ct != NULL)
+		okey_set_ptr(&ret[NFLOG_KEY_RAW_CT], ct);
+
 	ulogd_propagate_results(upi);
 	return 0;
 }
@@ -479,15 +530,24 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 	struct ulogd_pluginstance *upi = data;
 	struct ulogd_pluginstance *npi = NULL;
 	int ret = 0;
+	void *ct = build_ct(nfmsg);
 
 	/* since we support the re-use of one instance in several 
 	 * different stacks, we duplicate the message to let them know */
 	llist_for_each_entry(npi, &upi->plist, plist) {
-		ret = interp_packet(npi, nfmsg->nfgen_family, nfa);
+		ret = interp_packet(npi, nfmsg->nfgen_family, nfa, ct);
 		if (ret != 0)
-			return ret;
+			goto release_ct;
 	}
-	return interp_packet(upi, nfmsg->nfgen_family, nfa);
+	ret = interp_packet(upi, nfmsg->nfgen_family, nfa, ct);
+
+release_ct:
+#ifdef BUILD_NFCT
+	if (ct != NULL)
+		nfct_destroy(ct);
+#endif
+
+	return ret;
 }
 
 static int configure(struct ulogd_pluginstance *upi,
-- 
2.30.2

