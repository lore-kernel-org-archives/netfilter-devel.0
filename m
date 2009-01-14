From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Troubles with MARK target in 2.6.28
Date: Wed, 14 Jan 2009 06:39:40 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden> <496AE0E3.1030009@trash.net> <496AEC64.5040202@trash.net> <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr> <496AEEB0.3080905@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Nikolay S. Rybalov" <nowhere@hakkenden.ath.cx>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <496AEEB0.3080905@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Monday 2009-01-12 08:18, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> On Monday 2009-01-12 08:08, Patrick McHardy wrote:
>>> Patrick McHardy wrote:
>>>> Does this patch fix it?
>>> Jan, display of NFPROTO_UNSPEC targets and matches in
>>> /proc/net/ip_tables_targets etc. is also broken.
>>
>> I can tell it is not (more like a missing feature if you will),
>> because /proc/net/ip_t* is for IPv4 only, and /proc/net/ip6_t*
>> is for IPv6 only. I had a patch somewhere that added a better
>> overview, let's see where in my git realms that disappeared...
>
> Its supposed to show the targets and matches *available* for
> a family.

Possibly - I found no comment in the source.
But the spartanic output of those proc files barely helps (especially
in light of multiple revisions), so here is the patch I spoke about,
refreshed and rebased, that solves the worries.

parent cc46eb3e855b7c1f628e934e01b97f4f2642973e (v2.6.29-rc1-22-gcc46eb3)
commit 11d60b1b555097e613ad6548b9b695a19735dda1
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Jan 14 06:36:10 2009 +0100

netfilter: proc file for extension overview

Add a procfs file that dumps out the full Xtables target, match and
table info for all known nfprotos, superseding the IPv4/v6-only
/proc/net/ip{,6}_tables* which only provide names.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |  267 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 267 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 89837a4..8d0dac7 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -26,6 +26,7 @@
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp.h>
+#include <linux/netfilter_bridge.h>
 
 
 MODULE_LICENSE("GPL");
