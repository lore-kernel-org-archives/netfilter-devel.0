From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] clean up for conntrack stats
Date: Tue, 05 Oct 2004 16:52:07 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4162B517.8030200@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080704040109080908070204"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080704040109080908070204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Martin, Hi Patrick,

Attached a clean up for current conntrack stats, it applies to current 
bk 2.6 tree. Some comments:

a) I combined ifdef's checkings + macro, so if conntrack stats are 
compiled in the kernel we increase the counters.

 #define CONNTRACK_STAT_INC(count) 
(__get_cpu_var(ip_conntrack_stat).count++)
+#else /* !CONNTRACK STATS */
+#define CONNTRACK_STAT_INC(count)
+#endif

b) Martin, I've killed this to make them use the macro, are you ok with 
this? I know that we call twice smp_proccesor_id now, but it's clean I 
think.

-       /* use per_cpu() to avoid multiple calls to smp_processor_id() */
-       unsigned int cpu = smp_processor_id();

        MUST_BE_READ_LOCKED(&ip_conntrack_lock);
        list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
                if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
-                       per_cpu(ip_conntrack_stat, cpu).found++;
+                       CONNTRACK_STAT_INC(found);
                        return h;

c) This is similar to a)

+#define CT_ADD_COUNTERS(ct, ctinfo, skb) ct_add_counters(ct, ctinfo, skb)
+#else
+#define CT_ADD_COUNTERS(ct, ctinfo, skb)
+#endif

d) You can see that I've play around with ip_conntrack_standalone 
reordering the creation of /proc entries. I did it just to remove 
warnings about unused labels when unsetting conntrack stats.

To conclude, this patch adds up to 8 ifdef's CONFIG_IP_NF_CT_ACCT 
checkings, I must confess that I don't love them, I'll think if there's 
a way to do cleaner.

Wait for your comments.

regards,
Pablo

--------------080704040109080908070204
Content-Type: text/x-patch;
 name="acct-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acct-cleanup.patch"

===== include/linux/netfilter_ipv4/ip_conntrack.h 1.23 vs edited =====
--- 1.23/include/linux/netfilter_ipv4/ip_conntrack.h	Thu Sep 23 23:45:10 2004
+++ edited/include/linux/netfilter_ipv4/ip_conntrack.h	Tue Oct  5 16:03:41 2004
@@ -292,6 +292,7 @@
 
 extern unsigned int ip_conntrack_htable_size;
  
+#ifdef CONFIG_IP_NF_CT_ACCT
 struct ip_conntrack_stat
 {
 	unsigned int searched;
@@ -312,6 +313,9 @@
 };
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
+#else /* !CONNTRACK STATS */
+#define CONNTRACK_STAT_INC(count)
+#endif
 
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
===== net/ipv4/netfilter/ip_conntrack_core.c 1.68 vs edited =====
--- 1.68/net/ipv4/netfilter/ip_conntrack_core.c	Wed Sep 29 05:34:27 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Tue Oct  5 16:03:41 2004
@@ -76,7 +76,9 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 
+#ifdef CONFIG_IP_NF_CT_ACCT
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
+#endif
 
 inline void 
 ip_conntrack_put(struct ip_conntrack *ct)
@@ -352,16 +354,14 @@
 {
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int hash = hash_conntrack(tuple);
-	/* use per_cpu() to avoid multiple calls to smp_processor_id() */
-	unsigned int cpu = smp_processor_id();
 
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
 	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
 		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
-			per_cpu(ip_conntrack_stat, cpu).found++;
+			CONNTRACK_STAT_INC(found);
 			return h;
 		}
-		per_cpu(ip_conntrack_stat, cpu).searched++;
+		CONNTRACK_STAT_INC(searched);
 	}
 
 	return NULL;
@@ -1074,18 +1074,21 @@
 	synchronize_net();
 }
 
+#ifdef CONFIG_IP_NF_CT_ACCT
 static inline void ct_add_counters(struct ip_conntrack *ct,
 				   enum ip_conntrack_info ctinfo,
 				   const struct sk_buff *skb)
 {
-#ifdef CONFIG_IP_NF_CT_ACCT
 	if (skb) {
 		ct->counters[CTINFO2DIR(ctinfo)].packets++;
 		ct->counters[CTINFO2DIR(ctinfo)].bytes += 
 					ntohs(skb->nh.iph->tot_len);
 	}
-#endif
 }
