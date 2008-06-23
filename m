From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] cleanup netfilter_ipv6.h userspace header
Date: Mon, 23 Jun 2008 20:48:59 +0300
Message-ID: <20080623174859.GJ4756@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Kernel functions are not for userspace.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/netfilter_ipv6.h |    4 ++++
 1 file changed, 4 insertions(+)

88393f0873c19cf54c79388dd02c92a2ce7991c2 diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 3475a65..427969d 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -69,6 +69,8 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_LAST = INT_MAX,
 };
 
+#ifdef  __KERNEL__
+
 #ifdef CONFIG_NETFILTER
 extern int ip6_route_me_harder(struct sk_buff *skb);
 extern __sum16 nf_ip6_checksum(struct sk_buff *skb, unsigned int hook,
@@ -81,4 +83,6 @@ static inline int ipv6_netfilter_init(void) { return 0; }
 static inline void ipv6_netfilter_fini(void) { return; }
 #endif /* CONFIG_NETFILTER */
 
+#endif /* __KERNEL__ */
+
 #endif /*__LINUX_IP6_NETFILTER_H*/

