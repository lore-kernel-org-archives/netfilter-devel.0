Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02724C48BDF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA81261360
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 22:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhFVWC5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 18:02:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59238 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhFVWC4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 18:02:56 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2C0D964271;
        Tue, 22 Jun 2021 23:59:15 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/8] MAINTAINERS: netfilter: add irc channel
Date:   Tue, 22 Jun 2021 23:59:54 +0200
Message-Id: <20210622220001.198508-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622220001.198508-1-pablo@netfilter.org>
References: <20210622220001.198508-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

The community #netfilter IRC channel is now live on the libera.chat network
(https://libera.chat/).

CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
Link: https://marc.info/?l=netfilter&m=162210948632717
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bfb3d0931cba..f3d44262d16e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12657,6 +12657,7 @@ W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 W:	http://www.nftables.org/
 Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
+C:	irc://irc.libera.chat/netfilter
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
 F:	include/linux/netfilter*
-- 
2.30.2

