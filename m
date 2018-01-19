From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/32] netfilter: core: return EBUSY in case NAT hook is already in use
Date: Fri, 19 Jan 2018 20:10:21 +0100
Message-ID: <20180119191041.25804-13-pablo@netfilter.org>
References: <20180119191041.25804-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756234AbeASTLE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 14:11:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B5AB2EFEB2
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18B5FDA38C
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 20:11:01 +0100 (CET)
In-Reply-To: <20180119191041.25804-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

EEXIST is used for an object that already exists, with the same
name/handle. However, there no same object there, instead there is a
object that is using the single slot that is available for NAT hooks
since patch f92b40a8b264 ("netfilter: core: only allow one nat hook per
hook point"). Let's change this return value before this behaviour gets
exposed in the first -rc.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3f8e2d06b9cc..0f6b8172fb9a 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -140,7 +140,7 @@ nf_hook_entries_grow(const struct nf_hook_entries *old,
 
 		if (reg->nat_hook && orig_ops[i]->nat_hook) {
 			kvfree(new);
-			return ERR_PTR(-EEXIST);
+			return ERR_PTR(-EBUSY);
 		}
 
 		if (inserted || reg->priority > orig_ops[i]->priority) {
-- 
2.11.0

