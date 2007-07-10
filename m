From: =?ISO-8859-2?Q?Maciej_So=B3tysiak?= <maciej.soltysiak@ae.poznan.pl>
Subject: [PATCH] LOG target - log GID
Date: Tue, 10 Jul 2007 21:25:11 +0200
Message-ID: <4693DD17.9020406@ae.poznan.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040700080307090604080705"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------040700080307090604080705
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

While I was browsing through the files in my home directory I stumbled 
upon my patch from
May 2003 that adds to the LOG target an option to log UID and GID.

I noticed that someone already has done that in the past 4 years ;-)
However currently LOG only logs UID. My patch used to log GID too, so
what do you say about applying the patches attached.

log_gid_kern.diff - patch ipt_LOG.c and ip6t_LOG.c
log_gid_user.diff - patch libipt_LOG.c and libip6t_LOG.c

Please CC me, I am not on the list for some time now.
Best Regards,
Maciej Soltysiak

diff -Nru linux-2.6.22.orig/net/ipv4/netfilter/ipt_LOG.c 
linux-2.6.22/net/ipv4/netfilter/ipt_LOG.c
--- linux-2.6.22.orig/net/ipv4/netfilter/ipt_LOG.c    2007-07-10 
20:57:44.000000000 +0200
+++ linux-2.6.22/net/ipv4/netfilter/ipt_LOG.c    2007-07-10 
21:01:16.000000000 +0200
@@ -337,7 +337,9 @@
     if ((logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
         read_lock_bh(&skb->sk->sk_callback_lock);
         if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-            printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+            printk("UID=%u GID=%u",
+                skb->sk->sk_socket->file->f_uid,
+                skb->sk->sk_socket->file->f_gid);
         read_unlock_bh(&skb->sk->sk_callback_lock);
     }
 
diff -Nru linux-2.6.22.orig/net/ipv6/netfilter/ip6t_LOG.c 
linux-2.6.22/net/ipv6/netfilter/ip6t_LOG.c
--- linux-2.6.22.orig/net/ipv6/netfilter/ip6t_LOG.c    2007-07-10 
20:57:44.000000000 +0200
+++ linux-2.6.22/net/ipv6/netfilter/ip6t_LOG.c    2007-07-10 
21:01:41.000000000 +0200
@@ -359,7 +359,9 @@
     if ((logflags & IP6T_LOG_UID) && recurse && skb->sk) {
         read_lock_bh(&skb->sk->sk_callback_lock);
         if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-            printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+            printk("UID=%u GID=%u",
+                skb->sk->sk_socket->file->f_uid,
+                skb->sk->sk_socket->file->f_gid);
         read_unlock_bh(&skb->sk->sk_callback_lock);
     }
 }

diff -Nru iptables-1.3.8-20070709.orig/extensions/libip6t_LOG.c 
iptables-1.3.8-20070709/extensions/libip6t_LOG.c
--- iptables-1.3.8-20070709.orig/extensions/libip6t_LOG.c    2006-10-10 
08:18:40.000000000 +0200
+++ iptables-1.3.8-20070709/extensions/libip6t_LOG.c    2007-07-10 
20:52:50.000000000 +0200
@@ -28,7 +28,7 @@
 " --log-tcp-sequence        Log TCP sequence numbers.\n\n"
 " --log-tcp-options        Log TCP options.\n\n"
 " --log-ip-options        Log IP options.\n\n"
-" --log-uid            Log UID owning the local socket.\n\n",
+" --log-uid            Log UID/GID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 
diff -Nru iptables-1.3.8-20070709.orig/extensions/libipt_LOG.c 
iptables-1.3.8-20070709/extensions/libipt_LOG.c
--- iptables-1.3.8-20070709.orig/extensions/libipt_LOG.c    2006-10-10 
08:18:40.000000000 +0200
+++ iptables-1.3.8-20070709/extensions/libipt_LOG.c    2007-07-10 
20:52:46.000000000 +0200
@@ -28,7 +28,7 @@
 " --log-tcp-sequence        Log TCP sequence numbers.\n\n"
 " --log-tcp-options        Log TCP options.\n\n"
 " --log-ip-options        Log IP options.\n\n"
-" --log-uid            Log UID owning the local socket.\n\n",
+" --log-uid            Log UID/GID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 

--------------040700080307090604080705
Content-Type: text/plain;
 name="log_gid_kern.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log_gid_kern.diff"

diff -Nru linux-2.6.22.orig/net/ipv4/netfilter/ipt_LOG.c linux-2.6.22/net/ipv4/netfilter/ipt_LOG.c
--- linux-2.6.22.orig/net/ipv4/netfilter/ipt_LOG.c	2007-07-10 20:57:44.000000000 +0200
+++ linux-2.6.22/net/ipv4/netfilter/ipt_LOG.c	2007-07-10 21:01:16.000000000 +0200
@@ -337,7 +337,9 @@
 	if ((logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+			printk("UID=%u GID=%u",
+				skb->sk->sk_socket->file->f_uid,
+				skb->sk->sk_socket->file->f_gid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 
diff -Nru linux-2.6.22.orig/net/ipv6/netfilter/ip6t_LOG.c linux-2.6.22/net/ipv6/netfilter/ip6t_LOG.c
--- linux-2.6.22.orig/net/ipv6/netfilter/ip6t_LOG.c	2007-07-10 20:57:44.000000000 +0200
+++ linux-2.6.22/net/ipv6/netfilter/ip6t_LOG.c	2007-07-10 21:01:41.000000000 +0200
@@ -359,7 +359,9 @@
 	if ((logflags & IP6T_LOG_UID) && recurse && skb->sk) {
 		read_lock_bh(&skb->sk->sk_callback_lock);
 		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
-			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+			printk("UID=%u GID=%u",
+				skb->sk->sk_socket->file->f_uid,
+				skb->sk->sk_socket->file->f_gid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 	}
 }

--------------040700080307090604080705
Content-Type: text/plain;
 name="log_gid_user.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="log_gid_user.diff"

diff -Nru iptables-1.3.8-20070709.orig/extensions/libip6t_LOG.c iptables-1.3.8-20070709/extensions/libip6t_LOG.c
--- iptables-1.3.8-20070709.orig/extensions/libip6t_LOG.c	2006-10-10 08:18:40.000000000 +0200
+++ iptables-1.3.8-20070709/extensions/libip6t_LOG.c	2007-07-10 20:52:50.000000000 +0200
@@ -28,7 +28,7 @@
 " --log-tcp-sequence		Log TCP sequence numbers.\n\n"
 " --log-tcp-options		Log TCP options.\n\n"
 " --log-ip-options		Log IP options.\n\n"
-" --log-uid			Log UID owning the local socket.\n\n",
+" --log-uid			Log UID/GID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 
diff -Nru iptables-1.3.8-20070709.orig/extensions/libipt_LOG.c iptables-1.3.8-20070709/extensions/libipt_LOG.c
--- iptables-1.3.8-20070709.orig/extensions/libipt_LOG.c	2006-10-10 08:18:40.000000000 +0200
+++ iptables-1.3.8-20070709/extensions/libipt_LOG.c	2007-07-10 20:52:46.000000000 +0200
@@ -28,7 +28,7 @@
 " --log-tcp-sequence		Log TCP sequence numbers.\n\n"
 " --log-tcp-options		Log TCP options.\n\n"
 " --log-ip-options		Log IP options.\n\n"
-" --log-uid			Log UID owning the local socket.\n\n",
+" --log-uid			Log UID/GID owning the local socket.\n\n",
 IPTABLES_VERSION);
 }
 

--------------040700080307090604080705--
