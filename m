From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] ipt_MARK extension with backwards
 compatibility	(kernel side).
Date: Tue, 07 Dec 2004 22:20:04 +0100
Message-ID: <41B61E84.7020304@eurodev.net>
References: <1101358191.5842.26.camel@localhost.localdomain>
	<41A7B514.9030703@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080107030401080809050104"
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Rusty Russell <rusty@rustcorp.com.au>, Netfilter development mailing list
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41A7B514.9030703@eurodev.net>
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
--------------080107030401080809050104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira wrote:

>> 2) If not, you must extend the size of the structure, so old kernels
>> will fail, and new kernels will be able to tell whether they are to use
>> the new or old structure.  The IPT_ALIGN'ed size of the structure must
>> change for this to work!
>
>
> My idea, I don't know how crazy it is. Instead of using the size to 
> guess the target/match version, we could steal 1 byte from char name[] 
> to define a new field called version, so we could register different 
> versions of a match/target.
>
> Possible scenarios:
> a) Old kernel, new iptables binary: since names are manipulated with 
> str* functions, it shouldn't be any problem with the version stuff 
> because it will be ignored since info after first '\0' is ignored.
> b) New kernel, old iptables: version value is zero, so kernel guess 
> that it must handle the thing with first version of the target/match.


I finally found some spare time to go back this issue, I've finished two 
patches for the kernel part of my idea of adding versions to 
targets/matches. One for ip_tables, and other for ipt_MARK, this based 
on Rusty's.

iptables (user space) patches is still missing  :(

It works for me (TM) on a x86/gcc-2.95 with both patches applied and 
using an old binary version of iptables to test that doesn't break 
backward compatibility.

Please, say crap/cool/dirty/crazy/whatever about this.

--
Pablo

--------------080107030401080809050104
Content-Type: text/x-patch;
 name="ip_table-version.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ip_table-version.patch"

===== include/linux/netfilter_ipv4/ip_tables.h 1.12 vs edited =====
--- 1.12/include/linux/netfilter_ipv4/ip_tables.h	2004-11-02 01:39:53 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_tables.h	2004-12-07 20:16:50 +01:00
@@ -53,7 +53,9 @@
 			u_int16_t match_size;
 
 			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN];
+			char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t version;
 		} user;
 		struct {
 			u_int16_t match_size;
@@ -76,7 +78,9 @@
 			u_int16_t target_size;
 
 			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN];
