Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125F5C677F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 18:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240285AbjALSFM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 13:05:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbjALSDq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:46 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE93A5D89C
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 09:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uyYfu4UMfqaV5VtB0ZQmx2ln/AQurm1s3ezy0yTFzg4=; b=Jp9fGCKUNbbc82C2Hp2DKtlFON
        dsMn3ub4mVAItoUZBRYpEhiflpvfawmNfCLKD9GKIJZgy19b/Th1VvO3opS+NteolI08ODsIfDuHE
        B4w3qQfaWCmmsNw15E7u/26XjQ8Fj2vF4+/7ITmqLZgP5sQbd0GzfmTROr5ATeRXV611rs6aRq5iP
        z7It14r9mo6tMgNTxQA68Ze4Nd1xY1SIMVOv75gyGnTMxDnyxs2MdVWDCa3mO0iYz95SUmtctntax
        lCH79U/0H0w28mk418beU90sNdPmonR66sDrbFSDAGUSf48ypArEY2w+LKoAIhmx9Ls6TTPSLZm9i
        S9mqj83g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pG1Nl-0000DY-C5; Thu, 12 Jan 2023 18:28:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/5] netlink: Fix for potential NULL-pointer deref
Date:   Thu, 12 Jan 2023 18:28:21 +0100
Message-Id: <20230112172823.7298-4-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230112172823.7298-1-phil@nwl.cc>
References: <20230112172823.7298-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If memory allocation fails, calloc() returns NULL which was not checked
for. The code seems to expect zero array size though, so simply
replacing this call by one of the x*calloc() ones won't work. So guard
the call also by a check for 'len'.

Fixes: db0697ce7f602 ("src: support for flowtable listing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/netlink.c b/src/netlink.c
index 51de9c9c8edb2..efae125148b8c 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1790,7 +1790,8 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 	while (dev_array[len])
 		len++;
 
-	flowtable->dev_array = calloc(1, len * sizeof(char *));
+	if (len)
+		flowtable->dev_array = xmalloc(len * sizeof(char *));
 	for (i = 0; i < len; i++)
 		flowtable->dev_array[i] = xstrdup(dev_array[i]);
 
-- 
2.38.0

