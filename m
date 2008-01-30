From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/69]: ipt_recent: fix sparse warnings
Date: Wed, 30 Jan 2008 21:17:41 +0100 (MET)
Message-ID: <20080130201738.29874.37700.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60716 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765268AbYA3URn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:43 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ipt_recent: fix sparse warnings

net/ipv4/netfilter/ipt_recent.c:215:17: warning: symbol 't' shadows an earlier one
net/ipv4/netfilter/ipt_recent.c:179:22: originally declared here
net/ipv4/netfilter/ipt_recent.c:322:13: warning: context imbalance in 'recent_seq_start' - wrong count at exit
net/ipv4/netfilter/ipt_recent.c:354:13: warning: context imbalance in 'recent_seq_stop' - unexpected unlock

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 15a3018c4c11086b7dc5310aae4d1f13640fe844
tree b053ffabbb0186460955dafe935653aaf2e83e4a
parent a0b8676ce8423a544c283c59ac3d0c97e2e64b21
author Patrick McHardy <kaber@trash.net> Tue, 29 Jan 2008 16:22:08 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:19 +0100

 net/ipv4/netfilter/ipt_recent.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index e3154a9..68cbe3c 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -212,11 +212,11 @@ recent_mt(const struct sk_buff *skb, const struct net_device *in,
 		recent_entry_remove(t, e);
 		ret = !ret;
 	} else if (info->check_set & (IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) {
-		unsigned long t = jiffies - info->seconds * HZ;
+		unsigned long time = jiffies - info->seconds * HZ;
 		unsigned int i, hits = 0;
 
 		for (i = 0; i < e->nstamps; i++) {
-			if (info->seconds && time_after(t, e->stamps[i]))
+			if (info->seconds && time_after(time, e->stamps[i]))
 				continue;
 			if (++hits >= info->hit_count) {
 				ret = !ret;
@@ -320,6 +320,7 @@ struct recent_iter_state {
 };
 
 static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(recent_lock)
 {
 	struct recent_iter_state *st = seq->private;
 	const struct recent_table *t = st->table;
@@ -352,6 +353,7 @@ static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 }
 
 static void recent_seq_stop(struct seq_file *s, void *v)
+	__releases(recent_lock)
 {
 	spin_unlock_bh(&recent_lock);
 }
