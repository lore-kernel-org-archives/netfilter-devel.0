Return-Path: <SRS0=dC0K=W7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC6C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F29022CF7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Sep 2019 09:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfIDJhn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:37:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50206 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfIDJhm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Sep 2019 05:37:42 -0400
Received: from localhost ([::1]:35062 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1i5RjR-0006dW-8Q; Wed, 04 Sep 2019 11:37:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [conntrack-tools PATCH v2] conntrack: Fix CIDR to mask conversion on Big Endian
Date:   Wed,  4 Sep 2019 11:37:32 +0200
Message-Id: <20190904093732.2486-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Code assumed host architecture to be Little Endian. Instead produce a
proper mask by pushing the set bits into most significant position and
apply htonl() on the result.

Fixes: 3f6a2e90936bb ("conntrack: add support for CIDR notation")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Simplify bitshift operation as per Florian's suggestion.
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index c980a13f33d2c..f65926b298ad3 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2210,7 +2210,7 @@ nfct_build_netmask(uint32_t *dst, int b, int n)
 			dst[i] = 0xffffffff;
 			b -= 32;
 		} else if (b > 0) {
-			dst[i] = (1 << b) - 1;
+			dst[i] = htonl(~0u << (32 - b));
 			b = 0;
 		} else {
 			dst[i] = 0;
-- 
2.22.0

