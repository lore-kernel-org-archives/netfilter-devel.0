Return-Path: <SRS0=xhJ7=B3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36CBC433E1
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Aug 2020 10:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CD3E206FA
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Aug 2020 10:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgHQKby (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Aug 2020 06:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbgHQKbx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Aug 2020 06:31:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A12C061389
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2020 03:31:53 -0700 (PDT)
Received: from localhost ([::1]:60340 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1k7cQY-0003eR-0m; Mon, 17 Aug 2020 12:31:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Makefile: Add missing man pages to CLEANFILES
Date:   Mon, 17 Aug 2020 12:31:33 +0200
Message-Id: <20200817103133.3521-1-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The list of man pages to remove along with 'make clean' was missing a
few built ones, add them.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/Makefile.am | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index bab094b7c6aa9..4bf5742c9dc95 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -67,6 +67,10 @@ man_MANS	+= xtables-nft.8 xtables-translate.8 xtables-legacy.8 \
                    ebtables-nft.8
 endif
 CLEANFILES       = iptables.8 xtables-monitor.8 \
+		   iptables-xml.1 iptables-apply.8 \
+		   iptables-extensions.8 iptables-extensions.8.tmpl \
+		   iptables-restore.8 iptables-save.8 \
+		   iptables-restore-translate.8 ip6tables-restore-translate.8 \
 		   iptables-translate.8 ip6tables-translate.8
 
 vx_bin_links   = iptables-xml
-- 
2.27.0

