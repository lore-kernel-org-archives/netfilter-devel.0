From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/49]: replace list_for_each with list_for_each_entry
Date: Tue,  4 Dec 2007 13:01:57 +0100 (MET)
Message-ID: <20071204120157.2442.68510.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62096 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbXLDMB7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:01:59 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: replace list_for_each with list_for_each_entry

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c801dee0df0f79c1bf5dd448b4081c29c9266da8
tree a682609069d2b133c441e0df3081c6144e708c12
parent b3e4042d568acf92a0e4b5334c8a9ca499bb3a4a
author Li Zefan <lizf@cn.fujitsu.com> Tue, 04 Dec 2007 10:46:51 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:46:51 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 ++----
 net/netfilter/core.c               |    8 ++++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 2f544da..311361e 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -109,11 +109,9 @@ clusterip_config_entry_put(struct clusterip_config *c)
 static struct clusterip_config *
 __clusterip_config_find(__be32 clusterip)
 {
-	struct list_head *pos;
+	struct clusterip_config *c;
 
-	list_for_each(pos, &clusterip_configs) {
-		struct clusterip_config *c = list_entry(pos,
-					struct clusterip_config, list);
+	list_for_each_entry(c, &clusterip_configs, list) {
 		if (c->clusterip == clusterip)
 			return c;
 	}
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 631d269..e6d3a69 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -62,17 +62,17 @@ static DEFINE_MUTEX(nf_hook_mutex);
 
 int nf_register_hook(struct nf_hook_ops *reg)
 {
-	struct list_head *i;
+	struct nf_hook_ops *elem;
 	int err;
 
 	err = mutex_lock_interruptible(&nf_hook_mutex);
 	if (err < 0)
 		return err;
-	list_for_each(i, &nf_hooks[reg->pf][reg->hooknum]) {
-		if (reg->priority < ((struct nf_hook_ops *)i)->priority)
+	list_for_each_entry(elem, &nf_hooks[reg->pf][reg->hooknum], list) {
+		if (reg->priority < elem->priority)
 			break;
 	}
-	list_add_rcu(&reg->list, i->prev);
+	list_add_rcu(&reg->list, elem->list.prev);
 	mutex_unlock(&nf_hook_mutex);
 	return 0;
 }
