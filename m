From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 5/9]: Move rx timestamp functions to net/core/dev.c
Date: Mon, 15 Nov 2004 22:44:50 +0100
Message-ID: <41992352.3070607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010602030105030005050708"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------010602030105030005050708
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch moves the rx timestamp functions to net/core/dev.c.
This is necessary for the next patch: ip_queue needs to enable
timestamps while packets are received by it.



--------------010602030105030005050708
Content-Type: text/x-patch;
 name="05.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/11/13 13:27:50+01:00 kaber@coreworks.de 
#   [NET]: Move rx timestamp functions to net/core/dev.c
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/core/sock.c
#   2004/11/13 13:27:44+01:00 kaber@coreworks.de +2 -5
#   [NET]: Move rx timestamp functions to net/core/dev.c
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/core/dev.c
#   2004/11/13 13:27:43+01:00 kaber@coreworks.de +25 -0
#   [NET]: Move rx timestamp functions to net/core/dev.c
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/net/sock.h
#   2004/11/13 13:27:43+01:00 kaber@coreworks.de +0 -12
#   [NET]: Move rx timestamp functions to net/core/dev.c
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netdevice.h
#   2004/11/13 13:27:43+01:00 kaber@coreworks.de +3 -0
#   [NET]: Move rx timestamp functions to net/core/dev.c
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netdevice.h b/include/linux/netdevice.h
--- a/include/linux/netdevice.h	2004-11-15 22:07:09 +01:00
+++ b/include/linux/netdevice.h	2004-11-15 22:07:09 +01:00
@@ -928,6 +928,9 @@
 extern atomic_t netdev_dropping;
 extern int		netdev_set_master(struct net_device *dev, struct net_device *master);
 extern int skb_checksum_help(struct sk_buff *skb, int inward);
+/* rx skb timestamps */
+extern void		net_enable_timestamp(void);
+extern void		net_disable_timestamp(void);
 
 #ifdef CONFIG_SYSCTL
 extern char *net_sysctl_strdup(const char *s);
diff -Nru a/include/net/sock.h b/include/net/sock.h
--- a/include/net/sock.h	2004-11-15 22:07:09 +01:00
+++ b/include/net/sock.h	2004-11-15 22:07:09 +01:00
@@ -1270,19 +1270,7 @@
 	__kfree_skb(skb);
 }
 
-extern atomic_t netstamp_needed;
 extern void sock_enable_timestamp(struct sock *sk);
-
-static inline void net_timestamp(struct timeval *stamp) 
-{ 
-	if (atomic_read(&netstamp_needed)) 
-		do_gettimeofday(stamp);
-	else {
-		stamp->tv_sec = 0;
-		stamp->tv_usec = 0;
-	}		
-} 
-
 extern int sock_get_timestamp(struct sock *, struct timeval __user *);
 
 /* 
diff -Nru a/net/core/dev.c b/net/core/dev.c
--- a/net/core/dev.c	2004-11-15 22:07:09 +01:00
+++ b/net/core/dev.c	2004-11-15 22:07:09 +01:00
@@ -1001,6 +1001,29 @@
 	return notifier_call_chain(&netdev_chain, val, v);
 }
 
+/* When > 0 there are consumers of rx skb time stamps */
+static atomic_t netstamp_needed = ATOMIC_INIT(0);
+
+void net_enable_timestamp(void)
+{
+	atomic_inc(&netstamp_needed);
+}
+
+void net_disable_timestamp(void)
+{
+	atomic_dec(&netstamp_needed);
+}
+
+static inline void net_timestamp(struct timeval *stamp)
+{
+	if (atomic_read(&netstamp_needed))
+		do_gettimeofday(stamp);
+	else {
+		stamp->tv_sec = 0;
+		stamp->tv_usec = 0;
+	}
+}
+
 /*
  *	Support routine. Sends outgoing frames to any network
  *	taps currently in use.
@@ -3215,6 +3238,8 @@
 EXPORT_SYMBOL(synchronize_net);
 EXPORT_SYMBOL(unregister_netdevice);
 EXPORT_SYMBOL(unregister_netdevice_notifier);
+EXPORT_SYMBOL(net_enable_timestamp);
+EXPORT_SYMBOL(net_disable_timestamp);
 
 #if defined(CONFIG_BRIDGE) || defined(CONFIG_BRIDGE_MODULE)
 EXPORT_SYMBOL(br_handle_frame_hook);
diff -Nru a/net/core/sock.c b/net/core/sock.c
--- a/net/core/sock.c	2004-11-15 22:07:09 +01:00
+++ b/net/core/sock.c	2004-11-15 22:07:09 +01:00
@@ -179,7 +179,7 @@
 {	
 	if (sock_flag(sk, SOCK_TIMESTAMP)) { 
 		sock_reset_flag(sk, SOCK_TIMESTAMP);
-		atomic_dec(&netstamp_needed);
+		net_disable_timestamp();
 	}
 }
 
@@ -1226,9 +1226,6 @@
 }
 EXPORT_SYMBOL(release_sock);
 
-/* When > 0 there are consumers of rx skb time stamps */
-atomic_t netstamp_needed = ATOMIC_INIT(0); 
-
 int sock_get_timestamp(struct sock *sk, struct timeval __user *userstamp)
 { 
 	if (!sock_flag(sk, SOCK_TIMESTAMP))
@@ -1246,7 +1243,7 @@
 {	
 	if (!sock_flag(sk, SOCK_TIMESTAMP)) { 
 		sock_set_flag(sk, SOCK_TIMESTAMP);
-		atomic_inc(&netstamp_needed);
+		net_enable_timestamp();
 	}
 }
 EXPORT_SYMBOL(sock_enable_timestamp); 

--------------010602030105030005050708--
