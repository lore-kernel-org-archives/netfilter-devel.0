Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575C4C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239171AbiKWQpB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiKWQoz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A5FC1F72
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CU0dArQo13p4Rb68hCWCzlX0Y1cuivbXOQfmaNosR0Y=; b=nH2L0n/fSb3Imk9Jwz3QlmEJrs
        /F4ljG2ou0ztpIsJvetH6w9C1U7pXiK2FehSLHy7ZEiHsrFrXEL3nZTJNn9C5C9dd2eYmfOxsws3Z
        rtqAhZd4yVwE7nlF6UkXv0ITPrkESekfAYdbqaMbQzRTAcWl6Gnf/PJ/gTRQBwc1/5G4m9licSLun
        /KdzEdCS3bnKTuvRfN90p7iPsWhbhaqoQGdv1NboKiIIWa/24EmXdzfymkjb4FdJhn6XWdLTLS7JE
        LAFR4D99xaiWXPMqN6U0XoSnFv7dFcw8ReQowRrTNUmvQwxzVqvNvzwqO6tasWfNU6pKsLQLVpRub
        zIzLD8KQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrk-0003zB-5w
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 06/13] extensions: MARK: Sanitize MARK_xlate()
Date:   Wed, 23 Nov 2022 17:43:43 +0100
Message-Id: <20221123164350.10502-7-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since markinfo->mode might contain unexpected values, add a default case
returning zero.

Fixes: afefc7a134ca0 ("extensions: libxt_MARK: Add translation for revision 1 to nft")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_MARK.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 1536563d0f4c7..100f6a38996ac 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -366,6 +366,8 @@ static int MARK_xlate(struct xt_xlate *xl,
 	case XT_MARK_OR:
 		xt_xlate_add(xl, "mark or 0x%x ", (uint32_t)markinfo->mark);
 		break;
+	default:
+		return 0;
 	}
 
 	return 1;
-- 
2.38.0

