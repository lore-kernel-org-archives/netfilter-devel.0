From: Paolo Abeni <pabeni@redhat.com>
Subject: Re: WARNING: proc registration bug in clusterip_tg_check
Date: Wed,  7 Feb 2018 11:41:48 +0100
Message-ID: <945c8517a87c671825b61223088064ea2ad0a8cb.1517999262.git.pabeni@redhat.com>
References: <089e082d13a0cf25ed05648bf8b3@google.com>
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org, Cong Wang <xiyou.wangcong@gmail.com>
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <089e082d13a0cf25ed05648bf8b3@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

I can't reproduce the issue locally, so asking the syzbot to test the 
tentive fix for me (and hoping I did not mess with the tag/format) 

---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 3a84a60f6b39..db103cd971a9 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -230,17 +230,6 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 	refcount_set(&c->refcount, 1);
 	refcount_set(&c->entries, 1);
 
-	spin_lock_bh(&cn->lock);
-	if (__clusterip_config_find(net, ip)) {
-		spin_unlock_bh(&cn->lock);
-		kfree(c);
-
-		return ERR_PTR(-EBUSY);
-	}
-
-	list_add_rcu(&c->list, &cn->configs);
-	spin_unlock_bh(&cn->lock);
-
 #ifdef CONFIG_PROC_FS
 	{
 		char buffer[16];
@@ -257,20 +246,31 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
 	}
 #endif
 
+	spin_lock_bh(&cn->lock);
+	if (__clusterip_config_find(net, ip)) {
+		spin_unlock_bh(&cn->lock);
+		err = -EBUSY;
+		goto err_remove_pte:
+	}
+
+	list_add_rcu(&c->list, &cn->configs);
+	spin_unlock_bh(&cn->lock);
+
 	c->notifier.notifier_call = clusterip_netdev_event;
 	err = register_netdevice_notifier(&c->notifier);
 	if (!err)
 		return c;
 
+	spin_lock_bh(&cn->lock);
+	list_del_rcu(&c->list);
+	spin_unlock_bh(&cn->lock);
+
+err_remove_pte:
 #ifdef CONFIG_PROC_FS
 	proc_remove(c->pde);
 err:
 #endif
-	spin_lock_bh(&cn->lock);
-	list_del_rcu(&c->list);
-	spin_unlock_bh(&cn->lock);
 	kfree(c);
-
 	return ERR_PTR(err);
 }
 
-- 
2.14.3
