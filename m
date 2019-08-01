Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EEBC433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D209320644
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 12:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfHAMC5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 08:02:57 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:43298 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfHAMC5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 08:02:57 -0400
Received: from localhost ([::1]:56388 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ht9nM-00087E-AZ; Thu, 01 Aug 2019 14:02:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Drop stale include directive
Date:   Thu,  1 Aug 2019 14:02:31 +0200
Message-Id: <20190801120231.7665-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a leftover, the file does not exist in fresh clones.

Fixes: 06fd5e46d46f7 ("xtables: Drop support for /etc/xtables.conf")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 1ba43b43aa2ff..e194be1077bd2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -57,7 +57,6 @@
 #include "xshared.h" /* proto_to_name */
 #include "nft-shared.h"
 #include "nft-bridge.h" /* EBT_NOPROTO */
-#include "xtables-config-parser.h"
 
 static void *nft_fn;
 
-- 
2.22.0

