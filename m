From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] connbytes match
Date: Wed, 18 Jun 2003 14:28:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EF05B04.8050608@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050802070603010405080401"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050802070603010405080401
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I'm sending this patch on behalf of Martin Devera <devik@cdi.cz>. It adds a
new match 'connbytes' which matches the transfered bytes of a connection.
This is mostly useful for reclassifying big downloads. Martins originals 
patch
can be found here: http://luxik.cdi.cz/~devik/connbytes (for 2.4.17).
There have been requests for such a match from time to time, please
consider for inclusion.

Best regards,
Patrick

--------------050802070603010405080401
Content-Type: text/plain;
 name="nf-connbytes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf-connbytes.diff"

diff -urN ../nf/netfilter/patch-o-matic/extra/connbytes.patch netfilter/patch-o-matic/extra/connbytes.patch
--- ../nf/netfilter/patch-o-matic/extra/connbytes.patch	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/connbytes.patch	2003-06-18 13:59:25.000000000 +0200
@@ -0,0 +1,123 @@
+diff -Nru a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
+--- a/include/linux/netfilter_ipv4/ip_conntrack.h	Wed Jun 18 13:16:59 2003
++++ b/include/linux/netfilter_ipv4/ip_conntrack.h	Wed Jun 18 13:16:59 2003
+@@ -206,6 +206,8 @@
+ 	} nat;
+ #endif /* CONFIG_IP_NF_NAT_NEEDED */
+ 
++	/* number of bytes transfered; counter uses saturated incr. */
++	unsigned long bytes;
+ };
+ 
+ /* get master conntrack via master expectation */
+diff -Nru a/include/linux/netfilter_ipv4/ipt_connbytes.h b/include/linux/netfilter_ipv4/ipt_connbytes.h
+--- /dev/null	Wed Dec 31 16:00:00 1969
++++ b/include/linux/netfilter_ipv4/ipt_connbytes.h	Wed Jun 18 13:16:59 2003
+@@ -0,0 +1,10 @@
++#ifndef _IPT_CONNBYTES_H
++#define _IPT_CONNBYTES_H
++
++struct ipt_connbytes_info
++{
++       /* if from <= to then it matches the range; if from > to then
++          inverse range is matched */
++       unsigned long from, to;
++};
++#endif
+diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
+--- a/net/ipv4/netfilter/ip_conntrack_core.c	Wed Jun 18 13:16:59 2003
++++ b/net/ipv4/netfilter/ip_conntrack_core.c	Wed Jun 18 13:16:59 2003
+@@ -789,6 +789,13 @@
+ 		*set_reply = 0;
+ 	}
+ 	skb->nfct = &h->ctrack->infos[*ctinfo];
++
++	/* increment bytes in connection here */
++	if (h->ctrack->bytes + skb->len >= 0xffff0000)
++		h->ctrack->bytes = 0xffff0000;
++	else
++		h->ctrack->bytes += skb->len;
++
+ 	return h->ctrack;
+ }
+ 
+diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
+--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	Wed Jun 18 13:16:59 2003
++++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	Wed Jun 18 13:16:59 2003
+@@ -104,6 +104,7 @@
+ 		len += sprintf(buffer + len, "[ASSURED] ");
+ 	len += sprintf(buffer + len, "use=%u ",
+ 		       atomic_read(&conntrack->ct_general.use));
++	len += sprintf(buffer + len, "bytes=%lu ",conntrack->bytes);
+ 	len += sprintf(buffer + len, "\n");
+ 
+ 	return len;
+diff -Nru a/net/ipv4/netfilter/ipt_connbytes.c b/net/ipv4/netfilter/ipt_connbytes.c
+--- /dev/null	Wed Dec 31 16:00:00 1969
++++ b/net/ipv4/netfilter/ipt_connbytes.c	Wed Jun 18 13:16:59 2003
+@@ -0,0 +1,65 @@
++/* Kernel module to match connection tracking byte counter.
++ * GPL (C) 2002 Martin Devera (devik@cdi.cz).
++ */
++#include <linux/module.h>
++#include <linux/skbuff.h>
++#include <linux/netfilter_ipv4/ip_conntrack.h>
++#include <linux/netfilter_ipv4/ip_tables.h>
++#include <linux/netfilter_ipv4/ipt_connbytes.h>
++
++static int
++match(const struct sk_buff *skb,
++      const struct net_device *in,
++      const struct net_device *out,
++      const void *matchinfo,
++      int offset,
++      const void *hdr,
++      u_int16_t datalen,
++      int *hotdrop)
++{
++	const struct ipt_connbytes_info *sinfo = matchinfo;
++	enum ip_conntrack_info ctinfo;
++	struct ip_conntrack *ct;
++
++	if (!(ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo)))
++		return 0; /* no match */
++	
++	if (sinfo->from > sinfo->to)
++		return (ct->bytes < sinfo->to || ct->bytes > sinfo->from);
++	else
++		return (ct->bytes >= sinfo->from && ct->bytes <= sinfo->to);
++}
++
++static int check(const char *tablename,
++		 const struct ipt_ip *ip,
++		 void *matchinfo,
++		 unsigned int matchsize,
++		 unsigned int hook_mask)
++{
++	if (matchsize != IPT_ALIGN(sizeof(struct ipt_connbytes_info)))
++		return 0;
++
++	return 1;
++}
++
++static struct ipt_match state_match
++= { { NULL, NULL }, "connbytes", &match, &check, NULL, THIS_MODULE };
++
++static int __init init(void)
++{
++	/* NULL if ip_conntrack not a module */
++	if (ip_conntrack_module)
++		__MOD_INC_USE_COUNT(ip_conntrack_module);
++	return ipt_register_match(&state_match);
++}
++
++static void __exit fini(void)
++{
++	ipt_unregister_match(&state_match);
++	if (ip_conntrack_module)
++		__MOD_DEC_USE_COUNT(ip_conntrack_module);
++}
++
++module_init(init);
++module_exit(fini);
++MODULE_LICENSE("GPL");
diff -urN ../nf/netfilter/patch-o-matic/extra/connbytes.patch.config.in netfilter/patch-o-matic/extra/connbytes.patch.config.in
--- ../nf/netfilter/patch-o-matic/extra/connbytes.patch.config.in	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/connbytes.patch.config.in	2003-06-18 14:02:57.000000000 +0200
@@ -0,0 +1,2 @@
+    dep_tristate '  Connection state match support' CONFIG_IP_NF_MATCH_STATE $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES 
+    dep_tristate '  Connection byte counter support' CONFIG_IP_NF_MATCH_CONNBYTES $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES
diff -urN ../nf/netfilter/patch-o-matic/extra/connbytes.patch.help netfilter/patch-o-matic/extra/connbytes.patch.help
--- ../nf/netfilter/patch-o-matic/extra/connbytes.patch.help	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/connbytes.patch.help	2003-06-18 13:31:35.000000000 +0200
@@ -0,0 +1,24 @@
+Author: Martin Devera <devik@cdi.cz>
+Status: Working
+
+The connbytes match is used to match many bytes a connection transfered.
+The counter is limited to 0xffff0000, thus it can't overflow and also
+can't measure more than 4GB.
+
+The primary use is to detect long-lived downloads and mark them to be
+scheduled using a lower priority band in traffic control.
+
+The transfered bytes per connection can also be viewed through
+/proc/net/ip_conntrack.
+
+Usage:
+[!] --connbytes FROM:[TO]
+
+will match packet from a connection which transfered more than FROM and less
+than TO bytes. if TO is omitted only FROM check is done. "!" is used to match
+packets not falling in the range.
+
+Example:
+
+iptables .. -m connbytes --connbytes 10000:100000 ...
+
diff -urN ../nf/netfilter/patch-o-matic/extra/connbytes.patch.makefile netfilter/patch-o-matic/extra/connbytes.patch.makefile
--- ../nf/netfilter/patch-o-matic/extra/connbytes.patch.makefile	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/patch-o-matic/extra/connbytes.patch.makefile	2003-06-18 13:32:52.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) += ipt_conntrack.o
+obj-$(CONFIG_IP_NF_MATCH_CONNBYTES) += ipt_connbytes.o
diff -urN ../nf/netfilter/userspace/extensions/.connbytes-test netfilter/userspace/extensions/.connbytes-test
--- ../nf/netfilter/userspace/extensions/.connbytes-test	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/.connbytes-test	2003-06-18 13:36:08.000000000 +0200
@@ -0,0 +1,2 @@
+#! /bin/sh
+[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_connbytes.c ] && echo connbytes
diff -urN ../nf/netfilter/userspace/extensions/libipt_connbytes.c netfilter/userspace/extensions/libipt_connbytes.c
--- ../nf/netfilter/userspace/extensions/libipt_connbytes.c	1970-01-01 01:00:00.000000000 +0100
+++ netfilter/userspace/extensions/libipt_connbytes.c	2003-06-18 13:22:30.000000000 +0200
@@ -0,0 +1,134 @@
+/* Shared library add-on to iptables to add byte tracking support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <iptables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ipt_connbytes.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"connbytes v%s options:\n"
+" [!] --connbytes from:[to]\n"
+"				Transfered byte range to match\n"
+"\n", IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "connbytes", 1, 0, '1' },
+	{0}
+};
+
+/* Initialize the match. */
+static void
+init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	/* Can't cache this */
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static void
+parse_range(const char *arg, struct ipt_connbytes_info *si)
+{
+	char *colon,*p;
+
+	si->from = strtol(arg,&colon,10);
+	if (*colon != ':') 
+		exit_error(PARAMETER_PROBLEM, "Bad range `%s'", arg);
+	si->to = strtol(colon+1,&p,10);
+	if (p == colon+1) {
+		/* second number omited */
+		si->to = 0xffffffff;
+	}
+	if (si->from > si->to)
+		exit_error(PARAMETER_PROBLEM, "%lu should be less than %lu", si->from,si->to);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const struct ipt_entry *entry,
+      unsigned int *nfcache,
+      struct ipt_entry_match **match)
+{
+	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)(*match)->data;
+	int i;
+
+	switch (c) {
+	case '1':
+		if (check_inverse(optarg, &invert, optind, 0))
+			optind++;
+
+		parse_range(argv[optind-1], sinfo);
+		if (invert) {
+			i = sinfo->from;
+			sinfo->from = sinfo->to;
+			sinfo->to = i;
+		}
+		*flags = 1;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM, "You must specify `--connbytes'");
+}
+
+/* Prints out the matchinfo. */
+static void
+print(const struct ipt_ip *ip,
+      const struct ipt_entry_match *match,
+      int numeric)
+{
+	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
+
+	if (sinfo->from > sinfo->to) 
+		printf("connbytes ! %lu:%lu",sinfo->to,sinfo->from);
+	else
+		printf("connbytes %lu:%lu",sinfo->from,sinfo->to);
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	struct ipt_connbytes_info *sinfo = (struct ipt_connbytes_info *)match->data;
+
+	if (sinfo->from > sinfo->to) 
+		printf("! --connbytes %lu:%lu",sinfo->to,sinfo->from);
+	else
+		printf("--connbytes %lu:%lu",sinfo->from,sinfo->to);
+}
+
+static
+struct iptables_match state
+= { NULL,
+    "connbytes",
+    IPTABLES_VERSION,
+    IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
+    IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
+    &help,
+    &init,
+    &parse,
+    &final_check,
+    &print,
+    &save,
+    opts
+};
+
+void _init(void)
+{
+	register_match(&state);
+}

--------------050802070603010405080401--
