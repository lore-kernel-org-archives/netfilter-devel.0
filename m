From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf,v2] netfilter: nf_queue: don't re-enter same hook on packet reinjection
Date: Fri, 14 Oct 2016 12:37:26 +0200
Message-ID: <1476441446-19611-1-git-send-email-pablo@netfilter.org>
Cc: aconole@bytheb.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33250 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753190AbcJNKhj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 06:37:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E39F0131CD7
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 12:37:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D615DBAC29
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 12:37:36 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FA36DA81C
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 12:37:34 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure we skip the current hook from where the packet was enqueued,
otherwise the packets gets enqueued over and over again.

Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: Make sure next hook is non-null, otherwise we are at the end of the
    hook list and we can skip nf_iterate().

 net/netfilter/nf_queue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 96964a0070e1..691e713d70f5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -185,8 +185,9 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	entry->state.thresh = INT_MIN;
+	hook_entry = rcu_dereference(hook_entry->next);
 
-	if (verdict == NF_ACCEPT) {
+	if (hook_entry && verdict == NF_ACCEPT) {
 	next_hook:
 		verdict = nf_iterate(skb, &entry->state, &hook_entry);
 	}
-- 
2.1.4

