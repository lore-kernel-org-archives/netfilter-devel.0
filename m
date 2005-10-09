From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH JFYI] x_tables, first take
Date: Mon, 10 Oct 2005 00:45:02 +0200
Message-ID: <20051009224502.GD6593@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BghK6+krpKHjj+jk"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--BghK6+krpKHjj+jk
Content-Type: multipart/mixed; boundary="WIIRZ1HQ6FgrlPgb"
Content-Disposition: inline


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

At least those attending the workshop already know about "x_tables",
also-known-as "the project that kept Harald away from the pubbing at
night".

The idea is to consolidate the {arp,ip,ip6}_tables code as much as
possible.  Unfortunately the possibility is quite limited, but it's
enough to reduce the need for all those "ipt_limit/ip6t_limit" code
duplication. =20

If we don't merge something like x_tables, the copying will just become
worse, since then we'll need to copy state,connmark,connrate,conntrack
and all the others to ip6_tables :(

The patch is quite lengthy, so I point out the main features in all the
noise:

1) use a shared structure for {ip,arp,ip6}t_{target,match,table}
   respectively.  This new structures are called xt_{target,match,table}
2) separate the mutex and table/match/target list_heads' out of
   {ip,ip6,arp}_tables and put them into net/netfilter/x_tables.c.
   This new file maintains NPROTO arrays of them.
3) define all constants/.../ in include/netfilter/x_tables.h, and make
   include/netfilter_{ipv4,ipv6,arp}/{ip,arp,ip6}_tables.h just a
   wrapper around that
4) do the same like step '3' for per-extension headers
5) move 'shared' matches/targets from
   net/{ipv4,ipv6}/netfilter/{ip,ip6}t_FOO to net/netfilter/xt_FOO

I kept a careful eye on binary compatibility, so old userspace programs
_should_ transparently work without any trouble.  Lots of testing is
required, so if somebody wants to give
rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git#x_tables
a run in nfsim-testsuite, that would be appreciated quite a lot

Please send any comments/suggestions you might have.  I'll further work
on it, especially=20

a) try to remove the need for xt_tables[] and xt_mutex[] to be exported
   from x_tables.c
b) deal with some xt_owner incompatibilities between
c) have ip_tables provide real "protoff" pointer (e.g. layer 4 protocol
   header)
d) share tcp,udp,sctp,dccp matches between ip_tables and ip6_tables
e) try to figure out why the Kconfig magic for automatically selecting
   NETFILTER_XT_FOO based on old IP_NF_FOO values doesn't work as
   expected :(

Cheers,
	Harald

btw: patch is incremental to the {ip6,arp}_tables versioning support
that I just sent. =20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="x_tables.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x=
_tables.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/x_tables.h
@@ -0,0 +1,174 @@
+#ifndef _X_TABLES_H
+#define _X_TABLES_H
+
+#define XT_FUNCTION_MAXNAMELEN 30
+#define XT_TABLE_MAXNAMELEN 32
+
+/* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
+ * kernel supports, if >=3D revision. */
+struct xt_get_revision
+{
+	char name[XT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+};
+
+/* CONTINUE verdict for targets */
+#define XT_CONTINUE 0xFFFFFFFF
+
+/* For standard target */
+#define XT_RETURN (-NF_REPEAT - 1)
+
+#define XT_ALIGN(s) (((s) + (__alignof__(void *)-1)) & ~(__alignof__(void =
*)-1))
+
+/* Standard return verdict, or do jump. */
+#define XT_STANDARD_TARGET ""
+/* Error verdict. */
+#define XT_ERROR_TARGET "ERROR"
+
+/*
+ * New IP firewall options for [gs]etsockopt at the RAW IP level.
+ * Unlike BSD Linux inherits IP options so you don't have to use a raw
+ * socket for this. Instead we check rights in the calls. */
+#define XT_BASE_CTL		64	/* base for firewall socket options */
+
+#define XT_SO_SET_REPLACE	(XT_BASE_CTL)
+#define XT_SO_SET_ADD_COUNTERS	(XT_BASE_CTL + 1)
+#define XT_SO_SET_MAX		XT_SO_SET_ADD_COUNTERS
+
+#define XT_SO_GET_INFO			(XT_BASE_CTL)
+#define XT_SO_GET_ENTRIES		(XT_BASE_CTL + 1)
+#define XT_SO_GET_REVISION_MATCH	(XT_BASE_CTL + 2)
+#define XT_SO_GET_REVISION_TARGET	(XT_BASE_CTL + 3)
+#define XT_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
+
+#ifdef __KERNEL__
+
+#include <linux/netdevice.h>
+
+#define ASSERT_READ_LOCK(x)
+#define ASSERT_WRITE_LOCK(x)
+#include <linux/netfilter_ipv4/listhelp.h>
+
+struct xt_match
+{
+	struct list_head list;
+
+	const char name[XT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+
+	/* Return true or false: return FALSE and set *hotdrop =3D 1 to
+           force immediate packet drop. */
+	/* Arguments changed since 2.6.9, as this must now handle
+	   non-linear skb, using skb_header_pointer and
+	   skb_ip_make_writable. */
+	int (*match)(const struct sk_buff *skb,
+		     const struct net_device *in,
+		     const struct net_device *out,
+		     const void *matchinfo,
+		     int offset,
+		     unsigned int protoff,
+		     int *hotdrop);
+
+	/* Called when user tries to insert an entry of this type. */
+	/* Should return true or false. */
+	int (*checkentry)(const char *tablename,
+			  const void *ip,
+			  void *matchinfo,
+			  unsigned int matchinfosize,
+			  unsigned int hook_mask);
+
+	/* Called when entry of this type deleted. */
+	void (*destroy)(void *matchinfo, unsigned int matchinfosize);
+
+	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
+	struct module *me;
+};
+
+/* Registration hooks for targets. */
+struct xt_target
+{
+	struct list_head list;
+
+	const char name[XT_FUNCTION_MAXNAMELEN-1];
+
+	u_int8_t revision;
+
+	/* Returns verdict. Argument order changed since 2.6.9, as this
+	   must now handle non-linear skbs, using skb_copy_bits and
+	   skb_ip_make_writable. */
+	unsigned int (*target)(struct sk_buff **pskb,
+			       const struct net_device *in,
+			       const struct net_device *out,
+			       unsigned int hooknum,
+			       const void *targinfo,
+			       void *userdata);
+
+	/* Called when user tries to insert an entry of this type:
+           hook_mask is a bitmask of hooks from which it can be
+           called. */
+	/* Should return true or false. */
+	int (*checkentry)(const char *tablename,
+			  const void *entry,
+			  void *targinfo,
+			  unsigned int targinfosize,
+			  unsigned int hook_mask);
+
+	/* Called when entry of this type deleted. */
+	void (*destroy)(void *targinfo, unsigned int targinfosize);
+
+	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
+	struct module *me;
+};
+
+/* Furniture shopping... */
+struct xt_table
+{
+	struct list_head list;
+
+	/* A unique name... */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	/* What hooks you will enter on */
+	unsigned int valid_hooks;
+
+	/* Lock for the curtain */
+	rwlock_t lock;
+
+	/* Man behind the curtain... */
+	//struct ip6t_table_info *private;
+	void *private;
+
+	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
+	struct module *me;
+};
+
+extern int xt_register_target(int af, struct xt_target *target);
+extern void xt_unregister_target(int af, struct xt_target *target);
+extern int xt_register_match(int af, struct xt_match *target);
+extern void xt_unregister_match(int af, struct xt_match *target);
+
+extern int xt_register_table(struct xt_table *table,
+			     //const struct xt_replace *repl);
+			     const void *repl);
+extern void xt_unregister_table(struct xt_table *table);
+
+extern struct xt_match *xt_find_match(int af, const char *name, u8 revisio=
n);
+extern struct xt_target *xt_find_target(int af, const char *name, u8 revis=
ion);
+extern struct xt_target *xt_request_find_target(int af, const char *name,=
=20
+						u8 revision);
+extern int xt_find_revision(int af, const char *name, u8 revision, int tar=
get,
+			    int *err);
+
+extern struct xt_table *xt_find_table_lock(int af, const char *name);
+
+extern struct semaphore xt_mutex[NPROTO];
+extern struct list_head xt_tables[NPROTO];
+
+extern int xt_proto_init(int af);
+extern void xt_proto_fini(int af);
+
+#endif /* __KERNEL__ */
+
+#endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilte=
r/xt_CLASSIFY.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -0,0 +1,8 @@
+#ifndef _XT_CLASSIFY_H
+#define _XT_CLASSIFY_H
+
+struct xt_classify_target_info {
+	u_int32_t priority;
+};
+
+#endif /*_XT_CLASSIFY_H */
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt=
_MARK.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_MARK.h
@@ -0,0 +1,21 @@
+#ifndef _XT_MARK_H_target
+#define _XT_MARK_H_target
+
+/* Version 0 */
+struct xt_mark_target_info {
+	unsigned long mark;
+};
+
+/* Version 1 */
+enum {
+	XT_MARK_SET=3D0,
+	XT_MARK_AND,
+	XT_MARK_OR,
+};
+
+struct xt_mark_target_info_v1 {
+	unsigned long mark;
+	u_int8_t mode;
+};
+
+#endif /*_XT_MARK_H_target */
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter=
/xt_NFQUEUE.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -0,0 +1,16 @@
+/* iptables module for using NFQUEUE mechanism
+ *
+ * (C) 2005 Harald Welte <laforge@netfilter.org>
+ *
+ * This software is distributed under GNU GPL v2, 1991
+ *=20
+*/
+#ifndef _XT_NFQ_TARGET_H
+#define _XT_NFQ_TARGET_H
+
+/* target info */
+struct xt_NFQ_info {
+	u_int16_t queuenum;
+};
+
+#endif /* _XT_NFQ_TARGET_H */
diff --git a/include/linux/netfilter/xt_comment.h b/include/linux/netfilter=
/xt_comment.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_comment.h
@@ -0,0 +1,10 @@
+#ifndef _XT_COMMENT_H
+#define _XT_COMMENT_H
+
+#define XT_MAX_COMMENT_LEN 256
+
+struct xt_comment_info {
+	unsigned char comment[XT_MAX_COMMENT_LEN];
+};
+
+#endif /* XT_COMMENT_H */
diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfilter/=
xt_length.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_length.h
@@ -0,0 +1,9 @@
+#ifndef _XT_LENGTH_H
+#define _XT_LENGTH_H
+
+struct xt_length_info {
+    u_int16_t	min, max;
+    u_int8_t	invert;
+};
+
+#endif /*_XT_LENGTH_H*/
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/x=
t_limit.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_limit.h
@@ -0,0 +1,21 @@
+#ifndef _XT_RATE_H
+#define _XT_RATE_H
+
+/* timings are in milliseconds. */
+#define XT_LIMIT_SCALE 10000
+
+/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 429490
+   seconds, or one every 59 hours. */
+struct xt_rateinfo {
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+
+	/* Used internally by the kernel */
+	unsigned long prev;
+	u_int32_t credit;
+	u_int32_t credit_cap, cost;
+
+	/* Ugly, ugly fucker. */
+	struct xt_rateinfo *master;
+};
+#endif /*_XT_RATE_H*/
diff --git a/include/linux/netfilter/xt_mac.h b/include/linux/netfilter/xt_=
mac.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_mac.h
@@ -0,0 +1,8 @@
+#ifndef _XT_MAC_H
+#define _XT_MAC_H
+
+struct xt_mac_info {
+    unsigned char srcaddr[ETH_ALEN];
+    int invert;
+};
+#endif /*_XT_MAC_H*/
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt=
_mark.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_mark.h
@@ -0,0 +1,9 @@
+#ifndef _XT_MARK_H
+#define _XT_MARK_H
+
+struct xt_mark_info {
+    unsigned long mark, mask;
+    u_int8_t invert;
+};
+
+#endif /*_XT_MARK_H*/
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/x=
t_owner.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_owner.h
@@ -0,0 +1,20 @@
+#ifndef _XT_OWNER_H
+#define _XT_OWNER_H
+
+/* match and invert flags */
+#define XT_OWNER_UID	0x01
+#define XT_OWNER_GID	0x02
+#define XT_OWNER_PID	0x04
+#define XT_OWNER_SID	0x08
+#define XT_OWNER_COMM	0x10
+
+struct xt_owner_info {
+    uid_t uid;
+    gid_t gid;
+    pid_t pid;
+    pid_t sid;
+    char comm[16];
+    u_int8_t match, invert;	/* flags */
+};
+
+#endif /*_XT_OWNER_H*/
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter=
/xt_physdev.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_physdev.h
@@ -0,0 +1,24 @@
+#ifndef _XT_PHYSDEV_H
+#define _XT_PHYSDEV_H
+
+#ifdef __KERNEL__
+#include <linux/if.h>
+#endif
+
+#define XT_PHYSDEV_OP_IN		0x01
+#define XT_PHYSDEV_OP_OUT		0x02
+#define XT_PHYSDEV_OP_BRIDGED		0x04
+#define XT_PHYSDEV_OP_ISIN		0x08
+#define XT_PHYSDEV_OP_ISOUT		0x10
+#define XT_PHYSDEV_OP_MASK		(0x20 - 1)
+
+struct xt_physdev_info {
+	char physindev[IFNAMSIZ];
+	char in_mask[IFNAMSIZ];
+	char physoutdev[IFNAMSIZ];
+	char out_mask[IFNAMSIZ];
+	u_int8_t invert;
+	u_int8_t bitmask;
+};
+
+#endif /*_XT_PHYSDEV_H*/
diff --git a/include/linux/netfilter/xt_pkttype.h b/include/linux/netfilter=
/xt_pkttype.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_pkttype.h
@@ -0,0 +1,8 @@
+#ifndef _XT_PKTTYPE_H
+#define _XT_PKTTYPE_H
+
+struct xt_pkttype_info {
+	int	pkttype;
+	int	invert;
+};
+#endif /*_XT_PKTTYPE_H*/
diff --git a/include/linux/netfilter/xt_realm.h b/include/linux/netfilter/x=
t_realm.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_realm.h
@@ -0,0 +1,10 @@
+#ifndef _XT_REALM_H
+#define _XT_REALM_H
+
+struct xt_realm_info {
+	u_int32_t id;
+	u_int32_t mask;
+	u_int8_t invert;
+};
+
+#endif /* _XT_REALM_H */
diff --git a/include/linux/netfilter/xt_state.h b/include/linux/netfilter/x=
t_state.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_state.h
@@ -0,0 +1,13 @@
+#ifndef _XT_STATE_H
+#define _XT_STATE_H
+
+#define XT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
+#define XT_STATE_INVALID (1 << 0)
+
+#define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+
+struct xt_state_info
+{
+	unsigned int statemask;
+};
+#endif /*_XT_STATE_H*/
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/=
xt_string.h
new file mode 100644
--- /dev/null
+++ b/include/linux/netfilter/xt_string.h
@@ -0,0 +1,18 @@
+#ifndef _XT_STRING_H
+#define _XT_STRING_H
+
+#define XT_STRING_MAX_PATTERN_SIZE 128
+#define XT_STRING_MAX_ALGO_NAME_SIZE 16
+
+struct xt_string_info
+{
+	u_int16_t from_offset;
+	u_int16_t to_offset;
+	char	  algo[XT_STRING_MAX_ALGO_NAME_SIZE];
+	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
+	u_int8_t  patlen;
+	u_int8_t  invert;
+	struct ts_config __attribute__((aligned(8))) *config;
+};
+
+#endif /*_XT_STRING_H*/
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfi=
lter_arp/arp_tables.h
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -19,8 +19,12 @@
 #include <linux/compiler.h>
 #include <linux/netfilter_arp.h>
=20
-#define ARPT_FUNCTION_MAXNAMELEN 30
-#define ARPT_TABLE_MAXNAMELEN 32
+#include <linux/netfilter/x_tables.h>
+
+#define ARPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define ARPT_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
+#define arpt_target xt_target
+#define arpt_table xt_table
=20
 #define ARPT_DEV_ADDR_LEN_MAX 16
=20
@@ -141,23 +145,24 @@ struct arpt_entry
  * Unlike BSD Linux inherits IP options so you don't have to use a raw
  * socket for this. Instead we check rights in the calls.
  */
-#define ARPT_BASE_CTL		96	/* base for firewall socket options */
+#define ARPT_CTL_OFFSET		32
+#define ARPT_BASE_CTL		(XT_BASE_CTL+ARPT_CTL_OFFSET)
=20
-#define ARPT_SO_SET_REPLACE		(ARPT_BASE_CTL)
-#define ARPT_SO_SET_ADD_COUNTERS	(ARPT_BASE_CTL + 1)
-#define ARPT_SO_SET_MAX			ARPT_SO_SET_ADD_COUNTERS
-
-#define ARPT_SO_GET_INFO		(ARPT_BASE_CTL)
-#define ARPT_SO_GET_ENTRIES		(ARPT_BASE_CTL + 1)
-/* #define ARPT_SO_GET_REVISION_MATCH	(ARPT_BASE_CTL + 2)*/
-#define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
-#define ARPT_SO_GET_MAX			ARPT_SO_GET_REVISION_TARGET
+#define ARPT_SO_SET_REPLACE		(XT_SO_SET_REPLACE+ARPT_CTL_OFFSET)
+#define ARPT_SO_SET_ADD_COUNTERS	(XT_SO_SET_ADD_COUNTERS+ARPT_CTL_OFFSET)
+#define ARPT_SO_SET_MAX			(XT_SO_SET_MAX+ARPT_CTL_OFFSET)
+
+#define ARPT_SO_GET_INFO		(XT_SO_GET_INFO+ARPT_CTL_OFFSET)
+#define ARPT_SO_GET_ENTRIES		(XT_SO_GET_ENTRIES+ARPT_CTL_OFFSET)
+/* #define ARPT_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH  */
+#define ARPT_SO_GET_REVISION_TARGET	(XT_SO_GET_REVISION_TARGET+ARPT_CTL_OF=
FSET)
+#define ARPT_SO_GET_MAX			(XT_SO_GET_REVISION_TARGET+ARPT_CTL_OFFSET)
=20
 /* CONTINUE verdict for targets */
-#define ARPT_CONTINUE 0xFFFFFFFF
+#define ARPT_CONTINUE XT_CONTINUE
=20
 /* For standard target */
-#define ARPT_RETURN (-NF_REPEAT - 1)
+#define ARPT_RETURN XT_RETURN
=20
 /* The argument to ARPT_SO_GET_INFO */
 struct arpt_getinfo
@@ -239,19 +244,10 @@ struct arpt_get_entries
 	struct arpt_entry entrytable[0];
 };
=20
-/* The argument to ARPT_SO_GET_REVISION_*.  Returns highest revision
- * kernel supports, if >=3D revision. */
-struct arpt_get_revision
-{
-	char name[ARPT_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-};
-
 /* Standard return verdict, or do jump. */
-#define ARPT_STANDARD_TARGET ""
+#define ARPT_STANDARD_TARGET XT_STANDARD_TARGET
 /* Error verdict. */
-#define ARPT_ERROR_TARGET "ERROR"
+#define ARPT_ERROR_TARGET XT_ERROR_TARGET
=20
 /* Helper functions */
 static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_en=
try *e)
@@ -281,63 +277,8 @@ static __inline__ struct arpt_entry_targ
  */
 #ifdef __KERNEL__
=20
-/* Registration hooks for targets. */
-struct arpt_target
-{
-	struct list_head list;
-
-	const char name[ARPT_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-
-	/* Returns verdict. */
-	unsigned int (*target)(struct sk_buff **pskb,
-			       unsigned int hooknum,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       const void *targinfo,
-			       void *userdata);
-
-	/* Called when user tries to insert an entry of this type:
-           hook_mask is a bitmask of hooks from which it can be
-           called. */
-	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const struct arpt_entry *e,
-			  void *targinfo,
-			  unsigned int targinfosize,
-			  unsigned int hook_mask);
-
-	/* Called when entry of this type deleted. */
-	void (*destroy)(void *targinfo, unsigned int targinfosize);
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
-
-extern int arpt_register_target(struct arpt_target *target);
-extern void arpt_unregister_target(struct arpt_target *target);
-
-/* Furniture shopping... */
-struct arpt_table
-{
-	struct list_head list;
-
-	/* A unique name... */
-	char name[ARPT_TABLE_MAXNAMELEN];
-
-	/* What hooks you will enter on */
-	unsigned int valid_hooks;
-
-	/* Lock for the curtain */
-	rwlock_t lock;
-
-	/* Man behind the curtain... */
-	struct arpt_table_info *private;
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
+#define arpt_register_target(tgt) xt_register_target(NF_ARP, tgt)
+#define arpt_unregister_target(tgt) xt_unregister_target(NF_ARP, tgt)
=20
 extern int arpt_register_table(struct arpt_table *table,
 			       const struct arpt_replace *repl);
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfi=
lter_ipv4/ip_tables.h
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -25,8 +25,14 @@
 #include <linux/compiler.h>
 #include <linux/netfilter_ipv4.h>
=20
-#define IPT_FUNCTION_MAXNAMELEN 30
-#define IPT_TABLE_MAXNAMELEN 32
+#include <linux/netfilter/x_tables.h>
+
+#define IPT_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define IPT_TABLE_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define ipt_match xt_match
+#define ipt_target xt_target
+#define ipt_table xt_table
+#define ipt_get_revision xt_get_revision
=20
 /* Yes, Virginia, you have to zero the padding. */
 struct ipt_ip {
@@ -151,23 +157,20 @@ struct ipt_entry
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use a raw
  * socket for this. Instead we check rights in the calls. */
-#define IPT_BASE_CTL		64	/* base for firewall socket options */
-
-#define IPT_SO_SET_REPLACE	(IPT_BASE_CTL)
-#define IPT_SO_SET_ADD_COUNTERS	(IPT_BASE_CTL + 1)
-#define IPT_SO_SET_MAX		IPT_SO_SET_ADD_COUNTERS
-
-#define IPT_SO_GET_INFO			(IPT_BASE_CTL)
-#define IPT_SO_GET_ENTRIES		(IPT_BASE_CTL + 1)
-#define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
-#define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
-#define IPT_SO_GET_MAX			IPT_SO_GET_REVISION_TARGET
+#define IPT_BASE_CTL		XT_BASE_CTL
=20
-/* CONTINUE verdict for targets */
-#define IPT_CONTINUE 0xFFFFFFFF
+#define IPT_SO_SET_REPLACE	XT_SO_SET_REPLACE
+#define IPT_SO_SET_ADD_COUNTERS	XT_SO_SET_ADD_COUNTERS
+#define IPT_SO_SET_MAX		XT_SO_SET_MAX
+
+#define IPT_SO_GET_INFO			XT_SO_GET_INFO
+#define IPT_SO_GET_ENTRIES		XT_SO_GET_ENTRIES
+#define IPT_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH
+#define IPT_SO_GET_REVISION_TARGET	XT_SO_GET_REVISION_TARGET
+#define IPT_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
=20
-/* For standard target */
-#define IPT_RETURN (-NF_REPEAT - 1)
+#define IPT_CONTINUE XT_CONTINUE
+#define IPT_RETURN XT_RETURN
=20
 /* TCP matching stuff */
 struct ipt_tcp
@@ -291,19 +294,10 @@ struct ipt_get_entries
 	struct ipt_entry entrytable[0];
 };
=20
-/* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
- * kernel supports, if >=3D revision. */
-struct ipt_get_revision
-{
-	char name[IPT_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-};
-
 /* Standard return verdict, or do jump. */
-#define IPT_STANDARD_TARGET ""
+#define IPT_STANDARD_TARGET XT_STANDARD_TARGET
 /* Error verdict. */
-#define IPT_ERROR_TARGET "ERROR"
+#define IPT_ERROR_TARGET XT_ERROR_TARGET
=20
 /* Helper functions */
 static __inline__ struct ipt_entry_target *
@@ -356,103 +350,18 @@ ipt_get_target(struct ipt_entry *e)
 #include <linux/init.h>
 extern void ipt_init(void) __init;
=20
-struct ipt_match
-{
-	struct list_head list;
-
-	const char name[IPT_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-
-	/* Return true or false: return FALSE and set *hotdrop =3D 1 to
-           force immediate packet drop. */
-	/* Arguments changed since 2.4, as this must now handle
-           non-linear skbs, using skb_copy_bits and
-           skb_ip_make_writable. */
-	int (*match)(const struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     const void *matchinfo,
-		     int offset,
-		     int *hotdrop);
-
-	/* Called when user tries to insert an entry of this type. */
-	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const struct ipt_ip *ip,
-			  void *matchinfo,
-			  unsigned int matchinfosize,
-			  unsigned int hook_mask);
-
-	/* Called when entry of this type deleted. */
-	void (*destroy)(void *matchinfo, unsigned int matchinfosize);
-
-	/* Set this to THIS_MODULE. */
-	struct module *me;
-};
-
-/* Registration hooks for targets. */
-struct ipt_target
-{
-	struct list_head list;
-
-	const char name[IPT_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-
-	/* Called when user tries to insert an entry of this type:
-           hook_mask is a bitmask of hooks from which it can be
-           called. */
-	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const struct ipt_entry *e,
-			  void *targinfo,
-			  unsigned int targinfosize,
-			  unsigned int hook_mask);
+#define ipt_register_target(tgt) xt_register_target(AF_INET, tgt)
+#define ipt_unregister_target(tgt) xt_unregister_target(AF_INET, tgt)
=20
-	/* Called when entry of this type deleted. */
-	void (*destroy)(void *targinfo, unsigned int targinfosize);
+#define ipt_register_match(mtch) xt_register_match(AF_INET, mtch)
+#define ipt_unregister_match(mtch) xt_unregister_match(AF_INET, mtch)
=20
-	/* Returns verdict.  Argument order changed since 2.4, as this
-           must now handle non-linear skbs, using skb_copy_bits and
-           skb_ip_make_writable. */
-	unsigned int (*target)(struct sk_buff **pskb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       unsigned int hooknum,
-			       const void *targinfo,
-			       void *userdata);
+//#define ipt_register_table(tbl, repl) xt_register_table(AF_INET, tbl, re=
pl)
+//#define ipt_unregister_table(tbl) xt_unregister_table(AF_INET, tbl)
=20
-	/* Set this to THIS_MODULE. */
-	struct module *me;
-};
-
-extern int ipt_register_target(struct ipt_target *target);
-extern void ipt_unregister_target(struct ipt_target *target);
-
-extern int ipt_register_match(struct ipt_match *match);
-extern void ipt_unregister_match(struct ipt_match *match);
-
-/* Furniture shopping... */
-struct ipt_table
-{
-	struct list_head list;
-
-	/* A unique name... */
-	char name[IPT_TABLE_MAXNAMELEN];
-
-	/* What hooks you will enter on */
-	unsigned int valid_hooks;
-
-	/* Lock for the curtain */
-	rwlock_t lock;
-
-	/* Man behind the curtain... */
-	struct ipt_table_info *private;
-
-	/* Set to THIS_MODULE. */
-	struct module *me;
-};
+extern int ipt_register_table(struct ipt_table *table,
+			      const struct ipt_replace *repl);
+extern void ipt_unregister_table(struct ipt_table *table);
=20
 /* net/sched/ipt.c: Gimme access to your targets!  Gets target->me. */
 extern struct ipt_target *ipt_find_target(const char *name, u8 revision);
@@ -476,9 +385,6 @@ struct ipt_error
 	struct ipt_error_target target;
 };
=20
-extern int ipt_register_table(struct ipt_table *table,
-			      const struct ipt_replace *repl);
-extern void ipt_unregister_table(struct ipt_table *table);
 extern unsigned int ipt_do_table(struct sk_buff **pskb,
 				 unsigned int hook,
 				 const struct net_device *in,
@@ -486,6 +392,6 @@ extern unsigned int ipt_do_table(struct=20
 				 struct ipt_table *table,
 				 void *userdata);
=20
-#define IPT_ALIGN(s) (((s) + (__alignof__(struct ipt_entry)-1)) & ~(__alig=
nof__(struct ipt_entry)-1))
+#define IPT_ALIGN(s) XT_ALIGN(s)
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv4/ipt_CLASSIFY.h b/include/linux/ne=
tfilter_ipv4/ipt_CLASSIFY.h
--- a/include/linux/netfilter_ipv4/ipt_CLASSIFY.h
+++ b/include/linux/netfilter_ipv4/ipt_CLASSIFY.h
@@ -1,8 +1,6 @@
 #ifndef _IPT_CLASSIFY_H
 #define _IPT_CLASSIFY_H
