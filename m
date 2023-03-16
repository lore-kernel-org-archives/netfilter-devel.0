Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887A2C6FD19
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 13:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCPNAD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 09:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCPNAC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 09:00:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDD41B31C
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 05:59:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pcnCy-00074F-IP; Thu, 16 Mar 2023 13:59:52 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: xtables: disable 32bit compat interface by default
Date:   Thu, 16 Mar 2023 13:59:48 +0100
Message-Id: <20230316125948.14616-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This defaulted to 'y' because before this knob existed the 32bit
compat layer was always compiled in if CONFIG_COMPAT was set.

32bit iptables on 64bit kernel isn't common anymore, so remove
the default-y now.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 7f9f8f6cf41a..3d44d55d82ed 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -753,7 +753,6 @@ if NETFILTER_XTABLES
 config NETFILTER_XTABLES_COMPAT
 	bool "Netfilter Xtables 32bit support"
 	depends on COMPAT
-	default y
 	help
 	   This option provides a translation layer to run 32bit arp,ip(6),ebtables
 	   binaries on 64bit kernels.
-- 
2.39.2

