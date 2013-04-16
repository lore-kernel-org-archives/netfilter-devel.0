From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/28] proc: Supply an accessor to get the name in a
 proc_dir_entry struct [RFC]
Date: Tue, 16 Apr 2013 19:27:25 +0100
Message-ID: <20130416182725.27773.42175.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org,
	Harald Welte <laforge@netfilter.org>,
	netfilter-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
	Jan Engelhardt <jengelh@medozas.de>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Supply an accessor to get access to the name in a proc_dir_entry struct, just
returning a const pointer to it.

This is only needed by the xt_hashlimit netfilter module as that appears to
use the name in the pde to save a label in the xt_hashlimit_htable struct -
which will be a problem if CONFIG_PROC_FS=n.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Harald Welte <laforge@netfilter.org>
cc: Jan Engelhardt <jengelh@medozas.de>
cc: netfilter-devel@vger.kernel.org
---

 fs/proc/generic.c            |    6 ++++++
 include/linux/proc_fs.h      |    1 +
 net/netfilter/xt_hashlimit.c |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 75e08d3..2c6d6be 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -624,3 +624,9 @@ void *proc_get_parent_data(const struct inode *inode)
 	return de->parent->data;
 }
 EXPORT_SYMBOL_GPL(proc_get_parent_data);
+
+const char *get_proc_name(const struct proc_dir_entry *de)
+{
+	return de->name;
+}
+EXPORT_SYMBOL_GPL(get_proc_name);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 12694ef..718e966 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -87,6 +87,7 @@ static inline struct proc_dir_entry *proc_create(const char *name, umode_t mode,
 extern void proc_set_size(struct proc_dir_entry *, loff_t);
 extern void proc_set_user(struct proc_dir_entry *, kuid_t, kgid_t);
 extern void *proc_get_parent_data(const struct inode *);
+extern const char *get_proc_name(const struct proc_dir_entry *);
 #else
 
 static inline void proc_flush_task(struct task_struct *task)
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index ebfad03..d2fd53b 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -344,7 +344,7 @@ static struct xt_hashlimit_htable *htable_find_get(struct net *net,
 	struct xt_hashlimit_htable *hinfo;
 
 	hlist_for_each_entry(hinfo, &hashlimit_net->htables, node) {
-		if (!strcmp(name, hinfo->pde->name) &&
+		if (!strcmp(name, get_proc_name(hinfo->pde)) &&
 		    hinfo->family == family) {
 			hinfo->use++;
 			return hinfo;
