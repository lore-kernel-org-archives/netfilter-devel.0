From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 8/12]: lookup sockets for incoming packets in ipt_owner
Date: Tue, 21 Sep 2004 05:23:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414F9E99.8080507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030607070608030704070409"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------030607070608030704070409
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch exports __tcp_v4_lookup and udp_v4_lookup and changes the
owner match to look up the receiving socket for incoming packets.


ChangeSet@1.1935.1.8, 2004-09-19 18:08:05+02:00, kaber@coreworks.de
  [NETFILTER]: lookup sockets for incoming packets in ipt_owner
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------030607070608030704070409
Content-Type: text/x-patch;
 name="08.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="08.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/19 18:08:05+02:00 kaber@coreworks.de 
#   [NETFILTER]: lookup sockets for incoming packets in ipt_owner
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/udp.c
#   2004/09/19 18:07:39+02:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: lookup sockets for incoming packets in ipt_owner
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/tcp_ipv4.c
#   2004/09/19 18:07:39+02:00 kaber@coreworks.de +3 -2
#   [NETFILTER]: lookup sockets for incoming packets in ipt_owner
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_owner.c
#   2004/09/19 18:07:39+02:00 kaber@coreworks.de +76 -24
#   [NETFILTER]: lookup sockets for incoming packets in ipt_owner
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/net/udp.h
#   2004/09/19 18:07:39+02:00 kaber@coreworks.de +2 -0
#   [NETFILTER]: lookup sockets for incoming packets in ipt_owner
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/net/tcp.h
#   2004/09/19 18:07:39+02:00 kaber@coreworks.de +1 -0
#   [NETFILTER]: lookup sockets for incoming packets in ipt_owner
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/net/tcp.h b/include/net/tcp.h
--- a/include/net/tcp.h	2004-09-20 11:58:45 +02:00
+++ b/include/net/tcp.h	2004-09-20 11:58:45 +02:00
@@ -160,6 +160,7 @@
 extern void tcp_bucket_unlock(struct sock *sk);
 extern int tcp_port_rover;
 extern struct sock *tcp_v4_lookup_listener(u32 addr, unsigned short hnum, int dif);
+extern struct sock *__tcp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 hnum, int dif);
 
 /* These are AF independent. */
 static __inline__ int tcp_bhashfn(__u16 lport)
diff -Nru a/include/net/udp.h b/include/net/udp.h
--- a/include/net/udp.h	2004-09-20 11:58:45 +02:00
+++ b/include/net/udp.h	2004-09-20 11:58:45 +02:00
@@ -72,6 +72,8 @@
 extern int	udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
 extern int	udp_disconnect(struct sock *sk, int flags);
 
+extern struct sock *udp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 dport, int dif);
+
 DECLARE_SNMP_STAT(struct udp_mib, udp_statistics);
 #define UDP_INC_STATS(field)		SNMP_INC_STATS(udp_statistics, field)
 #define UDP_INC_STATS_BH(field)		SNMP_INC_STATS_BH(udp_statistics, field)
diff -Nru a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
--- a/net/ipv4/netfilter/ipt_owner.c	2004-09-20 11:58:45 +02:00
+++ b/net/ipv4/netfilter/ipt_owner.c	2004-09-20 11:58:45 +02:00
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
@@ -129,41 +136,77 @@
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
+			struct tcphdr _tcph, *th =
+				skb_header_pointer(skb, skb->nh.iph->ihl * 4,
+				                   sizeof(_tcph), &_tcph);
+			if (th == NULL)
+				return ret;
+			sk = __tcp_v4_lookup(iph->saddr, th->source,
+			                     iph->daddr, ntohs(th->dest),
+			                     in->ifindex);
+			if (sk && sk->sk_state == TCP_TIME_WAIT) {
+				tcp_tw_put((struct tcp_tw_bucket *)sk);
+				return ret;
+			}
+		} else if (iph->protocol == IPPROTO_UDP) {
+			struct udphdr _udph, *uh =
+				skb_header_pointer(skb, skb->nh.iph->ihl * 4,
+				                   sizeof(_udph), &_udph);
+			if (uh == NULL)
+				return ret;
+			sk = udp_v4_lookup(iph->saddr, uh->source, iph->daddr,
+			                   uh->dest, in->ifindex);
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
@@ -173,11 +216,20 @@
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
+	    (1 << NF_IP_LOCAL_IN) | (1 << NF_IP_PRE_ROUTING))) {
+		printk("ipt_owner: only valid for PRE_ROUTING, LOCAL_IN, "
+		       "LOCAL_OUT or POST_ROUTING.\n");
+		return 0;
+	}
+
+	if ((hook_mask & ((1 << NF_IP_LOCAL_IN) | (1 << NF_IP_PRE_ROUTING)))
+	    && ip->proto != IPPROTO_TCP && ip->proto != IPPROTO_UDP) {
+		printk("ipt_owner: only TCP or UDP can be used in "
+		       "PRE_ROUTING/LOCAL_IN\n");
+		return 0;
+	}
 
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_owner_info))) {
 		printk("Matchsize %u != %Zu\n", matchsize,
diff -Nru a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c	2004-09-20 11:58:45 +02:00
+++ b/net/ipv4/tcp_ipv4.c	2004-09-20 11:58:45 +02:00
@@ -514,8 +514,8 @@
 	goto out;
 }
 
-static inline struct sock *__tcp_v4_lookup(u32 saddr, u16 sport,
-					   u32 daddr, u16 hnum, int dif)
+inline struct sock *__tcp_v4_lookup(u32 saddr, u16 sport,
+				    u32 daddr, u16 hnum, int dif)
 {
 	struct sock *sk = __tcp_v4_lookup_established(saddr, sport,
 						      daddr, hnum, dif);
@@ -2647,6 +2647,7 @@
 EXPORT_SYMBOL(tcp_v4_connect);
 EXPORT_SYMBOL(tcp_v4_do_rcv);
 EXPORT_SYMBOL(tcp_v4_lookup_listener);
+EXPORT_SYMBOL(__tcp_v4_lookup);
 EXPORT_SYMBOL(tcp_v4_rebuild_header);
 EXPORT_SYMBOL(tcp_v4_remember_stamp);
 EXPORT_SYMBOL(tcp_v4_send_check);
diff -Nru a/net/ipv4/udp.c b/net/ipv4/udp.c
--- a/net/ipv4/udp.c	2004-09-20 11:58:45 +02:00
+++ b/net/ipv4/udp.c	2004-09-20 11:58:45 +02:00
@@ -1516,6 +1516,7 @@
 EXPORT_SYMBOL(udp_port_rover);
 EXPORT_SYMBOL(udp_prot);
 EXPORT_SYMBOL(udp_sendmsg);
+EXPORT_SYMBOL(udp_v4_lookup);
 
 #ifdef CONFIG_PROC_FS
 EXPORT_SYMBOL(udp_proc_register);

--------------030607070608030704070409--
