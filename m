From: Marco Innocenti <m.innocenti@cineca.it>
Subject: Re: [PATCH] NETFILTER: add support for invert condition (!) in
	ipt_limit
Date: Thu, 20 Oct 2005 11:01:00 +0200
Message-ID: <20051020090100.GA23412@pc-innocenti.cineca.it>
References: <20051017094417.GA26911@pc-innocenti.cineca.it>
	<20051017.184547.117007327.yoshfuji@linux-ipv6.org>
	<20051017143053.GA29010@pc-innocenti.cineca.it>
	<4353BFFB.7070406@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <4353BFFB.7070406@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Oct 17, 2005 at 05:15:07PM +0200, Patrick McHardy wrote:
> This breaks userspace compatibility, you need to use a new revision
> if you want to change this structure. Look at ipt_MARK for an example.


Signed-off-by: Marco Innocenti <m.innocenti@cineca.it>
---
diff -urpN linux-source-2.6.13/include/linux/netfilter_ipv4/ipt_limit.h linux-source-2.6.13.lavoro/include/linux/netfilter_ipv4/ipt_limit.h
--- linux-source-2.6.13/include/linux/netfilter_ipv4/ipt_limit.h	2005-08-29 01:41:01.000000000 +0200
+++ linux-source-2.6.13.lavoro/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-19 16:22:57.000000000 +0200
@@ -3,9 +3,10 @@
 
 /* timings are in milliseconds. */
 #define IPT_LIMIT_SCALE 10000
