From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,RFC 1/3] netfilter: nf_conntrack: add 64-bit conntrack ID extension
Date: Tue, 28 Nov 2017 03:13:07 +0100
Message-ID: <20171128021309.11277-1-pablo@netfilter.org>
Cc: richard@nod.at, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752398AbdK1CNS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Nov 2017 21:13:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6FFC8E2C45
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:13:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F759DA86E
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Nov 2017 03:13:16 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a 64-bit conntrack ID extension that allows userspace to
uniquely identify a conntrack object.

The existing 32-bit ID is not good to uniquely identify a conntrack
object. Long time ago, this used to be an incremental number that could
quickly wrap around. Someone suggested to use 64-bits, back then this
was considered to be too much memory for just an ID. So we usually
suggested to users that they should combine it with the conntrack tuple
to achieve a way to uniquely conntrack objects. This has always
generated a bit of controversy since userspace applications needed to
deal with extra work.

At some point, someone remove the explicit ct->id field that we used to
have to save memory space. This ID was modified to part of its memory
address. Howeover, this is a problem because objects can be quickly
recycled with the slab-by-rcu approach that we use these days. So even
combining this 32-bit ID with the tuple doesn't ensure that this is
unique. Moreover, this is leaking the pointer to userspace in 32-bit
arches, which is not good.

So let's introduce a 64-bit unique ID that ensures no overlaps. This is
only allocated once in the first packet, and never ever again from the
hot path, so let's keep this in a separated extension not to grab more
cachelines.

ID assignment is lockless: this patch divides the 64-bit space between
the existing CPUs, so they can freely allocate IDs in their space.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_extend.h |  2 ++
 include/net/netfilter/nf_conntrack_id.h     | 51 +++++++++++++++++++++++++++++
 include/net/netns/conntrack.h               |  1 +
 net/netfilter/Makefile                      |  2 +-
 net/netfilter/nf_conntrack_core.c           | 18 +++++++++-
 net/netfilter/nf_conntrack_id.c             | 48 +++++++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c        |  2 ++
 7 files changed, 122 insertions(+), 2 deletions(-)
 create mode 100644 include/net/netfilter/nf_conntrack_id.h
 create mode 100644 net/netfilter/nf_conntrack_id.c

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 21f887c5058c..274f9370c56a 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -28,6 +28,7 @@ enum nf_ct_ext_id {
 #if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
 	NF_CT_EXT_SYNPROXY,
 #endif
+	NF_CT_EXT_ID,
 	NF_CT_EXT_NUM,
 };
 
@@ -40,6 +41,7 @@ enum nf_ct_ext_id {
 #define NF_CT_EXT_TIMEOUT_TYPE struct nf_conn_timeout
 #define NF_CT_EXT_LABELS_TYPE struct nf_conn_labels
 #define NF_CT_EXT_SYNPROXY_TYPE struct nf_conn_synproxy
+#define NF_CT_EXT_ID_TYPE struct nf_conn_id
 
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
diff --git a/include/net/netfilter/nf_conntrack_id.h b/include/net/netfilter/nf_conntrack_id.h
new file mode 100644
index 000000000000..4dfd2d2fff6c
--- /dev/null
+++ b/include/net/netfilter/nf_conntrack_id.h
@@ -0,0 +1,51 @@
+#ifndef _NF_CONNTRACK_ID_H
+#define _NF_CONNTRACK_ID_H
+
+#include <linux/types.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_extend.h>
+
+struct nf_conn_id {
+	u64	id;
+};
+
+static inline u64 nf_ct_id(const struct nf_conn *ct)
+{
+	struct nf_conn_id *conn;
+
+	conn = nf_ct_ext_find(ct, NF_CT_EXT_ID);
+	if (!conn)
+		return 0;
+
+	return conn->id;
+}
+
+/* Needs to be called with preemption disabled. */
+static inline u64 nf_ct_id_alloc(struct net *net)
+{
+	u64 *id_cpu = this_cpu_ptr(net->ct.ids);
+
+	return (*id_cpu)++;
+}
+
+static inline struct nf_conn_id *
+nf_ct_id_ext_add(struct net *net, struct nf_conn *ct)
+{
+	struct nf_conn_id *conn;
+
+	conn = nf_ct_ext_add(ct, NF_CT_EXT_ID, GFP_ATOMIC);
+	if (!conn)
+		return NULL;
+
+	conn->id = nf_ct_id_alloc(net);
+
+	return conn;
+}
+
+int nf_conntrack_id_pernet_init(struct net *net);
+void nf_conntrack_id_pernet_fini(struct net *net);
+int nf_conntrack_id_init(void);
+void nf_conntrack_id_fini(void);
+
+#endif /* _NF_CONNTRACK_ID_H */
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index 9795d628a127..1675c9601c9d 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -114,6 +114,7 @@ struct netns_ct {
 
 	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
+	u64			__percpu *ids;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 	struct nf_ip_net	nf_ct_proto;
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index f78ed2470831..ea95e7e79a7e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 netfilter-objs := core.o nf_log.o nf_queue.o nf_sockopt.o
 
-nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o
+nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_expect.o nf_conntrack_helper.o nf_conntrack_proto.o nf_conntrack_l3proto_generic.o nf_conntrack_proto_generic.o nf_conntrack_proto_tcp.o nf_conntrack_proto_udp.o nf_conntrack_extend.o nf_conntrack_acct.o nf_conntrack_seqadj.o nf_conntrack_id.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMEOUT) += nf_conntrack_timeout.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_TIMESTAMP) += nf_conntrack_timestamp.o
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5749fcaa2770..85129bcf38e4 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -51,6 +51,7 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_id.h>
 #include <net/netfilter/nf_nat.h>
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_helper.h>
@@ -1241,6 +1242,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			     GFP_ATOMIC);
 
 	local_bh_disable();
