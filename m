Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214F3C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239080AbiKWQob (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239078AbiKWQo1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:27 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17271898E8
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GOWiQbQOQ+2o52YVLjf8u3nHc5K5C7t8su9rwGC/4bI=; b=qjmIvbFBMm4qg8dxlrtzB4NIO9
        LncQqqXBbVqKh9eg9P6MeuYmaoUrIAcCsixavEmSje4hJIy/NEpx4Xf59IpbBi3kt9wMJGVkQOL/a
        ZXdnyW12/iBGrx5I3PNONXG//ullhiPEJsUNjTNiD2zgdnQ6XD/V4GmteX4jZrOKHUt4IIB+bM8cp
        MAZOY0BQV9gAo/8P7E4NyQ/kFROQpFmiaQCbq+RM7Q7H6gDs422QXSyeeITlksBZfKaB3JTbNFFga
        eLicHUbDZVJ/CMJ0hTsBxgD/eNwvKPq4ydb+OVCcBIs0JZkb1Uzd/b90rvPVOCwWojqnfasuQOcJv
        4t2vci9Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrJ-0003xF-DM
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/13] extensions: libebt_mark: Fix mark target xlate
Date:   Wed, 23 Nov 2022 17:43:38 +0100
Message-Id: <20221123164350.10502-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Target value is constructed setting all non-target bits to one instead
of zero.

Fixes: 03ecffe6c2cc0 ("ebtables-compat: add initial translations")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_mark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_mark.c b/extensions/libebt_mark.c
index 423c5c9133d0d..40e49618e0215 100644
--- a/extensions/libebt_mark.c
+++ b/extensions/libebt_mark.c
@@ -201,7 +201,7 @@ static int brmark_xlate(struct xt_xlate *xl,
 		return 0;
 	}
 
-	tmp = info->target & EBT_VERDICT_BITS;
+	tmp = info->target | ~EBT_VERDICT_BITS;
 	xt_xlate_add(xl, "0x%lx %s ", info->mark, brmark_verdict(tmp));
 	return 1;
 }
-- 
2.38.0

