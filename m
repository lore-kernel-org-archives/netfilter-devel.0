From: diegows@linux.org.ar (Diego Woitasen (Lanux))
Subject: [PATCH] quota per ip
Date: Mon, 30 Jun 2003 12:38:18 -0300 (ART)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030630153818.46D05117760@superhijitus>
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: samj@samj.net
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This patch add support for quotas per source ip. Please I wan 't to hear your opinion about this.

Thanks.



diff -urN -X dontdiff linux-2.4.20-orig/include/linux/netfilter_ipv4/ipt_quota.h linux-2.4.20/include/linux/netfilter_ipv4/ipt_quota.h
--- linux-2.4.20-orig/include/linux/netfilter_ipv4/ipt_quota.h	Wed Dec 31 21:00:00 1969
+++ linux-2.4.20/include/linux/netfilter_ipv4/ipt_quota.h	Wed May 21 12:38:05 2003
@@ -0,0 +1,20 @@
+#ifndef _IPT_QUOTA_H
+#define _IPT_QUOTA_H
+
+#include <linux/list.h>
+
+/* print debug info in both kernel/netfilter module & iptable library */
+/* #define DEBUG_IPT_QUOTA */
+
+#define IPT_QUOTA				0x0001
+#define IPT_IPDSTQUOTA				0x0002
+#define IPT_QUOTA_FLAG_NEGATE		   	0x0004
+#define IPT_QUOTA_FLAG_COUNT_FULL		0x0009
+
+struct ipt_quota_info {
+	u_int64_t quota;	
+	u_int16_t flags;
+	struct list_head *ipquota_hash;
+};
+
+#endif /*_IPT_QUOTA_H*/
diff -urN -X dontdiff linux-2.4.20-orig/net/ipv4/netfilter/ipt_quota.c linux-2.4.20/net/ipv4/netfilter/ipt_quota.c
--- linux-2.4.20-orig/net/ipv4/netfilter/ipt_quota.c	Wed Dec 31 21:00:00 1969
+++ linux-2.4.20/net/ipv4/netfilter/ipt_quota.c	Wed May 21 12:38:17 2003
@@ -0,0 +1,381 @@
+/* 
+ * netfilter module to enforce network quotas
+ *
+ * Sam Johnston <samj@samj.net>
+ *
+ * 20 May 2003: Diego Woitasen (diegows@linux.org.ar):
+ *	- new quota per destination ip
+ * 29 Apr 2003: Brad Fisher (brad@info-link.net):
+ *	- ! inverse match and add the option to count total packet size
+ *	    (headers + data)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/vmalloc.h>
+#include <linux/ip.h>
+#include <linux/tcp.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_quota.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/proc_fs.h>
+#include <linux/netfilter_ipv4/lockhelp.h>
+#include <linux/sysctl.h>
+
+/* I don't need this DW */
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+
+#include <linux/netfilter_ipv4/listhelp.h>
+
+#define QUOTA_KEY(ip) (ip % quota_hash_size)
+
+MODULE_LICENSE("GPL");
+
+static spinlock_t quota_lock = SPIN_LOCK_UNLOCKED;
+
+static int kmem = 0;
+static int vmem = 0;
+static int hashsize = 0;
+static int quota_hash_size = 0;
+static int ipquota_kmem_max = 0;	/* max struct ipquota that could be alloc. */
+
+static kmem_cache_t *ipquota_cache;
+
+MODULE_PARM(hashsize, "i");
+MODULE_PARM(ipquota_kmem_max, "i");
+
+struct ipquota {
+	struct list_head list;
+	u_int32_t ip;
+	u_int64_t quota;
+};
+
+#ifdef CONFIG_SYSCTL
+
+static struct ctl_table_header *ip_quota_sysctl_header;
+
+static ctl_table ipquota_table[] = {
+	{4048, "ipquota_kmem_max", &ipquota_kmem_max, sizeof (ipquota_kmem_max),
+	 0644, NULL, proc_dointvec}
+	,
+	{0}
+};
+
+static ctl_table ipquota_table_dir[] = {
+	{NET_IPV4, "ipv4", NULL, 0, 0555, ipquota_table, 0, 0, 0, 0, 0},
+	{0}
+};
+
+static ctl_table ipquota_table_root[] = {
+	{CTL_NET, "net", NULL, 0, 0555, ipquota_table_dir, 0, 0, 0, 0, 0},
+	{0}
+};
+
+#endif
+
+static inline void *
+quota_alloc(void)
+{
+
+	if (kmem > ipquota_kmem_max)
+		return NULL;
+	kmem++;
+	return kmem_cache_alloc(ipquota_cache, GFP_ATOMIC);
+
+}
+
+static inline void
+quota_free(void *tmp_if)
+{
+
+	kmem--;
+	kmem_cache_free(ipquota_cache, tmp_if);
+
+}
+
+static inline void *
+quota_valloc(size_t size)
+{
+
+	vmem++;
+	return vmalloc(size);
+
+}
+
+static inline void
+quota_vfree(void *tmp_if)
+{
+
+	vmem--;
+	vfree(tmp_if);
+
+}
+
+static inline int
+quota_cmpfn(const struct ipquota *ipquota_tmp, u_int32_t ip)
+{
+
+	return ipquota_tmp->ip == ip;
+
+}
+
+static struct ipquota *
+quota_get(struct ipt_quota_info *info, u_int32_t ip)
+{
+
+	struct list_head *bucket;
+	struct ipquota *ipquota_tmp;
+
+	bucket = &info->ipquota_hash[QUOTA_KEY(ip)];
+
+	ipquota_tmp = LIST_FIND(bucket, quota_cmpfn, struct ipquota *, ip);
+
+	if (!ipquota_tmp) {
+		ipquota_tmp = quota_alloc();
+		if (!ipquota_tmp) {
+			printk(KERN_ERR
+			       "unable to create ipquota item (quota_alloc),"
+			       "ipquota_kmem_max reached");
+			return ipquota_tmp;
+		}
+
+		ipquota_tmp->ip = ip;
+		ipquota_tmp->quota = 0;
+		list_append(bucket, ipquota_tmp);
+	}
+	return ipquota_tmp;
+
+}
+
+static int
+quota_hash_init(struct ipt_quota_info *info)
+{
+
+	int i;
+
+	info->ipquota_hash =
+	    quota_valloc(sizeof (struct list_head) * quota_hash_size);
+
+	if (!info->ipquota_hash) {
+		printk(KERN_ERR "Unable to create quota_hash\n");
+		return (-1);
+	}
+
+	for (i = 0; i < quota_hash_size; i++)
+		INIT_LIST_HEAD(&info->ipquota_hash[i]);
+
+	return (quota_hash_size);
+
+}
+
+static int
+quota_hash_destroy(struct ipt_quota_info *info)
+{
+
+	int i;
+
+	for (i = 0; i < quota_hash_size; i++) {
+		struct list_head *pos_tmp, *n_tmp;
+		list_for_each_safe(pos_tmp, n_tmp, &info->ipquota_hash[i]) {
+			list_del(pos_tmp);
+			quota_free(pos_tmp);
+		}
+
+	}
+	quota_vfree(info->ipquota_hash);
+
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset, const void *hdr, u_int16_t datalen, int *hotdrop)
+{
+
+	struct ipt_quota_info *q = (struct ipt_quota_info *) matchinfo;
+
+	if (q->flags & IPT_QUOTA_FLAG_COUNT_FULL)
+		datalen = skb->len;
+
+	spin_lock_bh(&quota_lock);
+
+	if (q->flags & IPT_QUOTA) {
+		if (q->quota >= datalen) {
+			/* we can afford this one */
+			q->quota -= datalen;
+			goto quota;
+		}
+		/* so we do not allow even small packets from now on */
+		q->quota = 0;
+	} else if (q->flags & IPT_IPDSTQUOTA) {
+
+		struct ipquota *ipquota_tmp;
+
+		ipquota_tmp = quota_get(q, skb->nh.iph->daddr);
+		if (!ipquota_tmp)
+			goto xquota;
+
+		if ((ipquota_tmp->quota + datalen) < q->quota) {
+			ipquota_tmp->quota += datalen;
+			goto quota;
+		} else
+			goto xquota;
+
+	}
+
+      xquota:
+	spin_unlock_bh(&quota_lock);
+
+#ifdef DEBUG_IPT_QUOTA
+	printk("IPT Quota Failed: max=%llu\n", q->quota);
+#endif
+
+	if (q->flags & IPT_QUOTA_FLAG_NEGATE)
+		return 1;
+	return 0;
+
+      quota:
+	spin_unlock_bh(&quota_lock);
+
+#ifdef DEBUG_IPT_QUOTA
+	printk("IPT Quota OK: %llu datlen %d \n", q->quota, datalen);
+#endif
+
+	if (q->flags & IPT_QUOTA_FLAG_NEGATE)
+		return 0;
+	return 1;
+
+}
+
+static int
+checkentry(const char *tablename,
+	   const struct ipt_ip *ip,
+	   void *matchinfo, unsigned int matchsize, unsigned int hook_mask)
+{
+
+	struct ipt_quota_info *info = (struct ipt_quota_info *) matchinfo;
+
+	/* TODO: spinlocks? sanity checks? */
+	if (matchsize != IPT_ALIGN(sizeof (struct ipt_quota_info)))
+		return 0;
+
+	if (info->flags & IPT_IPDSTQUOTA)
+		if (quota_hash_init(info) < 0)
+			return 0;
+
+	return 1;
+
+}
+
+static void
+destroy(void *matchinfo, unsigned int size)
+{
+
+	struct ipt_quota_info *q = (struct ipt_quota_info *)
+	    matchinfo;
+
+	if (q->flags & IPT_IPDSTQUOTA) {
+		quota_hash_destroy(q);
+	}
+
+}
+
+static struct ipt_match quota_match = {
+	{NULL, NULL}, "quota", &match, &checkentry, &destroy, THIS_MODULE
+};
+
+int
+read_kmem(char *buf, char **start,
+	  off_t offset, int count, int *eof, void *data)
+{
+
+	*start = NULL;
+	*eof = 1;
+	return (sprintf(buf, "%d\n", kmem));
+}
+
+int
+read_vmem(char *buf, char **start,
+	  off_t offset, int count, int *eof, void *data)
+{
+
+	*start = NULL;
+	*eof = 1;
+	return (sprintf(buf, "%d\n", vmem));
+}
+
+static int __init
+init(void)
+{
+
+	ipquota_cache =
+	    kmem_cache_create("ipquota", sizeof (struct ipquota), 0,
+			      SLAB_HWCACHE_ALIGN, NULL, NULL);
+
+	if (!ipquota_cache) {
+		printk(KERN_ERR "Unable to create ipquota slab cache\n");
+		return -1;
+	}
+
+	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
+	 * machine has 256 buckets.  >= 1GB machines have 8192 buckets. */
+	if (hashsize) {
+		quota_hash_size = hashsize;
+	} else {
+		quota_hash_size = (((num_physpages << PAGE_SHIFT) / 16384)
+				   / sizeof (struct list_head));
+		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+			quota_hash_size = 8192;
+		if (quota_hash_size < 16)
+			quota_hash_size = 16;
+	}
+
+	if (!ipquota_kmem_max)
+		ipquota_kmem_max = 8 * quota_hash_size;
+
+	create_proc_read_entry("ipquota_kmem", 600, proc_net, read_kmem, NULL);
+	create_proc_read_entry("ipquota_vmem", 600, proc_net, read_vmem, NULL);
+
+#ifdef CONFIG_SYSCTL
+	ip_quota_sysctl_header = register_sysctl_table(ipquota_table_root, 0);
+	if (ip_quota_sysctl_header == NULL) {
+		kmem_cache_destroy(ipquota_cache);
+		remove_proc_entry("ipquota_kmem", NULL);
+		remove_proc_entry("ipquota_vmem", NULL);
+		return -1;
+	}
+#endif
+
+	printk(KERN_INFO
+	       "quota/ipquota initialized (ipquota_kmem_max %d, buckets %d)\n",
+	       ipquota_kmem_max, quota_hash_size);
+
+	return ipt_register_match(&quota_match);
+
+}
+
+static void __exit
+fini(void)
+{
+
+	remove_proc_entry("ipquota_kmem", NULL);
+	remove_proc_entry("ipquota_vmem", NULL);
+
+	kmem_cache_destroy(ipquota_cache);
+
+	ipt_unregister_match(&quota_match);
+
+#ifdef CONFIG_SYSCTL
+	unregister_sysctl_table(ip_quota_sysctl_header);
+#endif
+
+}
+
+module_init(init);
+module_exit(fini);
  dep_tristate '  limit match support' CONFIG_IP_NF_MATCH_LIMIT $CONFIG_IP_NF_IPTABLES
  dep_tristate '  quota match support' CONFIG_IP_NF_MATCH_QUOTA $CONFIG_IP_NF_IPTABLES
