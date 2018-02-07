From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Date: Wed,  7 Feb 2018 02:37:13 +0100
Message-ID: <20180207013713.2432-5-pablo@netfilter.org>
References: <20180207013713.2432-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180207013713.2432-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch adds the netlink description for nf_tables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h             |   2 +
 include/uapi/linux/netfilter/nf_tables_desc.h |  57 ++++
 net/netfilter/Makefile                        |   7 +-
 net/netfilter/nf_tables_api.c                 |   2 +
 net/netfilter/nf_tables_desc.c                | 471 ++++++++++++++++++++++++++
 5 files changed, 536 insertions(+), 3 deletions(-)
 create mode 100644 include/uapi/linux/netfilter/nf_tables_desc.h
 create mode 100644 net/netfilter/nf_tables_desc.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 663b015dace5..91b52b365f7e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1345,4 +1345,6 @@ struct nft_trans_flowtable {
 #define nft_trans_flowtable(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->flowtable)
 
+extern const struct nfnl_desc_subsys nft_nldesc;
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/uapi/linux/netfilter/nf_tables_desc.h b/include/uapi/linux/netfilter/nf_tables_desc.h
new file mode 100644
index 000000000000..e596ad9f78c3
--- /dev/null
+++ b/include/uapi/linux/netfilter/nf_tables_desc.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _LINUX_NF_TABLES_DESC_H
+#define _LINUX_NF_TABLES_DESC_H
+
+enum nft_nldesc_obj {
+	NFT_UNSPEC,
+	NFT_TABLE,
+	NFT_CHAIN,
+	NFT_CHAIN_COUNTER,
+	NFT_CHAIN_HOOK,
+	NFT_CHAIN_DEV,
+	NFT_RULE,
+	NFT_RULE_COMPAT,
+	NFT_SET,
+	NFT_SET_DESC,
+	NFT_SET_ELEM,
+	NFT_OBJ,
+	NFT_OBJ_COUNTER,
+	NFT_OBJ_QUOTA,
+	NFT_OBJ_LIMIT,
+	NFT_FLOWTABLE,
+	NFT_DATA,
+	NFT_EXPR,
+	NFT_EXPR_COUNTER,
+	NFT_EXPR_IMMEDIATE,
+	NFT_EXPR_BITWISE,
+	NFT_EXPR_BYTEORDER,
+	NFT_EXPR_CMP,
+	NFT_EXPR_RANGE,
+	NFT_EXPR_LOOKUP,
+	NFT_EXPR_DYNSET,
+	NFT_EXPR_PAYLOAD,
+	NFT_EXPR_EXTHDR,
+	NFT_EXPR_META,
+	NFT_EXPR_HASH,
+	NFT_EXPR_RT,
+	NFT_EXPR_CT,
+	NFT_EXPR_FLOW,
+	NFT_EXPR_LIMIT,
+	NFT_EXPR_LOG,
+	NFT_EXPR_QUEUE,
+	NFT_EXPR_QUOTA,
+	NFT_EXPR_REJECT,
+	NFT_EXPR_NAT,
+	NFT_EXPR_MASQ,
+	NFT_EXPR_REDIR,
+	NFT_EXPR_DUP,
+	NFT_EXPR_FWD,
+	NFT_EXPR_OBJREF,
+	NFT_EXPR_FIB,
+	NFT_EXPR_CT_HELPER,
+	NFT_EXPR_NUMGEN,
+	__NFT_MAX,
+};
+#define NFT_MAX	(__NFT_MAX - 1)
+
+#endif
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5d9b8b959e58..38e048ea7e42 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -73,9 +73,10 @@ obj-$(CONFIG_NETFILTER_CONNCOUNT) += nf_conncount.o
 obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 
 # nf_tables
-nf_tables-objs := nf_tables_core.o nf_tables_api.o nf_tables_trace.o \
-		  nft_immediate.o nft_cmp.o nft_range.o nft_bitwise.o \
-		  nft_byteorder.o nft_payload.o nft_lookup.o nft_dynset.o
+nf_tables-objs := nf_tables_core.o nf_tables_api.o nf_tables_desc.o \
+		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
+		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
+		  nft_dynset.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NF_TABLES_INET)	+= nf_tables_inet.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0791813a1e7d..cb500aeaa729 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6601,6 +6601,7 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err3;
 
