From: Vivek Kashyap <vivk@us.ibm.com>
Subject: Re: [PATCH] RANGEMARK target
Date: Tue, 4 Nov 2003 23:26:43 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311042248400.1197-100000@dyn319477.beaverton.ibm.com>
References: <20031031143849.GE21066@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031031143849.GE21066@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 31 Oct 2003, Harald Welte wrote:

> On Mon, Oct 27, 2003 at 02:57:28PM -0800, Vivek Kashyap wrote:
> > I wanted to MARK packets dynamically within a certain range. 
> 
> Ok, thanks for this contribution.
> 
> > Please comment. I'll then update with necessary changes and also
> > add ip6t_* target. 
> 
> I'm going to comment inline.
> 

I've updated the patch as per the comments.

Vivek

-------------------------------------------------------------------
diff -urN iptables-1.2.9.orig/extensions/libip6t_RANGEMARK.c iptables-1.2.9rc1/extensions/libip6t_RANGEMARK.c
--- iptables-1.2.9.orig/extensions/libip6t_RANGEMARK.c	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/extensions/libip6t_RANGEMARK.c	2003-11-04 14:25:16.000000000 -0800
@@ -0,0 +1,293 @@
+/* Shared library add-on to iptables to add RANGEMARK target support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+
+#include <ip6tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6t_RANGEMARK.h>
+
+struct rangemarkinfo {
+	struct ip6t_entry_target t;
+	struct ip6t_rangemark_target_info rangemark;
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"RANGEMARK target v%s options:\n"
+"  --set-rangemark base[-limit[.k][:r]][,S|O|A]] Set random nfmark within range"
+"\n"
+"  --set-rangemark base[-limit[.k][:h]][,S|O|A]] Set nfmark based on ports"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "set-rangemark", 1, 0, '1' },
+	{ 0 }
+};
+
+static char *
+get_val(char *s, unsigned long *val)
+{
+	char *ep = s;
+	
+	if (NULL == s)
+		return NULL;
+
+	if (*s == '\0') 
+		exit_error(PARAMETER_PROBLEM, "Invalid base-limit specified");
+
+	while(isalnum(*ep++));
+
+	/*
+	 * Out of range values are clipped at ULONG_MAX
+	 */
+	*val  = strtoul(s,&ep,0);
+
+	return ep;
+}
+
+static char *
+get_baseval(char *s, unsigned long *val, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_BASE)
+		exit_error(PARAMETER_PROBLEM, 
+			"set-rangemark: Base specified twice");
+
+	*flags |= RANGEMARK_FLAG_BASE;
+
+	return get_val(s, val);
+}
+
+static char *
+get_limitval(char *s, unsigned long *val, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_LIMIT)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Limit specified twice");
+
+	*flags |= RANGEMARK_FLAG_LIMIT;
+
+	return get_val(s, val);
+}
+
+static char *
+get_incrval(char *s, unsigned long *val, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_INCRVALUE)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Increment specified twice");
+
+	*flags |= RANGEMARK_FLAG_INCRVALUE;
+
+	return get_val(s, val);
+}
+
+static char *
+get_policy(char *s, char *policy, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_POLICY)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Policy specified twice");
+
+	*flags |= RANGEMARK_FLAG_POLICY;
+
+	switch(*s) {
+	case 'r': /* random */
+	case 'h': /* port hash */
+		*policy = *s;
+		break;
+
+	default: /* unrecognised */
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Unrecognised policy");
+		return NULL;
+	}
+
+	return ++s;
+}
+
+	
+static char *
+get_op(char *s, char *op, unsigned *flags)
+{
+	if (*flags & RANGEMARK_FLAG_OP)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Policy specified twice");
+
+	*flags |= RANGEMARK_FLAG_OP;
+
+	switch(*s) {
+	case 'S': /* Set the value overwriting any existing value */
+	case 'O': /* OR the value with the existing value */
+	case 'A': /* AND the value with the existing value */
+		*op = *s;
+		break;
+
+	default: /* unrecognised */
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Unrecognised operation");
+		return NULL;
+	}
+	return ++s;
+}
+	
+
+static int
+parse_params(int c, struct ip6t_rangemark_target_info *rinfo, char **argv, 
+			unsigned int *flags)
+{
+
+	char *ptr = NULL;
+	unsigned long mask;
+
+	switch(c) {
+	case '1': 
+		/* Calculate the base value */
+		ptr = get_baseval(optarg, &rinfo->base, flags);
+
+		/* Get the limit if present */
+		if (ptr && *ptr == '-') {
+			ptr = get_limitval(++ptr, &rinfo->limit, flags);
+		}
+
+		/* Get the incr value if present */
+		if (ptr && *ptr == '.') {
+			ptr = get_incrval(++ptr, &rinfo->incr, flags);
+		}
+
+		/* Get the policy if specified */
+		if (ptr && ( *ptr == ':')){
+				ptr = get_policy(++ptr, &rinfo->policy, flags);
+		}
+
+		/* Get the operation if specified */
+		if (ptr && *ptr == ',') {
+			ptr = get_op(++ptr, &rinfo->op, flags);
+		}
+
+		if (ptr && *ptr) {
+			exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Unrecognised option");
+		}
+
+		if (!(*flags & RANGEMARK_FLAG_LIMIT))
+			rinfo->limit = rinfo->base;
+		if (!(*flags & RANGEMARK_FLAG_INCRVALUE))
+			rinfo->incr = 1;
+		if (!(*flags & RANGEMARK_FLAG_POLICY))
+			rinfo->policy = RANGEMARK_POLICY_RANDOM;
+		if (!(*flags & RANGEMARK_FLAG_OP))
+			rinfo->op = RANGEMARK_OP_SET;
+
+		/*
+		 * Set the mask 
+		 */
+		mask = rinfo->limit - rinfo->base;
+		rinfo->mask = 1;
+		while(mask >>= 1)
+			rinfo->mask = (rinfo->mask << 1) | 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Initialize the target. */
+static void
+init(struct ip6t_entry_target *t, unsigned int *nfcache)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	  const struct ip6t_entry *entry,
+	  struct ip6t_entry_target **target)
+{
+
+	int ret = 0;
+	struct ip6t_rangemark_target_info *rangeinfo = 
+			(struct ip6t_rangemark_target_info *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: invert flag used\n");
+		ret = parse_params(c, rangeinfo, argv, flags);
+		break;
+
+	default:
+		return 0;
+	}
+
+	return ret;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+static void
+print_rangemark(struct ip6t_rangemark_target_info *r)
+{
+	printf("RANGEMARK Policy: %s Range: 0x%lx-0x%lx Incr: 0x%lx : %s  ", 
+		r->policy == 'h' ? "Hash" : "Random",
+		r->base, r->limit, r->incr,
+		r->op == 'S' ? "Set" : (r->op == 'O' ? "OR" : "AND")); 
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ip6t_ip6 *ip,
+	  const struct ip6t_entry_target *target,
+	  int numeric)
+{
+	struct ip6t_rangemark_target_info *rinfo =
+		(struct ip6t_rangemark_target_info *)target->data;
+	print_rangemark(rinfo);
+}
+
+/* Saves the union ip6t_targinfo in parsable form to stdout. */
+static void
+save(const struct ip6t_ip6 *ip, const struct ip6t_entry_target *target)
+{
+	struct ip6t_rangemark_target_info *r =
+		(struct ip6t_rangemark_target_info *)target->data;
+
+	printf("--set-rangemark %lu-%lu.%lu:%c,%c",r->base, r->limit,
+			r->incr, r->policy, r->op);
+}
+
+static
+struct ip6tables_target rangemark
+= {	NULL,
+	"RANGEMARK",
+	IPTABLES_VERSION,
+	IP6T_ALIGN(sizeof(struct ip6t_rangemark_target_info)),
+	IP6T_ALIGN(sizeof(struct ip6t_rangemark_target_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+void _init(void)
+{
+	register_target6(&rangemark);
+}
diff -urN iptables-1.2.9.orig/extensions/libipt_RANGEMARK.c iptables-1.2.9rc1/extensions/libipt_RANGEMARK.c
--- iptables-1.2.9.orig/extensions/libipt_RANGEMARK.c	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/extensions/libipt_RANGEMARK.c	2003-11-04 14:25:29.000000000 -0800
@@ -0,0 +1,294 @@
+/* Shared library add-on to iptables to add RANGEMARK target support. */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <ctype.h>
+
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_RANGEMARK.h>
+
+struct rangemarkinfo {
+    struct ipt_entry_target t;
+    struct ipt_rangemark_target_info rangemark;
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"RANGEMARK target v%s options:\n"
+"  --set-rangemark base[-limit[.k][:r]][,S|O|A]] Set random nfmark within range"
+"\n"
+"  --set-rangemark base[-limit[.k][:h]][,S|O|A]] Set nfmark based on ports"
+"\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "set-rangemark", 1, 0, '1' },
+	{ 0 }
+};
+
+static char *
+get_val(char *s, unsigned long *val)
+{
+	char *ep = s;
+	
+	if (NULL == s)
+		return NULL;
+
+	if (*s == '\0') 
+		exit_error(PARAMETER_PROBLEM, "Invalid base-limit specified");
+
+	while(isalnum(*ep++));
+
+	/*
+	 * Out of range values are clipped at ULONG_MAX
+	 */
+	*val  = strtoul(s,&ep,0);
+
+	return ep;
+}
+
+static char *
+get_baseval(char *s, unsigned long *val, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_BASE)
+		exit_error(PARAMETER_PROBLEM, 
+			"set-rangemark: Base specified twice");
+
+	*flags |= RANGEMARK_FLAG_BASE;
+
+	return get_val(s, val);
+}
+
+static char *
+get_limitval(char *s, unsigned long *val, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_LIMIT)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Limit specified twice");
+
+	*flags |= RANGEMARK_FLAG_LIMIT;
+
+	return get_val(s, val);
+}
+
+static char *
+get_incrval(char *s, unsigned long *val, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_INCRVALUE)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Increment specified twice");
+
+	*flags |= RANGEMARK_FLAG_INCRVALUE;
+
+	return get_val(s, val);
+}
+
+static char *
+get_policy(char *s, char *policy, unsigned int *flags)
+{
+	if (*flags & RANGEMARK_FLAG_POLICY)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Policy specified twice");
+
+	*flags |= RANGEMARK_FLAG_POLICY;
+
+	switch(*s) {
+	case 'r': /* random */
+	case 'h': /* port hash */
+		*policy = *s;
+		break;
+
+	default: /* unrecognised */
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Unrecognised policy");
+		return NULL;
+	}
+
+	return ++s;
+}
+
+	
+static char *
+get_op(char *s, char *op, unsigned *flags)
+{
+	if (*flags & RANGEMARK_FLAG_OP)
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Policy specified twice");
+
+	*flags |= RANGEMARK_FLAG_OP;
+
+	switch(*s) {
+	case 'S': /* Set the value overwriting any existing value */
+	case 'O': /* OR the value with the existing value */
+	case 'A': /* AND the value with the existing value */
+		*op = *s;
+		break;
+
+	default: /* unrecognised */
+		exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Unrecognised operation");
+		return NULL;
+	}
+	return ++s;
+}
+	
+
+static int
+parse_params(int c, struct ipt_rangemark_target_info *rinfo, char **argv, 
+			unsigned int *flags)
+{
+
+	char *ptr = NULL;
+	unsigned long mask;
+
+	switch(c) {
+	case '1': 
+		/* Calculate the base value */
+		ptr = get_baseval(optarg, &rinfo->base, flags);
+
+		/* Get the limit if present */
+		if (ptr && *ptr == '-') {
+			ptr = get_limitval(++ptr, &rinfo->limit, flags);
+		}
+
+		/* Get the incr value if present */
+		if (ptr && *ptr == '.') {
+			ptr = get_incrval(++ptr, &rinfo->incr, flags);
+		}
+
+		/* Get the policy if specified */
+		if (ptr && ( *ptr == ':')){
+				ptr = get_policy(++ptr, &rinfo->policy, flags);
+		}
+
+		/* Get the operation if specified */
+		if (ptr && *ptr == ',') {
+			ptr = get_op(++ptr, &rinfo->op, flags);
+		}
+
+		if (ptr && *ptr) {
+			exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: Unrecognised option");
+		}
+
+		if (!(*flags & RANGEMARK_FLAG_LIMIT))
+			rinfo->limit = rinfo->base;
+		if (!(*flags & RANGEMARK_FLAG_INCRVALUE))
+			rinfo->incr = 1;
+		if (!(*flags & RANGEMARK_FLAG_POLICY))
+			rinfo->policy = RANGEMARK_POLICY_RANDOM;
+		if (!(*flags & RANGEMARK_FLAG_OP))
+			rinfo->op = RANGEMARK_OP_SET;
+
+		/*
+		 * Set the mask 
+		 */
+		mask = rinfo->limit - rinfo->base;
+		rinfo->mask = 1;
+		while(mask >>= 1)
+			rinfo->mask = (rinfo->mask << 1) | 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Initialize the target. */
+static void
+init(struct ipt_entry_target *t, unsigned int *nfcache)
+{
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+	  const struct ipt_entry *entry,
+	  struct ipt_entry_target **target)
+{
+
+	int ret = 0;
+	struct ipt_rangemark_target_info *rangeinfo = 
+			(struct ipt_rangemark_target_info *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM, 
+				"set-rangemark: invert flag used\n");
+		ret = parse_params(c, rangeinfo, argv, flags);
+		break;
+
+	default:
+		return 0;
+	}
+
+	return ret;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+static void
+print_rangemark(struct ipt_rangemark_target_info *r)
+{
+	printf("RANGEMARK Policy: %s Range: 0x%lx-0x%lx Incr: 0x%lx : %s  ", 
+		r->policy == 'h' ? "Hash" : "Random",
+		r->base, r->limit, r->incr,
+		r->op == 'S' ? "Set" : (r->op == 'O' ? "OR" : "AND")); 
+}
+
+/* Prints out the targinfo. */
+static void
+print(const struct ipt_ip *ip,
+	  const struct ipt_entry_target *target,
+	  int numeric)
+{
+	struct ipt_rangemark_target_info *rinfo =
+		(struct ipt_rangemark_target_info *)target->data;
+	print_rangemark(rinfo);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void
+save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
+{
+	struct ipt_rangemark_target_info *r =
+		(struct ipt_rangemark_target_info *)target->data;
+
+	printf("--set-rangemark %lu-%lu.%lu:%c,%c",r->base, r->limit,
+			r->incr, r->policy, r->op);
+
+}
+
+static
+struct iptables_target rangemark
+= { NULL,
+	"RANGEMARK",
+	IPTABLES_VERSION,
+	IPT_ALIGN(sizeof(struct ipt_rangemark_target_info)),
+	IPT_ALIGN(sizeof(struct ipt_rangemark_target_info)),
+	&help,
+	&init,
+	&parse,
+	&final_check,
+	&print,
+	&save,
+	opts
+};
+
+void _init(void)
+{
+	register_target(&rangemark);
+}
diff -urN iptables-1.2.9.orig/extensions/.RANGEMARK-test iptables-1.2.9rc1/extensions/.RANGEMARK-test
--- iptables-1.2.9.orig/extensions/.RANGEMARK-test	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/extensions/.RANGEMARK-test	2003-11-03 21:17:44.000000000 -0800
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_RANGEMARK.c ] && echo RANGEMARK
diff -urN iptables-1.2.9.orig/extensions/.RANGEMARK-test6 iptables-1.2.9rc1/extensions/.RANGEMARK-test6
--- iptables-1.2.9.orig/extensions/.RANGEMARK-test6	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/extensions/.RANGEMARK-test6	2003-11-03 21:46:59.000000000 -0800
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv6/netfilter/ip6t_RANGEMARK.c ] && echo RANGEMARK
diff -urN iptables-1.2.9.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_RANGEMARK.h
--- iptables-1.2.9.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	2003-11-04 14:26:29.000000000 -0800
@@ -0,0 +1,40 @@
+#ifndef _IPT_RANGEMARK_H_target
+#define _IPT_RANGEMARK_H_target
+
+#include <linux/spinlock.h>
+
+/*
+ * Policy
+ */
+#define RANGEMARK_POLICY_RANDOM	'r'
+#define RANGEMARK_POLICY_PORTHASH 	'h'
+
+/*
+ * Operations
+ */
+#define RANGEMARK_OP_SET 	'S'
+#define RANGEMARK_OP_OR 	'O'
+#define RANGEMARK_OP_AND 	'A'
+
+/*
+ * Flags
+ */
+enum rangemark_flags {
+	RANGEMARK_FLAG_BASE = 1,
+	RANGEMARK_FLAG_LIMIT = 2,
+	RANGEMARK_FLAG_POLICY = 4,
+	RANGEMARK_FLAG_OP = 8,
+	RANGEMARK_FLAG_INCRVALUE = 16,
+};
+
+struct ipt_rangemark_target_info {
+	unsigned long	base;
+	unsigned long 	limit;
+	unsigned long	rsize;
+	unsigned long	incr;
+	signed   long   mask;
+	char		policy;
+	char 		op;
+};
+
+#endif /*_IPT_RANGEMARK_H_target*/
diff -urN iptables-1.2.9.orig/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h iptables-1.2.9rc1/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h
--- iptables-1.2.9.orig/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h	1969-12-31 16:00:00.000000000 -0800
+++ iptables-1.2.9rc1/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h	2003-11-04 14:26:42.000000000 -0800
@@ -0,0 +1,40 @@
+#ifndef _IP6T_RANGEMARK_H_target
+#define _IP6T_RANGEMARK_H_target
+
+#include <linux/spinlock.h>
+
+/*
+ * Policy
+ */
+#define RANGEMARK_POLICY_RANDOM	'r'
+#define RANGEMARK_POLICY_PORTHASH 	'h'
+
+/*
+ * Operations
+ */
+#define RANGEMARK_OP_SET 	'S'
+#define RANGEMARK_OP_OR 	'O'
+#define RANGEMARK_OP_AND 	'A'
+
+/*
+ * Flags
+ */
+enum rangemark_flags {
+	RANGEMARK_FLAG_BASE = 1,
+	RANGEMARK_FLAG_LIMIT = 2,
+	RANGEMARK_FLAG_POLICY = 4,
+	RANGEMARK_FLAG_OP = 8,
+	RANGEMARK_FLAG_INCRVALUE = 16,
+};
+
+struct ip6t_rangemark_target_info {
+	unsigned long	base;
+	unsigned long 	limit;
+	unsigned long	rsize;
+	unsigned long	incr;
+	signed   long   mask;
+	char		policy;
+	char 		op;
+};
+
+#endif /*_IP6T_RANGEMARK_H_target*/
diff -urN linux-2.4.22.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h linux-2.4.22/include/linux/netfilter_ipv4/ipt_RANGEMARK.h
--- linux-2.4.22.orig/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.4.22/include/linux/netfilter_ipv4/ipt_RANGEMARK.h	2003-11-04 14:24:12.000000000 -0800
@@ -0,0 +1,40 @@
+#ifndef _IPT_RANGEMARK_H_target
+#define _IPT_RANGEMARK_H_target
+
+#include <linux/spinlock.h>
+
+/*
+ * Policy
+ */
+#define RANGEMARK_POLICY_RANDOM	'r'
+#define RANGEMARK_POLICY_PORTHASH 	'h'
+
+/*
+ * Operations
+ */
+#define RANGEMARK_OP_SET 	'S'
+#define RANGEMARK_OP_OR 	'O'
+#define RANGEMARK_OP_AND 	'A'
+
+/*
+ * Flags
+ */
+enum rangemark_flags {
+	RANGEMARK_FLAG_BASE = 1,
+	RANGEMARK_FLAG_LIMIT = 2,
+	RANGEMARK_FLAG_POLICY = 4,
+	RANGEMARK_FLAG_OP = 8,
+	RANGEMARK_FLAG_INCRVALUE = 16,
+};
+
+struct ipt_rangemark_target_info {
+	unsigned long	base;
+	unsigned long 	limit;
+	unsigned long	rsize;
+	unsigned long	incr;
+	signed   long   mask;
+	char		policy;
+	char 		op;
+};
+
+#endif /*_IPT_RANGEMARK_H_target*/
diff -urN linux-2.4.22.orig/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h linux-2.4.22/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h
--- linux-2.4.22.orig/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.4.22/include/linux/netfilter_ipv6/ip6t_RANGEMARK.h	2003-11-04 14:24:25.000000000 -0800
@@ -0,0 +1,40 @@
+#ifndef _IP6T_RANGEMARK_H_target
+#define _IP6T_RANGEMARK_H_target
+
+#include <linux/spinlock.h>
+
+/*
+ * Policy
+ */
+#define RANGEMARK_POLICY_RANDOM	'r'
+#define RANGEMARK_POLICY_PORTHASH 	'h'
+
+/*
+ * Operations
+ */
+#define RANGEMARK_OP_SET 	'S'
+#define RANGEMARK_OP_OR 	'O'
+#define RANGEMARK_OP_AND 	'A'
+
+/*
+ * Flags
+ */
+enum rangemark_flags {
+	RANGEMARK_FLAG_BASE = 1,
+	RANGEMARK_FLAG_LIMIT = 2,
+	RANGEMARK_FLAG_POLICY = 4,
+	RANGEMARK_FLAG_OP = 8,
+	RANGEMARK_FLAG_INCRVALUE = 16,
+};
+
+struct ip6t_rangemark_target_info {
+	unsigned long	base;
+	unsigned long 	limit;
+	unsigned long	rsize;
+	unsigned long	incr;
+	signed   long   mask;
+	char		policy;
+	char 		op;
+};
+
+#endif /*_IP6T_RANGEMARK_H_target*/
diff -urN linux-2.4.22.orig/net/ipv4/netfilter/Config.in linux-2.4.22/net/ipv4/netfilter/Config.in
--- linux-2.4.22.orig/net/ipv4/netfilter/Config.in	2003-08-25 04:44:44.000000000 -0700
+++ linux-2.4.22/net/ipv4/netfilter/Config.in	2003-11-04 15:54:59.000000000 -0800
@@ -104,6 +104,7 @@
     dep_tristate '    DSCP target support' CONFIG_IP_NF_TARGET_DSCP $CONFIG_IP_NF_MANGLE
  
     dep_tristate '    MARK target support' CONFIG_IP_NF_TARGET_MARK $CONFIG_IP_NF_MANGLE
+    dep_tristate '    RANGEMARK target support' CONFIG_IP_NF_TARGET_RANGEMARK $CONFIG_IP_NF_MANGLE
   fi
   dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF_IPTABLES
   dep_tristate '  ULOG target support' CONFIG_IP_NF_TARGET_ULOG $CONFIG_IP_NF_IPTABLES
diff -urN linux-2.4.22.orig/net/ipv4/netfilter/ipt_RANGEMARK.c linux-2.4.22/net/ipv4/netfilter/ipt_RANGEMARK.c
--- linux-2.4.22.orig/net/ipv4/netfilter/ipt_RANGEMARK.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.4.22/net/ipv4/netfilter/ipt_RANGEMARK.c	2003-11-04 14:22:52.000000000 -0800
@@ -0,0 +1,188 @@
+/* This is a module which is used for setting the NFMARK field of an skb. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_RANGEMARK.h>
+
+void get_random_bytes(void *buf, int nbytes);
+
+u_int16_t
+rangemark_hash(u_int16_t s, u_int16_t d)
+{
+	s = (s>>1)^(d>>1);
+	return (d & 0x1) ? 0x8000 | s : s;
+}
+
+int
+rangemark_get_size(int a, int b)
+{
+	int k = b-a;
+	int i=0;
+
+	if (k) 
+		do 
+			i++;
+		while (k >>= 8);
+	return i;
+}
+
+static unsigned int
+target(struct sk_buff **pskb,
+	const struct net_device *in,
+	const struct net_device *out,
+	unsigned int hooknum,
+	const void *targinfo,
+	void *userinfo)
+{
+	const struct ipt_rangemark_target_info *rinfo = targinfo;
+	unsigned long base = rinfo->base;
+	unsigned long limit = rinfo->limit;
+	int policy = rinfo->policy;
+	int op = rinfo->op;
+	unsigned long markval;
+	void *iptr;
+	long random = 0;
+
+	switch(policy) {
+	case RANGEMARK_POLICY_RANDOM:
+		if (rinfo->rsize) {
+			get_random_bytes(&random, rinfo->rsize);
+			markval = base + (random & rinfo->mask);
+		} else 
+			markval = base;
+
+		break;
+		
+	case RANGEMARK_POLICY_PORTHASH:
+		iptr = (void *)(*pskb)->nh.iph;
+		if (((struct iphdr *)iptr)->protocol == IPPROTO_UDP) {
+			iptr = (void *)(*pskb)->h.uh;
+			markval =rangemark_hash(((struct udphdr *)iptr)->source,
+						((struct udphdr *)iptr)->dest);
+		} else if (((struct iphdr *)iptr)->protocol == IPPROTO_TCP) {
+			iptr = (void *)(*pskb)->h.th;
+			markval =rangemark_hash(((struct tcphdr *)iptr)->source,
+						((struct tcphdr *)iptr)->dest);
+		} else {
+			/* Not for us */
+			return IPT_CONTINUE;	
+		}
+		break;
+			
+	default:
+		return IPT_CONTINUE;
+	}
+
+	markval &= ~(rinfo->incr -1);
+	if (markval < base)
+		markval = base;
+	else if (markval > limit)
+		markval = limit;
+
+	switch(op) {
+	case RANGEMARK_OP_SET:
+		if ((*pskb)->nfmark != markval) {
+			(*pskb)->nfmark = markval;
+			(*pskb)->nfcache |= NFC_ALTERED;
+		}
+		break;
+
+	case RANGEMARK_OP_AND:
+		(*pskb)->nfmark &= markval;
+		(*pskb)->nfcache |= NFC_ALTERED;
+		break;
+
+	case RANGEMARK_OP_OR:
+		(*pskb)->nfmark |= markval;
+		(*pskb)->nfcache |= NFC_ALTERED;
+		break;
+
+	default:
+		break;
+	}
+	return IPT_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+	const struct ipt_entry *e,
+	void *targinfo,
+	unsigned int targinfosize,
+	unsigned int hook_mask)
+{
+
+	struct ipt_rangemark_target_info * rinfo;
+
+	if (targinfosize!=IPT_ALIGN(sizeof(struct ipt_rangemark_target_info))) {
+		printk(KERN_WARNING "RANGEMARK: targinfosize %u != %Zu\n",
+			   targinfosize,
+			   IPT_ALIGN(sizeof(struct ipt_rangemark_target_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") != 0) {
+		printk(KERN_WARNING 
+			"RANGEMARK: can only be called from \"mangle\" table,"
+			"not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	rinfo = (struct ipt_rangemark_target_info *) targinfo;
+
+	switch(rinfo->policy) {
+	case RANGEMARK_POLICY_RANDOM:
+	case RANGEMARK_POLICY_PORTHASH:
+		break;
+
+	default:
+		printk(KERN_WARNING "RANGEMARK: Policy not supported"); 
+		return 0;
+		break; /*NOT REACHED*/
+	}
+
+	if (rinfo->base != rinfo->limit) {
+		if (rinfo->incr == 0) {
+			printk(KERN_WARNING "RANGEMARK: increment invalid\n");
+			return 0;
+		}
+		if ((rinfo->incr + rinfo->base) > rinfo->limit){
+			printk(KERN_WARNING "RANGEMARK: increment too large\n");
+			return 0;
+		}
+
+	}
+	rinfo->rsize = rangemark_get_size(rinfo->base, rinfo->limit);
+	return 1;
+}
+
+static struct ipt_target ipt_rangemark_reg = {
+	.name		= "RANGEMARK",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	if (ipt_register_target(&ipt_rangemark_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_rangemark_reg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vivek Kashyap <kashyapv@us.ibm.com>");
+MODULE_DESCRIPTION("Set mark from a range of values");
diff -urN linux-2.4.22.orig/net/ipv4/netfilter/Makefile linux-2.4.22/net/ipv4/netfilter/Makefile
--- linux-2.4.22.orig/net/ipv4/netfilter/Makefile	2003-08-25 04:44:44.000000000 -0700
+++ linux-2.4.22/net/ipv4/netfilter/Makefile	2003-11-04 15:57:35.000000000 -0800
@@ -94,6 +94,7 @@
 obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_DSCP) += ipt_DSCP.o
 obj-$(CONFIG_IP_NF_TARGET_MARK) += ipt_MARK.o
+obj-$(CONFIG_IP_NF_TARGET_RANGEMARK) += ipt_RANGEMARK.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_NAT_SNMP_BASIC) += ip_nat_snmp_basic.o
diff -urN linux-2.4.22.orig/net/ipv6/netfilter/Config.in linux-2.4.22/net/ipv6/netfilter/Config.in
--- linux-2.4.22.orig/net/ipv6/netfilter/Config.in	2003-06-13 07:51:39.000000000 -0700
+++ linux-2.4.22/net/ipv6/netfilter/Config.in	2003-11-03 22:43:16.000000000 -0800
@@ -34,6 +34,7 @@
   fi
 #  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CONFIG_IP6_NF_IPTABLES
   dep_tristate '  netfilter MARK match support' CONFIG_IP6_NF_MATCH_MARK $CONFIG_IP6_NF_IPTABLES
+  dep_tristate '  netfilter RANGEMARK match support' CONFIG_IP6_NF_MATCH_RANGEMARK $CONFIG_IP6_NF_IPTABLES
   if [ "$CONFIG_EXPERIMENTAL" = "y" ]; then
     dep_tristate '  IPv6 Extension Headers Match (EXPERIMENTAL)' CONFIG_IP6_NF_MATCH_IPV6HEADER $CONFIG_IP6_NF_IPTABLES
   fi
diff -urN linux-2.4.22.orig/net/ipv6/netfilter/ip6t_RANGEMARK.c linux-2.4.22/net/ipv6/netfilter/ip6t_RANGEMARK.c
--- linux-2.4.22.orig/net/ipv6/netfilter/ip6t_RANGEMARK.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.4.22/net/ipv6/netfilter/ip6t_RANGEMARK.c	2003-11-04 14:23:47.000000000 -0800
@@ -0,0 +1,188 @@
+/* This is a module which is used for setting the NFMARK field of an skb. */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/tcp.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6/ip6t_RANGEMARK.h>
+
+void get_random_bytes(void *buf, int nbytes);
+
+u_int16_t
+rangemark_hash(u_int16_t s, u_int16_t d)
+{
+	s = (s>>1)^(d>>1);
+	return (d & 0x1) ? 0x8000 | s : s;
+}
+
+int
+rangemark_get_size(int a, int b)
+{
+	int k = b-a;
+	int i=0;
+
+	if (k) 
+		do 
+			i++;
+		while (k >>= 8);
+	return i;
+}
+
+static unsigned int
+target(struct sk_buff **pskb,
+	const struct net_device *in,
+	const struct net_device *out,
+	unsigned int hooknum,
+	const void *targinfo,
+	void *userinfo)
+{
+	const struct ip6t_rangemark_target_info *rinfo = targinfo;
+	unsigned long base = rinfo->base;
+	unsigned long limit = rinfo->limit;
+	int policy = rinfo->policy;
+	int op = rinfo->op;
+	unsigned long markval;
+	void *iptr;
+	long random = 0;
+
+	switch(policy) {
+	case RANGEMARK_POLICY_RANDOM:
+		if (rinfo->rsize) {
+			get_random_bytes(&random, rinfo->rsize);
+			markval = base + (random & rinfo->mask);
+		} else 
+			markval = base;
+
+		break;
+		
+	case RANGEMARK_POLICY_PORTHASH:
+		iptr = (void *)(*pskb)->nh.ipv6h;
+		if (((struct ipv6hdr *)iptr)->nexthdr == NEXTHDR_UDP) {
+			iptr = (void *)(*pskb)->h.uh;
+			markval =rangemark_hash(((struct udphdr *)iptr)->source,
+						((struct udphdr *)iptr)->dest);
+		} else if (((struct ipv6hdr *)iptr)->nexthdr == NEXTHDR_TCP) {
+			iptr = (void *)(*pskb)->h.th;
+			markval =rangemark_hash(((struct tcphdr *)iptr)->source,
+						((struct tcphdr *)iptr)->dest);
+		} else {
+			/* Not for us */
+			return IP6T_CONTINUE;	
+		}
+		break;
+			
+	default:
+		return IP6T_CONTINUE;
+	}
+
+	markval &= ~(rinfo->incr -1);
+	if (markval < base)
+		markval = base;
+	else if (markval > limit)
+		markval = limit;
+
+	switch(op) {
+	case RANGEMARK_OP_SET:
+		if ((*pskb)->nfmark != markval) {
+			(*pskb)->nfmark = markval;
+			(*pskb)->nfcache |= NFC_ALTERED;
+		}
+		break;
+
+	case RANGEMARK_OP_AND:
+		(*pskb)->nfmark &= markval;
+		(*pskb)->nfcache |= NFC_ALTERED;
+		break;
+
+	case RANGEMARK_OP_OR:
+		(*pskb)->nfmark |= markval;
+		(*pskb)->nfcache |= NFC_ALTERED;
+		break;
+
+	default:
+		break;
+	}
+	return IP6T_CONTINUE;
+}
+
+static int
+checkentry(const char *tablename,
+	const struct ip6t_entry *e,
+	void *targinfo,
+	unsigned int targinfosize,
+	unsigned int hook_mask)
+{
+
+	struct ip6t_rangemark_target_info * rinfo;
+
+	if(targinfosize!=IP6T_ALIGN(sizeof(struct ip6t_rangemark_target_info))){
+		printk(KERN_WARNING "RANGEMARK: targinfosize %u != %Zu\n",
+			targinfosize,
+			IP6T_ALIGN(sizeof(struct ip6t_rangemark_target_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") != 0) {
+		printk(KERN_WARNING 
+			"RANGEMARK: can only be called from \"mangle\" table,"
+			"not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	rinfo = (struct ip6t_rangemark_target_info *) targinfo;
+
+	switch(rinfo->policy) {
+	case RANGEMARK_POLICY_RANDOM:
+	case RANGEMARK_POLICY_PORTHASH:
+		break;
+
+	default:
+		printk(KERN_WARNING "RANGEMARK: Policy not supported"); 
+		return 0;
+		break; /*NOT REACHED*/
+	}
+
+	if (rinfo->base != rinfo->limit) {
+		if (rinfo->incr == 0) {
+			printk(KERN_WARNING "RANGEMARK: increment invalid\n");
+			return 0;
+		}
+		if ((rinfo->incr + rinfo->base) > rinfo->limit){
+			printk(KERN_WARNING "RANGEMARK: increment too large\n");
+			return 0;
+		}
+
+	}
+	rinfo->rsize = rangemark_get_size(rinfo->base, rinfo->limit);
+	return 1;
+}
+
+static struct ip6t_target ip6t_rangemark_reg = {
+	.name		= "RANGEMARK",
+	.target		= target,
+	.checkentry	= checkentry,
+	.me		= THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	if (ip6t_register_target(&ip6t_rangemark_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ip6t_unregister_target(&ip6t_rangemark_reg);
+}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vivek Kashyap <kashyapv@us.ibm.com>");
+MODULE_DESCRIPTION("Set mark from a range of values");
diff -urN linux-2.4.22.orig/net/ipv6/netfilter/Makefile linux-2.4.22/net/ipv6/netfilter/Makefile
--- linux-2.4.22.orig/net/ipv6/netfilter/Makefile	2003-06-13 07:51:39.000000000 -0700
+++ linux-2.4.22/net/ipv6/netfilter/Makefile	2003-11-04 16:06:41.000000000 -0800
@@ -28,6 +28,7 @@
 obj-$(CONFIG_IP6_NF_FILTER) += ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) += ip6table_mangle.o
 obj-$(CONFIG_IP6_NF_TARGET_MARK) += ip6t_MARK.o
+obj-$(CONFIG_IP6_NF_TARGET_RANGEMARK) += ip6t_RANGEMARK.o
 obj-$(CONFIG_IP6_NF_QUEUE) += ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
 obj-$(CONFIG_IP6_NF_MATCH_HL) += ip6t_hl.o
