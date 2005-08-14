From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 4/4]: Remove tasklist_lock abuse in ipt{,6}owner
Date: Mon, 15 Aug 2005 00:44:00 +0200
Message-ID: <42FFC930.4090607@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="04.diff"
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

[NETFILTER]: Remove tasklist_lock abuse in ipt{,6}owner

Rip out cmd/sid/pid matching since its unfixable broken and stands in the
way of locking changes to tasklist_lock.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4ef91e185bd595de034e1268a5377b4747d458c7
tree c358925f46627c9cfbdd6411fee73d681b87c012
parent 7ea3224e415f93eff91b7e21cfb99fc39b2c1e90
author Christoph Hellwig <hch@lst.de> Mon, 15 Aug 2005 00:37:42 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 15 Aug 2005 00:37:42 +0200

 net/ipv4/netfilter/ipt_owner.c  |  132 ++-------------------------------------
 net/ipv6/netfilter/ip6t_owner.c |   90 ++-------------------------
 2 files changed, 14 insertions(+), 208 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
--- a/net/ipv4/netfilter/ipt_owner.c
+++ b/net/ipv4/netfilter/ipt_owner.c
@@ -21,106 +21,6 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.c
 MODULE_DESCRIPTION("iptables owner match");
 
 static int
-match_comm(const struct sk_buff *skb, const char *comm)
-{
-	struct task_struct *g, *p;
-	struct files_struct *files;
-	int i;
-
-	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		if(strncmp(p->comm, comm, sizeof(p->comm)))
-			continue;
-
-		task_lock(p);
-		files = p->files;
-		if(files) {
-			spin_lock(&files->file_lock);
-			for (i=0; i < files->max_fds; i++) {
-				if (fcheck_files(files, i) ==
-				    skb->sk->sk_socket->file) {
-					spin_unlock(&files->file_lock);
-					task_unlock(p);
-					read_unlock(&tasklist_lock);
-					return 1;
-				}
-			}
-			spin_unlock(&files->file_lock);
-		}
-		task_unlock(p);
-	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
-	return 0;
-}
-
-static int
-match_pid(const struct sk_buff *skb, pid_t pid)
-{
-	struct task_struct *p;
-	struct files_struct *files;
-	int i;
-
-	read_lock(&tasklist_lock);
-	p = find_task_by_pid(pid);
-	if (!p)
-		goto out;
-	task_lock(p);
-	files = p->files;
-	if(files) {
-		spin_lock(&files->file_lock);
-		for (i=0; i < files->max_fds; i++) {
-			if (fcheck_files(files, i) ==
-			    skb->sk->sk_socket->file) {
-				spin_unlock(&files->file_lock);
-				task_unlock(p);
-				read_unlock(&tasklist_lock);
-				return 1;
-			}
-		}
-		spin_unlock(&files->file_lock);
-	}
-	task_unlock(p);
-out:
-	read_unlock(&tasklist_lock);
-	return 0;
-}
-
-static int
-match_sid(const struct sk_buff *skb, pid_t sid)
-{
-	struct task_struct *g, *p;
-	struct file *file = skb->sk->sk_socket->file;
-	int i, found=0;
-
-	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		struct files_struct *files;
-		if (p->signal->session != sid)
-			continue;
-
-		task_lock(p);
-		files = p->files;
-		if (files) {
-			spin_lock(&files->file_lock);
-			for (i=0; i < files->max_fds; i++) {
-				if (fcheck_files(files, i) == file) {
-					found = 1;
-					break;
-				}
-			}
-			spin_unlock(&files->file_lock);
-		}
-		task_unlock(p);
-		if (found)
-			goto out;
-	} while_each_thread(g, p);
-out:
-	read_unlock(&tasklist_lock);
-
-	return found;
-}
-
-static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
       const struct net_device *out,
@@ -145,24 +45,6 @@ match(const struct sk_buff *skb,
 			return 0;
 	}
 
-	if(info->match & IPT_OWNER_PID) {
-		if (!match_pid(skb, info->pid) ^
-		    !!(info->invert & IPT_OWNER_PID))
-			return 0;
-	}
-
-	if(info->match & IPT_OWNER_SID) {
-		if (!match_sid(skb, info->sid) ^
-		    !!(info->invert & IPT_OWNER_SID))
-			return 0;
-	}
-
-	if(info->match & IPT_OWNER_COMM) {
-		if (!match_comm(skb, info->comm) ^
-		    !!(info->invert & IPT_OWNER_COMM))
-			return 0;
-	}
-
 	return 1;
 }
 
