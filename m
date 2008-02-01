From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [00/..] patches patches!
Date: Fri, 1 Feb 2008 13:49:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802011337000.4864@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801312315120.4864@fbirervta.pbzchgretzou.qr>
 <47A2EEFA.9060906@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41473 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbYBAMuB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:50:01 -0500
In-Reply-To: <47A2EEFA.9060906@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 1 2008 11:05, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Hi :)
>> 
>> 
>> to make this evening still interesting, I have:
>> 
>> - 13 kernel patches, as replies to this thread.
>> 
>>   The way it looks from a quick grep is that all non-IPv4/v6-centric matches
>>   are now IPv6 capable - yay!
>
> Great :) Dave declared that only non-features should be merged
> from now on.

That's real sad - because it would have wrapped up the package
perfectly. Please reconsider these small improvements (7-10,13).

Categories:
01-04 constifying
   05 fix
   06 fix non-released feature
   07 'feature'?
   08 ebt_ip6, feature.
   09 rename - belongs to what category?
   10 xt_recent/AF_INET6, feature.
   11 fix non-released feature
   12 fix?
   13 I'd call it both a feature and fix, it avoids
      a(nother) [user-visible] flagday later.

> The constifying is no big deal I guess, but could
> you combine all of these in one big patch please? The remaining
> fixes are obviously fine, also the patches fixing non-released
> features. Everything else will have to wait for 2.6.26, but I
> can queue it for you.

01-04 combo below.

===
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Jan 25 20:52:56 2008 +0100

    [NETFILTER]: Annotate a few more places with const and remove casts

    - xtables targets
    - {arp,ip,ip6,x}tables
    - rest of nf_conntrack_* files
    - rest of nf_nat_* files
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b2c62cc..2326296 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -430,13 +430,13 @@ extern int xt_compat_add_offset(int af, unsigned int offset, short delta);
 extern void xt_compat_flush_offsets(int af);
 extern short xt_compat_calc_jump(int af, unsigned int offset);
 
-extern int xt_compat_match_offset(struct xt_match *match);
+extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
 				     void **dstptr, unsigned int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
 				   void __user **dstptr, unsigned int *size);
 
