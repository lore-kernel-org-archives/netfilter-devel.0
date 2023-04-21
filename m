Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B4EC77B61
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 16:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjDUQDw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 12:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjDUQDv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 12:03:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393619034
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2023 09:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RXaZ39hq4p237OZYT9yWGOpsa/erH7WU8DTfCueDy1o=; b=dYbiTUMhMUmib1ZhxNlnWkia88
        j0lnYRoh0GozvS3HekhDuZ1fNdTHYrt0khoCrIloqQFuFmij2MHBpnaqwXmiXJQv6IgVwu1gcqikk
        extujEr2dGL8mxGKda8NeSBlEYl8l5EtpWw7Z9TvZmITd1ZhkL8ECXOu1Damv5f4YXrkj3p6l4BdE
        b+SLwhjkHyZIPGI0H5yGcMMHS/tTBuKkZkY+a0yobAscYfDJyfxmltcgFm9K1tdFdTy33uUXU0fok
        lfUrFazlC9pN5KDKWBAWqMPpemufCDHxQr3al7iIeGLMGVRZ6sk/Y4rr4p+vjDrB6HyTIFYDVvvPo
        c3UMmHyA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pptEi-0007A5-3h
        for netfilter-devel@vger.kernel.org; Fri, 21 Apr 2023 18:03:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/2] nft-shared: Drop unused include
Date:   Fri, 21 Apr 2023 18:04:09 +0200
Message-Id: <20230421160409.7586-2-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421160409.7586-1-phil@nwl.cc>
References: <20230421160409.7586-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Code does not refer to struct xt_comment_info anymore.

Fixes: 3bb497c61d743 ("xtables: Fix for deleting rules with comment")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c19d78e469722..79f6a7d3fbb85 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -22,7 +22,6 @@
 #include <xtables.h>
 
 #include <linux/netfilter/nf_log.h>
-#include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
 #include <linux/netfilter/xt_NFLOG.h>
 #include <linux/netfilter/xt_mark.h>
-- 
2.40.0