@@ -173,6 +55,8 @@ checkentry(const char *tablename,
            unsigned int matchsize,
            unsigned int hook_mask)
 {
+	const struct ipt_owner_info *info = matchinfo;
+
         if (hook_mask
             & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
                 printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
@@ -184,15 +68,13 @@ checkentry(const char *tablename,
 		       IPT_ALIGN(sizeof(struct ipt_owner_info)));
 		return 0;
 	}
-#ifdef CONFIG_SMP
-	/* files->file_lock can not be used in a BH */
-	if (((struct ipt_owner_info *)matchinfo)->match
-	    & (IPT_OWNER_PID|IPT_OWNER_SID|IPT_OWNER_COMM)) {
-		printk("ipt_owner: pid, sid and command matching is broken "
-		       "on SMP.\n");
+
+	if (info->match & (IPT_OWNER_PID|IPT_OWNER_SID|IPT_OWNER_COMM)) {
+		printk("ipt_owner: pid, sid and command matching "
+		       "not supported anymore\n");
 		return 0;
 	}
-#endif
+
 	return 1;
 }
 
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owner.c
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -20,71 +20,6 @@ MODULE_AUTHOR("Marc Boucher <marc@mbsi.c
 MODULE_DESCRIPTION("IP6 tables owner matching module");
 MODULE_LICENSE("GPL");
 
-static int
-match_pid(const struct sk_buff *skb, pid_t pid)
-{
-	struct task_struct *p;
-	struct files_struct *files;
-	int i;
-
-	read_lock(&tasklist_lock);
-	p = find_task_by_pid(pid);
-	if (!p)
-		goto out;
-	task_lock(p);
-	files = p->files;
-	if(files) {
-		spin_lock(&files->file_lock);
-		for (i=0; i < files->max_fds; i++) {
-			if (fcheck_files(files, i) == skb->sk->sk_socket->file) {
-				spin_unlock(&files->file_lock);
-				task_unlock(p);
-				read_unlock(&tasklist_lock);
-				return 1;
-			}
-		}
-		spin_unlock(&files->file_lock);
-	}
-	task_unlock(p);
-out:
-	read_unlock(&tasklist_lock);
-	return 0;
-}
-
-static int
-match_sid(const struct sk_buff *skb, pid_t sid)
-{
-	struct task_struct *g, *p;
-	struct file *file = skb->sk->sk_socket->file;
-	int i, found=0;
-
-	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		struct files_struct *files;
-		if (p->signal->session != sid)
-			continue;
-
-		task_lock(p);
-		files = p->files;
-		if (files) {
-			spin_lock(&files->file_lock);
-			for (i=0; i < files->max_fds; i++) {
-				if (fcheck_files(files, i) == file) {
-					found = 1;
-					break;
-				}
-			}
-			spin_unlock(&files->file_lock);
-		}
-		task_unlock(p);
-		if (found)
-			goto out;
-	} while_each_thread(g, p);
-out:
-	read_unlock(&tasklist_lock);
-
-	return found;
-}
 
 static int
 match(const struct sk_buff *skb,
@@ -112,18 +47,6 @@ match(const struct sk_buff *skb,
 			return 0;
 	}
 
-	if(info->match & IP6T_OWNER_PID) {
-		if (!match_pid(skb, info->pid) ^
-		    !!(info->invert & IP6T_OWNER_PID))
-			return 0;
-	}
-
-	if(info->match & IP6T_OWNER_SID) {
-		if (!match_sid(skb, info->sid) ^
-		    !!(info->invert & IP6T_OWNER_SID))
-			return 0;
-	}
-
 	return 1;
 }
 
@@ -134,6 +57,8 @@ checkentry(const char *tablename,
            unsigned int matchsize,
            unsigned int hook_mask)
 {
+	const struct ip6t_owner_info *info = matchinfo;
+
         if (hook_mask
             & ~((1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING))) {
                 printk("ip6t_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
@@ -142,14 +67,13 @@ checkentry(const char *tablename,
 
 	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_owner_info)))
 		return 0;
-#ifdef CONFIG_SMP
-	/* files->file_lock can not be used in a BH */
-	if (((struct ip6t_owner_info *)matchinfo)->match
-	    & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
-		printk("ip6t_owner: pid and sid matching is broken on SMP.\n");
+
+	if (info->match & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
+		printk("ipt_owner: pid and sid matching "
+		       "not supported anymore\n");
 		return 0;
 	}
-#endif
+
 	return 1;
 }
 
