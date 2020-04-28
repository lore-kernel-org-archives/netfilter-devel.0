Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF8DC83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29DA206D6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:12:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgD1MMA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726763AbgD1MMA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:12:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4098CC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:12:00 -0700 (PDT)
Received: from localhost ([::1]:38716 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP5j-0008BA-1q; Tue, 28 Apr 2020 14:11:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 10/18] nft: missing nft_fini() call in bridge family
Date:   Tue, 28 Apr 2020 14:10:05 +0200
Message-Id: <20200428121013.24507-11-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-standalone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
index a9081c78c3bc3..ff74ddbb37334 100644
--- a/iptables/xtables-eb-standalone.c
+++ b/iptables/xtables-eb-standalone.c
@@ -53,6 +53,8 @@ int xtables_eb_main(int argc, char *argv[])
 	if (ret)
 		ret = nft_bridge_commit(&h);
 
+	nft_fini(&h);
+
 	if (!ret)
 		fprintf(stderr, "ebtables: %s\n", nft_strerror(errno));
 
-- 
2.25.1

