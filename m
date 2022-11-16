Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B83EC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Nov 2022 11:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbiKPLOq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Nov 2022 06:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239113AbiKPLOY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Nov 2022 06:14:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B024257B7E
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Nov 2022 03:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dpXyn9cJIatKljdow7dRjW1MnMvzEAiuD4td8D7Yr3w=; b=mKn3fpmQn8b3KxTKqkZlhefZ5K
        drPMhaWjQfFr3g2tp+D9BpzvvyhKlfF48MO+dABpezoctyzC6B2wcnWn6iRcV0ArZBtnQ37aKfCr5
        DK5U6dsh0+h3enKZuWE64/wwmpOOLuNTUdFzXMnkERTdEO3MadlfHJCCeQaucjtJBYr137AxILJyz
        j+xXRXVbQEZEyBWxMuxWEzN0iLF3n0/Ay2F17ODMl2T4lj4ZaQT/7YD/Vl4Oy/lML/SAAg+dwZ+QY
        fHC2Ln8gBdF1G1OHKusrmSuBhjIlWkBvX04A0PuSRtDpvN67teKpYOALHzugra7NWZt5P5FiJyCpc
        z2lNXIKw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ovGAw-0002ue-Oc
        for netfilter-devel@vger.kernel.org; Wed, 16 Nov 2022 12:01:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: mark: Test double bitwise in a rule
Date:   Wed, 16 Nov 2022 12:01:42 +0100
Message-Id: <20221116110142.17346-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In v1.8.8, the second bitwise changed the first one, messing
iptables-nft-save output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_mark.t | 1 +
 1 file changed, 1 insertion(+)

diff --git a/extensions/libxt_mark.t b/extensions/libxt_mark.t
index 7aeb871588ca6..12c058655f6be 100644
--- a/extensions/libxt_mark.t
+++ b/extensions/libxt_mark.t
@@ -5,3 +5,4 @@
 -m mark --mark 4294967296;;FAIL
 -m mark --mark -1;;FAIL
 -m mark;;FAIL
+-s 1.2.0.0/15 -m mark --mark 0x0/0xff0;=;OK
-- 
2.38.0

