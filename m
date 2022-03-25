Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D10C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 10:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347888AbiCYKvt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 06:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352168AbiCYKvq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 06:51:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FF437A8F
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 03:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RGCKNt6NMc/GEOu6eYrpzu7a9KIyH/4zb+LYAlAmSsU=; b=XSaUIX+Awzi3P5ggYImP0VgzS4
        7dJ1jLaixE3MP9CSz4ARZpLWlOJOFbFQdSwcC6suG/yM9XLzW6xTejREzOvlddjs5+P2pXbImyY3J
        eY8u3IzV1hl5pY1NZJHd8QXdtMr6EWmqQkFrgliXHHvU2BuXL075H9vHZQXjCVqZY+yx+trZFXGez
        WolR3Tb1rt0HWy0H3I/uMjEQqFajwUlnvaP7N20M2G+DN4+DDZUVGt22R9u2t2PoSf7kFjX/MP1RK
        e87yfwampvzPs1rCCeTl2JoCZudt8Tp7ZzSc+RTEo1j+4mit7N8BcjPVsjP6tWkmQxQSLXai+G6RD
        xkwv1R7A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXhWD-0007y9-NV; Fri, 25 Mar 2022 11:50:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 5/8] read_config_yy: Drop extra argument from dlog() call
Date:   Fri, 25 Mar 2022 11:50:00 +0100
Message-Id: <20220325105003.26621-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220325105003.26621-1-phil@nwl.cc>
References: <20220325105003.26621-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

False priority value was never printed.

Fixes: dfb88dae65fbd ("conntrackd: change scheduler and priority via configuration file")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/read_config_yy.y | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/read_config_yy.y b/src/read_config_yy.y
index 070b349c59498..5815d6ab464e8 100644
--- a/src/read_config_yy.y
+++ b/src/read_config_yy.y
@@ -1052,7 +1052,7 @@ scheduler_line : T_PRIO T_NUMBER
 {
 	conf.sched.prio = $2;
 	if (conf.sched.prio < 0 || conf.sched.prio > 99) {
-		dlog(LOG_ERR, "`Priority' must be [0, 99]\n", $2);
+		dlog(LOG_ERR, "`Priority' must be [0, 99]\n");
 		exit(EXIT_FAILURE);
 	}
 };
-- 
2.34.1