CONFIG_IP_NF_MATCH_LIMIT
quota match support
CONFIG_IP_NF_MATCH_QUOTA
  This match implements network quotas and quotas per destination ip.

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.

Author: Sam Johnston <samj@samj.net>
Status: worksforme

This option adds CONFIG_IP_NF_MATCH_QUOTA, which implements network
quotas by decrementing a byte counter with each packet.
Also implements quota per destination ip address. 
(Diego Woitasen <diegows@linux.org.ar>)

Supported options are:
--quota <bytes>
  The quota in bytes.
  
--ipdstquota <bytes>
  The quota per destination ip address in bytes

obj-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit.o
obj-$(CONFIG_IP_NF_MATCH_QUOTA) += ipt_quota.o
/*
 * Shared library add-on to iptables to add quota support
 *
 * Sam Johnston <samj@samj.net>
 *
 * 2003/04/02 Diego Woitasen (diegows@linux.org.ar) add quota per dst ip 
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <iptables.h>

#include <linux/netfilter_ipv4/ipt_quota.h>
#include <linux/netfilter_ipv4/ip_tables.h>

static struct option opts[] = {
  {"quota", 1, 0, IPT_QUOTA},
  {"ipdstquota", 1, 0, IPT_IPDSTQUOTA},
  {"count-headers", 0, 0, IPT_QUOTA_FLAG_COUNT_FULL},
  {0}
};

/* print usage */
static void
help (void)
{
  printf ("quota options:\n\n"
	  " --quota [!] quota			quota (bytes)\n"
	  " --ipdstquota [!] quota		quota per ip (bytes)\n"
	  "\n"
	  " --count-headers		count headers as well as data\n");
}

