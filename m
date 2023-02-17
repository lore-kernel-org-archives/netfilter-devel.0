Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ABCAC6379F
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 16:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBQQSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 11:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjBQQRy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 11:17:54 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF63F900F
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 08:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+oC7W4gPjxbs00Nwx9r890AYjlbMHfIQ8ZfXpqgHA6k=; b=mgkKbnvUUcretsBeY827rcJ3Yp
        qx3rK3csZUfYRwcqvBr6ViB81qUtBpzH7aPeyjOra1q2iZKnVghW5tWM9s35tX+5UPLuaWhxC8iUt
        xe7OM24MfEe9Fu5Q8EngtWVgcWqgLmksBGLaUTAr2yBnuXvfJnWVRR9mNrSXLiCS4DhhpVKm4QWK8
        nfw90EXLI50uvwpdFDLeSa5IZ7qTrV5Leuf5oyx3RI+gXr2jvLMia8D9rD5MSuqE1rLPnnxIG6FCf
        A5Z5iT+eZq2ziT/VRQM/lzs20/fjaJYTTe2WXDGHK1nmX0qScYOdjhjaSITaSm8coWNhswSqim0Pg
        dFY7qCTQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT3QU-0003W4-Q0
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 17:17:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/6] extensions: libebt_redirect: Fix target translation
Date:   Fri, 17 Feb 2023 17:17:10 +0100
Message-Id: <20230217161715.26120-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While EBT_ACCEPT is the default verdict for ebtables targets, omitting
it from translation implicitly converts it into 'continue'. Omit the
non-default EBT_CONTINUE instead.

Fixes: 24ce7465056ae ("ebtables-compat: add redirect match extension")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_redirect.c      | 2 +-
 extensions/libebt_redirect.txlate | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)
 create mode 100644 extensions/libebt_redirect.txlate

diff --git a/extensions/libebt_redirect.c b/extensions/libebt_redirect.c
index 4d4c7a02cea89..389f3ccb53f60 100644
--- a/extensions/libebt_redirect.c
+++ b/extensions/libebt_redirect.c
@@ -84,7 +84,7 @@ static int brredir_xlate(struct xt_xlate *xl,
 	const struct ebt_redirect_info *red = (const void*)params->target->data;
 
 	xt_xlate_add(xl, "meta set pkttype host");
-	if (red->target != EBT_ACCEPT)
+	if (red->target != EBT_CONTINUE)
 		xt_xlate_add(xl, " %s ", brredir_verdict(red->target));
 	return 1;
 }
diff --git a/extensions/libebt_redirect.txlate b/extensions/libebt_redirect.txlate
new file mode 100644
index 0000000000000..f0dd5deaf6406
--- /dev/null
+++ b/extensions/libebt_redirect.txlate
@@ -0,0 +1,8 @@
+ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta set pkttype host accept'
+
+ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target RETURN
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta set pkttype host return'
+
+ebtables-translate -t nat -A PREROUTING -d de:ad:00:00:be:ef -j redirect --redirect-target CONTINUE
+nft 'add rule bridge nat PREROUTING ether daddr de:ad:00:00:be:ef counter meta set pkttype host'
-- 
2.38.0

