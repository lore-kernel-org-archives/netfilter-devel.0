From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 12/18] Netfilter:  Add bitops to ipt_MARK without breaking
	compatbility
Date: Wed, 05 Jan 2005 14:34:52 +1100
Message-ID: <1104896093.20582.76.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Add bitops to ipt_MARK without breaking compatbility
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Anders Fugmann <afu@fugmann.dhs.org> wrote a patch to add bitops to
ipt_MARK.  I made a version based on the revision patch.

Bart De Schuymer <bdschuym@pandora.be> provided the idea of overriding
the target type.

Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_MARK.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ipt_MARK.c	2004-12-29 14:38:13.057844376 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ipt_MARK.c	2004-12-29 15:20:28.792354136 +1100
@@ -20,12 +20,12 @@
 MODULE_DESCRIPTION("iptables MARK modification module");
 
 static unsigned int
-target(struct sk_buff **pskb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const void *targinfo,
-       void *userinfo)
+target_v0(struct sk_buff **pskb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  unsigned int hooknum,
+	  const void *targinfo,
+	  void *userinfo)
 {
 	const struct ipt_mark_target_info *markinfo = targinfo;
 
@@ -36,12 +36,45 @@
 	return IPT_CONTINUE;
 }
 
+static unsigned int
+target_v1(struct sk_buff **pskb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  unsigned int hooknum,
+	  const void *targinfo,
+	  void *userinfo)
+{
+	const struct ipt_mark_target_info_v1 *markinfo = targinfo;
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
 static int
-checkentry(const char *tablename,
-	   const struct ipt_entry *e,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
+checkentry_v0(const char *tablename,
+	      const struct ipt_entry *e,
+	      void *targinfo,
+	      unsigned int targinfosize,
+	      unsigned int hook_mask)
 {
 	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_mark_target_info))) {
 		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
@@ -58,21 +91,71 @@
 	return 1;
 }
 
-static struct ipt_target ipt_mark_reg = {
+static int
+checkentry_v1(const char *tablename,
+	      const struct ipt_entry *e,
+	      void *targinfo,
+	      unsigned int targinfosize,
+	      unsigned int hook_mask)
+{
+	struct ipt_mark_target_info_v1 *markinfo = targinfo;
+
+	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_mark_target_info_v1))){
+		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
+		       targinfosize,
+		       IPT_ALIGN(sizeof(struct ipt_mark_target_info_v1)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") != 0) {
+		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (markinfo->mode != IPT_MARK_SET
+	    && markinfo->mode != IPT_MARK_AND
+	    && markinfo->mode != IPT_MARK_OR) {
+		printk(KERN_WARNING "MARK: unknown mode %u\n",
+		       markinfo->mode);
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct ipt_target ipt_mark_reg_v0 = {
 	.name		= "MARK",
-	.target		= target,
-	.checkentry	= checkentry,
+	.target		= target_v0,
+	.checkentry	= checkentry_v0,
 	.me		= THIS_MODULE,
+	.revision	= 0,
+};
+
+static struct ipt_target ipt_mark_reg_v1 = {
+	.name		= "MARK",
+	.target		= target_v1,
+	.checkentry	= checkentry_v1,
+	.me		= THIS_MODULE,
+	.revision	= 1,
 };
 
 static int __init init(void)
 {
-	return ipt_register_target(&ipt_mark_reg);
+	int err;
+
+	err = ipt_register_target(&ipt_mark_reg_v0);
+	if (!err) {
+		err = ipt_register_target(&ipt_mark_reg_v1);
+		if (err)
+			ipt_unregister_target(&ipt_mark_reg_v0);
+	}
+	return err;
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_target(&ipt_mark_reg);
+	ipt_unregister_target(&ipt_mark_reg_v0);
+	ipt_unregister_target(&ipt_mark_reg_v1);
 }
 
 module_init(init);
Index: linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ipt_MARK.h
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ipt_MARK.h	2004-12-29 14:38:13.057844376 +1100
+++ linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ipt_MARK.h	2004-12-29 15:18:20.243896472 +1100
@@ -1,8 +1,20 @@
 #ifndef _IPT_MARK_H_target
 #define _IPT_MARK_H_target
 
+/* Version 0 */
 struct ipt_mark_target_info {
 	unsigned long mark;
 };
 
+/* Version 1 */
+enum {
+	IPT_MARK_SET=0,
+	IPT_MARK_AND,
+	IPT_MARK_OR
+};
+
+struct ipt_mark_target_info_v1 {
+	unsigned long mark;
+	u_int8_t mode;
+};
 #endif /*_IPT_MARK_H_target*/
