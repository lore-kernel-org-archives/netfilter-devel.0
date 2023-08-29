Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A8AC83F19
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 13:44:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbjH2Nnw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 09:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236559AbjH2Nno (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 09:43:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1CD1BC
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 06:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WU4DmrzQr27m6kEV0HUwq/bOfuPcjtWUzHQMA7iU7SU=; b=LPcDE4gCLQkO1IUz+KW367k73U
        J7e9boleKbn0155L3NUOA+dVzN9oJLfR3Q3DznjE7OHGJA0fA44bb6T61/98LBzRL4kHVO2uA9cGm
        dQx9BSg2aSUWaw9nNIWlpHt5fzsLMd2iHve09NLwkTxj0dYaBIQSiyoPzFfmHCZKVwCO5Kv4A0xzg
        al/cS+EHa9qlQv+JvmSt0rbJVgeE5oEH4Gap7jhcZQ1Jlg2pAKlTYSO3Zr90DuDi6+/hfulHwsYMA
        vI26l2FNpt01lFKcPqObGlNVfVMekeLponbha6dBxMWYb1QeGxh/SVnhh2Aeep0wKiwbvkzI22dpH
        9T7kcSZA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qayzG-0000TA-Qa
        for netfilter-devel@vger.kernel.org; Tue, 29 Aug 2023 15:42:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/4] tests: monitor: Fix monitor JSON output for insert command
Date:   Tue, 29 Aug 2023 15:48:09 +0200
Message-ID: <20230829134812.31863-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Looks like commit ba786ac758fba ("tests: monitor: update insert and
replace commands") missed to also fix expected JSON output.

Fixes: 48d20b8cf162e ("monitor: honor NLM_F_APPEND flag for rules")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/simple.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/monitor/testcases/simple.t b/tests/monitor/testcases/simple.t
index 2d9c92de25dd3..c1c7bcfc08beb 100644
--- a/tests/monitor/testcases/simple.t
+++ b/tests/monitor/testcases/simple.t
@@ -15,7 +15,7 @@ J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "ex
 
 I insert rule ip t c counter accept
 O insert rule ip t c counter packets 0 bytes 0 accept
-J {"add": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"counter": {"packets": 0, "bytes": 0}}, {"accept": null}]}}}
+J {"insert": {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr": [{"counter": {"packets": 0, "bytes": 0}}, {"accept": null}]}}}
 
 I replace rule ip t c handle 2 accept comment "foo bar"
 O delete rule ip t c handle 2
-- 
2.41.0