-extern int xt_compat_target_offset(struct xt_target *target);
+extern int xt_compat_target_offset(const struct xt_target *target);
 extern void xt_compat_target_from_user(struct xt_entry_target *t,
 				       void **dstptr, unsigned int *size);
 extern int xt_compat_target_to_user(struct xt_entry_target *t,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index a7591ce..4191588 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -59,7 +59,7 @@ do {								\
 #endif
 
 static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
-				      char *hdr_addr, int len)
+				      const char *hdr_addr, int len)
 {
 	int i, ret;
 
@@ -80,8 +80,8 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 				   const char *outdev,
 				   const struct arpt_arp *arpinfo)
 {
-	char *arpptr = (char *)(arphdr + 1);
-	char *src_devaddr, *tgt_devaddr;
+	const char *arpptr = (char *)(arphdr + 1);
+	const char *src_devaddr, *tgt_devaddr;
 	__be32 src_ipaddr, tgt_ipaddr;
 	int i, ret;
 
@@ -226,12 +226,12 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 {
 	static const char nulldevname[IFNAMSIZ];
 	unsigned int verdict = NF_DROP;
-	struct arphdr *arp;
+	const struct arphdr *arp;
 	bool hotdrop = false;
 	struct arpt_entry *e, *back;
-	const char *indev, *outdev;
+	const const char *indev, *outdev;
 	void *table_base;
-	struct xt_table_info *private;
+	const struct xt_table_info *private;
 
 	/* ARP header, plus 2 device addresses, plus 2 IP addresses.  */
 	if (!pskb_may_pull(skb, (sizeof(struct arphdr) +
@@ -355,7 +355,7 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 		e->counters.pcnt = pos;
 
 		for (;;) {
-			struct arpt_standard_target *t
+			const struct arpt_standard_target *t
 				= (void *)arpt_get_target(e);
 			int visited = e->comefrom & (1 << hook);
 
@@ -440,7 +440,7 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 
 static inline int check_entry(struct arpt_entry *e, const char *name)
 {
-	struct arpt_entry_target *t;
+	const struct arpt_entry_target *t;
 
 	if (!arp_checkentry(&e->arp)) {
 		duprintf("arp_tables: arp check failed %p %s.\n", e, name);
@@ -713,7 +713,7 @@ static inline struct xt_counters *alloc_counters(struct arpt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -740,7 +740,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -875,7 +875,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 				    "arptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 
 #ifdef CONFIG_COMPAT
 		if (compat) {
@@ -930,7 +930,8 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	t = xt_find_table_lock(net, NF_ARP, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
+
 		duprintf("t->private->number = %u\n",
 			 private->number);
 		if (get.size == private->size)
@@ -1090,11 +1091,11 @@ static int do_add_counters(struct net *net, void __user *user, unsigned int len,
 	struct xt_counters_info tmp;
 	struct xt_counters *paddc;
 	unsigned int num_counters;
-	char *name;
+	const char *name;
 	int size;
 	void *ptmp;
 	struct arpt_table *t;
-	struct xt_table_info *private;
+	const struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
 #ifdef CONFIG_COMPAT
@@ -1561,7 +1562,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
@@ -1612,7 +1613,7 @@ static int compat_get_entries(struct net *net,
 	xt_compat_lock(NF_ARP);
 	t = xt_find_table_lock(net, NF_ARP, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 
 		duprintf("t->private->number = %u\n", private->number);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 45fa4e2..10517d6 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -15,7 +15,7 @@ target(struct sk_buff *skb,
        const void *targinfo)
 {
 	const struct arpt_mangle *mangle = targinfo;
-	struct arphdr *arp;
+	const struct arphdr *arp;
 	unsigned char *arpptr;
 	int pln, hln;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 600737f..eb3ec74 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -296,7 +296,7 @@ static void trace_packet(struct sk_buff *skb,
 			 struct ipt_entry *e)
 {
 	void *table_base;
-	struct ipt_entry *root;
+	const struct ipt_entry *root;
 	char *hookname, *chainname, *comment;
 	unsigned int rulenum = 0;
 
@@ -327,7 +327,7 @@ ipt_do_table(struct sk_buff *skb,
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	u_int16_t offset;
-	struct iphdr *ip;
+	const struct iphdr *ip;
 	u_int16_t datalen;
 	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
@@ -926,7 +926,7 @@ static struct xt_counters * alloc_counters(struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -953,9 +953,9 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	struct ipt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
-	void *loc_cpu_entry;
+	const void *loc_cpu_entry;
 
 	counters = alloc_counters(table);
 	if (IS_ERR(counters))
@@ -975,8 +975,8 @@ copy_entries_to_user(unsigned int total_size,
 	/* ... then go back and fix counters and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
 		unsigned int i;
-		struct ipt_entry_match *m;
-		struct ipt_entry_target *t;
+		const struct ipt_entry_match *m;
+		const struct ipt_entry_target *t;
 
 		e = (struct ipt_entry *)(loc_cpu_entry + off);
 		if (copy_to_user(userptr + off
@@ -1116,7 +1116,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 				    "iptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ipt_getinfo info;
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 
 #ifdef CONFIG_COMPAT
 		if (compat) {
@@ -1172,7 +1172,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr, int *len)
 
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		duprintf("t->private->number = %u\n", private->number);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1337,11 +1337,11 @@ do_add_counters(struct net *net, void __user *user, unsigned int len, int compat
 	struct xt_counters_info tmp;
 	struct xt_counters *paddc;
 	unsigned int num_counters;
-	char *name;
+	const char *name;
 	int size;
 	void *ptmp;
 	struct xt_table *t;
-	struct xt_table_info *private;
+	const struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
 #ifdef CONFIG_COMPAT
@@ -1878,11 +1878,11 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
-	void *loc_cpu_entry;
+	const void *loc_cpu_entry;
 	unsigned int i = 0;
 
 	counters = alloc_counters(table);
@@ -1929,7 +1929,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
@@ -2130,7 +2130,8 @@ icmp_match(const struct sk_buff *skb,
 	   unsigned int protoff,
 	   bool *hotdrop)
 {
-	struct icmphdr _icmph, *ic;
+	const struct icmphdr *ic;
+	struct icmphdr _icmph;
 	const struct ipt_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index c6cf84c..b8c793c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -142,7 +142,7 @@ clusterip_config_init_nodelist(struct clusterip_config *c,
 }
 
 static struct clusterip_config *
-clusterip_config_init(struct ipt_clusterip_tgt_info *i, __be32 ip,
+clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 			struct net_device *dev)
 {
 	struct clusterip_config *c;
@@ -417,7 +417,7 @@ clusterip_tg_check(const char *tablename, const void *e_void,
 /* drop reference count of cluster config when rule is deleted */
 static void clusterip_tg_destroy(const struct xt_target *target, void *targinfo)
 {
-	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
+	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
 
 	/* if no more entries are referencing the config, remove it
 	 * from the list and destroy the proc entry */
@@ -566,7 +566,7 @@ struct clusterip_seq_position {
 
 static void *clusterip_seq_start(struct seq_file *s, loff_t *pos)
 {
-	struct proc_dir_entry *pde = s->private;
+	const struct proc_dir_entry *pde = s->private;
 	struct clusterip_config *c = pde->data;
 	unsigned int weight;
 	u_int32_t local_nodes;
@@ -593,7 +593,7 @@ static void *clusterip_seq_start(struct seq_file *s, loff_t *pos)
 
 static void *clusterip_seq_next(struct seq_file *s, void *v, loff_t *pos)
 {
-	struct clusterip_seq_position *idx = (struct clusterip_seq_position *)v;
+	struct clusterip_seq_position *idx = v;
 
 	*pos = ++idx->pos;
 	if (*pos >= idx->weight) {
@@ -612,7 +612,7 @@ static void clusterip_seq_stop(struct seq_file *s, void *v)
 
 static int clusterip_seq_show(struct seq_file *s, void *v)
 {
-	struct clusterip_seq_position *idx = (struct clusterip_seq_position *)v;
+	struct clusterip_seq_position *idx = v;
 
 	if (idx->pos != 0)
 		seq_putc(s, ',');
@@ -668,7 +668,7 @@ static ssize_t clusterip_proc_write(struct file *file, const char __user *input,
 {
 #define PROC_WRITELEN	10
 	char buffer[PROC_WRITELEN+1];
-	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct clusterip_config *c = pde->data;
 	unsigned long nodenum;
 
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index 21395bc..d60139c 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -100,7 +100,7 @@ ecn_tg_check(const char *tablename, const void *e_void,
              const struct xt_target *target, void *targinfo,
              unsigned int hook_mask)
 {
-	const struct ipt_ECN_info *einfo = (struct ipt_ECN_info *)targinfo;
+	const struct ipt_ECN_info *einfo = targinfo;
 	const struct ipt_entry *e = e_void;
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index b38d785..77300e9 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -76,7 +76,8 @@ static void dump_packet(const struct nf_loginfo *info,
 
 	if ((logflags & IPT_LOG_IPOPT)
 	    && ih->ihl * 4 > sizeof(struct iphdr)) {
-		unsigned char _opt[4 * 15 - sizeof(struct iphdr)], *op;
+		const unsigned char *op;
+		unsigned char _opt[4 * 15 - sizeof(struct iphdr)];
 		unsigned int i, optsize;
 
 		optsize = ih->ihl * 4 - sizeof(struct iphdr);
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 22606e2..2639872 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -35,8 +35,10 @@ MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv4");
 static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
-	struct iphdr *oiph, *niph;
-	struct tcphdr _otcph, *oth, *tcph;
+	const struct iphdr *oiph;
+	struct iphdr *niph;
+	const struct tcphdr *oth;
+	struct tcphdr _otcph, *tcph;
 	unsigned int addr_type;
 
 	/* IP header checks: fragment. */
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 68cbe3c..f2142b7 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -339,7 +339,7 @@ static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
 static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct recent_iter_state *st = seq->private;
-	struct recent_table *t = st->table;
+	const struct recent_table *t = st->table;
 	struct recent_entry *e = v;
 	struct list_head *head = e->list.next;
 
@@ -360,7 +360,7 @@ static void recent_seq_stop(struct seq_file *s, void *v)
 
 static int recent_seq_show(struct seq_file *seq, void *v)
 {
-	struct recent_entry *e = v;
+	const struct recent_entry *e = v;
 	unsigned int i;
 
 	i = (e->index - 1) % ip_pkt_list_tot;
@@ -395,7 +395,7 @@ static int recent_seq_open(struct inode *inode, struct file *file)
 static ssize_t recent_proc_write(struct file *file, const char __user *input,
 				 size_t size, loff_t *loff)
 {
-	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
 	struct recent_table *t = pde->data;
 	struct recent_entry *e;
 	char buf[sizeof("+255.255.255.255")], *c = buf;
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index dd07362..afdcd8d 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -150,9 +150,9 @@ find_appropriate_src(const struct nf_conntrack_tuple *tuple,
 		     const struct nf_nat_range *range)
 {
 	unsigned int h = hash_by_src(tuple);
-	struct nf_conn_nat *nat;
-	struct nf_conn *ct;
-	struct hlist_node *n;
+	const struct nf_conn_nat *nat;
+	const struct nf_conn *ct;
+	const struct hlist_node *n;
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(nat, n, &bysource[h], bysource) {
@@ -426,7 +426,7 @@ int nf_nat_icmp_reply_translation(struct nf_conn *ct,
 		struct icmphdr icmp;
 		struct iphdr ip;
 	} *inside;
-	struct nf_conntrack_l4proto *l4proto;
+	const struct nf_conntrack_l4proto *l4proto;
 	struct nf_conntrack_tuple inner, target;
 	int hdrlen = ip_hdrlen(skb);
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index f8fda57..600f6d7 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -143,7 +143,7 @@ static bool ipt_snat_checkentry(const char *tablename,
 				void *targinfo,
 				unsigned int hook_mask)
 {
-	struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
@@ -159,7 +159,7 @@ static bool ipt_dnat_checkentry(const char *tablename,
 				void *targinfo,
 				unsigned int hook_mask)
 {
-	struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
diff --git a/net/ipv4/netfilter/nf_nat_snmp_basic.c b/net/ipv4/netfilter/nf_nat_snmp_basic.c
index 540ce6a..0c695c0 100644
--- a/net/ipv4/netfilter/nf_nat_snmp_basic.c
+++ b/net/ipv4/netfilter/nf_nat_snmp_basic.c
@@ -219,7 +219,7 @@ static unsigned char asn1_length_decode(struct asn1_ctx *ctx,
 		if (ch < 0x80)
 			*len = ch;
 		else {
-			cnt = (unsigned char) (ch & 0x7F);
+			cnt = ch & 0x7F;
 			*len = 0;
 
 			while (cnt > 0) {
@@ -617,8 +617,7 @@ struct snmp_cnv
 	int syntax;
 };
 
-static struct snmp_cnv snmp_conv [] =
-{
+static const struct snmp_cnv snmp_conv[] = {
 	{ASN1_UNI, ASN1_NUL, SNMP_NULL},
 	{ASN1_UNI, ASN1_INT, SNMP_INTEGER},
 	{ASN1_UNI, ASN1_OTS, SNMP_OCTETSTR},
@@ -643,7 +642,7 @@ static unsigned char snmp_tag_cls2syntax(unsigned int tag,
 					 unsigned int cls,
 					 unsigned short *syntax)
 {
-	struct snmp_cnv *cnv;
+	const struct snmp_cnv *cnv;
 
 	cnv = snmp_conv;
 
@@ -903,7 +902,7 @@ static inline void mangle_address(unsigned char *begin,
 		u_int32_t old;
 
 		if (debug)
-			memcpy(&old, (unsigned char *)addr, sizeof(old));
+			memcpy(&old, addr, sizeof(old));
 
 		*addr = map->to;
 
@@ -998,7 +997,7 @@ err_id_free:
  *
  *****************************************************************************/
 
-static void hex_dump(unsigned char *buf, size_t len)
+static void hex_dump(const unsigned char *buf, size_t len)
 {
 	size_t i;
 
@@ -1079,7 +1078,7 @@ static int snmp_parse_mangle(unsigned char *msg,
 	if (cls != ASN1_CTX || con != ASN1_CON)
 		return 0;
 	if (debug > 1) {
-		unsigned char *pdus[] = {
+		static const unsigned char *const pdus[] = {
 			[SNMP_PDU_GET] = "get",
 			[SNMP_PDU_NEXT] = "get-next",
 			[SNMP_PDU_RESPONSE] = "response",
@@ -1231,8 +1230,8 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 {
 	int dir = CTINFO2DIR(ctinfo);
 	unsigned int ret;
-	struct iphdr *iph = ip_hdr(skb);
-	struct udphdr *udph = (struct udphdr *)((u_int32_t *)iph + iph->ihl);
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct udphdr *udph = (struct udphdr *)((__be32 *)iph + iph->ihl);
 
 	/* SNMP replies and originating SNMP traps get mangled */
 	if (udph->source == htons(SNMP_PORT) && dir != IP_CT_DIR_REPLY)
diff --git a/net/ipv4/netfilter/nf_nat_standalone.c b/net/ipv4/netfilter/nf_nat_standalone.c
index 99b2c78..9fba42d 100644
--- a/net/ipv4/netfilter/nf_nat_standalone.c
+++ b/net/ipv4/netfilter/nf_nat_standalone.c
@@ -30,8 +30,8 @@
 #ifdef CONFIG_XFRM
 static void nat_decode_session(struct sk_buff *skb, struct flowi *fl)
 {
-	struct nf_conn *ct;
-	struct nf_conntrack_tuple *t;
+	const struct nf_conn *ct;
+	const struct nf_conntrack_tuple *t;
 	enum ip_conntrack_info ctinfo;
 	enum ip_conntrack_dir dir;
 	unsigned long statusbit;
@@ -189,7 +189,7 @@ nf_nat_out(unsigned int hooknum,
 	   int (*okfn)(struct sk_buff *))
 {
 #ifdef CONFIG_XFRM
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 #endif
 	unsigned int ret;
@@ -223,7 +223,7 @@ nf_nat_local_fn(unsigned int hooknum,
 		const struct net_device *out,
 		int (*okfn)(struct sk_buff *))
 {
-	struct nf_conn *ct;
+	const struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int ret;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index bf9bb6e..743b108 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -325,7 +325,7 @@ static void trace_packet(struct sk_buff *skb,
 			 struct ip6t_entry *e)
 {
 	void *table_base;
-	struct ip6t_entry *root;
+	const struct ip6t_entry *root;
 	char *hookname, *chainname, *comment;
 	unsigned int rulenum = 0;
 
@@ -952,7 +952,7 @@ static struct xt_counters *alloc_counters(struct xt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
@@ -979,9 +979,9 @@ copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	struct ip6t_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
-	void *loc_cpu_entry;
+	const void *loc_cpu_entry;
 
 	counters = alloc_counters(table);
 	if (IS_ERR(counters))
@@ -1001,8 +1001,8 @@ copy_entries_to_user(unsigned int total_size,
 	/* ... then go back and fix counters and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
 		unsigned int i;
-		struct ip6t_entry_match *m;
-		struct ip6t_entry_target *t;
+		const struct ip6t_entry_match *m;
+		const struct ip6t_entry_target *t;
 
 		e = (struct ip6t_entry *)(loc_cpu_entry + off);
 		if (copy_to_user(userptr + off
@@ -1142,7 +1142,7 @@ static int get_info(struct net *net, void __user *user, int *len, int compat)
 				    "ip6table_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 
 #ifdef CONFIG_COMPAT
 		if (compat) {
@@ -1225,7 +1225,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_table *t;
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
-	void *loc_cpu_old_entry;
+	const void *loc_cpu_old_entry;
 
 	ret = 0;
 	counters = vmalloc_node(num_counters * sizeof(struct xt_counters),
@@ -1369,9 +1369,9 @@ do_add_counters(struct net *net, void __user *user, unsigned int len,
 	int size;
 	void *ptmp;
 	struct xt_table *t;
-	struct xt_table_info *private;
+	const struct xt_table_info *private;
 	int ret = 0;
-	void *loc_cpu_entry;
+	const void *loc_cpu_entry;
 #ifdef CONFIG_COMPAT
 	struct compat_xt_counters_info compat_tmp;
 
@@ -1905,11 +1905,11 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 			    void __user *userptr)
 {
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
-	void *loc_cpu_entry;
+	const void *loc_cpu_entry;
 	unsigned int i = 0;
 
 	counters = alloc_counters(table);
@@ -1956,7 +1956,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
@@ -2155,7 +2155,8 @@ icmp6_match(const struct sk_buff *skb,
 	   unsigned int protoff,
 	   bool *hotdrop)
 {
-	struct icmp6hdr _icmph, *ic;
+	const struct icmp6hdr *ic;
+	struct icmp6hdr _icmph;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index b23baa6..c779d76 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -41,7 +41,8 @@ static void send_reset(struct sk_buff *oldskb)
 	struct tcphdr otcph, *tcph;
 	unsigned int otcplen, hh_len;
 	int tcphoff, needs_ack;
-	struct ipv6hdr *oip6h = ipv6_hdr(oldskb), *ip6h;
+	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
+	struct ipv6hdr *ip6h;
 	struct dst_entry *dst = NULL;
 	u8 proto;
 	struct flowi fl;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 3a94017..317a896 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -49,7 +49,8 @@ ipv6header_mt6(const struct sk_buff *skb, const struct net_device *in,
 	temp = 0;
 
 	while (ip6t_ext_hdr(nexthdr)) {
-		struct ipv6_opt_hdr _hdr, *hp;
+		const struct ipv6_opt_hdr *hp;
+		struct ipv6_opt_hdr _hdr;
 		int hdrlen;
 
 		/* Is there enough space for the next ext header? */
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 12a9efe..81aaf7a 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -110,7 +110,8 @@ rt_mt6(const struct sk_buff *skb, const struct net_device *in,
 		!!(rtinfo->invflags & IP6T_RT_INV_TYP)));
 
 	if (ret && (rtinfo->flags & IP6T_RT_RES)) {
-		u_int32_t *rp, _reserved;
+		const u_int32_t *rp;
+		u_int32_t _reserved;
 		rp = skb_header_pointer(skb,
 					ptr + offsetof(struct rt0_hdr,
 						       reserved),
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 2a0d698..d4a42f0 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -103,8 +103,8 @@ struct ctl_table nf_ct_ipv6_sysctl_table[] = {
 };
 #endif
 
-static unsigned int ip6qhashfn(__be32 id, struct in6_addr *saddr,
-			       struct in6_addr *daddr)
+static unsigned int ip6qhashfn(__be32 id, const struct in6_addr *saddr,
+                               const struct in6_addr *daddr)
 {
 	u32 a, b, c;
 
@@ -132,7 +132,7 @@ static unsigned int ip6qhashfn(__be32 id, struct in6_addr *saddr,
 
 static unsigned int nf_hashfn(struct inet_frag_queue *q)
 {
-	struct nf_ct_frag6_queue *nq;
+	const struct nf_ct_frag6_queue *nq;
 
 	nq = container_of(q, struct nf_ct_frag6_queue, q);
 	return ip6qhashfn(nq->id, &nq->saddr, &nq->daddr);
@@ -220,7 +220,7 @@ oom:
 
 
 static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
-			     struct frag_hdr *fhdr, int nhoff)
+			     const struct frag_hdr *fhdr, int nhoff)
 {
 	struct sk_buff *prev, *next;
 	int offset, end;
diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 7b8239c..572eedf 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -53,7 +53,7 @@ enum amanda_strings {
 };
 
 static struct {
-	char			*string;
+	const char		*string;
 	size_t			len;
 	struct ts_config	*ts;
 } search[] __read_mostly = {
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 6770baf..e0a2877 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -350,8 +350,9 @@ static int help(struct sk_buff *skb,
 		enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff, datalen;
-	struct tcphdr _tcph, *th;
-	char *fb_ptr;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
+	const char *fb_ptr;
 	int ret;
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b1fd21c..367e23c 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -125,7 +125,7 @@ void nf_conntrack_helper_unregister(struct nf_conntrack_helper *me)
 {
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_expect *exp;
-	struct hlist_node *n, *next;
+	const struct hlist_node *n, *next;
 	unsigned int i;
 
 	mutex_lock(&nf_ct_helper_mutex);
diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index c336b07..37a5ae5 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -50,7 +50,7 @@ MODULE_PARM_DESC(max_dcc_channels, "max number of expected DCC channels per "
 module_param(dcc_timeout, uint, 0400);
 MODULE_PARM_DESC(dcc_timeout, "timeout on for unestablished DCC channels");
 
-static const char *dccprotos[] = {
+static const char *const dccprotos[] = {
 	"SEND ", "CHAT ", "MOVE ", "TSEND ", "SCHAT "
 };
 
@@ -65,7 +65,7 @@ static const char *dccprotos[] = {
  *	ad_beg_p	returns pointer to first byte of addr data
  *	ad_end_p	returns pointer to last byte of addr data
  */
-static int parse_dcc(char *data, char *data_end, u_int32_t *ip,
+static int parse_dcc(char *data, const char *data_end, u_int32_t *ip,
 		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
 {
 	/* at least 12: "AAAAAAAA P\1\n" */
@@ -93,9 +93,11 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 		struct nf_conn *ct, enum ip_conntrack_info ctinfo)
 {
 	unsigned int dataoff;
-	struct iphdr *iph;
-	struct tcphdr _tcph, *th;
-	char *data, *data_limit, *ib_ptr;
+	const struct iphdr *iph;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
+	const char *data_limit;
+	char *data, *ib_ptr;
 	int dir = CTINFO2DIR(ctinfo);
 	struct nf_conntrack_expect *exp;
 	struct nf_conntrack_tuple *tuple;
@@ -159,7 +161,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 			/* we have at least
 			 * (19+MINMATCHLEN)-5-dccprotos[i].matchlen bytes valid
 			 * data left (== 14/13 bytes) */
-			if (parse_dcc((char *)data, data_limit, &dcc_ip,
+			if (parse_dcc(data, data_limit, &dcc_ip,
 				       &dcc_port, &addr_beg_p, &addr_end_p)) {
 				pr_debug("unable to parse dcc command\n");
 				continue;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index a679208..4d74dff 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -58,7 +58,7 @@ static struct xt_af *xt;
 #define duprintf(format, args...)
 #endif
 
-static const char *xt_prefix[NPROTO] = {
+static const char *const xt_prefix[NPROTO] = {
 	[AF_INET]	= "ip",
 	[AF_INET6]	= "ip6",
 	[NF_ARP]	= "arp",
@@ -248,7 +248,7 @@ EXPORT_SYMBOL_GPL(xt_request_find_target);
 
 static int match_revfn(int af, const char *name, u8 revision, int *bestp)
 {
-	struct xt_match *m;
+	const struct xt_match *m;
 	int have_rev = 0;
 
 	list_for_each_entry(m, &xt[af].match, list) {
@@ -264,7 +264,7 @@ static int match_revfn(int af, const char *name, u8 revision, int *bestp)
 
 static int target_revfn(int af, const char *name, u8 revision, int *bestp)
 {
-	struct xt_target *t;
+	const struct xt_target *t;
 	int have_rev = 0;
 
 	list_for_each_entry(t, &xt[af].target, list) {
@@ -385,7 +385,7 @@ short xt_compat_calc_jump(int af, unsigned int offset)
 }
 EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
 
-int xt_compat_match_offset(struct xt_match *match)
+int xt_compat_match_offset(const struct xt_match *match)
 {
 	u_int16_t csize = match->compatsize ? : match->matchsize;
 	return XT_ALIGN(match->matchsize) - COMPAT_XT_ALIGN(csize);
@@ -395,7 +395,7 @@ EXPORT_SYMBOL_GPL(xt_compat_match_offset);
 int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 			      unsigned int *size)
 {
-	struct xt_match *match = m->u.kernel.match;
+	const struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
 	int pad, off = xt_compat_match_offset(match);
 	u_int16_t msize = cm->u.user.match_size;
@@ -422,7 +422,7 @@ EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
 			    unsigned int *size)
 {
-	struct xt_match *match = m->u.kernel.match;
+	const struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match __user *cm = *dstptr;
 	int off = xt_compat_match_offset(match);
 	u_int16_t msize = m->u.user.match_size - off;
@@ -479,7 +479,7 @@ int xt_check_target(const struct xt_target *target, unsigned short family,
 EXPORT_SYMBOL_GPL(xt_check_target);
 
 #ifdef CONFIG_COMPAT
-int xt_compat_target_offset(struct xt_target *target)
+int xt_compat_target_offset(const struct xt_target *target)
 {
 	u_int16_t csize = target->compatsize ? : target->targetsize;
 	return XT_ALIGN(target->targetsize) - COMPAT_XT_ALIGN(csize);
@@ -489,7 +489,7 @@ EXPORT_SYMBOL_GPL(xt_compat_target_offset);
 void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 				unsigned int *size)
 {
-	struct xt_target *target = t->u.kernel.target;
+	const struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target *ct = (struct compat_xt_entry_target *)t;
 	int pad, off = xt_compat_target_offset(target);
 	u_int16_t tsize = ct->u.user.target_size;
@@ -515,7 +515,7 @@ EXPORT_SYMBOL_GPL(xt_compat_target_from_user);
 int xt_compat_target_to_user(struct xt_entry_target *t, void __user **dstptr,
 			     unsigned int *size)
 {
-	struct xt_target *target = t->u.kernel.target;
+	const struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target __user *ct = *dstptr;
 	int off = xt_compat_target_offset(target);
 	u_int16_t tsize = t->u.user.target_size - off;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 1faa913..211189e 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -55,7 +55,7 @@ static void secmark_save(const struct sk_buff *skb)
 static void secmark_restore(struct sk_buff *skb)
 {
 	if (!skb->secmark) {
-		struct nf_conn *ct;
+		const struct nf_conn *ct;
 		enum ip_conntrack_info ctinfo;
 
 		ct = nf_ct_get(skb, &ctinfo);
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 24c73ba..64d6ad3 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -96,7 +96,7 @@ xt_rateest_tg_checkentry(const char *tablename,
 			 void *targinfo,
 			 unsigned int hook_mask)
 {
-	struct xt_rateest_target_info *info = (void *)targinfo;
+	struct xt_rateest_target_info *info = targinfo;
 	struct xt_rateest *est;
 	struct {
 		struct nlattr		opt;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 3b01119..0ca9fe9 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -106,10 +106,10 @@ static int count_them(struct xt_connlimit_data *data,
 		      const union nf_inet_addr *mask,
 		      const struct xt_match *match)
 {
-	struct nf_conntrack_tuple_hash *found;
+	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
-	struct nf_conn *found_ct;
+	const struct nf_conn *found_ct;
 	struct list_head *hash;
 	bool addit = true;
 	int matches = 0;
@@ -256,7 +256,7 @@ connlimit_mt_check(const char *tablename, const void *ip,
 static void
 connlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
 {
-	struct xt_connlimit_info *info = matchinfo;
+	const struct xt_connlimit_info *info = matchinfo;
 	struct xt_connlimit_conn *conn;
 	struct xt_connlimit_conn *tmp;
 	struct list_head *hash = info->data->iphash;
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 667f45e..8b65221 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -98,7 +98,8 @@ dccp_mt(const struct sk_buff *skb, const struct net_device *in,
         const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct xt_dccp_info *info = matchinfo;
-	struct dccp_hdr _dh, *dh;
+	const struct dccp_hdr *dh;
+	struct dccp_hdr _dh;
 
 	if (offset)
 		return false;
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 71c7c37..a133eb9 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -47,7 +47,8 @@ esp_mt(const struct sk_buff *skb, const struct net_device *in,
        const struct net_device *out, const struct xt_match *match,
        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct ip_esp_hdr _esp, *eh;
+	const struct ip_esp_hdr *eh;
+	struct ip_esp_hdr _esp;
 	const struct xt_esp *espinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 31daa81..fd88c48 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -100,7 +100,8 @@ multiport_mt_v0(const struct sk_buff *skb, const struct net_device *in,
                 const void *matchinfo, int offset, unsigned int protoff,
                 bool *hotdrop)
 {
-	__be16 _ports[2], *pptr;
+	const __be16 *pptr;
+	__be16 _ports[2];
 	const struct xt_multiport *multiinfo = matchinfo;
 
 	if (offset)
@@ -126,7 +127,8 @@ multiport_mt(const struct sk_buff *skb, const struct net_device *in,
              const void *matchinfo, int offset, unsigned int protoff,
              bool *hotdrop)
 {
-	__be16 _ports[2], *pptr;
+	const __be16 *pptr;
+	__be16 _ports[2];
 	const struct xt_multiport_v1 *multiinfo = matchinfo;
 
 	if (offset)
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 9e918ad..d351582 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -136,7 +136,7 @@ policy_mt_check(const char *tablename, const void *ip_void,
                 const struct xt_match *match, void *matchinfo,
                 unsigned int hook_mask)
 {
-	struct xt_policy_info *info = matchinfo;
+	const struct xt_policy_info *info = matchinfo;
 
 	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))) {
 		printk(KERN_ERR "xt_policy: neither incoming nor "
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index fdb86a5..ebd84f1 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -86,7 +86,7 @@ static bool xt_rateest_mt_checkentry(const char *tablename,
 				     void *matchinfo,
 				     unsigned int hook_mask)
 {
-	struct xt_rateest_match_info *info = (void *)matchinfo;
+	struct xt_rateest_match_info *info = matchinfo;
 	struct xt_rateest *est1, *est2;
 
 	if (hweight32(info->flags & (XT_RATEEST_MATCH_ABS |
@@ -130,7 +130,7 @@ err1:
 static void xt_rateest_mt_destroy(const struct xt_match *match,
 				  void *matchinfo)
 {
-	struct xt_rateest_match_info *info = (void *)matchinfo;
+	struct xt_rateest_match_info *info = matchinfo;
 
 	xt_rateest_put(info->est1);
 	if (info->est2)
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index b718ec6..e6e4681 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -46,7 +46,8 @@ match_packet(const struct sk_buff *skb,
 	     bool *hotdrop)
 {
 	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
-	sctp_chunkhdr_t _sch, *sch;
+	const sctp_chunkhdr_t *sch;
+	sctp_chunkhdr_t _sch;
 	int chunk_match_type = info->chunk_match_type;
 	const struct xt_sctp_flag_info *flag_info = info->flag_info;
 	int flag_count = info->flag_count;
@@ -121,7 +122,8 @@ sctp_mt(const struct sk_buff *skb, const struct net_device *in,
         const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct xt_sctp_info *info = matchinfo;
-	sctp_sctphdr_t _sh, *sh;
+	const sctp_sctphdr_t *sh;
+	sctp_sctphdr_t _sh;
 
 	if (offset) {
 		duprintf("Dropping non-first fragment.. FIXME\n");
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index d7a5b27..6771bf0 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -31,9 +31,11 @@ tcpmss_mt(const struct sk_buff *skb, const struct net_device *in,
           bool *hotdrop)
 {
 	const struct xt_tcpmss_match_info *info = matchinfo;
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	u8 _opt[15 * 4 - sizeof(_tcph)], *op;
+	const u_int8_t *op;
+	u8 _opt[15 * 4 - sizeof(_tcph)];
 	unsigned int i, optlen;
 
 	/* If we don't have the whole header, drop packet. */
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 4fa3b66..951b06b 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -42,7 +42,8 @@ tcp_find_option(u_int8_t option,
 		bool *hotdrop)
 {
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
-	u_int8_t _opt[60 - sizeof(struct tcphdr)], *op;
+	const u_int8_t *op;
+	u_int8_t _opt[60 - sizeof(struct tcphdr)];
 	unsigned int i;
 
 	duprintf("tcp_match: finding option\n");
@@ -72,7 +73,8 @@ tcp_mt(const struct sk_buff *skb, const struct net_device *in,
        const struct net_device *out, const struct xt_match *match,
        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct tcphdr _tcph, *th;
+	const struct tcphdr *th;
+	struct tcphdr _tcph;
 	const struct xt_tcp *tcpinfo = matchinfo;
 
 	if (offset) {
@@ -144,7 +146,8 @@ udp_mt(const struct sk_buff *skb, const struct net_device *in,
        const struct net_device *out, const struct xt_match *match,
        const void *matchinfo, int offset, unsigned int protoff, bool *hotdrop)
 {
-	struct udphdr _udph, *uh;
+	const struct udphdr *uh;
+	struct udphdr _udph;
 	const struct xt_udp *udpinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index e9a8794..41297d0 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -220,7 +220,7 @@ time_mt_check(const char *tablename, const void *ip,
               const struct xt_match *match, void *matchinfo,
               unsigned int hook_mask)
 {
-	struct xt_time_info *info = matchinfo;
+	const struct xt_time_info *info = matchinfo;
 
 	if (info->daytime_start > XT_TIME_MAX_DAYTIME ||
 	    info->daytime_stop > XT_TIME_MAX_DAYTIME) {