/* initialise match */
static void
init (struct ipt_entry_match *m, unsigned int *nfcache)
{

  struct ipt_quota_info *info = (struct ipt_quota_info *) m->data;

  info->flags = 0;
  info->quota = 0;
  info->ipquota_hash = NULL;

  /* no can cache */
  *nfcache |= NFC_UNKNOWN;

}

/* print matchinfo */
static void
print (const struct ipt_ip *ip, const struct ipt_entry_match *match,
       int numeric)
{
  struct ipt_quota_info *q = (struct ipt_quota_info *) match->data;

  if (IPT_QUOTA & q->flags)
    printf ("quota");
  else if (IPT_IPDSTQUOTA & q->flags)
    printf ("ipdstquota");
  if (IPT_QUOTA_FLAG_NEGATE & q->flags)
    printf (" ! ");
  printf ("%llu bytes", (unsigned long long) q->quota);
  if (IPT_QUOTA_FLAG_COUNT_FULL & q->flags)
    printf (" (incl. headers)");

}

/* save matchinfo */
static void
save (const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
  struct ipt_quota_info *q = (struct ipt_quota_info *) match->data;

  if (IPT_QUOTA & q->flags)
    printf ("--quota");
  else if (IPT_IPDSTQUOTA & q->flags)
    printf ("--ipdstquota");
  if (IPT_QUOTA_FLAG_NEGATE & q->flags)
    printf (" ! ");
  printf (" %llu", (unsigned long long) q->quota);
  if (IPT_QUOTA_FLAG_COUNT_FULL & q->flags)
    printf (" --count-headers");

}

