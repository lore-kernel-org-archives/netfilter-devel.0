From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ctstat does not apply to 2.4
Date: Fri, 1 Oct 2004 14:55:43 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001215543.GA30842@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Current ctstat in pom-ng depends on three patches which are 2.6
only, but is not itself flagged 2.6 only.  This breaks --batch
mode on 2.4.  The below patch removes the 2.4 version and
adds the proper 'requires' entry.

Phil



--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ctstat

diff -ruN pom-orig/ctstat/info pom-new/ctstat/info
--- pom-orig/ctstat/info	2004-07-22 16:30:39.000000000 -0400
+++ pom-new/ctstat/info	2004-10-01 17:50:09.830017520 -0400
@@ -1,4 +1,5 @@
 Author: Martin Josefsson <gandalf@wlug.westbo.se>
 Status: Works when the planets align into the shape of tux, and only then
 Repository: pending
+Requires: linux >= 2.6.0
 Depends: conntrack-seqfile, expect-slab-cache, module_parm
diff -ruN pom-orig/ctstat/linux-2.4/include/linux/netfilter_ipv4/ip_conntrack.h.ladd pom-new/ctstat/linux-2.4/include/linux/netfilter_ipv4/ip_conntrack.h.ladd
--- pom-orig/ctstat/linux-2.4/include/linux/netfilter_ipv4/ip_conntrack.h.ladd	2003-12-18 13:47:57.000000000 -0500
+++ pom-new/ctstat/linux-2.4/include/linux/netfilter_ipv4/ip_conntrack.h.ladd	1969-12-31 19:00:00.000000000 -0500
@@ -1,21 +0,0 @@
-extern unsigned int ip_conntrack_htable_size;
-
-struct ip_conntrack_stat
-{
-	unsigned int searched;
-	unsigned int found;
-	unsigned int new;
-	unsigned int invalid;
-	unsigned int ignore;
-	unsigned int delete;
-	unsigned int delete_list;
-	unsigned int insert;
-	unsigned int insert_failed;
-	unsigned int drop;
-	unsigned int early_drop;
-	unsigned int icmp_error;
-	unsigned int expect_new;
-	unsigned int expect_create;
-	unsigned int expect_delete;
-} ____cacheline_aligned_in_smp;
-
diff -ruN pom-orig/ctstat/linux-2.4.patch pom-new/ctstat/linux-2.4.patch
--- pom-orig/ctstat/linux-2.4.patch	2003-12-18 13:47:57.000000000 -0500
+++ pom-new/ctstat/linux-2.4.patch	1969-12-31 19:00:00.000000000 -0500
@@ -1,261 +0,0 @@
-Binary files linux-2.4.22.raw/net/ipv4/netfilter/.ip_conntrack_standalone.c.rej.swp and linux-2.4.22/net/ipv4/netfilter/.ip_conntrack_standalone.c.rej.swp differ
-diff -x '*.orig' -x '*.rej' -urNp linux-2.4.22.raw/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.22/net/ipv4/netfilter/ip_conntrack_core.c
---- linux-2.4.22.raw/net/ipv4/netfilter/ip_conntrack_core.c	2003-11-15 22:29:29.000000000 +0100
-+++ linux-2.4.22/net/ipv4/netfilter/ip_conntrack_core.c	2003-11-15 22:30:32.000000000 +0100
-@@ -61,11 +61,13 @@ LIST_HEAD(protocol_list);
- static LIST_HEAD(helpers);
- unsigned int ip_conntrack_htable_size = 0;
- int ip_conntrack_max = 0;
--static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
-+atomic_t ip_conntrack_count = ATOMIC_INIT(0);
- struct list_head *ip_conntrack_hash;
- static kmem_cache_t *ip_conntrack_cachep;
- struct ip_conntrack ip_conntrack_untracked;
- 
-+struct ip_conntrack_stat ip_conntrack_stat[NR_CPUS];
-+
- extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
- 
- static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
-@@ -180,6 +182,7 @@ destroy_expect(struct ip_conntrack_expec
- 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
- 
- 	kfree(exp);
-+	ip_conntrack_stat[smp_processor_id()].expect_delete++;
- }
- 
- 
-@@ -348,12 +351,15 @@ destroy_conntrack(struct nf_conntrack *n
- 	DEBUGP("destroy_conntrack: returning ct=%p to slab\n", ct);
- 	kmem_cache_free(ip_conntrack_cachep, ct);
- 	atomic_dec(&ip_conntrack_count);
-+	ip_conntrack_stat[smp_processor_id()].delete++;
- }
- 
- static void death_by_timeout(unsigned long ul_conntrack)
- {
- 	struct ip_conntrack *ct = (void *)ul_conntrack;
- 
-+	ip_conntrack_stat[smp_processor_id()].delete_list++;
-+
- 	WRITE_LOCK(&ip_conntrack_lock);
- 	clean_from_lists(ct);
- 	WRITE_UNLOCK(&ip_conntrack_lock);
-@@ -376,13 +382,18 @@ __ip_conntrack_find(const struct ip_conn
- {
- 	struct ip_conntrack_tuple_hash *h;
- 	unsigned int hash = hash_conntrack(tuple);
-+	unsigned int cpu = smp_processor_id();
- 
- 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
--	h = LIST_FIND(&ip_conntrack_hash[hash],
--		      conntrack_tuple_cmp,
--		      struct ip_conntrack_tuple_hash *,
--		      tuple, ignored_conntrack);
--	return h;
-+	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
-+		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
-+			ip_conntrack_stat[cpu].found++;
-+			return h;
-+		}
-+		ip_conntrack_stat[cpu].searched++;
-+	}
-+
-+	return NULL;
- }
- 
- /* Find a connection corresponding to a tuple. */
-@@ -476,10 +487,12 @@ __ip_conntrack_confirm(struct nf_ct_info
- 		atomic_inc(&ct->ct_general.use);
- 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
- 		WRITE_UNLOCK(&ip_conntrack_lock);
-+		ip_conntrack_stat[smp_processor_id()].insert++;
- 		return NF_ACCEPT;
- 	}
- 
- 	WRITE_UNLOCK(&ip_conntrack_lock);
-+	ip_conntrack_stat[smp_processor_id()].insert_failed++;
- 	return NF_DROP;
- }
- 
-@@ -614,6 +627,7 @@ static int early_drop(struct list_head *
- 	if (del_timer(&h->ctrack->timeout)) {
- 		death_by_timeout((unsigned long)h->ctrack);
- 		dropped = 1;
-+		ip_conntrack_stat[smp_processor_id()].early_drop++;
- 	}
- 	ip_conntrack_put(h->ctrack);
- 	return dropped;
-@@ -738,12 +752,16 @@ init_conntrack(const struct ip_conntrack
- 		LIST_DELETE(&ip_conntrack_expect_list, expected);
- 		expected->expectant->expecting--;
- 		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
--	}
-+		ip_conntrack_stat[smp_processor_id()].expect_new++;
-+	} else
-+		ip_conntrack_stat[smp_processor_id()].new++;
-+
- 	atomic_inc(&ip_conntrack_count);
- 	WRITE_UNLOCK(&ip_conntrack_lock);
- 
- 	if (expected && expected->expectfn)
- 		expected->expectfn(conntrack);
-+
- 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
- }
- 
-@@ -840,29 +858,38 @@ unsigned int ip_conntrack_in(unsigned in
- #endif
- 
- 	/* Previously seen (loopback or untracked)?  Ignore. */
--	if ((*pskb)->nfct)
-+	if ((*pskb)->nfct) {
-+		ip_conntrack_stat[smp_processor_id()].ignore++;
- 		return NF_ACCEPT;
-+	}
- 
- 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
- 
- 	/* It may be an icmp error... */
- 	if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP 
--	    && icmp_error_track(*pskb, &ctinfo, hooknum))
-+	    && icmp_error_track(*pskb, &ctinfo, hooknum)) {
-+		ip_conntrack_stat[smp_processor_id()].icmp_error++;
- 		return NF_ACCEPT;
-+	}
- 
--	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
-+	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo))) {
- 		/* Not valid part of a connection */
-+		ip_conntrack_stat[smp_processor_id()].invalid++;
- 		return NF_ACCEPT;
-+	}
- 
--	if (IS_ERR(ct))
-+	if (IS_ERR(ct)) {
- 		/* Too stressed to deal. */
-+		ip_conntrack_stat[smp_processor_id()].drop++;
- 		return NF_DROP;
-+	}
- 
- 	IP_NF_ASSERT((*pskb)->nfct);
- 
- 	ret = proto->packet(ct, (*pskb)->nh.iph, (*pskb)->len, ctinfo);
- 	if (ret == -1) {
- 		/* Invalid */
-+		ip_conntrack_stat[smp_processor_id()].invalid++;
- 		nf_conntrack_put((*pskb)->nfct);
- 		(*pskb)->nfct = NULL;
- 		return NF_ACCEPT;
-@@ -873,6 +900,7 @@ unsigned int ip_conntrack_in(unsigned in
- 				       ct, ctinfo);
- 		if (ret == -1) {
- 			/* Invalid */
-+			ip_conntrack_stat[smp_processor_id()].invalid++;
- 			nf_conntrack_put((*pskb)->nfct);
- 			(*pskb)->nfct = NULL;
- 			return NF_ACCEPT;
-@@ -1056,6 +1084,8 @@ int ip_conntrack_expect_related(struct i
- 
- 	WRITE_UNLOCK(&ip_conntrack_lock);
- 
-+	ip_conntrack_stat[smp_processor_id()].expect_create++;
-+
- 	return ret;
- }
- 
-diff -x '*.orig' -x '*.rej' -urNp linux-2.4.22.raw/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.22/net/ipv4/netfilter/ip_conntrack_standalone.c
---- linux-2.4.22.raw/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-15 22:29:29.000000000 +0100
-+++ linux-2.4.22/net/ipv4/netfilter/ip_conntrack_standalone.c	2003-11-15 22:32:33.000000000 +0100
-@@ -40,6 +40,9 @@
- struct module *ip_conntrack_module = THIS_MODULE;
- MODULE_LICENSE("GPL");
- 
-+extern atomic_t ip_conntrack_count;
-+extern struct ip_conntrack_stat ip_conntrack_stat[NR_CPUS];
-+
- static int kill_proto(const struct ip_conntrack *i, void *data)
- {
- 	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum == 
-@@ -180,6 +183,46 @@ list_conntracks(char *buffer, char **sta
- 	return len;
- }
- 
-+static int ip_conntrack_get_stat(char *buffer, char **start, off_t offset, int length)
-+{
-+	unsigned int nr_conntracks = atomic_read(&ip_conntrack_count);
-+	int i, lcpu;
-+	int len = 0;
-+
-+	for (lcpu = 0; lcpu < smp_num_cpus; lcpu++) {
-+		i = cpu_logical_map(lcpu);
-+
-+		len += sprintf(buffer+len, "%08x  %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x  %08x %08x %08x \n",
-+				nr_conntracks,
-+				ip_conntrack_stat[i].searched,
-+				ip_conntrack_stat[i].found,
-+				ip_conntrack_stat[i].new,
-+				ip_conntrack_stat[i].invalid,
-+				ip_conntrack_stat[i].ignore,
-+				ip_conntrack_stat[i].delete,
-+				ip_conntrack_stat[i].delete_list,
-+				ip_conntrack_stat[i].insert,
-+				ip_conntrack_stat[i].insert_failed,
-+				ip_conntrack_stat[i].drop,
-+				ip_conntrack_stat[i].early_drop,
-+				ip_conntrack_stat[i].icmp_error,
-+
-+				ip_conntrack_stat[i].expect_new,
-+				ip_conntrack_stat[i].expect_create,
-+				ip_conntrack_stat[i].expect_delete
-+			);
-+	}
-+	len -= offset;
-+
-+	if (len > length)
-+		len = length;
-+	if (len < 0)
-+		len = 0;
-+
-+	*start = buffer + offset;
-+	return len;
-+}
-+
- static unsigned int ip_confirm(unsigned int hooknum,
- 			       struct sk_buff **pskb,
- 			       const struct net_device *in,
-@@ -363,7 +406,7 @@ static ctl_table ip_ct_net_table[] = {
- #endif
- static int init_or_cleanup(int init)
- {
--	struct proc_dir_entry *proc;
-+	struct proc_dir_entry *proc, *procstat;
- 	int ret = 0;
- 
- 	if (!init) goto cleanup;
-@@ -376,10 +419,15 @@ static int init_or_cleanup(int init)
- 	if (!proc) goto cleanup_init;
- 	proc->owner = THIS_MODULE;
- 
-+	procstat = proc_net_create("ip_conntrack_stat", 0, ip_conntrack_get_stat);
-+	if (!procstat)
-+		goto cleanup_proc;
-+	procstat->owner = THIS_MODULE;
-+
- 	ret = nf_register_hook(&ip_conntrack_defrag_ops);
- 	if (ret < 0) {
- 		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
--		goto cleanup_proc;
-+		goto cleanup_procstat;
- 	}
- 	ret = nf_register_hook(&ip_conntrack_defrag_local_out_ops);
- 	if (ret < 0) {
-@@ -431,6 +479,8 @@ static int init_or_cleanup(int init)
- 	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
-  cleanup_defragops:
- 	nf_unregister_hook(&ip_conntrack_defrag_ops);
-+ cleanup_procstat:
-+	proc_net_remove("ip_conntrack_stat");
-  cleanup_proc:
- 	proc_net_remove("ip_conntrack");
-  cleanup_init:

--y0ulUmNC+osPPQO6--
