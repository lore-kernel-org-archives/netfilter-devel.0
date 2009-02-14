From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Sat, 14 Feb 2009 21:28:49 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902142112590.28575@fbirervta.pbzchgretzou.qr>
References: <20090214192936.11718.44732.stgit@Decadence>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58041 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZBNU2w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Feb 2009 15:28:52 -0500
In-Reply-To: <20090214192936.11718.44732.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-14 20:29, Pablo Neira Ayuso wrote:

>This patch adds the iptables cluster match. This match can be used
>to deploy gateway and back-end load-sharing clusters.

All of this nice text (below) should go into libxt_cluster.man :)

>Assuming that all the nodes see all packets (see below for an
>example on how to do that if your switch does not allow this), the
>cluster match decides if this node has to handle a packet given:
>
>	jhash(source IP) % total_nodes == node_id
>
>For related connections, the master conntrack is used. The following
>is an example of its use to deploy a gateway cluster composed of two
>nodes (where this is the node 1):
>
>iptables -I PREROUTING -t mangle -i eth1 -m cluster \
>	--cluster-total-nodes 2 --cluster-local-node 1 \
[...]
>
>echo +2 > /proc/sys/net/netfilter/cluster/$PROC_NAME
>
>BTW, some final notes:
>
> * This match mangles the skbuff pkt_type in case that it detects
>PACKET_MULTICAST for a non-multicast address. This may be done in
>a PKTTYPE target for this sole purpose.
> * This match supersedes the CLUSTERIP target.

The supersedes statement should also go into Kconfig.

>@@ -0,0 +1,21 @@
>+#ifndef _XT_CLUSTER_MATCH_H
>+#define _XT_CLUSTER_MATCH_H
>+
>+struct proc_dir_entry;
>+
>+enum xt_cluster_flags {
>+	XT_CLUSTER_F_INV = 0,
>+};

Hm, that should be XT_CLUSTER_F_INV = 1 << 0.

>+config NETFILTER_XT_MATCH_CLUSTER
>+	tristate '"cluster" match support'
>+	depends on NETFILTER_ADVANCED

xt_cluster depends on NF_CONNTRACK too.

>+	---help---
>+	  This option allows you to build work-load-sharing clusters of
>+	  network servers/stateful firewalls without having a dedicated
>+	  load-balancing router/server/switch. Basically, this match returns
>+	  true when the packet must be handled by this cluster node. Thus,
>+	  all nodes see all packets and this match decides which node handles
>+	  what packets. The work-load sharing algorithm is based on source
>+	  address hashing.
>+
>+	  If you say Y here, try `iptables -m cluster --help` for
>+	  more information.

Somehow this gives the impression that Y is the only logical choice,
when indeed, M would work too.

>+struct xt_cluster_internal {
>+	unsigned long		node_mask;

I think I raised concern about this, but can't remember.
Should not this be of type nodemask_t instead? Or ... is this
"node" perhaps not describing a NUMA node, but a cluster node?
Some comments would be appreciated, along the lines of

/**
 * @node_mask:	cluster node mask
 */

>+	struct proc_dir_entry	*proc;
>+	atomic_t		use;
>+};

>+static inline bool
>+xt_cluster_is_multicast_addr(const struct sk_buff *skb, int family)

Cosmetic warrants uint8_t family.

>+static bool
>+xt_cluster_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>+{
>+	struct sk_buff *pskb = (struct sk_buff *)skb;
>+	const struct xt_cluster_match_info *info = par->matchinfo;
>+	const struct xt_cluster_internal *internal = info->data;
>+	const struct nf_conn *ct;
>+	enum ip_conntrack_info ctinfo;
>+	unsigned long hash;
>+	bool inv = !!(info->flags & XT_CLUSTER_F_INV);
>+
>+	if (!xt_cluster_is_multicast_addr(skb, par->family) &&
>+	    skb->pkt_type == PACKET_MULTICAST) {
>+	    	pskb->pkt_type = PACKET_HOST;
>+	}

{} are redundant here

>+	if (ct->master)
>+		hash = xt_cluster_hash(ct->master, info);
>+	else
>+		hash = xt_cluster_hash(ct, info);
>+
>+	return test_bit(hash, &internal->node_mask) ^ inv;

Since inv is just once used, I would "inline" it, aka
	return test_bit(hash, &internal->node_mask) ^
	       !!(info->flags & XT_CLUSTER_MATCH_INV);

>+static int xt_cluster_seq_show(struct seq_file *s, void *v)
>+{
>+	unsigned long *mask = v;
>+	seq_printf(s, "0x%.8lx\n", *mask);

'.' does not make sense with non-string,non-floating point numbers
(though it is a stdc feature it seems). I'd say "0x%08lx", for clarity.

>+	case '-':
>+		new_node_id = simple_strtoul(buffer+1, NULL, 10);
>+		if (!new_node_id || new_node_id > sizeof(info->node_mask)*8)
>+			return -EIO;
>+		printk(KERN_NOTICE "cluster: deleting node %u\n", new_node_id);
>+		clear_bit(new_node_id-1, &info->node_mask);
>+		break;
>+	default:
>+		return -EIO;

EINVAL, I'd say.

>+static bool
>+xt_cluster_proc_entry_exist(struct proc_dir_entry *dir, const char *name)
>+{
>+	struct proc_dir_entry *tmp;
>+
>+	for (tmp = dir->subdir; tmp; tmp = tmp->next) {
>+		if (strcmp(tmp->name, name) == 0)
>+			return true;
>+	}

-{}


Looks good so far.
