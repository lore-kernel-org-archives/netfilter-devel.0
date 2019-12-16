Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1851AC2D0BF
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED3F9206D3
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfLPMrH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:47:07 -0500
Received: from correo.us.es ([193.147.175.20]:37354 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727605AbfLPMrH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 07:47:07 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28502127C91
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17E9CDA71F
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0B03BDA717; Mon, 16 Dec 2019 13:47:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3F17DA70C
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 13:47:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DD64D4265A5A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:01 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/2] udata: support for TLV attribute nesting
Date:   Mon, 16 Dec 2019 13:46:59 +0100
Message-Id: <20191216124659.357458-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191216124659.357458-1-pablo@netfilter.org>
References: <20191216124659.357458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds nftnl_udata_nest_start() and nftnl_udata_nest_end()
to build attribute nests.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/udata.h |  5 +++++
 src/libnftnl.map         |  5 +++++
 src/udata.c              | 17 +++++++++++++++++
 3 files changed, 27 insertions(+)

diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index 591fa77aa5e7..8044041189b1 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -75,6 +75,11 @@ bool nftnl_udata_put_u32(struct nftnl_udata_buf *buf, uint8_t type,
 bool nftnl_udata_put_strz(struct nftnl_udata_buf *buf, uint8_t type,
 			  const char *strz);
 
+/* nest */
+struct nftnl_udata *nftnl_udata_nest_start(struct nftnl_udata_buf *buf,
+					   uint8_t type);
+void nftnl_udata_nest_end(struct nftnl_udata_buf *buf, struct nftnl_udata *ud);
+
 /* nftnl_udata_attr */
 uint8_t nftnl_udata_type(const struct nftnl_udata *attr);
 uint8_t nftnl_udata_len(const struct nftnl_udata *attr);
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 8230d1519e8e..5ba8d995440e 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -359,3 +359,8 @@ LIBNFTNL_13 {
   nftnl_obj_set_data;
   nftnl_flowtable_set_data;
 } LIBNFTNL_12;
+
+LIBNFTNL_14 {
+  nftnl_udata_nest_start;
+  nftnl_udata_nest_end;
+} LIBNFTNL_13;
diff --git a/src/udata.c b/src/udata.c
index 9f17395833b8..a47f9239abf8 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -150,3 +150,20 @@ int nftnl_udata_parse(const void *data, uint32_t data_len, nftnl_udata_cb_t cb,
 
 	return ret;
 }
+
+EXPORT_SYMBOL(nftnl_udata_nest_start);
+struct nftnl_udata *nftnl_udata_nest_start(struct nftnl_udata_buf *buf,
+                                           uint8_t type)
+{
+	struct nftnl_udata *ud = nftnl_udata_end(buf);
+
+	nftnl_udata_put(buf, type, 0, NULL);
+
+	return ud;
+}
+
+EXPORT_SYMBOL(nftnl_udata_nest_end);
+void nftnl_udata_nest_end(struct nftnl_udata_buf *buf, struct nftnl_udata *ud)
+{
+	ud->len = buf->end - (char *)ud;
+}
-- 
2.11.0

