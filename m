Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC2CEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjHBCF6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjHBCF6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:05:58 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D415213D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3xe5MqqWlyRzXVmlqHyO96H8Ly0eDTm5rKmqnY/x9oI=; b=YTp23fuE6E3FiaTOJ3QAjzk4WC
        p3jDlgBFzmXWeX2aAVeE8/4RHnSwySur3JbF1t3ii+mdm1qmvlBI/Aii1YNS0O7CJCRy6GATWSlsU
        KxJgQrGS1jn0ss8x063ZpFKykIeINCjTS2jIxss6PUsAdYb4voEwrk63YNTbCpQaLMpUumXeZSljv
        Pc6YRXYmyi9/BQ8CZ235YnUaCwMUS04kAfnQfkkgdYa+TVfwADp2ObEG72YTOoo5/iQHUBy2giqom
        L8PsOwdGatdGhEQyUP45Qn8Vi15wG227WYUEK8+P8YPQqr0n9xATEWqmq2AP+pJZVKCbbeRpwWzWZ
        RQomCdQQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1FL-0002v7-PS
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 04:05:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] extensions: libipt_icmp: --icmp-type is not mandatory
Date:   Wed,  2 Aug 2023 04:05:46 +0200
Message-Id: <20230802020547.28886-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020547.28886-1-phil@nwl.cc>
References: <20230802020547.28886-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The init callback sets things up for us, not specifying --icmp-type
results in an '--icmp-type any' match which seems perfectly fine.

Fixes: 1b8db4f4ca250 ("libip[6]t_icmp: use guided option parser")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_icmp.c | 2 +-
 extensions/libipt_icmp.t | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 171b3b3949e54..29c9e1a6cd727 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -31,7 +31,7 @@ static void icmp_help(void)
 
 static const struct xt_option_entry icmp_opts[] = {
 	{.name = "icmp-type", .id = O_ICMP_TYPE, .type = XTTYPE_STRING,
-	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	 .flags = XTOPT_INVERT},
 	XTOPT_TABLEEND,
 };
 
diff --git a/extensions/libipt_icmp.t b/extensions/libipt_icmp.t
index ce4a33f9633b5..08692900dba12 100644
--- a/extensions/libipt_icmp.t
+++ b/extensions/libipt_icmp.t
@@ -10,8 +10,6 @@
 # ERROR: cannot load: iptables -A INPUT -p icmp -m icmp --icmp-type destination-unreachable/network-unreachable
 # -p icmp -m icmp --icmp-type destination-unreachable/network-unreachable;=;OK
 -m icmp;;FAIL
-# we accept "iptables -I INPUT -p tcp -m tcp", why not this below?
-# ERROR: cannot load: iptables -A INPUT -p icmp -m icmp
-# -p icmp -m icmp;=;OK
+-p icmp -m icmp;-p icmp -m icmp --icmp-type any;OK
 -p icmp -m icmp --icmp-type 255/255;=;OK
 -p icmp -m icmp --icmp-type 255/0:255;-p icmp -m icmp --icmp-type any;OK
-- 
2.40.0

