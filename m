Return-Path: <SRS0=UdzR=75=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993FAC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 11:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC7120B1F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 11:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFPLIF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jun 2020 07:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgFPLID (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jun 2020 07:08:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C2FC08C5C2
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 04:08:03 -0700 (PDT)
Received: from localhost ([::1]:56938 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1jl9Rh-0003f8-5S; Tue, 16 Jun 2020 13:08:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xtables-translate: Use proper clear_cs function
Date:   Tue, 16 Jun 2020 13:08:02 +0200
Message-Id: <20200616110802.9122-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Avoid memleaks by performing a full free of any allocated data in local
iptables_command_state variable.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-translate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 5aa42496b5a48..c348c4df4933c 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -316,7 +316,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		exit(1);
 	}
 
-	xtables_rule_matches_free(&cs.matches);
+	nft_clear_iptables_command_state(&cs);
 
 	if (h->family == AF_INET) {
 		free(args.s.addr.v4);
-- 
2.27.0