+	nf_ct_id_ext_add(net, ct);
+
 	if (net->ct.expect_count) {
 		spin_lock(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
@@ -1856,6 +1859,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
 		free_percpu(net->ct.pcpu_lists);
+		nf_conntrack_id_pernet_fini(net);
 	}
 }
 
@@ -1971,7 +1975,7 @@ module_param_call(hashsize, nf_conntrack_set_hashsize, param_get_uint,
 static __always_inline unsigned int total_extension_size(void)
 {
 	/* remember to add new extensions below */
-	BUILD_BUG_ON(NF_CT_EXT_NUM > 9);
+	BUILD_BUG_ON(NF_CT_EXT_NUM > 10);
 
 	return sizeof(struct nf_ct_ext) +
 	       sizeof(struct nf_conn_help)
@@ -1995,6 +1999,7 @@ static __always_inline unsigned int total_extension_size(void)
 #if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
 		+ sizeof(struct nf_conn_synproxy)
 #endif
+		+ sizeof(struct nf_conn_id)
 	;
 };
 
@@ -2052,6 +2057,10 @@ int nf_conntrack_init_start(void)
 	       NF_CONNTRACK_VERSION, nf_conntrack_htable_size,
 	       nf_conntrack_max);
 
+	ret = nf_conntrack_id_init();
+	if (ret < 0)
+		goto err_id;
+
 	ret = nf_conntrack_expect_init();
 	if (ret < 0)
 		goto err_expect;
@@ -2110,6 +2119,8 @@ int nf_conntrack_init_start(void)
 err_acct:
 	nf_conntrack_expect_fini();
 err_expect:
+	nf_conntrack_id_fini();
+err_id:
 	kmem_cache_destroy(nf_conntrack_cachep);
 err_cachep:
 	nf_ct_free_hashtable(nf_conntrack_hash, nf_conntrack_htable_size);
@@ -2154,6 +2165,9 @@ int nf_conntrack_init_net(struct net *net)
 	if (!net->ct.stat)
 		goto err_pcpu_lists;
 
+	ret = nf_conntrack_id_pernet_init(net);
+	if (ret < 0)
+		goto err_id;
 	ret = nf_conntrack_expect_pernet_init(net);
 	if (ret < 0)
 		goto err_expect;
@@ -2185,6 +2199,8 @@ int nf_conntrack_init_net(struct net *net)
 err_acct:
 	nf_conntrack_expect_pernet_fini(net);
 err_expect:
+	nf_conntrack_id_pernet_fini(net);
+err_id:
 	free_percpu(net->ct.stat);
 err_pcpu_lists:
 	free_percpu(net->ct.pcpu_lists);
diff --git a/net/netfilter/nf_conntrack_id.c b/net/netfilter/nf_conntrack_id.c
new file mode 100644
index 000000000000..8ec535c33aa4
--- /dev/null
+++ b/net/netfilter/nf_conntrack_id.c
@@ -0,0 +1,48 @@
+#include <linux/types.h>
+#include <linux/netfilter.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include <net/netfilter/nf_conntrack_id.h>
+
+static const struct nf_ct_ext_type nf_ct_id_extend = {
+	.len    = sizeof(struct nf_conn_id),
+	.align  = __alignof__(struct nf_conn_id),
+	.id     = NF_CT_EXT_ID,
+};
+
+int nf_conntrack_id_pernet_init(struct net *net)
+{
+	int i = 0, cpu;
+
+	net->ct.ids = alloc_percpu(u64);
+	if (!net->ct.ids)
+		return -ENOMEM;
+
+	/* Divide u64 conntrack id space between existing CPUs, so we can
+	 * assign them locklessly.
+	 */
+	for_each_possible_cpu(cpu) {
+		u64 *id_base = per_cpu_ptr(net->ct.ids, cpu);
+
+		*id_base = (U64_MAX / nr_cpu_ids) * i;
+		i++;
+	}
+
+	return 0;
+}
+
+void nf_conntrack_id_pernet_fini(struct net *net)
+{
+	free_percpu(net->ct.ids);
+}
+
+int nf_conntrack_id_init(void)
+{
+	return nf_ct_extend_register(&nf_ct_id_extend);
+}
+
+void nf_conntrack_id_fini(void)
+{
+	nf_ct_extend_unregister(&nf_ct_id_extend);
+}
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 71a43ed19a0f..b3b8249ced4a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -47,6 +47,7 @@
 #include <net/netfilter/nf_conntrack_labels.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_conntrack_id.h>
 #ifdef CONFIG_NF_NAT_NEEDED
 #include <net/netfilter/nf_nat_core.h>
 #include <net/netfilter/nf_nat_l4proto.h>
@@ -1839,6 +1840,7 @@ ctnetlink_create_conntrack(struct net *net,
 	nf_ct_labels_ext_add(ct);
 	nfct_seqadj_ext_add(ct);
 	nfct_synproxy_ext_add(ct);
+	nf_ct_id_ext_add(net, ct);
 
 	/* we must add conntrack extensions before confirmation. */
 	ct->status |= IPS_CONFIRMED;
-- 
2.11.0

