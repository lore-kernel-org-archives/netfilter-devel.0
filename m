From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: [PATCH] owner-socketlookup update for 2.6.10
Date: Tue, 15 Feb 2005 15:13:42 +0200
Message-ID: <4211F586.7020106@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070101050201040301020000"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,  norman@rasmussen.org
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
--------------070101050201040301020000
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Attached updated owner-socketlookup patch that merges cleanly against 
2.6.10.

-- 
- xkr47


--------------070101050201040301020000
Content-Type: text/plain;
 name="linux-2.6.10.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.10.patch"

diff -ur --exclude-from=/tmp/srcdiff.excludes.PySd63 --new-file orig-linux-2.6.10/include/net/tcp.h linux-2.6.10/include/net/tcp.h
--- orig-linux-2.6.10/include/net/tcp.h	2004-12-24 23:34:00.000000000 +0200
+++ linux-2.6.10/include/net/tcp.h	2005-02-15 15:08:11.058007978 +0200
@@ -159,6 +159,7 @@
 extern void tcp_bucket_destroy(struct tcp_bind_bucket *tb);
 extern void tcp_bucket_unlock(struct sock *sk);
 extern int tcp_port_rover;
+extern struct sock *tcp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 hnum, int dif);
 
 /* These are AF independent. */
 static __inline__ int tcp_bhashfn(__u16 lport)
diff -ur --exclude-from=/tmp/srcdiff.excludes.PySd63 --new-file orig-linux-2.6.10/include/net/udp.h linux-2.6.10/include/net/udp.h
--- orig-linux-2.6.10/include/net/udp.h	2004-12-24 23:35:24.000000000 +0200
+++ linux-2.6.10/include/net/udp.h	2005-02-15 15:06:06.695143766 +0200
@@ -74,6 +74,8 @@
 extern unsigned int udp_poll(struct file *file, struct socket *sock,
 			     poll_table *wait);
 
+extern struct sock *udp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 dport, int dif);
+
 DECLARE_SNMP_STAT(struct udp_mib, udp_statistics);
 #define UDP_INC_STATS(field)		SNMP_INC_STATS(udp_statistics, field)
 #define UDP_INC_STATS_BH(field)		SNMP_INC_STATS_BH(udp_statistics, field)
diff -ur --exclude-from=/tmp/srcdiff.excludes.PySd63 --new-file orig-linux-2.6.10/net/ipv4/netfilter/ipt_owner.c linux-2.6.10/net/ipv4/netfilter/ipt_owner.c
--- orig-linux-2.6.10/net/ipv4/netfilter/ipt_owner.c	2004-12-24 23:35:28.000000000 +0200
+++ linux-2.6.10/net/ipv4/netfilter/ipt_owner.c	2005-02-15 15:06:06.697143458 +0200
@@ -6,12 +6,19 @@
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
+ *
+ * 03/26/2003 Patrick McHardy <kaber@trash.net>	: LOCAL_IN support
  */
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/file.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
 
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -21,7 +28,7 @@
 MODULE_DESCRIPTION("iptables owner match");
 
 static int
