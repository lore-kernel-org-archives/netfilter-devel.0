From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables --log-uid patch for 2.6
Date: Wed, 08 Dec 2004 05:33:16 +0100
Message-ID: <41B6840C.1030706@trash.net>
References: <1101668109.2922.1618.camel@ws102.darkcore.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090104010906080803000100"
Cc: netfilter-develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Lange <john.lange@open-it.ca>
In-Reply-To: <1101668109.2922.1618.camel@ws102.darkcore.net>
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
--------------090104010906080803000100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

John Lange wrote:

>I sent this to the list yesterday but I don't think it made it through.
>Apologies if it is a duplicate.
>
>Here are patches against the userspace and the kernel which allows the
>logging of the uid that generated the (outgoing) packet.
>
>This patch was originally the work of Martin Josefsson for the 2.4
>kernel but was never incorporated into the main code base. My work here
>simply ports it to the 2.6 kernel and the current version of netfilter
>(iptables).
>
Thanks, I've fixed locking (packets with skb->sk set may reach ipt_LOG
without the socket lock held through tunnel devices, so we need extra
locking) and added this patch to my tree. I'm going to add the userspace
patch when SVN is up again.

Regards
Patrick


--------------090104010906080803000100
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/12/08 04:53:15+01:00 kaber@coreworks.de 
#   [NETFILTER]: Add --log-uid option to ipt_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_LOG.c
#   2004/12/08 04:53:08+01:00 kaber@coreworks.de +8 -0
#   [NETFILTER]: Add --log-uid option to ipt_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4/ipt_LOG.h
#   2004/12/08 04:53:08+01:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: Add --log-uid option to ipt_LOG
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4/ipt_LOG.h b/include/linux/netfilter_ipv4/ipt_LOG.h
--- a/include/linux/netfilter_ipv4/ipt_LOG.h	2004-12-08 05:26:20 +01:00
+++ b/include/linux/netfilter_ipv4/ipt_LOG.h	2004-12-08 05:26:20 +01:00
@@ -4,7 +4,8 @@
 #define IPT_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
 #define IPT_LOG_TCPOPT		0x02	/* Log TCP options */
 #define IPT_LOG_IPOPT		0x04	/* Log IP options */
-#define IPT_LOG_MASK		0x07
+#define IPT_LOG_UID		0x08	/* Log UID owning local socket */
+#define IPT_LOG_MASK		0x0f
 
 struct ipt_log_info {
 	unsigned char level;
diff -Nru a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
--- a/net/ipv4/netfilter/ipt_LOG.c	2004-12-08 05:26:20 +01:00
+++ b/net/ipv4/netfilter/ipt_LOG.c	2004-12-08 05:26:20 +01:00
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

--------------090104010906080803000100--
