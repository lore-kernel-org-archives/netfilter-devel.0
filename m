From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: MARK bit operations patch #2
Date: Wed, 15 Jan 2003 02:24:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E24B83F.8030604@fugmann.dhs.org>
References: <3E240801.8080801@fugmann.dhs.org> <20030114211436.GL18686@sunbeam.de.gnumonks.org> <3E24811C.7000604@fugmann.dhs.org> <20030114235311.GO18686@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010509000508000406040907"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030114235311.GO18686@sunbeam.de.gnumonks.org>
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
--------------010509000508000406040907
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> On Tue, Jan 14, 2003 at 10:29:00PM +0100, Anders Fugmann wrote:
> 
>>My bad, should have said:
>>new kernel - new userspace: OK
>>old kernel - new userspace: OK
> 
> 
>>new kernel - old userspace: OK(*)
>>* - Only if the new userspace is compiled against the old kernel.
> 
> 
> sorry if I am a PITA, but where does the (*) case have new userspace and
> old kernel?  Either the first or the second line are wrong.
Sorry, I must be tired. The (*) is for "Old kernel - New userspace". In 
this case iptables has to be compiled against the correct headers, 
othervice it will not work.
> 
> 
> let's assume IPT_ALIGN aligns to 32bit boundaries on a 32bit platform,
> and 64bit on 64bit platforms.
> 
> now we have an old structure containing a 32bit integer IPT_ALIGN()ed to
> 32bit.  Then there is a new structure, aligned to 2*32bit == 64bit.
> 
> on the 64bit platform, the old 32bit structure is already aligned to
> 64bit.  And the new structure is aligned to 64bit as well.
I see your concern.
> 
> Resulting in IPT_ALIGN(sizeof(struct ipt_mark_target_info)) bein exactly
> the same as IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info)).
> 
> I'm not saying that it really happens right now (I would need to test
> it) - but theoretically it is possible.
> 
> I'd say you make your final patch and I test it on my sparc64 box. 
Perfect. I have attached final patch for kernel/iptables inclusion for 
you to test and evaluate. The changes include only manpage changes.
If included, please update the kernel version for which the extended 
functionality works (see the userspace patch).

If ok, I will start on making a IPv6 version of the patch (which would 
follow the same priciple - if you want.

> 
> If there are any problems, we have two options
> 
> 1) assure that IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info)) is
>    way larger than the older structure (resulting in 128bit)
Thats not a very good solution - We would be waisting kernel space and 
most importently it would trach the cache for no reason. Also, in some 
point in the future 128bit machines will become available, and then the 
bug is reintroduced.

The structure uses an unsigned long. I thought that this defines the 
biggest integer machine word available, that is 32 bit on a 32bit arch, 
and 64 bit on a 64bit arch. Extending the struct by 1 byte, the new 
alignment of the new struct would always increase.

A bit of googling came up with:
Making code 64 bit clean: http://www.treblig.org/articles/64bits.html

 From this article:
"So how long is a long? Well there is no really good definition of that 
in general! So if you start using a 'long' in place of an 'int' for some 
reason don't be surprised if it is a different size on a 64 bit 
platform. So if you are writing values to a hardware register then a 
'long' probably isn't a good idea because it will be 64 bits on 64 bit 
Linux platforms and 32 bit on 32 bit Linux platforms. Other OSs may 
still keep long at 32 bits on 64 bit systems - so being portable can be 
difficult."

If this is correct, then there should be no problem. IIRC, there are 
systems that use 64 bit for the kernel and 32 bit for the userspace, 
which would really give strange results.
> 
> 2) find some other way not depending on the size of the structure (which
>    would be preferred - but how?)
Yes. Testing on the size of the structure is actually not that nice, but
I have no idea of how to do this in a clean manner.
Actually a general "nice to have" feature would be to send along an 
identifier (magic number), which can be used by modules to see who is 
calling them. This would require checkentry function signatures to 
change, which is definatly not 2.4 material.

> 
> Thanks for working on this issue.
My pleasure.

Regards
Anders Fugmann

--------------010509000508000406040907
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

--------------010509000508000406040907
Content-Type: text/plain;
 name="MARK_operations.patch.userspace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="MARK_operations.patch.userspace"

--- iptables-1.2.7a-old/extensions/libipt_MARK.c	2002-08-05 16:26:47.000000000 +0200
+++ iptables-1.2.7a-new/extensions/libipt_MARK.c	2003-01-15 02:22:05.000000000 +0100
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
@@ -83,20 +102,53 @@
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
-
-	printf("--set-mark 0x%lx ", markinfo->mark);
+	printf("--set-mark ");
+#endif
+	print_mark(markinfo->mark,0);
 }
 
 static
@@ -104,8 +156,13 @@
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
--- iptables-1.2.7a-old/iptables.8	2002-08-07 11:37:40.000000000 +0200
+++ iptables-1.2.7a-new/iptables.8	2003-01-15 02:16:57.000000000 +0100
@@ -690,6 +690,23 @@
 table.  It can for example be used in conjunction with iproute2.
 .TP
 .BI "--set-mark " "mark"
+Sets the marking of the packet to 
+.I mark
+regardless of the current mark value of the packet.
+.P
+Since kernel 2.4.21 two additional options to the MARK target have been
+made available. The new options are:
+.TP
+.BI "--and-mark " "mark"
+Binary AND between the current mark value of the packet and the supplied
+.I mark 
+value.
+.TP
+.BI "--or-mark " "mark"
+Binary OR between the current mark value of the packet and the supplied
+.I mark 
+value.
+
 .SS REJECT
 This is used to send back an error packet in response to the matched
 packet: otherwise it is equivalent to 

--------------010509000508000406040907--