-match_comm(const struct sk_buff *skb, const char *comm)
+match_comm(const struct sock *sk, const char *comm)
 {
 	struct task_struct *g, *p;
 	struct files_struct *files;
@@ -38,7 +45,7 @@
 			spin_lock(&files->file_lock);
 			for (i=0; i < files->max_fds; i++) {
 				if (fcheck_files(files, i) ==
-				    skb->sk->sk_socket->file) {
+				    sk->sk_socket->file) {
 					spin_unlock(&files->file_lock);
 					task_unlock(p);
 					read_unlock(&tasklist_lock);
@@ -54,7 +61,7 @@
 }
 
 static int
-match_pid(const struct sk_buff *skb, pid_t pid)
+match_pid(const struct sock *sk, pid_t pid)
 {
 	struct task_struct *p;
 	struct files_struct *files;
@@ -70,7 +77,7 @@
 		spin_lock(&files->file_lock);
 		for (i=0; i < files->max_fds; i++) {
 			if (fcheck_files(files, i) ==
-			    skb->sk->sk_socket->file) {
+			    sk->sk_socket->file) {
 				spin_unlock(&files->file_lock);
 				task_unlock(p);
 				read_unlock(&tasklist_lock);
@@ -86,10 +93,10 @@
 }
 
 static int
-match_sid(const struct sk_buff *skb, pid_t sid)
+match_sid(const struct sock *sk, pid_t sid)
 {
 	struct task_struct *g, *p;
-	struct file *file = skb->sk->sk_socket->file;
+	struct file *file = sk->sk_socket->file;
 	int i, found=0;
 
 	read_lock(&tasklist_lock);
@@ -129,41 +136,71 @@
       int *hotdrop)
 {
 	const struct ipt_owner_info *info = matchinfo;
+	struct iphdr *iph = skb->nh.iph;
+	struct sock *sk = NULL;
+	int ret = 0;
+
+	if (out) {
+		sk = skb->sk;
+	} else {
+		if (iph->protocol == IPPROTO_TCP) {
+			struct tcphdr *tcph =
+				(struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+			sk = tcp_v4_lookup(iph->saddr, tcph->source,
+			                   iph->daddr, tcph->dest,
+			                   skb->dev->ifindex);
+			if (sk && sk->sk_state == TCP_TIME_WAIT) {
+				tcp_tw_put((struct tcp_tw_bucket *)sk);
+				return ret;
+			}
+		} else if (iph->protocol == IPPROTO_UDP) {
+			struct udphdr *udph =
+				(struct udphdr *)((u_int32_t *)iph + iph->ihl);
+			sk = udp_v4_lookup(iph->saddr, udph->source, iph->daddr,
+			                   udph->dest, skb->dev->ifindex);
+		}
+	}
 
-	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
-		return 0;
+	if (!sk || !sk->sk_socket || !sk->sk_socket->file)
+		goto out;
 
 	if(info->match & IPT_OWNER_UID) {
-		if ((skb->sk->sk_socket->file->f_uid != info->uid) ^
+		if ((sk->sk_socket->file->f_uid != info->uid) ^
 		    !!(info->invert & IPT_OWNER_UID))
-			return 0;
+			goto out;
 	}
 
 	if(info->match & IPT_OWNER_GID) {
-		if ((skb->sk->sk_socket->file->f_gid != info->gid) ^
+		if ((sk->sk_socket->file->f_gid != info->gid) ^
 		    !!(info->invert & IPT_OWNER_GID))
-			return 0;
+			goto out;
 	}
 
 	if(info->match & IPT_OWNER_PID) {
-		if (!match_pid(skb, info->pid) ^
+		if (!match_pid(sk, info->pid) ^
 		    !!(info->invert & IPT_OWNER_PID))
-			return 0;
+			goto out;
 	}
 
 	if(info->match & IPT_OWNER_SID) {
-		if (!match_sid(skb, info->sid) ^
+		if (!match_sid(sk, info->sid) ^
 		    !!(info->invert & IPT_OWNER_SID))
-			return 0;
+			goto out;
 	}
 
 	if(info->match & IPT_OWNER_COMM) {
-		if (!match_comm(skb, info->comm) ^
+		if (!match_comm(sk, info->comm) ^
 		    !!(info->invert & IPT_OWNER_COMM))
-			return 0;
+			goto out;
 	}
 
-	return 1;
+	ret = 1;
+
+out:
+	if (in && sk)
+		sock_put(sk);
+
+	return ret;
 }
 
 static int
@@ -173,11 +210,19 @@
            unsigned int matchsize,
            unsigned int hook_mask)
 {
-        if (hook_mask
-            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
-                printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
-                return 0;
-        }
+	if (hook_mask
+	    & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING) |
+	    (1 << NF_IP_LOCAL_IN))) {
+		printk("ipt_owner: only valid for LOCAL_IN, LOCAL_OUT "
+		       "or POST_ROUTING.\n");
+		return 0;
+	}
+
+	if ((hook_mask & (1 << NF_IP_LOCAL_IN))
+	    && ip->proto != IPPROTO_TCP && ip->proto != IPPROTO_UDP) {
+		printk("ipt_owner: only TCP or UDP can be used in LOCAL_IN\n");
+		return 0;
+	}
 
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_owner_info))) {
 		printk("Matchsize %u != %Zu\n", matchsize,
diff -ur --exclude-from=/tmp/srcdiff.excludes.PySd63 --new-file orig-linux-2.6.10/net/ipv4/udp.c linux-2.6.10/net/ipv4/udp.c
--- orig-linux-2.6.10/net/ipv4/udp.c	2004-12-24 23:34:01.000000000 +0200
+++ linux-2.6.10/net/ipv4/udp.c	2005-02-15 15:06:36.329583897 +0200
@@ -1564,6 +1564,7 @@
 EXPORT_SYMBOL(udp_prot);
 EXPORT_SYMBOL(udp_sendmsg);
 EXPORT_SYMBOL(udp_poll);
+EXPORT_SYMBOL(udp_v4_lookup);
 
 #ifdef CONFIG_PROC_FS
 EXPORT_SYMBOL(udp_proc_register);

--------------070101050201040301020000--
