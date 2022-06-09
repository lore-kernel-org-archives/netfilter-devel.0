Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B5BCCA473
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Jun 2022 17:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343936AbiFIRFw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234872AbiFIRFw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Jun 2022 13:05:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7326EC3D2B
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jun 2022 10:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YVgPjMEgBQwLRB8ypbSSk+OFkSMbxhWHJJzZ/eJkuQw=; b=qZRPPnpntS2SGynmA+L0Cn6dZg
        dUV2egbmjyyClp5AiVPF+D0o9Caxmur+KqXgvakwbmxyzB1qCDFKJAJgsYuzbTYdIPVBIpPAHpEyW
        /Vo8f3in82SWJTUcVgVOd57WMrS8jX2THBlW0TL3aVNDaZSijqITsFzt38EUdry0q+OLKYF19/Mv7
        f7bx2O+rhzEnABuB2WJD6klVwR0nkTnITD8D1tP/XfF5XQl+khulNgtd5rwR4pxEqlyqbuO06f2Fr
        7TUBAMaTrrndbK3Yq43uf5QmcAT6X3QCGzcexiKRqIzArRTUiFgJlEZvNsBOZ7oFZKrfEeL6Tttzb
        3hMJTXXA==;
Received: from localhost ([::1] helo=minime)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nzLbR-0005uL-QK
        for netfilter-devel@vger.kernel.org; Thu, 09 Jun 2022 19:05:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] iptables-legacy: Drop redundant include of xtables-multi.h
Date:   Thu,  9 Jun 2022 19:05:38 +0200
Message-Id: <20220609170539.14769-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The header is included unconditionally first, so no point in doing it a
second time of ENABLE_NFTABLES is defined.

Fixes: be70918eab26e ("xtables: rename xt-multi binaries to -nft, -legacy")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-legacy-multi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/iptables/xtables-legacy-multi.c b/iptables/xtables-legacy-multi.c
index 3b7905ff76b13..2c71931551b5c 100644
--- a/iptables/xtables-legacy-multi.c
+++ b/iptables/xtables-legacy-multi.c
@@ -14,10 +14,6 @@
 #include "ip6tables-multi.h"
 #endif
 
-#ifdef ENABLE_NFTABLES
-#include "xtables-multi.h"
-#endif
-
 static const struct subcommand multi_subcommands[] = {
 #ifdef ENABLE_IPV4
 	{"iptables",            iptables_main},
-- 
2.34.1

