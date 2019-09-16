Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83DA2C49ED7
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60EB4214D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 16:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390257AbfIPQu0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 12:50:26 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51166 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390245AbfIPQu0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 12:50:26 -0400
Received: from localhost ([::1]:36024 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i9uCm-0003nf-Vo; Mon, 16 Sep 2019 18:50:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/14] DEBUG: Print to stderr to not disturb iptables-save
Date:   Mon, 16 Sep 2019 18:49:49 +0200
Message-Id: <20190916165000.18217-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916165000.18217-1-phil@nwl.cc>
References: <20190916165000.18217-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This way there's at least a chance to get meaningful results from
testsuite with debugging being turned on.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index fd1f96bad1b98..b08c700e1d8b9 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -11,7 +11,7 @@
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
 #ifdef DEBUG
-#define DEBUGP(x, args...) fprintf(stdout, x, ## args)
+#define DEBUGP(x, args...) fprintf(stderr, x, ## args)
 #else
 #define DEBUGP(x, args...)
 #endif
-- 
2.23.0