+#define CT_ADD_COUNTERS(ct, ctinfo, skb) ct_add_counters(ct, ctinfo, skb)
+#else
+#define CT_ADD_COUNTERS(ct, ctinfo, skb)
+#endif
 
 /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
 void ip_ct_refresh_acct(struct ip_conntrack *ct, 
@@ -1098,7 +1101,7 @@
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct)) {
 		ct->timeout.expires = extra_jiffies;
-		ct_add_counters(ct, ctinfo, skb);
+		CT_ADD_COUNTERS(ct, ctinfo, skb);
 	} else {
 		WRITE_LOCK(&ip_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
@@ -1106,7 +1109,7 @@
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
 		}
-		ct_add_counters(ct, ctinfo, skb);
+		CT_ADD_COUNTERS(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
 	}
 }
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.50 vs edited =====
--- 1.50/net/ipv4/netfilter/ip_conntrack_standalone.c	Tue Sep 28 23:22:13 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Tue Oct  5 16:12:04 2004
@@ -46,7 +46,9 @@
 MODULE_LICENSE("GPL");
 
 extern atomic_t ip_conntrack_count;
+#ifdef CONFIG_IP_NF_CT_ACCT
 DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
+#endif
 
 static int kill_proto(const struct ip_conntrack *i, void *data)
 {
@@ -264,6 +266,7 @@
 	.release = seq_release
 };
 
+#ifdef CONFIG_IP_NF_CT_ACCT
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	int cpu;
@@ -351,6 +354,7 @@
 	.llseek  = seq_lseek,
 	.release = seq_release_private,
 };
+#endif /* CONFIG_IP_NF_CT_ACCT */
 #endif
 
 static unsigned int ip_confirm(unsigned int hooknum,
@@ -725,7 +729,10 @@
 static int init_or_cleanup(int init)
 {
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
+	struct proc_dir_entry *proc, *proc_exp;
+#ifdef CONFIG_IP_NF_CT_ACCT
+	struct proc_dir_entry *proc_stat;
+#endif
 #endif
 	int ret = 0;
 
@@ -736,19 +743,19 @@
 		goto cleanup_nothing;
 
 #ifdef CONFIG_PROC_FS
-	proc = proc_net_fops_create("ip_conntrack", 0440, &ct_file_ops);
-	if (!proc) goto cleanup_init;
-
 	proc_exp = proc_net_fops_create("ip_conntrack_expect", 0440,
 					&exp_file_ops);
-	if (!proc_exp) goto cleanup_proc;
-
-	proc_stat = create_proc_entry("ip_conntrack", S_IRUGO, proc_net_stat);
-	if (!proc_stat)
-		goto cleanup_proc_exp;
+	if (!proc_exp) goto cleanup_init;
+	
+	proc = proc_net_fops_create("ip_conntrack", 0440, &ct_file_ops);
 
-	proc_stat->proc_fops = &ct_cpu_seq_fops;
-	proc_stat->owner = THIS_MODULE;
+	if (!proc) goto cleanup_proc_expect;
+	
+#ifdef CONFIG_IP_NF_CT_ACCT
+	proc_stat = proc_net_fops_create("ip_conntrack_stat", 0440, 
+					 &ct_cpu_seq_fops);
+	if (!proc_stat) goto cleanup_proc;
+#endif /* CONFIG_IP_NF_CT_ACCT */
 #endif
 
 	ret = nf_register_hook(&ip_conntrack_defrag_ops);
@@ -814,11 +821,13 @@
 	nf_unregister_hook(&ip_conntrack_defrag_ops);
  cleanup_proc_stat:
 #ifdef CONFIG_PROC_FS
+#ifdef CONFIG_IP_NF_CT_ACCT
 	proc_net_remove("ip_conntrack_stat");
-cleanup_proc_exp:
-	proc_net_remove("ip_conntrack_exp");
  cleanup_proc:
+#endif /* CONFIG_IP_NF_CT_ACCT */
 	proc_net_remove("ip_conntrack");
+ cleanup_proc_expect:
+	proc_net_remove("ip_conntrack_expect");
  cleanup_init:
 #endif /* CONFIG_PROC_FS */
 	ip_conntrack_cleanup();

--------------080704040109080908070204--
