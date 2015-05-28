From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCH] Revert "netfilter: ensure number of counters is >0 in do_replace()"
Date: Thu, 28 May 2015 10:26:18 +0200
Message-ID: <1432801578-11970-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.132]:59789 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbbE1I0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 04:26:49 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 0D38810736BC
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2015 10:26:48 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This partially reverts commit 1086bbe97a07 ("netfilter: ensure number of
counters is >0 in do_replace()") in net/bridge/netfilter/ebtables.c.

Setting rules with ebtables does not work any more with 1086bbe97a07 place.

There is an error message and no rules set in the end.

e.g.

~# ebtables -t nat -A POSTROUTING --src 12:34:56:78:9a:bc -j DROP
Unable to update the kernel. Two possible causes:
1. Multiple ebtables programs were executing simultaneously. The ebtables
   userspace tool doesn't by default support multiple ebtables programs
running

Reverting the ebtables part of 1086bbe97a07 makes this work again.

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
 net/bridge/netfilter/ebtables.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index d5aba39..5149d9e 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1117,8 +1117,6 @@ static int do_replace(struct net *net, const void __user *user,
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
-	if (tmp.num_counters == 0)
-		return -EINVAL;
 
 	tmp.name[sizeof(tmp.name) - 1] = 0;
 
@@ -2161,8 +2159,6 @@ static int compat_copy_ebt_replace_from_user(struct ebt_replace *repl,
 		return -ENOMEM;
 	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
 		return -ENOMEM;
-	if (tmp.num_counters == 0)
-		return -EINVAL;
 
 	memcpy(repl, &tmp, offsetof(struct ebt_replace, hook_entry));
 
-- 
1.7.10.4

