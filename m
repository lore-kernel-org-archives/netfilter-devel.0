From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/2 nf] netfilter: nf_queue: don't re-enter same hook on packet reinjection
Date: Thu, 13 Oct 2016 11:23:06 +0200
Message-ID: <1476350587-2837-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51766 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753142AbcJMJX2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Oct 2016 05:23:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE1F24B8
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 11:23:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDFC6DA913
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 11:23:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 49AE7DA7FA
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Oct 2016 11:23:19 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make sure we skip the current hook from where the packet was enqueued,
otherwise the packets gets enqueued over and over again.

Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I managed to reproduce this with a simple test.

 # iptables -I OUTPUT -j QUEUE
 # cd libnetfilter_queue/utils/
 # ./nfqnl_test

Without my patch, netfilter munches packets that are reinjected.

@Aaron: Please, I'd appreciate if you can have a look to confirm this bug
        and the fix. Thanks.

 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 96964a0070e1..221d7a5c2fec 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -184,6 +184,7 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 			verdict = NF_DROP;
 	}
 
+	hook_entry = rcu_dereference(hook_entry->next);
 	entry->state.thresh = INT_MIN;
 
 	if (verdict == NF_ACCEPT) {
-- 
2.1.4

