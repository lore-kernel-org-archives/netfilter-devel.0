From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 37/49]: remove annoying debugging message
Date: Tue,  4 Dec 2007 13:02:47 +0100 (MET)
Message-ID: <20071204120247.2442.52653.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62217 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbXLDMCt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:49 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: remove annoying debugging message

Don't log "nf_hook: Verdict = QUEUE." message with NETFILTER_DEBUG=y.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e1b5dfe8599c62320973aa270e94c4d4e8872db9
tree 23c0eab90a429fe9f462de9bd0c6e506d01eded2
parent 486aae228a98e75818b5e7091c3efd62c4b0f6a1
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:47:59 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:32 +0100

 net/netfilter/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 6819a41..95e1863 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -178,8 +178,7 @@ next_hook:
 	} else if (verdict == NF_DROP) {
 		kfree_skb(skb);
 		ret = -EPERM;
-	} else if ((verdict & NF_VERDICT_MASK)  == NF_QUEUE) {
-		NFDEBUG("nf_hook: Verdict = QUEUE.\n");
+	} else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
 		if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
 			      verdict >> NF_VERDICT_BITS))
 			goto next_hook;
