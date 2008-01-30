From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 26/69]: nfnetlink_log: sparse warning fixes
Date: Wed, 30 Jan 2008 21:17:34 +0100 (MET)
Message-ID: <20080130201732.29874.23302.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60704 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396AbYA3URg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:17:36 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nfnetlink_log: sparse warning fixes

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7f16025ab2a78e16a58f5c4d655d568945ecc9dc
tree 64cf943b261f105fbfe0c076e78d71a5c414d1ba
parent 70d4a3d143164c03c11ad8d14a646e46453f4c76
author Stephen Hemminger <shemminger@vyatta.com> Tue, 29 Jan 2008 16:22:05 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:18 +0100

 net/netfilter/nfnetlink_log.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2348fcb..7efa40d 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -866,6 +866,7 @@ static struct hlist_node *get_idx(struct iter_state *st, loff_t pos)
 }
 
 static void *seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(instances_lock)
 {
 	read_lock_bh(&instances_lock);
 	return get_idx(seq->private, *pos);
@@ -878,6 +879,7 @@ static void *seq_next(struct seq_file *s, void *v, loff_t *pos)
 }
 
 static void seq_stop(struct seq_file *s, void *v)
+	__releases(instances_lock)
 {
 	read_unlock_bh(&instances_lock);
 }
