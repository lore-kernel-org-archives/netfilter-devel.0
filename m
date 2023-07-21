Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBCEEB64DD
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jul 2023 20:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjGUUOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jul 2023 16:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjGUUOl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jul 2023 16:14:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC674272C
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jul 2023 13:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DigqKcc0oBHgGEv0mKs6nWBTkRI70KytSx/QgM0pWnk=; b=B/x7BEhXa6QgwvTSSCS3zza5EW
        gRGvJ8XLDTID4yI4KbdahadRWu/hH9qLOdf/h90uZANeaVFdLl+XlCINHlQuruZ88LRirWgfa77E8
        lINoYMe3BE/q2UzSgMOijg9FOseFgGfJsW9wYiEBMOBMpup5qtmOk90OJoC0ddULjgLwly2JCijDv
        0cCSCPiQMiffoOl3/PQsu7jUVhRlb/jdMXjPBOWMDYPbEczoLPmgjCuyqqMmL9pvhgcaZMuSNW/F1
        7GWdSFbnIvdQtfBGYu92xlFuCPm1iBAh/KttZngZ8/FXO/wfyrAHLsjMS4NdsXaSjQ3Q4bie86Dhd
        ULe41kDg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qMwWN-0005jA-74
        for netfilter-devel@vger.kernel.org; Fri, 21 Jul 2023 22:14:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft: More verbose extension comparison debugging
Date:   Fri, 21 Jul 2023 22:14:25 +0200
Message-Id: <20230721201425.16448-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230721201425.16448-1-phil@nwl.cc>
References: <20230721201425.16448-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dump extension data if it differs.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 2 ++
 iptables/xshared.h    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 0cd082b5396d0..34ca9d16569d0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -398,6 +398,8 @@ bool compare_matches(struct xtables_rule_match *mt1,
 
 		if (memcmp(m1->data, m2->data, cmplen) != 0) {
 			DEBUGP("mismatch match data\n");
+			DEBUG_HEXDUMP("m1->data", m1->data, cmplen);
+			DEBUG_HEXDUMP("m2->data", m2->data, cmplen);
 			return false;
 		}
 	}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 0ed9f3c29c600..a200e0d620ad3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -12,8 +12,15 @@
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
+#define DEBUG_HEXDUMP(pfx, data, len)					\
+	for (int __i = 0; __i < (len); __i++) {				\
+		if (__i % 16 == 0)					\
+			printf("%s%s: ", __i ? "\n" : "", (pfx));	\
+		printf("%02x ", ((const unsigned char *)data)[__i]);	\
+	} printf("\n")
 #else
 #define DEBUGP(x, args...)
+#define DEBUG_HEXDUMP(pfx, data, len)
 #endif
 
 enum {
-- 
2.40.0

