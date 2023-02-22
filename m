Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5738C636D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 17:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjBVRDB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 12:03:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjBVRDB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 12:03:01 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC82C1C320
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 09:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4vgOZy7g3S3z3X4PAVFSrZEJPtBr0MiF3Wz+jEcU0zY=; b=BUXU9OKPyohUroxnK2ojAjy4mU
        ru6id2sWXRF6AR63rj+Wx0sH9xHdATqMEBDH3/B+QebAOY6OyQpdRngWaS+Wb0h0oRIYFgX7BUSQP
        Yj+VsGXXLQYVzOAyxjyjtoNamTHN3nuZHIB66NaZ05tAN/Zgin6YnjC+kjpc25l810RR5Qwr2BnF5
        vQzCHrn1ApH1G9Ie49EL5R6JUEFd57lSPX2KkyB4UvtSTho2nZWHOKZ9LF/qOlUzeYC0mEiiVV7gh
        DFI7klwtqFiF2EpIEi0ZpMRwdhvozVbSooKbhsn/7fHzfF7PAZw50utFrNw/teAiTQmPglPrTmcpk
        Ncszh3Tw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pUsW7-0005Yr-4A; Wed, 22 Feb 2023 18:02:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [ipset PATCH 1/2] xlate: Fix for fd leak in error path
Date:   Wed, 22 Feb 2023 18:02:40 +0100
Message-Id: <20230222170241.26208-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230222170241.26208-1-phil@nwl.cc>
References: <20230222170241.26208-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A rather cosmetic issue though, the program will terminate anyway.

Fixes: 325af556cd3a6 ("add ipset to nftables translation infrastructure")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 lib/ipset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/ipset.c b/lib/ipset.c
index f57b07413cba5..2e098e435d954 100644
--- a/lib/ipset.c
+++ b/lib/ipset.c
@@ -1999,7 +1999,7 @@ static int ipset_xlate_restore(struct ipset *ipset)
 
 		ret = build_argv(ipset, c);
 		if (ret < 0)
-			return ret;
+			break;
 
 		cmd = ipset_parser(ipset, ipset->newargc, ipset->newargv);
 		if (cmd < 0)
-- 
2.38.0

