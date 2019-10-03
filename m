Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF669ECE58D
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB288207FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 19:56:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="VwHJFfIG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732997AbfJCT4M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 15:56:12 -0400
Received: from kadath.azazel.net ([81.187.231.250]:51180 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbfJCT4L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 15:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3s5NTl58+Qq29ATpP12AzzCUXRSippIv9m5DXxHMKx0=; b=VwHJFfIG9iPUQBL/Ux/vHPMiCh
        5Rcp3I0g9qSqEVX7EQIntu2J+CQdH/UM2SjUD3OyBUwiDOEfuCtJun3d5D+hXQ0gZgyV7mSPs69M/
        +NxK+jWwflo820/5qeYkf7gPrvIiY6c0EenrtjopgYr+HOO2tf3/WFCK2iQgVcyjmsMygJYsrr+Ct
        82b27X00h0hAZOWleMNGW3SU+uV/XR110xa5rzOIOf6UA4gatS4eJuybansuw2Sziwgu9YwSg+ayt
        CMZio69nX5pEr1Fd6BHlLMAiSFpyRxIKcefGy/VWfJXaKFHmNqxTMLoa6VikkuExPn1RyvLjBN8M8
        ukpVd5QA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iG7Cp-0004KM-Tb; Thu, 03 Oct 2019 20:56:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 1/7] netfilter: ipset: add a coding-style fix to ip_set_ext_destroy.
Date:   Thu,  3 Oct 2019 20:56:01 +0100
Message-Id: <20191003195607.13180-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003195607.13180-1-jeremy@azazel.net>
References: <20191003195607.13180-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a local variable to hold comment in order to align the arguments of
ip_set_comment_free properly.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 9bc255a8461b..9fee4837d02c 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -269,9 +269,11 @@ ip_set_ext_destroy(struct ip_set *set, void *data)
 	/* Check that the extension is enabled for the set and
 	 * call it's destroy function for its extension part in data.
 	 */
-	if (SET_WITH_COMMENT(set))
-		ip_set_extensions[IPSET_EXT_ID_COMMENT].destroy(
-			set, ext_comment(data, set));
+	if (SET_WITH_COMMENT(set)) {
+		struct ip_set_comment *c = ext_comment(data, set);
+
+		ip_set_extensions[IPSET_EXT_ID_COMMENT].destroy(set, c);
+	}
 }
 
 static inline int
-- 
2.23.0

