From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Fixed proken MARK target in POM.
Date: Thu, 09 Jan 2003 14:07:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1D7419.1060502@fugmann.dhs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080305080209090302000905"
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
--------------080305080209090302000905
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

As I require the BIT-operations provided by the MARK target in POM,
attached is a fixed version of this.

The patch extends the MARK target in mangle chains to allow:

# iptables -t mangle -A PRERPUTING -j MARK --set-mark 0x01
# iptables -t mangle -A PRERPUTING -j MARK --and-mark 0x01
# iptables -t mangle -A PRERPUTING -j MARK --or-mark 0x01

The version is widly based on the current one with only minor code 
fixes. The kernel patch applies cleanly to 2.4.20 and 2.5.54. The 
userspace patch is against 1.2.7a. The patch has been tested on 2.5.54.

The patch maintains backward compability, and I request that this patch 
is applied to mainstream (and pushed to the Andrea for kernel 
inclusion), as I as a software developer of a firewall cannot ask users 
of the software to appliy patches to POM.

Regards
Anders Fugmann

--------------080305080209090302000905
Content-Type: text/plain;
 name="MARK_TARGET.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="MARK_TARGET.patch"

diff -r -u linux-2.4.20/include/linux/netfilter_ipv4/ipt_MARK.h linux-2.4.20-new/include/linux/netfilter_ipv4/ipt_MARK.h
--- linux-2.4.20/include/linux/netfilter_ipv4/ipt_MARK.h	2000-03-17 19:56:20.000000000 +0100
+++ linux-2.4.20-new/include/linux/netfilter_ipv4/ipt_MARK.h	2003-01-09 11:15:06.000000000 +0100
@@ -1,8 +1,15 @@
 #ifndef _IPT_MARK_H_target
 #define _IPT_MARK_H_target
 
+enum {
+        IPT_MARK_SET=0,
+        IPT_MARK_AND,
+        IPT_MARK_OR
+};
+
 struct ipt_mark_target_info {
 	unsigned long mark;
+	u_int8_t mode;
 };
 
 #endif /*_IPT_MARK_H_target*/
diff -r -u linux-2.4.20/net/ipv4/netfilter/ipt_MARK.c linux-2.4.20-new/net/ipv4/netfilter/ipt_MARK.c
--- linux-2.4.20/net/ipv4/netfilter/ipt_MARK.c	2001-09-30 21:26:08.000000000 +0200
+++ linux-2.4.20-new/net/ipv4/netfilter/ipt_MARK.c	2003-01-09 11:22:53.000000000 +0100
@@ -16,11 +16,31 @@
        void *userinfo)
 {
 	const struct ipt_mark_target_info *markinfo = targinfo;
+	int newmark;
+	
+	switch (markinfo->mode) {
+	case IPT_MARK_SET:
+		newmark = markinfo->mark;
+		break;
+		
+	case IPT_MARK_AND:
+		newmark = (*pskb)->nfmark & markinfo->mark;
+		break;
+		
+	case IPT_MARK_OR:
+		newmark = (*pskb)->nfmark | markinfo->mark;
+		break;
+
+	default:
+                newmark = (*pskb)->nfmark;
+		break;
+	}
 
-	if((*pskb)->nfmark != markinfo->mark) {
-		(*pskb)->nfmark = markinfo->mark;
-		(*pskb)->nfcache |= NFC_ALTERED;
+	if ((*pskb)->nfmark != newmark) {
+	        (*pskb)->nfmark = newmark;
+	        (*pskb)->nfcache |= NFC_ALTERED;
 	}
+
 	return IPT_CONTINUE;
 }
 

--------------080305080209090302000905
Content-Type: text/plain;
 name="MARK_operations.patch.userspace"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="MARK_operations.patch.userspace"

diff -u -r iptables-1.2.7a/extensions/libipt_MARK.c iptables-1.2.7a-new/extensions/libipt_MARK.c
--- iptables-1.2.7a/extensions/libipt_MARK.c	2002-08-05 16:26:47.000000000 +0200
+++ iptables-1.2.7a-new/extensions/libipt_MARK.c	2003-01-09 13:29:47.000000000 +0100
@@ -20,12 +20,16 @@
 	printf(
 "MARK target v%s options:\n"
 "  --set-mark value                   Set nfmark value\n"
+"  --and-mark value                   Binary AND the nfmark with value\n"
+"  --or-mark  value                   Binary OR  the nfmark with value\n"
 "\n",
 IPTABLES_VERSION);
 }
 
 static struct option opts[] = {
 	{ "set-mark", 1, 0, '1' },
+	{ "and-mark", 1, 0, '2' },
+	{ "or-mark", 1, 0, '3' },
 	{ 0 }
 };
 
