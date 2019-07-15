Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F62EC76191
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 15:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D049205ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 15:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbfGOP7N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 11:59:13 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55112 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730436AbfGOP7N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 11:59:13 -0400
Received: from chpebeni.pebenito.net (pool-108-15-23-247.bltmmd.fios.verizon.net [108.15.23.247])
        by linux.microsoft.com (Postfix) with ESMTPSA id 8A55820B7185
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 08:59:12 -0700 (PDT)
From:   Chris PeBenito <chpebeni@linux.microsoft.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libiptc] libip6tc.h: Add extern "C" wrapping for C++ linking.
Date:   Mon, 15 Jul 2019 11:58:55 -0400
Message-Id: <20190715155855.4415-1-chpebeni@linux.microsoft.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Chris PeBenito <chpebeni@linux.microsoft.com>
---
 include/libiptc/libip6tc.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 9aed80a0..eaf34d65 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -12,6 +12,10 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/xtcshared.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 #define ip6tc_handle xtc_handle
 #define ip6t_chainlabel xt_chainlabel
 
@@ -158,4 +162,8 @@ extern void dump_entries6(struct xtc_handle *const);
 
 extern const struct xtc_ops ip6tc_ops;
 
+#ifdef __cplusplus
+} /* extern "C" */
+#endif
+
 #endif /* _LIBIP6TC_H */
-- 
2.21.0

