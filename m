Return-Path: <SRS0=PuwI=UG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE22FC2BCA1
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 00:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978D4206DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Jun 2019 00:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="hYqPXp/B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfFGAgv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 20:36:51 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58476 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbfFGAgv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 20:36:51 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id B24F11A3043
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jun 2019 17:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1559867810; bh=nsz3hDS+lwbX4/XWryJ81sqCiRvrezAg+YcHRaqirkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYqPXp/Bcq87zLpqbwNZqAEywDPCMYvYXYuGVQDp1iHy3I5ExD+ZOyTAEWyKkg89b
         ZV5BQFoM8uy++ZVCVagzV0XVAYw7wlezcOwMPLK+YpwhaupGmGhWAhOqihoQYs6rx8
         dMOQX3qssaFNccOmD/8lh/USafYc5vq+sTePzWls=
X-Riseup-User-ID: 36341212F20331A8AA2E3DEE1E7AC08886F67A58ABAC2976A1720038A18AA4F5
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id E6DAF2238A5;
        Thu,  6 Jun 2019 17:36:49 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v4 1/3] netfilter: synproxy: add common uapi for SYNPROXY infrastructure
Date:   Fri,  7 Jun 2019 02:36:02 +0200
Message-Id: <20190607003603.7758-2-ffmancera@riseup.net>
In-Reply-To: <20190607003603.7758-1-ffmancera@riseup.net>
References: <20190607003603.7758-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new UAPI file is going to be used by the xt and nft common SYNPROXY
infrastructure. It is needed to avoid duplicated code.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/uapi/linux/netfilter/nf_SYNPROXY.h | 19 +++++++++++++++++++
 include/uapi/linux/netfilter/xt_SYNPROXY.h | 18 +++++++-----------
 2 files changed, 26 insertions(+), 11 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/nf_SYNPROXY.h

diff --git a/include/uapi/linux/netfilter/nf_SYNPROXY.h b/include/uapi/linux/netfilter/nf_SYNPROXY.h
new file mode 100644
index 000000000000..068d1b3a6f06
--- /dev/null
+++ b/include/uapi/linux/netfilter/nf_SYNPROXY.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NF_SYNPROXY_H
+#define _NF_SYNPROXY_H
+
+#include <linux/types.h>
+
+#define NF_SYNPROXY_OPT_MSS		0x01
+#define NF_SYNPROXY_OPT_WSCALE		0x02
+#define NF_SYNPROXY_OPT_SACK_PERM	0x04
+#define NF_SYNPROXY_OPT_TIMESTAMP	0x08
+#define NF_SYNPROXY_OPT_ECN		0x10
+
+struct nf_synproxy_info {
+	__u8	options;
+	__u8	wscale;
+	__u16	mss;
+};
+
+#endif /* _NF_SYNPROXY_H */
diff --git a/include/uapi/linux/netfilter/xt_SYNPROXY.h b/include/uapi/linux/netfilter/xt_SYNPROXY.h
index ea5eba15d4c1..4d5611d647df 100644
--- a/include/uapi/linux/netfilter/xt_SYNPROXY.h
+++ b/include/uapi/linux/netfilter/xt_SYNPROXY.h
@@ -2,18 +2,14 @@
 #ifndef _XT_SYNPROXY_H
 #define _XT_SYNPROXY_H
 
-#include <linux/types.h>
+#include <linux/netfilter/nf_SYNPROXY.h>
 
-#define XT_SYNPROXY_OPT_MSS		0x01
-#define XT_SYNPROXY_OPT_WSCALE		0x02
-#define XT_SYNPROXY_OPT_SACK_PERM	0x04
-#define XT_SYNPROXY_OPT_TIMESTAMP	0x08
-#define XT_SYNPROXY_OPT_ECN		0x10
+#define XT_SYNPROXY_OPT_MSS		NF_SYNPROXY_OPT_MSS
+#define XT_SYNPROXY_OPT_WSCALE		NF_SYNPROXY_OPT_WSCALE
+#define XT_SYNPROXY_OPT_SACK_PERM	NF_SYNPROXY_OPT_SACK_PERM
+#define XT_SYNPROXY_OPT_TIMESTAMP	NF_SYNPROXY_OPT_TIMESTAMP
+#define XT_SYNPROXY_OPT_ECN		NF_SYNPROXY_OPT_ECN
 
-struct xt_synproxy_info {
-	__u8	options;
-	__u8	wscale;
-	__u16	mss;
-};
+#define xt_synproxy_info		nf_synproxy_info
 
 #endif /* _XT_SYNPROXY_H */
-- 
2.20.1

