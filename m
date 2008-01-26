From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/5] [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
Date: Sat, 26 Jan 2008 17:18:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801261718040.15243@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801261717260.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39913 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbYAZQSR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:18:17 -0500
In-Reply-To: <Pine.LNX.4.64.0801261717260.15243@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2c25a538ee3d0335a6ed8cff1c6ee5c7f92489dd
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Jan 25 20:52:56 2008 +0100

    [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b99ede5..32e6cf6 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -428,13 +428,13 @@ extern int xt_compat_add_offset(int af, unsigned int offset, short delta);
 extern void xt_compat_flush_offsets(int af);
 extern short xt_compat_calc_jump(int af, unsigned int offset);
 
-extern int xt_compat_match_offset(struct xt_match *match);
+extern int xt_compat_match_offset(const struct xt_match *match);
 extern int xt_compat_match_from_user(struct xt_entry_match *m,
 				     void **dstptr, int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
 				   void __user **dstptr, int *size);
 
-extern int xt_compat_target_offset(struct xt_target *target);
+extern int xt_compat_target_offset(const struct xt_target *target);
 extern void xt_compat_target_from_user(struct xt_entry_target *t,
 				       void **dstptr, int *size);
 extern int xt_compat_target_to_user(struct xt_entry_target *t,
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index b4a810c..9fb772a 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -58,7 +58,7 @@ do {								\
 #endif
 
 static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
-				      char *hdr_addr, int len)
+				      const char *hdr_addr, int len)
 {
 	int i, ret;
 
@@ -79,8 +79,8 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 				   const char *outdev,
 				   const struct arpt_arp *arpinfo)
 {
-	char *arpptr = (char *)(arphdr + 1);
-	char *src_devaddr, *tgt_devaddr;
+	const char *arpptr = (char *)(arphdr + 1);
+	const char *src_devaddr, *tgt_devaddr;
 	__be32 src_ipaddr, tgt_ipaddr;
 	int i, ret;
 
@@ -225,12 +225,12 @@ unsigned int arpt_do_table(struct sk_buff *skb,
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
@@ -354,7 +354,7 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 		e->counters.pcnt = pos;
 
 		for (;;) {
-			struct arpt_standard_target *t
+			const struct arpt_standard_target *t
 				= (void *)arpt_get_target(e);
 			int visited = e->comefrom & (1 << hook);
 
@@ -439,7 +439,7 @@ static int mark_source_chains(struct xt_table_info *newinfo,
 
 static inline int check_entry(struct arpt_entry *e, const char *name)
 {
-	struct arpt_entry_target *t;
+	const struct arpt_entry_target *t;
 
 	if (!arp_checkentry(&e->arp)) {
 		duprintf("arp_tables: arp check failed %p %s.\n", e, name);
@@ -712,7 +712,7 @@ static inline struct xt_counters *alloc_counters(struct arpt_table *table)
 {
 	unsigned int countersize;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
@@ -739,7 +739,7 @@ static int copy_entries_to_user(unsigned int total_size,
 	unsigned int off, num;
 	struct arpt_entry *e;
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	int ret = 0;
 	void *loc_cpu_entry;
 
@@ -874,7 +874,7 @@ static int get_info(void __user *user, int *len, int compat)
 				    "arptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct arpt_getinfo info;
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 
 #ifdef CONFIG_COMPAT
 		if (compat) {
@@ -928,7 +928,8 @@ static int get_entries(struct arpt_get_entries __user *uptr, int *len)
 
 	t = xt_find_table_lock(NF_ARP, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
+
 		duprintf("t->private->number = %u\n",
 			 private->number);
 		if (get.size == private->size)
@@ -1086,11 +1087,11 @@ static int do_add_counters(void __user *user, unsigned int len, int compat)
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
@@ -1556,7 +1557,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 				       void __user *userptr)
 {
 	struct xt_counters *counters;
-	struct xt_table_info *private = table->private;
+	const struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
@@ -1606,7 +1607,7 @@ static int compat_get_entries(struct compat_arpt_get_entries __user *uptr,
 	xt_compat_lock(NF_ARP);
 	t = xt_find_table_lock(NF_ARP, get.name);
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
index 982b7f9..5c7b8e3 100644
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
@@ -1116,7 +1116,7 @@ static int get_info(void __user *user, int *len, int compat)
 				    "iptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ipt_getinfo info;
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 
 #ifdef CONFIG_COMPAT
 		if (compat) {
@@ -1172,7 +1172,7 @@ get_entries(struct ipt_get_entries __user *uptr, int *len)
 
 	t = xt_find_table_lock(AF_INET, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		duprintf("t->private->number = %u\n", private->number);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
@@ -1337,11 +1337,11 @@ do_add_counters(void __user *user, unsigned int len, int compat)
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
@@ -1876,11 +1876,11 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
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
@@ -1926,7 +1926,7 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(AF_INET, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
@@ -2117,7 +2117,8 @@ icmp_match(const struct sk_buff *skb,
 	   unsigned int protoff,
 	   bool *hotdrop)
 {
-	struct icmphdr _icmph, *ic;
+	const struct icmphdr *ic;
+	struct icmphdr _icmph;
 	const struct ipt_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dd7860f..a52b443 100644
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
@@ -1142,7 +1142,7 @@ static int get_info(void __user *user, int *len, int compat)
 				    "ip6table_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 
 #ifdef CONFIG_COMPAT
 		if (compat) {
@@ -1225,7 +1225,7 @@ __do_replace(const char *name, unsigned int valid_hooks,
 	struct xt_table *t;
 	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
-	void *loc_cpu_old_entry;
+	const void *loc_cpu_old_entry;
 
 	ret = 0;
 	counters = vmalloc_node(num_counters * sizeof(struct xt_counters),
@@ -1368,9 +1368,9 @@ do_add_counters(void __user *user, unsigned int len, int compat)
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
 
@@ -1902,11 +1902,11 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
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
@@ -1952,7 +1952,7 @@ compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
-		struct xt_table_info *private = t->private;
+		const struct xt_table_info *private = t->private;
 		struct xt_table_info info;
 		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
@@ -2142,7 +2142,8 @@ icmp6_match(const struct sk_buff *skb,
 	   unsigned int protoff,
 	   bool *hotdrop)
 {
-	struct icmp6hdr _icmph, *ic;
+	const struct icmp6hdr *ic;
+	struct icmp6hdr _icmph;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8d4fca9..2e2a65b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -65,7 +65,7 @@ enum {
 	MATCH,
 };
 
-static const char *xt_prefix[NPROTO] = {
+static const char *const xt_prefix[NPROTO] = {
 	[AF_INET]	= "ip",
 	[AF_INET6]	= "ip6",
 	[NF_ARP]	= "arp",
@@ -255,7 +255,7 @@ EXPORT_SYMBOL_GPL(xt_request_find_target);
 
 static int match_revfn(int af, const char *name, u8 revision, int *bestp)
 {
-	struct xt_match *m;
+	const struct xt_match *m;
 	int have_rev = 0;
 
 	list_for_each_entry(m, &xt[af].match, list) {
@@ -271,7 +271,7 @@ static int match_revfn(int af, const char *name, u8 revision, int *bestp)
 
 static int target_revfn(int af, const char *name, u8 revision, int *bestp)
 {
-	struct xt_target *t;
+	const struct xt_target *t;
 	int have_rev = 0;
 
 	list_for_each_entry(t, &xt[af].target, list) {
@@ -392,7 +392,7 @@ short xt_compat_calc_jump(int af, unsigned int offset)
 }
 EXPORT_SYMBOL_GPL(xt_compat_calc_jump);
 
-int xt_compat_match_offset(struct xt_match *match)
+int xt_compat_match_offset(const struct xt_match *match)
 {
 	u_int16_t csize = match->compatsize ? : match->matchsize;
 	return XT_ALIGN(match->matchsize) - COMPAT_XT_ALIGN(csize);
@@ -402,7 +402,7 @@ EXPORT_SYMBOL_GPL(xt_compat_match_offset);
 int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 			      int *size)
 {
-	struct xt_match *match = m->u.kernel.match;
+	const struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
 	int pad, off = xt_compat_match_offset(match);
 	u_int16_t msize = cm->u.user.match_size;
@@ -429,7 +429,7 @@ EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
 			    int *size)
 {
-	struct xt_match *match = m->u.kernel.match;
+	const struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match __user *cm = *dstptr;
 	int off = xt_compat_match_offset(match);
 	u_int16_t msize = m->u.user.match_size - off;
@@ -486,7 +486,7 @@ int xt_check_target(const struct xt_target *target, unsigned short family,
 EXPORT_SYMBOL_GPL(xt_check_target);
 
 #ifdef CONFIG_COMPAT
-int xt_compat_target_offset(struct xt_target *target)
+int xt_compat_target_offset(const struct xt_target *target)
 {
 	u_int16_t csize = target->compatsize ? : target->targetsize;
 	return XT_ALIGN(target->targetsize) - COMPAT_XT_ALIGN(csize);
@@ -496,7 +496,7 @@ EXPORT_SYMBOL_GPL(xt_compat_target_offset);
 void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 				int *size)
 {
-	struct xt_target *target = t->u.kernel.target;
+	const struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target *ct = (struct compat_xt_entry_target *)t;
 	int pad, off = xt_compat_target_offset(target);
 	u_int16_t tsize = ct->u.user.target_size;
@@ -522,7 +522,7 @@ EXPORT_SYMBOL_GPL(xt_compat_target_from_user);
 int xt_compat_target_to_user(struct xt_entry_target *t, void __user **dstptr,
 			     int *size)
 {
-	struct xt_target *target = t->u.kernel.target;
+	const struct xt_target *target = t->u.kernel.target;
 	struct compat_xt_entry_target __user *ct = *dstptr;
 	int off = xt_compat_target_offset(target);
 	u_int16_t tsize = t->u.user.target_size - off;
