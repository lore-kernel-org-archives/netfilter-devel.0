From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/4] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 20 Apr 2010 20:26:16 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004201958220.5154@obet.zrqbmnf.qr>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-3-git-send-email-jengelh@medozas.de> <4BCC4B19.7040805@trash.net> <alpine.LSU.2.01.1004191451100.9177@obet.zrqbmnf.qr> <4BCC636A.1080401@trash.net>
 <4BCDA9BC.50201@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57623 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0DTS0S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:26:18 -0400
In-Reply-To: <4BCDA9BC.50201@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-04-20 15:18, Patrick McHardy wrote:
>
>I just noticed a problem with this patch:
>
>[  428.295752] BUG: sleeping function called from invalid context at
>mm/slub.c:1705
>[  428.295762] in_atomic(): 1, irqs_disabled(): 0, pid: 9111, name: iptables
>[  428.295771] Pid: 9111, comm: iptables Not tainted 2.6.34-rc1 #2
>[  428.295776] Call Trace:
>[  428.295791]  [<c012138e>] __might_sleep+0xe5/0xed
>[  428.295801]  [<c019e8ca>] __kmalloc+0x92/0xfc
>[  428.295825]  [<f865b3bb>] ? xt_jumpstack_alloc+0x36/0xff [x_tables]
>[  428.295839]  [<f865b3bb>] xt_jumpstack_alloc+0x36/0xff [x_tables]
>
>You probably shouldn't be allocating the jumpstack while BHs are
>disabled.


The following patch should address this. It's easily movable
as it only does work on newinfo itself.



The following changes since commit 6c79bf0f2440fd250c8fce8d9b82fcf03d4e8350:
  Bart De Schuymer (1):
        netfilter: bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE traffic

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (1):
      netfilter: x_tables: move sleeping allocation outside BH-disabled region

 net/netfilter/x_tables.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

parent 6c79bf0f2440fd250c8fce8d9b82fcf03d4e8350 (v2.6.34-rc3-1335-g6c79bf0)
commit 3109d6b7342a5c8bf23697a86be12e733472d820
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Apr 20 20:11:15 2010 +0200

netfilter: x_tables: move sleeping allocation outside BH-disabled region

The jumpstack allocation needs to be moved out of the critical region.
Corrects this notice:

BUG: sleeping function called from invalid context at mm/slub.c:1705
[  428.295762] in_atomic(): 1, irqs_disabled(): 0, pid: 9111, name: iptables
[  428.295771] Pid: 9111, comm: iptables Not tainted 2.6.34-rc1 #2
[  428.295776] Call Trace:
[  428.295791]  [<c012138e>] __might_sleep+0xe5/0xed
[  428.295801]  [<c019e8ca>] __kmalloc+0x92/0xfc
[  428.295825]  [<f865b3bb>] ? xt_jumpstack_alloc+0x36/0xff [x_tables]

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 3ae3234..445de70 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -801,6 +801,12 @@ xt_replace_table(struct xt_table *table,
 	struct xt_table_info *private;
 	int ret;
 
+	ret = xt_jumpstack_alloc(newinfo);
+	if (ret < 0) {
+		*error = ret;
+		return NULL;
+	}
+
 	/* Do the substitution. */
 	local_bh_disable();
 	private = table->private;
@@ -814,12 +820,6 @@ xt_replace_table(struct xt_table *table,
 		return NULL;
 	}
 
-	ret = xt_jumpstack_alloc(newinfo);
-	if (ret < 0) {
-		*error = ret;
-		return NULL;
-	}
-
 	table->private = newinfo;
 	newinfo->initial_entries = private->initial_entries;
 
-- 
# Created with git-export-patch
