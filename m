Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B577C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 22:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiJEWnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiJEWnN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 18:43:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56785855AC
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 15:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a3VRwhczl5cBuBK6PJ4mJvG8WOgcSUXDMq3T3OgruZ4=; b=TRwzh0sP2OtXxcLhdRAxqNiBED
        1hTUEwc15r6jFT4hpoBQl47DVYNHaEx61CuRE+mbaSRnuaV84v5zVcolVSoIcwTalJmFz2YaBuaDa
        +r5sJDv7NP/eMtVSu+Gj0q6GpX06gM2ubDgFCO/lFCj1sABnONtjRTfQ5n+EogivmudXlpTVRGHVr
        ooipez6BC6gQ0mwBnBXBwkAB9xTUj1Z0ySjjYqo6hchQUeOqAzR6zlnlQI70ZiG+KfbUqJVB3xION
        FuhNekVFH/oikAEJBgA9M3fQdaBe9pdC9CXkLtvOROUOro6lDu6mZgBSdt579pWXyRa/FSKqaW6KD
        +n/84SHw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogD6W-0000tW-66
        for netfilter-devel@vger.kernel.org; Thu, 06 Oct 2022 00:43:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] tests: libebt_stp.t: Drop duplicate whitespace
Date:   Thu,  6 Oct 2022 00:42:55 +0200
Message-Id: <20221005224255.31944-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Code was fixed but the testcase adjustment slipped through.

Fixes: 262dff31a998e ("extensions: libebt_stp: Eliminate duplicate space in output")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_stp.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_stp.t b/extensions/libebt_stp.t
index 0c6b77b91454b..17d6c1c0978e3 100644
--- a/extensions/libebt_stp.t
+++ b/extensions/libebt_stp.t
@@ -1,7 +1,7 @@
 :INPUT,FORWARD,OUTPUT
 --stp-type 1;=;OK
 --stp-flags 0x1;--stp-flags topology-change -j CONTINUE;OK
---stp-root-prio 1  -j ACCEPT;=;OK
+--stp-root-prio 1 -j ACCEPT;=;OK
 --stp-root-addr 0d:ea:d0:0b:ee:f0;=;OK
 --stp-root-cost 1;=;OK
 --stp-sender-prio 1;=;OK
-- 
2.34.1

