From: Aaron Conole <aconole@bytheb.org>
Subject: [PATCH nf-next] netfilter: add list element test to br_netfilter_hooks
Date: Tue, 06 Dec 2016 10:04:58 -0500
Message-ID: <f7tpol514kl.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: dan.carpenter@oracle.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34981 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751556AbcLFPFt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 10:05:49 -0500
Received: by mail-qk0-f196.google.com with SMTP id n204so44031676qke.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Dec 2016 07:05:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The for-loop in the bridge hook entries assumes that the elements are
always present.  However, this assumption may not always be true.

Fixes: 66cfc1dd07c7 ("netfilter: convert while loops to for loops")
Signed-off-by: Aaron Conole <aconole@bytheb.org>
--
Pablo, if possible could this be squashed into the commit instead?  I
only did a build test of this, but it should be correct.

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index fbe35b4..b12501a 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -1009,7 +1009,7 @@ int br_nf_hook_thresh(unsigned int hook, struct net *net,
 	int ret;
 
 	for (elem = rcu_dereference(net->nf.hooks[NFPROTO_BRIDGE][hook]);
-	     nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF;
+	     elem && nf_hook_entry_priority(elem) <= NF_BR_PRI_BRNF;
 	     elem = rcu_dereference(elem->next))
 		;

--
2.5.0
