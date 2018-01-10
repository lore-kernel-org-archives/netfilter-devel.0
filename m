From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: core: return EBUSY in case NAT hook is already in use
Date: Wed, 10 Jan 2018 15:29:18 +0100
Message-ID: <20180110142918.23639-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34962 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755414AbeAJO30 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 09:29:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B93C11EC2C5
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:29:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB007DA843
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:29:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 347D2DA843
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:29:22 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F31214265A32
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:29:21 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

EEXIST is used for an object that already exists, with the same
name/handle. However, there no same object there, instead there is a
object that is using the single slot that is available for NAT hooks
since patch f92b40a8b264 ("netfilter: core: only allow one nat hook per
hook point"). Let's change this return value before this behaviour gets
exposed in the first -rc1.

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