@@ -45,17 +49,29 @@
 	struct ipt_mark_target_info *markinfo
 		= (struct ipt_mark_target_info *)(*target)->data;
 
-	switch (c) {
-	case '1':
-		if (string_to_number(optarg, 0, 0xffffffff, 
+	/* Do generic stuff */
+	if (c=='1' || c=='2' || c=='3') {
+	        if (string_to_number(optarg, 0, 0xffffffff, 
 				     (unsigned int *)&markinfo->mark))
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		        exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
-			           "MARK target: Can't specify --set-mark twice");
+		        exit_error(PARAMETER_PROBLEM,
+				   "MARK target: Can't specify --set-mark twice");
 		*flags = 1;
-		break;
 
+	}
+		
+	switch (c) {
+	case '1':
+	        markinfo->mode = IPT_MARK_SET;
+		break;
+	case '2':
+	        markinfo->mode = IPT_MARK_AND;
+		break;
+	case '3':
+	        markinfo->mode = IPT_MARK_OR;
+		break;
 	default:
 		return 0;
 	}
@@ -68,7 +84,7 @@
 {
 	if (!flags)
 		exit_error(PARAMETER_PROBLEM,
-		           "MARK target: Parameter --set-mark is required");
+		           "MARK target: Additional parameter required");
 }
 
 static void
@@ -85,7 +101,17 @@
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
-	printf("MARK set ");
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
 	print_mark(markinfo->mark, numeric);
 }
 
@@ -95,8 +121,19 @@
 {
 	const struct ipt_mark_target_info *markinfo =
 		(const struct ipt_mark_target_info *)target->data;
+	switch (markinfo->mode) {
+	case IPT_MARK_SET:
+	        printf("--set-mark");
+	        break;
+	case IPT_MARK_AND:
+	        printf("--and-mark");
+	        break;
+	case IPT_MARK_OR: 
+	        printf("--or-mark");
+	        break;
+	}
 
-	printf("--set-mark 0x%lx ", markinfo->mark);
+	printf(" 0x%lx ", markinfo->mark);
 }
 
 static
diff -u -r iptables-1.2.7a/iptables.8 iptables-1.2.7a-new/iptables.8
--- iptables-1.2.7a/iptables.8	2002-08-07 11:37:40.000000000 +0200
+++ iptables-1.2.7a-new/iptables.8	2003-01-09 12:25:13.000000000 +0100
@@ -690,6 +690,20 @@
 table.  It can for example be used in conjunction with iproute2.
 .TP
 .BI "--set-mark " "mark"
+Sets the marking of the packet to 
+.I mark
+regardless of the current mark value of the packet.
+.TP
+.BI "--and-mark " "mark"
+Binary AND the current mark value of the packet with the supplied
+.I mark 
+value.
+.TP
+.BI "--or-mark " "mark"
+Binary OR the current mark value of the packet with the supplied
+.I mark 
+value.
+
 .SS REJECT
 This is used to send back an error packet in response to the matched
 packet: otherwise it is equivalent to 

--------------080305080209090302000905--
