From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/2] ipt_MARK extension with backwards compatibility
	(kernel side).
Date: Thu, 25 Nov 2004 15:49:50 +1100
Message-ID: <1101358191.5842.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

We've been chasing this for a while; thanks to Bart for the final piece!

How to extend an extension:
1) If you already have a flags word in your structure which is checked
by existing versions of the code, you can simply add new flags: this
will fail on old kernels and work on new kernels.

2) If not, you must extend the size of the structure, so old kernels
will fail, and new kernels will be able to tell whether they are to use
the new or old structure.  The IPT_ALIGN'ed size of the structure must
change for this to work!

3) In your userspace extension, use the *flags arg to note if you need
the new structure. and in your final_check() function, reduce the
targetsize or matchsize to the old structure size if you didn't use the
new features.

4) Inside the kernel, create a dummy "struct ipt_target" or "struct
ipt_match" for the backwards compatibility mode.  This must have the
same name as the real one, but must not be registered.  In your
checkentry() routine, set t->u.kernel.target or m->u.kernel.match to the
old version if the old size is used.

5) See ipt_MARK for an example.

Name: Add bitops to ipt_MARK without breaking compatibility
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Anders Fugmann <afu@fugmann.dhs.org> wrote a patch to add bitops to
ipt_MARK.  I made a version which doesn't rely on any infrastructure
changes and is still backwards compatible (it'd be neater with
interface changes, but <shrug>).

Bart De Schuymer <bdschuym@pandora.be> provided the idea of overriding
the target type.

Index: linux-2.6.10-rc2-bk8-Netfilter/include/linux/netfilter_ipv4/ipt_MARK.h
===================================================================
--- linux-2.6.10-rc2-bk8-Netfilter.orig/include/linux/netfilter_ipv4/ipt_MARK.h	2000-03-18 05:56:20.000000000 +1100
+++ linux-2.6.10-rc2-bk8-Netfilter/include/linux/netfilter_ipv4/ipt_MARK.h	2004-11-25 13:29:47.000000000 +1100
@@ -1,8 +1,18 @@
 #ifndef _IPT_MARK_H_target
 #define _IPT_MARK_H_target
 
-struct ipt_mark_target_info {
+struct ipt_mark_target_old_info {
 	unsigned long mark;
 };
 
+enum {
+	IPT_MARK_SET=0,
+	IPT_MARK_AND,
+	IPT_MARK_OR
+};
+
+struct ipt_mark_target_info {
+	unsigned long mark;
+	u_int8_t mode;
+};
 #endif /*_IPT_MARK_H_target*/
Index: linux-2.6.10-rc2-bk8-Netfilter/net/ipv4/netfilter/ipt_MARK.c
===================================================================
--- linux-2.6.10-rc2-bk8-Netfilter.orig/net/ipv4/netfilter/ipt_MARK.c	2004-02-18 23:54:37.000000000 +1100
+++ linux-2.6.10-rc2-bk8-Netfilter/net/ipv4/netfilter/ipt_MARK.c	2004-11-25 13:33:40.000000000 +1100
@@ -20,7 +20,7 @@
 MODULE_DESCRIPTION("iptables MARK modification module");
 
 static unsigned int
-target(struct sk_buff **pskb,
+old_target(struct sk_buff **pskb,
        const struct net_device *in,
        const struct net_device *out,
        unsigned int hooknum,
@@ -36,6 +36,45 @@
 	return IPT_CONTINUE;
 }
 
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+	const struct ipt_mark_target_info *markinfo = targinfo;
+	int mark = 0;
+
+	switch (markinfo->mode) {
+	case IPT_MARK_SET:
+		mark = markinfo->mark;
+		break;
+		
+	case IPT_MARK_AND:
+		mark = (*pskb)->nfmark & markinfo->mark;
+		break;
+		
+	case IPT_MARK_OR:
+		mark = (*pskb)->nfmark | markinfo->mark;
+		break;
+	}
+
+	if((*pskb)->nfmark != mark) {
+		(*pskb)->nfmark = mark;
+		(*pskb)->nfcache |= NFC_ALTERED;
+	}
+	return IPT_CONTINUE;
+}
+
+
+static struct ipt_target ipt_mark_old_reg = {
+	.name		= "MARK",
+	.target		= old_target,
+	.me		= THIS_MODULE,
+};
+
 static int
 checkentry(const char *tablename,
 	   const struct ipt_entry *e,
@@ -43,6 +82,20 @@
            unsigned int targinfosize,
            unsigned int hook_mask)
 {
+ 	const struct ipt_mark_target_info *markinfo = targinfo;
+	struct ipt_entry_target *t
+		= container_of(targinfo, struct ipt_entry_target, data);
+
+	if (strcmp(tablename, "mangle") != 0) {
+		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (targinfosize==IPT_ALIGN(sizeof(struct ipt_mark_target_old_info))) {
+		t->u.kernel.target = &ipt_mark_old_reg;
+		return 1;
+	}
+
 	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_mark_target_info))) {
 		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
 		       targinfosize,
@@ -50,8 +104,11 @@
 		return 0;
 	}
 
-	if (strcmp(tablename, "mangle") != 0) {
-		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
+	if (markinfo->mode != IPT_MARK_SET
+	    && markinfo->mode != IPT_MARK_AND
+	    && markinfo->mode != IPT_MARK_OR) {
+		printk(KERN_WARNING "MARK: unknown mode %u\n",
+		       markinfo->mode);
 		return 0;
 	}
 

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
