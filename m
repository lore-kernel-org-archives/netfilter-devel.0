From: Christoph Hellwig <hch@lst.de>
Subject: Re: tasklist_lock abuse in ipt{,6}owner
Date: Thu, 11 Aug 2005 17:29:42 +0200
Message-ID: <20050811152942.GA8276@lst.de>
References: <20050809211249.GA29430@lst.de> <42FB449A.7030709@trash.net>
	<20050811152450.GA8189@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20050811152450.GA8189@lst.de>
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

On Thu, Aug 11, 2005 at 05:24:50PM +0200, Christoph Hellwig wrote:
> On Thu, Aug 11, 2005 at 02:29:14PM +0200, Patrick McHardy wrote:
> > Christoph Hellwig wrote:
> > > Folks, could you please take a look at getting rid of that match_pid
> > > crap?  We need to get rid of the tasklist_lock export to change the
> > > locking scheme in that area, and what netfilter does with it is not
> > > pretty.  I'd actually prefer dropping those modules completely, this
> > > kind of inverse lookup from file/socket to process shouldn't be done
> > > anywhere in the kernel.
> > 
> > I think its ok to rip out cmd/sid/pid matching, it is broken and can't
> > be fixed anyway. Feel free to send a patch, otherwise I'll take care
> > of it.
> 
> So you want to keep the uid/gid matches for now?  Probably we should
> check for the others in ->checkentry then and refuse to load if they're
> present?

Ok, here's a patch still leaving the UID/GID matches in and erroring out
if PID/SID/COMM are specified:


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/net/ipv4/netfilter/ipt_owner.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_owner.c	2005-08-11 16:46:08.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ipt_owner.c	2005-08-11 17:28:06.000000000 +0200
@@ -21,106 +21,6 @@
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
@@ -145,24 +45,6 @@
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
 
@@ -173,6 +55,8 @@
            unsigned int matchsize,
            unsigned int hook_mask)
 {
+	const struct ipt_owner_info *info = matchinfo;
+
         if (hook_mask
             & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
                 printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
@@ -184,15 +68,13 @@
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
 
Index: linux-2.6/net/ipv6/netfilter/ip6t_owner.c
===================================================================
--- linux-2.6.orig/net/ipv6/netfilter/ip6t_owner.c	2005-08-11 16:46:08.000000000 +0200
+++ linux-2.6/net/ipv6/netfilter/ip6t_owner.c	2005-08-11 17:27:49.000000000 +0200
@@ -20,71 +20,6 @@
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
@@ -112,18 +47,6 @@
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
 
@@ -134,6 +57,8 @@
            unsigned int matchsize,
            unsigned int hook_mask)
 {
+	const struct ip6t_owner_info *info = matchinfo;
+
         if (hook_mask
             & ~((1 << NF_IP6_LOCAL_OUT) | (1 << NF_IP6_POST_ROUTING))) {
                 printk("ip6t_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
@@ -142,14 +67,13 @@
 
 	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_owner_info)))
 		return 0;
-#ifdef CONFIG_SMP
-	/* files->file_lock can not be used in a BH */
-	if (((struct ip6t_owner_info *)matchinfo)->match
-	    & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
-		printk("ip6t_owner: pid and sid matching is broken on SMP.\n");
+
+	if (info->match & (IPT_OWNER_PID|IPT_OWNER_SID)) {
+		printk("ipt_owner: pid and sid matching "
+		       "not supported anymore\n");
 		return 0;
 	}
-#endif
+
 	return 1;
 }
 
