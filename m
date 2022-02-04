Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DFFC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 15:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359638AbiBDPTU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 10:19:20 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50396 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359630AbiBDPTR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 10:19:17 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1AA83601A0;
        Fri,  4 Feb 2022 16:19:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/6] MAINTAINERS: netfilter: update git links
Date:   Fri,  4 Feb 2022 16:19:02 +0100
Message-Id: <20220204151903.320786-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf and nf-next have a new location.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb83dcbcb619..3a9cb567d47c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13297,8 +13297,8 @@ W:	http://www.iptables.org/
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
2.30.2

