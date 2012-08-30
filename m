From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race
 condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 02:52:36 +0200
Message-ID: <20120830005236.GA8127@1984>
References: <7353554.n89QJXU3eh@gentoovm>
 <20120828105235.GA22669@1984>
 <9829027.jsWF3AolUh@gentoovm>
 <1605551.o4ZNqbFbkc@gentoovm>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Cc: netfilter-devel@vger.kernel.org
To: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41025 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab2H3Awm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Aug 2012 20:52:42 -0400
Content-Disposition: inline
In-Reply-To: <1605551.o4ZNqbFbkc@gentoovm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 29, 2012 at 01:10:29AM +0200, Oliver wrote:
> On Tuesday 28 August 2012 19:16:39 Oliver wrote:
> > During testing I found that the kernel is indeed solid and does not panic;
> > however, I managed to make conntrackd eat 100% of a CPU core on one of the
> > pair and conntrack entries remained unevicted from the kernel until I killed
> > the conntrackd process.
> 
> having conntrackd running while the conntrack table is full is causing a GPF - 
> I have attached a dmesg output of the kernel panic resulting from a general 
> protection fault.
> 
> The first GPF is from the kernel patched with the code provided in my previous 
> e-mail (the one for v3.4.10 based on the patch you provided me)
> 
> the second is with my only my original patch (the one-liner that checks the 
> dying bit in death_by_event) - although that's likely not relevant here since 
> that function is not part of the stack.

The problem seems to be the re-use of the conntrack timer. Races may
happen in entries that were just inserted in the dying list while
packets / ctnetlink still hold a reference to them.

Would you give a try to this patch? Please, remove the previous I
sent.

Let me know if you hit more crashes. Thanks.

--EeQfGwPcQSOJBaQU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nf_conntrack-fix-racy-timer-handling-with-.patch"

>From 413243208640a973ba48111eaec143efa3ca7a31 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 30 Aug 2012 02:02:51 +0200
Subject: [PATCH] netfilter: nf_conntrack: fix racy timer handling with
 reliable events

Existing code assumes that del_timer returns true for alive conntrack
entries. However, this is not true if reliable events are enabled.
In that case, del_timer may return true for entries that were
just inserted in the dying list. Note that packets may hold references
to conntrack entries that were just inserted to such list.

This patch fixes the issue by adding an independent timer for
event delivery. This increases the size of the ecache extension.
Still we can revisit this later and use support for variable size
extensions to allocate this area on demand.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h |    1 +
 net/netfilter/nf_conntrack_core.c           |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index e1ce104..4a045cd 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -18,6 +18,7 @@ struct nf_conntrack_ecache {
 	u16 ctmask;		/* bitmask of ct events to be delivered */
 	u16 expmask;		/* bitmask of expect events to be delivered */
 	u32 pid;		/* netlink pid of destroyer */
+	struct timer_list timeout;
 };
 
 static inline struct nf_conntrack_ecache *
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fc61f40..2d8f91a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -249,12 +249,15 @@ static void death_by_event(unsigned long ul_conntrack)
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 	struct net *net = nf_ct_net(ct);
+	struct nf_conn_ecache *ecache = nf_ct_ecache_find(ct);
+
+	BUG_ON(ecache == NULL);
 
 	if (nf_conntrack_event(IPCT_DESTROY, ct) < 0) {
 		/* bad luck, let's retry again */
-		ct->timeout.expires = jiffies +
+		ecache->timeout.expires = jiffies +
 			(random32() % net->ct.sysctl_events_retry_timeout);
-		add_timer(&ct->timeout);
+		add_timer(&ecache->timeout);
 		return;
 	}
 	/* we've got the event delivered, now it's dying */
@@ -268,6 +271,9 @@ static void death_by_event(unsigned long ul_conntrack)
 void nf_ct_insert_dying_list(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
+	struct nf_conn_ecache *ecache = nf_ct_ecache_find(ct);
+
+	BUG_ON(ecache == NULL);
 
 	/* add this conntrack to the dying list */
 	spin_lock_bh(&nf_conntrack_lock);
@@ -275,10 +281,10 @@ void nf_ct_insert_dying_list(struct nf_conn *ct)
 			     &net->ct.dying);
 	spin_unlock_bh(&nf_conntrack_lock);
 	/* set a new timer to retry event delivery */
-	setup_timer(&ct->timeout, death_by_event, (unsigned long)ct);
-	ct->timeout.expires = jiffies +
+	setup_timer(&ecache->timeout, death_by_event, (unsigned long)ct);
+	ecache->timeout.expires = jiffies +
 		(random32() % net->ct.sysctl_events_retry_timeout);
-	add_timer(&ct->timeout);
+	add_timer(&ecache->timeout);
 }
 EXPORT_SYMBOL_GPL(nf_ct_insert_dying_list);
 
-- 
1.7.10.4


--EeQfGwPcQSOJBaQU--
