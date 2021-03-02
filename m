Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6813C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82DB064F43
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Mar 2021 23:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhCBXhJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 18:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384332AbhCBPFT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 10:05:19 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1AFC06178C
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Mar 2021 06:30:23 -0800 (PST)
Received: from localhost ([::1]:36444 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lH62V-0003RP-Fs; Tue, 02 Mar 2021 15:30:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] libxtables: Simplify xtables_ipmask_to_cidr() a bit
Date:   Tue,  2 Mar 2021 15:30:10 +0100
Message-Id: <20210302143010.3362-2-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210302143010.3362-1-phil@nwl.cc>
References: <20210302143010.3362-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reduce the whole mask matching into a single for-loop. No need for a
shortcut, /32 masks will match in the first iteration.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index bc42ba8221f3a..fc3f622072adc 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1430,16 +1430,11 @@ int xtables_ipmask_to_cidr(const struct in_addr *mask)
 	int i;
 
 	maskaddr = ntohl(mask->s_addr);
-	/* shortcut for /32 networks */
-	if (maskaddr == 0xFFFFFFFFL)
-		return 32;
-
-	i = 32;
-	bits = 0xFFFFFFFEL;
-	while (--i >= 0 && maskaddr != bits)
-		bits <<= 1;
-	if (i >= 0)
-		return i;
+
+	for (i = 32, bits = (uint32_t)-1; i >= 0; i--, bits <<= 1) {
+		if (bits == maskaddr)
+			return i;
+	}
 
 	/* this mask cannot be converted to CIDR notation */
 	return -1;
-- 
2.28.0

