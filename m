From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: MARK bit operations patch #2
Date: Tue, 14 Jan 2003 13:52:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E240801.8080801@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060007010306000108060806"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------060007010306000108060806
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

I have tried to make the MARK target include
two new operations '--or-mark' and '--and-mark'.

The patch is compatible in the following ways:

new kernel - old userspace: OK
new kernel - old userspace: OK
old kernel - new userspace: OK(*)

* - Only if the new userspace is compiled against the old kernel.

Please comment. I'm not use if the compatibility satifies the 
requirements needed for such a patch to go into the 2.4 series.

Attached: MARK_TARGET.patch - patch against 2.4 (applies to 2.5 aswell))
Attached: MARK_operations.patch.userspace  - patch against iptables .1.2.7a)

Regards
Anders Fugmann


--------------060007010306000108060806
Content-Type: text/plain;
 name="MARK_TARGET.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="MARK_TARGET.patch"

--- linux-2.5.56/include/linux/netfilter_ipv4/ipt_MARK.h	2003-01-09 05:03:58.000000000 +0100
+++ linux-2.5.56-new/include/linux/netfilter_ipv4/ipt_MARK.h	2003-01-14 13:28:30.000000000 +0100
@@ -5,4 +5,17 @@
 	unsigned long mark;
 };
 
+#define MARK_BITOPS 1
+
+enum {
+	IPT_MARK_SET=0,
+	IPT_MARK_AND,
+	IPT_MARK_OR
+};
+
+struct ipt_mark_bitops_target_info {
+	unsigned long mark;
+	u_int8_t mode;
+};
+
 #endif /*_IPT_MARK_H_target*/
--- linux-2.5.56/net/ipv4/netfilter/ipt_MARK.c	2003-01-09 05:04:15.000000000 +0100
+++ linux-2.5.56-new/net/ipv4/netfilter/ipt_MARK.c	2003-01-14 13:29:37.000000000 +0100
@@ -1,4 +1,9 @@
-/* This is a module which is used for setting the NFMARK field of an skb. */
+/* This is a module which is used for setting the NFMARK field of an skb. *
+ *
+ *  13-1-2003: Anders Fugmann <afu@fugmann.dhs.org>
+ *             Added bit operations ADD and OR.
+ */
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
@@ -7,6 +12,10 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_MARK.h>
 
+/* If this variable is set, NFMARK works in compability mode and 
+   Uses the old ipt_mark_target_info. */
+static int compat_mode;
+
 static unsigned int
 target(struct sk_buff **pskb,
        unsigned int hooknum,
@@ -15,12 +24,36 @@
        const void *targinfo,
        void *userinfo)
 {
-	const struct ipt_mark_target_info *markinfo = targinfo;
-
-	if((*pskb)->nfmark != markinfo->mark) {
-		(*pskb)->nfmark = markinfo->mark;
-		(*pskb)->nfcache |= NFC_ALTERED;
+	int mark;
+	if (compat_mode) {
+		const struct ipt_mark_target_info *markinfo = targinfo;
+		mark = markinfo->mark;
+	} else {
+		const struct ipt_mark_bitops_target_info *markinfo = targinfo;
+		
+		switch (markinfo->mode) {
+		case IPT_MARK_SET:
+			mark = markinfo->mark;
+			break;
+			
+		case IPT_MARK_AND:
+			mark = (*pskb)->nfmark & markinfo->mark;
+			break;
+			
+		case IPT_MARK_OR:
+			mark = (*pskb)->nfmark | markinfo->mark;
+			break;
+			
+		default:
+			mark = (*pskb)->nfmark;
+			break;
+		}
 	}
+	if ((*pskb)->nfmark != mark) {
+		(*pskb)->nfmark = mark;
+		(*pskb)->nfcache |= NFC_ALTERED;
+        }
+
 	return IPT_CONTINUE;
 }
 
@@ -31,15 +64,18 @@
            unsigned int targinfosize,
            unsigned int hook_mask)
 {
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_mark_target_info))) {
-		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_mark_target_info)));
+	if (targinfosize == IPT_ALIGN(sizeof(struct ipt_mark_target_info))) 
+		compat_mode = 1;
+	else if (targinfosize !=  
+		 IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info))) {
+		printk(KERN_WARNING "MARK: targinfosize %u mismatch\n",
+		       targinfosize);
 		return 0;
 	}
 
 	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
+		printk(KERN_WARNING "MARK: can only be called from "
+		       "\"mangle\" table, not \"%s\"\n", tablename);
 		return 0;
 	}
 
@@ -53,6 +89,8 @@
 {
 	if (ipt_register_target(&ipt_mark_reg))
 		return -EINVAL;
+	
+	compat_mode = 0;
 
 	return 0;
 }

