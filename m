From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 34/47] netfilter: ebtables: Add support for specifying match revision
Date: Fri, 30 Mar 2018 13:44:56 +0200
Message-ID: <20180330114509.18738-5-pablo@netfilter.org>
References: <20180330114509.18738-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330114509.18738-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Bernie Harris <bernie.harris@alliedtelesis.co.nz>

Currently ebtables assumes that the revision number of all match
modules is 0, which is an issue when trying to use existing
xtables matches with ebtables. The solution is to modify ebtables
to allow extensions to specify a revision number, similar to
iptables. This gets passed down to the kernel, which is then able
to find the match module correctly.

To main binary backwards compatibility, the size of the ebt_entry
structures is not changed, only the size of the name field is
decreased by 1 byte to make room for the revision field.

Signed-off-by: Bernie Harris <bernie.harris@alliedtelesis.co.nz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_bridge/ebtables.h | 16 +++++++--
 net/bridge/netfilter/ebtables.c                | 47 ++++++++++++++++----------
 2 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge/ebtables.h b/include/uapi/linux/netfilter_bridge/ebtables.h
index 9ff57c0a0199..0c7dc8315013 100644
--- a/include/uapi/linux/netfilter_bridge/ebtables.h
+++ b/include/uapi/linux/netfilter_bridge/ebtables.h
@@ -20,6 +20,7 @@
 #define EBT_TABLE_MAXNAMELEN 32
 #define EBT_CHAIN_MAXNAMELEN EBT_TABLE_MAXNAMELEN
 #define EBT_FUNCTION_MAXNAMELEN EBT_TABLE_MAXNAMELEN
+#define EBT_EXTENSION_MAXNAMELEN 31
 
 /* verdicts >0 are "branches" */
 #define EBT_ACCEPT   -1
