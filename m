From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 45/49]: nfnetlink_queue: eliminate impossible switch case
Date: Tue,  4 Dec 2007 13:02:59 +0100 (MET)
Message-ID: <20071204120258.2442.2136.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62242 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXLDMDA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:03:00 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_queue: eliminate impossible switch case

We don't need a default case in nfqnl_build_packet_message(), the
copy_mode is validated when it is set. Tell the compiler about
the possible types and remove the default case. Saves 80b of
text on x86_64.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9e5fe442940e535b1839192dfde9ef67ae1a3042
tree 42c7a34a6fc51a63e4b9a95cd1667b9bbdd73bb4
parent d6607c3125212178c2b519dc6304fd38a6ed2ee9
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:22 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:35 +0100

 net/netfilter/nfnetlink_queue.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 436b442..abd5ff9 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -232,7 +232,7 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 	spin_lock_bh(&queue->lock);
 
-	switch (queue->copy_mode) {
+	switch ((enum nfqnl_config_mode)queue->copy_mode) {
 	case NFQNL_COPY_META:
 	case NFQNL_COPY_NONE:
 		data_len = 0;
@@ -253,11 +253,6 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
 
 		size += nla_total_size(data_len);
 		break;
-
-	default:
-		*errp = -EINVAL;
-		spin_unlock_bh(&queue->lock);
-		return NULL;
 	}
 
 	entry->id = queue->id_sequence++;
