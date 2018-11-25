From: Aaron Conole <aconole@bytheb.org>
Subject: [RFC -next v0 3/3] netfilter: nf_flow_table_bpf_map: introduce new loadable bpf map
Date: Sun, 25 Nov 2018 13:09:19 -0500
Message-ID: <20181125180919.13996-4-aconole@bytheb.org>
References: <20181125180919.13996-1-aconole@bytheb.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        Rony Efraim <ronye@mellanox.com>,
        Simon Horman <horms@verge.net>,
        Marcelo Leitner <marcelo.leitner@gmail.com>
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181125180919.13996-1-aconole@bytheb.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This commit introduces a new loadable map that allows an eBPF program to
query the flow offload tables for specific flow information.  For now,
that information is limited to input and output index information.  Future
enhancements would be to include connection tracking details, such as
state, metadata, and allow for window validation.

Signed-off-by: Aaron Conole <aconole@bytheb.org>
---
 include/linux/bpf_types.h                 |   2 +
 include/uapi/linux/bpf.h                  |   7 +
 net/netfilter/Kconfig                     |   9 +
 net/netfilter/Makefile                    |   1 +
 net/netfilter/nf_flow_table_bpf_flowmap.c | 202 ++++++++++++++++++++++
 5 files changed, 221 insertions(+)
 create mode 100644 net/netfilter/nf_flow_table_bpf_flowmap.c

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 44d9ab4809bd..82d3038cf6c3 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -71,3 +71,5 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
 #endif
 BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
+
+BPF_MAP_TYPE(BPF_MAP_TYPE_FLOWMAP, loadable_map)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 852dc17ab47a..fb77c8c5c209 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -131,6 +131,7 @@ enum bpf_map_type {
 	BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE,
 	BPF_MAP_TYPE_QUEUE,
 	BPF_MAP_TYPE_STACK,
+	BPF_MAP_TYPE_FLOWMAP,
 };
 
 enum bpf_prog_type {
@@ -2942,4 +2943,10 @@ struct bpf_flow_keys {
 	};
 };
 