=20
-struct ipt_classify_target_info {
-	u_int32_t priority;
-};
+#define ipt_classify_target_info xt_classify_target_info
=20
 #endif /*_IPT_CLASSIFY_H */
diff --git a/include/linux/netfilter_ipv4/ipt_MARK.h b/include/linux/netfil=
ter_ipv4/ipt_MARK.h
--- a/include/linux/netfilter_ipv4/ipt_MARK.h
+++ b/include/linux/netfilter_ipv4/ipt_MARK.h
@@ -1,20 +1,18 @@
 #ifndef _IPT_MARK_H_target
 #define _IPT_MARK_H_target
=20
+/* Backwards compatibility for old userspace */
+
+#include <linux/netfilter/xt_MARK.h>
+
 /* Version 0 */
-struct ipt_mark_target_info {
-	unsigned long mark;
-};
+#define ipt_mark_target_info xt_mark_target_info
=20
 /* Version 1 */
-enum {
-	IPT_MARK_SET=3D0,
-	IPT_MARK_AND,
-	IPT_MARK_OR
-};
-
-struct ipt_mark_target_info_v1 {
-	unsigned long mark;
-	u_int8_t mode;
-};
+#define IPT_MARK_SET	XT_MARK_SET
+#define IPT_MARK_AND	XT_MARK_AND
+#define	IPT_MARK_OR	XT_MARK_OR
+
+#define ipt_mark_target_info_v1 xt_mark_target_info_v1
+
 #endif /*_IPT_MARK_H_target*/
diff --git a/include/linux/netfilter_ipv4/ipt_NFQUEUE.h b/include/linux/net=
filter_ipv4/ipt_NFQUEUE.h
--- a/include/linux/netfilter_ipv4/ipt_NFQUEUE.h
+++ b/include/linux/netfilter_ipv4/ipt_NFQUEUE.h
@@ -8,9 +8,9 @@
 #ifndef _IPT_NFQ_TARGET_H
 #define _IPT_NFQ_TARGET_H
=20
-/* target info */
-struct ipt_NFQ_info {
-	u_int16_t queuenum;
-};
+/* Backwards compatibility for old userspace */
+#include <linux/netfilter/xt_NFQUEUE.h>
+
+#define ipt_NFQ_info xt_NFQ_info
=20
 #endif /* _IPT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter_ipv4/ipt_comment.h b/include/linux/net=
filter_ipv4/ipt_comment.h
--- a/include/linux/netfilter_ipv4/ipt_comment.h
+++ b/include/linux/netfilter_ipv4/ipt_comment.h
@@ -1,10 +1,10 @@
 #ifndef _IPT_COMMENT_H
 #define _IPT_COMMENT_H
=20
-#define IPT_MAX_COMMENT_LEN 256
+#include <linux/netfilter/xt_comment.h>
=20
-struct ipt_comment_info {
-	unsigned char comment[IPT_MAX_COMMENT_LEN];
-};
+#define IPT_MAX_COMMENT_LEN XT_MAX_COMMENT_LEN
+
+#define ipt_comment_info xt_comment_info
=20
 #endif /* _IPT_COMMENT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_length.h b/include/linux/netf=
ilter_ipv4/ipt_length.h
--- a/include/linux/netfilter_ipv4/ipt_length.h
+++ b/include/linux/netfilter_ipv4/ipt_length.h
@@ -1,9 +1,7 @@
 #ifndef _IPT_LENGTH_H
 #define _IPT_LENGTH_H
=20
-struct ipt_length_info {
-    u_int16_t	min, max;
-    u_int8_t	invert;
-};
+#include <linux/netfilter/xt_length.h>
+#define ipt_length_info xt_length_info
=20
 #endif /*_IPT_LENGTH_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_limit.h b/include/linux/netfi=
lter_ipv4/ipt_limit.h
--- a/include/linux/netfilter_ipv4/ipt_limit.h
+++ b/include/linux/netfilter_ipv4/ipt_limit.h
@@ -1,21 +1,8 @@
 #ifndef _IPT_RATE_H
 #define _IPT_RATE_H
=20
-/* timings are in milliseconds. */
-#define IPT_LIMIT_SCALE 10000
+#include <linux/netfilter/xt_limit.h>
+#define IPT_LIMIT_SCALE XT_LIMIT_SCALE
+#define ipt_rateinfo xt_rateinfo
=20
-/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 429490
-   seconds, or one every 59 hours. */
-struct ipt_rateinfo {
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
-
-	/* Used internally by the kernel */
-	unsigned long prev;
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
-
-	/* Ugly, ugly fucker. */
-	struct ipt_rateinfo *master;
-};
 #endif /*_IPT_RATE_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_mac.h b/include/linux/netfilt=
er_ipv4/ipt_mac.h
--- a/include/linux/netfilter_ipv4/ipt_mac.h
+++ b/include/linux/netfilter_ipv4/ipt_mac.h
@@ -1,8 +1,7 @@
 #ifndef _IPT_MAC_H
 #define _IPT_MAC_H
=20
-struct ipt_mac_info {
-    unsigned char srcaddr[ETH_ALEN];
-    int invert;
-};
+#include <linux/netfilter/xt_mac.h>
+#define ipt_mac_info xt_mac_info
+
 #endif /*_IPT_MAC_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_mark.h b/include/linux/netfil=
ter_ipv4/ipt_mark.h
--- a/include/linux/netfilter_ipv4/ipt_mark.h
+++ b/include/linux/netfilter_ipv4/ipt_mark.h
@@ -1,9 +1,9 @@
 #ifndef _IPT_MARK_H
 #define _IPT_MARK_H
=20
-struct ipt_mark_info {
-    unsigned long mark, mask;
-    u_int8_t invert;
-};
+/* Backwards compatibility for old userspace */
+#include <linux/netfilter/xt_mark.h>
+
+#define ipt_mark_info xt_mark_info
=20
 #endif /*_IPT_MARK_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_owner.h b/include/linux/netfi=
lter_ipv4/ipt_owner.h
--- a/include/linux/netfilter_ipv4/ipt_owner.h
+++ b/include/linux/netfilter_ipv4/ipt_owner.h
@@ -1,20 +1,15 @@
 #ifndef _IPT_OWNER_H
 #define _IPT_OWNER_H
=20
-/* match and invert flags */
-#define IPT_OWNER_UID	0x01
-#define IPT_OWNER_GID	0x02
-#define IPT_OWNER_PID	0x04
-#define IPT_OWNER_SID	0x08
-#define IPT_OWNER_COMM	0x10
+/* Backwards compatibility for old userspace */
+#include <linux/netfilter/xt_owner.h>
=20
-struct ipt_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
-    char comm[16];
-    u_int8_t match, invert;	/* flags */
-};
+#define IPT_OWNER_UID	XT_OWNER_UID
+#define IPT_OWNER_GID	XT_OWNER_GID
+#define IPT_OWNER_PID	XT_OWNER_PID
+#define IPT_OWNER_SID	XT_OWNER_SID
+#define IPT_OWNER_COMM	XT_OWNER_COMM
+
+#define ipt_owner_info xt_owner_info
=20
 #endif /*_IPT_OWNER_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_physdev.h b/include/linux/net=
filter_ipv4/ipt_physdev.h
--- a/include/linux/netfilter_ipv4/ipt_physdev.h
+++ b/include/linux/netfilter_ipv4/ipt_physdev.h
@@ -1,24 +1,17 @@
 #ifndef _IPT_PHYSDEV_H
 #define _IPT_PHYSDEV_H
=20
-#ifdef __KERNEL__
-#include <linux/if.h>
-#endif
+/* Backwards compatibility for old userspace */
=20
-#define IPT_PHYSDEV_OP_IN		0x01
-#define IPT_PHYSDEV_OP_OUT		0x02
-#define IPT_PHYSDEV_OP_BRIDGED		0x04
-#define IPT_PHYSDEV_OP_ISIN		0x08
-#define IPT_PHYSDEV_OP_ISOUT		0x10
-#define IPT_PHYSDEV_OP_MASK		(0x20 - 1)
+#include <linux/netfilter/xt_physdev.h>
=20
-struct ipt_physdev_info {
-	char physindev[IFNAMSIZ];
-	char in_mask[IFNAMSIZ];
-	char physoutdev[IFNAMSIZ];
-	char out_mask[IFNAMSIZ];
-	u_int8_t invert;
-	u_int8_t bitmask;
-};
+#define IPT_PHYSDEV_OP_IN		XT_PHYSDEV_OP_IN
+#define IPT_PHYSDEV_OP_OUT		XT_PHYSDEV_OP_OUT
+#define IPT_PHYSDEV_OP_BRIDGED		XT_PHYSDEV_OP_BRIDGED
+#define IPT_PHYSDEV_OP_ISIN		XT_PHYSDEV_OP_ISIN
+#define IPT_PHYSDEV_OP_ISOUT		XT_PHYSDEV_OP_ISOUT
+#define IPT_PHYSDEV_OP_MASK		XT_PHYSDEV_OP_MASK
+
+#define ipt_physdev_info xt_physdev_info
=20
 #endif /*_IPT_PHYSDEV_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_pkttype.h b/include/linux/net=
filter_ipv4/ipt_pkttype.h
--- a/include/linux/netfilter_ipv4/ipt_pkttype.h
+++ b/include/linux/netfilter_ipv4/ipt_pkttype.h
@@ -1,8 +1,7 @@
 #ifndef _IPT_PKTTYPE_H
 #define _IPT_PKTTYPE_H
=20
-struct ipt_pkttype_info {
-	int	pkttype;
-	int	invert;
-};
+#include <linux/netfilter/xt_pkttype.h>
+#define ipt_pkttype_info xt_pkttype_info
+
 #endif /*_IPT_PKTTYPE_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_realm.h b/include/linux/netfi=
lter_ipv4/ipt_realm.h
--- a/include/linux/netfilter_ipv4/ipt_realm.h
+++ b/include/linux/netfilter_ipv4/ipt_realm.h
@@ -1,10 +1,7 @@
 #ifndef _IPT_REALM_H
 #define _IPT_REALM_H
=20
-struct ipt_realm_info {
-	u_int32_t id;
-	u_int32_t mask;
-	u_int8_t invert;
-};
+#include <linux/netfilter/xt_realm.h>
+#define ipt_realm_info xt_realm_info
=20
 #endif /* _IPT_REALM_H */
diff --git a/include/linux/netfilter_ipv4/ipt_state.h b/include/linux/netfi=
lter_ipv4/ipt_state.h
--- a/include/linux/netfilter_ipv4/ipt_state.h
+++ b/include/linux/netfilter_ipv4/ipt_state.h
@@ -1,13 +1,15 @@
 #ifndef _IPT_STATE_H
 #define _IPT_STATE_H
=20
-#define IPT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
-#define IPT_STATE_INVALID (1 << 0)
+/* Backwards compatibility for old userspace */
=20
-#define IPT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+#include <linux/netfilter/xt_state.h>
+
+#define IPT_STATE_BIT		XT_STATE_BIT
+#define IPT_STATE_INVALID	XT_STATE_INVALID
+
+#define IPT_STATE_UNTRACKED	XT_STATE_UNTRACKED
+
+#define ipt_state_info		xt_state_info
=20
-struct ipt_state_info
-{
-	unsigned int statemask;
-};
 #endif /*_IPT_STATE_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_string.h b/include/linux/netf=
ilter_ipv4/ipt_string.h
--- a/include/linux/netfilter_ipv4/ipt_string.h
+++ b/include/linux/netfilter_ipv4/ipt_string.h
@@ -1,18 +1,10 @@
 #ifndef _IPT_STRING_H
 #define _IPT_STRING_H
=20
-#define IPT_STRING_MAX_PATTERN_SIZE 128
-#define IPT_STRING_MAX_ALGO_NAME_SIZE 16
+#include <linux/netfilter/xt_string.h>
=20
-struct ipt_string_info
-{
-	u_int16_t from_offset;
-	u_int16_t to_offset;
-	char	  algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
-	char 	  pattern[IPT_STRING_MAX_PATTERN_SIZE];
-	u_int8_t  patlen;
-	u_int8_t  invert;
-	struct ts_config __attribute__((aligned(8))) *config;
-};
+#define IPT_STRING_MAX_PATTERN_SIZE XT_STRING_MAX_PATTERN_SIZE
+#define IPT_STRING_MAX_ALGO_NAME_SIZE XT_STRING_MAX_ALGO_NAME_SIZE
+#define ipt_string_info xt_string_info
=20
 #endif /*_IPT_STRING_H*/
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netf=
ilter_ipv6/ip6_tables.h
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -25,8 +25,15 @@
 #include <linux/compiler.h>
 #include <linux/netfilter_ipv6.h>
=20
-#define IP6T_FUNCTION_MAXNAMELEN 30
-#define IP6T_TABLE_MAXNAMELEN 32
+#include <linux/netfilter/x_tables.h>
+
+#define IP6T_FUNCTION_MAXNAMELEN XT_FUNCTION_MAXNAMELEN
+#define IP6T_TABLE_MAXNAMELEN XT_TABLE_MAXNAMELEN
+
+#define ip6t_match xt_match
+#define ip6t_target xt_target
+#define ip6t_table xt_table
+#define ip6t_get_revision xt_get_revision
=20
 /* Yes, Virginia, you have to zero the padding. */
 struct ip6t_ip6 {
@@ -155,23 +162,23 @@ struct ip6t_entry
  * New IP firewall options for [gs]etsockopt at the RAW IP level.
  * Unlike BSD Linux inherits IP options so you don't have to use
  * a raw socket for this. Instead we check rights in the calls. */
-#define IP6T_BASE_CTL			64	/* base for firewall socket options */
+#define IP6T_BASE_CTL			XT_BASE_CTL
=20
-#define IP6T_SO_SET_REPLACE		(IP6T_BASE_CTL)
-#define IP6T_SO_SET_ADD_COUNTERS	(IP6T_BASE_CTL + 1)
-#define IP6T_SO_SET_MAX			IP6T_SO_SET_ADD_COUNTERS
-
-#define IP6T_SO_GET_INFO		(IP6T_BASE_CTL)
-#define IP6T_SO_GET_ENTRIES		(IP6T_BASE_CTL + 1)
-#define	IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 2)
-#define	IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 3)
-#define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
+#define IP6T_SO_SET_REPLACE		XT_SO_SET_REPLACE
+#define IP6T_SO_SET_ADD_COUNTERS	XT_SO_SET_ADD_COUNTERS
+#define IP6T_SO_SET_MAX			XT_SO_SET_MAX
+
+#define IP6T_SO_GET_INFO		XT_SO_GET_INFO
+#define IP6T_SO_GET_ENTRIES		XT_SO_GET_ENTRIES
+#define	IP6T_SO_GET_REVISION_MATCH	XT_SO_GET_REVISION_MATCH
+#define	IP6T_SO_GET_REVISION_TARGET	XT_SO_GET_REVISION_TARGET
+#define IP6T_SO_GET_MAX			XT_SO_GET_REVISION_TARGET
=20
 /* CONTINUE verdict for targets */
-#define IP6T_CONTINUE 0xFFFFFFFF
+#define IP6T_CONTINUE XT_CONTINUE
=20
 /* For standard target */
-#define IP6T_RETURN (-NF_REPEAT - 1)
+#define IP6T_RETURN XT_RETURN
=20
 /* TCP matching stuff */
 struct ip6t_tcp
@@ -295,15 +302,6 @@ struct ip6t_get_entries
 	struct ip6t_entry entrytable[0];
 };
=20
-/* The argument to IP6T_SO_GET_REVISION_*.  Returns highest revision
- * kernel supports, if >=3D revision. */
-struct ip6t_get_revision
-{
-	char name[IP6T_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-};
-
 /* Standard return verdict, or do jump. */
 #define IP6T_STANDARD_TARGET ""
 /* Error verdict. */
@@ -361,104 +359,11 @@ ip6t_get_target(struct ip6t_entry *e)
 #include <linux/init.h>
 extern void ip6t_init(void) __init;
=20
-struct ip6t_match
-{
-	struct list_head list;
-
-	const char name[IP6T_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-
-	/* Return true or false: return FALSE and set *hotdrop =3D 1 to
-           force immediate packet drop. */
-	/* Arguments changed since 2.6.9, as this must now handle
-	   non-linear skb, using skb_header_pointer and
-	   skb_ip_make_writable. */
-	int (*match)(const struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     const void *matchinfo,
-		     int offset,
-		     unsigned int protoff,
-		     int *hotdrop);
-
-	/* Called when user tries to insert an entry of this type. */
-	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const struct ip6t_ip6 *ip,
-			  void *matchinfo,
-			  unsigned int matchinfosize,
-			  unsigned int hook_mask);
-
-	/* Called when entry of this type deleted. */
-	void (*destroy)(void *matchinfo, unsigned int matchinfosize);
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
-
-/* Registration hooks for targets. */
-struct ip6t_target
-{
-	struct list_head list;
-
-	const char name[IP6T_FUNCTION_MAXNAMELEN-1];
+#define ip6t_register_target(tgt) xt_register_target(AF_INET6, tgt)
+#define ip6t_unregister_target(tgt) xt_unregister_target(AF_INET6, tgt)
=20
-	u_int8_t revision;
-
-	/* Returns verdict. Argument order changed since 2.6.9, as this
-	   must now handle non-linear skbs, using skb_copy_bits and
-	   skb_ip_make_writable. */
-	unsigned int (*target)(struct sk_buff **pskb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       unsigned int hooknum,
-			       const void *targinfo,
-			       void *userdata);
-
-	/* Called when user tries to insert an entry of this type:
-           hook_mask is a bitmask of hooks from which it can be
-           called. */
-	/* Should return true or false. */
-	int (*checkentry)(const char *tablename,
-			  const struct ip6t_entry *e,
-			  void *targinfo,
-			  unsigned int targinfosize,
-			  unsigned int hook_mask);
-
-	/* Called when entry of this type deleted. */
-	void (*destroy)(void *targinfo, unsigned int targinfosize);
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
-
-extern int ip6t_register_target(struct ip6t_target *target);
-extern void ip6t_unregister_target(struct ip6t_target *target);
-
-extern int ip6t_register_match(struct ip6t_match *match);
-extern void ip6t_unregister_match(struct ip6t_match *match);
-
-/* Furniture shopping... */
-struct ip6t_table
-{
-	struct list_head list;
-
-	/* A unique name... */
-	char name[IP6T_TABLE_MAXNAMELEN];
-
-	/* What hooks you will enter on */
-	unsigned int valid_hooks;
-
-	/* Lock for the curtain */
-	rwlock_t lock;
-
-	/* Man behind the curtain... */
-	struct ip6t_table_info *private;
-
-	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
-	struct module *me;
-};
+#define ip6t_register_match(match) xt_register_match(AF_INET6, match)
+#define ip6t_unregister_match(match) xt_unregister_match(AF_INET6, match)
=20
 extern int ip6t_register_table(struct ip6t_table *table,
 			       const struct ip6t_replace *repl);
diff --git a/include/linux/netfilter_ipv6/ip6t_MARK.h b/include/linux/netfi=
lter_ipv6/ip6t_MARK.h
--- a/include/linux/netfilter_ipv6/ip6t_MARK.h
+++ b/include/linux/netfilter_ipv6/ip6t_MARK.h
@@ -1,8 +1,9 @@
 #ifndef _IP6T_MARK_H_target
 #define _IP6T_MARK_H_target
=20
-struct ip6t_mark_target_info {
-	unsigned long mark;
-};
+/* Backwards compatibility for old userspace */
+#include <linux/netfilter/xt_MARK.h>
=20
-#endif /*_IPT_MARK_H_target*/
+#define ip6t_mark_target_info xt_mark_target_info
+
+#endif /*_IP6T_MARK_H_target*/
diff --git a/include/linux/netfilter_ipv6/ip6t_length.h b/include/linux/net=
filter_ipv6/ip6t_length.h
--- a/include/linux/netfilter_ipv6/ip6t_length.h
+++ b/include/linux/netfilter_ipv6/ip6t_length.h
@@ -1,10 +1,8 @@
 #ifndef _IP6T_LENGTH_H
 #define _IP6T_LENGTH_H
=20
-struct ip6t_length_info {
-	u_int16_t  min, max;
-	u_int8_t   invert;
-};
+#include <linux/netfilter/xt_length.h>
+#define ip6t_length_info xt_length_info
=20
 #endif /*_IP6T_LENGTH_H*/
 =09
diff --git a/include/linux/netfilter_ipv6/ip6t_limit.h b/include/linux/netf=
ilter_ipv6/ip6t_limit.h
--- a/include/linux/netfilter_ipv6/ip6t_limit.h
+++ b/include/linux/netfilter_ipv6/ip6t_limit.h
@@ -1,21 +1,8 @@
 #ifndef _IP6T_RATE_H
 #define _IP6T_RATE_H
=20
-/* timings are in milliseconds. */
-#define IP6T_LIMIT_SCALE 10000
+#include <linux/netfilter/xt_limit.h>
+#define IP6T_LIMIT_SCALE XT_LIMIT_SCALE
+#define ip6t_rateinfo xt_rateinfo
=20
-/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 429490
-   seconds, or one every 59 hours. */
-struct ip6t_rateinfo {
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
-
-	/* Used internally by the kernel */
-	unsigned long prev;
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
-
-	/* Ugly, ugly fucker. */
-	struct ip6t_rateinfo *master;
-};
-#endif /*_IPT_RATE_H*/
+#endif /*_IP6T_RATE_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_mac.h b/include/linux/netfil=
ter_ipv6/ip6t_mac.h
--- a/include/linux/netfilter_ipv6/ip6t_mac.h
+++ b/include/linux/netfilter_ipv6/ip6t_mac.h
@@ -1,8 +1,7 @@
 #ifndef _IP6T_MAC_H
 #define _IP6T_MAC_H
=20
-struct ip6t_mac_info {
-    unsigned char srcaddr[ETH_ALEN];
-    int invert;
-};
-#endif /*_IPT_MAC_H*/
+#include <linux/netfilter/xt_mac.h>
+#define ip6t_mac_info xt_mac_info
+
+#endif /*_IP6T_MAC_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_mark.h b/include/linux/netfi=
lter_ipv6/ip6t_mark.h
--- a/include/linux/netfilter_ipv6/ip6t_mark.h
+++ b/include/linux/netfilter_ipv6/ip6t_mark.h
@@ -1,9 +1,9 @@
 #ifndef _IP6T_MARK_H
 #define _IP6T_MARK_H
=20
-struct ip6t_mark_info {
-    unsigned long mark, mask;
-    u_int8_t invert;
-};
+/* Backwards compatibility for old userspace */
+#include <linux/netfilter/xt_mark.h>
+
+#define ip6t_mark_info xt_mark_info
=20
 #endif /*_IPT_MARK_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_owner.h b/include/linux/netf=
ilter_ipv6/ip6t_owner.h
--- a/include/linux/netfilter_ipv6/ip6t_owner.h
+++ b/include/linux/netfilter_ipv6/ip6t_owner.h
@@ -1,11 +1,13 @@
 #ifndef _IP6T_OWNER_H
 #define _IP6T_OWNER_H
=20
-/* match and invert flags */
-#define IP6T_OWNER_UID	0x01
-#define IP6T_OWNER_GID	0x02
-#define IP6T_OWNER_PID	0x04
-#define IP6T_OWNER_SID	0x08
+/* Backwards compatibility for old userspace */
+#include <linux/netfilter/xt_owner.h>
+
+#define IP6T_OWNER_UID	XT_OWNER_UID
+#define IP6T_OWNER_GID	XT_OWNER_GID
+#define IP6T_OWNER_PID	XT_OWNER_PID
+#define IP6T_OWNER_SID	XT_OWNER_SID
=20
 struct ip6t_owner_info {
     uid_t uid;
diff --git a/include/linux/netfilter_ipv6/ip6t_physdev.h b/include/linux/ne=
tfilter_ipv6/ip6t_physdev.h
--- a/include/linux/netfilter_ipv6/ip6t_physdev.h
+++ b/include/linux/netfilter_ipv6/ip6t_physdev.h
@@ -1,24 +1,17 @@
 #ifndef _IP6T_PHYSDEV_H
 #define _IP6T_PHYSDEV_H
=20
-#ifdef __KERNEL__
-#include <linux/if.h>
-#endif
+/* Backwards compatibility for old userspace */
=20
-#define IP6T_PHYSDEV_OP_IN		0x01
-#define IP6T_PHYSDEV_OP_OUT		0x02
-#define IP6T_PHYSDEV_OP_BRIDGED		0x04
-#define IP6T_PHYSDEV_OP_ISIN		0x08
-#define IP6T_PHYSDEV_OP_ISOUT		0x10
-#define IP6T_PHYSDEV_OP_MASK		(0x20 - 1)
+#include <linux/netfilter/xt_physdev.h>
=20
-struct ip6t_physdev_info {
-	char physindev[IFNAMSIZ];
-	char in_mask[IFNAMSIZ];
-	char physoutdev[IFNAMSIZ];
-	char out_mask[IFNAMSIZ];
-	u_int8_t invert;
-	u_int8_t bitmask;
-};
+#define IP6T_PHYSDEV_OP_IN		XT_PHYSDEV_OP_IN
+#define IP6T_PHYSDEV_OP_OUT		XT_PHYSDEV_OP_OUT
+#define IP6T_PHYSDEV_OP_BRIDGED		XT_PHYSDEV_OP_BRIDGED
+#define IP6T_PHYSDEV_OP_ISIN		XT_PHYSDEV_OP_ISIN
+#define IP6T_PHYSDEV_OP_ISOUT		XT_PHYSDEV_OP_ISOUT
+#define IP6T_PHYSDEV_OP_MASK		XT_PHYSDEV_OP_MASK
+
+#define ip6t_physdev_info xt_physdev_info
=20
 #endif /*_IP6T_PHYSDEV_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -168,6 +168,7 @@ config IP_NF_QUEUE
=20
 config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
+	depends on NETFILTER_XTABLES
 	help
 	  iptables is a general, extensible packet identification framework.
 	  The packet filtering and full NAT (masquerading, port forwarding,
@@ -178,14 +179,11 @@ config IP_NF_IPTABLES
=20
 # The matches.
 config IP_NF_MATCH_LIMIT
-	tristate "limit match support"
-	depends on IP_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_LIMIT
 	help
-	  limit matching allows you to control the rate at which a rule can be
-	  matched: mainly useful in combination with the LOG target ("LOG
-	  target support", below) and to avoid some Denial of Service attacks.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_IPRANGE
 	tristate "IP range match support"
@@ -197,35 +195,25 @@ config IP_NF_MATCH_IPRANGE
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_MATCH_MAC
-	tristate "MAC address match support"
-	depends on IP_NF_IPTABLES
+	tristate
+	select NETFILTER_XT_MATCH_MAC
+	default n
 	help
-	  MAC matching allows you to match packets based on the source
-	  Ethernet address of the packet.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_PKTTYPE
-	tristate "Packet type match support"
-	depends on IP_NF_IPTABLES
+	tristate
+	select NETFILTER_XT_MATCH_PKTTYPE
+	default n
 	help
-	  Packet type matching allows you to match a packet by
-	  its "class", eg. BROADCAST, MULTICAST, ...
-
-	  Typical usage:
-	  iptables -A INPUT -m pkttype --pkt-type broadcast -j LOG
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_MARK
-	tristate "netfilter MARK match support"
-	depends on IP_NF_IPTABLES
+	tristate
+	select NETFILTER_XT_MATCH_MARK
+	default n
 	help
-	  Netfilter mark matching allows you to match packets based on the
-	  `nfmark' value in the packet.  This can be set by the MARK target
-	  (see below).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_MULTIPORT
 	tristate "Multiple port match support"
@@ -288,13 +276,11 @@ config IP_NF_MATCH_AH_ESP
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_MATCH_LENGTH
-	tristate "LENGTH match support"
-	depends on IP_NF_IPTABLES
+	tristate
+	select NETFILTER_XT_MATCH_LENGTH
+	default n
 	help
-	  This option allows you to match the length of a packet against a
-	  specific value or range of values.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_TTL
 	tristate "TTL match support"
@@ -325,14 +311,11 @@ config IP_NF_MATCH_HELPER
 	  To compile it as a module, choose M here.  If unsure, say Y.
=20
 config IP_NF_MATCH_STATE
-	tristate "Connection state match support"
-	depends on IP_NF_CONNTRACK && IP_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_STATE
 	help
-	  Connection state matching allows you to match packets based on their
-	  relationship to a tracked connection (ie. previous packets).  This
-	  is a powerful tool for packet classification.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_CONNTRACK
 	tristate "Connection tracking match support"
@@ -356,13 +339,11 @@ config IP_NF_MATCH_OWNER
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_MATCH_PHYSDEV
-	tristate "Physdev match support"
-	depends on IP_NF_IPTABLES && BRIDGE_NETFILTER
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_PHYSDEV
 	help
-	  Physdev packet matching matches against the physical bridge ports
-	  the IP packet arrived on or will leave by.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_ADDRTYPE
 	tristate  'address type match support'
@@ -375,18 +356,11 @@ config IP_NF_MATCH_ADDRTYPE
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
 config IP_NF_MATCH_REALM
-	tristate  'realm match support'
-	depends on IP_NF_IPTABLES
-	select NET_CLS_ROUTE
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_REALM
 	help
-	  This option adds a `realm' match, which allows you to use the realm
-	  key from the routing subsystem inside iptables.
-=09
-	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option=20
-	  in tc world.
-=09
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_MATCH_SCTP
 	tristate  'SCTP protocol match support'
@@ -411,14 +385,11 @@ config IP_NF_MATCH_DCCP
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
 config IP_NF_MATCH_COMMENT
-	tristate  'comment match support'
-	depends on IP_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_COMMENT
 	help
-	  This option adds a `comment' dummy-match, which allows you to put
-	  comments in your iptables ruleset.
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+	  just for correct 'import' of old .config
=20
 config IP_NF_MATCH_CONNMARK
 	tristate  'Connection mark match support'
@@ -456,17 +427,11 @@ config IP_NF_MATCH_HASHLIMIT
 	  IPtables rule.
=20
 config IP_NF_MATCH_STRING
-	tristate  'string match support'
-	depends on IP_NF_IPTABLES=20
-	select TEXTSEARCH
-	select TEXTSEARCH_KMP
-	select TEXTSEARCH_BM
-	select TEXTSEARCH_FSM
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_STRING
 	help
-	  This option adds a `string' match, which allows you to look for
-	  pattern matchings in packets.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  just for correct 'import' of old .config
=20
 # `filter', generic and specific targets
 config IP_NF_FILTER
@@ -544,15 +509,11 @@ config IP_NF_TARGET_TCPMSS
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_TARGET_NFQUEUE
-	tristate "NFQUEUE Target Support"
-	depends on IP_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_TARGET_NFQUEUE
 	help
-	  This Target replaced the old obsolete QUEUE target.
-
-	  As opposed to QUEUE, it supports 65535 different queues,
-	  not just one.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 # NAT + specific targets
 config IP_NF_NAT
@@ -707,29 +668,18 @@ config IP_NF_TARGET_DSCP
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP_NF_TARGET_MARK
-	tristate "MARK target support"
-	depends on IP_NF_MANGLE
+	tristate
+	default n
+	select NETFILTER_XT_TARGET_MARK
 	help
-	  This option adds a `MARK' target, which allows you to create rules
-	  in the `mangle' table which alter the netfilter mark (nfmark) field
-	  associated with the packet prior to routing. This can change
-	  the routing method (see `Use netfilter MARK value as routing
-	  key') and can also be used by other subsystems to change their
-	  behavior.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_TARGET_CLASSIFY
 	tristate "CLASSIFY target support"
-	depends on IP_NF_MANGLE
+	default n
+	select NETFILTER_XT_TARGET_CLASSIFY
 	help
-	  This option adds a `CLASSIFY' target, which enables the user to set
-	  the priority of a packet. Some qdiscs can use this value for
-	  classification, among these are:
-
-  	  atm, cbq, dsmark, pfifo_fast, htb, prio
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP_NF_TARGET_TTL
 	tristate  'TTL target support'
@@ -796,6 +746,7 @@ config IP_NF_TARGET_NOTRACK
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
+	depends on NETFILTER_XTABLES
 	help
 	  arptables is a general, extensible packet identification framework.
 	  The ARP packet filtering and mangling (manipulation)subsystems
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -46,14 +46,10 @@ obj-$(CONFIG_IP_NF_RAW) +=3D iptable_raw.o
=20
 # matches
 obj-$(CONFIG_IP_NF_MATCH_HELPER) +=3D ipt_helper.o
-obj-$(CONFIG_IP_NF_MATCH_LIMIT) +=3D ipt_limit.o
 obj-$(CONFIG_IP_NF_MATCH_HASHLIMIT) +=3D ipt_hashlimit.o
 obj-$(CONFIG_IP_NF_MATCH_SCTP) +=3D ipt_sctp.o
 obj-$(CONFIG_IP_NF_MATCH_DCCP) +=3D ipt_dccp.o
-obj-$(CONFIG_IP_NF_MATCH_MARK) +=3D ipt_mark.o
-obj-$(CONFIG_IP_NF_MATCH_MAC) +=3D ipt_mac.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) +=3D ipt_iprange.o
-obj-$(CONFIG_IP_NF_MATCH_PKTTYPE) +=3D ipt_pkttype.o
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) +=3D ipt_multiport.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) +=3D ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
@@ -61,25 +57,18 @@ obj-$(CONFIG_IP_NF_MATCH_RECENT) +=3D ipt_
 obj-$(CONFIG_IP_NF_MATCH_ECN) +=3D ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_DSCP) +=3D ipt_dscp.o
 obj-$(CONFIG_IP_NF_MATCH_AH_ESP) +=3D ipt_ah.o ipt_esp.o
-obj-$(CONFIG_IP_NF_MATCH_LENGTH) +=3D ipt_length.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) +=3D ipt_ttl.o
-obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
 obj-$(CONFIG_IP_NF_MATCH_CONNMARK) +=3D ipt_connmark.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) +=3D ipt_conntrack.o
 obj-$(CONFIG_IP_NF_MATCH_CONNBYTES) +=3D ipt_connbytes.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) +=3D ipt_tcpmss.o
