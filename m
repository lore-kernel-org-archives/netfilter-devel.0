From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] ipt_MARK extension with backwards
 compatibility	(kernel side).
Date: Fri, 26 Nov 2004 23:58:28 +0100
Message-ID: <41A7B514.9030703@eurodev.net>
References: <1101358191.5842.26.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000205030103050202070109"
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1101358191.5842.26.camel@localhost.localdomain>
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
--------------000205030103050202070109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Rusty Russell wrote:

>We've been chasing this for a while; thanks to Bart for the final piece!
>  
>

that is good news, we finally drop that heavy anchor :)

>2) If not, you must extend the size of the structure, so old kernels
>will fail, and new kernels will be able to tell whether they are to use
>the new or old structure.  The IPT_ALIGN'ed size of the structure must
>change for this to work!
>  
>

My idea, I don't know how crazy it is. Instead of using the size to 
guess the target/match version, we could steal 1 byte from char name[] 
to define a new field called version, so we could register different 
versions of a match/target.

Possible scenarios:
a) Old kernel, new iptables binary: since names are manipulated with 
str* functions, it shouldn't be any problem with the version stuff 
because it will be ignored since info after first '\0' is ignored.
b) New kernel, old iptables: version value is zero, so kernel guess that 
it must handle the thing with first version of the target/match.

Possible Inconvenients?:
a) Current target/match with a name 29 byte long. Hm I think that 
there's no target/match like that.
b) Could gcc mess things with alignments and break compatibility?
c) Something I'm missing 8)

Attached just the beginning of a possible patch, things like 
ipt_register_* version aware should be implemented.

--
Pablo

--------------000205030103050202070109
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== include/linux/netfilter_ipv4/ip_tables.h 1.12 vs edited =====
--- 1.12/include/linux/netfilter_ipv4/ip_tables.h	2004-11-02 01:39:53 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_tables.h	2004-11-26 22:33:07 +01:00
@@ -25,6 +25,7 @@
 #include <linux/compiler.h>
 #include <linux/netfilter_ipv4.h>
 
+#define IPT_TARGET_MATCH_MAXNAMELEN 29
 #define IPT_FUNCTION_MAXNAMELEN 30
 #define IPT_TABLE_MAXNAMELEN 32
 
@@ -53,7 +54,9 @@
 			u_int16_t match_size;
 
 			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN];
+			char name[IPT_TARGET_MATCH_MAXNAMELEN];
+			/* Version */
+			u_int8_t version;
 		} user;
 		struct {
 			u_int16_t match_size;
@@ -76,7 +79,9 @@
 			u_int16_t target_size;
 
 			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN];
+			char name[IPT_TARGET_MATCH_MAXNAMELEN];
+			/* Version */
+			u_int8_t version;
 		} user;
 		struct {
 			u_int16_t target_size;
@@ -344,7 +349,10 @@
 {
 	struct list_head list;
 
-	const char name[IPT_FUNCTION_MAXNAMELEN];
+	const char name[IPT_TARGET_MATCH_MAXNAMELEN];
+
+	/* Version */
+	u_int8_t version;
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
            force immediate packet drop. */
@@ -378,7 +386,10 @@
 {
 	struct list_head list;
 
-	const char name[IPT_FUNCTION_MAXNAMELEN];
+	const char name[IPT_TARGET_MATCH_MAXNAMELEN];
+
+	/* Version */
+	u_int8_t version;
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
===== include/linux/netfilter_ipv4/listhelp.h 1.4 vs edited =====
--- 1.4/include/linux/netfilter_ipv4/listhelp.h	2004-02-20 23:51:48 +01:00
+++ edited/include/linux/netfilter_ipv4/listhelp.h	2004-11-26 23:08:52 +01:00
@@ -118,6 +118,24 @@
 	return 1;
 }
 
+/* Returns false if same name already in list, otherwise does insert. */
+static inline int
+list_named_version_insert(struct list_head *head, void *new)
+{
+	struct list_head *i;
+	u_int8_t ver, new_ver;
+
+	list_for_each(i, head) {
+		ver = i + sizeof(list_head) + NAMELEN_TARGET_MATCH_MAXLEN;
+		new_ver = i + sizeof(list_head) + NAMELEN_TARGET_MATCH_MAXLEN;
+		if (__list_cmp_name(i, new + sizeof(struct list_head))
+		    && ver == new_ver)
+			return 0;
+	}
+	list_prepend(head, new);
+	return 1;
+}
+
 /* Find this named element in the list. */
 #define list_named_find(head, name)			\
 LIST_FIND(head, __list_cmp_name, void *, name)
===== net/ipv4/netfilter/ip_tables.c 1.34 vs edited =====
--- 1.34/net/ipv4/netfilter/ip_tables.c	2004-11-16 00:00:45 +01:00
+++ edited/net/ipv4/netfilter/ip_tables.c	2004-11-26 23:13:48 +01:00
@@ -1339,7 +1339,7 @@
 	if (ret != 0)
 		return ret;
 
-	if (!list_named_insert(&ipt_target, target)) {
+	if (!list_named_version_insert(&ipt_target, target)) {
 		duprintf("ipt_register_target: `%s' already in list!\n",
 			 target->name);
 		ret = -EINVAL;
@@ -1365,7 +1365,7 @@
 	if (ret != 0)
 		return ret;
 
-	if (!list_named_insert(&ipt_match, match)) {
+	if (!list_named_version_insert(&ipt_match, match)) {
 		duprintf("ipt_register_match: `%s' already in list!\n",
 			 match->name);
 		ret = -EINVAL;

--------------000205030103050202070109--
