Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25E54C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKCBla (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBl3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0C71145A
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8fS/CGNlZTVbzdrFkn2guOcKwg335Rvq3wDQJY5pZnA=; b=WnvU5BeWE9orrFuqn5MSWt+DmK
        O71/6vAmZsGgpzHa5K0YTblRA6nyNEZe+itnd/wT07V80PjLcwZNt9UzEbrLnlJvFwg0Fr8yyBV8C
        ZEl5+iLA624kLzAosNVewf3jhg25g067d7wqALzWByXffxOKzYTIps88ojMS/wFj8flYLAWgH4hrE
        L51qDmwuPmKVnyYELNziAAUzZsi1SD8eFAahJLAKtAQytWo9QmFlWC7H/RLbFPJBEdX/sb9UP1RKt
        jlShM+2/AIzZ29SQEXKiOvaw16nxe8V4/KHgcLjoEEBM1Pp8nThABbUBOlnUgqjP8sQFnY57HiEzF
        QKz1fRLA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEV-0005Fs-4H
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:27 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/6] extensions: DNAT: Fix bad IP address error reporting
Date:   Thu,  3 Nov 2022 02:41:08 +0100
Message-Id: <20221103014113.10851-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221103014113.10851-1-phil@nwl.cc>
References: <20221103014113.10851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When introducing 'start' variable to cover for IPv6 addresses enclosed
in brackets, this single spot was missed.

Fixes: 14d77c8aa29a7 ("extensions: Merge IPv4 and IPv6 DNAT targets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_DNAT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index 5696d31f2b0c5..7bfefc7961fac 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -197,7 +197,7 @@ parse_to(const char *orig_arg, bool portok,
 
 	if (!inet_pton(family, start, &range->min_addr))
 		xtables_error(PARAMETER_PROBLEM,
-			      "Bad IP address \"%s\"", arg);
+			      "Bad IP address \"%s\"", start);
 	if (dash) {
 		if (!inet_pton(family, dash + 1, &range->max_addr))
 			xtables_error(PARAMETER_PROBLEM,
-- 
2.38.0

