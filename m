From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 10/18] Netfilter:  Steal a Character To Create a Revision
	Number
Date: Wed, 05 Jan 2005 14:34:07 +1100
Message-ID: <1104896047.20582.73.camel@localhost.localdomain>
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

Name: Steal a Character To Create a Revision Number
Status: Tested under nfsim
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Pablo Neira <pablo@eurodev.net> came up with the idea of stealing the
last byte in the (already nul-terminated) name of a target/match to
create a version.

That patch motivated me to clean up the match and target searching in
ip_tables, which makes this patch more trivial.  I also renamed
"version" to "revision" since the word "version" was used for iptables
itself.

===== include/linux/netfilter_ipv4/ip_tables.h 1.12 vs edited =====
Index: linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_tables.c
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/net/ipv4/netfilter/ip_tables.c	2004-12-29 16:58:27.500654632 +1100
+++ linux-2.6.10-bk1-Netfilter/net/ipv4/netfilter/ip_tables.c	2004-12-29 16:58:29.014424504 +1100
@@ -430,34 +430,62 @@
 	return NULL;
 }
 
-/* Find match by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-static inline struct ipt_match *find_match_lock(const char *name)
+/* Find match, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct ipt_match *find_match_lock(const char *name, u8 revision)
 {
 	struct ipt_match *m;
+	int found = 0;
 
 	if (down_interruptible(&ipt_mutex) != 0)
 		return ERR_PTR(-EINTR);
 
-	list_for_each_entry(m, &ipt_match, list)
-		if (strcmp(m->name, name) == 0 && try_module_get(m->me))
-			return m;
+	list_for_each_entry(m, &ipt_match, list) {
+		if (strcmp(m->name, name) == 0) {
+			found = 1;
+			if (m->revision == revision) {
+				if (!try_module_get(m->me))
+					found = 0;
+				else
+					return m;
+			}
+		}
+	}
 	up(&ipt_mutex);
-	return NULL;
+
+	/* Not found at all?  NULL so try_then_request_module loads module. */
+	if (!found)
+		return NULL;
+
+	return ERR_PTR(-EPROTOTYPE);
 }
 
-/* Find target by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-static inline struct ipt_target *find_target_lock(const char *name)
+/* Find target, grabs mutex & ref.  Returns ERR_PTR() on error. */
+static inline struct ipt_target *find_target_lock(const char *name, u8 revision)
 {
 	struct ipt_target *t;
+	int found = 0;
 
 	if (down_interruptible(&ipt_mutex) != 0)
 		return ERR_PTR(-EINTR);
 
-	list_for_each_entry(t, &ipt_target, list)
-		if (strcmp(t->name, name) == 0 && try_module_get(t->me))
-			return t;
+	list_for_each_entry(t, &ipt_target, list) {
+		if (strcmp(t->name, name) == 0) {
+			found = 1;
+			if (t->revision == revision) {
+				if (!try_module_get(t->me))
+					found = 0;
+				else
+					return t;
+			}
+		}
+	}
 	up(&ipt_mutex);
-	return NULL;
+
+	/* Not found at all?  NULL so try_then_request_module loads module. */
+	if (!found)
+		return NULL;
+
+	return ERR_PTR(-EPROTOTYPE);
 }
 
 /* All zeroes == unconditional rule. */
@@ -621,7 +649,8 @@
 {
 	struct ipt_match *match;
 
-	match = try_then_request_module(find_match_lock(m->u.user.name),
+	match = try_then_request_module(find_match_lock(m->u.user.name,
+							m->u.user.revision),
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("check_match: `%s' not found\n", m->u.user.name);
@@ -666,7 +695,8 @@
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
-	target = try_then_request_module(find_target_lock(t->u.user.name),
+	target = try_then_request_module(find_target_lock(t->u.user.name,
+							  t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
@@ -1303,12 +1333,7 @@
 	ret = down_interruptible(&ipt_mutex);
 	if (ret != 0)
 		return ret;
-
-	if (!list_named_insert(&ipt_target, target)) {
-		duprintf("ipt_register_target: `%s' already in list!\n",
-			 target->name);
-		ret = -EINVAL;
-	}
+	list_add(&target->list, &ipt_target);
 	up(&ipt_mutex);
 	return ret;
 }
@@ -1330,11 +1355,7 @@
 	if (ret != 0)
 		return ret;
 
-	if (!list_named_insert(&ipt_match, match)) {
-		duprintf("ipt_register_match: `%s' already in list!\n",
-			 match->name);
-		ret = -EINVAL;
-	}
+	list_add(&match->list, &ipt_match);
 	up(&ipt_mutex);
 
 	return ret;
Index: linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ip_tables.h
===================================================================
--- linux-2.6.10-bk1-Netfilter.orig/include/linux/netfilter_ipv4/ip_tables.h	2004-12-29 16:58:27.523651136 +1100
+++ linux-2.6.10-bk1-Netfilter/include/linux/netfilter_ipv4/ip_tables.h	2004-12-29 16:58:29.014424504 +1100
@@ -53,7 +53,9 @@
 			u_int16_t match_size;
 
 			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN];
+			char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t match_size;
@@ -76,7 +78,9 @@
 			u_int16_t target_size;
 
 			/* Used by userspace */
-			char name[IPT_FUNCTION_MAXNAMELEN];
+			char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t revision;
 		} user;
 		struct {
 			u_int16_t target_size;
@@ -344,7 +348,9 @@
 {
 	struct list_head list;
 
-	const char name[IPT_FUNCTION_MAXNAMELEN];
+	const char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
 
 	/* Return true or false: return FALSE and set *hotdrop = 1 to
            force immediate packet drop. */
@@ -378,7 +384,9 @@
 {
 	struct list_head list;
 
-	const char name[IPT_FUNCTION_MAXNAMELEN];
+	const char name[IPT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
