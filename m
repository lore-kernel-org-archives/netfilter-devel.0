Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34546C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Dec 2022 16:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiLWQY5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Dec 2022 11:24:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiLWQY4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2022 11:24:56 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C6DB7F7
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2022 08:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xbeAheG+TV96FDa/ezdR1Q39jQ4TJ95DjQ4XDD6AKX0=; b=iwZ6yLALueHvH42k+916B2nzb6
        Pc93EmDIaYyIypZEQ2GjwulDhvyjn525+Jct4ee+S5oxm5eZQOXcXwyAq8O9veB4XPsHExPLSdiDn
        GyQ1KugSb5ySjWiKvpHjkEiASta+hluOGhPmlGb37XR+5MDKUEBwBtXQDpbF5G2nwk3ISOQ0BdhWB
        k+lDU8a0/DQ6H67xck7+N3vZG5PuP36YmAiSsnGPtSYX/4TzLV4CTMTorRaA7zUgTQMakzGhg22/i
        //ON5wcfpcCRo6XaPA8o0WFYCwmtCgimpJNhoHDvaSRrfFkFojY3cxRxWKYcqh1l6c6+GrOuqZ9Bb
        /3GdkFmA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p8kqr-005e5T-20
        for netfilter-devel@vger.kernel.org; Fri, 23 Dec 2022 16:24:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_conntrack 1/2] conntrack: fix BPF code for filtering on big-endian architectures
Date:   Fri, 23 Dec 2022 16:24:40 +0000
Message-Id: <20221223162441.2692988-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The BPF for checking the subsystem ID looks for it in the righthand byte of
`nlh->nlmsg_type`.  However, it will only be there on little-endian archi-
tectures.  The result is that on big-endian architectures the subsystem ID
doesn't match, all packets are immediately accepted, and all filters are
ignored.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=896716
Fixes: b245e4092c5a ("src: allow to use nfct handler for conntrack and expectations at the same time")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/conntrack/bsf.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index 1549815eedcc..589bfd8e5d18 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -9,6 +9,7 @@
 
 #include "internal/internal.h"
 #include "internal/stack.h"
+#include <endian.h>
 #include <linux/filter.h>
 #include <stddef.h>		/* offsetof */
 
@@ -301,10 +302,14 @@ bsf_cmp_subsys(struct sock_filter *this, int pos, uint8_t subsys)
 		[1] = {
 			/* A = skb->data[X+k:B] (subsys_id) */
 			.code	= BPF_LD|BPF_B|BPF_IND,
+#if BYTE_ORDER == BIG_ENDIAN
+			.k	= 0,
+#else
 			.k	= sizeof(uint8_t),
+#endif
 		},
 		[2] = {
-			/* A == subsys ? jump +1 : accept */
+			/* A == subsys ? jump + 1 : accept */
 			.code	= BPF_JMP|BPF_JEQ|BPF_K,
 			.k	= subsys,
 			.jt	= 1,
-- 
2.35.1

