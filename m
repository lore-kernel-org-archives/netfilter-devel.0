From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.18 1/3]: recent match: fix "sleeping function called
 from invalid context"
Date: Thu, 08 Jun 2006 09:11:57 +0200
Message-ID: <4487CDBD.2070400@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070906090802040406010103"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070906090802040406010103
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

These three patches against net-2.6.18 fix two bugs in my recent
match rewrite and a minor thinko in the hashlimit match.

Please apply.



--------------070906090802040406010103
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: recent match: fix "sleeping function called from invalid context"

create_proc_entry must not be called with locks held. Use a mutex
instead to protect data only changed in user context.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6812aa38ac35d6e819058d2273a6a7de091a2604
tree 140fea396f29415d7981fcfbc5980f5c0b2d91a7
parent a0447a3000b5d4e926928493def9d62aae3b87ed
author Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 16:40:39 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 16:40:39 +0200

 net/ipv4/netfilter/ipt_recent.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 9686c4d..9b09e48 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -69,6 +69,7 @@ #endif
 
 static LIST_HEAD(tables);
 static DEFINE_SPINLOCK(recent_lock);
+static DEFINE_MUTEX(recent_mutex);
 
 #ifdef CONFIG_PROC_FS
 static struct proc_dir_entry	*proc_dir;
@@ -249,7 +250,7 @@ ipt_recent_checkentry(const char *tablen
 	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
 		return 0;
 
-	spin_lock_bh(&recent_lock);
+	mutex_lock(&recent_mutex);
 	t = recent_table_lookup(info->name);
 	if (t != NULL) {
 		t->refcnt++;
@@ -258,7 +259,7 @@ ipt_recent_checkentry(const char *tablen
 	}
 
 	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
-		    GFP_ATOMIC);
+		    GFP_KERNEL);
 	if (t == NULL)
 		goto out;
 	strcpy(t->name, info->name);
@@ -274,10 +275,12 @@ #ifdef CONFIG_PROC_FS
 	t->proc->proc_fops = &recent_fops;
 	t->proc->data      = t;
 #endif
+	spin_lock_bh(&recent_lock);
 	list_add_tail(&t->list, &tables);
+	spin_unlock_bh(&recent_lock);
 	ret = 1;
 out:
-	spin_unlock_bh(&recent_lock);
+	mutex_unlock(&recent_mutex);
 	return ret;
 }
 
@@ -288,17 +291,19 @@ ipt_recent_destroy(const struct xt_match
 	const struct ipt_recent_info *info = matchinfo;
 	struct recent_table *t;
 
-	spin_lock_bh(&recent_lock);
+	mutex_lock(&recent_mutex);
 	t = recent_table_lookup(info->name);
 	if (--t->refcnt == 0) {
+		spin_lock_bh(&recent_lock);
 		list_del(&t->list);
+		spin_unlock_bh(&recent_lock);
 		recent_table_flush(t);
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry(t->name, proc_dir);
 #endif
 		kfree(t);
 	}
-	spin_unlock_bh(&recent_lock);
+	mutex_unlock(&recent_mutex);
 }
 
 #ifdef CONFIG_PROC_FS

--------------070906090802040406010103--
