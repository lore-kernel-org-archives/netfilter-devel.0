From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH nf-next-2.6] netfilter: use vzalloc()
Date: Sat, 20 Nov 2010 19:01:56 +0100
Message-ID: <1290276116.2756.96.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32957 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0KTSCD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Nov 2010 13:02:03 -0500
Received: by wwa36 with SMTP id 36so5833241wwa.1
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Nov 2010 10:02:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nf_ct_alloc_hashtable() can use vzalloc()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 net/netfilter/nf_conntrack_core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0ba7d48..57a60c6 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1313,8 +1313,7 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced, int nulls)
 	if (!hash) {
 		*vmalloced = 1;
 		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
-		hash = __vmalloc(sz, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
-				 PAGE_KERNEL);
+		hash = vzalloc(sz);
 	}
 
 	if (hash && nulls)


