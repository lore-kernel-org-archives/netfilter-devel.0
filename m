From: Kris <kris@theendless.org>
Subject: Patch for the addition of --log-uid in to a 2.4.x kernel
Date: Wed, 31 Aug 2005 11:28:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.63.0508311127340.12743@morpheus.theendless.org>
References: <Pine.LNX.4.63.0508301507100.12743@morpheus.theendless.org>
	<4314DE54.20804@trash.net>
	<Pine.LNX.4.63.0508311041440.12743@morpheus.theendless.org>
	<4315C4BE.3060304@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4315C4BE.3060304@trash.net>
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

Alrighty everyone, enjoy the patch.

--- ipt_LOG.c   2005-08-30 17:23:36.000000000 -0400
+++ ipt_LOG.patch       2005-08-30 17:58:33.000000000 -0400
@@ -43,7 +43,7 @@

  /* One level of recursion won't kill us */
  static void dump_packet(const struct ipt_log_info *info,
-                       struct iphdr *iph, unsigned int len, int recurse)
+                       struct iphdr *iph, unsigned int len, int recurse, 
const struct sk_buff *skb)
  {
         void *protoh = (u_int32_t *)iph + iph->ihl;
         unsigned int datalen = len - iph->ihl * 4;
@@ -234,7 +234,8 @@
                                 dump_packet(info,
                                             (struct iphdr *)(icmph + 1),
                                             datalen-sizeof(struct 
icmphdr),
-                                           0);
+                                           0,
+                                            skb);
                                 printk("] ");
                         }

@@ -289,6 +290,12 @@
                 printk("PROTO=%u ", iph->protocol);
         }

+        /* Max length: 15 "UID=4294967295 " */
+        if ((info->logflags & IPT_LOG_UID) && skb && skb->sk) {
+                if (skb->sk->socket && skb->sk->socket->file)
+                        printk("UID=%u GID=%u ", 
skb->sk->socket->file->f_uid, skb->sk->socket->file->f_gid);
+        }
+
         /* Proto    Max log string length */
         /* IP:      40+46+6+11+127 = 230 */
         /* TCP:     10+max(25,20+30+13+9+32+11+127) = 252 */
@@ -334,7 +341,7 @@
                         printk(" ");
         }

-       dump_packet(loginfo, iph, (*pskb)->len, 1);
+       dump_packet(loginfo, iph, (*pskb)->len, 1, *pskb);
         printk("\n");
         spin_unlock_bh(&log_lock);
  }
@@ -385,7 +392,7 @@

         spin_lock_bh(&log_lock);
         printk(KERN_WARNING "%s", prefix);
-       dump_packet(&loginfo, iph, len, 1);
+       dump_packet(&loginfo, iph, len, 1, NULL);
         printk("\n");
         spin_unlock_bh(&log_lock);
  }
