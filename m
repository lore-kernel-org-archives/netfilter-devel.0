From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 04/08: xt_time: fix time's time_mt()'s use of do_div()
Date: Mon, 21 Jul 2008 18:17:28 +0200 (MEST)
Message-ID: <20080721161728.28572.17464.sendpatchset@localhost.localdomain>
References: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41621 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYGUQR3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:17:29 -0400
In-Reply-To: <20080721161722.28572.97957.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: xt_time: fix time's time_mt()'s use of do_div()

Fix netfilter xt_time's time_mt()'s use of do_div() on an s64 by using
div_s64() instead.

This was introduced by patch ee4411a1b1e0b679c99686629b5eab5a072ce49f.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 281de5230fde71e8799f18c4df1fa35f61b023d1
tree 108e7df333f946eb6d7c45249991ee072ab1f8a7
parent af2f44cbf0bc523048ff20b21dc83b5b4d305baf
author David Howells <dhowells@redhat.com> Mon, 21 Jul 2008 18:05:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 21 Jul 2008 18:05:57 +0200

 net/netfilter/xt_time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index ed76baa..9f32859 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -173,7 +173,7 @@ time_mt(const struct sk_buff *skb, const struct net_device *in,
 		__net_timestamp((struct sk_buff *)skb);
 
 	stamp = ktime_to_ns(skb->tstamp);
-	do_div(stamp, NSEC_PER_SEC);
+	stamp = div_s64(stamp, NSEC_PER_SEC);
 
 	if (info->flags & XT_TIME_LOCAL_TZ)
 		/* Adjust for local timezone */
