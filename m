Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868BAC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 May 2022 15:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381770AbiEMPCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 May 2022 11:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381797AbiEMPCN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 May 2022 11:02:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F164755F
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2022 08:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=p+pYeGHWzzGLdfDc9ssuPzVsDBe214i0uX/52zO/Xxw=; b=d0Df5LVhLpncUgJlaRLUiNGulA
        qgirlS9CUyxgZQcvja4BJ9Sy3sXIVARk+aRM+i6ZktZru/+ZNgNPx8u1r0piTPAaN1mplAvGNOb5S
        4U3fBoWY9lRLQzmHrDQqLDVW1u4Q2jtIJytPslPW+bPh90/I1exKH4UIPj9kVwEwTOUXRFHisgL6I
        C3Y/mTctl6XZ8/CVQJl8MT5gtpNdrfpcO0blP/K1iQmlqDDpksOU/lfZO9WS6iZAlBvvsdsFqaoBR
        yjlKHgoHEuEnOUlSaPh7zBPZZx+0m/zNaczo+xWLzmtFY63S4VXq+OsVfZzRStlRs1QG+aNkWcMCR
        +/RCYxYg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1npWnp-0001YE-KZ; Fri, 13 May 2022 17:02:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] xshared: Fix build for -Werror=format-security
Date:   Fri, 13 May 2022 17:01:53 +0200
Message-Id: <20220513150153.8851-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gcc complains about the omitted format string.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index fae5ddd5df93e..a8512d3808154 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1307,7 +1307,7 @@ static void check_empty_interface(struct xtables_args *args, const char *arg)
 		return;
 
 	if (args->family != NFPROTO_ARP)
-		xtables_error(PARAMETER_PROBLEM, msg);
+		xtables_error(PARAMETER_PROBLEM, "%s", msg);
 
 	fprintf(stderr, "%s", msg);
 }
-- 
2.34.1

