From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch net] ipt_CLUSTERIP: fix a race condition of proc file creation
Date: Wed,  7 Feb 2018 21:59:17 -0800
Message-ID: <20180208055918.20411-1-xiyou.wangcong@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

There is a race condition between clusterip_config_entry_put()
and clusterip_config_init(), after we release the spinlock in
clusterip_config_entry_put(), a new proc file with a same IP could
be created immediately since it is already removed from the configs
list, therefore it triggers this warning:

------------[ cut here ]------------
proc_dir_entry 'ipt_CLUSTERIP/172.20.0.170' already registered
WARNING: CPU: 1 PID: 4152 at fs/proc/generic.c:330 proc_register+0x2a4/0x370 fs/proc/generic.c:329
Kernel panic - not syncing: panic_on_warn set ...

As a quick fix, just move the proc_remove() inside the spinlock.

Reported-by: <syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com>
Fixes: 6c5d5cfbe3c5 ("netfilter: ipt_CLUSTERIP: check duplicate config when initializing")
Tested-by: Paolo Abeni <pabeni@redhat.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 3a84a60f6b39..1ff72b87a066 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -107,12 +107,6 @@ clusterip_config_entry_put(struct net *net, struct clusterip_config *c)
 
 	local_bh_disable();
 	if (refcount_dec_and_lock(&c->entries, &cn->lock)) {
-		list_del_rcu(&c->list);
-		spin_unlock(&cn->lock);
-		local_bh_enable();
-
-		unregister_netdevice_notifier(&c->notifier);
-
 		/* In case anyone still accesses the file, the open/close
 		 * functions are also incrementing the refcount on their own,
 		 * so it's safe to remove the entry even if it's in use. */
@@ -120,6 +114,12 @@ clusterip_config_entry_put(struct net *net, struct clusterip_config *c)
 		if (cn->procdir)
 			proc_remove(c->pde);
 #endif
+		list_del_rcu(&c->list);
+		spin_unlock(&cn->lock);
+		local_bh_enable();
+
+		unregister_netdevice_notifier(&c->notifier);
+
 		return;
 	}
 	local_bh_enable();
-- 
2.13.0
