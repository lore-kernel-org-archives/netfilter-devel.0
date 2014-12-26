From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft-sync PATCH 2/3] mnl: sync source code with nft
Date: Fri, 26 Dec 2014 13:51:28 +0100
Message-ID: <20141226125127.16382.40927.stgit@nfdev.cica.es>
References: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41862 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbaLZMvi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:51:38 -0500
In-Reply-To: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Let's update the mnl source code to match the latest in nft.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/linux/netfilter/nf_tables.h |  125 +++++++++++++++++++++-
 include/mnl.h                       |    2 
 include/utils.h                     |    9 ++
 src/main.c                          |    2 
 src/mnl.c                           |  198 ++++++++++++++++++++++-------------
 src/utils.c                         |    7 +
 6 files changed, 261 insertions(+), 82 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 11d5937..832bc46 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1,7 +1,8 @@
 #ifndef _LINUX_NF_TABLES_H
 #define _LINUX_NF_TABLES_H
 
-#define NFT_CHAIN_MAXNAMELEN 32
+#define NFT_CHAIN_MAXNAMELEN	32
+#define NFT_USERDATA_MAXLEN	256
 
 enum nft_registers {
 	NFT_REG_VERDICT,
@@ -50,6 +51,8 @@ enum nft_verdicts {
  * @NFT_MSG_NEWSETELEM: create a new set element (enum nft_set_elem_attributes)
  * @NFT_MSG_GETSETELEM: get a set element (enum nft_set_elem_attributes)
  * @NFT_MSG_DELSETELEM: delete a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_NEWGEN: announce a new generation, only for events (enum nft_gen_attributes)
+ * @NFT_MSG_GETGEN: get the rule-set generation (enum nft_gen_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -67,6 +70,8 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWSETELEM,
 	NFT_MSG_GETSETELEM,
 	NFT_MSG_DELSETELEM,
+	NFT_MSG_NEWGEN,
+	NFT_MSG_GETGEN,
 	NFT_MSG_MAX,
 };
 
@@ -156,6 +161,7 @@ enum nft_chain_attributes {
  * @NFTA_RULE_EXPRESSIONS: list of expressions (NLA_NESTED: nft_expr_attributes)
  * @NFTA_RULE_COMPAT: compatibility specifications of the rule (NLA_NESTED: nft_rule_compat_attributes)
  * @NFTA_RULE_POSITION: numeric handle of the previous rule (NLA_U64)
+ * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -165,6 +171,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_EXPRESSIONS,
 	NFTA_RULE_COMPAT,
 	NFTA_RULE_POSITION,
+	NFTA_RULE_USERDATA,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
@@ -209,6 +216,29 @@ enum nft_set_flags {
 };
 
 /**
+ * enum nft_set_policies - set selection policy
+ *
+ * @NFT_SET_POL_PERFORMANCE: prefer high performance over low memory use
+ * @NFT_SET_POL_MEMORY: prefer low memory use over high performance
+ */
+enum nft_set_policies {
+	NFT_SET_POL_PERFORMANCE,
+	NFT_SET_POL_MEMORY,
+};
+
+/**
+ * enum nft_set_desc_attributes - set element description
+ *
+ * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ */
+enum nft_set_desc_attributes {
+	NFTA_SET_DESC_UNSPEC,
+	NFTA_SET_DESC_SIZE,
+	__NFTA_SET_DESC_MAX
+};
+#define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
+
+/**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
  * @NFTA_SET_TABLE: table name (NLA_STRING)
@@ -218,6 +248,9 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_POLICY: selection policy (NLA_U32)
+ * @NFTA_SET_DESC: set description (NLA_NESTED)
+ * @NFTA_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -228,6 +261,9 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_POLICY,
+	NFTA_SET_DESC,
+	NFTA_SET_ID,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -263,12 +299,14 @@ enum nft_set_elem_attributes {
  * @NFTA_SET_ELEM_LIST_TABLE: table of the set to be changed (NLA_STRING)
  * @NFTA_SET_ELEM_LIST_SET: name of the set to be changed (NLA_STRING)
  * @NFTA_SET_ELEM_LIST_ELEMENTS: list of set elements (NLA_NESTED: nft_set_elem_attributes)
+ * @NFTA_SET_ELEM_LIST_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_set_elem_list_attributes {
 	NFTA_SET_ELEM_LIST_UNSPEC,
 	NFTA_SET_ELEM_LIST_TABLE,
 	NFTA_SET_ELEM_LIST_SET,
 	NFTA_SET_ELEM_LIST_ELEMENTS,
+	NFTA_SET_ELEM_LIST_SET_ID,
 	__NFTA_SET_ELEM_LIST_MAX
 };
 #define NFTA_SET_ELEM_LIST_MAX	(__NFTA_SET_ELEM_LIST_MAX - 1)
@@ -454,12 +492,14 @@ enum nft_cmp_attributes {
  * @NFTA_LOOKUP_SET: name of the set where to look for (NLA_STRING)
  * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_LOOKUP_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
  */
 enum nft_lookup_attributes {
 	NFTA_LOOKUP_UNSPEC,
 	NFTA_LOOKUP_SET,
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
+	NFTA_LOOKUP_SET_ID,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
@@ -535,6 +575,11 @@ enum nft_exthdr_attributes {
  * @NFT_META_L4PROTO: layer 4 protocol number
  * @NFT_META_BRI_IIFNAME: packet input bridge interface name
  * @NFT_META_BRI_OIFNAME: packet output bridge interface name
+ * @NFT_META_PKTTYPE: packet type (skb->pkt_type), special handling for loopback
+ * @NFT_META_CPU: cpu id through smp_processor_id()
+ * @NFT_META_IIFGROUP: packet input interface group
+ * @NFT_META_OIFGROUP: packet output interface group
+ * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -556,6 +601,11 @@ enum nft_meta_keys {
 	NFT_META_L4PROTO,
 	NFT_META_BRI_IIFNAME,
 	NFT_META_BRI_OIFNAME,
+	NFT_META_PKTTYPE,
+	NFT_META_CPU,
+	NFT_META_IIFGROUP,
+	NFT_META_OIFGROUP,
+	NFT_META_CGROUP,
 };
 
 /**
@@ -590,7 +640,6 @@ enum nft_meta_attributes {
  * @NFT_CT_PROTOCOL: conntrack layer 4 protocol
  * @NFT_CT_PROTO_SRC: conntrack layer 4 protocol source
  * @NFT_CT_PROTO_DST: conntrack layer 4 protocol destination
- * @NFT_CT_LABELS: conntrack label bitset (stored in conntrack extension)
  */
 enum nft_ct_keys {
 	NFT_CT_STATE,
@@ -606,7 +655,7 @@ enum nft_ct_keys {
 	NFT_CT_PROTOCOL,
 	NFT_CT_PROTO_SRC,
 	NFT_CT_PROTO_DST,
-	NFT_CT_LABEL,
+	NFT_CT_LABELS,
 };
 
 /**
@@ -615,12 +664,14 @@ enum nft_ct_keys {
  * @NFTA_CT_DREG: destination register (NLA_U32)
  * @NFTA_CT_KEY: conntrack data item to load (NLA_U32: nft_ct_keys)
  * @NFTA_CT_DIRECTION: direction in case of directional keys (NLA_U8)
+ * @NFTA_CT_SREG: source register (NLA_U32)
  */
 enum nft_ct_attributes {
 	NFTA_CT_UNSPEC,
 	NFTA_CT_DREG,
 	NFTA_CT_KEY,
 	NFTA_CT_DIRECTION,
+	NFTA_CT_SREG,
 	__NFTA_CT_MAX
 };
 #define NFTA_CT_MAX		(__NFTA_CT_MAX - 1)
@@ -660,6 +711,8 @@ enum nft_counter_attributes {
  * @NFTA_LOG_PREFIX: prefix to prepend to log messages (NLA_STRING)
  * @NFTA_LOG_SNAPLEN: length of payload to include in netlink message (NLA_U32)
  * @NFTA_LOG_QTHRESHOLD: queue threshold (NLA_U32)
+ * @NFTA_LOG_LEVEL: log level (NLA_U32)
+ * @NFTA_LOG_FLAGS: logging flags (NLA_U32)
  */
 enum nft_log_attributes {
 	NFTA_LOG_UNSPEC,
@@ -667,6 +720,8 @@ enum nft_log_attributes {
 	NFTA_LOG_PREFIX,
 	NFTA_LOG_SNAPLEN,
 	NFTA_LOG_QTHRESHOLD,
+	NFTA_LOG_LEVEL,
+	NFTA_LOG_FLAGS,
 	__NFTA_LOG_MAX
 };
 #define NFTA_LOG_MAX		(__NFTA_LOG_MAX - 1)
@@ -696,11 +751,32 @@ enum nft_queue_attributes {
  *
  * @NFT_REJECT_ICMP_UNREACH: reject using ICMP unreachable
  * @NFT_REJECT_TCP_RST: reject using TCP RST
+ * @NFT_REJECT_ICMPX_UNREACH: abstracted ICMP unreachable for bridge and inet
  */
 enum nft_reject_types {
 	NFT_REJECT_ICMP_UNREACH,
 	NFT_REJECT_TCP_RST,
+	NFT_REJECT_ICMPX_UNREACH,
+};
+
+/**
+ * enum nft_reject_code - Generic reject codes for IPv4/IPv6
+ *
+ * @NFT_REJECT_ICMPX_NO_ROUTE: no route to host / network unreachable
+ * @NFT_REJECT_ICMPX_PORT_UNREACH: port unreachable
+ * @NFT_REJECT_ICMPX_HOST_UNREACH: host unreachable
+ * @NFT_REJECT_ICMPX_ADMIN_PROHIBITED: administratively prohibited
+ *
+ * These codes are mapped to real ICMP and ICMPv6 codes.
+ */
+enum nft_reject_inet_code {
+	NFT_REJECT_ICMPX_NO_ROUTE	= 0,
+	NFT_REJECT_ICMPX_PORT_UNREACH,
+	NFT_REJECT_ICMPX_HOST_UNREACH,
+	NFT_REJECT_ICMPX_ADMIN_PROHIBITED,
+	__NFT_REJECT_ICMPX_MAX
 };
+#define NFT_REJECT_ICMPX_MAX	(__NFT_REJECT_ICMPX_MAX - 1)
 
 /**
  * enum nft_reject_attributes - nf_tables reject expression netlink attributes
@@ -736,6 +812,7 @@ enum nft_nat_types {
  * @NFTA_NAT_REG_ADDR_MAX: source register of address range end (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
  * @NFTA_NAT_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_NAT_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
  */
 enum nft_nat_attributes {
 	NFTA_NAT_UNSPEC,
@@ -745,19 +822,49 @@ enum nft_nat_attributes {
 	NFTA_NAT_REG_ADDR_MAX,
 	NFTA_NAT_REG_PROTO_MIN,
 	NFTA_NAT_REG_PROTO_MAX,
+	NFTA_NAT_FLAGS,
 	__NFTA_NAT_MAX
 };
 #define NFTA_NAT_MAX		(__NFTA_NAT_MAX - 1)
 
 /**
- * enum nft_nfacct_attributes - nf_tables nfacct expression netlink attributes
+ * enum nft_masq_attributes - nf_tables masquerade expression attributes
+ *
+ * @NFTA_MASQ_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ */
+enum nft_masq_attributes {
+	NFTA_MASQ_UNSPEC,
+	NFTA_MASQ_FLAGS,
+	__NFTA_MASQ_MAX
+};
+#define NFTA_MASQ_MAX		(__NFTA_MASQ_MAX - 1)
+
+/**
+ * enum nft_redir_attributes - nf_tables redirect expression netlink attributes
+ *
+ * @NFTA_REDIR_REG_PROTO_MIN: source register of proto range start (NLA_U32: nft_registers)
+ * @NFTA_REDIR_REG_PROTO_MAX: source register of proto range end (NLA_U32: nft_registers)
+ * @NFTA_REDIR_FLAGS: NAT flags (see NF_NAT_RANGE_* in linux/netfilter/nf_nat.h) (NLA_U32)
+ */
+enum nft_redir_attributes {
+	NFTA_REDIR_UNSPEC,
+	NFTA_REDIR_REG_PROTO_MIN,
+	NFTA_REDIR_REG_PROTO_MAX,
+	NFTA_REDIR_FLAGS,
+	__NFTA_REDIR_MAX
+};
+#define NFTA_REDIR_MAX		(__NFTA_REDIR_MAX - 1)
+
+/**
+ * enum nft_gen_attributes - nf_tables ruleset generation attributes
  *
- * @NFTA_NFACCT_NAME: nfacct object name (NLA_STRING)
+ * @NFTA_GEN_ID: Ruleset generation ID (NLA_U32)
  */
-enum nft_nfacct_attributes {
-	NFTA_NFACCT_NAME,
-	__NFTA_NFACCT_MAX,
+enum nft_gen_attributes {
+	NFTA_GEN_UNSPEC,
+	NFTA_GEN_ID,
+	__NFTA_GEN_MAX
 };
-#define NFTA_NFACCT_MAX		(__NFTA_NFACCT_MAX -1)
+#define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
 
 #endif /* _LINUX_NF_TABLES_H */
diff --git a/include/mnl.h b/include/mnl.h
index cd146bd..db409c4 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -11,6 +11,8 @@
 
 #include "config.h"
 
+void mnl_genid_get(struct mnl_socket *nf_sock);
+
 struct nft_rule_list *mnl_rule_dump(struct mnl_socket *nf_sock, int family);
 struct nft_chain_list *mnl_chain_dump(struct mnl_socket *nf_sock,  int family);
 struct nft_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family);
diff --git a/include/utils.h b/include/utils.h
index 8d0eb38..d6be446 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -1,7 +1,16 @@
 #ifndef _UTILS_H_
 #define _UTILS_H_
 
+#include <stdint.h>
+
+#define __noreturn		__attribute__((__noreturn__))
+
 void xfree(const void *ptr);
 
+void __memory_allocation_error(const char *filename, uint32_t line) __noreturn;
+
+#define memory_allocation_error()		\
+	__memory_allocation_error(__FILE__, __LINE__);
+
 #endif /* _UTILS_H_ */
 
diff --git a/src/main.c b/src/main.c
index 0e6a8bc..e8f2dab 100644
--- a/src/main.c
+++ b/src/main.c
@@ -108,6 +108,8 @@ int main(int argc, char *argv[])
 			goto err;
 		}
 
+		mnl_genid_get(nfts_inst.nl_query_sock);
+
 		nfts_log(NFTS_LOG_INFO, "listening at %s",
 			 inet_ntoa(nfts_inst.tcp.server.ipv4.inet_addr));
 	}
diff --git a/src/mnl.c b/src/mnl.c
index 3bb3ade..65ac4ea 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -14,27 +14,36 @@
 
 #include <errno.h>
 #include <stdlib.h>
+#include <fcntl.h>
 
+#include "utils.h"
 #include "mnl.h"
 #include "linux/netfilter/nf_tables.h"
 #include "linux/netfilter.h"
+#include <linux/netfilter/nfnetlink.h>
+#include <libnftnl/ruleset.h>
+#include <libnftnl/common.h>
 
 static int seq;
 
+/* The largest nf_tables netlink message is the set element message, which
+ * contains the NFTA_SET_ELEM_LIST_ELEMENTS attribute. This attribute is
+ * a nest that describes the set elements. Given that the netlink attribute
+ * length (nla_len) is 16 bits, the largest message is a bit larger than
+ * 64 KBytes.
+ */
+#define NFT_NLMSG_MAXSIZE (UINT16_MAX + getpagesize())
+
 static int
-nfts_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+nfts_mnl_recv(struct mnl_socket *nf_sock, uint32_t seqnum, uint32_t portid,
 	      int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
 {
-	char buf[MNL_SOCKET_BUFFER_SIZE];
-	uint32_t portid = mnl_socket_get_portid(nf_sock);
+	char buf[NFT_NLMSG_MAXSIZE];
 	int ret;
 
-	if (mnl_socket_sendto(nf_sock, data, len) < 0)
-		return -1;
-
 	ret = mnl_socket_recvfrom(nf_sock, buf, sizeof(buf));
 	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, cb, cb_data);
+		ret = mnl_cb_run(buf, ret, seqnum, portid, cb, cb_data);
 		if (ret <= 0)
 			goto out;
 
@@ -47,6 +56,53 @@ out:
 	return ret;
 }
 
+static int
+nfts_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
+	      int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
+{
+	uint32_t portid = mnl_socket_get_portid(nf_sock);
+
+	if (mnl_socket_sendto(nf_sock, data, len) < 0)
+		return -1;
+
+	return nfts_mnl_recv(nf_sock, seq, portid, cb, cb_data);
+}
+
+/*
+ * Rule-set consistency check across several netlink dumps
+ */
+static uint16_t nfts_genid;
+
+static int genid_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
+
+	nfts_genid = ntohs(nfh->res_id);
+
+	return MNL_CB_OK;
+}
+
+void mnl_genid_get(struct mnl_socket *nf_sock)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nft_nlmsg_build_hdr(buf, NFT_MSG_GETGEN, AF_UNSPEC, 0, seq);
+	/* Skip error checking, old kernels sets res_id field to zero. */
+	nfts_mnl_talk(nf_sock, nlh, nlh->nlmsg_len, genid_cb, NULL);
+}
+
+static int check_genid(const struct nlmsghdr *nlh)
+{
+	struct nfgenmsg *nfh = mnl_nlmsg_get_payload(nlh);
+
+	if (nfts_genid != ntohs(nfh->res_id)) {
+		errno = EINTR;
+		return -1;
+	}
+	return 0;
+}
+
 /*
  * Rule
  */
@@ -55,9 +111,12 @@ static int rule_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_rule_list *nlr_list = data;
 	struct nft_rule *r;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	r = nft_rule_alloc();
 	if (r == NULL)
-		return -1;
+		memory_allocation_error();
 
 	if (nft_rule_nlmsg_parse(nlh, r) < 0)
 		goto err_free;
@@ -102,9 +161,12 @@ static int chain_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_chain_list *nlc_list = data;
 	struct nft_chain *c;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	c = nft_chain_alloc();
 	if (c == NULL)
-		return -1;
+		memory_allocation_error();
 
 	if (nft_chain_nlmsg_parse(nlh, c) < 0)
 		goto err_free;
@@ -150,9 +212,12 @@ static int table_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_table_list *nlt_list = data;
 	struct nft_table *t;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	t = nft_table_alloc();
 	if (t == NULL)
-		return -1;
+		memory_allocation_error();
 
 	if (nft_table_nlmsg_parse(nlh, t) < 0)
 		goto err_free;
@@ -174,7 +239,7 @@ struct nft_table_list *mnl_table_dump(struct mnl_socket *nf_sock, int family)
 
 	nlt_list = nft_table_list_alloc();
 	if (nlt_list == NULL)
-		return NULL;
+		memory_allocation_error();
 
 	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE, family,
 					NLM_F_DUMP, seq);
@@ -198,9 +263,12 @@ static int set_cb(const struct nlmsghdr *nlh, void *data)
 	struct nft_set_list *nls_list = data;
 	struct nft_set *s;
 
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	s = nft_set_alloc();
 	if (s == NULL)
-		return -1;
+		memory_allocation_error();
 
 	if (nft_set_nlmsg_parse(nlh, s) < 0)
 		goto err_free;
@@ -228,7 +296,10 @@ mnl_set_dump(struct mnl_socket *nf_sock, int family, const char *table)
 
 	nlh = nft_set_nlmsg_build_hdr(buf, NFT_MSG_GETSET, family,
 				      NLM_F_DUMP|NLM_F_ACK, seq);
-	nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
+
+	if (table != NULL)
+		nft_set_attr_set(s, NFT_SET_ATTR_TABLE, table);
+
 	nft_set_nlmsg_build_payload(nlh, s);
 	nft_set_free(s);
 
@@ -246,32 +317,15 @@ err:
 	return NULL;
 }
 
-static void
-nft_set_list_merge(struct nft_set_list *dest, struct nft_set_list *orig)
-{
-	struct nft_set_list_iter *it;
-	struct nft_set *o;
-
-	it = nft_set_list_iter_create(orig);
-	if (it == NULL)
-		return;
-
-	o = nft_set_list_iter_next(it);
-	while (o != NULL) {
-		nft_set_list_add_tail(o, dest);
-		o = nft_set_list_iter_next(it);
-	}
-
-	nft_set_list_iter_destroy(it);
-}
-
-
 /*
  * Set elements
  */
 
 static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
 {
+	if (check_genid(nlh) < 0)
+		return MNL_CB_ERROR;
+
 	nft_set_elems_nlmsg_parse(nlh, data);
 	return MNL_CB_OK;
 }
@@ -296,61 +350,57 @@ int mnl_setelem_get(struct mnl_socket *nf_sock, struct nft_set *nls)
 struct nft_ruleset *mnl_ruleset_dump(struct mnl_socket *nf_sock)
 {
 	struct nft_ruleset *rs;
-	struct nft_rule_list *r;
-	struct nft_chain_list *c;
-	struct nft_set_list *complete_set_list = NULL, *s;
 	struct nft_table_list *t;
-	struct nft_table_list_iter *it;
-	struct nft_table *o;
-	const char *table;
-	uint16_t family;
-
-	t = mnl_table_dump(nf_sock, NFPROTO_UNSPEC);
-	if (t == NULL)
-		return NULL;
+	struct nft_chain_list *c;
+	struct nft_set_list *sl;
+	struct nft_set_list_iter *i;
+	struct nft_set *s;
+	struct nft_rule_list *r;
+	int ret = 0;
 
 	rs = nft_ruleset_alloc();
 	if (rs == NULL)
-		return NULL;
+		memory_allocation_error();
+
+	t = mnl_table_dump(nf_sock, NFPROTO_UNSPEC);
+	if (t == NULL)
+		goto err;
 
 	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_TABLELIST, t);
 
 	c = mnl_chain_dump(nf_sock, NFPROTO_UNSPEC);
-	if (c != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
-
-	r = mnl_rule_dump(nf_sock, NFPROTO_UNSPEC);
-	if (r != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
+	if (c == NULL)
+		goto err;
 
-	it = nft_table_list_iter_create(t);
-	if (it == NULL)
-		return NULL;
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_CHAINLIST, c);
 
-	o = nft_table_list_iter_next(it);
-	while (o != NULL) {
-		table = nft_table_attr_get_str(o, NFT_TABLE_ATTR_NAME);
-		family = nft_table_attr_get_u32(o, NFT_TABLE_ATTR_FAMILY);
+	sl = mnl_set_dump(nf_sock, NFPROTO_UNSPEC, NULL);
+	if (sl == NULL)
+		goto err;
 
-		s = mnl_set_dump(nf_sock, family, table);
-		if (s != NULL) {
-			if (complete_set_list == NULL) {
-				complete_set_list = nft_set_list_alloc();
-				if (complete_set_list == NULL)
-					return NULL;
-			}
+	i = nft_set_list_iter_create(sl);
+	s = nft_set_list_iter_next(i);
+	while (s != NULL) {
+		ret = mnl_setelem_get(nf_sock, s);
+		if (ret < 0)
+			goto err;
 
-			nft_set_list_merge(complete_set_list, s);
-		}
-		o = nft_table_list_iter_next(it);
+		s = nft_set_list_iter_next(i);
 	}
-	nft_table_list_iter_destroy(it);
+	nft_set_list_iter_destroy(i);
+
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST, sl);
+
+	r = mnl_rule_dump(nf_sock, NFPROTO_UNSPEC);
+	if (r == NULL)
+		goto err;
 
-	if (complete_set_list != NULL)
-		nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_SETLIST,
-				     complete_set_list);
+	nft_ruleset_attr_set(rs, NFT_RULESET_ATTR_RULELIST, r);
 
 	return rs;
+err:
+	nft_ruleset_free(rs);
+	return NULL;
 }
 
 /*
@@ -365,7 +415,9 @@ int nfts_socket_open(struct nft_sync_inst *inst)
 {
 	struct mnl_socket *s = netlink_socket_open();
 	if (s == NULL)
-		return -1;
+		memory_allocation_error();
+
+	fcntl(mnl_socket_get_fd(s), F_SETFL, O_NONBLOCK);
 
 	inst->nl_query_sock = s;
 	return 0;
diff --git a/src/utils.c b/src/utils.c
index f1886c4..da1e6ae 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -8,6 +8,7 @@
  */
 
 #include <stdlib.h>
+#include <stdio.h>
 
 #include "utils.h"
 
@@ -15,3 +16,9 @@ void xfree(const void *ptr)
 {
 	free((void *)ptr);
 }
+
+void __noreturn __memory_allocation_error(const char *filename, uint32_t line)
+{
+	fprintf(stderr, "%s:%u: Memory allocation failure\n", filename, line);
+	exit(EXIT_FAILURE);
+}

