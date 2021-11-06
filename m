Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBCEAC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:45:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6514611C0
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhKFUsj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 16:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhKFUsi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 16:48:38 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FCAC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:45:57 -0700 (PDT)
Received: from localhost ([::1]:58716 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSZV-0003yq-7g; Sat, 06 Nov 2021 21:45:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Unbreak xtables-translate
Date:   Sat,  6 Nov 2021 21:45:44 +0100
Message-Id: <20211106204544.13136-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixed commit broke xtables-translate which still relied upon do_parse()
to properly initialize the passed iptables_command_state reference. To
allow for callers to preset fields, this doesn't happen anymore so
do_command_xlate() has to initialize itself. Otherwise garbage from
stack is read leading to segfaults and program aborts.

Although init_cs callback is used by arptables only and
arptables-translate has not been implemented, do call it if set just to
avoid future issues.

Fixes: cfdda18044d81 ("nft-shared: Introduce init_cs family ops callback")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-translate.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 086b85d2f9cef..e2948c5009dd6 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -253,11 +253,18 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		.restore	= restore,
 		.xlate		= true,
 	};
-	struct iptables_command_state cs;
+	struct iptables_command_state cs = {
+		.jumpto = "",
+		.argv = argv,
+	};
+
 	struct xtables_args args = {
 		.family = h->family,
 	};
 
+	if (h->ops->init_cs)
+		h->ops->init_cs(&cs);
+
 	do_parse(h, argc, argv, &p, &cs, &args);
 
 	cs.restore = restore;
-- 
2.33.0