-
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
+
+/* Version 0 */
 struct ipt_rateinfo {
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
@@ -18,4 +19,19 @@ struct ipt_rateinfo {
 	/* Ugly, ugly fucker. */
 	struct ipt_rateinfo *master;
 };
+
+/* Version 1 */
+struct ipt_rateinfo_v1 {
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+	u_int8_t invert;
+
+	/* Used internally by the kernel */
+	unsigned long prev;
+	u_int32_t credit;
+	u_int32_t credit_cap, cost;
+
+	/* Ugly, ugly fucker. */
+	struct ipt_rateinfo_v1 *master;
+};
 #endif /*_IPT_RATE_H*/
diff -urpN linux-source-2.6.13/net/ipv4/netfilter/ipt_limit.c linux-source-2.6.13.lavoro/net/ipv4/netfilter/ipt_limit.c
--- linux-source-2.6.13/net/ipv4/netfilter/ipt_limit.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-source-2.6.13.lavoro/net/ipv4/netfilter/ipt_limit.c	2005-10-19 16:12:34.000000000 +0200
@@ -63,7 +63,7 @@ static DEFINE_SPINLOCK(limit_lock);
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static int
-ipt_limit_match(const struct sk_buff *skb,
+ipt_limit_match_v0(const struct sk_buff *skb,
 		const struct net_device *in,
 		const struct net_device *out,
 		const void *matchinfo,
@@ -89,6 +89,34 @@ ipt_limit_match(const struct sk_buff *sk
 	return 0;
 }
 
+
+static int
+ipt_limit_match_v1(const struct sk_buff *skb,
+		const struct net_device *in,
+		const struct net_device *out,
+		const void *matchinfo,
+		int offset,
+		int *hotdrop)
+{
+	struct ipt_rateinfo_v1 *r = ((struct ipt_rateinfo_v1 *)matchinfo)->master;
+	unsigned long now = jiffies;
+
+	spin_lock_bh(&limit_lock);
+	r->credit += (now - xchg(&r->prev, now)) * CREDITS_PER_JIFFY;
+	if (r->credit > r->credit_cap)
+		r->credit = r->credit_cap;
+
+	if (r->credit >= r->cost) {
+		/* We're under the limit. */
+		r->credit -= r->cost;
+		spin_unlock_bh(&limit_lock);
+		return !r->invert;
+	}
+
+       	spin_unlock_bh(&limit_lock);
+	return r->invert;
+}
+
 /* Precision saver. */
 static u_int32_t
 user2credits(u_int32_t user)
@@ -102,7 +130,7 @@ user2credits(u_int32_t user)
 }
 
 static int
-ipt_limit_checkentry(const char *tablename,
+ipt_limit_checkentry_v0(const char *tablename,
 		     const struct ipt_ip *ip,
 		     void *matchinfo,
 		     unsigned int matchsize,
@@ -134,23 +162,74 @@ ipt_limit_checkentry(const char *tablena
 	return 1;
 }
 
-static struct ipt_match ipt_limit_reg = {
+static int
+ipt_limit_checkentry_v1(const char *tablename,
+		     const struct ipt_ip *ip,
+		     void *matchinfo,
+		     unsigned int matchsize,
+		     unsigned int hook_mask)
+{
+	struct ipt_rateinfo_v1 *r = matchinfo;
+
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_rateinfo_v1)))
+		return 0;
+
+	/* Check for overflow. */
+	if (r->burst == 0
+	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
+		printk("Overflow in ipt_limit, try lower: %u/%u\n",
+		       r->avg, r->burst);
+		return 0;
+	}
+
+	/* User avg in seconds * IPT_LIMIT_SCALE: convert to jiffies *
+	   128. */
+	r->prev = jiffies;
+	r->credit = user2credits(r->avg * r->burst);	 /* Credits full. */
+	r->credit_cap = user2credits(r->avg * r->burst); /* Credits full. */
+	r->cost = user2credits(r->avg);
+
+	/* For SMP, we only want to use one set of counters. */
+	r->master = r;
+
+	return 1;
+}
+
+
+static struct ipt_match ipt_limit_reg_v0 = {
 	.name		= "limit",
-	.match		= ipt_limit_match,
-	.checkentry	= ipt_limit_checkentry,
+	.match		= ipt_limit_match_v0,
+	.checkentry	= ipt_limit_checkentry_v0,
 	.me		= THIS_MODULE,
+	.revision	= 0,
 };
 
+static struct ipt_match ipt_limit_reg_v1 = {
+	.name		= "limit",
+	.match		= ipt_limit_match_v1,
+	.checkentry	= ipt_limit_checkentry_v1,
+	.me		= THIS_MODULE,
+	.revision	= 1,
+};
+
+
 static int __init init(void)
 {
-	if (ipt_register_match(&ipt_limit_reg))
-		return -EINVAL;
-	return 0;
+	int err;
+
+	err = ipt_register_match(&ipt_limit_reg_v0);
+	if (!err) {
+		err = ipt_register_match(&ipt_limit_reg_v1);
+		if (err)
+			ipt_unregister_match(&ipt_limit_reg_v0);
+	}
+	return err;
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_match(&ipt_limit_reg);
+	ipt_unregister_match(&ipt_limit_reg_v0);
+	ipt_unregister_match(&ipt_limit_reg_v1);
 }
 
 module_init(init);
diff -upr iptables-1.3.3.orig/extensions/libipt_limit.c iptables-1.3.3/extensions/libipt_limit.c
--- iptables-1.3.3.orig/extensions/libipt_limit.c	2005-02-19 20:19:17.000000000 +0100
+++ iptables-1.3.3/extensions/libipt_limit.c	2005-10-19 21:16:46.000000000 +0200
@@ -19,7 +19,7 @@
 
 /* Function which prints out usage message. */
 static void
-help(void)
+help_v0(void)
 {
 	printf(
 "limit v%s options:\n"
@@ -30,6 +30,19 @@ help(void)
 "\n", IPTABLES_VERSION, IPT_LIMIT_BURST);
 }
 
+static void
+help_v1(void)
+{
+	printf(
+"limit v%s options:\n"
+"[!] --limit avg			max average match rate: default "IPT_LIMIT_AVG"\n"
+"                                [Packets per second unless followed by \n"
+"                                /sec /minute /hour /day postfixes]\n"
+"--limit-burst number		number to match in a burst, default %u\n"
+"\n", IPTABLES_VERSION, IPT_LIMIT_BURST);
+}
+
+
 static struct option opts[] = {
 	{ "limit", 1, 0, '%' },
 	{ "limit-burst", 1, 0, '$' },
@@ -74,7 +87,7 @@ int parse_rate(const char *rate, u_int32
 
 /* Initialize the match. */
 static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
+init_v0(struct ipt_entry_match *m, unsigned int *nfcache)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)m->data;
 
@@ -83,6 +96,18 @@ init(struct ipt_entry_match *m, unsigned
 
 }
 
+/* Initialize the match. */
+static void
+init_v1(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	struct ipt_rateinfo_v1 *r = (struct ipt_rateinfo_v1 *)m->data;
+
+	parse_rate(IPT_LIMIT_AVG, &r->avg);
+	r->burst = IPT_LIMIT_BURST;
+
+}
+
+
 /* FIXME: handle overflow:
 	if (r->avg*r->burst/r->burst != r->avg)
 		exit_error(PARAMETER_PROBLEM,
@@ -92,7 +117,7 @@ init(struct ipt_entry_match *m, unsigned
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
+parse_v0(int c, char **argv, int invert, unsigned int *flags,
       const struct ipt_entry *entry,
       unsigned int *nfcache,
       struct ipt_entry_match **match)
@@ -122,11 +147,49 @@ parse(int c, char **argv, int invert, un
 
 	if (invert)
 		exit_error(PARAMETER_PROBLEM,
-			   "limit does not support invert");
+			   "update the kernel to use '!' with limit");
 
 	return 1;
 }
 
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_rateinfo_v1 *r = (struct ipt_rateinfo_v1 *)(*match)->data;
+	unsigned int num;
+
+	switch(c) {
+	case '%':
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (!parse_rate(optarg, &r->avg))
+			exit_error(PARAMETER_PROBLEM,
+				   "bad rate `%s'", optarg);
+		break;
+
+	case '$':
+		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (string_to_number(optarg, 0, 10000, &num) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "bad --limit-burst `%s'", optarg);
+		r->burst = num;
+		break;
+
+	default:
+		return 0;
+	}
+
+	if (invert)
+		 r->invert = 1;
+
+	return 1;
+}
+
+
 /* Final check; nothing. */
 static void final_check(unsigned int flags)
 {
@@ -156,7 +219,7 @@ static void print_rate(u_int32_t period)
 
 /* Prints out the matchinfo. */
 static void
-print(const struct ipt_ip *ip,
+print_v0(const struct ipt_ip *ip,
       const struct ipt_entry_match *match,
       int numeric)
 {
@@ -165,8 +228,22 @@ print(const struct ipt_ip *ip,
 	printf("burst %u ", r->burst);
 }
 
+/* Prints out the matchinfo. */
+static void
+print_v1(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_rateinfo_v1 *r = (struct ipt_rateinfo_v1 *)match->data;
+        if (r->invert)
+		printf("! ");
+	printf("limit: avg "); print_rate(r->avg);
+	printf("burst %u ", r->burst);
+}
+
+
 /* FIXME: Make minimalist: only print rate if not default --RR */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+static void save_v0(const struct ipt_ip *ip, const struct ipt_entry_match *match)
 {
 	struct ipt_rateinfo *r = (struct ipt_rateinfo *)match->data;
 
@@ -175,22 +252,52 @@ static void save(const struct ipt_ip *ip
 		printf("--limit-burst %u ", r->burst);
 }
 
-static struct iptables_match limit = { 
+/* FIXME: Make minimalist: only print rate if not default --RR */
+static void save_v1(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_rateinfo_v1 *r = (struct ipt_rateinfo_v1 *)match->data;
+
+	printf("--limit "); print_rate(r->avg);
+	if (r->burst != IPT_LIMIT_BURST)
+		printf("--limit-burst %u ", r->burst);
+}
+
+
+static struct iptables_match limit_v0 = { 
 	.next		= NULL,
 	.name		= "limit",
 	.version	= IPTABLES_VERSION,
+	.revision	= 0,
 	.size		= IPT_ALIGN(sizeof(struct ipt_rateinfo)),
 	.userspacesize	= offsetof(struct ipt_rateinfo, prev),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
+	.help		= &help_v0,
+	.init		= &init_v0,
+	.parse		= &parse_v0,
+	.final_check	= &final_check,
+	.print		= &print_v0,
+	.save		= &save_v0,
+	.extra_opts	= opts
+};
+
+static struct iptables_match limit_v1 = { 
+	.next		= NULL,
+	.name		= "limit",
+	.version	= IPTABLES_VERSION,
+	.revision	= 1,
+	.size		= IPT_ALIGN(sizeof(struct ipt_rateinfo_v1)),
+	.userspacesize	= offsetof(struct ipt_rateinfo_v1, prev),
+	.help		= &help_v1,
+	.init		= &init_v1,
+	.parse		= &parse_v1,
 	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
+	.print		= &print_v1,
+	.save		= &save_v1,
 	.extra_opts	= opts
 };
 
+
 void _init(void)
 {
-	register_match(&limit);
+	register_match(&limit_v0);
+	register_match(&limit_v1);
 }
diff -upr iptables-1.3.3.orig/include/linux/netfilter_ipv4/ipt_limit.h iptables-1.3.3/include/linux/netfilter_ipv4/ipt_limit.h
--- iptables-1.3.3.orig/include/linux/netfilter_ipv4/ipt_limit.h	2004-10-10 11:56:23.000000000 +0200
+++ iptables-1.3.3/include/linux/netfilter_ipv4/ipt_limit.h	2005-10-19 20:21:47.000000000 +0200
@@ -3,9 +3,10 @@
 
 /* timings are in milliseconds. */
 #define IPT_LIMIT_SCALE 10000
-
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
+
+/* Version 0 */
 struct ipt_rateinfo {
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
@@ -23,4 +24,25 @@ struct ipt_rateinfo {
 	u_int32_t credit;
 	u_int32_t credit_cap, cost;
 };
+
+/* Version 1 */
+struct ipt_rateinfo_v1 {
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+        u_int8_t invert;
+
+#ifdef KERNEL_64_USERSPACE_32
+	u_int64_t prev;
+	u_int64_t placeholder;
+#else
+	/* Used internally by the kernel */
+	unsigned long prev;
+	/* Ugly, ugly fucker. */
+	struct ipt_rateinfo_v1 *master;
+#endif
+
+	u_int32_t credit;
+	u_int32_t credit_cap, cost;
+};
+
 #endif /*_IPT_RATE_H*/


 

-- 
Ciao
     Marco Innocenti
