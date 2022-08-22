Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA4E9C28D13
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Aug 2022 14:41:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbiHVOlg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Aug 2022 10:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbiHVOlc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2022 10:41:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A204137F95
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2022 07:41:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oQ8cJ-0004RU-Lr; Mon, 22 Aug 2022 16:41:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: remove NFPROTO_DECNET
Date:   Mon, 22 Aug 2022 16:41:21 +0200
Message-Id: <20220822144121.22026-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Decnet has been removed. so no need to reserve space in arrays for it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/uapi/linux/netfilter.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/netfilter.h b/include/uapi/linux/netfilter.h
index 53411ccc69db..5a79ccb76701 100644
--- a/include/uapi/linux/netfilter.h
+++ b/include/uapi/linux/netfilter.h
@@ -63,7 +63,9 @@ enum {
 	NFPROTO_NETDEV =  5,
 	NFPROTO_BRIDGE =  7,
 	NFPROTO_IPV6   = 10,
+#ifndef __KERNEL__ /* no longer supported by kernel */
 	NFPROTO_DECNET = 12,
+#endif
 	NFPROTO_NUMPROTO,
 };
 
-- 
2.35.1

