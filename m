From: Michael Scholl <michael.scholl@core-networks.de>
Subject: owner-socketlookup patch linux 2.6.14+
Date: Mon, 30 Jan 2006 08:58:27 +0100
Message-ID: <43DDC723.2020905@core-networks.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050206070805070008090204"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------050206070805070008090204
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I try to fix the owner-socketlookup patch for the current kernel.

Compiling 2.6.15.1 with this patch shows this error

...
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
net/built-in.o:(__ksymtab+0xc70): undefined reference to `udp_v4_lookup'
make: *** [.tmp_vmlinux1] Error 1

Could anybody help me fixing this (i hope the last) error in my patch?

--
Michael

--------------050206070805070008090204
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff -ruP linux-2.6.15.1.orig/include/net/udp.h linux-2.6.15.1/include/net/udp.h
--- linux-2.6.15.1.orig/include/net/udp.h	2006-01-15 07:16:02.000000000 +0100
+++ linux-2.6.15.1/include/net/udp.h	2006-01-30 00:32:02.000000000 +0100
@@ -74,6 +74,8 @@
 extern unsigned int udp_poll(struct file *file, struct socket *sock,
 			     poll_table *wait);
 
+extern struct sock *udp_v4_lookup(u32 saddr, u16 sport, u32 daddr, u16 dport, int dif);
+
 DECLARE_SNMP_STAT(struct udp_mib, udp_statistics);
 #define UDP_INC_STATS(field)		SNMP_INC_STATS(udp_statistics, field)
 #define UDP_INC_STATS_BH(field)		SNMP_INC_STATS_BH(udp_statistics, field)
diff -ruP linux-2.6.15.1.orig/net/ipv4/netfilter/ipt_owner.c linux-2.6.15.1/net/ipv4/netfilter/ipt_owner.c
--- linux-2.6.15.1.orig/net/ipv4/netfilter/ipt_owner.c	2006-01-15 07:16:02.000000000 +0100
+++ linux-2.6.15.1/net/ipv4/netfilter/ipt_owner.c	2006-01-30 07:21:01.000000000 +0100
@@ -12,7 +12,14 @@
 #include <linux/skbuff.h>
 #include <linux/file.h>
 #include <linux/rcupdate.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
 #include <net/sock.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+#include <net/inet_hashtables.h>
 
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -30,23 +37,48 @@
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
+			struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + iph->ihl);
+			sk = inet_lookup(&tcp_hashinfo, iph->saddr, tcph->source, iph->daddr, tcph->dest, skb->dev->ifindex);
+
+			if (sk && sk->sk_state == TCP_TIME_WAIT) {
+				inet_twsk_put((struct inet_timewait_sock *)sk);
+				return ret;
+			}
+		} else if (iph->protocol == IPPROTO_UDP) {
+			struct udphdr *udph = (struct udphdr *)((u_int32_t *)iph + iph->ihl);
+			sk = udp_v4_lookup(iph->saddr, udph->source, iph->daddr, udph->dest, skb->dev->ifindex);
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
 
-	return 1;
+	ret = 1;
+
+out:
+	if (in && sk)
+		sock_put(sk);
+	return ret;
 }
 
 static int
@@ -58,11 +90,19 @@
 {
 	const struct ipt_owner_info *info = matchinfo;
 
-        if (hook_mask
-            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
-                printk("ipt_owner: only valid for LOCAL_OUT or POST_ROUTING.\n");
-                return 0;
-        }
+	 if (hook_mask
+		& ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING) |
+		(1 << NF_IP_LOCAL_IN))) {
+			printk("ipt_owner: only valid for LOCAL_IN, LOCAL_OUT "
+				"or POST_ROUTING.\n");
+			return 0;
+ 	 }
+
+	 if ((hook_mask & (1 << NF_IP_LOCAL_IN))
+	     && ip->proto != IPPROTO_TCP && ip->proto != IPPROTO_UDP) {
+		printk("ipt_owner: only TCP or UDP can be used in LOCAL_IN\n");
+               return 0;
+	}
 
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_owner_info))) {
 		printk("Matchsize %u != %Zu\n", matchsize,
diff -ruP linux-2.6.15.1.orig/net/ipv4/udp.c linux-2.6.15.1/net/ipv4/udp.c
--- linux-2.6.15.1.orig/net/ipv4/udp.c	2006-01-15 07:16:02.000000000 +0100
+++ linux-2.6.15.1/net/ipv4/udp.c	2006-01-30 00:31:44.000000000 +0100
@@ -265,7 +265,7 @@
 	return result;
 }
 
-static __inline__ struct sock *udp_v4_lookup(u32 saddr, u16 sport,
+extern __inline__ struct sock *udp_v4_lookup(u32 saddr, u16 sport,
 					     u32 daddr, u16 dport, int dif)
 {
 	struct sock *sk;
@@ -1566,6 +1566,7 @@
 EXPORT_SYMBOL(udp_prot);
 EXPORT_SYMBOL(udp_sendmsg);
 EXPORT_SYMBOL(udp_poll);
+EXPORT_SYMBOL(udp_v4_lookup);
 
 #ifdef CONFIG_PROC_FS
 EXPORT_SYMBOL(udp_proc_register);

--------------050206070805070008090204--
