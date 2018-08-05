From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/21] netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf
Date: Sun,  5 Aug 2018 23:21:26 +0200
Message-ID: <20180805212141.3033-7-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

Add basic module functions into nft_osf.[ch] in order to implement OSF
module in nf_tables.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |   7 ++
 net/netfilter/Kconfig                    |   7 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_osf.c                  | 106 +++++++++++++++++++++++++++++++
 4 files changed, 121 insertions(+)
 create mode 100644 net/netfilter/nft_osf.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index f466860bcf75..382c32d630e9 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1463,6 +1463,13 @@ enum nft_flowtable_hook_attributes {
 };
 #define NFTA_FLOWTABLE_HOOK_MAX	(__NFTA_FLOWTABLE_HOOK_MAX - 1)
 
+enum nft_osf_attributes {
+	NFTA_OSF_UNSPEC,
+	NFTA_OSF_DREG,
+	__NFTA_OSF_MAX,
+};
+#define NFTA_OSF_MAX (__NFTA_OSF_MAX - 1)
+
 /**
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 85333431e524..16fdfb75efb5 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -627,6 +627,13 @@ config NFT_SOCKET
 	  This option allows matching for the presence or absence of a
 	  corresponding socket and its attributes.
 
+config NFT_OSF
+	tristate "Netfilter nf_tables passive OS fingerprint support"
+	depends on NETFILTER_ADVANCED
+	select NETFILTER_NETLINK_OSF
+	help
+	  This option allows matching packets from an specific OS.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index e684f9b8a9c3..5cbbf6978b55 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_NFT_FIB)		+= nft_fib.o
 obj-$(CONFIG_NFT_FIB_INET)	+= nft_fib_inet.o
 obj-$(CONFIG_NFT_FIB_NETDEV)	+= nft_fib_netdev.o
 obj-$(CONFIG_NFT_SOCKET)	+= nft_socket.o
+obj-$(CONFIG_NFT_OSF)		+= nft_osf.o
 
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
new file mode 100644
index 000000000000..bdacc4cffba4
--- /dev/null
+++ b/net/netfilter/nft_osf.c
@@ -0,0 +1,106 @@
+#include <net/ip.h>
+#include <net/tcp.h>
+
+#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_osf.h>
+
+#define OSF_GENRE_SIZE		32
+
+struct nft_osf {
+	enum nft_registers	dreg:8;
+};
+
+static const struct nla_policy nft_osf_policy[NFTA_OSF_MAX + 1] = {
+	[NFTA_OSF_DREG]		= { .type = NLA_U32 },
+};
+
+static void nft_osf_eval(const struct nft_expr *expr, struct nft_regs *regs,
+			 const struct nft_pktinfo *pkt)
+{
+	struct nft_osf *priv = nft_expr_priv(expr);
+	u32 *dest = &regs->data[priv->dreg];
+	struct sk_buff *skb = pkt->skb;
+	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
+	const char *os_name;
+
+	tcp = skb_header_pointer(skb, ip_hdrlen(skb),
+				 sizeof(struct tcphdr), &_tcph);
+	if (!tcp) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+	if (!tcp->syn) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	os_name = nf_osf_find(skb, nf_osf_fingers);
+	if (!os_name)
+		strncpy((char *)dest, "unknown", IFNAMSIZ);
+	else
+		strncpy((char *)dest, os_name, IFNAMSIZ);
+}
+
+static int nft_osf_init(const struct nft_ctx *ctx,
+			const struct nft_expr *expr,
+			const struct nlattr * const tb[])
+{
+	struct nft_osf *priv = nft_expr_priv(expr);
+	int err;
+
+	priv->dreg = nft_parse_register(tb[NFTA_OSF_DREG]);
+	err = nft_validate_register_store(ctx, priv->dreg, NULL,
+					  NFTA_DATA_VALUE, OSF_GENRE_SIZE);
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+
+static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_osf *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_OSF_DREG, priv->dreg))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static struct nft_expr_type nft_osf_type;
+static const struct nft_expr_ops nft_osf_op = {
+	.eval		= nft_osf_eval,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_osf)),
+	.init		= nft_osf_init,
+	.dump		= nft_osf_dump,
+	.type		= &nft_osf_type,
+};
+
+static struct nft_expr_type nft_osf_type __read_mostly = {
+	.ops		= &nft_osf_op,
+	.name		= "osf",
+	.owner		= THIS_MODULE,
+	.policy		= nft_osf_policy,
+	.maxattr	= NFTA_OSF_MAX,
+};
+
+static int __init nft_osf_module_init(void)
+{
+	return nft_register_expr(&nft_osf_type);
+}
+
+static void __exit nft_osf_module_exit(void)
+{
+	return nft_unregister_expr(&nft_osf_type);
+}
+
+module_init(nft_osf_module_init);
+module_exit(nft_osf_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
+MODULE_ALIAS_NFT_EXPR("osf");
-- 
2.11.0