-obj-$(CONFIG_IP_NF_MATCH_REALM) +=3D ipt_realm.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) +=3D ipt_addrtype.o
-obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) +=3D ipt_physdev.o
-obj-$(CONFIG_IP_NF_MATCH_COMMENT) +=3D ipt_comment.o
-obj-$(CONFIG_IP_NF_MATCH_STRING) +=3D ipt_string.o
=20
 # targets
 obj-$(CONFIG_IP_NF_TARGET_REJECT) +=3D ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_TOS) +=3D ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_ECN) +=3D ipt_ECN.o
 obj-$(CONFIG_IP_NF_TARGET_DSCP) +=3D ipt_DSCP.o
-obj-$(CONFIG_IP_NF_TARGET_MARK) +=3D ipt_MARK.o
 obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) +=3D ipt_MASQUERADE.o
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) +=3D ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_NETMAP) +=3D ipt_NETMAP.o
@@ -93,7 +82,6 @@ obj-$(CONFIG_IP_NF_TARGET_TCPMSS) +=3D ipt
 obj-$(CONFIG_IP_NF_TARGET_NOTRACK) +=3D ipt_NOTRACK.o
 obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) +=3D ipt_CLUSTERIP.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) +=3D ipt_TTL.o
-obj-$(CONFIG_IP_NF_TARGET_NFQUEUE) +=3D ipt_NFQUEUE.o
=20
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) +=3D arp_tables.o
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_table=
s.c
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -23,6 +23,7 @@
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
=20
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
=20
 MODULE_LICENSE("GPL");
@@ -56,10 +57,6 @@ do {								\
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
=20
-static DECLARE_MUTEX(arpt_mutex);
-
-#define ASSERT_READ_LOCK(x) ARP_NF_ASSERT(down_trylock(&arpt_mutex) !=3D 0)
-#define ASSERT_WRITE_LOCK(x) ARP_NF_ASSERT(down_trylock(&arpt_mutex) !=3D =
0)
 #include <linux/netfilter_ipv4/listhelp.h>
