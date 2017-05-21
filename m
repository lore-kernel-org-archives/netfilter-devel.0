From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nat: use atomic bit op to clear the _SRC_NAT_DONE_BIT
Date: Sun, 21 May 2017 22:38:11 +0800
Message-ID: <1495377491-46768-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:57851 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751302AbdEUOjZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 May 2017 10:39:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

We need to clear the IPS_SRC_NAT_DONE_BIT to indicate that the ct has
been removed from nat_bysource table. But unfortunately, we use the
non-atomic bit operation: "ct->status &= ~IPS_NAT_DONE_MASK". So
there's a race condition that we may clear the _DYING_BIT set by
another CPU unexpectedly.

Since we don't care about the IPS_DST_NAT_DONE_BIT, so just using
clear_bit to clear the IPS_SRC_NAT_DONE_BIT is enough.

Also note, this is the last user which use the non-atomic bit operation
to update the confirmed ct->status.

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nf_nat_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index ef0be32..6c72922 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -566,7 +566,7 @@ static int nf_nat_proto_clean(struct nf_conn *ct, void *data)
 	 * Else, when the conntrack is destoyed, nf_nat_cleanup_conntrack()
 	 * will delete entry from already-freed table.
 	 */
-	ct->status &= ~IPS_NAT_DONE_MASK;
+	clear_bit(IPS_SRC_NAT_DONE_BIT, &ct->status);
 	rhltable_remove(&nf_nat_bysource_table, &ct->nat_bysource,
 			nf_nat_bysource_params);
 
-- 
2.5.5


