Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3F3C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Jan 2022 17:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbiA2RaZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Jan 2022 12:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241070AbiA2RaY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Jan 2022 12:30:24 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F8EC061714
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Jan 2022 09:30:23 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nDrYL-0003gM-Pt; Sat, 29 Jan 2022 18:30:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] MAINTAINERS: netfilter: update git links
Date:   Sat, 29 Jan 2022 18:30:18 +0100
Message-Id: <20220129173018.178577-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf and nf-git have a new location.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f41088418aae..099e4809829f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13298,8 +13298,8 @@ W:	http://www.iptables.org/
 W:	http://www.nftables.org/
 Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
 C:	irc://irc.libera.chat/netfilter
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/
 F:	include/net/netfilter/
-- 
2.34.1

