From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 43/49]: nfnetlink_queue: mark hash table __read_mostly
Date: Tue,  4 Dec 2007 13:02:56 +0100 (MET)
Message-ID: <20071204120256.2442.80908.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62237 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbXLDMC5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:57 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: mark hash table __read_mostly

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0f3f456cc6f127fd14808cc03937ddca79057777
tree afeb9ba6ce5596ef9b626045906b3d43d58b94af
parent adf817a9cb4ba64618227e93a4d4f84fedc72ef1
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:17 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:34 +0100

 net/netfilter/nfnetlink_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c3aba1e..de48fd3 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -63,7 +63,7 @@ typedef int (*nfqnl_cmpfn)(struct nf_queue_entry *, unsigned long);
 static DEFINE_SPINLOCK(instances_lock);
 
 #define INSTANCE_BUCKETS	16
-static struct hlist_head instance_table[INSTANCE_BUCKETS];
+static struct hlist_head instance_table[INSTANCE_BUCKETS] __read_mostly;
 
 static inline u_int8_t instance_hashfn(u_int16_t queue_num)
 {