+	nfnl_desc_register_subsys(&nft_nldesc);
 	register_netdevice_notifier(&nf_tables_flowtable_notifier);
 
 	return register_pernet_subsys(&nf_tables_net_ops);
@@ -6617,6 +6618,7 @@ static void __exit nf_tables_module_exit(void)
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	unregister_netdevice_notifier(&nf_tables_flowtable_notifier);
+	nfnl_desc_unregister_subsys(&nft_nldesc);
 	rcu_barrier();
 	nf_tables_core_module_exit();
 	kfree(info);
diff --git a/net/netfilter/nf_tables_desc.c b/net/netfilter/nf_tables_desc.c
new file mode 100644
index 000000000000..2acaff69edb0
--- /dev/null
+++ b/net/netfilter/nf_tables_desc.c
@@ -0,0 +1,471 @@
+#include <net/nldesc.h>
+#include <net/netlink.h>
+#include <linux/if.h>
+#include <uapi/linux/netfilter.h>
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_tables_desc.h>
+#include <linux/netfilter/nf_log.h>
+#include <uapi/linux/netfilter/nf_nat.h>
+#include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
+
+static const struct nl_desc_attr nft_nldesc_table_attrs[NFTA_TABLE_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_TABLE_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_TABLE_FLAGS, NFT_TABLE_F_DORMANT),
+	NLDESC_ATTR_U32(NFTA_TABLE_USE),
+	NLDESC_ATTR_U64(NFTA_TABLE_HANDLE),
+	NLDESC_ATTR_PAD(NFTA_TABLE_PAD),
+};
+
+static const struct nl_desc_attr nft_nldesc_chain_dev_attrs[NFTA_DEVICE_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_DEVICE_NAME, IFNAMSIZ),
+};
+
+static const struct nl_desc_obj nft_nldesc_chain_dev[] = {
+	NLDESC_OBJ(NFT_CHAIN_DEV, nft_nldesc_chain_dev_attrs, NFTA_DEVICE_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_chain_hook_attrs[NFTA_HOOK_MAX + 1] = {
+	NLDESC_ATTR_U32(NFTA_HOOK_HOOKNUM),
+	NLDESC_ATTR_U32(NFTA_HOOK_PRIORITY),
+	NLDESC_ATTR_NESTED(NFTA_HOOK_DEV, nft_nldesc_chain_dev),
+};
+
+static const struct nl_desc_obj nft_nldesc_chain_hook[] = {
+	NLDESC_OBJ(NFT_CHAIN_HOOK, nft_nldesc_chain_hook_attrs, NFTA_HOOK_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_counter_attrs[NFTA_COUNTER_MAX + 1] = {
+	NLDESC_ATTR_U64(NFTA_COUNTER_BYTES),
+	NLDESC_ATTR_U64(NFTA_COUNTER_PACKETS),
+	NLDESC_ATTR_PAD(NFTA_COUNTER_PAD),
+};
+
+static const struct nl_desc_obj nft_nldesc_counters[] = {
+	NLDESC_OBJ(NFT_CHAIN_COUNTER, nft_nldesc_counter_attrs, NFTA_COUNTER_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_chain_attrs[NFTA_CHAIN_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_CHAIN_TABLE, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U64(NFTA_CHAIN_HANDLE),
+	NLDESC_ATTR_STRING(NFTA_CHAIN_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_NESTED(NFTA_CHAIN_HOOK, nft_nldesc_chain_hook),
+	NLDESC_ATTR_U32_MAX(NFTA_CHAIN_POLICY, NF_ACCEPT),
+	NLDESC_ATTR_U32(NFTA_CHAIN_USE),
+	NLDESC_ATTR_NUL_STRING(NFTA_CHAIN_TYPE),
+	NLDESC_ATTR_NESTED(NFTA_CHAIN_COUNTERS, nft_nldesc_counters),
+	NLDESC_ATTR_PAD(NFTA_CHAIN_PAD),
+};
+
+static const struct nl_desc_attr nft_nldesc_data_attrs[NFTA_DATA_MAX + 1] = {
+	NLDESC_ATTR_U32(NFTA_SET_DESC_SIZE),
+};
+
+static const struct nl_desc_obj nft_nldesc_data[] = {
+	NLDESC_OBJ(NFT_DATA, nft_nldesc_data_attrs, NFTA_DATA_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_immediate_attrs[NFTA_IMMEDIATE_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_IMMEDIATE_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_NESTED(NFTA_IMMEDIATE_DATA, nft_nldesc_data),
+};
+
+static const struct nl_desc_attr nft_nldesc_bitwise_attrs[NFTA_BITWISE_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_BITWISE_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_BITWISE_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_BITWISE_LEN, U8_MAX),
+	NLDESC_ATTR_NESTED(NFTA_BITWISE_MASK, nft_nldesc_data),
+	NLDESC_ATTR_NESTED(NFTA_BITWISE_XOR, nft_nldesc_data),
+};
+
+static const struct nl_desc_attr nft_nldesc_byteorder_attrs[NFTA_BYTEORDER_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_BYTEORDER_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_BYTEORDER_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_BYTEORDER_OP, NFT_BYTEORDER_HTON),
+	NLDESC_ATTR_U32_MAX(NFTA_BYTEORDER_LEN, U8_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_BYTEORDER_SIZE, U8_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_cmp_attrs[NFTA_CMP_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_CMP_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_CMP_OP, NFT_CMP_GTE),
+	NLDESC_ATTR_NESTED(NFTA_CMP_DATA, nft_nldesc_data),
+};
+
+static const struct nl_desc_attr nft_nldesc_range_attrs[NFTA_RANGE_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_RANGE_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_RANGE_OP, NFT_RANGE_NEQ),
+	NLDESC_ATTR_NESTED(NFTA_RANGE_FROM_DATA, nft_nldesc_data),
+	NLDESC_ATTR_NESTED(NFTA_RANGE_TO_DATA, nft_nldesc_data),
+};
+
+static const struct nl_desc_attr nft_nldesc_lookup_attrs[NFTA_LOOKUP_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_LOOKUP_SET, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_LOOKUP_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_LOOKUP_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32(NFTA_LOOKUP_SET_ID),
+	NLDESC_ATTR_U32_MAX(NFTA_LOOKUP_FLAGS, NFT_LOOKUP_F_INV),
+};
+
+static const struct nl_desc_obj nft_nldesc_expressions[];
+
+static const struct nl_desc_attr nft_nldesc_dynset_attrs[NFTA_DYNSET_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_DYNSET_SET_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32(NFTA_DYNSET_SET_ID),
+	NLDESC_ATTR_U32_MAX(NFTA_DYNSET_OP, NFT_DYNSET_OP_UPDATE),
+	NLDESC_ATTR_U32(NFTA_DYNSET_SREG_KEY),
+	NLDESC_ATTR_U32(NFTA_DYNSET_SREG_DATA),
+	NLDESC_ATTR_U64(NFTA_DYNSET_TIMEOUT),
+	NLDESC_ATTR_NESTED(NFTA_DYNSET_EXPR, nft_nldesc_expressions),
+	NLDESC_ATTR_PAD(NFTA_DYNSET_PAD),
+	NLDESC_ATTR_U32_MAX(NFTA_DYNSET_FLAGS, NFT_DYNSET_F_INV),
+};
+
+static const struct nl_desc_attr nft_nldesc_payload_attrs[NFTA_PAYLOAD_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_BASE, NFT_PAYLOAD_TRANSPORT_HEADER),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_OFFSET, U16_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_LEN, U8_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_CSUM_TYPE, NFT_PAYLOAD_CSUM_INET),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_CSUM_OFFSET, U16_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_PAYLOAD_CSUM_FLAGS, NFT_PAYLOAD_L4CSUM_PSEUDOHDR),
+};
+
+static const struct nl_desc_attr nft_nldesc_exthdr_attrs[NFTA_EXTHDR_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_EXTHDR_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U8(NFTA_EXTHDR_TYPE),
+	NLDESC_ATTR_U32_MAX(NFTA_EXTHDR_OFFSET, U8_MAX),
+	NLDESC_ATTR_U32(NFTA_EXTHDR_LEN),
+	NLDESC_ATTR_U32_MAX(NFTA_EXTHDR_FLAGS, NFT_EXTHDR_F_PRESENT),
+	NLDESC_ATTR_U32_MAX(NFTA_EXTHDR_OP, NFT_EXTHDR_OP_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_EXTHDR_SREG, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_meta_attrs[NFTA_META_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_META_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_META_KEY, NFT_META_SECPATH),
+	NLDESC_ATTR_U32_MAX(NFTA_META_SREG, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_hash_attrs[NFTA_HASH_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_HASH_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_HASH_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_HASH_LEN, U8_MAX),
+	NLDESC_ATTR_U32(NFTA_HASH_MODULUS),
+	NLDESC_ATTR_U32(NFTA_HASH_SEED),
+	NLDESC_ATTR_U32(NFTA_HASH_OFFSET),
+	NLDESC_ATTR_U32_MAX(NFTA_HASH_TYPE, NFT_HASH_SYM),
+};
+
+static const struct nl_desc_attr nft_nldesc_rt_attrs[NFTA_RT_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_RT_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_RT_KEY, NFT_RT_TCPMSS),
+};
+
+static const struct nl_desc_attr nft_nldesc_ct_attrs[NFTA_CT_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_CT_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_CT_KEY, NFT_CT_EVENTMASK),
+	NLDESC_ATTR_U32_MAX(NFTA_CT_DIRECTION, IP_CT_DIR_REPLY),
+	NLDESC_ATTR_U32_MAX(NFTA_CT_SREG, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_flow_attrs[NFTA_FLOW_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_FLOW_TABLE_NAME, NFT_NAME_MAXLEN - 1),
+};
+
+static const struct nl_desc_attr nft_nldesc_limit_attrs[NFTA_LIMIT_MAX + 1] = {
+	NLDESC_ATTR_U64(NFTA_LIMIT_RATE),
+	NLDESC_ATTR_U64(NFTA_LIMIT_UNIT),
+	NLDESC_ATTR_U32(NFTA_LIMIT_BURST),
+	NLDESC_ATTR_U32_MAX(NFTA_LIMIT_TYPE, NFT_LIMIT_PKT_BYTES),
+	NLDESC_ATTR_U32_MAX(NFTA_LIMIT_FLAGS, NFT_LIMIT_F_INV),
+	NLDESC_ATTR_PAD(NFTA_LIMIT_PAD),
+};
+
+static const struct nl_desc_attr nft_nldesc_log_attrs[NFTA_LOG_MAX + 1] = {
+	NLDESC_ATTR_U16(NFTA_LOG_GROUP),
+	NLDESC_ATTR_STRING(NFTA_LOG_PREFIX, NF_LOG_PREFIXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_LOG_SNAPLEN, U16_MAX),
+	NLDESC_ATTR_U16(NFTA_LOG_QTHRESHOLD),
+	NLDESC_ATTR_U32_MAX(NFTA_LOG_LEVEL, LOGLEVEL_DEBUG),
+	NLDESC_ATTR_U32_MAX(NFTA_LOG_FLAGS, NF_LOG_MASK),
+};
+
+static const struct nl_desc_attr nft_nldesc_queue_attrs[NFTA_QUEUE_MAX + 1] = {
+	NLDESC_ATTR_U16(NFTA_QUEUE_NUM),
+	NLDESC_ATTR_U16(NFTA_QUEUE_TOTAL),
+	NLDESC_ATTR_U16(NFTA_QUEUE_FLAGS),
+	NLDESC_ATTR_U32_MAX(NFTA_QUEUE_SREG_QNUM, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_quota_attrs[NFTA_QUOTA_MAX + 1] = {
+	NLDESC_ATTR_U64(NFTA_QUOTA_BYTES),
+	NLDESC_ATTR_U32_MAX(NFTA_QUOTA_FLAGS, NFT_QUOTA_F_DEPLETED),
+	NLDESC_ATTR_U64(NFTA_QUOTA_CONSUMED),
+	NLDESC_ATTR_PAD(NFTA_QUOTA_PAD),
+};
+
+static const struct nl_desc_attr nft_nldesc_reject_attrs[NFTA_REJECT_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_REJECT_TYPE, NFT_REJECT_ICMPX_UNREACH),
+	NLDESC_ATTR_U8(NFTA_REJECT_ICMP_CODE),
+};
+
+static const struct nl_desc_attr nft_nldesc_nat_attrs[NFTA_NAT_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_TYPE, NFT_NAT_DNAT),
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_FAMILY, NFPROTO_NUMPROTO),
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_REG_ADDR_MIN, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_REG_ADDR_MAX, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_REG_PROTO_MIN, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_REG_PROTO_MAX, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_NAT_FLAGS, NF_NAT_RANGE_MASK),
+};
+
+static const struct nl_desc_attr nft_nldesc_masq_attrs[NFTA_MASQ_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_MASQ_FLAGS, NF_NAT_RANGE_MASK),
+	NLDESC_ATTR_U32_MAX(NFTA_MASQ_REG_PROTO_MIN, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_MASQ_REG_PROTO_MAX, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_redir_attrs[NFTA_REDIR_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_REDIR_REG_PROTO_MIN, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_REDIR_REG_PROTO_MAX, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_REDIR_FLAGS, NF_NAT_RANGE_MASK),
+};
+
+static const struct nl_desc_attr nft_nldesc_dup_attrs[NFTA_DUP_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_DUP_SREG_ADDR, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_DUP_SREG_DEV, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_fwd_attrs[NFTA_FWD_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_FWD_SREG_DEV, NFT_REG_MAX),
+};
+
+static const struct nl_desc_attr nft_nldesc_objref_attrs[NFTA_OBJREF_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_OBJREF_IMM_TYPE, NFT_OBJECT_MAX),
+	NLDESC_ATTR_STRING(NFTA_OBJREF_IMM_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_OBJREF_SET_SREG, NFT_REG_MAX),
+	NLDESC_ATTR_STRING(NFTA_OBJREF_SET_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32(NFTA_OBJREF_SET_ID),
+};
+
+static const struct nl_desc_attr nft_nldesc_fib_attrs[NFTA_FIB_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_FIB_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_FIB_RESULT, NFT_FIB_RESULT_MAX),
+	NLDESC_ATTR_U32_MAX(NFTA_FIB_FLAGS, (NFTA_FIB_F_PRESENT << 1) - 1),
+};
+
+static const struct nl_desc_attr nft_nldesc_ct_helper_attrs[NFTA_CT_HELPER_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_CT_HELPER_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U16(NFTA_CT_HELPER_L3PROTO),
+	NLDESC_ATTR_U8(NFTA_CT_HELPER_L4PROTO),
+};
+
+static const struct nl_desc_attr nft_nldesc_numgen_attrs[NFTA_NG_MAX + 1] = {
+	NLDESC_ATTR_U32_MAX(NFTA_NG_DREG, NFT_REG_MAX),
+	NLDESC_ATTR_U32(NFTA_NG_MODULUS),
+	NLDESC_ATTR_U32_MAX(NFTA_NG_TYPE, NFT_NG_MAX),
+	NLDESC_ATTR_U32(NFTA_NG_OFFSET),
+};
+
+static const struct nl_desc_obj nft_nldesc_expr_data[] = {
+	NLDESC_OBJ(NFT_EXPR_IMMEDIATE, nft_nldesc_immediate_attrs, NFTA_IMMEDIATE_MAX),
+	NLDESC_OBJ(NFT_EXPR_BITWISE, nft_nldesc_bitwise_attrs, NFTA_BITWISE_MAX),
+	NLDESC_OBJ(NFT_EXPR_BYTEORDER, nft_nldesc_byteorder_attrs, NFTA_BYTEORDER_MAX),
+	NLDESC_OBJ(NFT_EXPR_CMP, nft_nldesc_cmp_attrs, NFTA_CMP_MAX),
+	NLDESC_OBJ(NFT_EXPR_RANGE, nft_nldesc_range_attrs, NFTA_RANGE_MAX),
+	NLDESC_OBJ(NFT_EXPR_LOOKUP, nft_nldesc_lookup_attrs, NFTA_LOOKUP_MAX),
+	NLDESC_OBJ(NFT_EXPR_DYNSET, nft_nldesc_dynset_attrs, NFTA_DYNSET_MAX),
+	NLDESC_OBJ(NFT_EXPR_PAYLOAD, nft_nldesc_payload_attrs, NFTA_PAYLOAD_MAX),
+	NLDESC_OBJ(NFT_EXPR_EXTHDR, nft_nldesc_exthdr_attrs, NFTA_EXTHDR_MAX),
+	NLDESC_OBJ(NFT_EXPR_META, nft_nldesc_meta_attrs, NFTA_META_MAX),
+	NLDESC_OBJ(NFT_EXPR_HASH, nft_nldesc_hash_attrs, NFTA_HASH_MAX),
+	NLDESC_OBJ(NFT_EXPR_RT, nft_nldesc_rt_attrs, NFTA_RT_MAX),
+	NLDESC_OBJ(NFT_EXPR_CT, nft_nldesc_ct_attrs, NFTA_CT_MAX),
+	NLDESC_OBJ(NFT_EXPR_FLOW, nft_nldesc_flow_attrs, NFTA_FLOW_MAX),
+	NLDESC_OBJ(NFT_EXPR_LIMIT, nft_nldesc_limit_attrs, NFTA_LIMIT_MAX),
+	NLDESC_OBJ(NFT_EXPR_COUNTER, nft_nldesc_counter_attrs, NFTA_COUNTER_MAX),
+	NLDESC_OBJ(NFT_EXPR_LOG, nft_nldesc_log_attrs, NFTA_LOG_MAX),
+	NLDESC_OBJ(NFT_EXPR_QUEUE, nft_nldesc_queue_attrs, NFTA_QUEUE_MAX),
+	NLDESC_OBJ(NFT_EXPR_QUOTA, nft_nldesc_quota_attrs, NFTA_QUOTA_MAX),
+	NLDESC_OBJ(NFT_EXPR_REJECT, nft_nldesc_reject_attrs, NFTA_REJECT_MAX),
+	NLDESC_OBJ(NFT_EXPR_NAT, nft_nldesc_nat_attrs, NFTA_NAT_MAX),
+	NLDESC_OBJ(NFT_EXPR_MASQ, nft_nldesc_masq_attrs, NFTA_MASQ_MAX),
+	NLDESC_OBJ(NFT_EXPR_REDIR, nft_nldesc_redir_attrs, NFTA_REDIR_MAX),
+	NLDESC_OBJ(NFT_EXPR_DUP, nft_nldesc_dup_attrs, NFTA_DUP_MAX),
+	NLDESC_OBJ(NFT_EXPR_FWD, nft_nldesc_fwd_attrs, NFTA_FWD_MAX),
+	NLDESC_OBJ(NFT_EXPR_OBJREF, nft_nldesc_objref_attrs, NFTA_OBJREF_MAX),
+	NLDESC_OBJ(NFT_EXPR_FIB, nft_nldesc_fib_attrs, NFTA_FIB_MAX),
+	NLDESC_OBJ(NFT_EXPR_CT_HELPER, nft_nldesc_ct_helper_attrs, NFTA_CT_HELPER_MAX),
+	NLDESC_OBJ(NFT_EXPR_NUMGEN, nft_nldesc_numgen_attrs, NFTA_NG_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_expressions_attrs[NFTA_EXPR_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_EXPR_NAME, 0),
+	NLDESC_ATTR_NESTED(NFTA_EXPR_DATA, nft_nldesc_expr_data),
+};
+
+static const struct nl_desc_obj nft_nldesc_expressions[] = {
+	NLDESC_OBJ(NFT_EXPR, nft_nldesc_expressions_attrs, NFTA_EXPR_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_rule_compat_attrs[NFTA_RULE_COMPAT_MAX + 1] = {
+	NLDESC_ATTR_U32(NFTA_RULE_COMPAT_PROTO),
+	NLDESC_ATTR_U32(NFTA_RULE_COMPAT_FLAGS),
+};
+
+static const struct nl_desc_obj nft_nldesc_rule_compat[] = {
+	NLDESC_OBJ(NFT_RULE_COMPAT, nft_nldesc_rule_compat_attrs, NFTA_RULE_COMPAT_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_rule_attrs[NFTA_RULE_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_RULE_TABLE, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_STRING(NFTA_RULE_CHAIN, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U64(NFTA_RULE_HANDLE),
+	NLDESC_ATTR_NESTED(NFTA_RULE_EXPRESSIONS, nft_nldesc_expressions),
+	NLDESC_ATTR_NESTED(NFTA_RULE_COMPAT, nft_nldesc_rule_compat),
+	NLDESC_ATTR_U64(NFTA_RULE_POSITION),
+	NLDESC_ATTR_BINARY(NFTA_RULE_USERDATA, NFT_USERDATA_MAXLEN),
+	NLDESC_ATTR_U32(NFTA_RULE_ID),
+};
+
+static const struct nl_desc_attr nft_nldesc_set_desc_attrs[NFTA_SET_DESC_MAX + 1] = {
+	NLDESC_ATTR_U32(NFTA_SET_DESC_SIZE),
+};
+
+static const struct nl_desc_obj nft_nldesc_set_desc[] = {
+	NLDESC_OBJ(NFT_SET_DESC, nft_nldesc_set_desc_attrs, NFTA_SET_DESC_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_set_attrs[NFTA_SET_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_SET_TABLE, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_STRING(NFTA_SET_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_SET_FLAGS, NFT_SET_OBJECT),
+	NLDESC_ATTR_U32(NFTA_SET_KEY_TYPE),
+	NLDESC_ATTR_U32(NFTA_SET_KEY_LEN),
+	NLDESC_ATTR_U32(NFTA_SET_DATA_TYPE),
+	NLDESC_ATTR_U32(NFTA_SET_DATA_LEN),
+	NLDESC_ATTR_U32_MAX(NFTA_SET_POLICY, NFT_SET_POL_MEMORY),
+	NLDESC_ATTR_NESTED(NFTA_SET_DESC, nft_nldesc_set_desc),
+	NLDESC_ATTR_U32(NFTA_SET_ID),
+	NLDESC_ATTR_U64(NFTA_SET_TIMEOUT),
+	NLDESC_ATTR_U32(NFTA_SET_GC_INTERVAL),
+	NLDESC_ATTR_BINARY(NFTA_SET_USERDATA, NFT_USERDATA_MAXLEN),
+	NLDESC_ATTR_PAD(NFTA_SET_PAD),
+	NLDESC_ATTR_U32_MAX(NFTA_SET_OBJ_TYPE, NFT_OBJECT_MAX),
+	NLDESC_ATTR_U64(NFTA_SET_HANDLE),
+};
+
+static const struct nl_desc_attr nft_nldesc_set_elem_attrs[NFTA_SET_ELEM_MAX + 1] = {
+	NLDESC_ATTR_NESTED(NFTA_SET_ELEM_KEY, nft_nldesc_data),
+	NLDESC_ATTR_NESTED(NFTA_SET_ELEM_DATA, nft_nldesc_data),
+	NLDESC_ATTR_U32_MAX(NFTA_SET_ELEM_FLAGS, NFT_SET_ELEM_INTERVAL_END),
+	NLDESC_ATTR_U64(NFTA_SET_ELEM_TIMEOUT),
+	NLDESC_ATTR_U64(NFTA_SET_ELEM_EXPIRATION),
+	NLDESC_ATTR_BINARY(NFTA_SET_ELEM_USERDATA, NFT_USERDATA_MAXLEN),
+	NLDESC_ATTR_NESTED(NFTA_SET_ELEM_EXPR, nft_nldesc_expressions),
+	NLDESC_ATTR_STRING(NFTA_SET_ELEM_OBJREF, NFT_NAME_MAXLEN - 1),
+};
+
+static const struct nl_desc_obj nft_nldesc_obj_data[] = {
+	NLDESC_OBJ(NFT_OBJ_COUNTER, nft_nldesc_counter_attrs, NFTA_COUNTER_MAX),
+	NLDESC_OBJ(NFT_OBJ_QUOTA, nft_nldesc_quota_attrs, NFTA_QUOTA_MAX),
+	NLDESC_OBJ(NFT_OBJ_LIMIT, nft_nldesc_limit_attrs, NFTA_LIMIT_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_attr nft_nldesc_obj_attrs[NFTA_OBJ_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_OBJ_TABLE, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_STRING(NFTA_OBJ_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_OBJ_TYPE, NFT_OBJECT_MAX),
+	NLDESC_ATTR_NESTED(NFTA_OBJ_DATA, nft_nldesc_obj_data),
+	NLDESC_ATTR_U32(NFTA_OBJ_USE),
+	NLDESC_ATTR_U64(NFTA_OBJ_HANDLE),
+	NLDESC_ATTR_PAD(NFTA_OBJ_PAD),
+};
+
+static const struct nl_desc_attr nft_nldesc_flowtable_attrs[NFTA_FLOWTABLE_MAX + 1] = {
+	NLDESC_ATTR_STRING(NFTA_FLOWTABLE_TABLE, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_STRING(NFTA_FLOWTABLE_NAME, NFT_NAME_MAXLEN - 1),
+	NLDESC_ATTR_U32_MAX(NFTA_FLOWTABLE_HOOK, NF_NETDEV_INGRESS),
+	NLDESC_ATTR_U32(NFTA_FLOWTABLE_USE),
+	NLDESC_ATTR_U64(NFTA_FLOWTABLE_HANDLE),
+	NLDESC_ATTR_PAD(NFTA_FLOWTABLE_PAD),
+};
+
+static const struct nl_desc_obj nft_nldesc_base[] = {
+	NLDESC_OBJ(NFT_TABLE, nft_nldesc_table_attrs, NFTA_TABLE_MAX),
+	NLDESC_OBJ(NFT_CHAIN, nft_nldesc_chain_attrs, NFTA_CHAIN_MAX),
+	NLDESC_OBJ(NFT_RULE, nft_nldesc_rule_attrs, NFTA_RULE_MAX),
+	NLDESC_OBJ(NFT_SET, nft_nldesc_set_attrs, NFTA_SET_MAX),
+	NLDESC_OBJ(NFT_SET_ELEM, nft_nldesc_set_elem_attrs, NFTA_SET_ELEM_MAX),
+	NLDESC_OBJ(NFT_OBJ, nft_nldesc_obj_attrs, NFTA_OBJ_MAX),
+	NLDESC_OBJ(NFT_FLOWTABLE, nft_nldesc_flowtable_attrs, NFTA_FLOWTABLE_MAX),
+	NLDESC_OBJ_END,
+};
+
+static const struct nl_desc_obj *nft_nldesc_obj_table[] = {
+	nft_nldesc_base,
+	nft_nldesc_chain_dev,
+	nft_nldesc_chain_hook,
+	nft_nldesc_counters,
+	nft_nldesc_data,
+	nft_nldesc_expressions,
+	nft_nldesc_expr_data,
+	nft_nldesc_expressions,
+	nft_nldesc_rule_compat,
+	nft_nldesc_set_desc,
+	nft_nldesc_obj_data,
+	NULL,
+};
+
+static const struct nl_desc_objs nft_desc_objs = {
+	.max	= NFT_MAX,
+	.table	= nft_nldesc_obj_table,
+};
+
+static const struct nl_desc_cmd nft_nldesc_cmd_table[] = {
+	NLDESC_CMD(NFT_MSG_NEWTABLE, NFT_TABLE),
+	NLDESC_CMD(NFT_MSG_GETTABLE, NFT_TABLE),
+	NLDESC_CMD(NFT_MSG_DELTABLE, NFT_TABLE),
+	NLDESC_CMD(NFT_MSG_NEWCHAIN, NFT_CHAIN),
+	NLDESC_CMD(NFT_MSG_GETCHAIN, NFT_CHAIN),
+	NLDESC_CMD(NFT_MSG_DELCHAIN, NFT_CHAIN),
+	NLDESC_CMD(NFT_MSG_NEWRULE, NFT_RULE),
+	NLDESC_CMD(NFT_MSG_GETRULE, NFT_RULE),
+	NLDESC_CMD(NFT_MSG_DELRULE, NFT_RULE),
+	NLDESC_CMD(NFT_MSG_NEWSET, NFT_SET),
+	NLDESC_CMD(NFT_MSG_GETSET, NFT_SET),
+	NLDESC_CMD(NFT_MSG_DELSET, NFT_SET),
+	NLDESC_CMD(NFT_MSG_NEWSETELEM, NFT_SET_ELEM),
+	NLDESC_CMD(NFT_MSG_GETSETELEM, NFT_SET_ELEM),
+	NLDESC_CMD(NFT_MSG_DELSETELEM, NFT_SET_ELEM),
+	NLDESC_CMD(NFT_MSG_NEWOBJ, NFT_OBJ),
+	NLDESC_CMD(NFT_MSG_GETOBJ, NFT_OBJ),
+	NLDESC_CMD(NFT_MSG_DELOBJ, NFT_OBJ),
+	NLDESC_CMD(NFT_MSG_GETOBJ_RESET, NFT_OBJ),
+	NLDESC_CMD(NFT_MSG_NEWFLOWTABLE, NFT_FLOWTABLE),
+	NLDESC_CMD(NFT_MSG_GETFLOWTABLE, NFT_FLOWTABLE),
+	NLDESC_CMD(NFT_MSG_DELFLOWTABLE, NFT_FLOWTABLE),
+	NLDESC_CMD_END,
+};
+
+static const struct nl_desc_cmds nft_desc_cmds = {
+	.max	= NFT_MSG_MAX,
+	.table	= nft_nldesc_cmd_table,
+};
+
+const struct nfnl_desc_subsys nft_nldesc = {
+	.id	= NFNL_SUBSYS_NFTABLES,
+	.cmds	= &nft_desc_cmds,
+	.objs	= &nft_desc_objs,
+};
-- 
2.11.0
