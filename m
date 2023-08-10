Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5810DC001B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Aug 2023 11:23:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbjHJLXx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Aug 2023 07:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbjHJLXw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2023 07:23:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81514268A
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Aug 2023 04:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fgaTGbuNOLietYUA25eTyYiUOp31cEanTFOf7vocWnQ=; b=mm0GGzTQy8wqRcrZT9dwHqLGBq
        1v9u5P2pI+djBYCV5UMVV3Q80cPYR1TbnlFcZ/GlT/l5AflsDLlkmCMvFZ/55mk3agSBR6CvqPVfk
        oQjjh/B1yYNsSKU04rYBLmbJ/GC9ZfAMc+XuTglxz/1xhjXmN++hcmbrbj38+LylSJyepu6SfZW49
        b9Z8dENJoS3klWFDX36gZxT61GhLvh2b4uvSC5tdPD3G+GHavRD3Ag9PY1JFyt2hpkotZ0KPuXmtQ
        fYd3vKaaHjqLcWpyOqYbmDYQ8W0A1A9pbIgupWuI07J6+O7gqA48bDijWzEwLwOr8eRoNauA9fMEg
        /c8EK3vw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qU3ld-0004OA-UR
        for netfilter-devel@vger.kernel.org; Thu, 10 Aug 2023 13:23:49 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 2/3] Revert "libiptc: fix wrong maptype of base chain counters on restore"
Date:   Thu, 10 Aug 2023 13:23:24 +0200
Message-Id: <20230810112325.20630-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230810112325.20630-1-phil@nwl.cc>
References: <20230810112325.20630-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit 7c4d668c9c2ee007c82063b7fc784cbbf46b2ec4.

The change can't be right: A simple rule append call will reset all
built-in chains' counters. The old code works fine even given the
mentioned "empty restore" use-case, at least if counters don't change on
the fly in-kernel.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=912
Fixes: 7c4d668c9c2ee ("libiptc: fix wrong maptype of base chain counters on restore")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libiptc/libiptc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 634f0bc76b91c..e475063367c26 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -822,7 +822,7 @@ static int __iptcc_p_del_policy(struct xtc_handle *h, unsigned int num)
 
 		/* save counter and counter_map information */
 		h->chain_iterator_cur->counter_map.maptype =
-						COUNTER_MAP_ZEROED;
+						COUNTER_MAP_NORMAL_MAP;
 		h->chain_iterator_cur->counter_map.mappos = num-1;
 		memcpy(&h->chain_iterator_cur->counters, &pr->entry->counters,
 			sizeof(h->chain_iterator_cur->counters));
-- 
2.40.0

