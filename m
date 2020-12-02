Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13DA6C64E7B
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 13:33:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B542B2075A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 13:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgLBNdi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 08:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbgLBNdi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 08:33:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A835C0613CF
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 05:32:58 -0800 (PST)
Received: from localhost ([::1]:46250 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kkSFa-0001xu-K7; Wed, 02 Dec 2020 14:32:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Shivani Bhardwaj <shivanib134@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: dccp: Fix translation of --dccp-type
Date:   Wed,  2 Dec 2020 14:32:50 +0100
Message-Id: <20201202133250.28340-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For starters, dccp_type_xlate() prefixed its output with 'dccp' although
dccp_xlate() did that already.

The second fix deals with odd capitulation if type INVALID was given.
The fundamental problem is that nftables doesn't define an equivalent
type name, but it doesn't make much sense, either: INVALID is not a
defined type, but actually any type value between 10 and 15 - due to the
four bit field size, they are possible but not used. Luckily, such a
match is easily possible in nftables. Simply translate 'INVALID' into
'10-15'.

Fixes: c94a998724143 ("extensions: libxt_dccp: Add translation to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_dccp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 5e67c264db2a9..86bdd10284375 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -288,6 +288,7 @@ static const char *const dccp_pkt_types_xlate[] = {
 	[DCCP_PKT_RESET]        = "reset",
 	[DCCP_PKT_SYNC]         = "sync",
 	[DCCP_PKT_SYNCACK]      = "syncack",
+	[DCCP_PKT_INVALID]	= "10-15",
 };
 
 static int dccp_type_xlate(const struct xt_dccp_info *einfo,
@@ -296,10 +297,7 @@ static int dccp_type_xlate(const struct xt_dccp_info *einfo,
 	bool have_type = false, set_need = false;
 	uint16_t types = einfo->typemask;
 
-	if (types & (1 << DCCP_PKT_INVALID))
-		return 0;
-
-	xt_xlate_add(xl, " dccp type%s ", einfo->invflags ? " !=" : "");
+	xt_xlate_add(xl, "type%s ", einfo->invflags ? " !=" : "");
 
 	if ((types != 0) && !(types == (types & -types))) {
 		xt_xlate_add(xl, "{");
-- 
2.28.0

