Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C676C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245442AbiFHQ11 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245461AbiFHQ10 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:27:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCC94C78F
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=utqkElLL8R8spj8BPzkAsuEuW07Ibsj2GRhMgYvKF9A=; b=Cq8/KN/fYEBjvx0qGP7d/D8D21
        5wxKsQzp7yDYIDPrCNifwMJE55Ke3PL/PTXU+P0Yo9bG5U3WazsCspJLcnxtcxNReU3RBEWimSMDC
        7PtK8fTyVpz1RQDC/VS8NYrabL4AncYg1mq2ePzDrXJPRRzAiTHlUic1odmx8PrsnDHBKCMxzj96I
        s6xTmrh/np7awCqcL5YI0Dg1z5EoLjf6WtHN5ENAnbyVYH4TrLlOsk7TqGETP6Kcf9sHIOH/ZTHnh
        hSXb6lo5Zfs2aW2W/zZVTbTDo7qSK0Aw/ZiuUeFZDW9d6aAefPdseyGdZCntB29/7ZhMJPoQ5DWcV
        xw7nrDJg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyWf-00084o-EW
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 9/9] extensions: string: Fix and enable tests
Date:   Wed,  8 Jun 2022 18:27:12 +0200
Message-Id: <20220608162712.31202-10-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some minor fixes were necessary:

* --algo is printed after the pattern
* Second long string test must fail, that string is 129 chars long
* --from 0 and --to 65535 are not printed (default values)

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_string.t | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_string.t b/extensions/libxt_string.t
index d68f099d966c6..2f4b30cbc0461 100644
--- a/extensions/libxt_string.t
+++ b/extensions/libxt_string.t
@@ -1,18 +1,11 @@
 :INPUT,FORWARD,OUTPUT
-# ERROR: cannot find: iptables -I INPUT -m string --algo bm --string "test"
-# -m string --algo bm --string "test";=;OK
-# ERROR: cannot find: iptables -I INPUT -m string --algo kmp --string "test")
-# -m string --algo kmp --string "test";=;OK
-# ERROR: cannot find: iptables -I INPUT -m string --algo kmp ! --string "test"
-# -m string --algo kmp ! --string "test";=;OK
-# cannot find: iptables -I INPUT -m string --algo bm --string "xxxxxxxxxxx" ....]
-# -m string --algo bm --string "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";=;OK
-# ERROR: cannot load: iptables -A INPUT -m string --algo bm --string "xxxx"
-# -m string --algo bm --string "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";=;OK
-# ERROR: cannot load: iptables -A INPUT -m string --algo bm --hexstring "|0a0a0a0a|"
-# -m string --algo bm --hexstring "|0a0a0a0a|";=;OK
-# ERROR: cannot find: iptables -I INPUT -m string --algo bm --from 0 --to 65535 --string "test"
-# -m string --algo bm --from 0 --to 65535 --string "test";=;OK
+-m string --algo bm --string "test";-m string --string "test" --algo bm;OK
+-m string --string "test" --algo kmp;=;OK
+-m string ! --string "test" --algo kmp;=;OK
+-m string --string "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" --algo bm;=;OK
+-m string --string "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" --algo bm;;FAIL
+-m string --hex-string "|0a0a0a0a|" --algo bm;=;OK
+-m string --algo bm --from 0 --to 65535 --string "test";-m string --string "test" --algo bm;OK
 -m string --algo wrong;;FAIL
 -m string --algo bm;;FAIL
 -m string;;FAIL
-- 
2.34.1

