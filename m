From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/6] netfilter: ipset: Dumping error could lead to kernel BUG
Date: Tue,  6 Sep 2011 21:59:03 +0200
Message-ID: <1315339147-9617-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:59660 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab1IFT7p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:59:45 -0400
In-Reply-To: <1315339147-9617-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If there was a dumping error in the middle, the set-specific variable was
not zeroed out and thus the 'done' function of the dumping wrongly tried
to release the already released reference of the set. The already released
reference was caught by __ip_set_put and triggered a kernel BUG message.
The issue was reported by Jean-Philippe Menil.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 5370fd8..7fa4a89 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1143,6 +1143,7 @@ release_refcount:
 	if (ret || !cb->args[2]) {
 		pr_debug("release set %s\n", ip_set_list[index]->name);
 		ip_set_put_byindex(index);
+		cb->args[2] = 0;
 	}
 out:
 	if (nlh) {
-- 
1.7.0.4

