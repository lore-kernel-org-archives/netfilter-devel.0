From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/1] netfilter: ebtables: fix one wrong return value
Date: Mon,  6 Oct 2008 13:45:10 -0400
Message-ID: <9ea25486b5c9b3aed90525721fe598397a5e2581.1223315105.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34982 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYJFRpN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 13:45:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Usually -EINVAL is used when checkentry fails (see *_tables).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/ebtables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 340e1c6..942739d 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -756,7 +756,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	} else if (t->u.target->checkentry &&
 	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
 		module_put(t->u.target->me);
-		ret = -EFAULT;
+		ret = -EINVAL;
 		goto cleanup_watchers;
 	}
 	(*cnt)++;
-- 
1.6.0.1

