From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/4] netfilter: conntrack: __nf_ct_l4proto_find() always returns valid pointer
Date: Tue,  3 May 2016 12:51:54 +0200
Message-ID: <1462272716-23603-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50963 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbcECKwU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 06:52:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BDEB013C0D9
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:52:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC787ADE2
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:52:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 83C5CA86B
	for <netfilter-devel@vger.kernel.org>; Tue,  3 May 2016 12:52:16 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove unnecessary check for non-nul pointer in destroy_conntrack()
given that __nf_ct_l4proto_find() returns the generic protocol tracker
if the protocol is not supported.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 1fd0ff1..32fba4f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -360,7 +360,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	}
 	rcu_read_lock();
 	l4proto = __nf_ct_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
-	if (l4proto && l4proto->destroy)
+	if (l4proto->destroy)
 		l4proto->destroy(ct);
 
 	rcu_read_unlock();
-- 
2.1.4

