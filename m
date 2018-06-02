From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/20] netfilter: nf_tables: add support for native socket matching
Date: Sat,  2 Jun 2018 02:22:52 +0200
Message-ID: <20180602002259.4024-14-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

Now it can only match the transparent flag of an ip/ipv6 socket.

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  25 ++++++
 net/netfilter/Kconfig                    |   9 ++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_socket.c               | 143 +++++++++++++++++++++++++++++++
 4 files changed, 178 insertions(+)
 create mode 100644 net/netfilter/nft_socket.c

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 9c71f024f9cc..3d46c82a5ebd 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -905,6 +905,31 @@ enum nft_rt_attributes {
 #define NFTA_RT_MAX		(__NFTA_RT_MAX - 1)
 
 /**
+ * enum nft_socket_attributes - nf_tables socket expression netlink attributes
+ *
+ * @NFTA_SOCKET_KEY: socket key to match
+ * @NFTA_SOCKET_DREG: destination register
+ */
+enum nft_socket_attributes {
+	NFTA_SOCKET_UNSPEC,
+	NFTA_SOCKET_KEY,
+	NFTA_SOCKET_DREG,
+	__NFTA_SOCKET_MAX
+};
+#define NFTA_SOCKET_MAX		(__NFTA_SOCKET_MAX - 1)
+
+/*
+ * enum nft_socket_keys - nf_tables socket expression keys
+ *
+ * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option_
+ */
+enum nft_socket_keys {
+	NFT_SOCKET_TRANSPARENT,
+	__NFT_SOCKET_MAX
+};
+#define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
+
+/**
  * enum nft_ct_keys - nf_tables ct expression keys
  *
  * @NFT_CT_STATE: conntrack state (bitmask of enum ip_conntrack_info)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3ec8886850b2..276e1e32f44e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -613,6 +613,15 @@ config NFT_FIB_INET
 	  The lookup will be delegated to the IPv4 or IPv6 FIB depending
 	  on the protocol of the packet.
 
+config NFT_SOCKET
+	tristate "Netfilter nf_tables socket match support"
+	depends on IPV6 || IPV6=n
+	select NF_SOCKET_IPV4
+	select NF_SOCKET_IPV6 if IPV6
+	help
+	  This option allows matching for the presence or absence of a
+	  corresponding socket and its attributes.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9b3434360d49..eec169555731 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_NFT_FIB)		+= nft_fib.o
 obj-$(CONFIG_NFT_FIB_INET)	+= nft_fib_inet.o
 obj-$(CONFIG_NFT_FIB_NETDEV)	+= nft_fib_netdev.o
 obj-$(CONFIG_NF_OSF)		+= nf_osf.o
+obj-$(CONFIG_NFT_SOCKET)	+= nft_socket.o
 
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
new file mode 100644
index 000000000000..d86337068ecb
--- /dev/null
+++ b/net/netfilter/nft_socket.c
@@ -0,0 +1,143 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/module.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_socket.h>
+#include <net/inet_sock.h>
+
+struct nft_socket {
+	enum nft_socket_keys		key:8;
+	union {
+		enum nft_registers	dreg:8;
+	};
+};
+
+static void nft_socket_eval(const struct nft_expr *expr,
+			    struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+	struct sk_buff *skb = pkt->skb;
+	struct sock *sk = skb->sk;
+	u32 *dest = &regs->data[priv->dreg];
+
+	if (!sk)
+		switch(nft_pf(pkt)) {
+		case NFPROTO_IPV4:
+			sk = nf_sk_lookup_slow_v4(nft_net(pkt), skb, nft_in(pkt));
+			break;
+#if IS_ENABLED(CONFIG_NF_SOCKET_IPV6)
+		case NFPROTO_IPV6:
+			sk = nf_sk_lookup_slow_v6(nft_net(pkt), skb, nft_in(pkt));
+			break;
+#endif
+		default:
+			WARN_ON_ONCE(1);
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+
+	if(!sk) {
+		nft_reg_store8(dest, 0);
+		return;
+	}
+
+	/* So that subsequent socket matching not to require other lookups. */
+	skb->sk = sk;
+
+	switch(priv->key) {
+	case NFT_SOCKET_TRANSPARENT:
+		nft_reg_store8(dest, nf_sk_is_transparent(sk));
+		break;
+	default:
+		WARN_ON(1);
+		regs->verdict.code = NFT_BREAK;
+	}
+}
+
+static const struct nla_policy nft_socket_policy[NFTA_SOCKET_MAX + 1] = {
+	[NFTA_SOCKET_KEY]		= { .type = NLA_U32 },
+	[NFTA_SOCKET_DREG]		= { .type = NLA_U32 },
+};
+
+static int nft_socket_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_socket *priv = nft_expr_priv(expr);
+	unsigned int len;
+
+	if (!tb[NFTA_SOCKET_DREG] || !tb[NFTA_SOCKET_KEY])
+		return -EINVAL;
+
+	switch(ctx->family) {
+	case NFPROTO_IPV4:
+#if IS_ENABLED(CONFIG_NF_SOCKET_IPV6)
+	case NFPROTO_IPV6:
+#endif
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->key = ntohl(nla_get_u32(tb[NFTA_SOCKET_KEY]));
+	switch(priv->key) {
+	case NFT_SOCKET_TRANSPARENT:
+		len = sizeof(u8);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->dreg = nft_parse_register(tb[NFTA_SOCKET_DREG]);
+	return nft_validate_register_store(ctx, priv->dreg, NULL,
+					   NFT_DATA_VALUE, len);
+}
+
+static int nft_socket_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+
+	if (nla_put_u32(skb, NFTA_SOCKET_KEY, htonl(priv->key)))
+		return -1;
+	if (nft_dump_register(skb, NFTA_SOCKET_DREG, priv->dreg))
+		return -1;
+	return 0;
+}
+
+static struct nft_expr_type nft_socket_type;
+static const struct nft_expr_ops nft_socket_ops = {
+	.type		= &nft_socket_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_socket)),
+	.eval		= nft_socket_eval,
+	.init		= nft_socket_init,
+	.dump		= nft_socket_dump,
+};
+
+static struct nft_expr_type nft_socket_type __read_mostly = {
+	.name		= "socket",
+	.ops		= &nft_socket_ops,
+	.policy		= nft_socket_policy,
+	.maxattr	= NFTA_SOCKET_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_socket_module_init(void)
+{
+	return nft_register_expr(&nft_socket_type);
+}
+
+static void __exit nft_socket_module_exit(void)
+{
+	nft_unregister_expr(&nft_socket_type);
+}
+
+module_init(nft_socket_module_init);
+module_exit(nft_socket_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Máté Eckl");
+MODULE_DESCRIPTION("nf_tables socket match module");
-- 
2.11.0
