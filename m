Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58522C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239168AbiKWQpJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239111AbiKWQpF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:45:05 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622AFC1F43
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=g/RRYL2LWx3RWpQWQdUIN3geABVFbLiKr8jA1hZByqE=; b=EimcPyL+vGn3pHf+rDKwevx1BM
        QojbW5cNlIu59sclsJJVzGPMW2dK7mV64iBpvkNjKM3PwHGQ+D+qfkCUsCBvIjvy5CNmIHAXr4QR/
        cFcFW0BC/t6bGzLvP4OXzkVg7qHgKuSAzt40QmeD676mW6c2vBB7npN3d8BDXzQ0C24HV80z4A6iP
        31zrWrAUKxTlZF21pu8bxt2U527S/5tWP6peTGbyft0bouzOuRx3cXT9t0SjE+DSwSecOWQynPlHp
        OLLBX4yOCeiV3gsRrXAayxYVe2DqcXsG3hCkYnmRvcNhge5GWe6XO2TSnDYmpjGKAkjcesfddoZUL
        TJs9ojPw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsru-00040D-Oi
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:45:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 12/13] extensions: frag: Add comment to clarify xlate callback
Date:   Wed, 23 Nov 2022 17:43:49 +0100
Message-Id: <20221123164350.10502-13-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Matching on fragmentation header length is ineffective in kernel, xlate
callback correctly ignores it. Add a comment as a hint for reviewers.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_frag.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 3842496e56a55..72a43153c53dc 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -193,6 +193,8 @@ static int frag_xlate(struct xt_xlate *xl,
 		space = " ";
 	}
 
+	/* ignore ineffective IP6T_FRAG_LEN bit */
+
 	if (fraginfo->flags & IP6T_FRAG_RES) {
 		xt_xlate_add(xl, "%sfrag reserved 1", space);
 		space = " ";
-- 
2.38.0

