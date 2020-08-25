Return-Path: <SRS0=A2+c=CD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF7CC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EC1420706
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Aug 2020 22:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgHYW4N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Aug 2020 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgHYW4N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Aug 2020 18:56:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BF9C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2020 15:56:12 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1kAhrM-00066z-P4; Wed, 26 Aug 2020 00:56:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH lnf-conntrack] include: add CTA_STATS_CLASH_RESOLVE
Date:   Wed, 26 Aug 2020 00:56:01 +0200
Message-Id: <20200825225601.8860-1-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index aa45723138db..0e9af6c1ebd7 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -255,6 +255,7 @@ enum ctattr_stats_cpu {
 	CTA_STATS_EARLY_DROP,
 	CTA_STATS_ERROR,
 	CTA_STATS_SEARCH_RESTART,
+	CTA_STATS_CLASH_RESOLVE,
 	__CTA_STATS_MAX,
 };
 #define CTA_STATS_MAX (__CTA_STATS_MAX - 1)
-- 
2.26.2