@@ -949,6 +950,260 @@ static const struct file_operations xt_target_ops = {
 #define	FORMAT_MATCHES	"_tables_matches"
 #define FORMAT_TARGETS 	"_tables_targets"
 
+struct xt_extinfo_trav {
+	struct seq_net_private seqnet;
+	struct list_head *head, *curr;
+	u_int8_t class, nfproto;
+};
+
+enum {
+	EXTINFO_TABLE_HDR,
+	EXTINFO_TABLE,
+	EXTINFO_TARGET_HDR,
+	EXTINFO_TARGET,
+	EXTINFO_MATCH_HDR,
+	EXTINFO_MATCH,
+	EXTINFO_LEAD_IN,
+	EXTINFO_DONE,
+};
+
+static void *xt_extinfo_seq_next(struct seq_file *seq, void *v, loff_t *ppos)
+{
+	static const u_int8_t next[] = {
+		[EXTINFO_TABLE_HDR]  = EXTINFO_TABLE,
+		[EXTINFO_TABLE]      = EXTINFO_TARGET_HDR,
+		[EXTINFO_TARGET_HDR] = EXTINFO_TARGET,
+		[EXTINFO_TARGET]     = EXTINFO_MATCH_HDR,
+		[EXTINFO_MATCH_HDR]  = EXTINFO_MATCH,
+		[EXTINFO_MATCH]      = EXTINFO_DONE,
+	};
+	struct xt_extinfo_trav *trav = seq->private;
+
+	switch (trav->class) {
+	case EXTINFO_LEAD_IN:
+		trav->class = EXTINFO_TABLE_HDR;
+		break;
+	case EXTINFO_TABLE_HDR:
+	case EXTINFO_TARGET_HDR:
+	case EXTINFO_MATCH_HDR:
+		trav->nfproto = 0;
+		mutex_lock(&xt[trav->nfproto].mutex);
+		switch (trav->class) {
+		case EXTINFO_TABLE_HDR:
+			trav->head = trav->curr =
+				&seq_file_net(seq)->xt.tables[trav->nfproto];
+			break;
+		case EXTINFO_TARGET_HDR:
+			trav->head = trav->curr = &xt[trav->nfproto].target;
+			break;
+		case EXTINFO_MATCH_HDR:
+			trav->head = trav->curr = &xt[trav->nfproto].match;
+			break;
+		}
+		trav->class = next[trav->class];
+		break;
+	case EXTINFO_TABLE:
+	case EXTINFO_TARGET:
+	case EXTINFO_MATCH:
+		trav->curr = trav->curr->next;
+		if (trav->curr != trav->head)
+			break; /* still in the game */
+
+		mutex_unlock(&xt[trav->nfproto].mutex);
+		if (++trav->nfproto >= NFPROTO_NUMPROTO) {
+			/* Done with category */
+			trav->class = next[trav->class];
+			break;
+		}
+
+		/* nfproto switchover */
+		mutex_lock(&xt[trav->nfproto].mutex);
+		switch (trav->class) {
+		case EXTINFO_TABLE:
+			trav->head = trav->curr =
+				&seq_file_net(seq)->xt.tables[trav->nfproto];
+			break;
+		case EXTINFO_TARGET:
+			trav->head = trav->curr = &xt[trav->nfproto].target;
+			break;
+		case EXTINFO_MATCH:
+			trav->head = trav->curr = &xt[trav->nfproto].match;
+			break;
+		}
+		break;
+	default:
+		return NULL;
+	}
+
+	if (ppos != NULL)
+		++*ppos;
+	return trav;
+}
+
+static void *xt_extinfo_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct xt_extinfo_trav *trav = seq->private;
+	void *ret;
+	loff_t i;
+
+	trav->class = EXTINFO_LEAD_IN;
+	for (i = 0; i < *pos; ++i)
+		if ((ret = xt_extinfo_seq_next(seq, NULL, NULL)) == NULL)
+			return NULL;
+	return trav;
+}
+
+static const char *xt_extinfo_hooks(char *buf, unsigned int hook_mask)
+{
+	if (hook_mask == 0)
+		return "*";
+
+	buf[0] = (hook_mask & (1 << NF_INET_PRE_ROUTING))  ? 'R' : '-';
+	buf[1] = (hook_mask & (1 << NF_INET_LOCAL_IN))     ? 'I' : '-';
+	buf[2] = (hook_mask & (1 << NF_INET_FORWARD))      ? 'F' : '-';
+	buf[3] = (hook_mask & (1 << NF_INET_LOCAL_OUT))    ? 'O' : '-';
+	buf[4] = (hook_mask & (1 << NF_INET_POST_ROUTING)) ? 'S' : '-';
+	buf[5] = (hook_mask & (1 << NF_BR_BROUTING))       ? 'B' : '-';
+	buf[6] = '\0';
+	return buf;
+}
+
+static const char *xt_extinfo_nfproto(char *buf, u_int8_t p)
+{
+	static const char *const names[] = {
+		[NFPROTO_UNSPEC] = "*",
+		[NFPROTO_IPV4]   = "IPv4",
+		[NFPROTO_ARP]    = "ARP",
+		[NFPROTO_BRIDGE] = "bridge",
+		[NFPROTO_IPV6]   = "IPv6",
+		[NFPROTO_DECNET] = "DECnet",
+	};
+	if (p < ARRAY_SIZE(names))
+		return names[p];
+	/* buf is at least [4] big; and p's range is 0..255 */
+	sprintf(buf, "%u", p);
+	return buf;
+}
+
+static const char *xt_extinfo_l4proto(char *buf, u_int8_t p)
+{
+	/* IPPROTO_* can be a large value; not using an array here */
+	switch (p) {
+	case 0:			return "*";
+	case IPPROTO_AH:	return "ah";
+	case IPPROTO_DCCP:	return "dccp";
+	case IPPROTO_ESP:	return "esp";
+	case IPPROTO_ICMP:	return "icmp";
+	case IPPROTO_ICMPV6:	return "icmpv6";
+	case IPPROTO_SCTP:	return "sctp";
+	case IPPROTO_TCP:	return "tcp";
+	case IPPROTO_UDP:	return "udp";
+	case IPPROTO_UDPLITE:	return "udplite";
+	case IPPROTO_MH:	return "mh";
+	default:
+		sprintf(buf, "%u", p);
+		return buf;
+	}
+}
+
+static int xt_extinfo_seq_show(struct seq_file *seq, void *v)
+{
+	struct xt_extinfo_trav *trav = seq->private;
+	const struct xt_table *table;
+	const struct xt_target *target;
+	const struct xt_match *match;
+	char hooks[7], nfproto[4], l4proto[4];
+
+	switch (trav->class) {
+	case EXTINFO_LEAD_IN:
+		return seq_printf(seq, "# format version 1\n");
+	case EXTINFO_TABLE_HDR:
+		return seq_printf(seq, "# -- Tables --\n"
+		       "# type\t" "%-13s\t\t\t" "nfproto\t\t"
+		       "hooks\n", "Name");
+	case EXTINFO_TABLE:
+		if (trav->curr == trav->head)
+			return 0;
+		table = list_entry(trav->curr, struct xt_table, list);
+		/*
+		 * The leading type identifier is so that sorting the output
+		 * produces a meaningful result, i.e. that targets remain
+		 * distinguishable from matches even when mixed.
+		 */
+		return seq_printf(seq, "table\t%-15s\t\t\t%s\t\t%s\n",
+		       table->name, xt_extinfo_nfproto(nfproto, table->af),
+		       xt_extinfo_hooks(hooks, table->valid_hooks));
+	case EXTINFO_TARGET_HDR:
+		return seq_printf(seq, "# -- Targets --\n"
+		       "# type\t" "%-13s\t" "rev\t" "table\t" "nfproto\t"
+		       "l4proto\t" "hooks\t" "tgsize\n", "Name");
+	case EXTINFO_TARGET:
+		if (trav->curr == trav->head)
+			return 0;
+		target = list_entry(trav->curr, struct xt_target, list);
+		/*
+		 * Last field's %d is correct despite it being unsigned -
+		 * "-1" might be used in exceptions.
+		 */
+		return seq_printf(seq, "target\t%-15s\t%u\t%s\t%s\t"
+		       "%s\t%s\t%6d\n",
+		       (*target->name == '\0') ? "(standard)" : target->name,
+		       target->revision, target->table ? : "*",
+		       xt_extinfo_nfproto(nfproto, target->family),
+		       xt_extinfo_l4proto(l4proto, target->proto),
+		       xt_extinfo_hooks(hooks, target->hooks),
+		       target->targetsize);
+	case EXTINFO_MATCH_HDR:
+		return seq_printf(seq, "# -- Matches --\n"
+		       "# type\t" "%-13s\t" "rev\t" "table\t" "nfproto\t"
+		       "l4proto\t" "hooks\t" "mtsize\n", "Name");
+	case EXTINFO_MATCH:
+		if (trav->curr == trav->head)
+			return 0;
+		match = list_entry(trav->curr, struct xt_match, list);
+		return seq_printf(seq, "match\t%-15s\t%u\t%s\t%s\t"
+		       "%s\t%s\t%6d\n",
+		       match->name, match->revision, match->table ? : "*",
+		       xt_extinfo_nfproto(nfproto, match->family),
+		       xt_extinfo_l4proto(l4proto, match->proto),
+		       xt_extinfo_hooks(hooks, match->hooks), match->matchsize);
+	}
+	return 0;
+}
+
+static void xt_extinfo_seq_stop(struct seq_file *seq, void *v)
+{
+	struct xt_extinfo_trav *trav = seq->private;
+
+	switch (trav->class) {
+	case EXTINFO_TABLE:
+	case EXTINFO_TARGET:
+	case EXTINFO_MATCH:
+		mutex_unlock(&xt[trav->nfproto].mutex);
+	}
+	/* in all other cases, no lock is currently held */
+}
+
+static const struct seq_operations xt_extinfo_seq_ops = {
+	.start	= xt_extinfo_seq_start,
+	.next	= xt_extinfo_seq_next,
+	.stop	= xt_extinfo_seq_stop,
+	.show	= xt_extinfo_seq_show,
+};
+
+static int xt_extinfo_open(struct inode *inode, struct file *file)
+{
+	return seq_open_net(inode, file, &xt_extinfo_seq_ops,
+	       sizeof(struct xt_extinfo_trav));
+}
+
+static const struct file_operations xt_extinfo_fops = {
+	.open    = xt_extinfo_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release_net,
+};
+
 #endif /* CONFIG_PROC_FS */
 
 int xt_proto_init(struct net *net, u_int8_t af)
@@ -1025,15 +1280,27 @@ EXPORT_SYMBOL_GPL(xt_proto_fini);
 
 static int __net_init xt_net_init(struct net *net)
 {
+	struct proc_dir_entry *proc;
 	int i;
 
+	proc = proc_create_data("xtables_info", S_IRUGO, net->proc_net,
+	       &xt_extinfo_fops, NULL);
+	if (proc == NULL)
+		return -EINVAL;
+
 	for (i = 0; i < NFPROTO_NUMPROTO; i++)
 		INIT_LIST_HEAD(&net->xt.tables[i]);
 	return 0;
 }
 
+static void __net_exit xt_net_exit(struct net *net)
+{
+	remove_proc_entry("xtables_info", net->proc_net);
+}
+
 static struct pernet_operations xt_net_ops = {
 	.init = xt_net_init,
+	.exit = xt_net_exit,
 };
 
 static int __init xt_init(void)
-- 
# Created with git-export-patch
