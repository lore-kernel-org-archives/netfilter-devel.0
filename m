From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/09]: nf_queue: don't return error when unregistering a non-existant handler
Date: Mon, 10 Mar 2008 19:26:25 +0100 (MET)
Message-ID: <20080310182627.20404.50731.sendpatchset@localhost.localdomain>
References: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34282 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYCJS00 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:26:26 -0400
In-Reply-To: <20080310182615.20404.67685.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_queue: don't return error when unregistering a non-existant handler

Commit ce7663d84:

[NETFILTER]: nfnetlink_queue: don't unregister handler of other subsystem

changed nf_unregister_queue_handler to return an error when attempting to
unregister a queue handler that is not identical to the one passed in.
This is correct in case we really do have a different queue handler already
registered, but some existing userspace code always does an unbind before
bind and aborts if that fails, so try to be nice and return success in
that case.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c5fa0de9a02e442b8dc72db52f5fa9154b73b49d
tree 414b455f6fad5a9839b7e852d9e62d4dc6f7990d
parent 68b176bf4421f595f94c8a80fffcf4cc06d7edc4
author Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 19:13:13 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 10 Mar 2008 19:13:13 +0100

 net/netfilter/nf_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 6bfdb78..61b55a5 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -51,7 +51,7 @@ int nf_unregister_queue_handler(int pf, const struct nf_queue_handler *qh)
 		return -EINVAL;
 
 	mutex_lock(&queue_handler_mutex);
-	if (queue_handler[pf] != qh) {
+	if (queue_handler[pf] && queue_handler[pf] != qh) {
 		mutex_unlock(&queue_handler_mutex);
 		return -EINVAL;
 	}
