Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A52EC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbiKWQoS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbiKWQoR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:17 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647E1686B6
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Cp2sy9HhZmY0uODe+U2UNif4AtnadXo4Jwgeb9yX1HQ=; b=SOPY3SNLsFuRaPwowjqetaa3Wv
        S0JNKaYEJ+R3Q5W/ucGBTxkBXIjH8fQVK/MvjX+iElymdBzI5wXUd+tnhXgOcgIplrqKrfagveiYM
        LtB6k8GMXbShj6lUFMzenLwIgjIWTRA2p6oBf9tvyfiKqM210DDUf2w9Mu1EPYLGJIjW8raFWaHOo
        IOQqCjkcUXiehN1YDZ9ma6vt9F1XGbQcpZig5CIRKWAW9UpMiXwxm19fX/ONielAwf2lW4Y8fDi9s
        nmcws1JqpFNTTzeeWZ8iQsrmQQdXLa3pUntRq5GSQHQ9Z/jy8e3qzyTzA/jmtRzWAPd5iKrmZ+Xbl
        0nPFH3ig==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsr8-0003x7-Pd
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 03/13] extensions: libebt_redirect: Fix xlate return code
Date:   Wed, 23 Nov 2022 17:43:40 +0100
Message-Id: <20221123164350.10502-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The callback is supposed to return 1 on success, not 0.

Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_redirect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
index 6e653997ee99e..4d4c7a02cea89 100644
--- a/extensions/libebt_redirect.c
+++ b/extensions/libebt_redirect.c
@@ -86,7 +86,7 @@ static int brredir_xlate(struct xt_xlate *xl,
 	xt_xlate_add(xl, "meta set pkttype host");
 	if (red->target != EBT_ACCEPT)
 		xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
-	return 0;
+	return 1;
 }
 
 static struct xtables_target brredirect_target = {
-- 
2.38.0

