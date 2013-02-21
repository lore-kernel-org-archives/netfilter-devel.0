From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/2] netfilter: ipset: "Directory not empty" error message
Date: Thu, 21 Feb 2013 17:45:46 +0100
Message-ID: <1361465146-11861-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1361465146-11861-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:43033 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab3BUQps (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2013 11:45:48 -0500
In-Reply-To: <1361465146-11861-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When an entry flagged with "nomatch" was tested by ipset, it
returned the error message "Kernel error received:
Directory not empty" instead of "<element> is NOT in set <setname>"
(reported by John Brendler).

The internal error code was not properly transformed before returning
to userspace, fixed.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 6d6d8f2..38ca630 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1470,7 +1470,8 @@ ip_set_utest(struct sock *ctnl, struct sk_buff *skb,
 	if (ret == -EAGAIN)
 		ret = 1;
 
-	return ret < 0 ? ret : ret > 0 ? 0 : -IPSET_ERR_EXIST;
+	return (ret < 0 && ret != -ENOTEMPTY) ? ret :
+		ret > 0 ? 0 : -IPSET_ERR_EXIST;
 }
 
 /* Get headed data of a set */
-- 
1.7.0.4