+struct bpf_flow_map {
+	struct bpf_flow_keys	flow;
+	__u32			iifindex;
+	__u32			oifindex;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 2ab870ef233a..30f1bc9084be 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -709,6 +709,15 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_BPF
+	tristate "Netfilter flowtable BPF map"
+	depends on NF_FLOW_TABLE
+	depends on BPF_LOADABLE_MAPS
+	help
+	  This option adds support for retrieving flow table entries
+	  via a loadable BPF map.
+	  To compile it as a module, choose M here.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 4ddf3ef51ece..8dba928a03fd 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
+obj-$(CONFIG_NF_FLOW_TABLE_BPF)	+= nf_flow_table_bpf_flowmap.o
 nf_flow_table-objs := nf_flow_table_core.o nf_flow_table_ip.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
diff --git a/net/netfilter/nf_flow_table_bpf_flowmap.c b/net/netfilter/nf_flow_table_bpf_flowmap.c
new file mode 100644
index 000000000000..577985560883
--- /dev/null
+++ b/net/netfilter/nf_flow_table_bpf_flowmap.c
@@ -0,0 +1,202 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (c) 2018, Aaron Conole <aconole@bytheb.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/bpf.h>
+#include <net/xdp.h>
+#include <linux/filter.h>
+#include <trace/events/xdp.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_flow_table.h>
+
+struct flow_map_internal {
+	struct bpf_map map;
+	struct nf_flowtable net_flow_table;
+};
+
+static void flow_map_init_from_attr(struct bpf_map *map, union bpf_attr *attr)
+{
+	map->map_type = attr->map_type;
+	map->key_size = attr->key_size;
+	map->value_size = attr->value_size;
+	map->max_entries = attr->max_entries;
+	map->map_flags = attr->map_flags;
+	map->numa_node = bpf_map_attr_numa_node(attr);
+}
+
+static struct bpf_map *flow_map_alloc(union bpf_attr *attr)
+{
+	struct flow_map_internal *fmap_ret;
+	u64 cost;
+	int err;
+
+	if (!capable(CAP_NET_ADMIN))
+		return ERR_PTR(-EPERM);
+
+	if (attr->max_entries == 0 ||
+	    attr->key_size != sizeof(struct bpf_flow_map) ||
+	    attr->value_size != sizeof(struct bpf_flow_map))
+		return ERR_PTR(-EINVAL);
+
+	fmap_ret = kzalloc(sizeof(*fmap_ret), GFP_USER);
+	if (!fmap_ret)
+		return ERR_PTR(-ENOMEM);
+
+	flow_map_init_from_attr(&fmap_ret->map, attr);
+	cost = (u64)fmap_ret->map.max_entries * sizeof(struct flow_offload);
+	if (cost >= U32_MAX - PAGE_SIZE) {
+		kfree(&fmap_ret);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	fmap_ret->map.pages = round_up(cost, PAGE_SIZE) >> PAGE_SHIFT;
+
+	/* if map size is larger than memlock limit, reject it early */
+	if ((err = bpf_map_precharge_memlock(fmap_ret->map.pages))) {
+		kfree(&fmap_ret);
+		return ERR_PTR(err);
+	}
+
+	memset(&fmap_ret->net_flow_table, 0, sizeof(fmap_ret->net_flow_table));
+	fmap_ret->net_flow_table.flags |= NF_FLOWTABLE_F_SNOOP;
+	nf_flow_table_init(&fmap_ret->net_flow_table);
+
+	return &fmap_ret->map;
+}
+
+static void flow_map_free(struct bpf_map *map)
+{
+	struct flow_map_internal *fmap = container_of(map,
+						      struct flow_map_internal,
+						      map);
+
+	nf_flow_table_free(&fmap->net_flow_table);
+	synchronize_rcu();
+	kfree(fmap);
+}
+
+static void flow_walk(struct flow_offload *flow, void *data)
+{
+	printk("Flow offload dir0: %x:%d -> %x:%d, %u, %u, %d, %u\n",
+	       flow->tuplehash[0].tuple.src_v4.s_addr,
+	       flow->tuplehash[0].tuple.src_port,
+	       flow->tuplehash[0].tuple.dst_v4.s_addr,
+	       flow->tuplehash[0].tuple.dst_port,
+	       flow->tuplehash[0].tuple.l3proto,
+	       flow->tuplehash[0].tuple.l4proto,
+	       flow->tuplehash[0].tuple.iifidx,
+	       flow->tuplehash[0].tuple.dir
+	       );
+
+	printk("Flow offload dir1: %x:%d -> %x:%d, %u, %u, %d, %u\n",
+	       flow->tuplehash[1].tuple.src_v4.s_addr,
+	       flow->tuplehash[1].tuple.src_port,
+	       flow->tuplehash[1].tuple.dst_v4.s_addr,
+	       flow->tuplehash[1].tuple.dst_port,
+	       flow->tuplehash[1].tuple.l3proto,
+	       flow->tuplehash[1].tuple.l4proto,
+	       flow->tuplehash[1].tuple.iifidx,
+	       flow->tuplehash[1].tuple.dir
+	       );
+}
+
+static void *flow_map_lookup_elem(struct bpf_map *map, void *key)
+{
+	struct flow_map_internal *fmap = container_of(map,
+						      struct flow_map_internal, map);
+	struct bpf_flow_map *internal_key = (struct bpf_flow_map *)key;
+	struct flow_offload_tuple_rhash *hash_ret;
+	struct flow_offload_tuple lookup_key;
+
+	memset(&lookup_key, 0, sizeof(lookup_key));
+	lookup_key.src_port = ntohs(internal_key->flow.sport);
+	lookup_key.dst_port = ntohs(internal_key->flow.dport);
+	lookup_key.dir = 0;
+
+	if (internal_key->flow.addr_proto == htons(ETH_P_IP)) {
+		lookup_key.l3proto = AF_INET;
+		lookup_key.src_v4.s_addr = ntohl(internal_key->flow.ipv4_src);
+		lookup_key.dst_v4.s_addr = ntohl(internal_key->flow.ipv4_dst);
+	} else if (internal_key->flow.addr_proto == htons(ETH_P_IPV6)) {
+		lookup_key.l3proto = AF_INET6;
+		memcpy(&lookup_key.src_v6,
+		       internal_key->flow.ipv6_src,
+		       sizeof(lookup_key.src_v6));
+		memcpy(&lookup_key.dst_v6,
+		       internal_key->flow.ipv6_dst,
+		       sizeof(lookup_key.dst_v6));
+	} else
+		return NULL;
+
+	lookup_key.l4proto = (u8)internal_key->flow.ip_proto;
+	lookup_key.iifidx = internal_key->iifindex;
+
+	printk("Flow offload lookup: %x:%d -> %x:%d, %u, %u, %d, %u\n",
+	       lookup_key.src_v4.s_addr, lookup_key.src_port,
+	       lookup_key.dst_v4.s_addr, lookup_key.dst_port,
+	       lookup_key.l3proto, lookup_key.l4proto,
+	       lookup_key.iifidx, lookup_key.dir);
+	hash_ret = flow_offload_lookup(&fmap->net_flow_table, &lookup_key);
+	if (!hash_ret) {
+		memcpy(&lookup_key.src_v6, internal_key->flow.ipv6_src,
+		       sizeof(lookup_key.src_v6));
+		memcpy(&lookup_key.dst_v6, internal_key->flow.ipv6_dst,
+		       sizeof(lookup_key.dst_v6));
+		lookup_key.src_port = internal_key->flow.dport;
+		lookup_key.dst_port = internal_key->flow.sport;
+		lookup_key.dir = 1;
+		hash_ret = flow_offload_lookup(&fmap->net_flow_table,
+					       &lookup_key);
+	}
+
+	if (!hash_ret) {
+		printk("No flow found, but table is: %d\n",
+		       atomic_read(&fmap->net_flow_table.rhashtable.nelems));
+		nf_flow_table_iterate(&fmap->net_flow_table, flow_walk, NULL);
+		return NULL;
+	}
+
+	printk("Flow matched!\n");
+	return key;
+}
+
+static int flow_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
+{
+	return 0;
+}
+
+static int flow_map_check_no_btf(const struct bpf_map *map,
+				 const struct btf_type *key_type,
+				 const struct btf_type *value_type)
+{
+	return -ENOTSUPP;
+}
+
+const struct bpf_map_ops flow_map_ops = {
+	.map_alloc = flow_map_alloc,
+	.map_free = flow_map_free,
+	.map_get_next_key = flow_map_get_next_key,
+	.map_lookup_elem = flow_map_lookup_elem,
+	.map_check_btf = flow_map_check_no_btf,
+};
+
+static int __init flow_map_init(void)
+{
+	bpf_map_insert_ops(BPF_MAP_TYPE_FLOWMAP, &flow_map_ops);
+	return 0;
+}
+
+module_init(flow_map_init);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Aaron Conole <aconole@bytheb.org>");
-- 
2.19.1
