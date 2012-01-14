From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 5/8] netfilter: ipset: Dumping error triggered removing references twice
Date: Sat, 14 Jan 2012 17:38:58 +0100
Message-ID: <1326559141-26783-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:54788 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab2ANQjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:39:21 -0500
In-Reply-To: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
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
index 2babb65..aeee9bd 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1142,6 +1142,7 @@ release_refcount:
 	if (ret || !cb->args[2]) {
 		pr_debug("release set %s\n", ip_set_list[index]->name);
 		ip_set_put_byindex(index);
+		cb->args[2] = 0;
 	}
 out:
 	if (nlh) {
-- 
1.7.0.4

