From: Krzysztof Piotr Oledzki <ole@ans.pl>
Subject: [PATCH] netfilter: add locking for counters zeroing
Date: Mon, 21 Jul 2008 18:46:58 +0200
Message-ID: <4884bd82.Dh41l9jJY8sI8ajg%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:35143 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYGUQrE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:47:04 -0400
Received: from bizon.gios.gov.pl (ole@localhost6 [IPv6:::1])
	by bizon.gios.gov.pl (8.14.3/8.14.3) with ESMTP id m6LGkwQJ002228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 18:47:00 +0200
Received: (from ole@localhost)
	by bizon.gios.gov.pl (8.14.3/8.14.3/Submit) id m6LGkw46002227
	for netfilter-devel@vger.kernel.org; Mon, 21 Jul 2008 18:46:58 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From 4407c0b11dde5235b1141ef63bc29f322a73c873 Mon Sep 17 00:00:00 2001
From: Krzysztof Piotr Oledzki <ole@ans.pl>
Date: Mon, 21 Jul 2008 17:20:45 +0200
Subject: netfilter: add locking for counters zeroing

The memset inside ctnetlink_dump_table() fuction needs locking.
The lock shoud be grabbed outside the loop to avoid repeatedly
taking and releasing it again.

Also add similar locking inside xt_connbytes match where
the counters get read.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
---
 net/netfilter/nf_conntrack_netlink.c |    2 ++
 net/netfilter/xt_connbytes.c         |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9432da4..ff1bbb0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -545,6 +545,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 	u_int8_t l3proto = nfmsg->nfgen_family;
 
 	rcu_read_lock();
+	spin_lock_bh(&nf_conntrack_lock);
 	last = (struct nf_conn *)cb->args[1];
 	for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
 restart:
@@ -588,6 +589,7 @@ restart:
 		}
 	}
 out:
+	spin_unlock_bh(&nf_conntrack_lock);
 	rcu_read_unlock();
 	if (last)
 		nf_ct_put(last);
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 3e39c4f..9d0253a 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -38,6 +38,7 @@ connbytes_mt(const struct sk_buff *skb, const struct net_device *in,
 	if (!counters)
 		return false;
 
+	spin_lock_bh(&nf_conntrack_lock);
 	switch (sinfo->what) {
 	case XT_CONNBYTES_PKTS:
 		switch (sinfo->direction) {
@@ -88,6 +89,7 @@ connbytes_mt(const struct sk_buff *skb, const struct net_device *in,
 			what = div64_u64(bytes, pkts);
 		break;
 	}
+	spin_unlock_bh(&nf_conntrack_lock);
 
 	if (sinfo->count.to)
 		return what <= sinfo->count.to && what >= sinfo->count.from;
-- 
1.5.6.1