=20
 struct arpt_table_info {
@@ -71,8 +68,6 @@ struct arpt_table_info {
 	char entries[0] __attribute__((aligned(SMP_CACHE_BYTES)));
 };
=20
-static LIST_HEAD(arpt_target);
-static LIST_HEAD(arpt_tables);
 #define ADD_COUNTER(c,b,p) do { (c).bcnt +=3D (b); (c).pcnt +=3D (p); } wh=
ile(0)
=20
 #ifdef CONFIG_SMP
@@ -227,9 +222,9 @@ static inline int arp_checkentry(const s
 }
=20
 static unsigned int arpt_error(struct sk_buff **pskb,
-			       unsigned int hooknum,
 			       const struct net_device *in,
 			       const struct net_device *out,
+			       unsigned int hooknum,
 			       const void *targinfo,
 			       void *userinfo)
 {
@@ -258,6 +253,7 @@ unsigned int arpt_do_table(struct sk_buf
 	struct arpt_entry *e, *back;
 	const char *indev, *outdev;
 	void *table_base;
+	struct arpt_table_info *private =3D table->private;
=20
 	/* ARP header, plus 2 device addresses, plus 2 IP addresses.  */
 	if (!pskb_may_pull((*pskb), (sizeof(struct arphdr) +
@@ -269,11 +265,10 @@ unsigned int arpt_do_table(struct sk_buf
 	outdev =3D out ? out->name : nulldevname;
=20
 	read_lock_bh(&table->lock);
-	table_base =3D (void *)table->private->entries
-		+ TABLE_OFFSET(table->private,
-			       smp_processor_id());
-	e =3D get_entry(table_base, table->private->hook_entry[hook]);
-	back =3D get_entry(table_base, table->private->underflow[hook]);
+	table_base =3D (void *)private->entries
+		+ TABLE_OFFSET(private, smp_processor_id());
+	e =3D get_entry(table_base, private->hook_entry[hook]);
+	back =3D get_entry(table_base, private->underflow[hook]);
=20
 	arp =3D (*pskb)->nh.arph;
 	do {
@@ -321,8 +316,8 @@ unsigned int arpt_do_table(struct sk_buf
 				 * abs. verdicts
 				 */
 				verdict =3D t->u.kernel.target->target(pskb,
-								     hook,
 								     in, out,
+								     hook,
 								     t->data,
 								     userdata);
=20
@@ -347,106 +342,6 @@ unsigned int arpt_do_table(struct sk_buf
 		return verdict;
 }
=20
-/*
- * These are weird, but module loading must not be done with mutex
- * held (since they will register), and we have to have a single
- * function to use try_then_request_module().
- */
-
-/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-static inline struct arpt_table *find_table_lock(const char *name)
-{
-	struct arpt_table *t;
-
-	if (down_interruptible(&arpt_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &arpt_tables, list)
-		if (strcmp(t->name, name) =3D=3D 0 && try_module_get(t->me))
-			return t;
-	up(&arpt_mutex);
-	return NULL;
-}
-
-
-/* Find target, grabs ref.  Returns ERR_PTR() on error. */
-static inline struct arpt_target *find_target(const char *name, u8 revisio=
n)
-{
-	struct arpt_target *t;
-	int err =3D 0;
-
-	if (down_interruptible(&arpt_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &arpt_target, list) {
-		if (strcmp(t->name, name) =3D=3D 0) {
-			if (t->revision =3D=3D revision) {
-				if (try_module_get(t->me)) {
-					up(&arpt_mutex);
-					return t;
-				}
-			} else
-				err =3D -EPROTOTYPE; /* Found something. */
-		}
-	}
-	up(&arpt_mutex);
-	return ERR_PTR(err);
-}
-
-struct arpt_target *arpt_find_target(const char *name, u8 revision)
-{
-	struct arpt_target *target;
-
-	target =3D try_then_request_module(find_target(name, revision),
-					 "arpt_%s", name);
-	if (IS_ERR(target) || !target)
-		return NULL;
-	return target;
-}
-
-static int target_revfn(const char *name, u8 revision, int *bestp)
-{
-	struct arpt_target *t;
-	int have_rev =3D 0;
-
-	list_for_each_entry(t, &arpt_target, list) {
-		if (strcmp(t->name, name) =3D=3D 0) {
-			if (t->revision > *bestp)
-				*bestp =3D t->revision;
-			if (t->revision =3D=3D revision)
-				have_rev =3D1;
-		}
-	}
-	return have_rev;
-}
-
-/* Returns true or false (if no such extension at all) */
-static inline int find_revision(const char *name, u8 revision,
-				int (*revfn)(const char *, u8, int *),
-				int *err)
-{
-	int have_rev, best =3D -1;
-
-	if (down_interruptible(&arpt_mutex) !=3D 0) {
-		*err =3D -EINTR;
-		return 1;
-	}
-	have_rev =3D revfn(name, revision, &best);
-	up(&arpt_mutex);
-
-	/* Nothing at all?  Return 0 to try loading module. */
-	if (best =3D=3D -1) {
-		*err =3D -ENOENT;
-		return 0;
-	}
-
-	*err =3D best;
-	if (!have_rev)
-		*err =3D -EPROTONOSUPPORT;
-	return 1;
-}
-
-
 /* All zeroes =3D=3D unconditional rule. */
 static inline int unconditional(const struct arpt_arp *arp)
 {
@@ -592,8 +487,8 @@ static inline int check_entry(struct arp
 	}
=20
 	t =3D arpt_get_target(e);
-	target =3D try_then_request_module(find_target(t->u.user.name,
-						     t->u.user.revision),
+	target =3D try_then_request_module(xt_find_target(NF_ARP, t->u.user.name,
+							t->u.user.revision),
 					 "arpt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
@@ -774,19 +669,21 @@ static struct arpt_table_info *replace_t
 					     struct arpt_table_info *newinfo,
 					     int *error)
 {
-	struct arpt_table_info *oldinfo;
+	struct arpt_table_info *oldinfo, *private;
=20
 	/* Do the substitution. */
 	write_lock_bh(&table->lock);
+	private =3D table->private;
+
 	/* Check inside lock: is the old number correct? */
-	if (num_counters !=3D table->private->number) {
+	if (num_counters !=3D private->number) {
 		duprintf("num_counters !=3D table->private->number (%u/%u)\n",
-			 num_counters, table->private->number);
+			 num_counters, private->number);
 		write_unlock_bh(&table->lock);
 		*error =3D -EAGAIN;
 		return NULL;
 	}
-	oldinfo =3D table->private;
+	oldinfo =3D private;
 	table->private =3D newinfo;
 	newinfo->initial_entries =3D oldinfo->initial_entries;
 	write_unlock_bh(&table->lock);
@@ -828,13 +725,14 @@ static int copy_entries_to_user(unsigned
 	unsigned int off, num, countersize;
 	struct arpt_entry *e;
 	struct arpt_counters *counters;
+	struct arpt_table_info *private =3D table->private;
 	int ret =3D 0;
=20
 	/* We need atomic snapshot of counters: rest doesn't change
 	 * (other than comefrom, which userspace doesn't care
 	 * about).
 	 */
-	countersize =3D sizeof(struct arpt_counters) * table->private->number;
+	countersize =3D sizeof(struct arpt_counters) * private->number;
 	counters =3D vmalloc(countersize);
=20
 	if (counters =3D=3D NULL)
@@ -843,11 +741,11 @@ static int copy_entries_to_user(unsigned
 	/* First, sum counters... */
 	memset(counters, 0, countersize);
 	write_lock_bh(&table->lock);
-	get_counters(table->private, counters);
+	get_counters(private, counters);
 	write_unlock_bh(&table->lock);
=20
 	/* ... then copy entire thing from CPU 0... */
-	if (copy_to_user(userptr, table->private->entries, total_size) !=3D 0) {
+	if (copy_to_user(userptr, private->entries, total_size) !=3D 0) {
 		ret =3D -EFAULT;
 		goto free_counters;
 	}
@@ -857,7 +755,7 @@ static int copy_entries_to_user(unsigned
 	for (off =3D 0, num =3D 0; off < total_size; off +=3D e->next_offset, num=
++){
 		struct arpt_entry_target *t;
=20
-		e =3D (struct arpt_entry *)(table->private->entries + off);
+		e =3D (struct arpt_entry *)(private->entries + off);
 		if (copy_to_user(userptr + off
 				 + offsetof(struct arpt_entry, counters),
 				 &counters[num],
@@ -888,21 +786,21 @@ static int get_entries(const struct arpt
 	int ret;
 	struct arpt_table *t;
=20
-	t =3D find_table_lock(entries->name);
+	t =3D xt_find_table_lock(NF_ARP, entries->name);
 	if (t || !IS_ERR(t)) {
+		struct arpt_table_info *private =3D t->private;
 		duprintf("t->private->number =3D %u\n",
-			 t->private->number);
-		if (entries->size =3D=3D t->private->size)
-			ret =3D copy_entries_to_user(t->private->size,
+			 private->number);
+		if (entries->size =3D=3D private->size)
+			ret =3D copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 t->private->size,
-				 entries->size);
+				 private->size, entries->size);
 			ret =3D -EINVAL;
 		}
 		module_put(t->me);
-		up(&arpt_mutex);
+		up(&xt_mutex[NF_ARP]);
 	} else
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
=20
@@ -954,7 +852,7 @@ static int do_replace(void __user *user,
=20
 	duprintf("arp_tables: Translated table\n");
=20
-	t =3D try_then_request_module(find_table_lock(tmp.name),
+	t =3D try_then_request_module(xt_find_table_lock(NF_ARP, tmp.name),
 				    "arptable_%s", tmp.name);
 	if (!t || IS_ERR(t)) {
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
@@ -992,12 +890,12 @@ static int do_replace(void __user *user,
 			 sizeof(struct arpt_counters) * tmp.num_counters) !=3D 0)
 		ret =3D -EFAULT;
 	vfree(counters);
-	up(&arpt_mutex);
+	up(&xt_mutex[NF_ARP]);
 	return ret;
=20
  put_module:
 	module_put(t->me);
-	up(&arpt_mutex);
+	up(&xt_mutex[NF_ARP]);
  free_newinfo_counters_untrans:
 	ARPT_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry, NULL);
  free_newinfo_counters:
@@ -1026,6 +924,7 @@ static int do_add_counters(void __user *
 	unsigned int i;
 	struct arpt_counters_info tmp, *paddc;
 	struct arpt_table *t;
+	struct arpt_table_info *private;
 	int ret =3D 0;
=20
 	if (copy_from_user(&tmp, user, sizeof(tmp)) !=3D 0)
@@ -1043,27 +942,28 @@ static int do_add_counters(void __user *
 		goto free;
 	}
=20
-	t =3D find_table_lock(tmp.name);
+	t =3D xt_find_table_lock(NF_ARP, tmp.name);
 	if (!t || IS_ERR(t)) {
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free;
 	}
=20
 	write_lock_bh(&t->lock);
-	if (t->private->number !=3D paddc->num_counters) {
+	private =3D t->private;
+	if (private->number !=3D paddc->num_counters) {
 		ret =3D -EINVAL;
 		goto unlock_up_free;
 	}
=20
 	i =3D 0;
-	ARPT_ENTRY_ITERATE(t->private->entries,
-			   t->private->size,
+	ARPT_ENTRY_ITERATE(private->entries,
+			   private->size,
 			   add_counter_to_entry,
 			   paddc->counters,
 			   &i);
  unlock_up_free:
 	write_unlock_bh(&t->lock);
-	up(&arpt_mutex);
+	up(&xt_mutex[NF_ARP]);
 	module_put(t->me);
  free:
 	vfree(paddc);
@@ -1120,25 +1020,26 @@ static int do_arpt_get_ctl(struct sock *
 		}
 		name[ARPT_TABLE_MAXNAMELEN-1] =3D '\0';
=20
-		t =3D try_then_request_module(find_table_lock(name),
+		t =3D try_then_request_module(xt_find_table_lock(NF_ARP, name),
 					    "arptable_%s", name);
 		if (t && !IS_ERR(t)) {
 			struct arpt_getinfo info;
+			struct arpt_table_info *private =3D t->private;
=20
 			info.valid_hooks =3D t->valid_hooks;
-			memcpy(info.hook_entry, t->private->hook_entry,
+			memcpy(info.hook_entry, private->hook_entry,
 			       sizeof(info.hook_entry));
-			memcpy(info.underflow, t->private->underflow,
+			memcpy(info.underflow, private->underflow,
 			       sizeof(info.underflow));
-			info.num_entries =3D t->private->number;
-			info.size =3D t->private->size;
+			info.num_entries =3D private->number;
+			info.size =3D private->size;
 			strcpy(info.name, name);
=20
 			if (copy_to_user(user, &info, *len) !=3D 0)
 				ret =3D -EFAULT;
 			else
 				ret =3D 0;
-			up(&arpt_mutex);
+			up(&xt_mutex[NF_ARP]);
 			module_put(t->me);
 		} else
 			ret =3D t ? PTR_ERR(t) : -ENOENT;
@@ -1163,7 +1064,7 @@ static int do_arpt_get_ctl(struct sock *
 	}
=20
 	case ARPT_SO_GET_REVISION_TARGET: {
-		struct arpt_get_revision rev;
+		struct xt_get_revision rev;
=20
 		if (*len !=3D sizeof(rev)) {
 			ret =3D -EINVAL;
@@ -1174,8 +1075,8 @@ static int do_arpt_get_ctl(struct sock *
 			break;
 		}
=20
-		try_then_request_module(find_revision(rev.name, rev.revision,
-						      target_revfn, &ret),
+		try_then_request_module(xt_find_revision(NF_ARP, rev.name,
+							 rev.revision, 1, &ret),
 					"arpt_%s", rev.name);
 		break;
 	}
@@ -1188,42 +1089,19 @@ static int do_arpt_get_ctl(struct sock *
 	return ret;
 }
=20
-/* Registration hooks for targets. */
-int arpt_register_target(struct arpt_target *target)
-{
-	int ret;
-
-	ret =3D down_interruptible(&arpt_mutex);
-	if (ret !=3D 0)
-		return ret;
-
-	list_add(&target->list, &arpt_target);
-	up(&arpt_mutex);
-
-	return ret;
-}
-
-void arpt_unregister_target(struct arpt_target *target)
-{
-	down(&arpt_mutex);
-	LIST_DELETE(&arpt_target, target);
-	up(&arpt_mutex);
-}
-
 int arpt_register_table(struct arpt_table *table,
 			const struct arpt_replace *repl)
 {
 	int ret;
-	struct arpt_table_info *newinfo;
+	struct arpt_table_info *newinfo, *private;
 	static struct arpt_table_info bootstrap
 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
=20
 	newinfo =3D vmalloc(sizeof(struct arpt_table_info)
 			  + SMP_ALIGN(repl->size) * num_possible_cpus());
-	if (!newinfo) {
-		ret =3D -ENOMEM;
-		return ret;
-	}
+	if (!newinfo)
+		return -ENOMEM;
+
 	memcpy(newinfo->entries, repl->entries, repl->size);
=20
 	ret =3D translate_table(table->name, table->valid_hooks,
@@ -1237,14 +1115,14 @@ int arpt_register_table(struct arpt_tabl
 		return ret;
 	}
=20
-	ret =3D down_interruptible(&arpt_mutex);
+	ret =3D down_interruptible(&xt_mutex[NF_ARP]);
 	if (ret !=3D 0) {
 		vfree(newinfo);
 		return ret;
 	}
=20
 	/* Don't autoload: we'd eat our tail... */
-	if (list_named_find(&arpt_tables, table->name)) {
+	if (list_named_find(&xt_tables[NF_ARP], table->name)) {
 		ret =3D -EEXIST;
 		goto free_unlock;
 	}
@@ -1254,17 +1132,17 @@ int arpt_register_table(struct arpt_tabl
 	if (!replace_table(table, 0, newinfo, &ret))
 		goto free_unlock;
=20
-	duprintf("table->private->number =3D %u\n",
-		 table->private->number);
-=09
+	private =3D table->private;
+	duprintf("table->private->number =3D %u\n", private->number);
+
 	/* save number of initial entries */
-	table->private->initial_entries =3D table->private->number;
+	private->initial_entries =3D private->number;
=20
 	rwlock_init(&table->lock);
-	list_prepend(&arpt_tables, table);
+	list_prepend(&xt_tables[NF_ARP], table);
=20
  unlock:
-	up(&arpt_mutex);
+	up(&xt_mutex[NF_ARP]);
 	return ret;
=20
  free_unlock:
@@ -1274,14 +1152,16 @@ int arpt_register_table(struct arpt_tabl
=20
 void arpt_unregister_table(struct arpt_table *table)
 {
-	down(&arpt_mutex);
-	LIST_DELETE(&arpt_tables, table);
-	up(&arpt_mutex);
+	struct arpt_table_info *private =3D table->private;
+
+	down(&xt_mutex[NF_ARP]);
+	LIST_DELETE(&xt_tables[NF_ARP], table);
+	up(&xt_mutex[NF_ARP]);
=20
 	/* Decrease module usage counts and free resources */
-	ARPT_ENTRY_ITERATE(table->private->entries, table->private->size,
+	ARPT_ENTRY_ITERATE(private->entries, private->size,
 			   cleanup_entry, NULL);
-	vfree(table->private);
+	vfree(private);
 }
=20
 /* The built-in targets: standard (NULL) and error. */
@@ -1304,52 +1184,15 @@ static struct nf_sockopt_ops arpt_sockop
 	.get		=3D do_arpt_get_ctl,
 };
=20
-#ifdef CONFIG_PROC_FS
-static inline int print_name(const struct arpt_table *t,
-			     off_t start_offset, char *buffer, int length,
-			     off_t *pos, unsigned int *count)
-{
-	if ((*count)++ >=3D start_offset) {
-		unsigned int namelen;
-
-		namelen =3D sprintf(buffer + *pos, "%s\n", t->name);
-		if (*pos + namelen > length) {
-			/* Stop iterating */
-			return 1;
-		}
-		*pos +=3D namelen;
-	}
-	return 0;
-}
-
-static int arpt_get_tables(char *buffer, char **start, off_t offset, int l=
ength)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&arpt_mutex) !=3D 0)
-		return 0;
-
-	LIST_FIND(&arpt_tables, print_name, struct arpt_table *,
-		  offset, buffer, length, &pos, &count);
-
-	up(&arpt_mutex);
-
-	/* `start' hack - see fs/proc/generic.c line ~105 */
-	*start=3D(char *)((unsigned long)count-offset);
-	return pos;
-}
-#endif /*CONFIG_PROC_FS*/
-
 static int __init init(void)
 {
 	int ret;
=20
+	xt_proto_init(NF_ARP);
+
 	/* Noone else will be downing sem now, so we won't sleep */
-	down(&arpt_mutex);
-	list_append(&arpt_target, &arpt_standard_target);
-	list_append(&arpt_target, &arpt_error_target);
-	up(&arpt_mutex);
+	xt_register_target(NF_ARP, &arpt_standard_target);
+	xt_register_target(NF_ARP, &arpt_error_target);
=20
 	/* Register setsockopt */
 	ret =3D nf_register_sockopt(&arpt_sockopts);
@@ -1358,19 +1201,6 @@ static int __init init(void)
 		return ret;
 	}
=20
-#ifdef CONFIG_PROC_FS
-	{
-		struct proc_dir_entry *proc;
-
-		proc =3D proc_net_create("arp_tables_names", 0, arpt_get_tables);
-		if (!proc) {
-			nf_unregister_sockopt(&arpt_sockopts);
-			return -ENOMEM;
-		}
-		proc->owner =3D THIS_MODULE;
-	}
-#endif
-
 	printk("arp_tables: (C) 2002 David S. Miller\n");
 	return 0;
 }
@@ -1378,16 +1208,12 @@ static int __init init(void)
 static void __exit fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
-#ifdef CONFIG_PROC_FS
-	proc_net_remove("arp_tables_names");
-#endif
+	xt_proto_fini(NF_ARP);
 }
=20
 EXPORT_SYMBOL(arpt_register_table);
 EXPORT_SYMBOL(arpt_unregister_table);
 EXPORT_SYMBOL(arpt_do_table);
-EXPORT_SYMBOL(arpt_register_target);
-EXPORT_SYMBOL(arpt_unregister_target);
=20
 module_init(init);
 module_exit(fini);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_man=
gle.c
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -8,8 +8,9 @@ MODULE_AUTHOR("Bart De Schuymer <bdschuy
 MODULE_DESCRIPTION("arptables arp payload mangle target");
=20
 static unsigned int
-target(struct sk_buff **pskb, unsigned int hooknum, const struct net_devic=
e *in,
-   const struct net_device *out, const void *targinfo, void *userinfo)
+target(struct sk_buff **pskb, const struct net_device *in,
+   const struct net_device *out, unsigned int hooknum, const void *targinf=
o,
+   void *userinfo)
 {
 	const struct arpt_mangle *mangle =3D targinfo;
 	struct arphdr *arp;
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_r=
ule.c
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -168,7 +168,7 @@ static unsigned int ipt_dnat_target(stru
 }
=20
 static int ipt_snat_checkentry(const char *tablename,
-			       const struct ipt_entry *e,
+			       const void *entry,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
@@ -201,7 +201,7 @@ static int ipt_snat_checkentry(const cha
 }
=20
 static int ipt_dnat_checkentry(const char *tablename,
-			       const struct ipt_entry *e,
+			       const void *entry,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2,7 +2,7 @@
  * Packet matching code.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
- * Copyright (C) 2000-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * Copyright (C) 2000-2005 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -11,6 +11,8 @@
  * 19 Jan 2002 Harald Welte <laforge@gnumonks.org>
  * 	- increase module usage count as soon as we have rules inside
  * 	  a table
+ * 08 Oct 2005 Harald Welte <lafore@netfilter.org>
+ * 	- Generalize into "x_tables" layer and "{ip,ip6,arp}_tables"
  */
 #include <linux/config.h>
 #include <linux/cache.h>
@@ -28,6 +30,7 @@
 #include <linux/proc_fs.h>
 #include <linux/err.h>
=20
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
 MODULE_LICENSE("GPL");
@@ -62,12 +65,12 @@ do {								\
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
=20
-static DECLARE_MUTEX(ipt_mutex);
-
+#if 0
 /* Must have mutex */
 #define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) !=3D 0)
 #define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ipt_mutex) !=3D 0)
 #include <linux/netfilter_ipv4/listhelp.h>
+#endif
=20
 #if 0
 /* All the better to debug you with... */
@@ -107,9 +110,6 @@ struct ipt_table_info
 	char entries[0] ____cacheline_aligned;
 };
=20
-static LIST_HEAD(ipt_target);
-static LIST_HEAD(ipt_match);
-static LIST_HEAD(ipt_tables);
 #define ADD_COUNTER(c,b,p) do { (c).bcnt +=3D (b); (c).pcnt +=3D (p); } wh=
ile(0)
=20
 #ifdef CONFIG_SMP
@@ -242,7 +242,8 @@ int do_match(struct ipt_entry_match *m,
 	     int *hotdrop)
 {
 	/* Stop iteration if it doesn't match */
-	if (!m->u.kernel.match->match(skb, in, out, m->data, offset, hotdrop))
+	if (!m->u.kernel.match->match(skb, in, out, m->data, offset,=20
+	    0, hotdrop))
 		return 1;
 	else
 		return 0;
@@ -273,6 +274,7 @@ ipt_do_table(struct sk_buff **pskb,
 	const char *indev, *outdev;
 	void *table_base;
 	struct ipt_entry *e, *back;
+	struct ipt_table_info *private =3D table->private;
=20
 	/* Initialization */
 	ip =3D (*pskb)->nh.iph;
@@ -289,9 +291,9 @@ ipt_do_table(struct sk_buff **pskb,
=20
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	table_base =3D (void *)table->private->entries
+	table_base =3D (void *)private->entries
 		+ TABLE_OFFSET(table->private, smp_processor_id());
-	e =3D get_entry(table_base, table->private->hook_entry[hook]);
+	e =3D get_entry(table_base, private->hook_entry[hook]);
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	/* Check noone else using our table */
@@ -307,7 +309,7 @@ ipt_do_table(struct sk_buff **pskb,
 #endif
=20
 	/* For return from builtin chain */
-	back =3D get_entry(table_base, table->private->underflow[hook]);
+	back =3D get_entry(table_base, private->underflow[hook]);
=20
 	do {
 		IP_NF_ASSERT(e);
@@ -407,145 +409,6 @@ ipt_do_table(struct sk_buff **pskb,
 #endif
 }
=20
-/*
- * These are weird, but module loading must not be done with mutex
- * held (since they will register), and we have to have a single
- * function to use try_then_request_module().
- */
-
-/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-static inline struct ipt_table *find_table_lock(const char *name)
-{
-	struct ipt_table *t;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &ipt_tables, list)
-		if (strcmp(t->name, name) =3D=3D 0 && try_module_get(t->me))
-			return t;
-	up(&ipt_mutex);
-	return NULL;
-}
-
-/* Find match, grabs ref.  Returns ERR_PTR() on error. */
-static inline struct ipt_match *find_match(const char *name, u8 revision)
-{
-	struct ipt_match *m;
-	int err =3D 0;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(m, &ipt_match, list) {
-		if (strcmp(m->name, name) =3D=3D 0) {
-			if (m->revision =3D=3D revision) {
-				if (try_module_get(m->me)) {
-					up(&ipt_mutex);
-					return m;
-				}
-			} else
-				err =3D -EPROTOTYPE; /* Found something. */
-		}
-	}
-	up(&ipt_mutex);
-	return ERR_PTR(err);
-}
-
-/* Find target, grabs ref.  Returns ERR_PTR() on error. */
-static inline struct ipt_target *find_target(const char *name, u8 revision)
-{
-	struct ipt_target *t;
-	int err =3D 0;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &ipt_target, list) {
-		if (strcmp(t->name, name) =3D=3D 0) {
-			if (t->revision =3D=3D revision) {
-				if (try_module_get(t->me)) {
-					up(&ipt_mutex);
-					return t;
-				}
-			} else
-				err =3D -EPROTOTYPE; /* Found something. */
-		}
-	}
-	up(&ipt_mutex);
-	return ERR_PTR(err);
-}
-
-struct ipt_target *ipt_find_target(const char *name, u8 revision)
-{
-	struct ipt_target *target;
-
-	target =3D try_then_request_module(find_target(name, revision),
-					 "ipt_%s", name);
-	if (IS_ERR(target) || !target)
-		return NULL;
-	return target;
-}
-
-static int match_revfn(const char *name, u8 revision, int *bestp)
-{
-	struct ipt_match *m;
-	int have_rev =3D 0;
-
-	list_for_each_entry(m, &ipt_match, list) {
-		if (strcmp(m->name, name) =3D=3D 0) {
-			if (m->revision > *bestp)
-				*bestp =3D m->revision;
-			if (m->revision =3D=3D revision)
-				have_rev =3D 1;
-		}
-	}
-	return have_rev;
-}
-
-static int target_revfn(const char *name, u8 revision, int *bestp)
-{
-	struct ipt_target *t;
-	int have_rev =3D 0;
-
-	list_for_each_entry(t, &ipt_target, list) {
-		if (strcmp(t->name, name) =3D=3D 0) {
-			if (t->revision > *bestp)
-				*bestp =3D t->revision;
-			if (t->revision =3D=3D revision)
-				have_rev =3D 1;
-		}
-	}
-	return have_rev;
-}
-
-/* Returns true or false (if no such extension at all) */
-static inline int find_revision(const char *name, u8 revision,
-				int (*revfn)(const char *, u8, int *),
-				int *err)
-{
-	int have_rev, best =3D -1;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0) {
-		*err =3D -EINTR;
-		return 1;
-	}
-	have_rev =3D revfn(name, revision, &best);
-	up(&ipt_mutex);
-
-	/* Nothing at all?  Return 0 to try loading module. */
-	if (best =3D=3D -1) {
-		*err =3D -ENOENT;
-		return 0;
-	}
-
-	*err =3D best;
-	if (!have_rev)
-		*err =3D -EPROTONOSUPPORT;
-	return 1;
-}
-
-
 /* All zeroes =3D=3D unconditional rule. */
 static inline int
 unconditional(const struct ipt_ip *ip)
@@ -707,7 +570,7 @@ check_match(struct ipt_entry_match *m,
 {
 	struct ipt_match *match;
=20
-	match =3D try_then_request_module(find_match(m->u.user.name,
+	match =3D try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
 						   m->u.user.revision),
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
@@ -752,7 +615,8 @@ check_entry(struct ipt_entry *e, const c
 		goto cleanup_matches;
=20
 	t =3D ipt_get_target(e);
-	target =3D try_then_request_module(find_target(t->u.user.name,
+	target =3D try_then_request_module(xt_find_target(AF_INET,
+						     t->u.user.name,
 						     t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
@@ -936,7 +800,7 @@ replace_table(struct ipt_table *table,
 	      struct ipt_table_info *newinfo,
 	      int *error)
 {
-	struct ipt_table_info *oldinfo;
+	struct ipt_table_info *oldinfo, *private;
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	{
@@ -955,15 +819,16 @@ replace_table(struct ipt_table *table,
=20
 	/* Do the substitution. */
 	write_lock_bh(&table->lock);
+	private =3D table->private;
 	/* Check inside lock: is the old number correct? */
-	if (num_counters !=3D table->private->number) {
+	if (num_counters !=3D private->number) {
 		duprintf("num_counters !=3D table->private->number (%u/%u)\n",
-			 num_counters, table->private->number);
+			 num_counters, private->number);
 		write_unlock_bh(&table->lock);
 		*error =3D -EAGAIN;
 		return NULL;
 	}
-	oldinfo =3D table->private;
+	oldinfo =3D private;
 	table->private =3D newinfo;
 	newinfo->initial_entries =3D oldinfo->initial_entries;
 	write_unlock_bh(&table->lock);
@@ -1008,12 +873,13 @@ copy_entries_to_user(unsigned int total_
 	unsigned int off, num, countersize;
 	struct ipt_entry *e;
 	struct ipt_counters *counters;
+	struct ipt_table_info *private =3D table->private;
 	int ret =3D 0;
=20
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
 	   about). */
-	countersize =3D sizeof(struct ipt_counters) * table->private->number;
+	countersize =3D sizeof(struct ipt_counters) * private->number;
 	counters =3D vmalloc(countersize);
=20
 	if (counters =3D=3D NULL)
@@ -1022,11 +888,11 @@ copy_entries_to_user(unsigned int total_
 	/* First, sum counters... */
 	memset(counters, 0, countersize);
 	write_lock_bh(&table->lock);
-	get_counters(table->private, counters);
+	get_counters(private, counters);
 	write_unlock_bh(&table->lock);
=20
 	/* ... then copy entire thing from CPU 0... */
-	if (copy_to_user(userptr, table->private->entries, total_size) !=3D 0) {
+	if (copy_to_user(userptr, private->entries, total_size) !=3D 0) {
 		ret =3D -EFAULT;
 		goto free_counters;
 	}
@@ -1038,7 +904,7 @@ copy_entries_to_user(unsigned int total_
 		struct ipt_entry_match *m;
 		struct ipt_entry_target *t;
=20
-		e =3D (struct ipt_entry *)(table->private->entries + off);
+		e =3D (struct ipt_entry *)(private->entries + off);
 		if (copy_to_user(userptr + off
 				 + offsetof(struct ipt_entry, counters),
 				 &counters[num],
@@ -1086,21 +952,22 @@ get_entries(const struct ipt_get_entries
 	int ret;
 	struct ipt_table *t;
=20
-	t =3D find_table_lock(entries->name);
+	t =3D xt_find_table_lock(AF_INET, entries->name);
 	if (t && !IS_ERR(t)) {
+		struct ipt_table_info *private =3D t->private;
 		duprintf("t->private->number =3D %u\n",
-			 t->private->number);
-		if (entries->size =3D=3D t->private->size)
-			ret =3D copy_entries_to_user(t->private->size,
+			 private->number);
+		if (entries->size =3D=3D private->size)
+			ret =3D copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 t->private->size,
+				 private->size,
 				 entries->size);
 			ret =3D -EINVAL;
 		}
 		module_put(t->me);
-		up(&ipt_mutex);
+		up(&xt_mutex[AF_INET]);
 	} else
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
=20
@@ -1153,7 +1020,7 @@ do_replace(void __user *user, unsigned i
=20
 	duprintf("ip_tables: Translated table\n");
=20
-	t =3D try_then_request_module(find_table_lock(tmp.name),
+	t =3D try_then_request_module(xt_find_table_lock(AF_INET, tmp.name),
 				    "iptable_%s", tmp.name);
 	if (!t || IS_ERR(t)) {
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
@@ -1191,12 +1058,12 @@ do_replace(void __user *user, unsigned i
 			 sizeof(struct ipt_counters) * tmp.num_counters) !=3D 0)
 		ret =3D -EFAULT;
 	vfree(counters);
-	up(&ipt_mutex);
+	up(&xt_mutex[AF_INET]);
 	return ret;
=20
  put_module:
 	module_put(t->me);
-	up(&ipt_mutex);
+	up(&xt_mutex[AF_INET]);
  free_newinfo_counters_untrans:
 	IPT_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry,NULL);
  free_newinfo_counters:
@@ -1234,6 +1101,7 @@ do_add_counters(void __user *user, unsig
 	unsigned int i;
 	struct ipt_counters_info tmp, *paddc;
 	struct ipt_table *t;
+	struct ipt_table_info *private;
 	int ret =3D 0;
=20
 	if (copy_from_user(&tmp, user, sizeof(tmp)) !=3D 0)
@@ -1251,27 +1119,28 @@ do_add_counters(void __user *user, unsig
 		goto free;
 	}
=20
-	t =3D find_table_lock(tmp.name);
+	t =3D xt_find_table_lock(AF_INET, tmp.name);
 	if (!t || IS_ERR(t)) {
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free;
 	}
=20
 	write_lock_bh(&t->lock);
-	if (t->private->number !=3D paddc->num_counters) {
+	private =3D t->private;
+	if (private->number !=3D paddc->num_counters) {
 		ret =3D -EINVAL;
 		goto unlock_up_free;
 	}
=20
 	i =3D 0;
-	IPT_ENTRY_ITERATE(t->private->entries,
-			  t->private->size,
+	IPT_ENTRY_ITERATE(private->entries,
+			  private->size,
 			  add_counter_to_entry,
 			  paddc->counters,
 			  &i);
  unlock_up_free:
 	write_unlock_bh(&t->lock);
-	up(&ipt_mutex);
+	up(&xt_mutex[AF_INET]);
 	module_put(t->me);
  free:
 	vfree(paddc);
@@ -1330,25 +1199,26 @@ do_ipt_get_ctl(struct sock *sk, int cmd,
 		}
 		name[IPT_TABLE_MAXNAMELEN-1] =3D '\0';
=20
-		t =3D try_then_request_module(find_table_lock(name),
+		t =3D try_then_request_module(xt_find_table_lock(AF_INET, name),
 					    "iptable_%s", name);
 		if (t && !IS_ERR(t)) {
 			struct ipt_getinfo info;
+			struct ipt_table_info *private =3D t->private;
=20
 			info.valid_hooks =3D t->valid_hooks;
-			memcpy(info.hook_entry, t->private->hook_entry,
+			memcpy(info.hook_entry, private->hook_entry,
 			       sizeof(info.hook_entry));
-			memcpy(info.underflow, t->private->underflow,
+			memcpy(info.underflow, private->underflow,
 			       sizeof(info.underflow));
-			info.num_entries =3D t->private->number;
-			info.size =3D t->private->size;
+			info.num_entries =3D private->number;
+			info.size =3D private->size;
 			memcpy(info.name, name, sizeof(info.name));
=20
 			if (copy_to_user(user, &info, *len) !=3D 0)
 				ret =3D -EFAULT;
 			else
 				ret =3D 0;
-			up(&ipt_mutex);
+			up(&xt_mutex[AF_INET]);
 			module_put(t->me);
 		} else
 			ret =3D t ? PTR_ERR(t) : -ENOENT;
@@ -1375,7 +1245,7 @@ do_ipt_get_ctl(struct sock *sk, int cmd,
 	case IPT_SO_GET_REVISION_MATCH:
 	case IPT_SO_GET_REVISION_TARGET: {
 		struct ipt_get_revision rev;
-		int (*revfn)(const char *, u8, int *);
+		int target;
=20
 		if (*len !=3D sizeof(rev)) {
 			ret =3D -EINVAL;
@@ -1387,12 +1257,13 @@ do_ipt_get_ctl(struct sock *sk, int cmd,
 		}
=20
 		if (cmd =3D=3D IPT_SO_GET_REVISION_TARGET)
-			revfn =3D target_revfn;
+			target =3D 1;
 		else
-			revfn =3D match_revfn;
+			target =3D 0;
=20
-		try_then_request_module(find_revision(rev.name, rev.revision,
-						      revfn, &ret),
+		try_then_request_module(xt_find_revision(AF_INET, rev.name,
+							 rev.revision,
+							 target, &ret),
 					"ipt_%s", rev.name);
 		break;
 	}
@@ -1405,55 +1276,10 @@ do_ipt_get_ctl(struct sock *sk, int cmd,
 	return ret;
 }
=20
-/* Registration hooks for targets. */
-int
-ipt_register_target(struct ipt_target *target)
-{
-	int ret;
-
-	ret =3D down_interruptible(&ipt_mutex);
-	if (ret !=3D 0)
-		return ret;
-	list_add(&target->list, &ipt_target);
-	up(&ipt_mutex);
-	return ret;
-}
-
-void
-ipt_unregister_target(struct ipt_target *target)
-{
-	down(&ipt_mutex);
-	LIST_DELETE(&ipt_target, target);
-	up(&ipt_mutex);
-}
-
-int
-ipt_register_match(struct ipt_match *match)
-{
-	int ret;
-
-	ret =3D down_interruptible(&ipt_mutex);
-	if (ret !=3D 0)
-		return ret;
-
-	list_add(&match->list, &ipt_match);
-	up(&ipt_mutex);
-
-	return ret;
-}
-
-void
-ipt_unregister_match(struct ipt_match *match)
-{
-	down(&ipt_mutex);
-	LIST_DELETE(&ipt_match, match);
-	up(&ipt_mutex);
-}
-
 int ipt_register_table(struct ipt_table *table, const struct ipt_replace *=
repl)
 {
 	int ret;
-	struct ipt_table_info *newinfo;
+	struct ipt_table_info *newinfo, *private;
 	static struct ipt_table_info bootstrap
 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
=20
@@ -1474,14 +1300,14 @@ int ipt_register_table(struct ipt_table=20
 		return ret;
 	}
=20
-	ret =3D down_interruptible(&ipt_mutex);
+	ret =3D down_interruptible(&xt_mutex[AF_INET]);
 	if (ret !=3D 0) {
 		vfree(newinfo);
 		return ret;
 	}
=20
 	/* Don't autoload: we'd eat our tail... */
-	if (list_named_find(&ipt_tables, table->name)) {
+	if (list_named_find(&xt_tables[AF_INET], table->name)) {
 		ret =3D -EEXIST;
 		goto free_unlock;
 	}
@@ -1491,17 +1317,17 @@ int ipt_register_table(struct ipt_table=20
 	if (!replace_table(table, 0, newinfo, &ret))
 		goto free_unlock;
=20
-	duprintf("table->private->number =3D %u\n",
-		 table->private->number);
-=09
+	private =3D table->private;
+	duprintf("table->private->number =3D %u\n", private->number);
+
 	/* save number of initial entries */
-	table->private->initial_entries =3D table->private->number;
+	private->initial_entries =3D private->number;
=20
 	rwlock_init(&table->lock);
-	list_prepend(&ipt_tables, table);
+	list_prepend(&xt_tables[AF_INET], table);
=20
  unlock:
-	up(&ipt_mutex);
+	up(&xt_mutex[AF_INET]);
 	return ret;
=20
  free_unlock:
@@ -1511,14 +1337,17 @@ int ipt_register_table(struct ipt_table=20
=20
 void ipt_unregister_table(struct ipt_table *table)
 {
-	down(&ipt_mutex);
-	LIST_DELETE(&ipt_tables, table);
-	up(&ipt_mutex);
+	struct ipt_table_info *private;
+
+	down(&xt_mutex[AF_INET]);
+ 	private =3D table->private;
+	LIST_DELETE(&xt_tables[AF_INET], table);
+	up(&xt_mutex[AF_INET]);
=20
 	/* Decrease module usage counts and free resources */
-	IPT_ENTRY_ITERATE(table->private->entries, table->private->size,
-			  cleanup_entry, NULL);
-	vfree(table->private);
+	IPT_ENTRY_ITERATE(private->entries, private->size, cleanup_entry,
+			  NULL);
+	vfree(private);
 }
=20
 /* Returns 1 if the port is matched by the range, 0 otherwise */
@@ -1571,6 +1400,7 @@ tcp_match(const struct sk_buff *skb,
 	  const struct net_device *out,
 	  const void *matchinfo,
 	  int offset,
+	  unsigned int protoff,
 	  int *hotdrop)
 {
 	struct tcphdr _tcph, *th;
@@ -1632,11 +1462,12 @@ tcp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 tcp_checkentry(const char *tablename,
-	       const struct ipt_ip *ip,
+	       const void *info,
 	       void *matchinfo,
 	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
+	const struct ipt_ip *ip =3D info;
 	const struct ipt_tcp *tcpinfo =3D matchinfo;
=20
 	/* Must specify proto =3D=3D TCP, and no unknown invflags */
@@ -1652,6 +1483,7 @@ udp_match(const struct sk_buff *skb,
 	  const struct net_device *out,
 	  const void *matchinfo,
 	  int offset,
+	  unsigned int protoff,
 	  int *hotdrop)
 {
 	struct udphdr _udph, *uh;
@@ -1682,11 +1514,12 @@ udp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 udp_checkentry(const char *tablename,
-	       const struct ipt_ip *ip,
+	       const void *info,
 	       void *matchinfo,
 	       unsigned int matchinfosize,
 	       unsigned int hook_mask)
 {
+	const struct ipt_ip *ip =3D info;
 	const struct ipt_udp *udpinfo =3D matchinfo;
=20
 	/* Must specify proto =3D=3D UDP, and no unknown invflags */
@@ -1725,6 +1558,7 @@ icmp_match(const struct sk_buff *skb,
 	   const struct net_device *out,
 	   const void *matchinfo,
 	   int offset,
+	   unsigned int protoff,
 	   int *hotdrop)
 {
 	struct icmphdr _icmph, *ic;
@@ -1755,11 +1589,12 @@ icmp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 icmp_checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *info,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
+	const struct ipt_ip *ip =3D info;
 	const struct ipt_icmp *icmpinfo =3D matchinfo;
=20
 	/* Must specify proto =3D=3D ICMP, and no unknown invflags */
@@ -1807,105 +1642,18 @@ static struct ipt_match icmp_matchstruct
 	.checkentry	=3D &icmp_checkentry,
 };
=20
-#ifdef CONFIG_PROC_FS
-static inline int print_name(const char *i,
-			     off_t start_offset, char *buffer, int length,
-			     off_t *pos, unsigned int *count)
-{
-	if ((*count)++ >=3D start_offset) {
-		unsigned int namelen;
-
-		namelen =3D sprintf(buffer + *pos, "%s\n",
-				  i + sizeof(struct list_head));
-		if (*pos + namelen > length) {
-			/* Stop iterating */
-			return 1;
-		}
-		*pos +=3D namelen;
-	}
-	return 0;
-}
-
-static inline int print_target(const struct ipt_target *t,
-                               off_t start_offset, char *buffer, int lengt=
h,
-                               off_t *pos, unsigned int *count)
-{
-	if (t =3D=3D &ipt_standard_target || t =3D=3D &ipt_error_target)
-		return 0;
-	return print_name((char *)t, start_offset, buffer, length, pos, count);
-}
-
-static int ipt_get_tables(char *buffer, char **start, off_t offset, int le=
ngth)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0)
-		return 0;
-
-	LIST_FIND(&ipt_tables, print_name, void *,
-		  offset, buffer, length, &pos, &count);
-
-	up(&ipt_mutex);
-
-	/* `start' hack - see fs/proc/generic.c line ~105 */
-	*start=3D(char *)((unsigned long)count-offset);
-	return pos;
-}
-
-static int ipt_get_targets(char *buffer, char **start, off_t offset, int l=
ength)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0)
-		return 0;
-
-	LIST_FIND(&ipt_target, print_target, struct ipt_target *,
-		  offset, buffer, length, &pos, &count);
-=09
-	up(&ipt_mutex);
-
-	*start =3D (char *)((unsigned long)count - offset);
-	return pos;
-}
-
-static int ipt_get_matches(char *buffer, char **start, off_t offset, int l=
ength)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&ipt_mutex) !=3D 0)
-		return 0;
-=09
-	LIST_FIND(&ipt_match, print_name, void *,
-		  offset, buffer, length, &pos, &count);
-
-	up(&ipt_mutex);
-
-	*start =3D (char *)((unsigned long)count - offset);
-	return pos;
-}
-
-static struct { char *name; get_info_t *get_info; } ipt_proc_entry[] =3D
-{ { "ip_tables_names", ipt_get_tables },
-  { "ip_tables_targets", ipt_get_targets },
-  { "ip_tables_matches", ipt_get_matches },
-  { NULL, NULL} };
-#endif /*CONFIG_PROC_FS*/
-
 static int __init init(void)
 {
 	int ret;
=20
+	xt_proto_init(AF_INET);
+
 	/* Noone else will be downing sem now, so we won't sleep */
-	down(&ipt_mutex);
-	list_append(&ipt_target, &ipt_standard_target);
-	list_append(&ipt_target, &ipt_error_target);
-	list_append(&ipt_match, &tcp_matchstruct);
-	list_append(&ipt_match, &udp_matchstruct);
-	list_append(&ipt_match, &icmp_matchstruct);
-	up(&ipt_mutex);
+	xt_register_target(AF_INET, &ipt_standard_target);
+	xt_register_target(AF_INET, &ipt_error_target);
+	xt_register_match(AF_INET, &tcp_matchstruct);
+	xt_register_match(AF_INET, &udp_matchstruct);
+	xt_register_match(AF_INET, &icmp_matchstruct);
=20
 	/* Register setsockopt */
 	ret =3D nf_register_sockopt(&ipt_sockopts);
@@ -1914,25 +1662,6 @@ static int __init init(void)
 		return ret;
 	}
=20
-#ifdef CONFIG_PROC_FS
-	{
-	struct proc_dir_entry *proc;
-	int i;
-
-	for (i =3D 0; ipt_proc_entry[i].name; i++) {
-		proc =3D proc_net_create(ipt_proc_entry[i].name, 0,
-				       ipt_proc_entry[i].get_info);
-		if (!proc) {
-			while (--i >=3D 0)
-				proc_net_remove(ipt_proc_entry[i].name);
-			nf_unregister_sockopt(&ipt_sockopts);
-			return -ENOMEM;
-		}
-		proc->owner =3D THIS_MODULE;
-	}
-	}
-#endif
-
 	printk("ip_tables: (C) 2000-2002 Netfilter core team\n");
 	return 0;
 }
@@ -1940,23 +1669,18 @@ static int __init init(void)
 static void __exit fini(void)
 {
 	nf_unregister_sockopt(&ipt_sockopts);
-#ifdef CONFIG_PROC_FS
-	{
-	int i;
-	for (i =3D 0; ipt_proc_entry[i].name; i++)
-		proc_net_remove(ipt_proc_entry[i].name);
-	}
-#endif
+
+	xt_unregister_match(AF_INET, &icmp_matchstruct);
+	xt_unregister_match(AF_INET, &udp_matchstruct);
+	xt_unregister_match(AF_INET, &tcp_matchstruct);
+	xt_unregister_target(AF_INET, &ipt_error_target);
+	xt_unregister_target(AF_INET, &ipt_standard_target);
+
+	xt_proto_fini(AF_INET);
 }
=20
 EXPORT_SYMBOL(ipt_register_table);
 EXPORT_SYMBOL(ipt_unregister_table);
-EXPORT_SYMBOL(ipt_register_match);
-EXPORT_SYMBOL(ipt_unregister_match);
 EXPORT_SYMBOL(ipt_do_table);
-EXPORT_SYMBOL(ipt_register_target);
-EXPORT_SYMBOL(ipt_unregister_target);
-EXPORT_SYMBOL(ipt_find_target);
-
 module_init(init);
 module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_CLASSIFY.c b/net/ipv4/netfilter/ipt_CLA=
SSIFY.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_CLASSIFY.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * This is a module which is used for setting the skb->priority field
- * of an skb for qdisc classification.
- */
-
-/* (C) 2001-2002 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_CLASSIFY.h>
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("iptables qdisc classification target module");
-
-static unsigned int
-target(struct sk_buff **pskb,
-       const struct net_device *in,
-       const struct net_device *out,
-       unsigned int hooknum,
-       const void *targinfo,
-       void *userinfo)
-{
-	const struct ipt_classify_target_info *clinfo =3D targinfo;
-
-	if((*pskb)->priority !=3D clinfo->priority)=20
-		(*pskb)->priority =3D clinfo->priority;
-
-	return IPT_CONTINUE;
-}
-
-static int
-checkentry(const char *tablename,
-           const struct ipt_entry *e,
-           void *targinfo,
-           unsigned int targinfosize,
-           unsigned int hook_mask)
-{
-	if (targinfosize !=3D IPT_ALIGN(sizeof(struct ipt_classify_target_info))){
-		printk(KERN_ERR "CLASSIFY: invalid size (%u !=3D %Zu).\n",
-		       targinfosize,
-		       IPT_ALIGN(sizeof(struct ipt_classify_target_info)));
-		return 0;
-	}
-=09
-	if (hook_mask & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_FORWARD) |
-	                  (1 << NF_IP_POST_ROUTING))) {
-		printk(KERN_ERR "CLASSIFY: only valid in LOCAL_OUT, FORWARD "
-		                "and POST_ROUTING.\n");
-		return 0;
-	}
-
-	if (strcmp(tablename, "mangle") !=3D 0) {
-		printk(KERN_ERR "CLASSIFY: can only be called from "
-		                "\"mangle\" table, not \"%s\".\n",
-		                tablename);
-		return 0;
-	}
-
-	return 1;
-}
-
-static struct ipt_target ipt_classify_reg =3D {=20
-	.name 		=3D "CLASSIFY",=20
-	.target 	=3D target,
-	.checkentry	=3D checkentry,
-	.me 		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_target(&ipt_classify_reg);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_target(&ipt_classify_reg);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_comment.c b/net/ipv4/netfilter/ipt_comm=
ent.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_comment.c
+++ /dev/null
@@ -1,59 +0,0 @@
-/*
- * Implements a dummy match to allow attaching comments to rules
- *
- * 2003-05-13 Brad Fisher (brad@info-link.net)
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_comment.h>
-
-MODULE_AUTHOR("Brad Fisher <brad@info-link.net>");
-MODULE_DESCRIPTION("iptables comment match module");
-MODULE_LICENSE("GPL");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-	/* We always match */
-	return 1;
-}
-
-static int
-checkentry(const char *tablename,
-           const struct ipt_ip *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	/* Check the size */
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_comment_info)))
-		return 0;
-	return 1;
-}
-
-static struct ipt_match comment_match =3D {
-	.name		=3D "comment",
-	.match		=3D match,
-	.checkentry	=3D checkentry,
-	.me		=3D THIS_MODULE
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&comment_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&comment_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_dccp.c b/net/ipv4/netfilter/ipt_dccp.c
--- a/net/ipv4/netfilter/ipt_dccp.c
+++ b/net/ipv4/netfilter/ipt_dccp.c
@@ -119,11 +119,12 @@ match(const struct sk_buff *skb,
=20
 static int
 checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *inf,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
+	const struct ipt_ip *ip =3D inf;
 	const struct ipt_dccp_info *info;
=20
 	info =3D (const struct ipt_dccp_info *)matchinfo;
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_ha=
shlimit.c
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -504,7 +504,7 @@ hashlimit_match(const struct sk_buff *sk
=20
 static int
 hashlimit_checkentry(const char *tablename,
-		     const struct ipt_ip *ip,
+		     const void *inf,
 		     void *matchinfo,
 		     unsigned int matchsize,
 		     unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_helper.c b/net/ipv4/netfilter/ipt_helpe=
r.c
--- a/net/ipv4/netfilter/ipt_helper.c
+++ b/net/ipv4/netfilter/ipt_helper.c
@@ -74,7 +74,7 @@ out_unlock:
 }
=20
 static int check(const char *tablename,
-		 const struct ipt_ip *ip,
+		 const void *inf,
 		 void *matchinfo,
 		 unsigned int matchsize,
 		 unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_ipra=
nge.c
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -63,7 +63,7 @@ match(const struct sk_buff *skb,
 }
=20
 static int check(const char *tablename,
-		 const struct ipt_ip *ip,
+		 const void *inf,
 		 void *matchinfo,
 		 unsigned int matchsize,
 		 unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_length.c b/net/ipv4/netfilter/ipt_lengt=
h.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_length.c
+++ /dev/null
@@ -1,64 +0,0 @@
-/* Kernel module to match packet length. */
-/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-
-#include <linux/netfilter_ipv4/ipt_length.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
-MODULE_DESCRIPTION("IP tables packet length matching module");
-MODULE_LICENSE("GPL");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-	const struct ipt_length_info *info =3D matchinfo;
-	u_int16_t pktlen =3D ntohs(skb->nh.iph->tot_len);
-=09
-	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->invert;
-}
-
-static int
-checkentry(const char *tablename,
-           const struct ipt_ip *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_length_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ipt_match length_match =3D {
-	.name		=3D "length",
-	.match		=3D &match,
-	.checkentry	=3D &checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&length_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&length_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_limit.c b/net/ipv4/netfilter/ipt_limit.c
--- a/net/ipv4/netfilter/ipt_limit.c
+++ b/net/ipv4/netfilter/ipt_limit.c
@@ -103,7 +103,7 @@ user2credits(u_int32_t user)
=20
 static int
 ipt_limit_checkentry(const char *tablename,
-		     const struct ipt_ip *ip,
+		     const void *inf,
 		     void *matchinfo,
 		     unsigned int matchsize,
 		     unsigned int hook_mask)
diff --git a/net/ipv4/netfilter/ipt_mac.c b/net/ipv4/netfilter/ipt_mac.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_mac.c
+++ /dev/null
@@ -1,79 +0,0 @@
-/* Kernel module to match MAC address parameters. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/if_ether.h>
-
-#include <linux/netfilter_ipv4/ipt_mac.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables mac matching module");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-    const struct ipt_mac_info *info =3D matchinfo;
-
-    /* Is mac pointer valid? */
-    return (skb->mac.raw >=3D skb->head
-	    && (skb->mac.raw + ETH_HLEN) <=3D skb->data
-	    /* If so, compare... */
-	    && ((memcmp(eth_hdr(skb)->h_source, info->srcaddr, ETH_ALEN)
-		=3D=3D 0) ^ info->invert));
-}
-
-static int
-ipt_mac_checkentry(const char *tablename,
-		   const struct ipt_ip *ip,
-		   void *matchinfo,
-		   unsigned int matchsize,
-		   unsigned int hook_mask)
-{
-	/* FORWARD isn't always valid, but it's nice to be able to do --RR */
-	if (hook_mask
-	    & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN)
-		| (1 << NF_IP_FORWARD))) {
-		printk("ipt_mac: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
-		return 0;
-	}
-
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_mac_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ipt_match mac_match =3D {
-	.name		=3D "mac",
-	.match		=3D &match,
-	.checkentry	=3D &ipt_mac_checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&mac_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&mac_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_pkttype.c b/net/ipv4/netfilter/ipt_pktt=
ype.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_pkttype.c
+++ /dev/null
@@ -1,70 +0,0 @@
-/* (C) 1999-2001 Michal Ludvig <michal@logix.cz>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-
-#include <linux/netfilter_ipv4/ipt_pkttype.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Michal Ludvig <michal@logix.cz>");
-MODULE_DESCRIPTION("IP tables match to match on linklayer packet type");
-
-static int match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-    const struct ipt_pkttype_info *info =3D matchinfo;
-
-    return (skb->pkt_type =3D=3D info->pkttype) ^ info->invert;
-}
-
-static int checkentry(const char *tablename,
-		   const struct ipt_ip *ip,
-		   void *matchinfo,
-		   unsigned int matchsize,
-		   unsigned int hook_mask)
-{
-/*
-	if (hook_mask
-	    & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN)
-		| (1 << NF_IP_FORWARD))) {
-		printk("ipt_pkttype: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n"=
);
-		return 0;
-	}
-*/
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_pkttype_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ipt_match pkttype_match =3D {
-	.name		=3D "pkttype",
-	.match		=3D &match,
-	.checkentry	=3D &checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&pkttype_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&pkttype_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_realm.c b/net/ipv4/netfilter/ipt_realm.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_realm.c
+++ /dev/null
@@ -1,76 +0,0 @@
-/* IP tables module for matching the routing realm
- *
- * $Id: ipt_realm.c,v 1.3 2004/03/05 13:25:40 laforge Exp $
- *
- * (C) 2003 by Sampsa Ranta <sampsa@netsonic.fi>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <net/route.h>
-
-#include <linux/netfilter_ipv4/ipt_realm.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-MODULE_AUTHOR("Sampsa Ranta <sampsa@netsonic.fi>");
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("iptables realm match");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-	const struct ipt_realm_info *info =3D matchinfo;
-	struct dst_entry *dst =3D skb->dst;
-   =20
-	return (info->id =3D=3D (dst->tclassid & info->mask)) ^ info->invert;
-}
-
-static int check(const char *tablename,
-                 const struct ipt_ip *ip,
-                 void *matchinfo,
-                 unsigned int matchsize,
-                 unsigned int hook_mask)
-{
-	if (hook_mask
-	    & ~((1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
-	        (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN))) {
-		printk("ipt_realm: only valid for POST_ROUTING, LOCAL_OUT, "
-		       "LOCAL_IN or FORWARD.\n");
-		return 0;
-	}
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_realm_info))) {
-		printk("ipt_realm: invalid matchsize.\n");
-		return 0;
-	}
-	return 1;
-}
-
-static struct ipt_match realm_match =3D {
-	.name		=3D "realm",
-	.match		=3D match,=20
-	.checkentry	=3D check,
-	.me		=3D THIS_MODULE
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&realm_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&realm_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_sctp.c b/net/ipv4/netfilter/ipt_sctp.c
--- a/net/ipv4/netfilter/ipt_sctp.c
+++ b/net/ipv4/netfilter/ipt_sctp.c
@@ -152,12 +152,13 @@ match(const struct sk_buff *skb,
=20
 static int
 checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
+	   const void *inf,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
 	const struct ipt_sctp_info *info;
+	const struct ipt_ip *ip =3D inf;
=20
 	info =3D (const struct ipt_sctp_info *)matchinfo;
=20
diff --git a/net/ipv4/netfilter/ipt_state.c b/net/ipv4/netfilter/ipt_state.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_state.c
+++ /dev/null
@@ -1,74 +0,0 @@
-/* Kernel module to match connection tracking information. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_state.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
-MODULE_DESCRIPTION("iptables connection tracking state match module");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-	const struct ipt_state_info *sinfo =3D matchinfo;
-	enum ip_conntrack_info ctinfo;
-	unsigned int statebit;
-
-	if (skb->nfct =3D=3D &ip_conntrack_untracked.ct_general)
-		statebit =3D IPT_STATE_UNTRACKED;
-	else if (!ip_conntrack_get(skb, &ctinfo))
-		statebit =3D IPT_STATE_INVALID;
-	else
-		statebit =3D IPT_STATE_BIT(ctinfo);
-
-	return (sinfo->statemask & statebit);
-}
-
-static int check(const char *tablename,
-		 const struct ipt_ip *ip,
-		 void *matchinfo,
-		 unsigned int matchsize,
-		 unsigned int hook_mask)
-{
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_state_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ipt_match state_match =3D {
-	.name		=3D "state",
-	.match		=3D &match,
-	.checkentry	=3D &check,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	need_ip_conntrack();
-	return ipt_register_match(&state_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&state_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv4/netfilter/ipt_string.c b/net/ipv4/netfilter/ipt_strin=
g.c
deleted file mode 100644
--- a/net/ipv4/netfilter/ipt_string.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/* String matching match for iptables
- *=20
- * (C) 2005 Pablo Neira Ayuso <pablo@eurodev.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_string.h>
-#include <linux/textsearch.h>
-
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@eurodev.net>");
-MODULE_DESCRIPTION("IP tables string match module");
-MODULE_LICENSE("GPL");
-
-static int match(const struct sk_buff *skb,
-		 const struct net_device *in,
-		 const struct net_device *out,
-		 const void *matchinfo,
-		 int offset,
-		 int *hotdrop)
-{
-	struct ts_state state;
-	struct ipt_string_info *conf =3D (struct ipt_string_info *) matchinfo;
-
-	memset(&state, 0, sizeof(struct ts_state));
-
-	return (skb_find_text((struct sk_buff *)skb, conf->from_offset,=20
-			     conf->to_offset, conf->config, &state)=20
-			     !=3D UINT_MAX) && !conf->invert;
-}
-
-#define STRING_TEXT_PRIV(m) ((struct ipt_string_info *) m)
-
-static int checkentry(const char *tablename,
-		      const struct ipt_ip *ip,
-		      void *matchinfo,
-		      unsigned int matchsize,
-		      unsigned int hook_mask)
-{
-	struct ipt_string_info *conf =3D matchinfo;
-	struct ts_config *ts_conf;
-
-	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_string_info)))
-		return 0;
-
-	/* Damn, can't handle this case properly with iptables... */
-	if (conf->from_offset > conf->to_offset)
-		return 0;
-
-	ts_conf =3D textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
-				     GFP_KERNEL, TS_AUTOLOAD);
-	if (IS_ERR(ts_conf))
-		return 0;
-
-	conf->config =3D ts_conf;
-
-	return 1;
-}
-
-static void destroy(void *matchinfo, unsigned int matchsize)
-{
-	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
-}
-
-static struct ipt_match string_match =3D {
-	.name 		=3D "string",
-	.match 		=3D match,
-	.checkentry	=3D checkentry,
-	.destroy 	=3D destroy,
-	.me 		=3D THIS_MODULE
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&string_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&string_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -31,6 +31,7 @@ config IP6_NF_QUEUE
=20
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering/masq/NAT)"
+	depends on NETFILTER_XTABLES
 	help
 	  ip6tables is a general, extensible packet identification framework.
 	  Currently only the packet filtering and packet mangling subsystem
@@ -41,23 +42,18 @@ config IP6_NF_IPTABLES
=20
 # The simple matches.
 config IP6_NF_MATCH_LIMIT
-	tristate "limit match support"
-	depends on IP6_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_LIMIT
 	help
-	  limit matching allows you to control the rate at which a rule can be
-	  matched: mainly useful in combination with the LOG target ("LOG
-	  target support", below) and to avoid some Denial of Service attacks.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP6_NF_MATCH_MAC
-	tristate "MAC address match support"
-	depends on IP6_NF_IPTABLES
+	tristate
+	select NETFILTER_XT_MATCH_MAC
+	default n
 	help
-	  mac matching allows you to match packets based on the source
-	  Ethernet address of the packet.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables match based on the old value
=20
 config IP6_NF_MATCH_RT
 	tristate "Routing header match support"
@@ -116,14 +112,11 @@ config IP6_NF_MATCH_OWNER
=20
 #  dep_tristate '  MAC address match support' CONFIG_IP6_NF_MATCH_MAC $CON=
FIG_IP6_NF_IPTABLES
 config IP6_NF_MATCH_MARK
-	tristate "netfilter MARK match support"
-	depends on IP6_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_MARK
 	help
-	  Netfilter mark matching allows you to match packets based on the
-	  `nfmark' value in the packet.  This can be set by the MARK target
-	  (see below).
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables extension based on the old value
=20
 config IP6_NF_MATCH_IPV6HEADER
 	tristate "IPv6 Extension Headers Match"
@@ -143,13 +136,11 @@ config IP6_NF_MATCH_AHESP
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP6_NF_MATCH_LENGTH
-	tristate "Packet Length match support"
-	depends on IP6_NF_IPTABLES
+	tristate
+	select NETFILTER_XT_MATCH_LENGTH
+	default n
 	help
-	  This option allows you to match the length of a packet against a
-	  specific value or range of values.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables extension based on the old value
=20
 config IP6_NF_MATCH_EUI64
 	tristate "EUI64 address check"
@@ -162,13 +153,11 @@ config IP6_NF_MATCH_EUI64
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP6_NF_MATCH_PHYSDEV
-	tristate "Physdev match support"
-	depends on IP6_NF_IPTABLES && BRIDGE_NETFILTER
+	tristate
+	default n
+	select NETFILTER_XT_MATCH_PHYSDEV
 	help
-	  Physdev packet matching matches against the physical bridge ports
-	  the IP packet arrived on or will leave by.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables extension based on the old value
=20
 #  dep_tristate '  Multiple port match support' CONFIG_IP6_NF_MATCH_MULTIP=
ORT $CONFIG_IP6_NF_IPTABLES
 #  dep_tristate '  TOS match support' CONFIG_IP6_NF_MATCH_TOS $CONFIG_IP6_=
NF_IPTABLES
@@ -210,15 +199,11 @@ config IP6_NF_TARGET_REJECT
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
 config IP6_NF_TARGET_NFQUEUE
-	tristate "NFQUEUE Target Support"
-	depends on IP_NF_IPTABLES
+	tristate
+	default n
+	select NETFILTER_XT_TARGET_NFQUEUE
 	help
-	  This Target replaced the old obsolete QUEUE target.
-
-	  As opposed to QUEUE, it supports 65535 different queues,
-	  not just one.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables extension based on the old value
=20
 #  if [ "$CONFIG_IP6_NF_FILTER" !=3D "n" ]; then
 #    dep_tristate '    REJECT target support' CONFIG_IP6_NF_TARGET_REJECT =
$CONFIG_IP6_NF_FILTER
@@ -238,17 +223,11 @@ config IP6_NF_MANGLE
=20
 #    dep_tristate '    TOS target support' CONFIG_IP6_NF_TARGET_TOS $CONFI=
G_IP_NF_MANGLE
 config IP6_NF_TARGET_MARK
-	tristate "MARK target support"
-	depends on IP6_NF_MANGLE
+	tristate
+	default n
+	select NETFILTER_XT_TARGET_MARK
 	help
-	  This option adds a `MARK' target, which allows you to create rules
-	  in the `mangle' table which alter the netfilter mark (nfmark) field
-	  associated with the packet packet prior to routing. This can change
-	  the routing method (see `Use netfilter MARK value as routing
-	  key') and can also be used by other subsystems to change their
-	  behavior.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  automatically select new xtables extension based on the old value
=20
 config IP6_NF_TARGET_HL
 	tristate  'HL (hoplimit) target support'
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,10 +4,7 @@
=20
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) +=3D ip6_tables.o
-obj-$(CONFIG_IP6_NF_MATCH_LIMIT) +=3D ip6t_limit.o
-obj-$(CONFIG_IP6_NF_MATCH_MARK) +=3D ip6t_mark.o
 obj-$(CONFIG_IP6_NF_MATCH_LENGTH) +=3D ip6t_length.o
-obj-$(CONFIG_IP6_NF_MATCH_MAC) +=3D ip6t_mac.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) +=3D ip6t_rt.o
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) +=3D ip6t_hbh.o ip6t_dst.o
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) +=3D ip6t_ipv6header.o
@@ -16,12 +13,9 @@ obj-$(CONFIG_IP6_NF_MATCH_AHESP) +=3D ip6t
 obj-$(CONFIG_IP6_NF_MATCH_EUI64) +=3D ip6t_eui64.o
 obj-$(CONFIG_IP6_NF_MATCH_MULTIPORT) +=3D ip6t_multiport.o
 obj-$(CONFIG_IP6_NF_MATCH_OWNER) +=3D ip6t_owner.o
-obj-$(CONFIG_IP6_NF_MATCH_PHYSDEV) +=3D ip6t_physdev.o
 obj-$(CONFIG_IP6_NF_FILTER) +=3D ip6table_filter.o
 obj-$(CONFIG_IP6_NF_MANGLE) +=3D ip6table_mangle.o
-obj-$(CONFIG_IP6_NF_TARGET_MARK) +=3D ip6t_MARK.o
 obj-$(CONFIG_IP6_NF_TARGET_HL) +=3D ip6t_HL.o
-obj-$(CONFIG_IP6_NF_TARGET_NFQUEUE) +=3D ip6t_NFQUEUE.o
 obj-$(CONFIG_IP6_NF_QUEUE) +=3D ip6_queue.o
 obj-$(CONFIG_IP6_NF_TARGET_LOG) +=3D ip6t_LOG.o
 obj-$(CONFIG_IP6_NF_RAW) +=3D ip6table_raw.o
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_table=
s.c
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2,7 +2,7 @@
  * Packet matching code.
  *
  * Copyright (C) 1999 Paul `Rusty' Russell & Michael J. Neuling
- * Copyright (C) 2000-2005 Netfilter Core Team <coreteam@netfilter.org>
+ * Copyright (C) 2000-2002 Netfilter core team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -23,12 +23,14 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/icmpv6.h>
+#include <net/ip.h>
 #include <net/ipv6.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <linux/proc_fs.h>
=20
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/x_tables.h>
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
@@ -65,11 +67,7 @@ do {								\
 #endif
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
=20
-static DECLARE_MUTEX(ip6t_mutex);
=20
-/* Must have mutex */
-#define ASSERT_READ_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) !=3D 0)
-#define ASSERT_WRITE_LOCK(x) IP_NF_ASSERT(down_trylock(&ip6t_mutex) !=3D 0)
 #include <linux/netfilter_ipv4/listhelp.h>
=20
 #if 0
@@ -78,12 +76,13 @@ static DECLARE_MUTEX(ip6t_mutex);
 #define inline
 #endif
=20
-/*
+/* Locking is simple: we assume at worst case there will be one packet
+   in user context and one from bottom halves (or soft irq if Alexey's
+   softnet patch was applied).
+
    We keep a set of rules for each CPU, so we can avoid write-locking
-   them in the softirq when updating the counters and therefore
-   only need to read-lock in the softirq; doing a write_lock_bh() in user
-   context stops packets coming through and allows user context to read
-   the counters or update the rules.
+   them; doing a readlock_bh() stops packets coming through if we're
+   in user context.
=20
    To be cache friendly on SMP, we arrange them like so:
    [ n-entries ]
@@ -110,9 +109,6 @@ struct ip6t_table_info
 	char entries[0] ____cacheline_aligned;
 };
=20
-static LIST_HEAD(ip6t_target);
-static LIST_HEAD(ip6t_match);
-static LIST_HEAD(ip6t_tables);
 #define ADD_COUNTER(c,b,p) do { (c).bcnt +=3D (b); (c).pcnt +=3D (p); } wh=
ile(0)
=20
 #ifdef CONFIG_SMP
@@ -353,7 +349,7 @@ ip6t_do_table(struct sk_buff **pskb,
 	      struct ip6t_table *table,
 	      void *userdata)
 {
-	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(lon=
g))));
+	static const char nulldevname[IFNAMSIZ];
 	int offset =3D 0;
 	unsigned int protoff =3D 0;
 	int hotdrop =3D 0;
@@ -362,10 +358,12 @@ ip6t_do_table(struct sk_buff **pskb,
 	const char *indev, *outdev;
 	void *table_base;
 	struct ip6t_entry *e, *back;
+	struct ip6t_table_info *private;
=20
 	/* Initialization */
 	indev =3D in ? in->name : nulldevname;
 	outdev =3D out ? out->name : nulldevname;
+
 	/* We handle fragments by dealing with the first fragment as
 	 * if it was a normal packet.  All other fragments are treated
 	 * normally, except that they will NEVER match rules that ask
@@ -374,10 +372,11 @@ ip6t_do_table(struct sk_buff **pskb,
 	 * match it. */
=20
 	read_lock_bh(&table->lock);
+	private =3D table->private;
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
-	table_base =3D (void *)table->private->entries
-		+ TABLE_OFFSET(table->private, smp_processor_id());
-	e =3D get_entry(table_base, table->private->hook_entry[hook]);
+	table_base =3D (void *)private->entries
+		+ TABLE_OFFSET(private, smp_processor_id());
+	e =3D get_entry(table_base, private->hook_entry[hook]);
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	/* Check noone else using our table */
@@ -393,7 +392,7 @@ ip6t_do_table(struct sk_buff **pskb,
 #endif
=20
 	/* For return from builtin chain */
-	back =3D get_entry(table_base, table->private->underflow[hook]);
+	back =3D get_entry(table_base, private->underflow[hook]);
=20
 	do {
 		IP_NF_ASSERT(e);
@@ -493,145 +492,6 @@ ip6t_do_table(struct sk_buff **pskb,
 #endif
 }
=20
-/*
- * These are weird, but module loading must not be done with mutex
- * held (since they will register), and we have to have a single
- * function to use try_then_request_module().
- */
-
-/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
-static inline struct ip6t_table *find_table_lock(const char *name)
-{
-	struct ip6t_table *t;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &ip6t_tables, list)
-		if (strcmp(t->name, name) =3D=3D 0 && try_module_get(t->me))
-			return t;
-	up(&ip6t_mutex);
-	return NULL;
-}
-
-/* Find match, grabs ref.  Returns ERR_PTR() on error. */
-static inline struct ip6t_match *find_match(const char *name, u8 revision)
-{
-	struct ip6t_match *m;
-	int err =3D 0;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(m, &ip6t_match, list) {
-		if (strcmp(m->name, name) =3D=3D 0) {
-			if (m->revision =3D=3D revision) {
-				if (try_module_get(m->me)) {
-					up(&ip6t_mutex);
-					return m;
-				}
-			} else
-				err =3D -EPROTOTYPE; /* Found something. */
-		}
-	}
-	up(&ip6t_mutex);
-	return ERR_PTR(err);
-}
-
-/* Find target, grabs ref.  Returns ERR_PTR() on error. */
-static inline struct ip6t_target *find_target(const char *name, u8 revisio=
n)
-{
-	struct ip6t_target *t;
-	int err =3D 0;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0)
-		return ERR_PTR(-EINTR);
-
-	list_for_each_entry(t, &ip6t_target, list) {
-		if (strcmp(t->name, name) =3D=3D 0) {
-			if (t->revision =3D=3D revision) {
-				if (try_module_get(t->me)) {
-					up(&ip6t_mutex);
-					return t;
-				}
-			} else
-				err =3D -EPROTOTYPE; /* Found something. */
-		}
-	}
-	up(&ip6t_mutex);
-	return ERR_PTR(err);
-}
-
-struct ip6t_target *ip6t_find_target(const char *name, u8 revision)
-{
-	struct ip6t_target *target;
-
-	target =3D try_then_request_module(find_target(name, revision),
-					 "ip6t_%s", name);
-	if (IS_ERR(target) || !target)
-		return NULL;
-	return target;
-}
-
-static int match_revfn(const char *name, u8 revision, int *bestp)
-{
-	struct ip6t_match *m;
-	int have_rev =3D 0;
-
-	list_for_each_entry(m, &ip6t_match, list) {
-		if (strcmp(m->name, name) =3D=3D 0) {
-			if (m->revision > *bestp)
-				*bestp =3D m->revision;
-			if (m->revision =3D=3D revision)
-				have_rev =3D 1;
-		}
-	}
-	return have_rev;
-}
-
-static int target_revfn(const char *name, u8 revision, int *bestp)
-{
-	struct ip6t_target *t;
-	int have_rev =3D 0;
-
-	list_for_each_entry(t, &ip6t_target, list) {
-		if (strcmp(t->name, name) =3D=3D 0) {
-			if (t->revision > *bestp)
-				*bestp =3D t->revision;
-			if (t->revision =3D=3D revision)
-				have_rev =3D 1;
-		}
-	}
-	return have_rev;
-}
-
-/* Returns true or fals (if no such extension at all) */
-static inline int find_revision(const char *name, u8 revision,
-				int (*revfn)(const char *, u8, int *),
-				int *err)
-{
-	int have_rev, best =3D -1;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0) {
-		*err =3D -EINTR;
-		return 1;
-	}
-	have_rev =3D revfn(name, revision, &best);
-	up(&ip6t_mutex);
-
-	/* Nothing at all?  Return 0 to try loading module. */
-	if (best =3D=3D -1) {
-		*err =3D -ENOENT;
-		return 0;
-	}
-
-	*err =3D best;
-	if (!have_rev)
-		*err =3D -EPROTONOSUPPORT;
-	return 1;
-}
-
-
 /* All zeroes =3D=3D unconditional rule. */
 static inline int
 unconditional(const struct ip6t_ip6 *ipv6)
@@ -793,11 +653,11 @@ check_match(struct ip6t_entry_match *m,
 {
 	struct ip6t_match *match;
=20
-	match =3D try_then_request_module(find_match(m->u.user.name,
-						   m->u.user.revision),
+	match =3D try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
+			      		m->u.user.revision),
 					"ip6t_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
-		duprintf("check_match: `%s' not found\n", m->u.user.name);
+	  	duprintf("check_match: `%s' not found\n", m->u.user.name);
 		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match =3D match;
@@ -838,8 +698,9 @@ check_entry(struct ip6t_entry *e, const=20
 		goto cleanup_matches;
=20
 	t =3D ip6t_get_target(e);
-	target =3D try_then_request_module(find_target(t->u.user.name,
-						     t->u.user.revision),
+	target =3D try_then_request_module(xt_find_target(AF_INET6,
+							t->u.user.name,
+							t->u.user.revision),
 					 "ip6t_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
@@ -1022,7 +883,7 @@ replace_table(struct ip6t_table *table,
 	      struct ip6t_table_info *newinfo,
 	      int *error)
 {
-	struct ip6t_table_info *oldinfo;
+	struct ip6t_table_info *oldinfo, *private;
=20
 #ifdef CONFIG_NETFILTER_DEBUG
 	{
@@ -1041,15 +902,16 @@ replace_table(struct ip6t_table *table,
=20
 	/* Do the substitution. */
 	write_lock_bh(&table->lock);
+	private =3D table->private;
 	/* Check inside lock: is the old number correct? */
-	if (num_counters !=3D table->private->number) {
+	if (num_counters !=3D private->number) {
 		duprintf("num_counters !=3D table->private->number (%u/%u)\n",
-			 num_counters, table->private->number);
+			 num_counters, private->number);
 		write_unlock_bh(&table->lock);
 		*error =3D -EAGAIN;
 		return NULL;
 	}
-	oldinfo =3D table->private;
+	oldinfo =3D private;
 	table->private =3D newinfo;
 	newinfo->initial_entries =3D oldinfo->initial_entries;
 	write_unlock_bh(&table->lock);
@@ -1094,12 +956,13 @@ copy_entries_to_user(unsigned int total_
 	unsigned int off, num, countersize;
 	struct ip6t_entry *e;
 	struct ip6t_counters *counters;
+	struct ip6t_table_info *private =3D table->private;
 	int ret =3D 0;
=20
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
 	   about). */
-	countersize =3D sizeof(struct ip6t_counters) * table->private->number;
+	countersize =3D sizeof(struct ip6t_counters) * private->number;
 	counters =3D vmalloc(countersize);
=20
 	if (counters =3D=3D NULL)
@@ -1108,11 +971,11 @@ copy_entries_to_user(unsigned int total_
 	/* First, sum counters... */
 	memset(counters, 0, countersize);
 	write_lock_bh(&table->lock);
-	get_counters(table->private, counters);
+	get_counters(private, counters);
 	write_unlock_bh(&table->lock);
=20
 	/* ... then copy entire thing from CPU 0... */
-	if (copy_to_user(userptr, table->private->entries, total_size) !=3D 0) {
+	if (copy_to_user(userptr, private->entries, total_size) !=3D 0) {
 		ret =3D -EFAULT;
 		goto free_counters;
 	}
@@ -1124,7 +987,7 @@ copy_entries_to_user(unsigned int total_
 		struct ip6t_entry_match *m;
 		struct ip6t_entry_target *t;
=20
-		e =3D (struct ip6t_entry *)(table->private->entries + off);
+		e =3D (struct ip6t_entry *)(private->entries + off);
 		if (copy_to_user(userptr + off
 				 + offsetof(struct ip6t_entry, counters),
 				 &counters[num],
@@ -1172,21 +1035,20 @@ get_entries(const struct ip6t_get_entrie
 	int ret;
 	struct ip6t_table *t;
=20
-	t =3D find_table_lock(entries->name);
+	t =3D xt_find_table_lock(AF_INET6, entries->name);
 	if (t && !IS_ERR(t)) {
-		duprintf("t->private->number =3D %u\n",
-			 t->private->number);
-		if (entries->size =3D=3D t->private->size)
-			ret =3D copy_entries_to_user(t->private->size,
+		struct ip6t_table_info *private =3D t->private;
+		duprintf("t->private->number =3D %u\n", private->number);
+		if (entries->size =3D=3D private->size)
+			ret =3D copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 t->private->size,
-				 entries->size);
+				 private->size, entries->size);
 			ret =3D -EINVAL;
 		}
 		module_put(t->me);
-		up(&ip6t_mutex);
+		up(&xt_mutex[AF_INET6]);
 	} else
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
=20
@@ -1235,7 +1097,7 @@ do_replace(void __user *user, unsigned i
=20
 	duprintf("ip_tables: Translated table\n");
=20
-	t =3D try_then_request_module(find_table_lock(tmp.name),
+	t =3D try_then_request_module(xt_find_table_lock(AF_INET6, tmp.name),
 				    "ip6table_%s", tmp.name);
 	if (!t || IS_ERR(t)) {
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
@@ -1269,16 +1131,17 @@ do_replace(void __user *user, unsigned i
 	/* Decrease module usage counts and free resource */
 	IP6T_ENTRY_ITERATE(oldinfo->entries, oldinfo->size, cleanup_entry,NULL);
 	vfree(oldinfo);
+	/* Silent error: too late now. */
 	if (copy_to_user(tmp.counters, counters,
 			 sizeof(struct ip6t_counters) * tmp.num_counters) !=3D 0)
 		ret =3D -EFAULT;
 	vfree(counters);
-	up(&ip6t_mutex);
+	up(&xt_mutex[AF_INET6]);
 	return ret;
=20
  put_module:
 	module_put(t->me);
-	up(&ip6t_mutex);
+	up(&xt_mutex[AF_INET6]);
  free_newinfo_counters_untrans:
 	IP6T_ENTRY_ITERATE(newinfo->entries, newinfo->size, cleanup_entry,NULL);
  free_newinfo_counters:
@@ -1315,6 +1178,7 @@ do_add_counters(void __user *user, unsig
 {
 	unsigned int i;
 	struct ip6t_counters_info tmp, *paddc;
+	struct ip6t_table_info *private;
 	struct ip6t_table *t;
 	int ret =3D 0;
=20
@@ -1333,27 +1197,28 @@ do_add_counters(void __user *user, unsig
 		goto free;
 	}
=20
-	t =3D find_table_lock(tmp.name);
+	t =3D xt_find_table_lock(AF_INET6, tmp.name);
 	if (!t || IS_ERR(t)) {
 		ret =3D t ? PTR_ERR(t) : -ENOENT;
 		goto free;
 	}
=20
 	write_lock_bh(&t->lock);
-	if (t->private->number !=3D paddc->num_counters) {
+	private =3D t->private;
+	if (private->number !=3D paddc->num_counters) {
 		ret =3D -EINVAL;
 		goto unlock_up_free;
 	}
=20
 	i =3D 0;
-	IP6T_ENTRY_ITERATE(t->private->entries,
-			  t->private->size,
+	IP6T_ENTRY_ITERATE(private->entries,
+			  private->size,
 			  add_counter_to_entry,
 			  paddc->counters,
 			  &i);
  unlock_up_free:
 	write_unlock_bh(&t->lock);
-	up(&ip6t_mutex);
+	up(&xt_mutex[AF_INET6]);
 	module_put(t->me);
  free:
 	vfree(paddc);
@@ -1412,25 +1277,26 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 		}
 		name[IP6T_TABLE_MAXNAMELEN-1] =3D '\0';
=20
-		t =3D try_then_request_module(find_table_lock(name),
+		t =3D try_then_request_module(xt_find_table_lock(AF_INET6, name),
 					    "ip6table_%s", name);
 		if (t && !IS_ERR(t)) {
 			struct ip6t_getinfo info;
+			struct ip6t_table_info *private =3D t->private;
=20
 			info.valid_hooks =3D t->valid_hooks;
-			memcpy(info.hook_entry, t->private->hook_entry,
+			memcpy(info.hook_entry, private->hook_entry,
 			       sizeof(info.hook_entry));
-			memcpy(info.underflow, t->private->underflow,
+			memcpy(info.underflow, private->underflow,
 			       sizeof(info.underflow));
-			info.num_entries =3D t->private->number;
-			info.size =3D t->private->size;
+			info.num_entries =3D private->number;
+			info.size =3D private->size;
 			memcpy(info.name, name, sizeof(info.name));
=20
 			if (copy_to_user(user, &info, *len) !=3D 0)
 				ret =3D -EFAULT;
 			else
 				ret =3D 0;
-			up(&ip6t_mutex);
+			up(&xt_mutex[AF_INET6]);
 			module_put(t->me);
 		} else
 			ret =3D t ? PTR_ERR(t) : -ENOENT;
@@ -1457,7 +1323,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 	case IP6T_SO_GET_REVISION_MATCH:
 	case IP6T_SO_GET_REVISION_TARGET: {
 		struct ip6t_get_revision rev;
-		int (*revfn)(const char *, u8, int *);
+		int target;
=20
 		if (*len !=3D sizeof(rev)) {
 			ret =3D -EINVAL;
@@ -1469,12 +1335,13 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 		}
=20
 		if (cmd =3D=3D IP6T_SO_GET_REVISION_TARGET)
-			revfn =3D target_revfn;
+			target =3D 1;
 		else
-			revfn =3D match_revfn;
+			target =3D 0;
=20
-		try_then_request_module(find_revision(rev.name, rev.revision,
-						      revfn, &ret),
+		try_then_request_module(xt_find_revision(AF_INET6, rev.name,
+							 rev.revision,
+							 target, &ret),
 					"ip6t_%s", rev.name);
 		break;
 	}
@@ -1487,56 +1354,11 @@ do_ip6t_get_ctl(struct sock *sk, int cmd
 	return ret;
 }
=20
-/* Registration hooks for targets. */
-int
-ip6t_register_target(struct ip6t_target *target)
-{
-	int ret;
-
-	ret =3D down_interruptible(&ip6t_mutex);
-	if (ret !=3D 0)
-		return ret;
-	list_add(&target->list, &ip6t_target);
-	up(&ip6t_mutex);
-	return ret;
-}
-
-void
-ip6t_unregister_target(struct ip6t_target *target)
-{
-	down(&ip6t_mutex);
-	LIST_DELETE(&ip6t_target, target);
-	up(&ip6t_mutex);
-}
-
-int
-ip6t_register_match(struct ip6t_match *match)
-{
-	int ret;
-
-	ret =3D down_interruptible(&ip6t_mutex);
-	if (ret !=3D 0)
-		return ret;
-
-	list_add(&match->list, &ip6t_match);
-	up(&ip6t_mutex);
-
-	return ret;
-}
-
-void
-ip6t_unregister_match(struct ip6t_match *match)
-{
-	down(&ip6t_mutex);
-	LIST_DELETE(&ip6t_match, match);
-	up(&ip6t_mutex);
-}
-
 int ip6t_register_table(struct ip6t_table *table,
 			const struct ip6t_replace *repl)
 {
 	int ret;
-	struct ip6t_table_info *newinfo;
+	struct ip6t_table_info *newinfo, *private;
 	static struct ip6t_table_info bootstrap
 		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
=20
@@ -1557,14 +1379,14 @@ int ip6t_register_table(struct ip6t_tabl
 		return ret;
 	}
=20
-	ret =3D down_interruptible(&ip6t_mutex);
+	ret =3D down_interruptible(&xt_mutex[AF_INET6]);
 	if (ret !=3D 0) {
 		vfree(newinfo);
 		return ret;
 	}
=20
 	/* Don't autoload: we'd eat our tail... */
-	if (list_named_find(&ip6t_tables, table->name)) {
+	if (list_named_find(&xt_tables[AF_INET6], table->name)) {
 		ret =3D -EEXIST;
 		goto free_unlock;
 	}
@@ -1574,17 +1396,17 @@ int ip6t_register_table(struct ip6t_tabl
 	if (!replace_table(table, 0, newinfo, &ret))
 		goto free_unlock;
=20
-	duprintf("table->private->number =3D %u\n",
-		 table->private->number);
+	private =3D table->private;
+	duprintf("table->private->number =3D %u\n", private->number);
=20
 	/* save number of initial entries */
-	table->private->initial_entries =3D table->private->number;
+	private->initial_entries =3D private->number;
=20
 	rwlock_init(&table->lock);
-	list_prepend(&ip6t_tables, table);
+	list_prepend(&xt_tables[AF_INET6], table);
=20
  unlock:
-	up(&ip6t_mutex);
+	up(&xt_mutex[AF_INET6]);
 	return ret;
=20
  free_unlock:
@@ -1594,14 +1416,17 @@ int ip6t_register_table(struct ip6t_tabl
=20
 void ip6t_unregister_table(struct ip6t_table *table)
 {
-	down(&ip6t_mutex);
-	LIST_DELETE(&ip6t_tables, table);
-	up(&ip6t_mutex);
+	struct ip6t_table_info *private;
+
+	down(&xt_mutex[AF_INET6]);
+	private =3D table->private;
+	LIST_DELETE(&xt_tables[AF_INET6], table);
+	up(&xt_mutex[AF_INET6]);
=20
 	/* Decrease module usage counts and free resources */
-	IP6T_ENTRY_ITERATE(table->private->entries, table->private->size,
-			  cleanup_entry, NULL);
-	vfree(table->private);
+	IP6T_ENTRY_ITERATE(private->entries, private->size,
+			   cleanup_entry, NULL);
+	vfree(private);
 }
=20
 /* Returns 1 if the port is matched by the range, 0 otherwise */
@@ -1713,11 +1538,12 @@ tcp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 tcp_checkentry(const char *tablename,
-	       const struct ip6t_ip6 *ipv6,
+	       const void *entry,
 	       void *matchinfo,
 	       unsigned int matchsize,
 	       unsigned int hook_mask)
 {
+	const struct ip6t_ip6 *ipv6 =3D entry;
 	const struct ip6t_tcp *tcpinfo =3D matchinfo;
=20
 	/* Must specify proto =3D=3D TCP, and no unknown invflags */
@@ -1763,11 +1589,12 @@ udp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 udp_checkentry(const char *tablename,
-	       const struct ip6t_ip6 *ipv6,
+	       const void *entry,
 	       void *matchinfo,
 	       unsigned int matchinfosize,
 	       unsigned int hook_mask)
 {
+	const struct ip6t_ip6 *ipv6 =3D entry;
 	const struct ip6t_udp *udpinfo =3D matchinfo;
=20
 	/* Must specify proto =3D=3D UDP, and no unknown invflags */
@@ -1835,11 +1662,12 @@ icmp6_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 icmp6_checkentry(const char *tablename,
-	   const struct ip6t_ip6 *ipv6,
+	   const void *entry,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
+	const struct ip6t_ip6 *ipv6 =3D entry;
 	const struct ip6t_icmp *icmpinfo =3D matchinfo;
=20
 	/* Must specify proto =3D=3D ICMP, and no unknown invflags */
@@ -1887,146 +1715,35 @@ static struct ip6t_match icmp6_matchstru
 	.checkentry	=3D &icmp6_checkentry,
 };
=20
-#ifdef CONFIG_PROC_FS
-static inline int print_name(const char *i,
-			     off_t start_offset, char *buffer, int length,
-			     off_t *pos, unsigned int *count)
-{
-	if ((*count)++ >=3D start_offset) {
-		unsigned int namelen;
-
-		namelen =3D sprintf(buffer + *pos, "%s\n",
-				  i + sizeof(struct list_head));
-		if (*pos + namelen > length) {
-			/* Stop iterating */
-			return 1;
-		}
-		*pos +=3D namelen;
-	}
-	return 0;
-}
-
-static inline int print_target(const struct ip6t_target *t,
-                               off_t start_offset, char *buffer, int lengt=
h,
-                               off_t *pos, unsigned int *count)
-{
-	if (t =3D=3D &ip6t_standard_target || t =3D=3D &ip6t_error_target)
-		return 0;
-	return print_name((char *)t, start_offset, buffer, length, pos, count);
-}
-
-static int ip6t_get_tables(char *buffer, char **start, off_t offset, int l=
ength)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0)
-		return 0;
-
-	LIST_FIND(&ip6t_tables, print_name, char *,
-		  offset, buffer, length, &pos, &count);
-
-	up(&ip6t_mutex);
-
-	/* `start' hack - see fs/proc/generic.c line ~105 */
-	*start=3D(char *)((unsigned long)count-offset);
-	return pos;
-}
-
-static int ip6t_get_targets(char *buffer, char **start, off_t offset, int =
length)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0)
-		return 0;
-
-	LIST_FIND(&ip6t_target, print_target, struct ip6t_target *,
-		  offset, buffer, length, &pos, &count);
-
-	up(&ip6t_mutex);
-
-	*start =3D (char *)((unsigned long)count - offset);
-	return pos;
-}
-
-static int ip6t_get_matches(char *buffer, char **start, off_t offset, int =
length)
-{
-	off_t pos =3D 0;
-	unsigned int count =3D 0;
-
-	if (down_interruptible(&ip6t_mutex) !=3D 0)
-		return 0;
-
-	LIST_FIND(&ip6t_match, print_name, char *,
-		  offset, buffer, length, &pos, &count);
-
-	up(&ip6t_mutex);
-
-	*start =3D (char *)((unsigned long)count - offset);
-	return pos;
-}
-
-static struct { char *name; get_info_t *get_info; } ip6t_proc_entry[] =3D
-{ { "ip6_tables_names", ip6t_get_tables },
-  { "ip6_tables_targets", ip6t_get_targets },
-  { "ip6_tables_matches", ip6t_get_matches },
-  { NULL, NULL} };
-#endif /*CONFIG_PROC_FS*/
-
 static int __init init(void)
 {
 	int ret;
=20
+	xt_proto_init(AF_INET6);
+
 	/* Noone else will be downing sem now, so we won't sleep */
-	down(&ip6t_mutex);
-	list_append(&ip6t_target, &ip6t_standard_target);
-	list_append(&ip6t_target, &ip6t_error_target);
-	list_append(&ip6t_match, &tcp_matchstruct);
-	list_append(&ip6t_match, &udp_matchstruct);
-	list_append(&ip6t_match, &icmp6_matchstruct);
-	up(&ip6t_mutex);
+	xt_register_target(AF_INET6, &ip6t_standard_target);
+	xt_register_target(AF_INET6, &ip6t_error_target);
+	xt_register_match(AF_INET6, &tcp_matchstruct);
+	xt_register_match(AF_INET6, &udp_matchstruct);
+	xt_register_match(AF_INET6, &icmp6_matchstruct);
=20
 	/* Register setsockopt */
 	ret =3D nf_register_sockopt(&ip6t_sockopts);
 	if (ret < 0) {
 		duprintf("Unable to register sockopts.\n");
+		xt_proto_fini(AF_INET6);
 		return ret;
 	}
=20
-#ifdef CONFIG_PROC_FS
-	{
-		struct proc_dir_entry *proc;
-		int i;
-
-		for (i =3D 0; ip6t_proc_entry[i].name; i++) {
-			proc =3D proc_net_create(ip6t_proc_entry[i].name, 0,
-					       ip6t_proc_entry[i].get_info);
-			if (!proc) {
-				while (--i >=3D 0)
-				       proc_net_remove(ip6t_proc_entry[i].name);
-				nf_unregister_sockopt(&ip6t_sockopts);
-				return -ENOMEM;
-			}
-			proc->owner =3D THIS_MODULE;
-		}
-	}
-#endif
-
-	printk("ip6_tables: (C) 2000-2002 Netfilter core team\n");
+	printk("ip6_tables: (C) 2000-2005 Netfilter core team\n");
 	return 0;
 }
=20
 static void __exit fini(void)
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
-#ifdef CONFIG_PROC_FS
-	{
-		int i;
-		for (i =3D 0; ip6t_proc_entry[i].name; i++)
-			proc_net_remove(ip6t_proc_entry[i].name);
-	}
-#endif
+	xt_proto_fini(AF_INET6);
 }
=20
 /*
@@ -2083,10 +1800,6 @@ int ipv6_find_hdr(const struct sk_buff *
 EXPORT_SYMBOL(ip6t_register_table);
 EXPORT_SYMBOL(ip6t_unregister_table);
 EXPORT_SYMBOL(ip6t_do_table);
-EXPORT_SYMBOL(ip6t_register_match);
-EXPORT_SYMBOL(ip6t_unregister_match);
-EXPORT_SYMBOL(ip6t_register_target);
-EXPORT_SYMBOL(ip6t_unregister_target);
 EXPORT_SYMBOL(ip6t_ext_hdr);
 EXPORT_SYMBOL(ipv6_find_hdr);
=20
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -62,7 +62,7 @@ static unsigned int ip6t_hl_target(struc
 }
=20
 static int ip6t_hl_checkentry(const char *tablename,
-		const struct ip6t_entry *e,
+		const void *entry,
 		void *targinfo,
 		unsigned int targinfosize,
 		unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -443,7 +443,7 @@ ip6t_log_target(struct sk_buff **pskb,
=20
=20
 static int ip6t_log_checkentry(const char *tablename,
-			       const struct ip6t_entry *e,
+			       const void *entry,
 			       void *targinfo,
 			       unsigned int targinfosize,
 			       unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJ=
ECT.c
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -218,12 +218,13 @@ static unsigned int reject6_target(struc
 }
=20
 static int check(const char *tablename,
-		 const struct ip6t_entry *e,
+		 const void *entry,
 		 void *targinfo,
 		 unsigned int targinfosize,
 		 unsigned int hook_mask)
 {
  	const struct ip6t_reject_info *rejinfo =3D targinfo;
+	const struct ip6t_entry *e =3D entry;
=20
  	if (targinfosize !=3D IP6T_ALIGN(sizeof(struct ip6t_reject_info))) {
   		DEBUGP("ip6t_REJECT: targinfosize %u !=3D 0\n", targinfosize);
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -97,7 +97,7 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const struct ip6t_ip6 *ip,
+          const void *entry,
           void *matchinfo,
           unsigned int matchinfosize,
           unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_dst.c b/net/ipv6/netfilter/ip6t_dst.c
--- a/net/ipv6/netfilter/ip6t_dst.c
+++ b/net/ipv6/netfilter/ip6t_dst.c
@@ -178,7 +178,7 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const struct ip6t_ip6 *ip,
+          const void *info,
           void *matchinfo,
           unsigned int matchinfosize,
           unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui6=
4.c
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -62,7 +62,7 @@ match(const struct sk_buff *skb,
=20
 static int
 ip6t_eui64_checkentry(const char *tablename,
-		   const struct ip6t_ip6 *ip,
+		   const void  *ip,
 		   void *matchinfo,
 		   unsigned int matchsize,
 		   unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -178,7 +178,7 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const struct ip6t_ip6 *ip,
+          const void *entry,
           void *matchinfo,
           unsigned int matchinfosize,
           unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -48,7 +48,7 @@ static int match(const struct sk_buff *s
 	return 0;
 }
=20
-static int checkentry(const char *tablename, const struct ip6t_ip6 *ip,
+static int checkentry(const char *tablename, const void *entry,
 		      void *matchinfo, unsigned int matchsize,
 		      unsigned int hook_mask)
 {
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t=
_ipv6header.c
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -124,7 +124,7 @@ ipv6header_match(const struct sk_buff *s
=20
 static int
 ipv6header_checkentry(const char *tablename,
-		      const struct ip6t_ip6 *ip,
+		      const void *ip,
 		      void *matchinfo,
 		      unsigned int matchsize,
 		      unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_length.c b/net/ipv6/netfilter/ip6t_len=
gth.c
deleted file mode 100644
--- a/net/ipv6/netfilter/ip6t_length.c
+++ /dev/null
@@ -1,66 +0,0 @@
-/* Length Match - IPv6 Port */
-
-/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/netfilter_ipv6/ip6t_length.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
-MODULE_DESCRIPTION("IPv6 packet length match");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-	const struct ip6t_length_info *info =3D matchinfo;
-	u_int16_t pktlen =3D ntohs(skb->nh.ipv6h->payload_len) + sizeof(struct ip=
v6hdr);
-=09
-	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->invert;
-}
-
-static int
-checkentry(const char *tablename,
-           const struct ip6t_ip6 *ip,
-           void *matchinfo,
-           unsigned int matchsize,
-           unsigned int hook_mask)
-{
-	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_length_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ip6t_match length_match =3D {
-	.name		=3D "length",
-	.match		=3D &match,
-	.checkentry	=3D &checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ip6t_register_match(&length_match);
-}
-
-static void __exit fini(void)
-{
-	ip6t_unregister_match(&length_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv6/netfilter/ip6t_limit.c b/net/ipv6/netfilter/ip6t_limi=
t.c
deleted file mode 100644
--- a/net/ipv6/netfilter/ip6t_limit.c
+++ /dev/null
@@ -1,147 +0,0 @@
-/* Kernel module to control the rate
- *
- * 2 September 1999: Changed from the target RATE to the match
- *                   `limit', removed logging.  Did I mention that
- *                   Alexey is a fucking genius?
- *                   Rusty Russell (rusty@rustcorp.com.au).  */
-
-/* (C) 1999 J=E9r=F4me de Vivie <devivie@info.enserb.u-bordeaux.fr>
- * (C) 1999 Herv=E9 Eychenne <eychenne@info.enserb.u-bordeaux.fr>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/spinlock.h>
-#include <linux/interrupt.h>
-
-#include <linux/netfilter_ipv6/ip6_tables.h>
-#include <linux/netfilter_ipv6/ip6t_limit.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
-MODULE_DESCRIPTION("rate limiting within ip6tables");
-
-/* The algorithm used is the Simple Token Bucket Filter (TBF)
- * see net/sched/sch_tbf.c in the linux source tree
- */
-
-static DEFINE_SPINLOCK(limit_lock);
-
-/* Rusty: This is my (non-mathematically-inclined) understanding of
-   this algorithm.  The `average rate' in jiffies becomes your initial
-   amount of credit `credit' and the most credit you can ever have
-   `credit_cap'.  The `peak rate' becomes the cost of passing the
-   test, `cost'.
-
-   `prev' tracks the last packet hit: you gain one credit per jiffy.
-   If you get credit balance more than this, the extra credit is
-   discarded.  Every time the match passes, you lose `cost' credits;
-   if you don't have that many, the test fails.
-
-   See Alexey's formal explanation in net/sched/sch_tbf.c.
-
-   To avoid underflow, we multiply by 128 (ie. you get 128 credits per
-   jiffy).  Hence a cost of 2^32-1, means one pass per 32768 seconds
-   at 1024HZ (or one every 9 hours).  A cost of 1 means 12800 passes
-   per second at 100HZ.  */
-
-#define CREDITS_PER_JIFFY 128
-
-static int
-ip6t_limit_match(const struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		const void *matchinfo,
-		int offset,
-		unsigned int protoff,
-		int *hotdrop)
-{
-	struct ip6t_rateinfo *r =3D ((struct ip6t_rateinfo *)matchinfo)->master;
-	unsigned long now =3D jiffies;
-
-	spin_lock_bh(&limit_lock);
-	r->credit +=3D (now - xchg(&r->prev, now)) * CREDITS_PER_JIFFY;
-	if (r->credit > r->credit_cap)
-		r->credit =3D r->credit_cap;
-
-	if (r->credit >=3D r->cost) {
-		/* We're not limited. */
-		r->credit -=3D r->cost;
-		spin_unlock_bh(&limit_lock);
-		return 1;
-	}
-
-       	spin_unlock_bh(&limit_lock);
-	return 0;
-}
-
-/* Precision saver. */
-static u_int32_t
-user2credits(u_int32_t user)
-{
-	/* If multiplying would overflow... */
-	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
-		/* Divide first. */
-		return (user / IP6T_LIMIT_SCALE) * HZ * CREDITS_PER_JIFFY;
-
-	return (user * HZ * CREDITS_PER_JIFFY) / IP6T_LIMIT_SCALE;
-}
-
-static int
-ip6t_limit_checkentry(const char *tablename,
-		     const struct ip6t_ip6 *ip,
-		     void *matchinfo,
-		     unsigned int matchsize,
-		     unsigned int hook_mask)
-{
-	struct ip6t_rateinfo *r =3D matchinfo;
-
-	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_rateinfo)))
-		return 0;
-
-	/* Check for overflow. */
-	if (r->burst =3D=3D 0
-	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
-		printk("Call rusty: overflow in ip6t_limit: %u/%u\n",
-		       r->avg, r->burst);
-		return 0;
-	}
-
-	/* User avg in seconds * IP6T_LIMIT_SCALE: convert to jiffies *
-	   128. */
-	r->prev =3D jiffies;
-	r->credit =3D user2credits(r->avg * r->burst);	 /* Credits full. */
-	r->credit_cap =3D user2credits(r->avg * r->burst); /* Credits full. */
-	r->cost =3D user2credits(r->avg);
-
-	/* For SMP, we only want to use one set of counters. */
-	r->master =3D r;
-
-	return 1;
-}
-
-static struct ip6t_match ip6t_limit_reg =3D {
-	.name		=3D "limit",
-	.match		=3D ip6t_limit_match,
-	.checkentry	=3D ip6t_limit_checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	if (ip6t_register_match(&ip6t_limit_reg))
-		return -EINVAL;
-	return 0;
-}
-
-static void __exit fini(void)
-{
-	ip6t_unregister_match(&ip6t_limit_reg);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv6/netfilter/ip6t_mac.c b/net/ipv6/netfilter/ip6t_mac.c
deleted file mode 100644
--- a/net/ipv6/netfilter/ip6t_mac.c
+++ /dev/null
@@ -1,80 +0,0 @@
-/* Kernel module to match MAC address parameters. */
-
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/if_ether.h>
-
-#include <linux/netfilter_ipv6/ip6t_mac.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("MAC address matching module for IPv6");
-MODULE_AUTHOR("Netfilter Core Teaam <coreteam@netfilter.org>");
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-    const struct ip6t_mac_info *info =3D matchinfo;
-
-    /* Is mac pointer valid? */
-    return (skb->mac.raw >=3D skb->head
-	    && (skb->mac.raw + ETH_HLEN) <=3D skb->data
-	    /* If so, compare... */
-	    && ((memcmp(eth_hdr(skb)->h_source, info->srcaddr, ETH_ALEN)
-		=3D=3D 0) ^ info->invert));
-}
-
-static int
-ip6t_mac_checkentry(const char *tablename,
-		   const struct ip6t_ip6 *ip,
-		   void *matchinfo,
-		   unsigned int matchsize,
-		   unsigned int hook_mask)
-{
-	if (hook_mask
-	    & ~((1 << NF_IP6_PRE_ROUTING) | (1 << NF_IP6_LOCAL_IN)
-		| (1 << NF_IP6_FORWARD))) {
-		printk("ip6t_mac: only valid for PRE_ROUTING, LOCAL_IN or"
-		       " FORWARD\n");
-		return 0;
-	}
-
-	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_mac_info)))
-		return 0;
-
-	return 1;
-}
-
-static struct ip6t_match mac_match =3D {
-	.name		=3D "mac",
-	.match		=3D &match,
-	.checkentry	=3D &ip6t_mac_checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ip6t_register_match(&mac_match);
-}
-
-static void __exit fini(void)
-{
-	ip6t_unregister_match(&mac_match);
-}
-
-module_init(init);
-module_exit(fini);
diff --git a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_=
multiport.c
--- a/net/ipv6/netfilter/ip6t_multiport.c
+++ b/net/ipv6/netfilter/ip6t_multiport.c
@@ -84,11 +84,12 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-	   const struct ip6t_ip6 *ip,
+	   const void *info,
 	   void *matchinfo,
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
+	const struct ip6t_ip6 *ip =3D info;
 	const struct ip6t_multiport *multiinfo =3D matchinfo;
=20
 	if (matchsize !=3D IP6T_ALIGN(sizeof(struct ip6t_multiport)))
diff --git a/net/ipv6/netfilter/ip6t_owner.c b/net/ipv6/netfilter/ip6t_owne=
r.c
--- a/net/ipv6/netfilter/ip6t_owner.c
+++ b/net/ipv6/netfilter/ip6t_owner.c
@@ -53,7 +53,7 @@ match(const struct sk_buff *skb,
=20
 static int
 checkentry(const char *tablename,
-           const struct ip6t_ip6 *ip,
+           const void  *ip,
            void *matchinfo,
            unsigned int matchsize,
            unsigned int hook_mask)
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -183,7 +183,7 @@ match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
-          const struct ip6t_ip6 *ip,
+          const void *entry,
           void *matchinfo,
           unsigned int matchinfosize,
           unsigned int hook_mask)
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -22,3 +22,151 @@ config NETFILTER_NETLINK_LOG
 	  and is also scheduled to replace the old syslog-based ipt_LOG
 	  and ip6t_LOG modules.
=20
+config NETFILTER_XTABLES
+	tristate "Netfilter Xtables support"
+	help
+	  This is required if you intend to use any of ip_tables,
+	  ip6_tables or arp_tables.
+
+config NETFILTER_XT_TARGET_CLASSIFY
+	tristate "Xtables CLASSIFY target support"
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `CLASSIFY' target, which enables the user to set
+	  the priority of a packet. Some qdiscs can use this value for
+	  classification, among these are:
+
+  	  atm, cbq, dsmark, pfifo_fast, htb, prio
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_TARGET_MARK
+	tristate "Netfilter Xtables MARK target support"
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `MARK' target, which allows you to create rules
+	  in the `mangle' table which alter the netfilter mark (nfmark) field
+	  associated with the packet prior to routing. This can change
+	  the routing method (see `Use netfilter MARK value as routing
+	  key') and can also be used by other subsystems to change their
+	  behavior.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_TARGET_NFQUEUE
+	tristate "NFQUEUE Target Support"
+	depends on NETFILTER_XTABLES
+	help
+	  This Target replaced the old obsolete QUEUE target.
+
+	  As opposed to QUEUE, it supports 65535 different queues,
+	  not just one.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_COMMENT
+	tristate  'Xtables comment match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `comment' dummy-match, which allows you to put
+	  comments in your iptables ruleset.
+
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+config NETFILTER_XT_MATCH_LENGTH
+	tristate "LENGTH match support"
+	depends on NETFILTER_XTABLES
+	help
+	  This option allows you to match the length of a packet against a
+	  specific value or range of values.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_LIMIT
+	tristate "limit match support"
+	depends on NETFILTER_XTABLES
+	help
+	  limit matching allows you to control the rate at which a rule can be
+	  matched: mainly useful in combination with the LOG target ("LOG
+	  target support", below) and to avoid some Denial of Service attacks.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_MAC
+	tristate "MAC address match support"
+	depends on NETFILTER_XTABLES
+	help
+	  MAC matching allows you to match packets based on the source
+	  Ethernet address of the packet.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_MARK
+	tristate "netfilter MARK match support"
+	depends on NETFILTER_XTABLES
+	help
+	  Netfilter mark matching allows you to match packets based on the
+	  `nfmark' value in the packet.  This can be set by the MARK target
+	  (see below).
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_PHYSDEV
+	tristate "Physdev match support"
+	depends on NETFILTER_XTABLES && BRIDGE_NETFILTER
+	help
+	  Physdev packet matching matches against the physical bridge ports
+	  the IP packet arrived on or will leave by.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_PKTTYPE
+	tristate "Packet type match support"
+	depends on NETFILTER_XTABLES
+	help
+	  Packet type matching allows you to match a packet by
+	  its "class", eg. BROADCAST, MULTICAST, ...
+
+	  Typical usage:
+	  iptables -A INPUT -m pkttype --pkt-type broadcast -j LOG
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_REALM
+	tristate  'realm match support'
+	depends on NETFILTER_XTABLES
+	select NET_CLS_ROUTE
+	help
+	  This option adds a `realm' match, which allows you to use the realm
+	  key from the routing subsystem inside iptables.
+=09
+	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option=20
+	  in tc world.
+=09
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/modules.txt>.  If unsure, say `N'.
+
+config NETFILTER_XT_MATCH_STATE
+	tristate "Netfilter Xtables state match support"
+	depends on NETFILTER_XTABLES && IP_NF_CONNTRACK
+	help
+	  Connection state matching allows you to match packets based on their
+	  relationship to a tracked connection (ie. previous packets).  This
+	  is a powerful tool for packet classification.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
+config NETFILTER_XT_MATCH_STRING
+	tristate  'string match support'
+	depends on NETFILTER_XTABLES
+	select TEXTSEARCH
+	select TEXTSEARCH_KMP
+	select TEXTSEARCH_BM
+	select TEXTSEARCH_FSM
+	help
+	  This option adds a `string' match, which allows you to look for
+	  pattern matchings in packets.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -5,3 +5,18 @@ obj-$(CONFIG_NETFILTER) =3D netfilter.o
 obj-$(CONFIG_NETFILTER_NETLINK) +=3D nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) +=3D nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) +=3D nfnetlink_log.o
+
+obj-$(CONFIG_NETFILTER_XTABLES) +=3D x_tables.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) +=3D xt_CLASSIFY.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_MARK) +=3D xt_MARK.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) +=3D xt_NFQUEUE.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_COMMENT) +=3D xt_comment.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_LENGTH) +=3D xt_length.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_LIMIT) +=3D xt_limit.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_MAC) +=3D xt_mac.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_MARK) +=3D xt_mark.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_PKTTYPE) +=3D xt_pkttype.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) +=3D xt_realm.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) +=3D xt_state.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/x_tables.c
@@ -0,0 +1,458 @@
+
+#include <linux/config.h>
+#include <linux/kernel.h>
+#include <linux/socket.h>
+#include <linux/net.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_arp.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("[ip,ip6,arp]_tables backend module");
+
+static struct semaphore xt_mutex[NPROTO];
+static struct list_head xt_match[NPROTO];
+static struct list_head xt_target[NPROTO];
+static struct list_head xt_tables[NPROTO];
+
+EXPORT_SYMBOL_GPL(xt_mutex);
+EXPORT_SYMBOL_GPL(xt_tables);
+
+enum {
+	TABLE,
+	TARGET,
+	MATCH,
+};
+
+/* Registration hooks for targets. */
+int
+xt_register_target(int af, struct xt_target *target)
+{
+	int ret;
+
+	ret =3D down_interruptible(&xt_mutex[af]);
+	if (ret !=3D 0)
+		return ret;
+	list_add(&target->list, &xt_target[af]);
+	up(&xt_mutex[af]);
+	return ret;
+}
+EXPORT_SYMBOL(xt_register_target);
+
+void
+xt_unregister_target(int af, struct xt_target *target)
+{
+	down(&xt_mutex[af]);
+	LIST_DELETE(&xt_target[af], target);
+	up(&xt_mutex[af]);
+}
+EXPORT_SYMBOL(xt_unregister_target);
+
+int
+xt_register_match(int af, struct xt_match *match)
+{
+	int ret;
+
+	ret =3D down_interruptible(&xt_mutex[af]);
+	if (ret !=3D 0)
+		return ret;
+
+	list_add(&match->list, &xt_match[af]);
+	up(&xt_mutex[af]);
+
+	return ret;
+}
+EXPORT_SYMBOL(xt_register_match);
+
+void
+xt_unregister_match(int af, struct xt_match *match)
+{
+	down(&xt_mutex[af]);
+	LIST_DELETE(&xt_match[af], match);
+	up(&xt_mutex[af]);
+}
+EXPORT_SYMBOL(xt_unregister_match);
+
+
+/*
+ * These are weird, but module loading must not be done with mutex
+ * held (since they will register), and we have to have a single
+ * function to use try_then_request_module().
+ */
+
+/* Find match, grabs ref.  Returns ERR_PTR() on error. */
+struct xt_match *xt_find_match(int af, const char *name, u8 revision)
+{
+	struct xt_match *m;
+	int err =3D 0;
+
+	if (down_interruptible(&xt_mutex[af]) !=3D 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(m, &xt_match[af], list) {
+		if (strcmp(m->name, name) =3D=3D 0) {
+			if (m->revision =3D=3D revision) {
+				if (try_module_get(m->me)) {
+					up(&xt_mutex[af]);
+					return m;
+				}
+			} else
+				err =3D -EPROTOTYPE; /* Found something. */
+		}
+	}
+	up(&xt_mutex[af]);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(xt_find_match);
+
+/* Find target, grabs ref.  Returns ERR_PTR() on error. */
+struct xt_target *xt_find_target(int af, const char *name, u8 revision)
+{
+	struct xt_target *t;
+	int err =3D 0;
+
+	if (down_interruptible(&xt_mutex[af]) !=3D 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(t, &xt_target[af], list) {
+		if (strcmp(t->name, name) =3D=3D 0) {
+			if (t->revision =3D=3D revision) {
+				if (try_module_get(t->me)) {
+					up(&xt_mutex[af]);
+					return t;
+				}
+			} else
+				err =3D -EPROTOTYPE; /* Found something. */
+		}
+	}
+	up(&xt_mutex[af]);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(xt_find_target);
+
+#define AF_ARP AF_ECONET
+
+static const char *xt_prefix[NPROTO] =3D {
+	[AF_INET] 	=3D "ipt_%s",
+	[AF_INET6] 	=3D "ip6t_%s",
+	[AF_ARP]	=3D "arpt_%s",
+};
+
+struct xt_target *xt_request_find_target(int af, const char *name, u8 revi=
sion)
+{
+	struct xt_target *target;
+
+	target =3D try_then_request_module(xt_find_target(af, name, revision),
+					 xt_prefix[af], name);
+	if (IS_ERR(target) || !target)
+		return NULL;
+	return target;
+}
+EXPORT_SYMBOL_GPL(xt_request_find_target);
+
+static int match_revfn(int af, const char *name, u8 revision, int *bestp)
+{
+	struct xt_match *m;
+	int have_rev =3D 0;
+
+	list_for_each_entry(m, &xt_match[af], list) {
+		if (strcmp(m->name, name) =3D=3D 0) {
+			if (m->revision > *bestp)
+				*bestp =3D m->revision;
+			if (m->revision =3D=3D revision)
+				have_rev =3D 1;
+		}
+	}
+	return have_rev;
+}
+
+static int target_revfn(int af, const char *name, u8 revision, int *bestp)
+{
+	struct xt_target *t;
+	int have_rev =3D 0;
+
+	list_for_each_entry(t, &xt_target[af], list) {
+		if (strcmp(t->name, name) =3D=3D 0) {
+			if (t->revision > *bestp)
+				*bestp =3D t->revision;
+			if (t->revision =3D=3D revision)
+				have_rev =3D 1;
+		}
+	}
+	return have_rev;
+}
+
+/* Returns true or false (if no such extension at all) */
+int xt_find_revision(int af, const char *name, u8 revision, int target,
+		     int *err)
+{
+	int have_rev, best =3D -1;
+
+	if (down_interruptible(&xt_mutex[af]) !=3D 0) {
+		*err =3D -EINTR;
+		return 1;
+	}
+	if (target =3D=3D 1)
+		have_rev =3D target_revfn(af, name, revision, &best);
+	else
+		have_rev =3D match_revfn(af, name, revision, &best);
+	up(&xt_mutex[af]);
+
+	/* Nothing at all?  Return 0 to try loading module. */
+	if (best =3D=3D -1) {
+		*err =3D -ENOENT;
+		return 0;
+	}
+
+	*err =3D best;
+	if (!have_rev)
+		*err =3D -EPROTONOSUPPORT;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(xt_find_revision);
+
+/* Find table by name, grabs mutex & ref.  Returns ERR_PTR() on error. */
+struct xt_table *xt_find_table_lock(int af, const char *name)
+{
+	struct xt_table *t;
+
+	if (down_interruptible(&xt_mutex[af]) !=3D 0)
+		return ERR_PTR(-EINTR);
+
+	list_for_each_entry(t, &xt_tables[af], list)
+		if (strcmp(t->name, name) =3D=3D 0 && try_module_get(t->me))
+			return t;
+	up(&xt_mutex[af]);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(xt_find_table_lock);
+
+#ifdef CONFIG_PROC_FS
+static char *xt_proto_prefix[NPROTO] =3D {
+	[AF_INET]	=3D "ip",
+	[AF_INET6]	=3D "ip6",
+	[NF_ARP]	=3D "arp",
+};
+
+static struct list_head *xt_get_idx(struct list_head *list, struct seq_fil=
e *seq, loff_t pos)
+{
+	struct list_head *head =3D list->next;
+
+	if (!head || list_empty(list))
+		return NULL;
+
+	while (pos && (head =3D head->next)) {
+		if (head =3D=3D list)
+			return NULL;
+		pos--;
+	}
+	return pos ? NULL : head;
+}
+
+static struct list_head *type2list(u_int16_t af, u_int16_t type)
+{
+	struct list_head *list;
+
+	switch (type) {
+	case TARGET:
+		list =3D &xt_target[af];
+		break;
+	case MATCH:
+		list =3D &xt_match[af];
+		break;
+	case TABLE:
+		list =3D &xt_tables[af];
+		break;
+	default:
+		list =3D NULL;
+		break;
+	}
+
+	return list;
+}
+
+static void *xt_tgt_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D (struct proc_dir_entry *) seq->private;
+	u_int16_t af =3D (unsigned long)pde->data & 0xffff;
+	u_int16_t type =3D (unsigned long)pde->data >> 16;
+	struct list_head *list;
+
+	if (af >=3D NPROTO)
+		return NULL;
+
+	list =3D type2list(af, type);
+	if (!list)
+		return NULL;
+
+	if (down_interruptible(&xt_mutex[af]) !=3D 0)
+		return NULL;
+=09
+	return xt_get_idx(list, seq, *pos);
+}
+
+static void *xt_tgt_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D seq->private;
+	u_int16_t af =3D (unsigned long)pde->data & 0xffff;
+	u_int16_t type =3D (unsigned long)pde->data >> 16;
+	struct list_head *list;
+
+	if (af >=3D NPROTO)
+		return NULL;
+=09
+	list =3D type2list(af, type);
+	if (!list)
+		return NULL;
+
+	(*pos)++;
+	return xt_get_idx(list, seq, *pos);
+}
+
+static void xt_tgt_seq_stop(struct seq_file *seq, void *v)
+{
+	struct proc_dir_entry *pde =3D seq->private;
+	u_int16_t af =3D (unsigned long)pde->data & 0xffff;
+
+	up(&xt_mutex[af]);
+}
+
+static int xt_name_seq_show(struct seq_file *seq, void *v)
+{
+	return seq_printf(seq, "%s\n", (char *)v + sizeof(struct list_head));
+}
+
+static struct seq_operations xt_tgt_seq_ops =3D {
+	.start	=3D xt_tgt_seq_start,
+	.next	=3D xt_tgt_seq_next,
+	.stop	=3D xt_tgt_seq_stop,
+	.show	=3D xt_name_seq_show,
+};
+
+static int xt_tgt_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret =3D seq_open(file, &xt_tgt_seq_ops);
+	if (!ret) {
+		struct seq_file *seq =3D file->private_data;
+		struct proc_dir_entry *pde =3D PDE(inode);
+
+		seq->private =3D pde;
+	}
+
+	return ret;
+}
+
+static struct file_operations xt_file_ops =3D {
+	.owner	 =3D THIS_MODULE,
+	.open	 =3D xt_tgt_open,
+	.read	 =3D seq_read,
+	.llseek	 =3D seq_lseek,
+	.release =3D seq_release,
+};
+
+#define FORMAT_TABLES	"_tables_names"
+#define	FORMAT_MATCHES	"_tables_matches"
+#define FORMAT_TARGETS 	"_tables_targets"
+
+#endif /* CONFIG_PROC_FS */
+
+int xt_proto_init(int af)
+{
+#ifdef CONFIG_PROC_FS
+	char buf[XT_FUNCTION_MAXNAMELEN];
+	struct proc_dir_entry *proc;
+#endif
+
+	if (af >=3D NPROTO)
+		return -EINVAL;
+
+
+#ifdef CONFIG_PROC_FS
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_TABLES, sizeof(buf));
+	proc =3D proc_net_fops_create(buf, 0440, &xt_file_ops);
+	if (!proc)
+		goto out;
+	proc->data =3D (void *) ((unsigned long) af | (TABLE << 16));
+
+
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
+	proc =3D proc_net_fops_create(buf, 0440, &xt_file_ops);
+	if (!proc)
+		goto out_remove_tables;
+	proc->data =3D (void *) ((unsigned long) af | (MATCH << 16));
+
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
+	proc =3D proc_net_fops_create(buf, 0440, &xt_file_ops);
+	if (!proc)
+		goto out_remove_matches;
+	proc->data =3D (void *) ((unsigned long) af | (TARGET << 16));
+#endif
+
+	return 0;
+
+#ifdef CONFIG_PROC_FS
+out_remove_matches:
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
+	proc_net_remove(buf);
+
+out_remove_tables:
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_TABLES, sizeof(buf));
+	proc_net_remove(buf);
+out:
+	return -1;
+#endif
+}
+EXPORT_SYMBOL_GPL(xt_proto_init);
+
+void xt_proto_fini(int af)
+{
+#ifdef CONFIG_PROC_FS
+	char buf[XT_FUNCTION_MAXNAMELEN];
+
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_TABLES, sizeof(buf));
+	proc_net_remove(buf);
+
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_TARGETS, sizeof(buf));
+	proc_net_remove(buf);
+
+	strlcpy(buf, xt_proto_prefix[af], sizeof(buf));
+	strlcat(buf, FORMAT_MATCHES, sizeof(buf));
+	proc_net_remove(buf);
+#endif /*CONFIG_PROC_FS*/
+}
+EXPORT_SYMBOL_GPL(xt_proto_fini);
+
+
+static int __init xt_init(void)
+{
+	int i;
+	for (i =3D 0; i < ARRAY_SIZE(xt_mutex); i++) {
+		init_MUTEX(&xt_mutex[i]);
+		INIT_LIST_HEAD(&xt_target[i]);
+		INIT_LIST_HEAD(&xt_match[i]);
+		INIT_LIST_HEAD(&xt_tables[i]);
+	}
+	return 0;
+}
+
+static void __exit xt_fini(void)
+{
+
+}
+
+module_init(xt_init);
+module_exit(xt_fini);
+
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_MARK.c
@@ -0,0 +1,191 @@
+/* This is a module which is used for setting the NFMARK field of an skb. =
*/
+
+/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_MARK.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("ip[6]tables MARK modification module");
+MODULE_ALIAS("ipt_MARK");
+MODULE_ALIAS("ip6t_MARK");
+
+static unsigned int
+target_v0(struct sk_buff **pskb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  unsigned int hooknum,
+	  const void *targinfo,
+	  void *userinfo)
+{
+	const struct xt_mark_target_info *markinfo =3D targinfo;
+
+	if((*pskb)->nfmark !=3D markinfo->mark)
+		(*pskb)->nfmark =3D markinfo->mark;
+
+	return XT_CONTINUE;
+}
+
+static unsigned int
+target_v1(struct sk_buff **pskb,
+	  const struct net_device *in,
+	  const struct net_device *out,
+	  unsigned int hooknum,
+	  const void *targinfo,
+	  void *userinfo)
+{
+	const struct xt_mark_target_info_v1 *markinfo =3D targinfo;
+	int mark =3D 0;
+
+	switch (markinfo->mode) {
+	case XT_MARK_SET:
+		mark =3D markinfo->mark;
+		break;
+	=09
+	case XT_MARK_AND:
+		mark =3D (*pskb)->nfmark & markinfo->mark;
+		break;
+	=09
+	case XT_MARK_OR:
+		mark =3D (*pskb)->nfmark | markinfo->mark;
+		break;
+	}
+
+	if((*pskb)->nfmark !=3D mark)
+		(*pskb)->nfmark =3D mark;
+
+	return XT_CONTINUE;
+}
+
+
+static int
+checkentry_v0(const char *tablename,
+	      const void *entry,
+	      void *targinfo,
+	      unsigned int targinfosize,
+	      unsigned int hook_mask)
+{
+	struct xt_mark_target_info *markinfo =3D targinfo;
+
+	if (targinfosize !=3D XT_ALIGN(sizeof(struct xt_mark_target_info))) {
+		printk(KERN_WARNING "MARK: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       XT_ALIGN(sizeof(struct xt_mark_target_info)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not=
 \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (markinfo->mark > 0xffffffff) {
+		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static int
+checkentry_v1(const char *tablename,
+	      const void *entry,
+	      void *targinfo,
+	      unsigned int targinfosize,
+	      unsigned int hook_mask)
+{
+	struct xt_mark_target_info_v1 *markinfo =3D targinfo;
+
+	if (targinfosize !=3D XT_ALIGN(sizeof(struct xt_mark_target_info_v1))){
+		printk(KERN_WARNING "MARK: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       XT_ALIGN(sizeof(struct xt_mark_target_info_v1)));
+		return 0;
+	}
+
+	if (strcmp(tablename, "mangle") !=3D 0) {
+		printk(KERN_WARNING "MARK: can only be called from \"mangle\" table, not=
 \"%s\"\n", tablename);
+		return 0;
+	}
+
+	if (markinfo->mode !=3D XT_MARK_SET
+	    && markinfo->mode !=3D XT_MARK_AND
+	    && markinfo->mode !=3D XT_MARK_OR) {
+		printk(KERN_WARNING "MARK: unknown mode %u\n",
+		       markinfo->mode);
+		return 0;
+	}
+
+	if (markinfo->mark > 0xffffffff) {
+		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct xt_target ipt_mark_reg_v0 =3D {
+	.name		=3D "MARK",
+	.target		=3D target_v0,
+	.checkentry	=3D checkentry_v0,
+	.me		=3D THIS_MODULE,
+	.revision	=3D 0,
+};
+
+static struct xt_target ipt_mark_reg_v1 =3D {
+	.name		=3D "MARK",
+	.target		=3D target_v1,
+	.checkentry	=3D checkentry_v1,
+	.me		=3D THIS_MODULE,
+	.revision	=3D 1,
+};
+
+static struct xt_target ip6t_mark_reg_v0 =3D {
+	.name		=3D "MARK",
+	.target		=3D target_v0,
+	.checkentry	=3D checkentry_v0,
+	.me		=3D THIS_MODULE,
+	.revision	=3D 0,
+};
+
+static int __init init(void)
+{
+	int err;
+
+	err =3D xt_register_target(AF_INET, &ipt_mark_reg_v0);
+	if (err)
+		return err;
+
+	err =3D xt_register_target(AF_INET, &ipt_mark_reg_v1);
+	if (err)
+		xt_unregister_target(AF_INET, &ipt_mark_reg_v0);
+
+	err =3D xt_register_target(AF_INET6, &ip6t_mark_reg_v0);
+	if (err) {
+		xt_unregister_target(AF_INET, &ipt_mark_reg_v0);
+		xt_unregister_target(AF_INET, &ipt_mark_reg_v1);
+	}
+
+	return err;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_target(AF_INET, &ipt_mark_reg_v0);
+	xt_unregister_target(AF_INET, &ipt_mark_reg_v1);
+	xt_unregister_target(AF_INET6, &ip6t_mark_reg_v0);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -0,0 +1,107 @@
+/* iptables module for using new netfilter netlink queue
+ *
+ * (C) 2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as=20
+ * published by the Free Software Foundation.
+ *=20
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter.h>
+#include <linux/netfilter_arp.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_NFQUEUE.h>
+
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("[ip,ip6,arp]_tables NFQUEUE target");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_NFQUEUE");
+MODULE_ALIAS("ip6t_NFQUEUE");
+MODULE_ALIAS("arpt_NFQUEUE");
+
+static unsigned int
+target(struct sk_buff **pskb,
+       const struct net_device *in,
+       const struct net_device *out,
+       unsigned int hooknum,
+       const void *targinfo,
+       void *userinfo)
+{
+	const struct xt_NFQ_info *tinfo =3D targinfo;
+
+	return NF_QUEUE_NR(tinfo->queuenum);
+}
+
+static int
+checkentry(const char *tablename,
+	   const void *entry,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+	if (targinfosize !=3D XT_ALIGN(sizeof(struct xt_NFQ_info))) {
+		printk(KERN_WARNING "NFQUEUE: targinfosize %u !=3D %Zu\n",
+		       targinfosize,
+		       XT_ALIGN(sizeof(struct xt_NFQ_info)));
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct xt_target ipt_NFQ_reg =3D {
+	.name		=3D "NFQUEUE",
+	.target		=3D target,
+	.checkentry	=3D checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static struct xt_target ip6t_NFQ_reg =3D {
+	.name		=3D "NFQUEUE",
+	.target		=3D target,
+	.checkentry	=3D checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static struct xt_target arpt_NFQ_reg =3D {
+	.name		=3D "NFQUEUE",
+	.target		=3D target,
+	.checkentry	=3D checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+	ret =3D xt_register_target(AF_INET, &ipt_NFQ_reg);
+	if (ret)
+		return ret;
+	ret =3D xt_register_target(AF_INET6, &ip6t_NFQ_reg);
+	if (ret)
+		goto out_ip;
+	ret =3D xt_register_target(NF_ARP, &arpt_NFQ_reg);
+	if (ret)
+		goto out_ip6;
+
+	return ret;
+out_ip6:
+	xt_unregister_target(AF_INET6, &ip6t_NFQ_reg);
+out_ip:
+	xt_unregister_target(AF_INET, &ipt_NFQ_reg);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_target(NF_ARP, &arpt_NFQ_reg);
+	xt_unregister_target(AF_INET6, &ip6t_NFQ_reg);
+	xt_unregister_target(AF_INET, &ipt_NFQ_reg);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_comment.c
@@ -0,0 +1,73 @@
+/*
+ * Implements a dummy match to allow attaching comments to rules
+ *
+ * 2003-05-13 Brad Fisher (brad@info-link.net)
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_comment.h>
+
+MODULE_AUTHOR("Brad Fisher <brad@info-link.net>");
+MODULE_DESCRIPTION("iptables comment match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_comment");
+MODULE_ALIAS("ip6t_comment");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protooff,
+      int *hotdrop)
+{
+	/* We always match */
+	return 1;
+}
+
+static int
+checkentry(const char *tablename,
+           const void *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	/* Check the size */
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_comment_info)))
+		return 0;
+	return 1;
+}
+
+static struct xt_match comment_match =3D {
+	.name		=3D "comment",
+	.match		=3D match,
+	.checkentry	=3D checkentry,
+	.me		=3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret =3D xt_register_match(AF_INET, &comment_match);
+	if (ret)
+		return ret;
+
+	ret =3D xt_register_match(AF_INET6, &comment_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &comment_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &comment_match);
+	xt_unregister_match(AF_INET6, &comment_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_length.c
@@ -0,0 +1,98 @@
+/* Kernel module to match packet length. */
+/* (C) 1999-2001 James Morris <jmorros@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <net/ip.h>
+
+#include <linux/netfilter/xt_length.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
+MODULE_DESCRIPTION("IP tables packet length matching module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_length");
+MODULE_ALIAS("ip6t_length");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct xt_length_info *info =3D matchinfo;
+	u_int16_t pktlen =3D ntohs(skb->nh.iph->tot_len);
+=09
+	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->invert;
+}
+
+static int
+match6(const struct sk_buff *skb,
+       const struct net_device *in,
+       const struct net_device *out,
+       const void *matchinfo,
+       int offset,
+       unsigned int protoff,
+       int *hotdrop)
+{
+	const struct xt_length_info *info =3D matchinfo;
+	u_int16_t pktlen =3D ntohs(skb->nh.ipv6h->payload_len) + sizeof(struct ip=
v6hdr);
+=09
+	return (pktlen >=3D info->min && pktlen <=3D info->max) ^ info->invert;
+}
+
+static int
+checkentry(const char *tablename,
+           const void *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_length_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct xt_match length_match =3D {
+	.name		=3D "length",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+static struct xt_match length6_match =3D {
+	.name		=3D "length",
+	.match		=3D &match6,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+	ret =3D xt_register_match(AF_INET, &length_match);
+	if (ret)
+		return ret;
+	ret =3D xt_register_match(AF_INET6, &length6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &length_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &length_match);
+	xt_unregister_match(AF_INET6, &length6_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_limit.c
@@ -0,0 +1,175 @@
+/* Kernel module to control the rate
+ *
+ * 2 September 1999: Changed from the target RATE to the match
+ *                   `limit', removed logging.  Did I mention that
+ *                   Alexey is a fucking genius?
+ *                   Rusty Russell (rusty@rustcorp.com.au).  */
+
+/* (C) 1999 J=E9r=F4me de Vivie <devivie@info.enserb.u-bordeaux.fr>
+ * (C) 1999 Herv=E9 Eychenne <eychenne@info.enserb.u-bordeaux.fr>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_limit.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
+MODULE_DESCRIPTION("iptables rate limit match");
+MODULE_ALIAS("ipt_limit");
+MODULE_ALIAS("ip6t_limit");
+
+/* The algorithm used is the Simple Token Bucket Filter (TBF)
+ * see net/sched/sch_tbf.c in the linux source tree
+ */
+
+static DEFINE_SPINLOCK(limit_lock);
+
+/* Rusty: This is my (non-mathematically-inclined) understanding of
+   this algorithm.  The `average rate' in jiffies becomes your initial
+   amount of credit `credit' and the most credit you can ever have
+   `credit_cap'.  The `peak rate' becomes the cost of passing the
+   test, `cost'.
+
+   `prev' tracks the last packet hit: you gain one credit per jiffy.
+   If you get credit balance more than this, the extra credit is
+   discarded.  Every time the match passes, you lose `cost' credits;
+   if you don't have that many, the test fails.
+
+   See Alexey's formal explanation in net/sched/sch_tbf.c.
+
+   To get the maxmum range, we multiply by this factor (ie. you get N
+   credits per jiffy).  We want to allow a rate as low as 1 per day
+   (slowest userspace tool allows), which means
+   CREDITS_PER_JIFFY*HZ*60*60*24 < 2^32. ie. */
+#define MAX_CPJ (0xFFFFFFFF / (HZ*60*60*24))
+
+/* Repeated shift and or gives us all 1s, final shift and add 1 gives
+ * us the power of 2 below the theoretical max, so GCC simply does a
+ * shift. */
+#define _POW2_BELOW2(x) ((x)|((x)>>1))
+#define _POW2_BELOW4(x) (_POW2_BELOW2(x)|_POW2_BELOW2((x)>>2))
+#define _POW2_BELOW8(x) (_POW2_BELOW4(x)|_POW2_BELOW4((x)>>4))
+#define _POW2_BELOW16(x) (_POW2_BELOW8(x)|_POW2_BELOW8((x)>>8))
+#define _POW2_BELOW32(x) (_POW2_BELOW16(x)|_POW2_BELOW16((x)>>16))
+#define POW2_BELOW32(x) ((_POW2_BELOW32(x)>>1) + 1)
+
+#define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
+
+static int
+ipt_limit_match(const struct sk_buff *skb,
+		const struct net_device *in,
+		const struct net_device *out,
+		const void *matchinfo,
+		int offset,
+		unsigned int protoff,
+		int *hotdrop)
+{
+	struct xt_rateinfo *r =3D ((struct xt_rateinfo *)matchinfo)->master;
+	unsigned long now =3D jiffies;
+
+	spin_lock_bh(&limit_lock);
+	r->credit +=3D (now - xchg(&r->prev, now)) * CREDITS_PER_JIFFY;
+	if (r->credit > r->credit_cap)
+		r->credit =3D r->credit_cap;
+
+	if (r->credit >=3D r->cost) {
+		/* We're not limited. */
+		r->credit -=3D r->cost;
+		spin_unlock_bh(&limit_lock);
+		return 1;
+	}
+
+       	spin_unlock_bh(&limit_lock);
+	return 0;
+}
+
+/* Precision saver. */
+static u_int32_t
+user2credits(u_int32_t user)
+{
+	/* If multiplying would overflow... */
+	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
+		/* Divide first. */
+		return (user / XT_LIMIT_SCALE) * HZ * CREDITS_PER_JIFFY;
+
+	return (user * HZ * CREDITS_PER_JIFFY) / XT_LIMIT_SCALE;
+}
+
+static int
+ipt_limit_checkentry(const char *tablename,
+		     const void *inf,
+		     void *matchinfo,
+		     unsigned int matchsize,
+		     unsigned int hook_mask)
+{
+	struct xt_rateinfo *r =3D matchinfo;
+
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_rateinfo)))
+		return 0;
+
+	/* Check for overflow. */
+	if (r->burst =3D=3D 0
+	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
+		printk("Overflow in xt_limit, try lower: %u/%u\n",
+		       r->avg, r->burst);
+		return 0;
+	}
+
+	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
+	   128. */
+	r->prev =3D jiffies;
+	r->credit =3D user2credits(r->avg * r->burst);	 /* Credits full. */
+	r->credit_cap =3D user2credits(r->avg * r->burst); /* Credits full. */
+	r->cost =3D user2credits(r->avg);
+
+	/* For SMP, we only want to use one set of counters. */
+	r->master =3D r;
+
+	return 1;
+}
+
+static struct xt_match ipt_limit_reg =3D {
+	.name		=3D "limit",
+	.match		=3D ipt_limit_match,
+	.checkentry	=3D ipt_limit_checkentry,
+	.me		=3D THIS_MODULE,
+};
+static struct xt_match limit6_reg =3D {
+	.name		=3D "limit",
+	.match		=3D ipt_limit_match,
+	.checkentry	=3D ipt_limit_checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+=09
+	ret =3D xt_register_match(AF_INET, &ipt_limit_reg);
+	if (ret)
+		return ret;
+=09
+	ret =3D xt_register_match(AF_INET6, &limit6_reg);
+	if (ret)
+		xt_unregister_match(AF_INET, &ipt_limit_reg);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &ipt_limit_reg);
+	xt_unregister_match(AF_INET6, &limit6_reg);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_mac.c
@@ -0,0 +1,99 @@
+/* Kernel module to match MAC address parameters. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/xt_mac.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
+MODULE_DESCRIPTION("iptables mac matching module");
+MODULE_ALIAS("ipt_mac");
+MODULE_ALIAS("ip6t_mac");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+    const struct xt_mac_info *info =3D matchinfo;
+
+    /* Is mac pointer valid? */
+    return (skb->mac.raw >=3D skb->head
+	    && (skb->mac.raw + ETH_HLEN) <=3D skb->data
+	    /* If so, compare... */
+	    && ((memcmp(eth_hdr(skb)->h_source, info->srcaddr, ETH_ALEN)
+		=3D=3D 0) ^ info->invert));
+}
+
+static int
+ipt_mac_checkentry(const char *tablename,
+		   const void *inf,
+		   void *matchinfo,
+		   unsigned int matchsize,
+		   unsigned int hook_mask)
+{
+	/* FORWARD isn't always valid, but it's nice to be able to do --RR */
+	if (hook_mask
+	    & ~((1 << NF_IP_PRE_ROUTING) | (1 << NF_IP_LOCAL_IN)
+		| (1 << NF_IP_FORWARD))) {
+		printk("xt_mac: only valid for PRE_ROUTING, LOCAL_IN or FORWARD.\n");
+		return 0;
+	}
+
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_mac_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct xt_match mac_match =3D {
+	.name		=3D "mac",
+	.match		=3D &match,
+	.checkentry	=3D &ipt_mac_checkentry,
+	.me		=3D THIS_MODULE,
+};
+static struct xt_match mac6_match =3D {
+	.name		=3D "mac",
+	.match		=3D &match,
+	.checkentry	=3D &ipt_mac_checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+	ret =3D xt_register_match(AF_INET, &mac_match);
+	if (ret)
+		return ret;
+
+	ret =3D xt_register_match(AF_INET6, &mac6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &mac_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &mac_match);
+	xt_unregister_match(AF_INET6, &mac6_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_mark.c
@@ -0,0 +1,91 @@
+/* Kernel module to match NFMARK values. */
+
+/* (C) 1999-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter/xt_mark.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("iptables mark matching module");
+MODULE_ALIAS("ipt_mark");
+MODULE_ALIAS("ip6t_mark");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct xt_mark_info *info =3D matchinfo;
+
+	return ((skb->nfmark & info->mask) =3D=3D info->mark) ^ info->invert;
+}
+
+static int
+checkentry(const char *tablename,
+           const void *entry,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	struct xt_mark_info *minfo =3D (struct xt_mark_info *) matchinfo;
+
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_mark_info)))
+		return 0;
+
+	if (minfo->mark > 0xffffffff || minfo->mask > 0xffffffff) {
+		printk(KERN_WARNING "mark: only supports 32bit mark\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct xt_match mark_match =3D {
+	.name		=3D "mark",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static struct xt_match mark6_match =3D {
+	.name		=3D "mark",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+	ret =3D xt_register_match(AF_INET, &mark_match);
+	if (ret)
+		return ret;
+
+	ret =3D xt_register_match(AF_INET6, &mark6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &mark_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &mark_match);
+	xt_unregister_match(AF_INET6, &mark6_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_owner.c
@@ -0,0 +1,115 @@
+/* Kernel module to match various things tied to sockets associated with
+   locally generated outgoing packets. */
+
+/* (C) 2000-2001 Marc Boucher <marc@mbsi.ca>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/file.h>
+#include <linux/rcupdate.h>
+#include <net/sock.h>
+
+#include <linux/netfilter/xt_owner.h>
+
+MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
+MODULE_DESCRIPTION("IP6 tables owner matching module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_owner");
+MODULE_ALIAS("ip6t_owner");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct xt_owner_info *info =3D matchinfo;
+
+	if (!skb->sk || !skb->sk->sk_socket || !skb->sk->sk_socket->file)
+		return 0;
+
+	if(info->match & XT_OWNER_UID) {
+		if((skb->sk->sk_socket->file->f_uid !=3D info->uid) ^
+		    !!(info->invert & XT_OWNER_UID))
+			return 0;
+	}
+
+	if(info->match & XT_OWNER_GID) {
+		if((skb->sk->sk_socket->file->f_gid !=3D info->gid) ^
+		    !!(info->invert & XT_OWNER_GID))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int
+checkentry(const char *tablename,
+           const void  *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	const struct xt_owner_info *info =3D matchinfo;
+
+        if (hook_mask
+            & ~((1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_POST_ROUTING))) {
+                printk("xt_owner: only valid for LOCAL_OUT or POST_ROUTING=
=2E\n");
+                return 0;
+        }
+
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_owner_info)))
+		return 0;
+
+	if (info->match & (XT_OWNER_PID|XT_OWNER_SID)) {
+		printk("xt_owner: pid and sid matching "
+		       "not supported anymore\n");
+		return 0;
+	}
+
+	return 1;
+}
+
+static struct xt_match owner_match =3D {
+	.name		=3D "owner",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static struct xt_match owner6_match =3D {
+	.name		=3D "owner",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+	ret =3D xt_register_match(AF_INET, &owner_match);
+	if (ret)
+		return ret;
+	ret =3D xt_register_match(AF_INET6, &owner6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &owner_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET6, &owner6_match);
+	xt_unregister_match(AF_INET, &owner_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_physdev.c
@@ -0,0 +1,155 @@
+/* Kernel module to match the bridge port in and
+ * out device for IP packets coming into contact with a bridge. */
+
+/* (C) 2001-2003 Bart De Schuymer <bdschuym@pandora.be>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/xt_physdev.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge.h>
+#define MATCH   1
+#define NOMATCH 0
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
+MODULE_DESCRIPTION("iptables bridge physical device match module");
+MODULE_ALIAS("ipt_physdev");
+MODULE_ALIAS("ip6t_physdev");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	int i;
+	static const char nulldevname[IFNAMSIZ];
+	const struct xt_physdev_info *info =3D matchinfo;
+	unsigned int ret;
+	const char *indev, *outdev;
+	struct nf_bridge_info *nf_bridge;
+
+	/* Not a bridged IP packet or no info available yet:
+	 * LOCAL_OUT/mangle and LOCAL_OUT/nat don't know if
+	 * the destination device will be a bridge. */
+	if (!(nf_bridge =3D skb->nf_bridge)) {
+		/* Return MATCH if the invert flags of the used options are on */
+		if ((info->bitmask & XT_PHYSDEV_OP_BRIDGED) &&
+		    !(info->invert & XT_PHYSDEV_OP_BRIDGED))
+			return NOMATCH;
+		if ((info->bitmask & XT_PHYSDEV_OP_ISIN) &&
+		    !(info->invert & XT_PHYSDEV_OP_ISIN))
+			return NOMATCH;
+		if ((info->bitmask & XT_PHYSDEV_OP_ISOUT) &&
+		    !(info->invert & XT_PHYSDEV_OP_ISOUT))
+			return NOMATCH;
+		if ((info->bitmask & XT_PHYSDEV_OP_IN) &&
+		    !(info->invert & XT_PHYSDEV_OP_IN))
+			return NOMATCH;
+		if ((info->bitmask & XT_PHYSDEV_OP_OUT) &&
+		    !(info->invert & XT_PHYSDEV_OP_OUT))
+			return NOMATCH;
+		return MATCH;
+	}
+
+	/* This only makes sense in the FORWARD and POSTROUTING chains */
+	if ((info->bitmask & XT_PHYSDEV_OP_BRIDGED) &&
+	    (!!(nf_bridge->mask & BRNF_BRIDGED) ^
+	    !(info->invert & XT_PHYSDEV_OP_BRIDGED)))
+		return NOMATCH;
+
+	if ((info->bitmask & XT_PHYSDEV_OP_ISIN &&
+	    (!nf_bridge->physindev ^ !!(info->invert & XT_PHYSDEV_OP_ISIN))) ||
+	    (info->bitmask & XT_PHYSDEV_OP_ISOUT &&
+	    (!nf_bridge->physoutdev ^ !!(info->invert & XT_PHYSDEV_OP_ISOUT))))
+		return NOMATCH;
+
+	if (!(info->bitmask & XT_PHYSDEV_OP_IN))
+		goto match_outdev;
+	indev =3D nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
+	for (i =3D 0, ret =3D 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
+		ret |=3D (((const unsigned int *)indev)[i]
+			^ ((const unsigned int *)info->physindev)[i])
+			& ((const unsigned int *)info->in_mask)[i];
+	}
+
+	if ((ret =3D=3D 0) ^ !(info->invert & XT_PHYSDEV_OP_IN))
+		return NOMATCH;
+
+match_outdev:
+	if (!(info->bitmask & XT_PHYSDEV_OP_OUT))
+		return MATCH;
+	outdev =3D nf_bridge->physoutdev ?
+		 nf_bridge->physoutdev->name : nulldevname;
+	for (i =3D 0, ret =3D 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
+		ret |=3D (((const unsigned int *)outdev)[i]
+			^ ((const unsigned int *)info->physoutdev)[i])
+			& ((const unsigned int *)info->out_mask)[i];
+	}
+
+	return (ret !=3D 0) ^ !(info->invert & XT_PHYSDEV_OP_OUT);
+}
+
+static int
+checkentry(const char *tablename,
+		       const void *ip,
+		       void *matchinfo,
+		       unsigned int matchsize,
+		       unsigned int hook_mask)
+{
+	const struct xt_physdev_info *info =3D matchinfo;
+
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_physdev_info)))
+		return 0;
+	if (!(info->bitmask & XT_PHYSDEV_OP_MASK) ||
+	    info->bitmask & ~XT_PHYSDEV_OP_MASK)
+		return 0;
+	return 1;
+}
+
+static struct xt_match physdev_match =3D {
+	.name		=3D "physdev",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static struct xt_match physdev6_match =3D {
+	.name		=3D "physdev",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret =3D xt_register_match(AF_INET, &physdev_match);
+	if (ret < 0)
+		return ret;
+
+	ret =3D xt_register_match(AF_INET6, &physdev6_match);
+	if (ret < 0)
+		xt_unregister_match(AF_INET, &physdev_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &physdev_match);
+	xt_unregister_match(AF_INET6, &physdev6_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_pkttype.c
@@ -0,0 +1,82 @@
+/* (C) 1999-2001 Michal Ludvig <michal@logix.cz>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+
+#include <linux/netfilter/xt_pkttype.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michal Ludvig <michal@logix.cz>");
+MODULE_DESCRIPTION("IP tables match to match on linklayer packet type");
+MODULE_ALIAS("ipt_pkttype");
+MODULE_ALIAS("ip6t_pkttype");
+
+static int match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct xt_pkttype_info *info =3D matchinfo;
+
+	return (skb->pkt_type =3D=3D info->pkttype) ^ info->invert;
+}
+
+static int checkentry(const char *tablename,
+		   const void *ip,
+		   void *matchinfo,
+		   unsigned int matchsize,
+		   unsigned int hook_mask)
+{
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_pkttype_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct xt_match pkttype_match =3D {
+	.name		=3D "pkttype",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+static struct xt_match pkttype6_match =3D {
+	.name		=3D "pkttype",
+	.match		=3D &match,
+	.checkentry	=3D &checkentry,
+	.me		=3D THIS_MODULE,
+};
+
+
+static int __init init(void)
+{
+	int ret;
+	ret =3D xt_register_match(AF_INET, &pkttype_match);
+	if (ret)
+		return ret;
+
+	ret =3D xt_register_match(AF_INET6, &pkttype6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &pkttype_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &pkttype_match);
+	xt_unregister_match(AF_INET6, &pkttype6_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_realm.c
@@ -0,0 +1,78 @@
+/* IP tables module for matching the routing realm
+ *
+ * $Id: ipt_realm.c,v 1.3 2004/03/05 13:25:40 laforge Exp $
+ *
+ * (C) 2003 by Sampsa Ranta <sampsa@netsonic.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <net/route.h>
+
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter/xt_realm.h>
+#include <linux/netfilter/x_tables.h>
+
+MODULE_AUTHOR("Sampsa Ranta <sampsa@netsonic.fi>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("X_tables realm match");
+MODULE_ALIAS("ipt_realm");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct xt_realm_info *info =3D matchinfo;
+	struct dst_entry *dst =3D skb->dst;
+   =20
+	return (info->id =3D=3D (dst->tclassid & info->mask)) ^ info->invert;
+}
+
+static int check(const char *tablename,
+                 const void *ip,
+                 void *matchinfo,
+                 unsigned int matchsize,
+                 unsigned int hook_mask)
+{
+	if (hook_mask
+	    & ~((1 << NF_IP_POST_ROUTING) | (1 << NF_IP_FORWARD) |
+	        (1 << NF_IP_LOCAL_OUT) | (1 << NF_IP_LOCAL_IN))) {
+		printk("xt_realm: only valid for POST_ROUTING, LOCAL_OUT, "
+		       "LOCAL_IN or FORWARD.\n");
+		return 0;
+	}
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_realm_info))) {
+		printk("xt_realm: invalid matchsize.\n");
+		return 0;
+	}
+	return 1;
+}
+
+static struct xt_match realm_match =3D {
+	.name		=3D "realm",
+	.match		=3D match,=20
+	.checkentry	=3D check,
+	.me		=3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	return xt_register_match(AF_INET, &realm_match);
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &realm_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_state.c
@@ -0,0 +1,96 @@
+/* Kernel module to match connection tracking information. */
+
+/* (C) 1999-2001 Paul `Rusty' Russell
+ * (C) 2002-2005 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_state.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Rusty Russell <rusty@rustcorp.com.au>");
+MODULE_DESCRIPTION("ip[6]_tables connection tracking state match module");
+MODULE_ALIAS("ipt_state");
+MODULE_ALIAS("ip6t_state");
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
+{
+	const struct xt_state_info *sinfo =3D matchinfo;
+	enum ip_conntrack_info ctinfo;
+	unsigned int statebit;
+
+	if (skb->nfct =3D=3D &ip_conntrack_untracked.ct_general)
+		statebit =3D XT_STATE_UNTRACKED;
+	else if (!ip_conntrack_get(skb, &ctinfo))
+		statebit =3D XT_STATE_INVALID;
+	else
+		statebit =3D XT_STATE_BIT(ctinfo);
+
+	return (sinfo->statemask & statebit);
+}
+
+static int check(const char *tablename,
+		 const void *ip,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_state_info)))
+		return 0;
+
+	return 1;
+}
+
+static struct xt_match state_match =3D {
+	.name		=3D "state",
+	.match		=3D &match,
+	.checkentry	=3D &check,
+	.me		=3D THIS_MODULE,
+};
+
+static struct xt_match state6_match =3D {
+	.name		=3D "state",
+	.match		=3D &match,
+	.checkentry	=3D &check,
+	.me		=3D THIS_MODULE,
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	need_ip_conntrack();
+
+	ret =3D xt_register_match(AF_INET, &state_match);
+	if (ret < 0)
+		return ret;
+
+	ret =3D xt_register_match(AF_INET6, &state6_match);
+	if (ret < 0)
+		xt_unregister_match(AF_INET,&state_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &state_match);
+	xt_unregister_match(AF_INET6, &state6_match);
+}
+
+module_init(init);
+module_exit(fini);
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
new file mode 100644
--- /dev/null
+++ b/net/netfilter/xt_string.c
@@ -0,0 +1,111 @@
+/* String matching match for iptables
+ *=20
+ * (C) 2005 Pablo Neira Ayuso <pablo@eurodev.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_string.h>
+#include <linux/textsearch.h>
+
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@eurodev.net>");
+MODULE_DESCRIPTION("IP tables string match module");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_string");
+MODULE_ALIAS("ip6t_string");
+
+static int match(const struct sk_buff *skb,
+		 const struct net_device *in,
+		 const struct net_device *out,
+		 const void *matchinfo,
+		 int offset,
+		 unsigned int protoff,
+		 int *hotdrop)
+{
+	struct ts_state state;
+	struct xt_string_info *conf =3D (struct xt_string_info *) matchinfo;
+
+	memset(&state, 0, sizeof(struct ts_state));
+
+	return (skb_find_text((struct sk_buff *)skb, conf->from_offset,=20
+			     conf->to_offset, conf->config, &state)=20
+			     !=3D UINT_MAX) && !conf->invert;
+}
+
+#define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)
+
+static int checkentry(const char *tablename,
+		      const void *ip,
+		      void *matchinfo,
+		      unsigned int matchsize,
+		      unsigned int hook_mask)
+{
+	struct xt_string_info *conf =3D matchinfo;
+	struct ts_config *ts_conf;
+
+	if (matchsize !=3D XT_ALIGN(sizeof(struct xt_string_info)))
+		return 0;
+
+	/* Damn, can't handle this case properly with iptables... */
+	if (conf->from_offset > conf->to_offset)
+		return 0;
+
+	ts_conf =3D textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
+				     GFP_KERNEL, TS_AUTOLOAD);
+	if (IS_ERR(ts_conf))
+		return 0;
+
+	conf->config =3D ts_conf;
+
+	return 1;
+}
+
+static void destroy(void *matchinfo, unsigned int matchsize)
+{
+	textsearch_destroy(STRING_TEXT_PRIV(matchinfo)->config);
+}
+
+static struct xt_match string_match =3D {
+	.name 		=3D "string",
+	.match 		=3D match,
+	.checkentry	=3D checkentry,
+	.destroy 	=3D destroy,
+	.me 		=3D THIS_MODULE
+};
+static struct xt_match string6_match =3D {
+	.name 		=3D "string",
+	.match 		=3D match,
+	.checkentry	=3D checkentry,
+	.destroy 	=3D destroy,
+	.me 		=3D THIS_MODULE
+};
+
+static int __init init(void)
+{
+	int ret;
+
+	ret =3D xt_register_match(AF_INET, &string_match);
+	if (ret)
+		return ret;
+	ret =3D xt_register_match(AF_INET6, &string6_match);
+	if (ret)
+		xt_unregister_match(AF_INET, &string_match);
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	xt_unregister_match(AF_INET, &string_match);
+	xt_unregister_match(AF_INET6, &string6_match);
+}
+
+module_init(init);
+module_exit(fini);

--WIIRZ1HQ6FgrlPgb--

--BghK6+krpKHjj+jk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZ1uXaXGVTD0i/8RAgUbAJ9g9G/3oQ48Px0/NdmmegT1X1BlQgCffqHb
ulCiKRynqP48EJ6TIH6s/jY=
=8dMN
-----END PGP SIGNATURE-----

--BghK6+krpKHjj+jk--
