From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 63/79: ebtables: fix one wrong return value
Date: Wed,  8 Oct 2008 12:47:46 +0200 (MEST)
Message-ID: <20081008104745.10423.56917.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYJHKrr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:47 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 147c3844ad381b58715a6ee2ea697594e3c06284
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:16 2008 +0200

    netfilter: ebtables: fix one wrong return value
    
    Usually -EINVAL is used when checkentry fails (see *_tables).
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index b489ed2..7d8ead5 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -699,7 +699,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	} else if (t->u.target->checkentry &&
 	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
 		module_put(t->u.target->me);
-		ret = -EFAULT;
+		ret = -EINVAL;
 		goto cleanup_watchers;
 	}
 	(*cnt)++;
