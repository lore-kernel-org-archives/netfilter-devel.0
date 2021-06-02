Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625D5C4708F
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E33A613B1
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Jun 2021 15:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhFBP0c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhFBP0b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 11:26:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BA5C061574
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Jun 2021 08:24:47 -0700 (PDT)
Received: from localhost ([::1]:43124 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1loSjd-0007QB-NT; Wed, 02 Jun 2021 17:24:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/9] libxtables: Fix memleak in xtopt_parse_hostmask()
Date:   Wed,  2 Jun 2021 17:23:57 +0200
Message-Id: <20210602152403.5689-4-phil@nwl.cc>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602152403.5689-1-phil@nwl.cc>
References: <20210602152403.5689-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The allocated hostmask duplicate needs to be freed again.

Fixes: 66266abd17adc ("libxtables: XTTYPE_HOSTMASK support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtoptions.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index d329f2ff7979e..0dcdf607f4678 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -763,6 +763,7 @@ static void xtopt_parse_hostmask(struct xt_option_call *cb)
 	cb->arg = p;
 	xtopt_parse_plenmask(cb);
 	cb->arg = orig_arg;
+	free(work);
 }
 
 static void xtopt_parse_ethermac(struct xt_option_call *cb)
-- 
2.31.1

