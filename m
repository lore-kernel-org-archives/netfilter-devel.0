From: wenxu@ucloud.cn
Subject: [PATCH] netfilter: x_tables: add xt_tunnel match
Date: Fri, 21 Dec 2018 18:12:24 +0800
Message-ID: <1545387144-5796-1-git-send-email-wenxu@ucloud.cn>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch allows us to match on the tunnel metadata that is available
of the packet. We can use this to validate if the packet comes from/goes
to tunnel and the corresponding tunnel ID in the iptables.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 include/uapi/linux/netfilter/xt_tunnel.h | 13 +++++++
 net/netfilter/Kconfig                    | 10 ++++++
 net/netfilter/Makefile                   |  1 +
 net/netfilter/xt_tunnel.c                | 58 ++++++++++++++++++++++++++++++++
 4 files changed, 82 insertions(+)
 create mode 100644 include/uapi/linux/netfilter/xt_tunnel.h
 create mode 100644 net/netfilter/xt_tunnel.c

diff --git a/include/uapi/linux/netfilter/xt_tunnel.h b/include/uapi/linux/netfilter/xt_tunnel.h
new file mode 100644
index 0000000..2c46a65
--- /dev/null
+++ b/include/uapi/linux/netfilter/xt_tunnel.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _XT_TUNNEL_H
+#define _XT_TUNNEL_H
+
+#include <linux/types.h>
+
+struct xt_tunnel_mtinfo {
+	__u32 key, mask;
+	__u8 invert;
+};
+
+#endif /*_XT_TUNNEL_H*/
+
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index beb3a69..ee52a75 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1586,6 +1586,16 @@ config NETFILTER_XT_MATCH_U32
 
 	  Details and examples are in the kernel module source.
 
+config NETFILTER_XT_MATCH_TUNNEL
+	tristate '"tunnel" match support'
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds a "tunnel" match, which allows you to match based on
+	  the packet tunnel_id
+
+	  If you want to compile it as a module, say M here.
+	  If unsure, say N.
+
 endif # NETFILTER_XTABLES
 
 endmenu
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 1ae65a3..965541c 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -198,6 +198,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) += xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) += xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TIME) += xt_time.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_U32) += xt_u32.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_TUNNEL) += xt_tunnel.o
 
 # ipset
 obj-$(CONFIG_IP_SET) += ipset/
diff --git a/net/netfilter/xt_tunnel.c b/net/netfilter/xt_tunnel.c
new file mode 100644
index 0000000..caf1f44
--- /dev/null
+++ b/net/netfilter/xt_tunnel.c
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/dst_metadata.h>
+#include <net/ip_tunnels.h>
+
+#include <linux/netfilter/xt_tunnel.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("wenxu <wenxu@ucloud.cn>");
+MODULE_DESCRIPTION("Xtables: packet tunnel match");
+MODULE_ALIAS("ipt_tunnel");
+MODULE_ALIAS("ip6t_tunnel");
+
+static bool
+tunnel_mt(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct xt_tunnel_mtinfo *info = par->matchinfo;
+	struct ip_tunnel_info *tun_info;
+	u32 key;
+
+	tun_info = skb_tunnel_info(skb);
+	if (tun_info) {
+		key = ntohl(tunnel_id_to_key32(tun_info->key.tun_id));
+		return ((key & info->mask) == info->key) ^ info->invert;
+	}
+
+	return !info->invert;
+}
+
+static struct xt_match tunnel_mt_reg __read_mostly = {
+	.name           = "tunnel",
+	.revision       = 0,
+	.family         = NFPROTO_UNSPEC,
+	.match          = tunnel_mt,
+	.matchsize      = sizeof(struct xt_tunnel_mtinfo),
+	.me             = THIS_MODULE,
+};
+
+static int __init tunnel_mt_init(void)
+{
+	int ret;
+
+	ret = xt_register_match(&tunnel_mt_reg);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void __exit tunnel_mt_exit(void)
+{
+	xt_unregister_match(&tunnel_mt_reg);
+}
+
+module_init(tunnel_mt_init);
+module_exit(tunnel_mt_exit);
-- 
1.8.3.1
