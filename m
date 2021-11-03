Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF98C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 22:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4201E60EBB
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 22:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhKCWdK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 18:33:10 -0400
Received: from fourcot.fr ([217.70.191.14]:52498 "EHLO olfflo.fourcot.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhKCWdJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 18:33:09 -0400
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netfilter-devel@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH nf] netfilter: ctnetlink: do not erase error code with EINVAL
Date:   Wed,  3 Nov 2021 23:21:55 +0100
Message-Id: <20211103222155.17981-2-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211103222155.17981-1-florent.fourcot@wifirst.fr>
References: <20211103222155.17981-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

And be consistent in error management for both orig/reply filtering

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
---
 net/netfilter/nf_conntrack_netlink.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2663764d0b6e..c7708bde057c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1012,10 +1012,8 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   filter->family,
 						   &filter->zone,
 						   filter->reply_flags);
-		if (err < 0) {
-			err = -EINVAL;
+		if (err < 0)
 			goto err_filter;
-		}
 	}
 
 	return filter;
-- 
2.20.1

