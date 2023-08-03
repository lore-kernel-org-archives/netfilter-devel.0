Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E154C001DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Aug 2023 16:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbjHCQGB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjHCQGB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 12:06:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC69C1BD9
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2023 09:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FYJ2DZgsFLDvXv0niZjrmYNxHoxorzgPUNm3n0ZtUwQ=; b=JcV+n1op2ueLJ5hILutB24HssA
        vtJBinkSd3/q3ognsjw0LSiGg+duL7dPjocxhOKwAsDkUDPYMBmhc/ls5LEOSqgM49bdeQvX4AR3S
        mqpiz/2+EltMAvtEog3HyxgoieVR8+VzDLZFcsCauizlvWzWwkZOoPPVIqNqMd9jb5G5cdYGMZxOS
        gx7vbPP/LRPKCA1g3pVrtwwvIaGEjvZqwaLIfqdKfoSgJXFLQUeio8DlpiIy2/odUo50e5ue7bk7r
        wxA5M/KQHwQkJRXgETAMowk9NjfMY5UZjCQXdd/6wkAconvbuZ4hQd6vGenO0rPrmSOhMzdASoFIS
        9YxcCZJw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qRapp-0007IJ-N7; Thu, 03 Aug 2023 18:05:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] Revert "libiptc: fix wrong maptype of base chain counters on restore"
Date:   Thu,  3 Aug 2023 18:05:49 +0200
Message-Id: <20230803160549.25460-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
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
index f9b7779efdba5..29ff356f2324e 100644
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