/* parse quota option */
static int
parse_quota (const char *s, struct ipt_quota_info *quota, int c)
{

  if (s && (*s == '-'))
    exit_error (PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);

  quota->quota = strtoull (s, (char **) NULL, 10);

#ifdef DEBUG_IPT_QUOTA
  printf ("Quota: %llu\n", quota->quota);
#endif

  if (quota->quota == -1)
    exit_error (PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
  else
    return 1;

}

/* parse all options, returning true if we found any for us */
static int
parse (int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache, struct ipt_entry_match **match)
{
  struct ipt_quota_info *info = (struct ipt_quota_info *) (*match)->data;

  switch (c)
    {
    case IPT_QUOTA_FLAG_COUNT_FULL:
      if (check_inverse (optarg, &invert, NULL, 0))
	exit_error (PARAMETER_PROBLEM, "count-headers: unexpected '!'");
      info->flags |= IPT_QUOTA_FLAG_COUNT_FULL;
      break;
    case IPT_QUOTA:
    case IPT_IPDSTQUOTA:
      if ((info->flags & IPT_QUOTA) && (info->flags & IPT_IPDSTQUOTA))
	exit_error (PARAMETER_PROBLEM,
		    "syntax error: you can't use --quota and --ipdstquota");
      check_inverse (optarg, &invert, &optind, 0);
      if (invert)
	info->flags |= IPT_QUOTA_FLAG_NEGATE;
      parse_quota (argv[optind - 1], info, c);
      info->flags |= (u_int16_t) c;
      *flags = 1;
      break;
    default:
      exit_error (PARAMETER_PROBLEM, "unknown option: try --help");
      return 0;
    }
  return 1;
}

/* no final check */
static void
final_check (unsigned int flags)
{

  if (flags != 1)
    exit_error (PARAMETER_PROBLEM, "quota: missing arguments");

}

struct iptables_match quota = { NULL,
  "quota",
  NETFILTER_VERSION,
  IPT_ALIGN (sizeof (struct ipt_quota_info)),
  IPT_ALIGN (sizeof (struct ipt_quota_info)),
  &help,
  &init,
  &parse,
  &final_check,
  &print,
  &save,
  opts
};

void
_init (void)
{
  register_match (&quota);
}
