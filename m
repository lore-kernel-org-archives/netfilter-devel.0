From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: [PATCH] two bugfixes to ownercmd
Date: Thu, 17 Feb 2005 04:59:46 +0200
Message-ID: <421408A2.1050002@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050200050205090805000003"
To: netfilter-devel@lists.netfilter.org
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
--------------050200050205090805000003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

I found two bugs in the ownercmd patch in patch-o-matic-ng. The patch 
adds the ipv6 version of the same functionality already found in stock 
kernels for ipv4.

[1] Only affects 2.6 version of the ownercmd patch.

In 2.4, read locks are used for files->file_lock
In 2.6, spinlocks are used instead.

The current 2.6 patch illegally uses read locks, which causes compiler 
warnings. If you look at the other functions in the same file 
(ip6t_owner.c), it's easy to see spinlocks are used for the same 
operations everywhere else in the file.

[2] Both the 2.4 and 2.6 patches lack an update to the SMP checks done 
in the checkentry() function. The ipv4 version in the stock kernel does 
this properly, so I updated the checks according to that.

The attached files contain all the previous changes plus my bugfixes for 
the above bugs, and should therefore be drop-in replacements for the 
current ones.

-- 
- xkr47


--------------050200050205090805000003
Content-Type: text/plain;
 name="linux-2.4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.patch"

diff -ur --exclude-from=/tmp/srcdiff.excludes.K336vZ -N orig-linux-2.4.28/include/linux/netfilter_ipv6/ip6t_owner.h linux-2.4.28/include/linux/netfilter_ipv6/ip6t_owner.h
--- orig-linux-2.4.28/include/linux/netfilter_ipv6/ip6t_owner.h	2001-05-17 16:05:15.000000000 +0300
+++ linux-2.4.28/include/linux/netfilter_ipv6/ip6t_owner.h	2005-02-17 04:43:29.765977549 +0200
@@ -6,12 +6,14 @@
 #define IP6T_OWNER_GID	0x02
 #define IP6T_OWNER_PID	0x04
 #define IP6T_OWNER_SID	0x08
+#define IP6T_OWNER_COMM 0x10
 
 struct ip6t_owner_info {
     uid_t uid;
     gid_t gid;
     pid_t pid;
     pid_t sid;
+    char comm[16];
     u_int8_t match, invert;	/* flags */
 };
 
diff -ur --exclude-from=/tmp/srcdiff.excludes.K336vZ -N orig-linux-2.4.28/net/ipv6/netfilter/ip6t_owner.c linux-2.4.28/net/ipv6/netfilter/ip6t_owner.c
--- orig-linux-2.4.28/net/ipv6/netfilter/ip6t_owner.c	2004-11-28 09:57:45.000000000 +0200
+++ linux-2.4.28/net/ipv6/netfilter/ip6t_owner.c	2005-02-17 04:44:04.759592035 +0200
@@ -16,6 +16,38 @@
 MODULE_LICENSE("GPL");
 
 static int
+match_comm(const struct sk_buff *skb, const char *comm)
+{
+	struct task_struct *p;
+	struct files_struct *files;
+	int i;
+
+	read_lock(&tasklist_lock);
+	for_each_task(p) {
+		if(strncmp(p->comm, comm, sizeof(p->comm)))
+			continue;
+
+		task_lock(p);
+		files = p->files;
+		if(files) {
+			read_lock(&files->file_lock);
+			for (i=0; i < files->max_fds; i++) {
+				if (fcheck_files(files, i) == skb->sk->socket->file) {
+					read_unlock(&files->file_lock);
+					task_unlock(p);
+					read_unlock(&tasklist_lock);
+					return 1;
+				}
+			}
+			read_unlock(&files->file_lock);
+		}
+		task_unlock(p);
+	}
+	read_unlock(&tasklist_lock);
+	return 0;
+}
+
+static int
 match_pid(const struct sk_buff *skb, pid_t pid)
 {
 	struct task_struct *p;
@@ -119,6 +151,12 @@
 			return 0;
 	}
 
+	if(info->match & IP6T_OWNER_COMM) {
+		if (!match_comm(skb, info->comm) ^
+		    !!(info->invert & IP6T_OWNER_COMM))
+			return 0;
+	}
+
 	return 1;
 }
 
