From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] LOCAL_IN support for owner match
Date: Wed, 26 Mar 2003 15:15:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E81B60F.1000609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070907090003030901010005"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: marc@mbsi.ca
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
--------------070907090003030901010005
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc,

this patch adds LOCAL_IN support to the owner match.
My previous patches which i sent to netfilter-devel had
problems, namely they didn't knew about tcp sockets
in TIME_WAIT state so the crashed. This one is tested
on several computers for some time and seems to work well.
I think this is a very useful feature for filtering weird protocols
like H.323 or IIOB without conntrack helpers, but also for
local user traffic accounting or similar stuff. Please consider
for inclusion.

Regards,
Patrick


--------------070907090003030901010005
Content-Type: text/plain;
 name="pom-owner.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pom-owner.diff"

diff -urN a/extra/owner-socketlookup.patch b/extra/owner-socketlookup.patch
--- a/extra/owner-socketlookup.patch	1970-01-01 01:00:00.000000000 +0100
+++ b/extra/owner-socketlookup.patch	2003-03-26 14:29:09.000000000 +0100
@@ -0,0 +1,205 @@
+diff -urN a/include/net/tcp.h b/include/net/tcp.h
+--- a/include/net/tcp.h	2002-11-29 00:53:15.000000000 +0100
++++ b/include/net/tcp.h	2003-03-26 14:11:33.000000000 +0100
+@@ -140,6 +140,7 @@
+ extern void tcp_bucket_unlock(struct sock *sk);
+ extern int tcp_port_rover;
+ extern struct sock *tcp_v4_lookup_listener(u32 addr, unsigned short hnum, int dif);
++extern struct sock *tcp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 hnum, int dif);
+ 
+ /* These are AF independent. */
+ static __inline__ int tcp_bhashfn(__u16 lport)
+diff -urN a/include/net/udp.h b/include/net/udp.h
+--- a/include/net/udp.h	2001-11-22 20:47:15.000000000 +0100
++++ b/include/net/udp.h	2003-03-26 14:11:33.000000000 +0100
+@@ -69,6 +69,8 @@
+ extern int	udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
+ extern int	udp_disconnect(struct sock *sk, int flags);
+ 
++extern struct sock *udp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 dport, int dif);
++
+ extern struct udp_mib udp_statistics[NR_CPUS*2];
+ #define UDP_INC_STATS(field)		SNMP_INC_STATS(udp_statistics, field)
+ #define UDP_INC_STATS_BH(field)		SNMP_INC_STATS_BH(udp_statistics, field)
+diff -urN a/net/ipv4/netfilter/ipt_owner.c b/net/ipv4/netfilter/ipt_owner.c
+--- a/net/ipv4/netfilter/ipt_owner.c	2002-11-29 00:53:15.000000000 +0100
++++ b/net/ipv4/netfilter/ipt_owner.c	2003-03-26 14:26:20.000000000 +0100
+@@ -2,17 +2,25 @@
+    locally generated outgoing packets.
+ 
+    Copyright (C) 2000 Marc Boucher
++
++   03/26/2003 Patrick McHardy <kaber@trash.net>: LOCAL_IN support
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
+@@ -28,7 +36,7 @@
+ 		if(files) {
+ 			read_lock(&files->file_lock);
+ 			for (i=0; i < files->max_fds; i++) {
+-				if (fcheck_files(files, i) == skb->sk->socket->file) {
++				if (fcheck_files(files, i) == sk->socket->file) {
+ 					read_unlock(&files->file_lock);
+ 					task_unlock(p);
+ 					read_unlock(&tasklist_lock);
+@@ -44,7 +52,7 @@
+ }
+ 
+ static int
+-match_pid(const struct sk_buff *skb, pid_t pid)
++match_pid(const struct sock *sk, pid_t pid)
+ {
+ 	struct task_struct *p;
+ 	struct files_struct *files;
+@@ -59,7 +67,7 @@
+ 	if(files) {
+ 		read_lock(&files->file_lock);
+ 		for (i=0; i < files->max_fds; i++) {
+-			if (fcheck_files(files, i) == skb->sk->socket->file) {
++			if (fcheck_files(files, i) == sk->socket->file) {
+ 				read_unlock(&files->file_lock);
+ 				task_unlock(p);
+ 				read_unlock(&tasklist_lock);
+@@ -75,10 +83,10 @@
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
+@@ -119,41 +127,71 @@
+       int *hotdrop)
+ {
+ 	const struct ipt_owner_info *info = matchinfo;
+-
+-	if (!skb->sk || !skb->sk->socket || !skb->sk->socket->file)
+-		return 0;
++	struct iphdr *iph = skb->nh.iph;
++	struct sock *sk = NULL;
++	int ret = 0;
++
++	if (out) {
++		sk = skb->sk;
++	} else {
++		if (iph->protocol == IPPROTO_TCP) {
++			struct tcphdr *tcph =
++			        (struct tcphdr*)((u_int32_t*)iph + iph->ihl);
++			sk = tcp_v4_lookup(iph->saddr, tcph->source,
++			                   iph->daddr, tcph->dest,
++			                   ((struct rtable*)skb->dst)->rt_iif);
++			if (sk && sk->state == TCP_TIME_WAIT) {
++				tcp_tw_put((struct tcp_tw_bucket *)sk);
++				return ret;
++			}
++		} else if (iph->protocol == IPPROTO_UDP) {
++			struct udphdr *udph =
++			        (struct udphdr*)((u_int32_t*)iph + iph->ihl);
++			sk = udp_v4_lookup(iph->saddr, udph->source, iph->daddr,
++			                   udph->dest, skb->dev->ifindex);
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
+@@ -164,8 +202,10 @@
+            unsigned int hook_mask)
+ {
+         if (hook_mask
+-            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
+-                printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
++            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING) |
++		(1 << NF_IP_LOCAL_IN))) {
++        	printk("ipt_owner: only valid for LOCAL_IN, LOCAL_OUT "
++		       "or POST_ROUTING.\n");
+                 return 0;
+         }
+ 
+diff -urN a/net/netsyms.c b/net/netsyms.c
+--- a/net/netsyms.c	2002-11-29 00:53:16.000000000 +0100
++++ b/net/netsyms.c	2003-03-26 14:11:33.000000000 +0100
+@@ -596,4 +596,9 @@
+ EXPORT_SYMBOL(wireless_send_event);
+ #endif /* CONFIG_NET_RADIO || CONFIG_NET_PCMCIA_RADIO */
+ 
++#if defined(CONFIG_IP_NF_MATCH_OWNER)||defined(CONFIG_IP_NF_MATCH_OWNER_MODULE)
++EXPORT_SYMBOL(tcp_v4_lookup);
++EXPORT_SYMBOL(udp_v4_lookup);
++#endif /* CONFIG_IP_NF_MATCH_OWNER */
++
+ #endif  /* CONFIG_NET */
diff -urN a/extra/owner-socketlookup.patch.help b/extra/owner-socketlookup.patch.help
--- a/extra/owner-socketlookup.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ b/extra/owner-socketlookup.patch.help	2003-03-26 14:23:32.000000000 +0100
@@ -0,0 +1,14 @@
+Author: Patrick McHardy <kaber@trash.net>
+Status: working
+
+The patch allows you to use the owner match in the INPUT chain to match 
+properties of the receiving socket. This could be used to filter like
+those "personal firewalls", but is mainly intended to help filter weird
+protocols like H.323 or IIOB without conntrack helpers.
+
+Example:
+
+	# Allow packets on eth0 to sockets owned by local user gnugk
+	
+	iptables -A INPUT -i eth0 -m owner --uid-owner gnugk -j ACCEPT
+

--------------070907090003030901010005--