@@ -120,7 +121,10 @@ struct ebt_entries {
 
 struct ebt_entry_match {
 	union {
-		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct {
+			char name[EBT_EXTENSION_MAXNAMELEN];
+			uint8_t revision;
+		};
 		struct xt_match *match;
 	} u;
 	/* size of data */
@@ -130,7 +134,10 @@ struct ebt_entry_match {
 
 struct ebt_entry_watcher {
 	union {
-		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct {
+			char name[EBT_EXTENSION_MAXNAMELEN];
+			uint8_t revision;
+		};
 		struct xt_target *watcher;
 	} u;
 	/* size of data */
@@ -140,7 +147,10 @@ struct ebt_entry_watcher {
 
 struct ebt_entry_target {
 	union {
-		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct {
+			char name[EBT_EXTENSION_MAXNAMELEN];
+			uint8_t revision;
+		};
 		struct xt_target *target;
 	} u;
 	/* size of data */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 9a26d2b7420f..a8cb543e3296 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -356,12 +356,12 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
 
-	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, 0);
+	match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	if (IS_ERR(match) || match->family != NFPROTO_BRIDGE) {
 		if (!IS_ERR(match))
 			module_put(match->me);
 		request_module("ebt_%s", m->u.name);
-		match = xt_find_match(NFPROTO_BRIDGE, m->u.name, 0);
+		match = xt_find_match(NFPROTO_BRIDGE, m->u.name, m->u.revision);
 	}
 	if (IS_ERR(match))
 		return PTR_ERR(match);
@@ -1350,16 +1350,17 @@ static int update_counters(struct net *net, const void __user *user,
 
 static inline int ebt_obj_to_user(char __user *um, const char *_name,
 				  const char *data, int entrysize,
-				  int usersize, int datasize)
+				  int usersize, int datasize, u8 revision)
 {
-	char name[EBT_FUNCTION_MAXNAMELEN] = {0};
+	char name[EBT_EXTENSION_MAXNAMELEN] = {0};
 
-	/* ebtables expects 32 bytes long names but xt_match names are 29 bytes
+	/* ebtables expects 31 bytes long names but xt_match names are 29 bytes
 	 * long. Copy 29 bytes and fill remaining bytes with zeroes.
 	 */
 	strlcpy(name, _name, sizeof(name));
-	if (copy_to_user(um, name, EBT_FUNCTION_MAXNAMELEN) ||
-	    put_user(datasize, (int __user *)(um + EBT_FUNCTION_MAXNAMELEN)) ||
+	if (copy_to_user(um, name, EBT_EXTENSION_MAXNAMELEN) ||
+	    put_user(revision, (u8 __user *)(um + EBT_EXTENSION_MAXNAMELEN)) ||
+	    put_user(datasize, (int __user *)(um + EBT_EXTENSION_MAXNAMELEN + 1)) ||
 	    xt_data_to_user(um + entrysize, data, usersize, datasize,
 			    XT_ALIGN(datasize)))
 		return -EFAULT;
@@ -1372,7 +1373,8 @@ static inline int ebt_match_to_user(const struct ebt_entry_match *m,
 {
 	return ebt_obj_to_user(ubase + ((char *)m - base),
 			       m->u.match->name, m->data, sizeof(*m),
-			       m->u.match->usersize, m->match_size);
+			       m->u.match->usersize, m->match_size,
+			       m->u.match->revision);
 }
 
 static inline int ebt_watcher_to_user(const struct ebt_entry_watcher *w,
@@ -1380,7 +1382,8 @@ static inline int ebt_watcher_to_user(const struct ebt_entry_watcher *w,
 {
 	return ebt_obj_to_user(ubase + ((char *)w - base),
 			       w->u.watcher->name, w->data, sizeof(*w),
-			       w->u.watcher->usersize, w->watcher_size);
+			       w->u.watcher->usersize, w->watcher_size,
+			       w->u.watcher->revision);
 }
 
 static inline int ebt_entry_to_user(struct ebt_entry *e, const char *base,
@@ -1411,7 +1414,8 @@ static inline int ebt_entry_to_user(struct ebt_entry *e, const char *base,
 	if (ret != 0)
 		return ret;
 	ret = ebt_obj_to_user(hlp, t->u.target->name, t->data, sizeof(*t),
-			      t->u.target->usersize, t->target_size);
+			      t->u.target->usersize, t->target_size,
+			      t->u.target->revision);
 	if (ret != 0)
 		return ret;
 
@@ -1599,7 +1603,10 @@ struct compat_ebt_replace {
 /* struct ebt_entry_match, _target and _watcher have same layout */
 struct compat_ebt_entry_mwt {
 	union {
-		char name[EBT_FUNCTION_MAXNAMELEN];
+		struct {
+			char name[EBT_EXTENSION_MAXNAMELEN];
+			u8 revision;
+		};
 		compat_uptr_t ptr;
 	} u;
 	compat_uint_t match_size;
@@ -1638,8 +1645,9 @@ static int compat_match_to_user(struct ebt_entry_match *m, void __user **dstptr,
 
 	BUG_ON(off >= m->match_size);
 
-	if (copy_to_user(cm->u.name, match->name,
-	    strlen(match->name) + 1) || put_user(msize, &cm->match_size))
+	if (copy_to_user(cm->u.name, match->name, strlen(match->name) + 1) ||
+	    put_user(match->revision, &cm->u.revision) ||
+	    put_user(msize, &cm->match_size))
 		return -EFAULT;
 
 	if (match->compat_to_user) {
@@ -1668,8 +1676,9 @@ static int compat_target_to_user(struct ebt_entry_target *t,
 
 	BUG_ON(off >= t->target_size);
 
-	if (copy_to_user(cm->u.name, target->name,
-	    strlen(target->name) + 1) || put_user(tsize, &cm->match_size))
+	if (copy_to_user(cm->u.name, target->name, strlen(target->name) + 1) ||
+	    put_user(target->revision, &cm->u.revision) ||
+	    put_user(tsize, &cm->match_size))
 		return -EFAULT;
 
 	if (target->compat_to_user) {
@@ -1933,7 +1942,7 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 				struct ebt_entries_buf_state *state,
 				const unsigned char *base)
 {
-	char name[EBT_FUNCTION_MAXNAMELEN];
+	char name[EBT_EXTENSION_MAXNAMELEN];
 	struct xt_match *match;
 	struct xt_target *wt;
 	void *dst = NULL;
@@ -1947,7 +1956,8 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 
 	switch (compat_mwt) {
 	case EBT_COMPAT_MATCH:
-		match = xt_request_find_match(NFPROTO_BRIDGE, name, 0);
+		match = xt_request_find_match(NFPROTO_BRIDGE, name,
+					      mwt->u.revision);
 		if (IS_ERR(match))
 			return PTR_ERR(match);
 
@@ -1966,7 +1976,8 @@ static int compat_mtw_from_user(struct compat_ebt_entry_mwt *mwt,
 		break;
 	case EBT_COMPAT_WATCHER: /* fallthrough */
 	case EBT_COMPAT_TARGET:
-		wt = xt_request_find_target(NFPROTO_BRIDGE, name, 0);
+		wt = xt_request_find_target(NFPROTO_BRIDGE, name,
+					    mwt->u.revision);
 		if (IS_ERR(wt))
 			return PTR_ERR(wt);
 		off = xt_compat_target_offset(wt);
-- 
2.11.0
