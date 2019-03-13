Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5086C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE68B213A2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 19:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfCMTqX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 15:46:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:48570 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbfCMTqX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 15:46:23 -0400
Received: from localhost ([::1]:33428 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1h49pV-00019h-9s; Wed, 13 Mar 2019 20:46:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 5/6] xtables-legacy.8: Remove stray colon
Date:   Wed, 13 Mar 2019 20:46:16 +0100
Message-Id: <20190313194617.31071-6-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190313194617.31071-1-phil@nwl.cc>
References: <20190313194617.31071-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This obviously doesn't belong there.

Fixes: be70918eab26e ("xtables: rename xt-multi binaries to -nft, -legacy")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-legacy.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-legacy.8 b/iptables/xtables-legacy.8
index 5b4ab32a3ea12..6db7d2cb4357a 100644
--- a/iptables/xtables-legacy.8
+++ b/iptables/xtables-legacy.8
@@ -67,7 +67,7 @@ iptables-legacy-save and checking for any differences in output.
 .B xtables\-monitor(8)
 will need the
 .B xtables\-nft(8)
-versions to work, it cannot display changes made using the.
+versions to work, it cannot display changes made using the
 .B iptables-legacy
 tools.
 
-- 
2.21.0

