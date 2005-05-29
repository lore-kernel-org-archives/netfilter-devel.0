From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [2/3] OSF: Kernel connector support.
Date: Mon, 30 May 2005 00:22:25 +0400
Message-ID: <20050530002225.1c75a512@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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

Kernel connector was commited into 2.6.12-rc4-mm tree.
Use it's extended notification feature.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

--- orig/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
+++ mod/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c
@@ -92,6 +92,45 @@
 	.me = THIS_MODULE 
 };
 
+
+#ifdef CONFIG_CONNECTOR
+#include <linux/connector.h>
+
+/*
+ * They should live in connector.h.
+ */
+#define CN_IDX_OSF		0x0001
+#define CN_VAL_OSF		0x0000
+
+static char osf_finger_buf[sizeof(struct ipt_osf_nlmsg) + sizeof(struct cn_msg)];
+static struct cb_id osf_id = {CN_IDX_OSF, CN_VAL_OSF};
+static u32 osf_seq;
+
+static void ipt_osf_send_connector(struct osf_finger *f, const struct sk_buff *sk)
+{
+	struct cn_msg *m;
+	struct ipt_osf_nlmsg *data;
+	
+	m = (struct cn_msg *)osf_finger_buf;
+	data = (struct ipt_osf_nlmsg *)(m+1);
+
+	memcpy(&m->id, &osf_id, sizeof(m->id));
+	m->seq = osf_seq++;
+	m->ack = 0;
+	m->len = sizeof(*f);
+	
+	memcpy(&data->f, f, sizeof(struct osf_finger));
+	memcpy(&data->ip, sk->nh.iph, sizeof(struct iphdr));
+	memcpy(&data->tcp, (struct tcphdr *)((u_int32_t *)sk->nh.iph + sk->nh.iph->ihl), sizeof(struct tcphdr));
+
+	cn_netlink_send(m, m->id.idx, GFP_ATOMIC);
+}
+#else
+static void ipt_osf_send_connector(struct osf_finger *f, const struct sk_buff *sk)
+{
+}
+#endif
+
 static void ipt_osf_nlsend(struct osf_finger *f, const struct sk_buff *sk)
 {
 	unsigned int size;
@@ -99,6 +138,9 @@
 	struct ipt_osf_nlmsg *data;
 	struct nlmsghdr *nlh;
 
+	if (!nts)
+		return;
+
 	size = NLMSG_SPACE(sizeof(struct ipt_osf_nlmsg));
 
 	skb = alloc_skb(size, GFP_ATOMIC);
@@ -346,13 +388,18 @@
 					ipt_osf_nlsend(f, skb);
 					spin_unlock_bh(&ipt_osf_netlink_lock);
 				}
+				if (info->flags & IPT_OSF_CONNECTOR) {
+					spin_lock_bh(&ipt_osf_netlink_lock);
+					ipt_osf_send_connector(f, skb);
+					spin_unlock_bh(&ipt_osf_netlink_lock);
+				}
 				if ((info->flags & IPT_OSF_LOG) && 
 					info->loglevel == IPT_OSF_LOGLEVEL_FIRST)
 					break;
 			}
 		}
 	}
-	if (!fcount && (info->flags & (IPT_OSF_LOG | IPT_OSF_NETLINK))) {
+	if (!fcount && (info->flags & (IPT_OSF_LOG | IPT_OSF_NETLINK | IPT_OSF_CONNECTOR))) {
 		unsigned char opt[4 * 15 - sizeof(struct tcphdr)];
 		unsigned int i, optsize;
 		struct osf_finger fg;
@@ -383,7 +430,7 @@
 				NIPQUAD(ip->saddr), ntohs(tcp->source),
 				NIPQUAD(ip->daddr), ntohs(tcp->dest));
 		
-		if (info->flags & IPT_OSF_NETLINK) {
+		if (info->flags & (IPT_OSF_NETLINK | IPT_OSF_CONNECTOR)) {
 			fg.wss.val 	= window;
 			fg.ttl		= ip->ttl;
 			fg.df		= df;
@@ -391,7 +438,10 @@
 			strncpy(fg.genre, "Unknown", MAXGENRELEN);
 
 			spin_lock_bh(&ipt_osf_netlink_lock);
-			ipt_osf_nlsend(&fg, skb);
+			if (info->flags & IPT_OSF_NETLINK)
+				ipt_osf_nlsend(&fg, skb);
+			if (info->flags & IPT_OSF_CONNECTOR)
+				ipt_osf_send_connector(&fg, skb);
 			spin_unlock_bh(&ipt_osf_netlink_lock);
 		}
 	}
@@ -750,7 +800,7 @@
 	return count;
 }
 
-static int __init osf_init(void)
+static int __devinit osf_init(void)
 {
 	int err;
 	struct proc_dir_entry *p;
@@ -777,15 +827,12 @@
 	nts = netlink_kernel_create(NETLINK_NFLOG, NULL);
 	if (!nts) {
 		log("netlink_kernel_create() failed\n");
-		remove_proc_entry("sys/net/ipv4/osf", NULL);
-		ipt_unregister_match(&osf_match);
-		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static void __exit osf_fini(void)
+static void __devexit osf_fini(void)
 {
 	struct osf_finger *f, *n;
 	


--- orig/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h
+++ mod/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h
@@ -29,6 +29,7 @@
 #define	IPT_OSF_SMART		2
 #define IPT_OSF_LOG		4
 #define IPT_OSF_NETLINK		8
+#define IPT_OSF_CONNECTOR	16
 
 #define IPT_OSF_LOGLEVEL_ALL	0
 #define IPT_OSF_LOGLEVEL_FIRST	1




	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
