From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: ipt_recent: fix race between recent_mt_destroy and proc manipulations
Date: Thu, 31 Jul 2008 08:33:15 +0200 (MEST)
Message-ID: <20080731063314.18150.31778.sendpatchset@localhost.localdomain>
References: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34604 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYGaGdQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 02:33:16 -0400
In-Reply-To: <20080731063312.18150.49494.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: ipt_recent: fix race between recent_mt_destroy and proc manipulations

The thing is that recent_mt_destroy first flushes the entries
from table with the recent_table_flush and only *after* this
removes the proc file, corresponding to that table.

Thus, if we manage to write to this file the '+XXX' command we
will leak some entries. If we manage to write there a 'clean'
command we'll race in two recent_table_flush flows, since the
recent_mt_destroy calls this outside the recent_lock.

The proper solution as I see it is to remove the proc file first
and then go on with flushing the table. This flushing becomes
safe w/o the lock, since the table is already inaccessible from
the outside.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 728845f8c11ec11be4a3725a70389a3013cd4e48
tree c6dfca9346769ab48550ba27c28a3ba2af94e30b
parent 827768d3835412f6ba386c9fc2d6fdbde0c2c0ee
author Pavel Emelyanov <xemul@openvz.org> Wed, 30 Jul 2008 12:52:38 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jul 2008 12:52:38 +0200

 net/ipv4/netfilter/ipt_recent.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 21cb053..3974d7c 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -305,10 +305,10 @@ static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
 		spin_lock_bh(&recent_lock);
 		list_del(&t->list);
 		spin_unlock_bh(&recent_lock);
-		recent_table_flush(t);
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry(t->name, proc_dir);
 #endif
+		recent_table_flush(t);
 		kfree(t);
 	}
 	mutex_unlock(&recent_mutex);
