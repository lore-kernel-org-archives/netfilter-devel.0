From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 3/6]: Add --log-uid option to ipt_LOG/ip6t_LOG
Date: Tue, 11 Jan 2005 13:49:53 +0100
Message-ID: <41E3CB71.8040100@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060907000606000802020403"
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
--------------060907000606000802020403
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------060907000606000802020403
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/01/11 03:43:46+01:00 kaber@coreworks.de 
#   [NETFILTER]: Add --log-uid option to ipt_LOG/ip6t_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_LOG.c
#   2005/01/11 03:43:38+01:00 kaber@coreworks.de +8 -0
#   [NETFILTER]: Add --log-uid option to ipt_LOG/ip6t_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_LOG.c
#   2005/01/11 03:43:38+01:00 kaber@coreworks.de +8 -0
#   [NETFILTER]: Add --log-uid option to ipt_LOG/ip6t_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv6/ip6t_LOG.h
#   2005/01/11 03:43:38+01:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: Add --log-uid option to ipt_LOG/ip6t_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ipt_LOG.h
#   2005/01/11 03:43:38+01:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: Add --log-uid option to ipt_LOG/ip6t_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
--- a/include/linux/netfilter_ipv4/ipt_LOG.h	2005-01-11 13:39:48 +01:00
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h	2005-01-11 13:39:48 +01:00
@@ -4,7 +4,8 @@
 #define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IPT_LOG_IPOPT		0x04	/* Log IP options */
-#define IPT_LOG_MASK		0x07
+#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
+#define IPT_LOG_MASK		0x0f
 
 struct ipt_log_info {
 	unsigned char level;
diff -Nru a/include/linux/netfilter_ipv6/ip6t_LOG.h b/include/linux/netfilter_ipv6/ip6t_LOG.h
--- a/include/linux/netfilter_ipv6/ip6t_LOG.h	2005-01-11 13:39:48 +01:00
+++ b/include/linux/netfilter_ipv6/ip6t_LOG.h	2005-01-11 13:39:48 +01:00
@@ -4,7 +4,8 @@
 #define IP6T_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IP6T_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IP6T_LOG_IPOPT		0x04	/* Log IP options */
-#define IP6T_LOG_MASK		0x07
+#define IP6T_LOG_UID		0x08	/* Log UID owning local socket */
+#define IP6T_LOG_MASK		0x0f
 
 struct ip6t_log_info {
 	unsigned char level;
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	2005-01-11 13:39:48 +01:00
+++ b/net/ipv4/netfilter/ipt_LOG.c	2005-01-11 13:39:48 +01:00
@@ -327,6 +327,14 @@
 		printk("PROTO=%u ", ih->protocol);
 	}
 
+	/* Max length: 15 "UID=4294967295 " */
+ 	if ((info->logflags & IPT_LOG_UID) && !iphoff && skb->sk) {
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
+ 			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
+	}
+
 	/* Proto    Max log string length */
 	/* IP:      40+46+6+11+127 = 230 */
 	/* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
diff -Nru a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
--- a/net/ipv6/netfilter/ip6t_LOG.c	2005-01-11 13:39:48 +01:00
+++ b/net/ipv6/netfilter/ip6t_LOG.c	2005-01-11 13:39:48 +01:00
@@ -347,6 +347,14 @@
 	default:
 		printk("PROTO=%u ", currenthdr);
 	}
+
+	/* Max length: 15 "UID=4294967295 " */
+	if ((info->logflags & IP6T_LOG_UID) && recurse && skb->sk) {
+		read_lock_bh(&skb->sk->sk_callback_lock);
+		if (skb->sk->sk_socket && skb->sk->sk_socket->file)
+			printk("UID=%u ", skb->sk->sk_socket->file->f_uid);
+		read_unlock_bh(&skb->sk->sk_callback_lock);
+	}
 }
 
 static void

--------------060907000606000802020403--
