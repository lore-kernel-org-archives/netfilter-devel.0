Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UPPERCASE_50_75,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E37CC43603
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EFA9206D3
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 12:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfLPMrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 07:47:06 -0500
Received: from correo.us.es ([193.147.175.20]:37340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727557AbfLPMrF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 07:47:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 312CF127C78
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 229F3DA703
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 17D59DA711; Mon, 16 Dec 2019 13:47:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0659BDA703
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 13:47:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DE24E4265A5A
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 13:47:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 1/2] udata: add NFTNL_UDATA_SET_*TYPEOF* definitions
Date:   Mon, 16 Dec 2019 13:46:58 +0100
Message-Id: <20191216124659.357458-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/udata.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index dd2f3dfd9bfe..591fa77aa5e7 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -22,10 +22,19 @@ enum nftnl_udata_set_types {
 	NFTNL_UDATA_SET_KEYBYTEORDER,
 	NFTNL_UDATA_SET_DATABYTEORDER,
 	NFTNL_UDATA_SET_MERGE_ELEMENTS,
+	NFTNL_UDATA_SET_KEY_TYPEOF,
+	NFTNL_UDATA_SET_DATA_TYPEOF,
 	__NFTNL_UDATA_SET_MAX
 };
 #define NFTNL_UDATA_SET_MAX (__NFTNL_UDATA_SET_MAX - 1)
 
+enum {
+	NFTNL_UDATA_SET_TYPEOF_EXPR,
+	NFTNL_UDATA_SET_TYPEOF_DATA,
+	__NFTNL_UDATA_SET_TYPEOF_MAX,
+};
+#define NFTNL_UDATA_SET_TYPEOF_MAX (__NFTNL_UDATA_SET_TYPEOF_MAX - 1)
+
 enum nftnl_udata_set_elem_types {
 	NFTNL_UDATA_SET_ELEM_COMMENT,
 	NFTNL_UDATA_SET_ELEM_FLAGS,
-- 
2.11.0

