From: gfree.wind@vip.163.com
Subject: [PATCH nf] ebtables: arpreply: Add the standard target sanity check
Date: Fri, 12 May 2017 17:44:10 +0800
Message-ID: <1494582250-120912-1-git-send-email-gfree.wind@vip.163.com>
Cc: Gao Feng <gfree.wind@vip.163.com>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from proxy90-7.mail.163.com ([43.230.90.7]:55456 "EHLO
        proxy90-7.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932315AbdELJpZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 May 2017 05:45:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <gfree.wind@vip.163.com>

The info->target is from userspace and it would be used directly.
So we need to add the sanity check to make sure it is a valid standard
target, although the ebtables tool has already checked it. Kernel need
to check anything from userspace.

If the target was set as an evil value, it would break the ebtables
and cause a panic. Because the non-standard target is treated as one
offset.

Signed-off-by: Gao Feng <gfree.wind@vip.163.com>
---
 net/bridge/netfilter/ebt_arpreply.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 5929309..c4886d9 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -68,6 +68,9 @@ static int ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
 		return -EINVAL;
+	if (INVALID_TARGET)
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
1.9.1