@@ -140,8 +178,9 @@
 #ifdef CONFIG_SMP
 	/* files->file_lock can not be used in a BH */
 	if (((struct ip6t_owner_info *)matchinfo)->match
-	    & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
-		printk("ip6t_owner: pid and sid matching is broken on SMP.\n");
+	    & (IP6T_OWNER_PID|IP6T_OWNER_SID|IP6T_OWNER_COMM)) {
+		printk("ip6t_owner: pid, sid and command matching is broken "
+		       "on SMP.\n");
 		return 0;
 	}
 #endif

--------------050200050205090805000003
Content-Type: text/plain;
 name="linux-2.6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.patch"

diff -ur --exclude-from=/tmp/srcdiff.excludes.ye2xex -N orig-linux-2.6.10/include/linux/netfilter_ipv6/ip6t_owner.h linux-2.6.10/include/linux/netfilter_ipv6/ip6t_owner.h
--- orig-linux-2.6.10/include/linux/netfilter_ipv6/ip6t_owner.h	2004-12-24 23:35:00.000000000 +0200
+++ linux-2.6.10/include/linux/netfilter_ipv6/ip6t_owner.h	2005-02-17 04:33:02.405528261 +0200
@@ -6,12 +6,14 @@
 #define IP6T_OWNER_GID	0x02
 #define IP6T_OWNER_PID	0x04
 #define IP6T_OWNER_SID	0x08
+#define IP6T_OWNER_COMM 0x10
 
 struct ip6t_owner_info {
     uid_t uid;
     gid_t gid;
     pid_t pid;
     pid_t sid;
+    char comm[16];
     u_int8_t match, invert;	/* flags */
 };
 
diff -ur --exclude-from=/tmp/srcdiff.excludes.ye2xex -N orig-linux-2.6.10/net/ipv6/netfilter/ip6t_owner.c linux-2.6.10/net/ipv6/netfilter/ip6t_owner.c
--- orig-linux-2.6.10/net/ipv6/netfilter/ip6t_owner.c	2004-12-24 23:36:00.000000000 +0200
+++ linux-2.6.10/net/ipv6/netfilter/ip6t_owner.c	2005-02-17 04:33:09.219479594 +0200
@@ -21,6 +21,39 @@
 MODULE_LICENSE("GPL");
 
 static int
+match_comm(const struct sk_buff *skb, const char *comm)
+{
+	struct task_struct *p, *g;
+	struct files_struct *files;
+	int i;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if(strncmp(p->comm, comm, sizeof(p->comm)))
+			continue;
+
+		task_lock(p);
+		files = p->files;
+		if(files) {
+			spin_lock(&files->file_lock);
+			for (i=0; i < files->max_fds; i++) {
+				if (fcheck_files(files, i) ==
+				    skb->sk->sk_socket->file) {
+					spin_unlock(&files->file_lock);
+					task_unlock(p);
+					read_unlock(&tasklist_lock);
+					return 1;
+				}
+			}
+			spin_unlock(&files->file_lock);
+		}
+		task_unlock(p);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+	return 0;
+}
+
+static int
 match_pid(const struct sk_buff *skb, pid_t pid)
 {
 	struct task_struct *p;
@@ -124,6 +157,12 @@
 			return 0;
 	}
 
+	if(info->match & IP6T_OWNER_COMM) {
+		if (!match_comm(skb, info->comm) ^
+		    !!(info->invert & IP6T_OWNER_COMM))
+			return 0;
+	}
+
 	return 1;
 }
 
@@ -145,8 +184,9 @@
 #ifdef CONFIG_SMP
 	/* files->file_lock can not be used in a BH */
 	if (((struct ip6t_owner_info *)matchinfo)->match
-	    & (IP6T_OWNER_PID|IP6T_OWNER_SID)) {
-		printk("ip6t_owner: pid and sid matching is broken on SMP.\n");
+	    & (IP6T_OWNER_PID|IP6T_OWNER_SID|IP6T_OWNER_COMM)) {
+		printk("ip6t_owner: pid, sid and command matching is broken "
+		       "on SMP.\n");
 		return 0;
 	}
 #endif

--------------050200050205090805000003--