+			char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t version;
 		} user;
 		struct {
 			u_int16_t target_size;
@@ -344,7 +348,9 @@
 {
 	struct list_head list;
 
-	const char name[IPT_FUNCTION_MAXNAMELEN];
+	const char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t version;
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
            force immediate packet drop. */
@@ -378,7 +384,9 @@
 {
 	struct list_head list;
 
-	const char name[IPT_FUNCTION_MAXNAMELEN];
+	const char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t version;
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
@@ -414,7 +422,7 @@
 extern void ipt_unregister_match(struct ipt_match *match);
 
 extern struct ipt_target *
-__ipt_find_target_lock(const char *name, int *error);
+__ipt_find_target_lock(const char *name, const u_int8_t ver, int *error);
 extern void __ipt_mutex_up(void);
 
 /* Furniture shopping... */
===== net/ipv4/netfilter/ip_tables.c 1.34 vs edited =====
--- 1.34/net/ipv4/netfilter/ip_tables.c	2004-11-16 00:00:45 +01:00
+++ edited/net/ipv4/netfilter/ip_tables.c	2004-12-07 20:07:45 +01:00
@@ -465,22 +465,133 @@
 	return find_inlist_lock(&ipt_tables, name, "iptable_", error, mutex);
 }
 
+static struct ipt_target *
+find_target(const char *name, u_int8_t version)
+{
+	struct list_head *i;
+	struct ipt_target *t;
+
+	list_for_each(i, &ipt_target) {
+		t = (struct ipt_target *) i;
+		if (!strcmp(name, t->name)
+		    && version == t->version)
+			return t;
+	}
+	return NULL;
+}
+
+static struct ipt_match *
+find_match(const char *name, u_int8_t version)
+{
+	struct list_head *i;
+	struct ipt_match *m;
+
+	list_for_each(i, &ipt_match) {
+		m = (struct ipt_match *) i;
+		if (!strcmp(name, m->name)
+		    && version == m->version)
+			return m;
+	}
+	return NULL;
+}
+
+static int
+target_insert(struct ipt_target *target)
+{
+	if (find_target(target->name, target->version) == NULL) {
+		list_prepend(&ipt_target, target);
+		return 1;
+	}
+	return 0;
+}
+
+static int
+match_insert(struct ipt_match *match)
+{
+	if (find_match(match->name, match->version) == NULL) {
+		list_prepend(&ipt_match, match);
+		return 1;
+	}
+	return 0;
+}
+
+#define IPT_MATCH 0
+#define IPT_TARGET 1
+
+static inline void *
+find_inlist_tm_lock_noload(const char *name,
+			const u_int8_t ver,
+			int *error,
+			struct semaphore *mutex,
+			int type)
+{
+	void *ret = NULL;
+
+	*error = down_interruptible(mutex);
+	if (*error != 0)
+		return NULL;
+
+	switch(type) {
+		case IPT_MATCH:
+			ret = (void *) find_match(name, ver);
+			break;
+		case IPT_TARGET:
+			ret = (void *) find_target(name, ver);
+			break;
+		default:
+			/* shouldn't happen */
+			break;
+	}
+	if (!ret) {
+		printk("find_tm_lock_noload: `%s' version=(%1x) not found!\n", name, ver);
+		*error = -ENOENT;
+		up(mutex);
+	}
+	return ret;
+}
+
+#ifndef CONFIG_KMOD
+#define find_inlist_tm_lock(n,v,p,e,m,t) find_inlist_tm_lock_noload((n),(v),(e),(m),(t))
+#else
+static void *
+find_inlist_tm_lock(const char *name,
+		    const u_int8_t ver,
+		    const char *prefix,
+		    int *error,
+		    struct semaphore *mutex,
+		    int type)
+{
+	void *ret;
+
+	ret = find_inlist_tm_lock_noload(name, ver, error, mutex, type);
+	if (!ret) {
+		duprintf("find_inlist: loading `%s%s'.\n", prefix, name);
+		request_module("%s%s", prefix, name);
+		ret = find_inlist_tm_lock_noload(name, ver, error, mutex,type);
+	}
+
+	return ret;
+}
+#endif
+
 static inline struct ipt_match *
-find_match_lock(const char *name, int *error, struct semaphore *mutex)
+find_match_lock(const char *name, u_int8_t ver, int *error, 
+		struct semaphore *mutex)
 {
-	return find_inlist_lock(&ipt_match, name, "ipt_", error, mutex);
+	return find_inlist_tm_lock(name, ver, "ipt_", error, mutex, IPT_MATCH);
 }
 
 static struct ipt_target *
-ipt_find_target_lock(const char *name, int *error, struct semaphore *mutex)
+ipt_find_target_lock(const char *name, const u_int8_t ver, int *error, 
+		     struct semaphore *mutex)
 {
-	return find_inlist_lock(&ipt_target, name, "ipt_", error, mutex);
+	return find_inlist_tm_lock(name, ver, "ipt_", error, mutex,IPT_TARGET);
 }
 
 struct ipt_target *
-__ipt_find_target_lock(const char *name, int *error)
+__ipt_find_target_lock(const char *name, const u_int8_t ver, int *error)
 {
-	return ipt_find_target_lock(name,error,&ipt_mutex);
+	return ipt_find_target_lock(name,ver,error,&ipt_mutex);
 }
 
 void
@@ -651,7 +762,8 @@
 	int ret;
 	struct ipt_match *match;
 
-	match = find_match_lock(m->u.user.name, &ret, &ipt_mutex);
+	match = find_match_lock(m->u.user.name, m->u.user.version, &ret,
+				&ipt_mutex);
 	if (!match) {
 		duprintf("check_match: `%s' not found\n", m->u.user.name);
 		return ret;
@@ -699,7 +811,8 @@
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
-	target = ipt_find_target_lock(t->u.user.name, &ret, &ipt_mutex);
+	target = ipt_find_target_lock(t->u.user.name, t->u.user.version, &ret,
+				      &ipt_mutex);
 	if (!target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		goto cleanup_matches;
@@ -1339,12 +1452,13 @@
 	if (ret != 0)
 		return ret;
 
-	if (!list_named_insert(&ipt_target, target)) {
-		duprintf("ipt_register_target: `%s' already in list!\n",
-			 target->name);
-		ret = -EINVAL;
+	if (!target_insert(target)) {
+		printk("ipt_register_target: `%s' already in list!\n",
+			target->name);
+		return -EINVAL;
 	}
 	up(&ipt_mutex);
+	printk("register_target: `%s' registered\n", target->name);
 	return ret;
 }
 
@@ -1365,12 +1479,13 @@
 	if (ret != 0)
 		return ret;
 
-	if (!list_named_insert(&ipt_match, match)) {
-		duprintf("ipt_register_match: `%s' already in list!\n",
-			 match->name);
-		ret = -EINVAL;
+	if (!match_insert(match)) {
+		printk("ipt_register_match: `%s' already in list!\n",
+			match->name);
+		return -EINVAL;
 	}
 	up(&ipt_mutex);
+	printk("register_match: `%s' registered\n", match->name);
 
 	return ret;
 }

--------------080107030401080809050104
Content-Type: text/x-patch;
 name="ipt_mark.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_mark.patch"

===== include/linux/netfilter_ipv4/ipt_MARK.h 1.1 vs edited =====
--- 1.1/include/linux/netfilter_ipv4/ipt_MARK.h	2002-02-05 18:39:43 +01:00
+++ edited/include/linux/netfilter_ipv4/ipt_MARK.h	2004-12-07 21:17:33 +01:00
@@ -1,8 +1,19 @@
 #ifndef _IPT_MARK_H_target
 #define _IPT_MARK_H_target
 
-struct ipt_mark_target_info {
+struct ipt_mark_target_info_v0 {
 	unsigned long mark;
+};
+
+enum {
+	IPT_MARK_SET=0,
+	IPT_MARK_AND,
+	IPT_MARK_OR
+};
+
+struct ipt_mark_target_info_v1 {
+	unsigned long mark;
+	u_int8_t mode;
 };
 
 #endif /*_IPT_MARK_H_target*/
===== net/ipv4/netfilter/ipt_MARK.c 1.7 vs edited =====
--- 1.7/net/ipv4/netfilter/ipt_MARK.c	2004-01-30 02:00:13 +01:00
+++ edited/net/ipv4/netfilter/ipt_MARK.c	2004-12-07 21:29:03 +01:00
@@ -20,14 +20,14 @@
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
-	const struct ipt_mark_target_info *markinfo = targinfo;
+	const struct ipt_mark_target_info_v0 *markinfo = targinfo;
 
 	if((*pskb)->nfmark != markinfo->mark) {
 		(*pskb)->nfmark = markinfo->mark;
@@ -36,43 +36,118 @@
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
-	if (targinfosize != IPT_ALIGN(sizeof(struct ipt_mark_target_info))) {
+	if (strcmp(tablename, "mangle") != 0) {
+		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (targinfosize 
+	    != IPT_ALIGN(sizeof(struct ipt_mark_target_info_v0))) {
 		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
 		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_mark_target_info)));
+		       IPT_ALIGN(sizeof(struct ipt_mark_target_info_v0)));
 		return 0;
 	}
+	return 1;
+}
+
+static struct ipt_target ipt_mark_reg_v0 = {
+	.name		= "MARK",
+	.target		= target_v0,
+	.checkentry	= checkentry_v0,
+	.me		= THIS_MODULE,
+};
+
+static int
+checkentry_v1(const char *tablename,
+	      const struct ipt_entry *e,
+	      void *targinfo,
+	      unsigned int targinfosize,
+	      unsigned int hook_mask)
+{
+	const struct ipt_mark_target_info_v1 *markinfo = targinfo;
 
 	if (strcmp(tablename, "mangle") != 0) {
 		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not \"%s\"\n", tablename);
 		return 0;
 	}
+		
+	if (targinfosize
+	    != IPT_ALIGN(sizeof(struct ipt_mark_target_info_v1))) {
+		printk(KERN_WARNING "MARK: targinfosize %u != %Zu\n",
+		       targinfosize,
+		       IPT_ALIGN(sizeof(struct ipt_mark_target_info_v1)));
+		return 0;
+	}
+	if (markinfo->mode != IPT_MARK_SET
+    	    && markinfo->mode != IPT_MARK_AND
+	    && markinfo->mode != IPT_MARK_OR) {
+		printk(KERN_WARNING "MARK: unknown mode %u\n",
+		       markinfo->mode);
+		return 0;
+	}
 
 	return 1;
 }
 
-static struct ipt_target ipt_mark_reg = {
+static struct ipt_target ipt_mark_reg_v1 = {
 	.name		= "MARK",
-	.target		= target,
-	.checkentry	= checkentry,
+	.version	= 0x1,
+	.target		= target_v1,
+	.checkentry	= checkentry_v1,
 	.me		= THIS_MODULE,
 };
 
 static int __init init(void)
 {
-	return ipt_register_target(&ipt_mark_reg);
+	if (ipt_register_target(&ipt_mark_reg_v0) < 0)
+		return -EINVAL;
+	return ipt_register_target(&ipt_mark_reg_v1);
 }
 
 static void __exit fini(void)
 {
-	ipt_unregister_target(&ipt_mark_reg);
+	ipt_unregister_target(&ipt_mark_reg_v0);
+	ipt_unregister_target(&ipt_mark_reg_v1);
 }
 
 module_init(init);

--------------080107030401080809050104--
