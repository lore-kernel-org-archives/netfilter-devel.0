From: Patrick McHardy <kaber@trash.net>
Subject: [RESEND}: owner socket lookup
Date: Thu, 19 Dec 2002 18:03:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E01FBFA.9020706@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060702090208030902070103"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060702090208030902070103
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

about two or three month ago i sent you a pom-patch for the owner match 
so it also works in
PREROUTING and INPUT chains. I never received a final response from you. 
Please just tell
me your decision so i know it didn't got lost.

This version has bugfixes, the first one had some mixups (saddr instead 
of daddr for
udp_v4_lookup) and also didn't release sockets after lookups.

Thanks,
Patrick

--------------060702090208030902070103
Content-Type: text/plain;
 name="owner-v4-pom.diff-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="owner-v4-pom.diff-2"

diff -urN patch-o-matic-20020825-orig/extra/owner-socketlookup.patch patch-o-matic-20020825/extra/owner-socketlookup.patch
--- patch-o-matic-20020825-orig/extra/owner-socketlookup.patch	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-20020825/extra/owner-socketlookup.patch	2002-12-19 17:51:24.000000000 +0100
@@ -0,0 +1,201 @@
+diff -urN linux-2.4.19-clean/include/net/tcp.h linux-2.4.19/include/net/tcp.h
+--- linux-2.4.19-clean/include/net/tcp.h	2002-08-03 02:39:46.000000000 +0200
++++ linux-2.4.19/include/net/tcp.h	2002-12-19 17:42:45.000000000 +0100
+@@ -140,6 +140,7 @@
+ extern void tcp_bucket_unlock(struct sock *sk);
+ extern int tcp_port_rover;
+ extern struct sock *tcp_v4_lookup_listener(u32 addr, unsigned short hnum, int dif);
++extern struct sock *tcp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 hnum, int dif);
+ 
+ /* These are AF independent. */
+ static __inline__ int tcp_bhashfn(__u16 lport)
+diff -urN linux-2.4.19-clean/include/net/udp.h linux-2.4.19/include/net/udp.h
+--- linux-2.4.19-clean/include/net/udp.h	2001-11-22 20:47:15.000000000 +0100
++++ linux-2.4.19/include/net/udp.h	2002-12-19 17:42:45.000000000 +0100
+@@ -69,6 +69,8 @@
+ extern int	udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+ extern int	udp_disconnect(struct sock *sk, int flags);
+ 
++extern struct sock *udp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 dport, int dif);
++
+ extern struct udp_mib udp_statistics[NR_CPUS*2];
+ #define UDP_INC_STATS(field)		SNMP_INC_STATS(udp_statistics, field)
+ #define UDP_INC_STATS_BH(field)		SNMP_INC_STATS_BH(udp_statistics, field)
+diff -urN linux-2.4.19-clean/net/ipv4/netfilter/ipt_owner.c linux-2.4.19/net/ipv4/netfilter/ipt_owner.c
+--- linux-2.4.19-clean/net/ipv4/netfilter/ipt_owner.c	2002-12-19 17:43:07.000000000 +0100
++++ linux-2.4.19/net/ipv4/netfilter/ipt_owner.c	2002-12-19 17:47:38.000000000 +0100
+@@ -2,17 +2,26 @@
+    locally generated outgoing packets.
+ 
+    Copyright (C) 2000 Marc Boucher
++
++   08/28/2002 Patrick McHardy <kaber@trash.net> 
++   		- Modified to also match properties of receiving sockets
+  */
+ #include <linux/module.h>
+ #include <linux/skbuff.h>
+ #include <linux/file.h>
++#include <linux/ip.h>
++#include <linux/tcp.h>
++#include <linux/udp.h>
+ #include <net/sock.h>
++#include <net/tcp.h>
++#include <net/udp.h>
++#include <net/route.h>
+ 
+ #include <linux/netfilter_ipv4/ipt_owner.h>
+ #include <linux/netfilter_ipv4/ip_tables.h>
+ 
+ static int
+-match_comm(const struct sk_buff *skb, const char *comm)
++match_comm(const struct sock *sk, const char *comm)
+ {
+ 	struct task_struct *p;
+ 	struct files_struct *files;
+@@ -28,7 +37,7 @@
+ 		if(files) {
+ 			read_lock(&files->file_lock);
+ 			for (i=0; i < files->max_fds; i++) {
+-				if (fcheck_files(files, i) == skb->sk->socket->file) {
++				if (fcheck_files(files, i) == sk->socket->file) {
+ 					read_unlock(&files->file_lock);
+ 					task_unlock(p);
+ 					read_unlock(&tasklist_lock);
+@@ -44,7 +53,7 @@
+ }
+ 
+ static int
+-match_pid(const struct sk_buff *skb, pid_t pid)
++match_pid(const struct sock *sk, pid_t pid)
+ {
+ 	struct task_struct *p;
+ 	struct files_struct *files;
+@@ -59,7 +68,7 @@
+ 	if(files) {
+ 		read_lock(&files->file_lock);
+ 		for (i=0; i < files->max_fds; i++) {
+-			if (fcheck_files(files, i) == skb->sk->socket->file) {
++			if (fcheck_files(files, i) == sk->socket->file) {
+ 				read_unlock(&files->file_lock);
+ 				task_unlock(p);
+ 				read_unlock(&tasklist_lock);
+@@ -75,10 +84,10 @@
+ }
+ 
+ static int
+-match_sid(const struct sk_buff *skb, pid_t sid)
++match_sid(const struct sock *sk, pid_t sid)
+ {
+ 	struct task_struct *p;
+-	struct file *file = skb->sk->socket->file;
++	struct file *file = sk->socket->file;
+ 	int i, found=0;
+ 
+ 	read_lock(&tasklist_lock);
+@@ -119,41 +128,67 @@
+       int *hotdrop)
+ {
+ 	const struct ipt_owner_info *info = matchinfo;
++	struct sock *sk = NULL;
++	int ret = 0;
+ 
+-	if (!skb->sk || !skb->sk->socket || !skb->sk->socket->file)
+-		return 0;
++	if (out) {
++		sk = skb->sk;
++	} else {
++		struct iphdr *iph = skb->nh.iph;
++		if (iph->protocol == IPPROTO_TCP) {
++			struct tcphdr *tcph =
++				(struct tcphdr*)((u_int32_t*)iph + iph->ihl);
++			sk = tcp_v4_lookup(iph->saddr, tcph->source,
++					   iph->daddr, tcph->dest,
++					   ((struct rtable*)skb->dst)->rt_iif);
++		} else if (iph->protocol == IPPROTO_UDP) {
++			struct udphdr *udph =
++				(struct udphdr*)((u_int32_t*)iph + iph->ihl);
++			sk = udp_v4_lookup(iph->saddr, udph->source, iph->daddr,
++					   udph->dest, skb->dev->ifindex);
++		}
++	} 
++					
++	if (!sk || !sk->socket || !sk->socket->file)
++		goto out;
+ 
+ 	if(info->match & IPT_OWNER_UID) {
+-		if((skb->sk->socket->file->f_uid != info->uid) ^
++		if((sk->socket->file->f_uid != info->uid) ^
+ 		    !!(info->invert & IPT_OWNER_UID))
+-			return 0;
++			goto out;
+ 	}
+ 
+ 	if(info->match & IPT_OWNER_GID) {
+-		if((skb->sk->socket->file->f_gid != info->gid) ^
++		if((sk->socket->file->f_gid != info->gid) ^
+ 		    !!(info->invert & IPT_OWNER_GID))
+-			return 0;
++			goto out;
+ 	}
+ 
+ 	if(info->match & IPT_OWNER_PID) {
+-		if (!match_pid(skb, info->pid) ^
++		if (!match_pid(sk, info->pid) ^
+ 		    !!(info->invert & IPT_OWNER_PID))
+-			return 0;
++			goto out;
+ 	}
+ 
+ 	if(info->match & IPT_OWNER_SID) {
+-		if (!match_sid(skb, info->sid) ^
++		if (!match_sid(sk, info->sid) ^
+ 		    !!(info->invert & IPT_OWNER_SID))
+-			return 0;
++			goto out;
+ 	}
+ 
+ 	if(info->match & IPT_OWNER_COMM) {
+-		if (!match_comm(skb, info->comm) ^
++		if (!match_comm(sk, info->comm) ^
+ 		    !!(info->invert & IPT_OWNER_COMM))
+-			return 0;
++			goto out;
+ 	}
+ 
+-	return 1;
++	ret = 1;
++
++out:
++	if (in && sk)
++		sock_put(sk);
++
++	return ret;
+ }
+ 
+ static int
+@@ -164,8 +199,10 @@
+            unsigned int hook_mask)
+ {
+         if (hook_mask
+-            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
+-                printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
++            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING) |
++		(1 << NF_IP_LOCAL_IN)  | (1 << NF_IP_PRE_ROUTING))) {
++                printk("ipt_owner: only valid for LOCAL_OUT, LOCAL_IN, "
++		       "POST_ROUTING or PRE_ROUTING.\n");
+                 return 0;
+         }
+ 
+diff -urN linux-2.4.19-clean/net/netsyms.c linux-2.4.19/net/netsyms.c
+--- linux-2.4.19-clean/net/netsyms.c	2002-08-03 02:39:46.000000000 +0200
++++ linux-2.4.19/net/netsyms.c	2002-12-19 17:42:45.000000000 +0100
+@@ -588,4 +588,9 @@
+ EXPORT_SYMBOL(net_call_rx_atomic);
+ EXPORT_SYMBOL(softnet_data);
+ 
++#if defined(CONFIG_IP_NF_MATCH_OWNER)||defined(CONFIG_IP_NF_MATCH_OWNER_MODULE)
++EXPORT_SYMBOL(tcp_v4_lookup);
++EXPORT_SYMBOL(udp_v4_lookup);
++#endif /* CONFIG_IP_NF_MATCH_OWNER */
++
+ #endif  /* CONFIG_NET */
diff -urN patch-o-matic-20020825-orig/extra/owner-socketlookup.patch.help patch-o-matic-20020825/extra/owner-socketlookup.patch.help
--- patch-o-matic-20020825-orig/extra/owner-socketlookup.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-20020825/extra/owner-socketlookup.patch.help	2002-12-19 17:31:05.000000000 +0100
@@ -0,0 +1,13 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: working
+
+The patch allows you to use the owner match in the INPUT/PREROUTING chains to
+match properties of the receiving socket.
+
+Example:
+
+	# Allow packets coming in on eth0 to sockets owned be local user
+	# kaber
+	
+	iptables -A INPUT -i eth0 -m owner --uid-owner kaber -j ACCEPT
+

--------------060702090208030902070103--
