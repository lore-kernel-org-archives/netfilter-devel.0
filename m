From: Dimitris Kotsonis <jnk@pwn.emphyrio.org>
Subject: string patch for 2.6
Date: Thu, 30 Dec 2004 10:25:45 +0200
Message-ID: <41D3BB89.6040609@pwn.emphyrio.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050809010006030909080509"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
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

This is a multi-part message in MIME format.
--------------050809010006030909080509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This is a patch against pong-20041229 that will add string support for 
kernel 2.6

Dimitris



--------------050809010006030909080509
Content-Type: text/plain;
 name="string_2.6_for_pom_ng-20041229.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="string_2.6_for_pom_ng-20041229.diff"

diff -urN patch-o-matic-ng-20041229.orig/string/info patch-o-matic-ng-20041229/string/info
--- patch-o-matic-ng-20041229.orig/string/info	2004-02-20 01:55:30.000000000 +0200
+++ patch-o-matic-ng-20041229/string/info	2004-12-30 09:45:42.000000000 +0200
@@ -1,4 +1,3 @@
 Author: Emmanuel Roger <winfield@freegates.be>
 Status: Working, not with kernel 2.4.9
 Repository: extra
-Requires: linux < 2.6.0
diff -urN patch-o-matic-ng-20041229.orig/string/linux-2.6/Documentation/Configure.help.ladd patch-o-matic-ng-20041229/string/linux-2.6/Documentation/Configure.help.ladd
--- patch-o-matic-ng-20041229.orig/string/linux-2.6/Documentation/Configure.help.ladd	1970-01-01 02:00:00.000000000 +0200
+++ patch-o-matic-ng-20041229/string/linux-2.6/Documentation/Configure.help.ladd	2004-12-30 10:02:30.000000000 +0200
@@ -0,0 +1,8 @@
+CONFIG_IP_NF_MATCH_UNCLEAN
+String match support (EXPERIMENTAL)
+CONFIG_IP_NF_MATCH_STRING
+  String matching alows you to match packets which contain a
+  specified string of characters.
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
diff -urN patch-o-matic-ng-20041229.orig/string/linux-2.6/include/linux/netfilter_ipv4/ipt_string.h patch-o-matic-ng-20041229/string/linux-2.6/include/linux/netfilter_ipv4/ipt_string.h
--- patch-o-matic-ng-20041229.orig/string/linux-2.6/include/linux/netfilter_ipv4/ipt_string.h	1970-01-01 02:00:00.000000000 +0200
+++ patch-o-matic-ng-20041229/string/linux-2.6/include/linux/netfilter_ipv4/ipt_string.h	2004-12-30 10:01:51.000000000 +0200
@@ -0,0 +1,21 @@
+#ifndef _IPT_STRING_H
+#define _IPT_STRING_H
+
+/* *** PERFORMANCE TWEAK ***
+ * Packet size and search string threshold,
+ * above which sublinear searches is used. */
+#define IPT_STRING_HAYSTACK_THRESH	100
+#define IPT_STRING_NEEDLE_THRESH	20
+
+#define BM_MAX_NLEN 256
+#define BM_MAX_HLEN 1024
+
+typedef char *(*proc_ipt_search) (char *, char *, int, int);
+
+struct ipt_string_info {
+    char string[BM_MAX_NLEN];
+    u_int16_t invert;
+    u_int16_t len;
+};
+
+#endif /* _IPT_STRING_H */
diff -urN patch-o-matic-ng-20041229.orig/string/linux-2.6/net/ipv4/netfilter/Kconfig.ladd patch-o-matic-ng-20041229/string/linux-2.6/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng-20041229.orig/string/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	1970-01-01 02:00:00.000000000 +0200
+++ patch-o-matic-ng-20041229/string/linux-2.6/net/ipv4/netfilter/Kconfig.ladd	2004-12-30 09:59:30.000000000 +0200
@@ -0,0 +1,9 @@
+config IP_NF_MATCH_STRING
+	tristate  'String match support'
+	depends on IP_NF_IPTABLES
+	help
+	  String matching alows you to match packets which contain a
+	  specified string of characters.
+	
+	  If you want to compile it as a module, say M here and read
+	  Documentation/modules.txt.  If unsure, say `N'.
diff -urN patch-o-matic-ng-20041229.orig/string/linux-2.6/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng-20041229/string/linux-2.6/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-20041229.orig/string/linux-2.6/net/ipv4/netfilter/Makefile.ladd	1970-01-01 02:00:00.000000000 +0200
+++ patch-o-matic-ng-20041229/string/linux-2.6/net/ipv4/netfilter/Makefile.ladd	2004-12-30 09:57:35.000000000 +0200
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) += ipt_physdev.o
+obj-$(CONFIG_IP_NF_MATCH_STRING) += ipt_string.o
diff -urN patch-o-matic-ng-20041229.orig/string/linux-2.6/net/ipv4/netfilter/ipt_string.c patch-o-matic-ng-20041229/string/linux-2.6/net/ipv4/netfilter/ipt_string.c
--- patch-o-matic-ng-20041229.orig/string/linux-2.6/net/ipv4/netfilter/ipt_string.c	1970-01-01 02:00:00.000000000 +0200
+++ patch-o-matic-ng-20041229/string/linux-2.6/net/ipv4/netfilter/ipt_string.c	2004-12-30 09:49:42.000000000 +0200
@@ -0,0 +1,221 @@
+/* Kernel module to match a string into a packet.
+ *
+ * Copyright (C) 2000 Emmanuel Roger  <winfield@freegates.be>
+ * 
+ * ChangeLog
+ *	19.02.2002: Gianni Tedesco <gianni@ecsc.co.uk>
+ *		Fixed SMP re-entrancy problem using per-cpu data areas
+ *		for the skip/shift tables.
+ *	02.05.2001: Gianni Tedesco <gianni@ecsc.co.uk>
+ *		Fixed kernel panic, due to overrunning boyer moore string
+ *		tables. Also slightly tweaked heuristic for deciding what
+ * 		search algo to use.
+ * 	27.01.2001: Gianni Tedesco <gianni@ecsc.co.uk>
+ * 		Implemented Boyer Moore Sublinear search algorithm
+ * 		alongside the existing linear search based on memcmp().
+ * 		Also a quick check to decide which method to use on a per
+ * 		packet basis.
+ */
+
+#include <linux/smp.h>
+#include <linux/threads.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <net/sock.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_string.h>
+
+MODULE_LICENSE("GPL");
+
+struct string_per_cpu {
+	int *skip;
+	int *shift;
+	int *len;
+};
+
+struct string_per_cpu *bm_string_data=NULL;
+
+/* Boyer Moore Sublinear string search - VERY FAST */
+char *search_sublinear (char *needle, char *haystack, int needle_len, int haystack_len) 
+{
+	int M1, right_end, sk, sh;  
+	int ended, j, i;
+
+	int *skip, *shift, *len;
+	
+	/* use data suitable for this CPU */
+	shift=bm_string_data[smp_processor_id()].shift;
+	skip=bm_string_data[smp_processor_id()].skip;
+	len=bm_string_data[smp_processor_id()].len;
+	
+	/* Setup skip/shift tables */
+	M1 = right_end = needle_len-1;
+	for (i = 0; i < BM_MAX_HLEN; i++) skip[i] = needle_len;  
+	for (i = 0; needle[i]; i++) skip[needle[i]] = M1 - i;  
+
+	for (i = 1; i < needle_len; i++) {   
+		for (j = 0; j < needle_len && needle[M1 - j] == needle[M1 - i - j]; j++);  
+		len[i] = j;  
+	}  
+
+	shift[0] = 1;  
+	for (i = 1; i < needle_len; i++) shift[i] = needle_len;  
+	for (i = M1; i > 0; i--) shift[len[i]] = i;  
+	ended = 0;  
+	
+	for (i = 0; i < needle_len; i++) {  
+		if (len[i] == M1 - i) ended = i;  
+		if (ended) shift[i] = ended;  
+	}  
+
+	/* Do the search*/  
+	while (right_end < haystack_len)
+	{
+		for (i = 0; i < needle_len && haystack[right_end - i] == needle[M1 - i]; i++);  
+		if (i == needle_len) {
+			return haystack+(right_end - M1);
+		}
+		
+		sk = skip[haystack[right_end - i]];  
+		sh = shift[i];
+		right_end = max(right_end - i + sk, right_end + sh);  
+	}
+
+	return NULL;
+}  
+
+/* Linear string search based on memcmp() */
+char *search_linear (char *needle, char *haystack, int needle_len, int haystack_len) 
+{
+	char *k = haystack + (haystack_len-needle_len);
+	char *t = haystack;
+	
+	while ( t <= k ) {
+		if (memcmp(t, needle, needle_len) == 0)
+			return t;
+		t++;
+	}
+
+	return NULL;
+}
+
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_string_info *info = matchinfo;
+	struct iphdr *ip = skb->nh.iph;
+	int hlen, nlen;
+	char *needle, *haystack;
+	proc_ipt_search search=search_linear;
+
+	if ( !ip ) return 0;
+
+	/* get lenghts, and validate them */
+	nlen=info->len;
+	hlen=ntohs(ip->tot_len)-(ip->ihl*4);
+	if ( nlen > hlen ) return 0;
+
+	needle=(char *)&info->string;
+	haystack=(char *)ip+(ip->ihl*4);
+
+	/* The sublinear search comes in to its own
+	 * on the larger packets */
+	if ( (hlen>IPT_STRING_HAYSTACK_THRESH) &&
+	  	(nlen>IPT_STRING_NEEDLE_THRESH) ) {
+		if ( hlen < BM_MAX_HLEN ) {
+			search=search_sublinear;
+		}else{
+			if (net_ratelimit())
+				printk(KERN_INFO "ipt_string: Packet too big "
+					"to attempt sublinear string search "
+					"(%d bytes)\n", hlen );
+		}
+	}
+	
+    return ((search(needle, haystack, nlen, hlen)!=NULL) ^ info->invert);
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+
+       if (matchsize != IPT_ALIGN(sizeof(struct ipt_string_info)))
+               return 0;
+
+       return 1;
+}
+
+void string_freeup_data(void)
+{
+	int c;
+	
+	if ( bm_string_data ) {
+		for(c=0; c<NR_CPUS; c++) {
+			if ( bm_string_data[c].shift ) kfree(bm_string_data[c].shift);
+			if ( bm_string_data[c].skip ) kfree(bm_string_data[c].skip);
+			if ( bm_string_data[c].len ) kfree(bm_string_data[c].len);
+		}
+		kfree(bm_string_data);
+	}
+}
+
+static struct ipt_match string_match = {
+	.name       ="string",
+	.match      = &match, 
+	.checkentry = &checkentry, 
+	.me         = THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int c;
+	size_t tlen;
+	size_t alen;
+
+	tlen=sizeof(struct string_per_cpu)*NR_CPUS;
+	alen=sizeof(int)*BM_MAX_HLEN;
+	
+	/* allocate array of structures */
+	if ( !(bm_string_data=kmalloc(tlen,GFP_KERNEL)) ) {
+		return 0;
+	}
+	
+	memset(bm_string_data, 0, tlen);
+	
+	/* allocate our skip/shift tables */
+	for(c=0; c<NR_CPUS; c++) {
+		if ( !(bm_string_data[c].shift=kmalloc(alen, GFP_KERNEL)) )
+			goto alloc_fail;
+		if ( !(bm_string_data[c].skip=kmalloc(alen, GFP_KERNEL)) )
+			goto alloc_fail;
+		if ( !(bm_string_data[c].len=kmalloc(alen, GFP_KERNEL)) )
+			goto alloc_fail;
+	}
+	
+	return ipt_register_match(&string_match);
+
+alloc_fail:
+	string_freeup_data();
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&string_match);
+	string_freeup_data();
+}
+
+module_init(init);
+module_exit(fini);

--------------050809010006030909080509--