--------------060007010306000108060806
Content-Type: text/plain;
 name="MARK_operations.patch.userspace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="MARK_operations.patch.userspace"

--- iptables-1.2.7a-old/extensions/libipt_MARK.c	2002-08-05 16:26:47.000000000 +0200
+++ iptables-1.2.7a-new/extensions/libipt_MARK.c	2003-01-14 13:40:55.000000000 +0100
@@ -8,11 +8,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_MARK.h>
 
-struct markinfo {
-	struct ipt_entry_target t;
-	struct ipt_mark_target_info mark;
-};
-
 /* Function which prints out usage message. */
 static void
 help(void)
@@ -20,12 +15,20 @@
 	printf(
 "MARK target v%s options:\n"
 "  --set-mark value                   Set nfmark value\n"
+#ifdef MARK_BITOPS
+"  --and-mark value                   Binary AND the nfmark with value\n"
+"  --or-mark  value                   Binary OR  the nfmark with value\n"
+#endif
 "\n",
 IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
 	{ "set-mark", 1, 0, '1' },
+#ifdef MARK_BITOPS
+	{ "and-mark", 1, 0, '2' },
+	{ "or-mark", 1, 0, '3' },
+#endif
 	{ 0 }
 };
 
@@ -42,24 +45,40 @@
       const struct ipt_entry *entry,
       struct ipt_entry_target **target)
 {
-	struct ipt_mark_target_info *markinfo
-		= (struct ipt_mark_target_info *)(*target)->data;
+#ifdef MARK_BITOPS
+	struct ipt_mark_bitops_target_info *markinfo
+		= (struct ipt_mark_bitops_target_info *)(*target)->data;
 
 	switch (c) {
 	case '1':
-		if (string_to_number(optarg, 0, 0xffffffff, 
-				     (unsigned int *)&markinfo->mark))
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "MARK target: Can't specify --set-mark twice");
-		*flags = 1;
+	        markinfo->mode = IPT_MARK_SET;
+		break;
+	case '2':
+	        markinfo->mode = IPT_MARK_AND;
+		break;
+	case '3':
+	        markinfo->mode = IPT_MARK_OR;
 		break;
-
 	default:
 		return 0;
 	}
-
+#else 
+	struct ipt_mark_target_info *markinfo
+		= (struct ipt_mark_target_info *)(*target)->data;
+	if (c != '1') 
+		return 0;
+#endif
+	if (string_to_number(optarg, 0, 0xffffffff, 
+			     (unsigned int *)&markinfo->mark))
+		exit_error(PARAMETER_PROBLEM, 
+			   "Bad MARK value `%s'", optarg);
+	
+	if (*flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "MARK target: "
+			   "Can't specify operation twice");
+	*flags = 1;
+	
 	return 1;
 }
 
@@ -68,7 +87,7 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "MARK target: Parameter --set-mark is required");
+		           "MARK target: Additional parameter required");
 }
 
 static void
@@ -83,20 +102,54 @@
       const struct ipt_entry_target *target,
       int numeric)
 {
+#ifdef MARK_BITOPS
+	const struct ipt_mark_bitops_target_info *markinfo =
+		(const struct ipt_mark_bitops_target_info *)target->data;
+	switch (markinfo->mode) {
+	case IPT_MARK_SET:
+	        printf("MARK set ");
+	        break;
+	case IPT_MARK_AND:
+	        printf("MARK and ");
+	        break;
+	case IPT_MARK_OR: 
+	        printf("MARK or ");
+	        break;
+	}
+#else
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
 	printf("MARK set ");
+#endif
 	print_mark(markinfo->mark, numeric);
+
 }
 
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
 save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
 {
+#ifdef MARK_BITOPS
+	const struct ipt_mark_bitops_target_info *markinfo =
+		(const struct ipt_mark_bitops_target_info *)target->data;
+	switch (markinfo->mode) {
+	case IPT_MARK_SET:
+	        printf("--set-mark ");
+	        break;
+	case IPT_MARK_AND:
+	        printf("--and-mark ");
+	        break;
+	case IPT_MARK_OR: 
+	        printf("--or-mark ");
+	        break;
+	}
+#else
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
+	printf("--set-mark ");
+#endif
+	printf(" 0x%lx ", markinfo->mark);
 
-	printf("--set-mark 0x%lx ", markinfo->mark);
 }
 
 static
@@ -104,8 +157,13 @@
 = { NULL,
     "MARK",
     IPTABLES_VERSION,
+#ifdef MARK_BITOPS
+    IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info)),
+    IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info)),
+#else
     IPT_ALIGN(sizeof(struct ipt_mark_target_info)),
     IPT_ALIGN(sizeof(struct ipt_mark_target_info)),
+#endif
     &help,
     &init,
     &parse,

--------------060007010306000108060806--
