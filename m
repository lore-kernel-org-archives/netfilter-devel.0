Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CCDC4708E
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 08:57:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB08F610A8
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 May 2021 08:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236074AbhE1I6l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 May 2021 04:58:41 -0400
Received: from host.78.145.23.62.rev.coltfrance.com ([62.23.145.78]:58730 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S236076AbhE1I6k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 May 2021 04:58:40 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 May 2021 04:58:39 EDT
Received: from bretzel (unknown [10.16.0.57])
        by proxy.6wind.com (Postfix) with ESMTPS id EAEC39C22F0;
        Fri, 28 May 2021 10:49:05 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1lmYAz-0004yo-Ta; Fri, 28 May 2021 10:49:05 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [PATCH nf] MAINTAINERS: netfilter: add irc channel
Date:   Fri, 28 May 2021 10:48:49 +0200
Message-Id: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The community #netfilter IRC channel is now live on the libera.chat network
(https://libera.chat/).

CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
Link: https://marc.info/?l=netfilter&m=162210948632717
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1d834bebf469..d9c7f8b5cae2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12649,6 +12649,7 @@ W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 W:	http://www.nftables.org/
 Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
+C:	irc://irc.libera.chat/netfilter
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
 F:	include/linux/netfilter*
-- 
2.30.0

