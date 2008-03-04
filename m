From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/19] [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
Date: Tue, 4 Mar 2008 17:30:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041730180.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40657 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765429AbYCDQae (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:34 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b5ee37d4825c664d5560acf785ae97ec207c761c
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Jan 25 20:52:56 2008 +0100

    [NETFILTER]: annotate {arp,ip,ip6,x}tables with const
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/x_tables.h |    4 +-
 net/ipv4/netfilter/arp_tables.c    |   33 ++++++++++++++-------------
 net/ipv4/netfilter/arpt_mangle.c   |    2 +-
 net/ipv4/netfilter/ip_tables.c     |   31 +++++++++++++------------
 net/ipv6/netfilter/ip6_tables.c    |   29 ++++++++++++-----------
 net/netfilter/x_tables.c           |   18 +++++++-------
 6 files changed, 60 insertions(+), 57 deletions(-)

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
index 3f4222b..3e732c8 100644
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
