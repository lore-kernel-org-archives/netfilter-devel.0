From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak81 RFC V2 3/5] audit: use inline function to get audit
	context
Date: Sat, 12 May 2018 21:58:20 -0400
Message-ID: <baa29a694e352bd4fe8acd0f46f7baca1ad2c147.1526173613.git.rgb@redhat.com>
References: <cover.1526173613.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Richard Guy Briggs <rgb@redhat.com>, David Howells <dhowells@redhat.com>,
	Ingo Molnar <mingo@redhat.com>
To: Linux-Audit Mailing List <linux-audit@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
	Netfilter Devel List <netfilter-devel@vger.kernel.org>,
	Linux Security Module list <linux-security-module@vger.kernel.org>,
	Integrity Measurement Architecture <linux-integrity@vger.kernel.org>,
	SElinux list <selinux@tycho.nsa.gov>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <cover.1526173613.git.rgb@redhat.com>
In-Reply-To: <cover.1526173613.git.rgb@redhat.com>
References: <cover.1526173613.git.rgb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

Recognizing that the audit context is an internal audit value, use an
access function to retrieve the audit context pointer for the task
rather than reaching directly into the task struct to get it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h                | 14 ++++++--
 include/net/xfrm.h                   |  2 +-
 kernel/audit.c                       |  6 ++--
 kernel/audit_watch.c                 |  2 +-
 kernel/auditsc.c                     | 64 +++++++++++++++++-------------------
 net/bridge/netfilter/ebtables.c      |  2 +-
 net/core/dev.c                       |  2 +-
 net/netfilter/x_tables.c             |  2 +-
 net/netlabel/netlabel_user.c         |  2 +-
 security/integrity/ima/ima_api.c     |  2 +-
 security/integrity/integrity_audit.c |  2 +-
 security/lsm_audit.c                 |  2 +-
 security/selinux/hooks.c             |  4 +--
 security/selinux/selinuxfs.c         |  6 ++--
 security/selinux/ss/services.c       | 12 +++----
 15 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 5f86f7c..786aa8e 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -235,9 +235,13 @@ extern void __audit_inode_child(struct inode *parent,
 extern void __audit_seccomp(unsigned long syscall, long signr, int code);
 extern void __audit_ptrace(struct task_struct *t);
 
+static inline struct audit_context *audit_context(void)
+{
+	return current->audit_context;
+}
 static inline bool audit_dummy_context(void)
 {
-	void *p = current->audit_context;
+	void *p = audit_context();
 	return !p || *(int *)p;
 }
 static inline void audit_free(struct task_struct *task)
@@ -249,12 +253,12 @@ static inline void audit_syscall_entry(int major, unsigned long a0,
 				       unsigned long a1, unsigned long a2,
 				       unsigned long a3)
 {
-	if (unlikely(current->audit_context))
+	if (unlikely(audit_context()))
 		__audit_syscall_entry(major, a0, a1, a2, a3);
 }
 static inline void audit_syscall_exit(void *pt_regs)
 {
-	if (unlikely(current->audit_context)) {
+	if (unlikely(audit_context())) {
 		int success = is_syscall_success(pt_regs);
 		long return_code = regs_return_value(pt_regs);
 
@@ -468,6 +472,10 @@ static inline bool audit_dummy_context(void)
 {
 	return true;
 }
+static inline struct audit_context *audit_context(void)
+{
+	return NULL;
+}
 static inline struct filename *audit_reusename(const __user char *name)
 {
 	return NULL;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fcce8ee..7f2e31a 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -736,7 +736,7 @@ static inline struct audit_buffer *xfrm_audit_start(const char *op)
 
 	if (audit_enabled == 0)
 		return NULL;
-	audit_buf = audit_log_start(current->audit_context, GFP_ATOMIC,
+	audit_buf = audit_log_start(audit_context(), GFP_ATOMIC,
 				    AUDIT_MAC_IPSEC_EVENT);
 	if (audit_buf == NULL)
 		return NULL;
diff --git a/kernel/audit.c b/kernel/audit.c
index e9f9a90..e7478cb 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1099,8 +1099,7 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 
 	if (audit_enabled == AUDIT_OFF)
 		return;
-	ab = audit_log_start(current->audit_context,
-			     GFP_KERNEL, AUDIT_FEATURE_CHANGE);
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_FEATURE_CHANGE);
 	if (!ab)
 		return;
 	audit_log_task_info(ab, current);
@@ -2317,8 +2316,7 @@ void audit_log_link_denied(const char *operation)
 		return;
 
 	/* Generate AUDIT_ANOM_LINK with subject, operation, outcome. */
-	ab = audit_log_start(current->audit_context, GFP_KERNEL,
-			     AUDIT_ANOM_LINK);
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_ANOM_LINK);
 	if (!ab)
 		return;
 	audit_log_format(ab, "op=%s", operation);
diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 9eb8b35..f1ba889 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -274,7 +274,7 @@ static void audit_update_watch(struct audit_parent *parent,
 		/* If the update involves invalidating rules, do the inode-based
 		 * filtering now, so we don't omit records. */
 		if (invalidating && !audit_dummy_context())
-			audit_filter_inodes(current, current->audit_context);
+			audit_filter_inodes(current, audit_context());
 
 		/* updating ino will likely change which audit_hash_list we
 		 * are on so we need a new watch for the new list */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index e157595..ecc0c23 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1509,8 +1509,7 @@ void __audit_free(struct task_struct *tsk)
 void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 			   unsigned long a3, unsigned long a4)
 {
-	struct task_struct *tsk = current;
-	struct audit_context *context = tsk->audit_context;
+	struct audit_context *context = audit_context();
 	enum audit_state     state;
 
 	if (!audit_enabled || !context)
@@ -1525,7 +1524,7 @@ void __audit_syscall_entry(int major, unsigned long a1, unsigned long a2,
 	context->dummy = !audit_n_rules;
 	if (!context->dummy && state == AUDIT_BUILD_CONTEXT) {
 		context->prio = 0;
-		if (auditd_test_task(tsk))
+		if (auditd_test_task(current))
 			return;
 	}
 
@@ -1563,12 +1562,12 @@ void __audit_syscall_exit(int success, long return_code)
 	else
 		success = AUDITSC_FAILURE;
 
-	context = audit_take_context(tsk, success, return_code);
+	context = audit_take_context(current, success, return_code);
 	if (!context)
 		return;
 
 	if (context->in_syscall && context->current_state == AUDIT_RECORD_CONTEXT)
-		audit_log_exit(context, tsk);
+		audit_log_exit(context, current);
 
 	context->in_syscall = 0;
 	context->prio = context->state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
@@ -1602,7 +1601,7 @@ static inline void handle_one(const struct inode *inode)
 	int count;
 	if (likely(!inode->i_fsnotify_marks))
 		return;
-	context = current->audit_context;
+	context = audit_context();
 	p = context->trees;
 	count = context->tree_count;
 	rcu_read_lock();
@@ -1633,7 +1632,7 @@ static void handle_path(const struct dentry *dentry)
 	unsigned long seq;
 	int count;
 
-	context = current->audit_context;
+	context = audit_context();
 	p = context->trees;
 	count = context->tree_count;
 retry:
@@ -1715,7 +1714,7 @@ static struct audit_names *audit_alloc_name(struct audit_context *context,
 struct filename *
 __audit_reusename(const __user char *uptr)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	struct audit_names *n;
 
 	list_for_each_entry(n, &context->names_list, list) {
@@ -1738,7 +1737,7 @@ struct filename *
  */
 void __audit_getname(struct filename *name)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	struct audit_names *n;
 
 	if (!context->in_syscall)
@@ -1766,7 +1765,7 @@ void __audit_getname(struct filename *name)
 void __audit_inode(struct filename *name, const struct dentry *dentry,
 		   unsigned int flags)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	struct inode *inode = d_backing_inode(dentry);
 	struct audit_names *n;
 	bool parent = flags & AUDIT_INODE_PARENT;
@@ -1865,7 +1864,7 @@ void __audit_inode_child(struct inode *parent,
 			 const struct dentry *dentry,
 			 const unsigned char type)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	struct inode *inode = d_backing_inode(dentry);
 	const char *dname = dentry->d_name.name;
 	struct audit_names *n, *found_parent = NULL, *found_child = NULL;
@@ -2084,7 +2083,7 @@ int audit_set_loginuid(kuid_t loginuid)
  */
 void __audit_mq_open(int oflag, umode_t mode, struct mq_attr *attr)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	if (attr)
 		memcpy(&context->mq_open.attr, attr, sizeof(struct mq_attr));
@@ -2108,7 +2107,7 @@ void __audit_mq_open(int oflag, umode_t mode, struct mq_attr *attr)
 void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio,
 			const struct timespec64 *abs_timeout)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	struct timespec64 *p = &context->mq_sendrecv.abs_timeout;
 
 	if (abs_timeout)
@@ -2132,7 +2131,7 @@ void __audit_mq_sendrecv(mqd_t mqdes, size_t msg_len, unsigned int msg_prio,
 
 void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	if (notification)
 		context->mq_notify.sigev_signo = notification->sigev_signo;
@@ -2151,7 +2150,7 @@ void __audit_mq_notify(mqd_t mqdes, const struct sigevent *notification)
  */
 void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	context->mq_getsetattr.mqdes = mqdes;
 	context->mq_getsetattr.mqstat = *mqstat;
 	context->type = AUDIT_MQ_GETSETATTR;
@@ -2164,7 +2163,7 @@ void __audit_mq_getsetattr(mqd_t mqdes, struct mq_attr *mqstat)
  */
 void __audit_ipc_obj(struct kern_ipc_perm *ipcp)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	context->ipc.uid = ipcp->uid;
 	context->ipc.gid = ipcp->gid;
 	context->ipc.mode = ipcp->mode;
@@ -2184,7 +2183,7 @@ void __audit_ipc_obj(struct kern_ipc_perm *ipcp)
  */
 void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mode)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	context->ipc.qbytes = qbytes;
 	context->ipc.perm_uid = uid;
@@ -2195,7 +2194,7 @@ void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gid, umode_t mo
 
 void __audit_bprm(struct linux_binprm *bprm)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	context->type = AUDIT_EXECVE;
 	context->execve.argc = bprm->argc;
@@ -2210,7 +2209,7 @@ void __audit_bprm(struct linux_binprm *bprm)
  */
 int __audit_socketcall(int nargs, unsigned long *args)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	if (nargs <= 0 || nargs > AUDITSC_ARGS || !args)
 		return -EINVAL;
@@ -2228,7 +2227,7 @@ int __audit_socketcall(int nargs, unsigned long *args)
  */
 void __audit_fd_pair(int fd1, int fd2)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	context->fds[0] = fd1;
 	context->fds[1] = fd2;
 }
@@ -2242,7 +2241,7 @@ void __audit_fd_pair(int fd1, int fd2)
  */
 int __audit_sockaddr(int len, void *a)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	if (!context->sockaddr) {
 		void *p = kmalloc(sizeof(struct sockaddr_storage), GFP_KERNEL);
@@ -2258,7 +2257,7 @@ int __audit_sockaddr(int len, void *a)
 
 void __audit_ptrace(struct task_struct *t)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	context->target_pid = task_tgid_nr(t);
 	context->target_auid = audit_get_loginuid(t);
@@ -2279,19 +2278,18 @@ void __audit_ptrace(struct task_struct *t)
 int audit_signal_info(int sig, struct task_struct *t)
 {
 	struct audit_aux_data_pids *axp;
-	struct task_struct *tsk = current;
-	struct audit_context *ctx = tsk->audit_context;
+	struct audit_context *ctx = audit_context();
 	kuid_t uid = current_uid(), auid, t_uid = task_uid(t);
 
 	if (auditd_test_task(t) &&
 	    (sig == SIGTERM || sig == SIGHUP ||
 	     sig == SIGUSR1 || sig == SIGUSR2)) {
-		audit_sig_pid = task_tgid_nr(tsk);
-		if (uid_valid(auid = audit_get_loginuid(tsk)))
+		audit_sig_pid = task_tgid_nr(current);
+		if (uid_valid(auid = audit_get_loginuid(current)))
 			audit_sig_uid = auid;
 		else
 			audit_sig_uid = uid;
-		security_task_getsecid(tsk, &audit_sig_sid);
+		security_task_getsecid(current, &audit_sig_sid);
 	}
 
 	if (!audit_signals || audit_dummy_context())
@@ -2347,7 +2345,7 @@ int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
 			   const struct cred *new, const struct cred *old)
 {
 	struct audit_aux_data_bprm_fcaps *ax;
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	struct cpu_vfs_cap_data vcaps;
 
 	ax = kmalloc(sizeof(*ax), GFP_KERNEL);
@@ -2387,7 +2385,7 @@ int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
  */
 void __audit_log_capset(const struct cred *new, const struct cred *old)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	context->capset.pid = task_tgid_nr(current);
 	context->capset.cap.effective   = new->cap_effective;
 	context->capset.cap.inheritable = new->cap_effective;
@@ -2398,7 +2396,7 @@ void __audit_log_capset(const struct cred *new, const struct cred *old)
 
 void __audit_mmap_fd(int fd, int flags)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 	context->mmap.fd = fd;
 	context->mmap.flags = flags;
 	context->type = AUDIT_MMAP;
@@ -2406,7 +2404,7 @@ void __audit_mmap_fd(int fd, int flags)
 
 void __audit_log_kern_module(char *name)
 {
-	struct audit_context *context = current->audit_context;
+	struct audit_context *context = audit_context();
 
 	context->module.name = kmalloc(strlen(name) + 1, GFP_KERNEL);
 	strcpy(context->module.name, name);
@@ -2415,7 +2413,7 @@ void __audit_log_kern_module(char *name)
 
 void __audit_fanotify(unsigned int response)
 {
-	audit_log(current->audit_context, GFP_KERNEL,
+	audit_log(audit_context(), GFP_KERNEL,
 		AUDIT_FANOTIFY,	"resp=%u", response);
 }
 
@@ -2482,7 +2480,7 @@ void __audit_seccomp(unsigned long syscall, long signr, int code)
 
 struct list_head *audit_killed_trees(void)
 {
-	struct audit_context *ctx = current->audit_context;
+	struct audit_context *ctx = audit_context();
 	if (likely(!ctx || !ctx->in_syscall))
 		return NULL;
 	return &ctx->killed_trees;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 032e0fe..894c96a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1062,7 +1062,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 
 #ifdef CONFIG_AUDIT
 	if (audit_enabled) {
-		audit_log(current->audit_context, GFP_KERNEL,
+		audit_log(audit_context(), GFP_KERNEL,
 			  AUDIT_NETFILTER_CFG,
 			  "table=%s family=%u entries=%u",
 			  repl->name, AF_BRIDGE, repl->nentries);
diff --git a/net/core/dev.c b/net/core/dev.c
index 969462e..5f38862 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6749,7 +6749,7 @@ static int __dev_set_promiscuity(struct net_device *dev, int inc, bool notify)
 			dev->flags & IFF_PROMISC ? "entered" : "left");
 		if (audit_enabled) {
 			current_uid_gid(&uid, &gid);
-			audit_log(current->audit_context, GFP_ATOMIC,
+			audit_log(audit_context(), GFP_ATOMIC,
 				AUDIT_ANOM_PROMISCUOUS,
 				"dev=%s prom=%d old_prom=%d auid=%u uid=%u gid=%u ses=%u",
 				dev->name, (dev->flags & IFF_PROMISC),
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 71325fe..1540263 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1414,7 +1414,7 @@ struct xt_table_info *
 
 #ifdef CONFIG_AUDIT
 	if (audit_enabled) {
-		audit_log(current->audit_context, GFP_KERNEL,
+		audit_log(audit_context(), GFP_KERNEL,
 			  AUDIT_NETFILTER_CFG,
 			  "table=%s family=%u entries=%u",
 			  table->name, table->af, private->number);
diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
index 58495f4..2f328af 100644
--- a/net/netlabel/netlabel_user.c
+++ b/net/netlabel/netlabel_user.c
@@ -104,7 +104,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
 	if (audit_enabled == 0)
 		return NULL;
 
-	audit_buf = audit_log_start(current->audit_context, GFP_ATOMIC, type);
+	audit_buf = audit_log_start(audit_context(), GFP_ATOMIC, type);
 	if (audit_buf == NULL)
 		return NULL;
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index bf88236..a02c5ac 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -326,7 +326,7 @@ void ima_audit_measurement(struct integrity_iint_cache *iint,
 		hex_byte_pack(hash + (i * 2), iint->ima_hash->digest[i]);
 	hash[i * 2] = '\0';
 
-	ab = audit_log_start(current->audit_context, GFP_KERNEL,
+	ab = audit_log_start(audit_context(), GFP_KERNEL,
 			     AUDIT_INTEGRITY_RULE);
 	if (!ab)
 		goto out;
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index 90987d1..ab10a25 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -38,7 +38,7 @@ void integrity_audit_msg(int audit_msgno, struct inode *inode,
 	if (!integrity_audit_info && audit_info == 1)	/* Skip info messages */
 		return;
 
-	ab = audit_log_start(current->audit_context, GFP_KERNEL, audit_msgno);
+	ab = audit_log_start(audit_context(), GFP_KERNEL, audit_msgno);
 	audit_log_format(ab, "pid=%d uid=%u auid=%u ses=%u",
 			 task_pid_nr(current),
 			 from_kuid(&init_user_ns, current_cred()->uid),
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 67703db..f840010 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -447,7 +447,7 @@ void common_lsm_audit(struct common_audit_data *a,
 	if (a == NULL)
 		return;
 	/* we use GFP_ATOMIC so we won't sleep */
-	ab = audit_log_start(current->audit_context, GFP_ATOMIC | __GFP_NOWARN,
+	ab = audit_log_start(audit_context(), GFP_ATOMIC | __GFP_NOWARN,
 			     AUDIT_AVC);
 
 	if (ab == NULL)
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4cafe6a..6dd582b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3294,7 +3294,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, const char *name,
 			} else {
 				audit_size = 0;
 			}
-			ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR);
+			ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_SELINUX_ERR);
 			audit_log_format(ab, "op=setxattr invalid_context=");
 			audit_log_n_untrustedstring(ab, value, audit_size);
 			audit_log_end(ab);
@@ -6431,7 +6431,7 @@ static int selinux_setprocattr(const char *name, void *value, size_t size)
 					audit_size = size - 1;
 				else
 					audit_size = size;
-				ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR);
+				ab = audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_SELINUX_ERR);
 				audit_log_format(ab, "op=fscreate invalid_context=");
 				audit_log_n_untrustedstring(ab, value, audit_size);
 				audit_log_end(ab);
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index efdc633..b4c51d1 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -167,7 +167,7 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
 				      NULL);
 		if (length)
 			goto out;
-		audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_STATUS,
+		audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS,
 			"enforcing=%d old_enforcing=%d auid=%u ses=%u"
 			" enabled=%d old-enabled=%d lsm=selinux res=1",
 			new_value, old_value,
@@ -303,7 +303,7 @@ static ssize_t sel_write_disable(struct file *file, const char __user *buf,
 		length = selinux_disable(fsi->state);
 		if (length)
 			goto out;
-		audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_STATUS,
+		audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS,
 			"enforcing=%d old_enforcing=%d auid=%u ses=%u"
 			" enabled=%d old-enabled=%d lsm=selinux res=1",
 			enforcing, enforcing,
@@ -581,7 +581,7 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
 	length = count;
 
 out1:
-	audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
+	audit_log(audit_context(), GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
 		"auid=%u ses=%u lsm=selinux res=1",
 		from_kuid(&init_user_ns, audit_get_loginuid(current)),
 		audit_get_sessionid(current));
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 8057e19..0fd8ad9 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -501,7 +501,7 @@ static void security_dump_masked_av(struct policydb *policydb,
 		goto out;
 
 	/* audit a message */
-	ab = audit_log_start(current->audit_context,
+	ab = audit_log_start(audit_context(),
 			     GFP_ATOMIC, AUDIT_SELINUX_ERR);
 	if (!ab)
 		goto out;
@@ -743,7 +743,7 @@ static int security_validtrans_handle_fail(struct selinux_state *state,
 		goto out;
 	if (context_struct_to_string(p, tcontext, &t, &tlen))
 		goto out;
-	audit_log(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR,
+	audit_log(audit_context(), GFP_ATOMIC, AUDIT_SELINUX_ERR,
 		  "op=security_validate_transition seresult=denied"
 		  " oldcontext=%s newcontext=%s taskcontext=%s tclass=%s",
 		  o, n, t, sym_name(p, SYM_CLASSES, tclass-1));
@@ -929,7 +929,7 @@ int security_bounded_transition(struct selinux_state *state,
 					      &old_name, &length) &&
 		    !context_struct_to_string(policydb, new_context,
 					      &new_name, &length)) {
-			audit_log(current->audit_context,
+			audit_log(audit_context(),
 				  GFP_ATOMIC, AUDIT_SELINUX_ERR,
 				  "op=security_bounded_transition "
 				  "seresult=denied "
@@ -1586,7 +1586,7 @@ static int compute_sid_handle_invalid_context(
 		goto out;
 	if (context_struct_to_string(policydb, newcontext, &n, &nlen))
 		goto out;
-	audit_log(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR,
+	audit_log(audit_context(), GFP_ATOMIC, AUDIT_SELINUX_ERR,
 		  "op=security_compute_sid invalid_context=%s"
 		  " scontext=%s"
 		  " tcontext=%s"
@@ -2882,7 +2882,7 @@ int security_set_bools(struct selinux_state *state, int len, int *values)
 
 	for (i = 0; i < len; i++) {
 		if (!!values[i] != policydb->bool_val_to_struct[i]->state) {
-			audit_log(current->audit_context, GFP_ATOMIC,
+			audit_log(audit_context(), GFP_ATOMIC,
 				AUDIT_MAC_CONFIG_CHANGE,
 				"bool=%s val=%d old_val=%d auid=%u ses=%u",
 				sym_name(policydb, SYM_BOOLS, i),
@@ -3025,7 +3025,7 @@ int security_sid_mls_copy(struct selinux_state *state,
 		if (rc) {
 			if (!context_struct_to_string(policydb, &newcon, &s,
 						      &len)) {
-				audit_log(current->audit_context,
+				audit_log(audit_context(),
 					  GFP_ATOMIC, AUDIT_SELINUX_ERR,
 					  "op=security_sid_mls_copy "
 					  "invalid_context=%s", s);
-- 
1.8.3.1
