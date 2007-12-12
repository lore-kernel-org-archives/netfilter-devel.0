From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BUG?] ip6tables: 32bit userspace doesn't work with 64bit kernel
Date: Wed, 12 Dec 2007 18:10:30 +0100
Message-ID: <47601606.5010009@trash.net>
References: <20071208223737.GA8885@dreamland.darkstar.lan>	 <475C1425.7070608@trash.net> <68676e00712100509q1fcbf42dx6bcb46e95467ac91@mail.gmail.com> <475F9DA4.4000502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040408020301010801070900"
Cc: netfilter-devel@vger.kernel.org
To: Luca Tettamanti <kronos.it@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50772 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbXLLRKj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:10:39 -0500
In-Reply-To: <475F9DA4.4000502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040408020301010801070900
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Luca Tettamanti wrote:
>
>> Ok, feel free to throw patches this way for testing ;-)
> 
> 
> I've completed the compat support, but its about 25 patches -
> do you want me to start throwing? :) Otherwise just wait for
> a few days, I'll send them upstream as soon as the iptables
> compat fix is in net-2.6.25 since they depend on that one.


I figured out how to tell git to export them all as one big
patch, so if you want to do some testing, please go ahead.
Might apply to Linus' current -git tree, otherwise please
use net-2.6.25.

  include/linux/netfilter/x_tables.h        |   47 +
  include/linux/netfilter_arp/arp_tables.h  |   17
  include/linux/netfilter_ipv4/ip_tables.h  |   76 -
  include/linux/netfilter_ipv6/ip6_tables.h |   73 -
  net/compat.c                              |  106 --
  net/ipv4/netfilter/ip_tables.c            |  321 +++----
  net/ipv6/netfilter/ip6_tables.c           | 1204 
++++++++++++++++++++++++------
  net/netfilter/x_tables.c                  |    5
  net/netfilter/xt_CONNMARK.c               |    5
  net/netfilter/xt_MARK.c                   |   15
  net/netfilter/xt_connmark.c               |    5
  net/netfilter/xt_limit.c                  |    5
  net/netfilter/xt_mark.c                   |    5
  13 files changed, 1299 insertions(+), 585 deletions(-)


--------------040408020301010801070900
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index e305f2d..fdde1a0 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -318,6 +318,49 @@ extern void xt_proto_fini(int af);
 extern struct xt_table_info *xt_alloc_table_info(unsigned int size);
 extern void xt_free_table_info(struct xt_table_info *info);
 
+/* fn returns 0 to continue iteration */
+#define XT_MATCH_ITERATE(type, e, fn, args...)			\
+({								\
+	unsigned int __i;					\
+	int __ret = 0;						\
+	struct xt_entry_match *__m;				\
+								\
+	for (__i = sizeof(type);				\
+	     __i < (e)->target_offset;				\
+	     __i += __m->u.match_size) {			\
+		__m = (void *)e + __i;				\
+								\
+		__ret = fn(__m , ## args);			\
+		if (__ret != 0)					\
+			break;					\
+	}							\
+	__ret;							\
+})
+
+/* fn returns 0 to continue iteration */
+#define XT_ENTRY_ITERATE_CONTINUE(type, entries, size, n, fn, args...) \
+({								\
+	unsigned int __i, __n;					\
+	int __ret = 0;						\
+	type *__entry;						\
+								\
+	for (__i = 0, __n = 0; __i < (size);			\
+	     __i += __entry->next_offset, __n++) { 		\
+		__entry = (void *)(entries) + __i;		\
+		if (__n < n)					\
+			continue;				\
+								\
+		__ret = fn(__entry , ## args);			\
+		if (__ret != 0)					\
+			break;					\
+	}							\
+	__ret;							\
+})
+
+/* fn returns 0 to continue iteration */
+#define XT_ENTRY_ITERATE(type, entries, size, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(type, entries, size, 0, fn, args)
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
@@ -382,8 +425,8 @@ extern void xt_compat_lock(int af);
 extern void xt_compat_unlock(int af);
 
 extern int xt_compat_match_offset(struct xt_match *match);
-extern void xt_compat_match_from_user(struct xt_entry_match *m,
-				      void **dstptr, int *size);
+extern int xt_compat_match_from_user(struct xt_entry_match *m,
+				     void **dstptr, int *size);
 extern int xt_compat_match_to_user(struct xt_entry_match *m,
 				   void __user **dstptr, int *size);
 
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 2fc73fa..e44811b 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -217,21 +217,8 @@ static __inline__ struct arpt_entry_target *arpt_get_target(struct arpt_entry *e
 }
 
 /* fn returns 0 to continue iteration */
-#define ARPT_ENTRY_ITERATE(entries, size, fn, args...)		\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct arpt_entry *__entry;				\
-								\
-	for (__i = 0; __i < (size); __i += __entry->next_offset) { \
-		__entry = (void *)(entries) + __i;		\
-								\
-		__ret = fn(__entry , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+#define ARPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct arpt_entry, entries, size, fn, ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 54da616..45fcad9 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -229,60 +229,12 @@ ipt_get_target(struct ipt_entry *e)
 }
 
 /* fn returns 0 to continue iteration */
-#define IPT_MATCH_ITERATE(e, fn, args...)	\
-({						\
-	unsigned int __i;			\
-	int __ret = 0;				\
-	struct ipt_entry_match *__match;	\
-						\
-	for (__i = sizeof(struct ipt_entry);	\
-	     __i < (e)->target_offset;		\
-	     __i += __match->u.match_size) {	\
-		__match = (void *)(e) + __i;	\
-						\
-		__ret = fn(__match , ## args);	\
-		if (__ret != 0)			\
-			break;			\
-	}					\
-	__ret;					\
-})
+#define IPT_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct ipt_entry, e, fn, ## args)
 
 /* fn returns 0 to continue iteration */
-#define IPT_ENTRY_ITERATE(entries, size, fn, args...)		\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct ipt_entry *__entry;				\
-								\
-	for (__i = 0; __i < (size); __i += __entry->next_offset) { \
-		__entry = (void *)(entries) + __i;		\
-								\
-		__ret = fn(__entry , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
-
-/* fn returns 0 to continue iteration */
-#define IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
-({								\
-	unsigned int __i, __n;					\
-	int __ret = 0;						\
-	struct ipt_entry *__entry;				\
-								\
-	for (__i = 0, __n = 0; __i < (size);			\
-	     __i += __entry->next_offset, __n++) { 		\
-		__entry = (void *)(entries) + __i;		\
-		if (__n < n)					\
-			continue;				\
-								\
-		__ret = fn(__entry , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+#define IPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ipt_entry, entries, size, fn, ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
@@ -359,8 +311,28 @@ struct compat_ipt_entry
 	unsigned char elems[0];
 };
 
+/* Helper functions */
+static inline struct ipt_entry_target *
+compat_ipt_get_target(struct compat_ipt_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
 #define COMPAT_IPT_ALIGN(s) 	COMPAT_XT_ALIGN(s)
 
+/* fn returns 0 to continue iteration */
+#define COMPAT_IPT_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct compat_ipt_entry, e, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IPT_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct compat_ipt_entry, entries, size, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IPT_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(struct compat_ipt_entry, entries, size, n, \
+				  fn, ## args)
+
 #endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 2e98654..110801d 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -289,40 +289,12 @@ ip6t_get_target(struct ip6t_entry *e)
 }
 
 /* fn returns 0 to continue iteration */
-#define IP6T_MATCH_ITERATE(e, fn, args...)	\
-({						\
-	unsigned int __i;			\
-	int __ret = 0;				\
-	struct ip6t_entry_match *__m;		\
-						\
-	for (__i = sizeof(struct ip6t_entry);	\
-	     __i < (e)->target_offset;		\
-	     __i += __m->u.match_size) {	\
-		__m = (void *)(e) + __i;	\
-						\
-		__ret = fn(__m , ## args);	\
-		if (__ret != 0)			\
-			break;			\
-	}					\
-	__ret;					\
-})
+#define IP6T_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct ip6t_entry, e, fn, ## args)
 
 /* fn returns 0 to continue iteration */
-#define IP6T_ENTRY_ITERATE(entries, size, fn, args...)		\
-({								\
-	unsigned int __i;					\
-	int __ret = 0;						\
-	struct ip6t_entry *__e;					\
-								\
-	for (__i = 0; __i < (size); __i += __e->next_offset) {	\
-		__e = (void *)(entries) + __i;			\
-								\
-		__ret = fn(__e , ## args);			\
-		if (__ret != 0)					\
-			break;					\
-	}							\
-	__ret;							\
-})
+#define IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct ip6t_entry, entries, size, fn, ## args)
 
 /*
  *	Main firewall chains definitions and global var's definitions.
@@ -352,7 +324,42 @@ extern int ip6_masked_addrcmp(const struct in6_addr *addr1,
 			      const struct in6_addr *mask,
 			      const struct in6_addr *addr2);
 
-#define IP6T_ALIGN(s) (((s) + (__alignof__(struct ip6t_entry)-1)) & ~(__alignof__(struct ip6t_entry)-1))
+#define IP6T_ALIGN(s) XT_ALIGN(s)
 
+#ifdef CONFIG_COMPAT
+#include <net/compat.h>
+
+struct compat_ip6t_entry
+{
+	struct ip6t_ip6 ipv6;
+	compat_uint_t nfcache;
+	u_int16_t target_offset;
+	u_int16_t next_offset;
+	compat_uint_t comefrom;
+	struct compat_xt_counters counters;
+	unsigned char elems[0];
+};
+
+static inline struct ip6t_entry_target *
+compat_ip6t_get_target(struct compat_ip6t_entry *e)
+{
+	return (void *)e + e->target_offset;
+}
+
+#define COMPAT_IP6T_ALIGN(s)	COMPAT_XT_ALIGN(s)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IP6T_MATCH_ITERATE(e, fn, args...) \
+	XT_MATCH_ITERATE(struct compat_ip6t_entry, e, fn, ## args)
+
+/* fn returns 0 to continue iteration */
+#define COMPAT_IP6T_ENTRY_ITERATE(entries, size, fn, args...) \
+	XT_ENTRY_ITERATE(struct compat_ip6t_entry, entries, size, fn, ## args)
+
+#define COMPAT_IP6T_ENTRY_ITERATE_CONTINUE(entries, size, n, fn, args...) \
+	XT_ENTRY_ITERATE_CONTINUE(struct compat_ip6t_entry, entries, size, n, \
+				  fn, ## args)
+
+#endif /* CONFIG_COMPAT */
 #endif /*__KERNEL__*/
 #endif /* _IP6_TABLES_H */
diff --git a/net/compat.c b/net/compat.c
index b599cf1..96ec55e 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -20,7 +20,6 @@
 #include <linux/syscalls.h>
 #include <linux/filter.h>
 #include <linux/compat.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/security.h>
 
 #include <net/scm.h>
@@ -315,107 +314,6 @@ void scm_detach_fds_compat(struct msghdr *kmsg, struct scm_cookie *scm)
 }
 
 /*
- * For now, we assume that the compatibility and native version
- * of struct ipt_entry are the same - sfr.  FIXME
- */
-struct compat_ipt_replace {
-	char			name[IPT_TABLE_MAXNAMELEN];
-	u32			valid_hooks;
-	u32			num_entries;
-	u32			size;
-	u32			hook_entry[NF_INET_NUMHOOKS];
-	u32			underflow[NF_INET_NUMHOOKS];
-	u32			num_counters;
-	compat_uptr_t		counters;	/* struct ipt_counters * */
-	struct ipt_entry	entries[0];
-};
-
-static int do_netfilter_replace(int fd, int level, int optname,
-				char __user *optval, int optlen)
-{
-	struct compat_ipt_replace __user *urepl;
-	struct ipt_replace __user *repl_nat;
-	char name[IPT_TABLE_MAXNAMELEN];
-	u32 origsize, tmp32, num_counters;
-	unsigned int repl_nat_size;
-	int ret;
-	int i;
-	compat_uptr_t ucntrs;
-
-	urepl = (struct compat_ipt_replace __user *)optval;
-	if (get_user(origsize, &urepl->size))
-		return -EFAULT;
-
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (optlen != sizeof(*urepl) + origsize)
-		return -ENOPROTOOPT;
-
-	/* XXX Assumes that size of ipt_entry is the same both in
-	 *     native and compat environments.
-	 */
-	repl_nat_size = sizeof(*repl_nat) + origsize;
-	repl_nat = compat_alloc_user_space(repl_nat_size);
-
-	ret = -EFAULT;
-	if (put_user(origsize, &repl_nat->size))
-		goto out;
-
-	if (!access_ok(VERIFY_READ, urepl, optlen) ||
-	    !access_ok(VERIFY_WRITE, repl_nat, optlen))
-		goto out;
-
-	if (__copy_from_user(name, urepl->name, sizeof(urepl->name)) ||
-	    __copy_to_user(repl_nat->name, name, sizeof(repl_nat->name)))
-		goto out;
-
-	if (__get_user(tmp32, &urepl->valid_hooks) ||
-	    __put_user(tmp32, &repl_nat->valid_hooks))
-		goto out;
-
-	if (__get_user(tmp32, &urepl->num_entries) ||
-	    __put_user(tmp32, &repl_nat->num_entries))
-		goto out;
-
-	if (__get_user(num_counters, &urepl->num_counters) ||
-	    __put_user(num_counters, &repl_nat->num_counters))
-		goto out;
-
-	if (__get_user(ucntrs, &urepl->counters) ||
-	    __put_user(compat_ptr(ucntrs), &repl_nat->counters))
-		goto out;
-
-	if (__copy_in_user(&repl_nat->entries[0],
-			   &urepl->entries[0],
-			   origsize))
-		goto out;
-
-	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		if (__get_user(tmp32, &urepl->hook_entry[i]) ||
-		    __put_user(tmp32, &repl_nat->hook_entry[i]) ||
-		    __get_user(tmp32, &urepl->underflow[i]) ||
-		    __put_user(tmp32, &repl_nat->underflow[i]))
-			goto out;
-	}
-
-	/*
-	 * Since struct ipt_counters just contains two u_int64_t members
-	 * we can just do the access_ok check here and pass the (converted)
-	 * pointer into the standard syscall.  We hope that the pointer is
-	 * not misaligned ...
-	 */
-	if (!access_ok(VERIFY_WRITE, compat_ptr(ucntrs),
-		       num_counters * sizeof(struct ipt_counters)))
-		goto out;
-
-
-	ret = sys_setsockopt(fd, level, optname,
-			     (char __user *)repl_nat, repl_nat_size);
-
-out:
-	return ret;
-}
-
-/*
  * A struct sock_filter is architecture independent.
  */
 struct compat_sock_fprog {
@@ -483,10 +381,6 @@ asmlinkage long compat_sys_setsockopt(int fd, int level, int optname,
 	int err;
 	struct socket *sock;
 
-	if (level == SOL_IPV6 && optname == IPT_SO_SET_REPLACE)
-		return do_netfilter_replace(fd, level, optname,
-					    optval, optlen);
-
 	if (optlen < 0)
 		return -EINVAL;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 64ffe57..0f97043 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -74,7 +74,7 @@ do {								\
    Hence the start of any table is given by get_table() below.  */
 
 /* Returns whether matches rule or not. */
-static inline int
+static inline bool
 ip_packet_match(const struct iphdr *ip,
 		const char *indev,
 		const char *outdev,
@@ -102,7 +102,7 @@ ip_packet_match(const struct iphdr *ip,
 			NIPQUAD(ipinfo->dmsk.s_addr),
 			NIPQUAD(ipinfo->dst.s_addr),
 			ipinfo->invflags & IPT_INV_DSTIP ? " (INV)" : "");
-		return 0;
+		return false;
 	}
 
 	/* Look for ifname matches; this should unroll nicely. */
@@ -116,7 +116,7 @@ ip_packet_match(const struct iphdr *ip,
 		dprintf("VIA in mismatch (%s vs %s).%s\n",
 			indev, ipinfo->iniface,
 			ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
 	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned long); i++) {
@@ -129,7 +129,7 @@ ip_packet_match(const struct iphdr *ip,
 		dprintf("VIA out mismatch (%s vs %s).%s\n",
 			outdev, ipinfo->outiface,
 			ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
 	/* Check specific protocol */
@@ -138,7 +138,7 @@ ip_packet_match(const struct iphdr *ip,
 		dprintf("Packet protocol %hi does not match %hi.%s\n",
 			ip->protocol, ipinfo->proto,
 			ipinfo->invflags&IPT_INV_PROTO ? " (INV)":"");
-		return 0;
+		return false;
 	}
 
 	/* If we have a fragment rule but the packet is not a fragment
@@ -146,10 +146,10 @@ ip_packet_match(const struct iphdr *ip,
 	if (FWINV((ipinfo->flags&IPT_F_FRAG) && !isfrag, IPT_INV_FRAG)) {
 		dprintf("Fragment rule but not fragment.%s\n",
 			ipinfo->invflags & IPT_INV_FRAG ? " (INV)" : "");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static inline bool
@@ -222,7 +222,7 @@ unconditional(const struct ipt_ip *ip)
 static const char *hooknames[] = {
 	[NF_INET_PRE_ROUTING]		= "PREROUTING",
 	[NF_INET_LOCAL_IN]		= "INPUT",
-	[NF_INET_FORWARD]			= "FORWARD",
+	[NF_INET_FORWARD]		= "FORWARD",
 	[NF_INET_LOCAL_OUT]		= "OUTPUT",
 	[NF_INET_POST_ROUTING]		= "POSTROUTING",
 };
@@ -467,8 +467,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 	   to 0 as we leave), and comefrom to save source hook bitmask */
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
-		struct ipt_entry *e
-			= (struct ipt_entry *)(entry0 + pos);
+		struct ipt_entry *e = (struct ipt_entry *)(entry0 + pos);
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
@@ -486,8 +485,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 				       hook, pos, e->comefrom);
 				return 0;
 			}
-			e->comefrom
-				|= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
+			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
 			if ((e->target_offset == sizeof(struct ipt_entry)
@@ -589,7 +587,8 @@ check_entry(struct ipt_entry *e, const char *name)
 		return -EINVAL;
 	}
 
-	if (e->target_offset + sizeof(struct ipt_entry_target) > e->next_offset)
+	if (e->target_offset + sizeof(struct ipt_entry_target) >
+	    e->next_offset)
 		return -EINVAL;
 
 	t = ipt_get_target(e);
@@ -600,8 +599,8 @@ check_entry(struct ipt_entry *e, const char *name)
 }
 
 static inline int check_match(struct ipt_entry_match *m, const char *name,
-				const struct ipt_ip *ip, unsigned int hookmask,
-				unsigned int *i)
+			      const struct ipt_ip *ip,
+			      unsigned int hookmask, unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
@@ -624,16 +623,16 @@ static inline int check_match(struct ipt_entry_match *m, const char *name,
 
 static inline int
 find_check_match(struct ipt_entry_match *m,
-	    const char *name,
-	    const struct ipt_ip *ip,
-	    unsigned int hookmask,
-	    unsigned int *i)
+		 const char *name,
+		 const struct ipt_ip *ip,
+		 unsigned int hookmask,
+		 unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						   m->u.user.revision),
+						      m->u.user.revision),
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
@@ -663,8 +662,8 @@ static inline int check_target(struct ipt_entry *e, const char *name)
 			      name, e->comefrom, e->ip.proto,
 			      e->ip.invflags & IPT_INV_PROTO);
 	if (!ret && t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target,
-						      t->data, e->comefrom)) {
+	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
+					       e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
@@ -674,7 +673,7 @@ static inline int check_target(struct ipt_entry *e, const char *name)
 
 static inline int
 find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
-	    unsigned int *i)
+		 unsigned int *i)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -687,14 +686,14 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 
 	j = 0;
 	ret = IPT_MATCH_ITERATE(e, find_check_match, name, &e->ip,
-							e->comefrom, &j);
+				e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
-						     t->u.user.name,
-						     t->u.user.revision),
+							t->u.user.name,
+							t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
@@ -959,7 +958,6 @@ copy_entries_to_user(unsigned int total_size,
 	 * allowed to migrate to another cpu)
 	 */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
-	/* ... then copy entire thing ... */
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
 		goto free_counters;
@@ -1020,7 +1018,7 @@ struct compat_delta {
 	short delta;
 };
 
-static struct compat_delta *compat_offsets = NULL;
+static struct compat_delta *compat_offsets;
 
 static int compat_add_offset(unsigned int offset, short delta)
 {
@@ -1046,7 +1044,7 @@ static void compat_flush_offsets(void)
 	struct compat_delta *tmp, *next;
 
 	if (compat_offsets) {
-		for(tmp = compat_offsets; tmp; tmp = next) {
+		for (tmp = compat_offsets; tmp; tmp = next) {
 			next = tmp->next;
 			kfree(tmp);
 		}
@@ -1059,7 +1057,7 @@ static short compat_calc_jump(unsigned int offset)
 	struct compat_delta *tmp;
 	short delta;
 
-	for(tmp = compat_offsets, delta = 0; tmp; tmp = tmp->next)
+	for (tmp = compat_offsets, delta = 0; tmp; tmp = tmp->next)
 		if (tmp->offset < offset)
 			delta += tmp->delta;
 	return delta;
@@ -1084,21 +1082,21 @@ static int compat_standard_to_user(void __user *dst, void *src)
 }
 
 static inline int
-compat_calc_match(struct ipt_entry_match *m, int * size)
+compat_calc_match(struct ipt_entry_match *m, int *size)
 {
 	*size += xt_compat_match_offset(m->u.kernel.match);
 	return 0;
 }
 
 static int compat_calc_entry(struct ipt_entry *e,
-		const struct xt_table_info *info,
-		void *base, struct xt_table_info *newinfo)
+			     const struct xt_table_info *info,
+			     void *base, struct xt_table_info *newinfo)
 {
 	struct ipt_entry_target *t;
 	unsigned int entry_offset;
 	int off, i, ret;
 
-	off = 0;
+	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - base;
 	IPT_MATCH_ITERATE(e, compat_calc_match, &off);
 	t = ipt_get_target(e);
@@ -1109,18 +1107,18 @@ static int compat_calc_entry(struct ipt_entry *e,
 		return ret;
 
 	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
-		if (info->hook_entry[i] && (e < (struct ipt_entry *)
-				(base + info->hook_entry[i])))
+		if (info->hook_entry[i] &&
+		    (e < (struct ipt_entry *)(base + info->hook_entry[i])))
 			newinfo->hook_entry[i] -= off;
-		if (info->underflow[i] && (e < (struct ipt_entry *)
-				(base + info->underflow[i])))
+		if (info->underflow[i] &&
+		    (e < (struct ipt_entry *)(base + info->underflow[i])))
 			newinfo->underflow[i] -= off;
 	}
 	return 0;
 }
 
 static int compat_table_info(const struct xt_table_info *info,
-		struct xt_table_info *newinfo)
+			     struct xt_table_info *newinfo)
 {
 	void *loc_cpu_entry;
 
@@ -1132,7 +1130,8 @@ static int compat_table_info(const struct xt_table_info *info,
 	newinfo->initial_entries = 0;
 	loc_cpu_entry = info->entries[raw_smp_processor_id()];
 	return IPT_ENTRY_ITERATE(loc_cpu_entry, info->size,
-			compat_calc_entry, info, loc_cpu_entry, newinfo);
+				 compat_calc_entry, info, loc_cpu_entry,
+				 newinfo);
 }
 #endif
 
@@ -1143,8 +1142,8 @@ static int get_info(void __user *user, int *len, int compat)
 	int ret;
 
 	if (*len != sizeof(struct ipt_getinfo)) {
-		duprintf("length %u != %u\n", *len,
-			(unsigned int)sizeof(struct ipt_getinfo));
+		duprintf("length %u != %zu\n", *len,
+			 sizeof(struct ipt_getinfo));
 		return -EINVAL;
 	}
 
@@ -1157,7 +1156,7 @@ static int get_info(void __user *user, int *len, int compat)
 		xt_compat_lock(AF_INET);
 #endif
 	t = try_then_request_module(xt_find_table_lock(AF_INET, name),
-			"iptable_%s", name);
+				    "iptable_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ipt_getinfo info;
 		struct xt_table_info *private = t->private;
@@ -1167,14 +1166,14 @@ static int get_info(void __user *user, int *len, int compat)
 			struct xt_table_info tmp;
 			ret = compat_table_info(private, &tmp);
 			compat_flush_offsets();
-			private =  &tmp;
+			private = &tmp;
 		}
 #endif
 		info.valid_hooks = t->valid_hooks;
 		memcpy(info.hook_entry, private->hook_entry,
-				sizeof(info.hook_entry));
+		       sizeof(info.hook_entry));
 		memcpy(info.underflow, private->underflow,
-				sizeof(info.underflow));
+		       sizeof(info.underflow));
 		info.num_entries = private->number;
 		info.size = private->size;
 		strcpy(info.name, name);
@@ -1203,31 +1202,27 @@ get_entries(struct ipt_get_entries __user *uptr, int *len)
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
-		duprintf("get_entries: %u < %d\n", *len,
-				(unsigned int)sizeof(get));
+		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
 		return -EINVAL;
 	}
 	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
 		return -EFAULT;
 	if (*len != sizeof(struct ipt_get_entries) + get.size) {
-		duprintf("get_entries: %u != %u\n", *len,
-				(unsigned int)(sizeof(struct ipt_get_entries) +
-				get.size));
+		duprintf("get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
 
 	t = xt_find_table_lock(AF_INET, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
-		duprintf("t->private->number = %u\n",
-			 private->number);
+		duprintf("t->private->number = %u\n", private->number);
 		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size,
-				 get.size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		module_put(t->me);
@@ -1240,8 +1235,8 @@ get_entries(struct ipt_get_entries __user *uptr, int *len)
 
 static int
 __do_replace(const char *name, unsigned int valid_hooks,
-		struct xt_table_info *newinfo, unsigned int num_counters,
-		void __user *counters_ptr)
+	     struct xt_table_info *newinfo, unsigned int num_counters,
+	     void __user *counters_ptr)
 {
 	int ret;
 	struct xt_table *t;
@@ -1289,7 +1284,8 @@ __do_replace(const char *name, unsigned int valid_hooks,
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
+			  NULL);
 	xt_free_table_info(oldinfo);
 	if (copy_to_user(counters_ptr, counters,
 			 sizeof(struct xt_counters) * num_counters) != 0)
@@ -1318,10 +1314,6 @@ do_replace(void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (len != sizeof(tmp) + tmp.size)
-		return -ENOPROTOOPT;
-
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
@@ -1330,7 +1322,7 @@ do_replace(void __user *user, unsigned int len)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy that is our node/cpu */
+	/* choose the copy that is on our node/cpu */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
@@ -1346,15 +1338,14 @@ do_replace(void __user *user, unsigned int len)
 
 	duprintf("ip_tables: Translated table\n");
 
-	ret = __do_replace(tmp.name, tmp.valid_hooks,
-			      newinfo, tmp.num_counters,
-			      tmp.counters);
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
 	if (ret)
 		goto free_newinfo_untrans;
 	return 0;
 
  free_newinfo_untrans:
-	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1479,12 +1470,6 @@ struct compat_ipt_replace {
 	struct compat_ipt_entry	entries[0];
 };
 
-static inline int compat_copy_match_to_user(struct ipt_entry_match *m,
-		void __user **dstptr, compat_uint_t *size)
-{
-	return xt_compat_match_to_user(m, dstptr, size);
-}
-
 static int
 compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 			  compat_uint_t *size, struct xt_counters *counters,
@@ -1506,7 +1491,9 @@ compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 		goto out;
 
 	*dstptr += sizeof(struct compat_ipt_entry);
-	ret = IPT_MATCH_ITERATE(e, compat_copy_match_to_user, dstptr, size);
+	*size -= sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
+
+	ret = IPT_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
 	target_offset = e->target_offset - (origsize - *size);
 	if (ret)
 		goto out;
@@ -1529,19 +1516,19 @@ out:
 
 static inline int
 compat_find_calc_match(struct ipt_entry_match *m,
-	    const char *name,
-	    const struct ipt_ip *ip,
-	    unsigned int hookmask,
-	    int *size, int *i)
+		       const char *name,
+		       const struct ipt_ip *ip,
+		       unsigned int hookmask,
+		       int *size, int *i)
 {
 	struct xt_match *match;
 
 	match = try_then_request_module(xt_find_match(AF_INET, m->u.user.name,
-						   m->u.user.revision),
+						      m->u.user.revision),
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("compat_check_calc_match: `%s' not found\n",
-				m->u.user.name);
+			 m->u.user.name);
 		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match = match;
@@ -1562,7 +1549,7 @@ compat_release_match(struct ipt_entry_match *m, unsigned int *i)
 }
 
 static inline int
-compat_release_entry(struct ipt_entry *e, unsigned int *i)
+compat_release_entry(struct compat_ipt_entry *e, unsigned int *i)
 {
 	struct ipt_entry_target *t;
 
@@ -1570,22 +1557,22 @@ compat_release_entry(struct ipt_entry *e, unsigned int *i)
 		return 1;
 
 	/* Cleanup all matches */
-	IPT_MATCH_ITERATE(e, compat_release_match, NULL);
-	t = ipt_get_target(e);
+	COMPAT_IPT_MATCH_ITERATE(e, compat_release_match, NULL);
+	t = compat_ipt_get_target(e);
 	module_put(t->u.kernel.target->me);
 	return 0;
 }
 
 static inline int
-check_compat_entry_size_and_hooks(struct ipt_entry *e,
-			   struct xt_table_info *newinfo,
-			   unsigned int *size,
-			   unsigned char *base,
-			   unsigned char *limit,
-			   unsigned int *hook_entries,
-			   unsigned int *underflows,
-			   unsigned int *i,
-			   const char *name)
+check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
+				  struct xt_table_info *newinfo,
+				  unsigned int *size,
+				  unsigned char *base,
+				  unsigned char *limit,
+				  unsigned int *hook_entries,
+				  unsigned int *underflows,
+				  unsigned int *i,
+				  const char *name)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -1600,32 +1587,33 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	}
 
 	if (e->next_offset < sizeof(struct compat_ipt_entry) +
-			sizeof(struct compat_xt_entry_target)) {
+			     sizeof(struct compat_xt_entry_target)) {
 		duprintf("checking: element %p size %u\n",
 			 e, e->next_offset);
 		return -EINVAL;
 	}
 
-	ret = check_entry(e, name);
+	/* For purposes of check_entry casting the compat entry is fine */
+	ret = check_entry((struct ipt_entry *)e, name);
 	if (ret)
 		return ret;
 
-	off = 0;
+	off = sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
 	entry_offset = (void *)e - (void *)base;
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, compat_find_calc_match, name, &e->ip,
-			e->comefrom, &off, &j);
+	ret = COMPAT_IPT_MATCH_ITERATE(e, compat_find_calc_match, name,
+				       &e->ip, e->comefrom, &off, &j);
 	if (ret != 0)
 		goto release_matches;
 
-	t = ipt_get_target(e);
+	t = compat_ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
-						     t->u.user.name,
-						     t->u.user.revision),
+							t->u.user.name,
+							t->u.user.revision),
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
-							t->u.user.name);
+			 t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto release_matches;
 	}
@@ -1646,7 +1634,7 @@ check_compat_entry_size_and_hooks(struct ipt_entry *e,
 	}
 
 	/* Clear counters and comefrom */
-	e->counters = ((struct ipt_counters) { 0, 0 });
+	memset(&e->counters, 0, sizeof(e->counters));
 	e->comefrom = 0;
 
 	(*i)++;
@@ -1659,17 +1647,10 @@ release_matches:
 	return ret;
 }
 
-static inline int compat_copy_match_from_user(struct ipt_entry_match *m,
-	void **dstptr, compat_uint_t *size, const char *name,
-	const struct ipt_ip *ip, unsigned int hookmask)
-{
-	xt_compat_match_from_user(m, dstptr, size);
-	return 0;
-}
-
-static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
-	unsigned int *size, const char *name,
-	struct xt_table_info *newinfo, unsigned char *base)
+static int
+compat_copy_entry_from_user(struct compat_ipt_entry *e, void **dstptr,
+			    unsigned int *size, const char *name,
+			    struct xt_table_info *newinfo, unsigned char *base)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -1681,14 +1662,17 @@ static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 	origsize = *size;
 	de = (struct ipt_entry *)*dstptr;
 	memcpy(de, e, sizeof(struct ipt_entry));
+	memcpy(&de->counters, &e->counters, sizeof(e->counters));
 
-	*dstptr += sizeof(struct compat_ipt_entry);
-	ret = IPT_MATCH_ITERATE(e, compat_copy_match_from_user, dstptr, size,
-			name, &de->ip, de->comefrom);
+	*dstptr += sizeof(struct ipt_entry);
+	*size += sizeof(struct ipt_entry) - sizeof(struct compat_ipt_entry);
+
+	ret = COMPAT_IPT_MATCH_ITERATE(e, xt_compat_match_from_user,
+				       dstptr, size);
 	if (ret)
 		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
-	t = ipt_get_target(e);
+	t = compat_ipt_get_target(e);
 	target = t->u.kernel.target;
 	xt_compat_target_from_user(t, dstptr, size);
 
@@ -1703,12 +1687,13 @@ static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
 }
 
 static inline int compat_check_entry(struct ipt_entry *e, const char *name,
-						unsigned int *i)
+				     unsigned int *i)
 {
 	int j, ret;
 
 	j = 0;
-	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip, e->comefrom, &j);
+	ret = IPT_MATCH_ITERATE(e, check_match, name, &e->ip,
+				e->comefrom, &j);
 	if (ret)
 		goto cleanup_matches;
 
@@ -1726,13 +1711,13 @@ static inline int compat_check_entry(struct ipt_entry *e, const char *name,
 
 static int
 translate_compat_table(const char *name,
-		unsigned int valid_hooks,
-		struct xt_table_info **pinfo,
-		void **pentry0,
-		unsigned int total_size,
-		unsigned int number,
-		unsigned int *hook_entries,
-		unsigned int *underflows)
+		       unsigned int valid_hooks,
+		       struct xt_table_info **pinfo,
+		       void **pentry0,
+		       unsigned int total_size,
+		       unsigned int number,
+		       unsigned int *hook_entries,
+		       unsigned int *underflows)
 {
 	unsigned int i, j;
 	struct xt_table_info *newinfo, *info;
@@ -1755,11 +1740,11 @@ translate_compat_table(const char *name,
 	j = 0;
 	xt_compat_lock(AF_INET);
 	/* Walk through entries, checking offsets. */
-	ret = IPT_ENTRY_ITERATE(entry0, total_size,
-				check_compat_entry_size_and_hooks,
-				info, &size, entry0,
-				entry0 + total_size,
-				hook_entries, underflows, &j, name);
+	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
+				       check_compat_entry_size_and_hooks,
+				       info, &size, entry0,
+				       entry0 + total_size,
+				       hook_entries, underflows, &j, name);
 	if (ret != 0)
 		goto out_unlock;
 
@@ -1799,10 +1784,10 @@ translate_compat_table(const char *name,
 	}
 	entry1 = newinfo->entries[raw_smp_processor_id()];
 	pos = entry1;
-	size =  total_size;
-	ret = IPT_ENTRY_ITERATE(entry0, total_size,
-			compat_copy_entry_from_user, &pos, &size,
-			name, newinfo, entry1);
+	size = total_size;
+	ret = COMPAT_IPT_ENTRY_ITERATE(entry0, total_size,
+				       compat_copy_entry_from_user,
+				       &pos, &size, name, newinfo, entry1);
 	compat_flush_offsets();
 	xt_compat_unlock(AF_INET);
 	if (ret)
@@ -1814,11 +1799,11 @@ translate_compat_table(const char *name,
 
 	i = 0;
 	ret = IPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
-								name, &i);
+				name, &i);
 	if (ret) {
 		j -= i;
-		IPT_ENTRY_ITERATE_CONTINUE(entry1, newinfo->size, i,
-						compat_release_entry, &j);
+		COMPAT_IPT_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
+						  compat_release_entry, &j);
 		IPT_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
 		xt_free_table_info(newinfo);
 		return ret;
@@ -1837,7 +1822,7 @@ translate_compat_table(const char *name,
 free_newinfo:
 	xt_free_table_info(newinfo);
 out:
-	IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	COMPAT_IPT_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
 	return ret;
 out_unlock:
 	compat_flush_offsets();
@@ -1856,10 +1841,6 @@ compat_do_replace(void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-	/* Hack: Causes ipchains to give correct error msg --RR */
-	if (len != sizeof(tmp) + tmp.size)
-		return -ENOPROTOOPT;
-
 	/* overflow check */
 	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
@@ -1870,7 +1851,7 @@ compat_do_replace(void __user *user, unsigned int len)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy that is our node/cpu */
+	/* choose the copy that is on our node/cpu */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
 			   tmp.size) != 0) {
@@ -1879,22 +1860,22 @@ compat_do_replace(void __user *user, unsigned int len)
 	}
 
 	ret = translate_compat_table(tmp.name, tmp.valid_hooks,
-			      &newinfo, &loc_cpu_entry, tmp.size,
-			      tmp.num_entries, tmp.hook_entry, tmp.underflow);
+				     &newinfo, &loc_cpu_entry, tmp.size,
+				     tmp.num_entries, tmp.hook_entry,
+				     tmp.underflow);
 	if (ret != 0)
 		goto free_newinfo;
 
 	duprintf("compat_do_replace: Translated table\n");
 
-	ret = __do_replace(tmp.name, tmp.valid_hooks,
-			      newinfo, tmp.num_counters,
-			      compat_ptr(tmp.counters));
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, compat_ptr(tmp.counters));
 	if (ret)
 		goto free_newinfo_untrans;
 	return 0;
 
  free_newinfo_untrans:
-	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
+	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1902,7 +1883,7 @@ compat_do_replace(void __user *user, unsigned int len)
 
 static int
 compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
-		unsigned int len)
+		      unsigned int len)
 {
 	int ret;
 
@@ -1926,15 +1907,15 @@ compat_do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user,
 	return ret;
 }
 
-struct compat_ipt_get_entries
-{
+struct compat_ipt_get_entries {
 	char name[IPT_TABLE_MAXNAMELEN];
 	compat_uint_t size;
 	struct compat_ipt_entry entrytable[0];
 };
 
-static int compat_copy_entries_to_user(unsigned int total_size,
-		     struct xt_table *table, void __user *userptr)
+static int
+compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
+			    void __user *userptr)
 {
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
@@ -1970,10 +1951,8 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 	struct compat_ipt_get_entries get;
 	struct xt_table *t;
 
-
 	if (*len < sizeof(get)) {
-		duprintf("compat_get_entries: %u < %u\n",
-				*len, (unsigned int)sizeof(get));
+		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
 		return -EINVAL;
 	}
 
@@ -1981,9 +1960,8 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 		return -EFAULT;
 
 	if (*len != sizeof(struct compat_ipt_get_entries) + get.size) {
-		duprintf("compat_get_entries: %u != %u\n", *len,
-			(unsigned int)(sizeof(struct compat_ipt_get_entries) +
-			get.size));
+		duprintf("compat_get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
 		return -EINVAL;
 	}
 
@@ -1992,16 +1970,14 @@ compat_get_entries(struct compat_ipt_get_entries __user *uptr, int *len)
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		struct xt_table_info info;
-		duprintf("t->private->number = %u\n",
-			 private->number);
+		duprintf("t->private->number = %u\n", private->number);
 		ret = compat_table_info(private, &info);
 		if (!ret && get.size == info.size) {
 			ret = compat_copy_entries_to_user(private->size,
-						   t, uptr->entrytable);
+							  t, uptr->entrytable);
 		} else if (!ret) {
 			duprintf("compat_get_entries: I've got %u not %u!\n",
-				 private->size,
-				 get.size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		compat_flush_offsets();
@@ -2039,7 +2015,7 @@ compat_do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 #endif
 
 static int
-do_ipt_set_ctl(struct sock *sk,	int cmd, void __user *user, unsigned int len)
+do_ipt_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 {
 	int ret;
 
@@ -2126,9 +2102,7 @@ int ipt_register_table(struct xt_table *table, const struct ipt_replace *repl)
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy on our node/cpu
-	 * but dont care of preemption
-	 */
+	/* choose the copy on our node/cpu, but dont care about preemption */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
@@ -2170,7 +2144,8 @@ icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 		     u_int8_t type, u_int8_t code,
 		     bool invert)
 {
-	return ((test_type == 0xFF) || (type == test_type && code >= min_code && code <= max_code))
+	return ((test_type == 0xFF) ||
+		(type == test_type && code >= min_code && code <= max_code))
 		^ invert;
 }
 
@@ -2211,7 +2186,7 @@ icmp_match(const struct sk_buff *skb,
 /* Called when user tries to insert an entry of this type. */
 static bool
 icmp_checkentry(const char *tablename,
-	   const void *info,
+	   const void *entry,
 	   const struct xt_match *match,
 	   void *matchinfo,
 	   unsigned int hook_mask)
@@ -2262,9 +2237,9 @@ static struct xt_match icmp_matchstruct __read_mostly = {
 	.name		= "icmp",
 	.match		= icmp_match,
 	.matchsize	= sizeof(struct ipt_icmp),
+	.checkentry	= icmp_checkentry,
 	.proto		= IPPROTO_ICMP,
 	.family		= AF_INET,
-	.checkentry	= icmp_checkentry,
 };
 
 static int __init ip_tables_init(void)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d3e884a..2e74a2e 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -19,9 +19,11 @@
 #include <linux/poison.h>
 #include <linux/icmpv6.h>
 #include <net/ipv6.h>
+#include <net/compat.h>
 #include <asm/uaccess.h>
 #include <linux/mutex.h>
 #include <linux/proc_fs.h>
+#include <linux/err.h>
 #include <linux/cpumask.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
@@ -31,9 +33,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("IPv6 packet filter");
 
-#define IPV6_HDR_LEN	(sizeof(struct ipv6hdr))
-#define IPV6_OPTHDR_LEN	(sizeof(struct ipv6_opt_hdr))
-
 /*#define DEBUG_IP_FIREWALL*/
 /*#define DEBUG_ALLOW_ALL*/ /* Useful for remote debugging */
 /*#define DEBUG_IP_FIREWALL_USER*/
@@ -76,12 +75,6 @@ do {								\
 
    Hence the start of any table is given by get_table() below.  */
 
-#if 0
-#define down(x) do { printk("DOWN:%u:" #x "\n", __LINE__); down(x); } while(0)
-#define down_interruptible(x) ({ int __r; printk("DOWNi:%u:" #x "\n", __LINE__); __r = down_interruptible(x); if (__r != 0) printk("ABORT-DOWNi:%u\n", __LINE__); __r; })
-#define up(x) do { printk("UP:%u:" #x "\n", __LINE__); up(x); } while(0)
-#endif
-
 /* Check for an extension */
 int
 ip6t_ext_hdr(u8 nexthdr)
@@ -378,8 +371,8 @@ ip6t_do_table(struct sk_buff *skb,
 	 * match it. */
 
 	read_lock_bh(&table->lock);
-	private = table->private;
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
+	private = table->private;
 	table_base = (void *)private->entries[smp_processor_id()];
 	e = get_entry(table_base, private->hook_entry[hook]);
 
@@ -399,9 +392,8 @@ ip6t_do_table(struct sk_buff *skb,
 				goto no_match;
 
 			ADD_COUNTER(e->counters,
-				    ntohs(ipv6_hdr(skb)->payload_len)
-				    + IPV6_HDR_LEN,
-				    1);
+				    ntohs(ipv6_hdr(skb)->payload_len) +
+				    sizeof(struct ipv6hdr), 1);
 
 			t = ip6t_get_target(e);
 			IP_NF_ASSERT(t->u.kernel.target);
@@ -504,9 +496,7 @@ mark_source_chains(struct xt_table_info *newinfo,
 	   to 0 as we leave), and comefrom to save source hook bitmask */
 	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
 		unsigned int pos = newinfo->hook_entry[hook];
-		struct ip6t_entry *e
-			= (struct ip6t_entry *)(entry0 + pos);
-		int visited = e->comefrom & (1 << hook);
+		struct ip6t_entry *e = (struct ip6t_entry *)(entry0 + pos);
 
 		if (!(valid_hooks & (1 << hook)))
 			continue;
@@ -517,14 +507,14 @@ mark_source_chains(struct xt_table_info *newinfo,
 		for (;;) {
 			struct ip6t_standard_target *t
 				= (void *)ip6t_get_target(e);
+			int visited = e->comefrom & (1 << hook);
 
 			if (e->comefrom & (1 << NF_INET_NUMHOOKS)) {
 				printk("iptables: loop hook %u pos %u %08X.\n",
 				       hook, pos, e->comefrom);
 				return 0;
 			}
-			e->comefrom
-				|= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
+			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
 			if ((e->target_offset == sizeof(struct ip6t_entry)
@@ -617,101 +607,134 @@ cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
 }
 
 static inline int
-check_match(struct ip6t_entry_match *m,
-	    const char *name,
-	    const struct ip6t_ip6 *ipv6,
-	    unsigned int hookmask,
-	    unsigned int *i)
+check_entry(struct ip6t_entry *e, const char *name)
+{
+	struct ip6t_entry_target *t;
+
+	if (!ip6_checkentry(&e->ipv6)) {
+		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
+		return -EINVAL;
+	}
+
+	if (e->target_offset + sizeof(struct ip6t_entry_target) >
+	    e->next_offset)
+		return -EINVAL;
+
+	t = ip6t_get_target(e);
+	if (e->target_offset + t->u.target_size > e->next_offset)
+		return -EINVAL;
+
+	return 0;
+}
+
+static inline int check_match(struct ip6t_entry_match *m, const char *name,
+			      const struct ip6t_ip6 *ipv6,
+			      unsigned int hookmask, unsigned int *i)
+{
+	struct xt_match *match;
+	int ret;
+
+	match = m->u.kernel.match;
+	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
+			     name, hookmask, ipv6->proto,
+			     ipv6->invflags & IP6T_INV_PROTO);
+	if (!ret && m->u.kernel.match->checkentry
+	    && !m->u.kernel.match->checkentry(name, ipv6, match, m->data,
+					      hookmask)) {
+		duprintf("ip_tables: check failed for `%s'.\n",
+			 m->u.kernel.match->name);
+		ret = -EINVAL;
+	}
+	if (!ret)
+		(*i)++;
+	return ret;
+}
+
+static inline int
+find_check_match(struct ip6t_entry_match *m,
+		 const char *name,
+		 const struct ip6t_ip6 *ipv6,
+		 unsigned int hookmask,
+		 unsigned int *i)
 {
 	struct xt_match *match;
 	int ret;
 
 	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
-					m->u.user.revision),
+						      m->u.user.revision),
 					"ip6t_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
-		duprintf("check_match: `%s' not found\n", m->u.user.name);
+		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
 		return match ? PTR_ERR(match) : -ENOENT;
 	}
 	m->u.kernel.match = match;
 
-	ret = xt_check_match(match, AF_INET6, m->u.match_size - sizeof(*m),
-			     name, hookmask, ipv6->proto,
-			     ipv6->invflags & IP6T_INV_PROTO);
+	ret = check_match(m, name, ipv6, hookmask, i);
 	if (ret)
 		goto err;
 
-	if (m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ipv6, match,  m->data,
-					      hookmask)) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	(*i)++;
 	return 0;
 err:
 	module_put(m->u.kernel.match->me);
 	return ret;
 }
 
-static struct xt_target ip6t_standard_target;
+static inline int check_target(struct ip6t_entry *e, const char *name)
+{
+	struct ip6t_entry_target *t;
+	struct xt_target *target;
+	int ret;
+
+	t = ip6t_get_target(e);
+	target = t->u.kernel.target;
+	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
+			      name, e->comefrom, e->ipv6.proto,
+			      e->ipv6.invflags & IP6T_INV_PROTO);
+	if (!ret && t->u.kernel.target->checkentry
+	    && !t->u.kernel.target->checkentry(name, e, target, t->data,
+					       e->comefrom)) {
+		duprintf("ip_tables: check failed for `%s'.\n",
+			 t->u.kernel.target->name);
+		ret = -EINVAL;
+	}
+	return ret;
+}
 
 static inline int
-check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
-	    unsigned int *i)
+find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
+		 unsigned int *i)
 {
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
 	int ret;
 	unsigned int j;
 
-	if (!ip6_checkentry(&e->ipv6)) {
-		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
-		return -EINVAL;
-	}
-
-	if (e->target_offset + sizeof(struct ip6t_entry_target) >
-								e->next_offset)
-		return -EINVAL;
+	ret = check_entry(e, name);
+	if (ret)
+		return ret;
 
 	j = 0;
-	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6, e->comefrom, &j);
+	ret = IP6T_MATCH_ITERATE(e, find_check_match, name, &e->ipv6,
+				 e->comefrom, &j);
 	if (ret != 0)
 		goto cleanup_matches;
 
 	t = ip6t_get_target(e);
-	ret = -EINVAL;
-	if (e->target_offset + t->u.target_size > e->next_offset)
-			goto cleanup_matches;
 	target = try_then_request_module(xt_find_target(AF_INET6,
 							t->u.user.name,
 							t->u.user.revision),
 					 "ip6t_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
-		duprintf("check_entry: `%s' not found\n", t->u.user.name);
+		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
 
-	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, e->ipv6.proto,
-			      e->ipv6.invflags & IP6T_INV_PROTO);
+	ret = check_target(e, name);
 	if (ret)
 		goto err;
 
-	if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
-						      e->comefrom)) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 t->u.kernel.target->name);
-		ret = -EINVAL;
-		goto err;
-	}
-
 	(*i)++;
 	return 0;
  err:
@@ -846,7 +869,7 @@ translate_table(const char *name,
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				check_entry, name, size, &i);
+				find_check_entry, name, size, &i);
 
 	if (ret != 0) {
 		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
@@ -860,7 +883,7 @@ translate_table(const char *name,
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
-	return 0;
+	return ret;
 }
 
 /* Gets counters. */
@@ -920,33 +943,49 @@ get_counters(const struct xt_table_info *t,
 	}
 }
 
-static int
-copy_entries_to_user(unsigned int total_size,
-		     struct xt_table *table,
-		     void __user *userptr)
+static inline struct xt_counters *alloc_counters(struct xt_table *table)
 {
-	unsigned int off, num, countersize;
-	struct ip6t_entry *e;
+	unsigned int countersize;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
-	int ret = 0;
-	void *loc_cpu_entry;
 
 	/* We need atomic snapshot of counters: rest doesn't change
 	   (other than comefrom, which userspace doesn't care
 	   about). */
 	countersize = sizeof(struct xt_counters) * private->number;
-	counters = vmalloc(countersize);
+	counters = vmalloc_node(countersize, numa_node_id());
 
 	if (counters == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	/* First, sum counters... */
 	write_lock_bh(&table->lock);
 	get_counters(private, counters);
 	write_unlock_bh(&table->lock);
 
-	/* choose the copy that is on ourc node/cpu */
+	return counters;
+}
+
+static int
+copy_entries_to_user(unsigned int total_size,
+		     struct xt_table *table,
+		     void __user *userptr)
+{
+	unsigned int off, num;
+	struct ip6t_entry *e;
+	struct xt_counters *counters;
+	struct xt_table_info *private = table->private;
+	int ret = 0;
+	void *loc_cpu_entry;
+
+	counters = alloc_counters(table);
+	if (IS_ERR(counters))
+		return PTR_ERR(counters);
+
+	/* choose the copy that is on our node/cpu, ...
+	 * This choice is lazy (because current thread is
+	 * allowed to migrate to another cpu)
+	 */
 	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	if (copy_to_user(userptr, loc_cpu_entry, total_size) != 0) {
 		ret = -EFAULT;
@@ -1001,23 +1040,218 @@ copy_entries_to_user(unsigned int total_size,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_delta {
+	struct compat_delta *next;
+	unsigned int offset;
+	short delta;
+};
+
+static struct compat_delta *compat_offsets;
+
+static int compat_add_offset(unsigned int offset, short delta)
+{
+	struct compat_delta *tmp;
+
+	tmp = kmalloc(sizeof(struct compat_delta), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+	tmp->offset = offset;
+	tmp->delta = delta;
+	if (compat_offsets) {
+		tmp->next = compat_offsets->next;
+		compat_offsets->next = tmp;
+	} else {
+		compat_offsets = tmp;
+		tmp->next = NULL;
+	}
+	return 0;
+}
+
+static void compat_flush_offsets(void)
+{
+	struct compat_delta *tmp, *next;
+
+	if (compat_offsets) {
+		for (tmp = compat_offsets; tmp; tmp = next) {
+			next = tmp->next;
+			kfree(tmp);
+		}
+		compat_offsets = NULL;
+	}
+}
+
+static short compat_calc_jump(unsigned int offset)
+{
+	struct compat_delta *tmp;
+	short delta;
+
+	for (tmp = compat_offsets, delta = 0; tmp; tmp = tmp->next)
+		if (tmp->offset < offset)
+			delta += tmp->delta;
+	return delta;
+}
+
+static void compat_standard_from_user(void *dst, void *src)
+{
+	int v = *(compat_int_t *)src;
+
+	if (v > 0)
+		v += compat_calc_jump(v);
+	memcpy(dst, &v, sizeof(v));
+}
+
+static int compat_standard_to_user(void __user *dst, void *src)
+{
+	compat_int_t cv = *(int *)src;
+
+	if (cv > 0)
+		cv -= compat_calc_jump(cv);
+	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
+}
+
+static inline int
+compat_calc_match(struct ip6t_entry_match *m, int *size)
+{
+	*size += xt_compat_match_offset(m->u.kernel.match);
+	return 0;
+}
+
+static int compat_calc_entry(struct ip6t_entry *e,
+			     const struct xt_table_info *info,
+			     void *base, struct xt_table_info *newinfo)
+{
+	struct ip6t_entry_target *t;
+	unsigned int entry_offset;
+	int off, i, ret;
+
+	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+	entry_offset = (void *)e - base;
+	IP6T_MATCH_ITERATE(e, compat_calc_match, &off);
+	t = ip6t_get_target(e);
+	off += xt_compat_target_offset(t->u.kernel.target);
+	newinfo->size -= off;
+	ret = compat_add_offset(entry_offset, off);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		if (info->hook_entry[i] &&
+		    (e < (struct ip6t_entry *)(base + info->hook_entry[i])))
+			newinfo->hook_entry[i] -= off;
+		if (info->underflow[i] &&
+		    (e < (struct ip6t_entry *)(base + info->underflow[i])))
+			newinfo->underflow[i] -= off;
+	}
+	return 0;
+}
+
+static int compat_table_info(const struct xt_table_info *info,
+			     struct xt_table_info *newinfo)
+{
+	void *loc_cpu_entry;
+
+	if (!newinfo || !info)
+		return -EINVAL;
+
+	/* we dont care about newinfo->entries[] */
+	memcpy(newinfo, info, offsetof(struct xt_table_info, entries));
+	newinfo->initial_entries = 0;
+	loc_cpu_entry = info->entries[raw_smp_processor_id()];
+	return IP6T_ENTRY_ITERATE(loc_cpu_entry, info->size,
+				  compat_calc_entry, info, loc_cpu_entry,
+				  newinfo);
+}
+#endif
+
+static int get_info(void __user *user, int *len, int compat)
+{
+	char name[IP6T_TABLE_MAXNAMELEN];
+	struct xt_table *t;
+	int ret;
+
+	if (*len != sizeof(struct ip6t_getinfo)) {
+		duprintf("length %u != %zu\n", *len,
+			 sizeof(struct ip6t_getinfo));
+		return -EINVAL;
+	}
+
+	if (copy_from_user(name, user, sizeof(name)) != 0)
+		return -EFAULT;
+
+	name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
+#ifdef CONFIG_COMPAT
+	if (compat)
+		xt_compat_lock(AF_INET6);
+#endif
+	t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
+				    "ip6table_%s", name);
+	if (t && !IS_ERR(t)) {
+		struct ip6t_getinfo info;
+		struct xt_table_info *private = t->private;
+
+#ifdef CONFIG_COMPAT
+		if (compat) {
+			struct xt_table_info tmp;
+			ret = compat_table_info(private, &tmp);
+			compat_flush_offsets();
+			private = &tmp;
+		}
+#endif
+		info.valid_hooks = t->valid_hooks;
+		memcpy(info.hook_entry, private->hook_entry,
+		       sizeof(info.hook_entry));
+		memcpy(info.underflow, private->underflow,
+		       sizeof(info.underflow));
+		info.num_entries = private->number;
+		info.size = private->size;
+		strcpy(info.name, name);
+
+		if (copy_to_user(user, &info, *len) != 0)
+			ret = -EFAULT;
+		else
+			ret = 0;
+
+		xt_table_unlock(t);
+		module_put(t->me);
+	} else
+		ret = t ? PTR_ERR(t) : -ENOENT;
+#ifdef CONFIG_COMPAT
+	if (compat)
+		xt_compat_unlock(AF_INET6);
+#endif
+	return ret;
+}
+
 static int
-get_entries(const struct ip6t_get_entries *entries,
-	    struct ip6t_get_entries __user *uptr)
+get_entries(struct ip6t_get_entries __user *uptr, int *len)
 {
 	int ret;
+	struct ip6t_get_entries get;
 	struct xt_table *t;
 
-	t = xt_find_table_lock(AF_INET6, entries->name);
+	if (*len < sizeof(get)) {
+		duprintf("get_entries: %u < %zu\n", *len, sizeof(get));
+		return -EINVAL;
+	}
+	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
+		return -EFAULT;
+	if (*len != sizeof(struct ip6t_get_entries) + get.size) {
+		duprintf("get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
+		return -EINVAL;
+	}
+
+	t = xt_find_table_lock(AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
 		duprintf("t->private->number = %u\n", private->number);
-		if (entries->size == private->size)
+		if (get.size == private->size)
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
 		else {
 			duprintf("get_entries: I've got %u not %u!\n",
-				 private->size, entries->size);
+				 private->size, get.size);
 			ret = -EINVAL;
 		}
 		module_put(t->me);
@@ -1029,64 +1263,39 @@ get_entries(const struct ip6t_get_entries *entries,
 }
 
 static int
-do_replace(void __user *user, unsigned int len)
+__do_replace(const char *name, unsigned int valid_hooks,
+	     struct xt_table_info *newinfo, unsigned int num_counters,
+	     void __user *counters_ptr)
 {
 	int ret;
-	struct ip6t_replace tmp;
 	struct xt_table *t;
-	struct xt_table_info *newinfo, *oldinfo;
+	struct xt_table_info *oldinfo;
 	struct xt_counters *counters;
-	void *loc_cpu_entry, *loc_cpu_old_entry;
-
-	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
-		return -EFAULT;
-
-	/* overflow check */
-	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
-		return -ENOMEM;
-
-	newinfo = xt_alloc_table_info(tmp.size);
-	if (!newinfo)
-		return -ENOMEM;
-
-	/* choose the copy that is on our node/cpu */
-	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
-	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
-			   tmp.size) != 0) {
-		ret = -EFAULT;
-		goto free_newinfo;
-	}
+	void *loc_cpu_old_entry;
 
-	counters = vmalloc(tmp.num_counters * sizeof(struct xt_counters));
+	ret = 0;
+	counters = vmalloc(num_counters * sizeof(struct xt_counters));
 	if (!counters) {
 		ret = -ENOMEM;
-		goto free_newinfo;
+		goto out;
 	}
 
-	ret = translate_table(tmp.name, tmp.valid_hooks,
-			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
-	if (ret != 0)
-		goto free_newinfo_counters;
-
-	duprintf("ip_tables: Translated table\n");
-
-	t = try_then_request_module(xt_find_table_lock(AF_INET6, tmp.name),
-				    "ip6table_%s", tmp.name);
+	t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
+				    "ip6table_%s", name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free_newinfo_counters_untrans;
 	}
 
 	/* You lied! */
-	if (tmp.valid_hooks != t->valid_hooks) {
+	if (valid_hooks != t->valid_hooks) {
 		duprintf("Valid hook crap: %08X vs %08X\n",
-			 tmp.valid_hooks, t->valid_hooks);
+			 valid_hooks, t->valid_hooks);
 		ret = -EINVAL;
 		goto put_module;
 	}
 
-	oldinfo = xt_replace_table(t, tmp.num_counters, newinfo, &ret);
+	oldinfo = xt_replace_table(t, num_counters, newinfo, &ret);
 	if (!oldinfo)
 		goto put_module;
 
@@ -1104,10 +1313,11 @@ do_replace(void __user *user, unsigned int len)
 	get_counters(oldinfo, counters);
 	/* Decrease module usage counts and free resource */
 	loc_cpu_old_entry = oldinfo->entries[raw_smp_processor_id()];
-	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,NULL);
+	IP6T_ENTRY_ITERATE(loc_cpu_old_entry, oldinfo->size, cleanup_entry,
+			   NULL);
 	xt_free_table_info(oldinfo);
-	if (copy_to_user(tmp.counters, counters,
-			 sizeof(struct xt_counters) * tmp.num_counters) != 0)
+	if (copy_to_user(counters_ptr, counters,
+			 sizeof(struct xt_counters) * num_counters) != 0)
 		ret = -EFAULT;
 	vfree(counters);
 	xt_table_unlock(t);
@@ -1117,9 +1327,54 @@ do_replace(void __user *user, unsigned int len)
 	module_put(t->me);
 	xt_table_unlock(t);
  free_newinfo_counters_untrans:
-	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry,NULL);
- free_newinfo_counters:
 	vfree(counters);
+ out:
+	return ret;
+}
+
+static int
+do_replace(void __user *user, unsigned int len)
+{
+	int ret;
+	struct ip6t_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	ret = translate_table(tmp.name, tmp.valid_hooks,
+			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
+			      tmp.hook_entry, tmp.underflow);
+	if (ret != 0)
+		goto free_newinfo;
+
+	duprintf("ip_tables: Translated table\n");
+
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
  free_newinfo:
 	xt_free_table_info(newinfo);
 	return ret;
@@ -1148,31 +1403,59 @@ add_counter_to_entry(struct ip6t_entry *e,
 }
 
 static int
-do_add_counters(void __user *user, unsigned int len)
+do_add_counters(void __user *user, unsigned int len, int compat)
 {
 	unsigned int i;
-	struct xt_counters_info tmp, *paddc;
-	struct xt_table_info *private;
+	struct xt_counters_info tmp;
+	struct xt_counters *paddc;
+	unsigned int num_counters;
+	char *name;
+	int size;
+	void *ptmp;
 	struct xt_table *t;
+	struct xt_table_info *private;
 	int ret = 0;
 	void *loc_cpu_entry;
+#ifdef CONFIG_COMPAT
+	struct compat_xt_counters_info compat_tmp;
 
-	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+	if (compat) {
+		ptmp = &compat_tmp;
+		size = sizeof(struct compat_xt_counters_info);
+	} else
+#endif
+	{
+		ptmp = &tmp;
+		size = sizeof(struct xt_counters_info);
+	}
+
+	if (copy_from_user(ptmp, user, size) != 0)
 		return -EFAULT;
 
-	if (len != sizeof(tmp) + tmp.num_counters*sizeof(struct xt_counters))
+#ifdef CONFIG_COMPAT
+	if (compat) {
+		num_counters = compat_tmp.num_counters;
+		name = compat_tmp.name;
+	} else
+#endif
+	{
+		num_counters = tmp.num_counters;
+		name = tmp.name;
+	}
+
+	if (len != size + num_counters * sizeof(struct xt_counters))
 		return -EINVAL;
 
-	paddc = vmalloc(len);
+	paddc = vmalloc_node(len - size, numa_node_id());
 	if (!paddc)
 		return -ENOMEM;
 
-	if (copy_from_user(paddc, user, len) != 0) {
+	if (copy_from_user(paddc, user + size, len - size) != 0) {
 		ret = -EFAULT;
 		goto free;
 	}
 
-	t = xt_find_table_lock(AF_INET6, tmp.name);
+	t = xt_find_table_lock(AF_INET6, name);
 	if (!t || IS_ERR(t)) {
 		ret = t ? PTR_ERR(t) : -ENOENT;
 		goto free;
@@ -1180,18 +1463,18 @@ do_add_counters(void __user *user, unsigned int len)
 
 	write_lock_bh(&t->lock);
 	private = t->private;
-	if (private->number != tmp.num_counters) {
+	if (private->number != num_counters) {
 		ret = -EINVAL;
 		goto unlock_up_free;
 	}
 
 	i = 0;
 	/* Choose the copy that is on our node */
-	loc_cpu_entry = private->entries[smp_processor_id()];
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
 	IP6T_ENTRY_ITERATE(loc_cpu_entry,
 			  private->size,
 			  add_counter_to_entry,
-			  paddc->counters,
+			  paddc,
 			  &i);
  unlock_up_free:
 	write_unlock_bh(&t->lock);
@@ -1203,8 +1486,433 @@ do_add_counters(void __user *user, unsigned int len)
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_ip6t_replace {
+	char			name[IP6T_TABLE_MAXNAMELEN];
+	u32			valid_hooks;
+	u32			num_entries;
+	u32			size;
+	u32			hook_entry[NF_INET_NUMHOOKS];
+	u32			underflow[NF_INET_NUMHOOKS];
+	u32			num_counters;
+	compat_uptr_t		counters;	/* struct ip6t_counters * */
+	struct compat_ip6t_entry entries[0];
+};
+
 static int
-do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
+compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
+			  compat_uint_t *size, struct xt_counters *counters,
+			  unsigned int *i)
+{
+	struct ip6t_entry_target *t;
+	struct compat_ip6t_entry __user *ce;
+	u_int16_t target_offset, next_offset;
+	compat_uint_t origsize;
+	int ret;
+
+	ret = -EFAULT;
+	origsize = *size;
+	ce = (struct compat_ip6t_entry __user *)*dstptr;
+	if (copy_to_user(ce, e, sizeof(struct ip6t_entry)))
+		goto out;
+
+	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
+		goto out;
+
+	*dstptr += sizeof(struct compat_ip6t_entry);
+	*size -= sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+
+	ret = IP6T_MATCH_ITERATE(e, xt_compat_match_to_user, dstptr, size);
+	target_offset = e->target_offset - (origsize - *size);
+	if (ret)
+		goto out;
+	t = ip6t_get_target(e);
+	ret = xt_compat_target_to_user(t, dstptr, size);
+	if (ret)
+		goto out;
+	ret = -EFAULT;
+	next_offset = e->next_offset - (origsize - *size);
+	if (put_user(target_offset, &ce->target_offset))
+		goto out;
+	if (put_user(next_offset, &ce->next_offset))
+		goto out;
+
+	(*i)++;
+	return 0;
+out:
+	return ret;
+}
+
+static inline int
+compat_find_calc_match(struct ip6t_entry_match *m,
+		       const char *name,
+		       const struct ip6t_ip6 *ipv6,
+		       unsigned int hookmask,
+		       int *size, int *i)
+{
+	struct xt_match *match;
+
+	match = try_then_request_module(xt_find_match(AF_INET6, m->u.user.name,
+						      m->u.user.revision),
+					"ip6t_%s", m->u.user.name);
+	if (IS_ERR(match) || !match) {
+		duprintf("compat_check_calc_match: `%s' not found\n",
+			 m->u.user.name);
+		return match ? PTR_ERR(match) : -ENOENT;
+	}
+	m->u.kernel.match = match;
+	*size += xt_compat_match_offset(match);
+
+	(*i)++;
+	return 0;
+}
+
+static inline int
+compat_release_match(struct ip6t_entry_match *m, unsigned int *i)
+{
+	if (i && (*i)-- == 0)
+		return 1;
+
+	module_put(m->u.kernel.match->me);
+	return 0;
+}
+
+static inline int
+compat_release_entry(struct compat_ip6t_entry *e, unsigned int *i)
+{
+	struct ip6t_entry_target *t;
+
+	if (i && (*i)-- == 0)
+		return 1;
+
+	/* Cleanup all matches */
+	COMPAT_IP6T_MATCH_ITERATE(e, compat_release_match, NULL);
+	t = compat_ip6t_get_target(e);
+	module_put(t->u.kernel.target->me);
+	return 0;
+}
+
+static inline int
+check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
+				  struct xt_table_info *newinfo,
+				  unsigned int *size,
+				  unsigned char *base,
+				  unsigned char *limit,
+				  unsigned int *hook_entries,
+				  unsigned int *underflows,
+				  unsigned int *i,
+				  const char *name)
+{
+	struct ip6t_entry_target *t;
+	struct xt_target *target;
+	unsigned int entry_offset;
+	int ret, off, h, j;
+
+	duprintf("check_compat_entry_size_and_hooks %p\n", e);
+	if ((unsigned long)e % __alignof__(struct compat_ip6t_entry) != 0
+	    || (unsigned char *)e + sizeof(struct compat_ip6t_entry) >= limit) {
+		duprintf("Bad offset %p, limit = %p\n", e, limit);
+		return -EINVAL;
+	}
+
+	if (e->next_offset < sizeof(struct compat_ip6t_entry) +
+			     sizeof(struct compat_xt_entry_target)) {
+		duprintf("checking: element %p size %u\n",
+			 e, e->next_offset);
+		return -EINVAL;
+	}
+
+	/* For purposes of check_entry casting the compat entry is fine */
+	ret = check_entry((struct ip6t_entry *)e, name);
+	if (ret)
+		return ret;
+
+	off = sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+	entry_offset = (void *)e - (void *)base;
+	j = 0;
+	ret = COMPAT_IP6T_MATCH_ITERATE(e, compat_find_calc_match, name,
+					&e->ipv6, e->comefrom, &off, &j);
+	if (ret != 0)
+		goto release_matches;
+
+	t = compat_ip6t_get_target(e);
+	target = try_then_request_module(xt_find_target(AF_INET6,
+							t->u.user.name,
+							t->u.user.revision),
+					 "ip6t_%s", t->u.user.name);
+	if (IS_ERR(target) || !target) {
+		duprintf("check_compat_entry_size_and_hooks: `%s' not found\n",
+			 t->u.user.name);
+		ret = target ? PTR_ERR(target) : -ENOENT;
+		goto release_matches;
+	}
+	t->u.kernel.target = target;
+
+	off += xt_compat_target_offset(target);
+	*size += off;
+	ret = compat_add_offset(entry_offset, off);
+	if (ret)
+		goto out;
+
+	/* Check hooks & underflows */
+	for (h = 0; h < NF_INET_NUMHOOKS; h++) {
+		if ((unsigned char *)e - base == hook_entries[h])
+			newinfo->hook_entry[h] = hook_entries[h];
+		if ((unsigned char *)e - base == underflows[h])
+			newinfo->underflow[h] = underflows[h];
+	}
+
+	/* Clear counters and comefrom */
+	memset(&e->counters, 0, sizeof(e->counters));
+	e->comefrom = 0;
+
+	(*i)++;
+	return 0;
+
+out:
+	module_put(t->u.kernel.target->me);
+release_matches:
+	IP6T_MATCH_ITERATE(e, compat_release_match, &j);
+	return ret;
+}
+
+static int
+compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
+			    unsigned int *size, const char *name,
+			    struct xt_table_info *newinfo, unsigned char *base)
+{
+	struct ip6t_entry_target *t;
+	struct xt_target *target;
+	struct ip6t_entry *de;
+	unsigned int origsize;
+	int ret, h;
+
+	ret = 0;
+	origsize = *size;
+	de = (struct ip6t_entry *)*dstptr;
+	memcpy(de, e, sizeof(struct ip6t_entry));
+	memcpy(&de->counters, &e->counters, sizeof(e->counters));
+
+	*dstptr += sizeof(struct ip6t_entry);
+	*size += sizeof(struct ip6t_entry) - sizeof(struct compat_ip6t_entry);
+
+	ret = COMPAT_IP6T_MATCH_ITERATE(e, xt_compat_match_from_user,
+					dstptr, size);
+	if (ret)
+		return ret;
+	de->target_offset = e->target_offset - (origsize - *size);
+	t = compat_ip6t_get_target(e);
+	target = t->u.kernel.target;
+	xt_compat_target_from_user(t, dstptr, size);
+
+	de->next_offset = e->next_offset - (origsize - *size);
+	for (h = 0; h < NF_INET_NUMHOOKS; h++) {
+		if ((unsigned char *)de - base < newinfo->hook_entry[h])
+			newinfo->hook_entry[h] -= origsize - *size;
+		if ((unsigned char *)de - base < newinfo->underflow[h])
+			newinfo->underflow[h] -= origsize - *size;
+	}
+	return ret;
+}
+
+static inline int compat_check_entry(struct ip6t_entry *e, const char *name,
+				     unsigned int *i)
+{
+	int j, ret;
+
+	j = 0;
+	ret = IP6T_MATCH_ITERATE(e, check_match, name, &e->ipv6,
+				 e->comefrom, &j);
+	if (ret)
+		goto cleanup_matches;
+
+	ret = check_target(e, name);
+	if (ret)
+		goto cleanup_matches;
+
+	(*i)++;
+	return 0;
+
+ cleanup_matches:
+	IP6T_MATCH_ITERATE(e, cleanup_match, &j);
+	return ret;
+}
+
+static int
+translate_compat_table(const char *name,
+		       unsigned int valid_hooks,
+		       struct xt_table_info **pinfo,
+		       void **pentry0,
+		       unsigned int total_size,
+		       unsigned int number,
+		       unsigned int *hook_entries,
+		       unsigned int *underflows)
+{
+	unsigned int i, j;
+	struct xt_table_info *newinfo, *info;
+	void *pos, *entry0, *entry1;
+	unsigned int size;
+	int ret;
+
+	info = *pinfo;
+	entry0 = *pentry0;
+	size = total_size;
+	info->number = number;
+
+	/* Init all hooks to impossible value. */
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		info->hook_entry[i] = 0xFFFFFFFF;
+		info->underflow[i] = 0xFFFFFFFF;
+	}
+
+	duprintf("translate_compat_table: size %u\n", info->size);
+	j = 0;
+	xt_compat_lock(AF_INET6);
+	/* Walk through entries, checking offsets. */
+	ret = COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size,
+					check_compat_entry_size_and_hooks,
+					info, &size, entry0,
+					entry0 + total_size,
+					hook_entries, underflows, &j, name);
+	if (ret != 0)
+		goto out_unlock;
+
+	ret = -EINVAL;
+	if (j != number) {
+		duprintf("translate_compat_table: %u not %u entries\n",
+			 j, number);
+		goto out_unlock;
+	}
+
+	/* Check hooks all assigned */
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		/* Only hooks which are valid */
+		if (!(valid_hooks & (1 << i)))
+			continue;
+		if (info->hook_entry[i] == 0xFFFFFFFF) {
+			duprintf("Invalid hook entry %u %u\n",
+				 i, hook_entries[i]);
+			goto out_unlock;
+		}
+		if (info->underflow[i] == 0xFFFFFFFF) {
+			duprintf("Invalid underflow %u %u\n",
+				 i, underflows[i]);
+			goto out_unlock;
+		}
+	}
+
+	ret = -ENOMEM;
+	newinfo = xt_alloc_table_info(size);
+	if (!newinfo)
+		goto out_unlock;
+
+	newinfo->number = number;
+	for (i = 0; i < NF_INET_NUMHOOKS; i++) {
+		newinfo->hook_entry[i] = info->hook_entry[i];
+		newinfo->underflow[i] = info->underflow[i];
+	}
+	entry1 = newinfo->entries[raw_smp_processor_id()];
+	pos = entry1;
+	size = total_size;
+	ret = COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size,
+					compat_copy_entry_from_user,
+					&pos, &size, name, newinfo, entry1);
+	compat_flush_offsets();
+	xt_compat_unlock(AF_INET6);
+	if (ret)
+		goto free_newinfo;
+
+	ret = -ELOOP;
+	if (!mark_source_chains(newinfo, valid_hooks, entry1))
+		goto free_newinfo;
+
+	i = 0;
+	ret = IP6T_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
+				 name, &i);
+	if (ret) {
+		j -= i;
+		COMPAT_IP6T_ENTRY_ITERATE_CONTINUE(entry0, newinfo->size, i,
+						   compat_release_entry, &j);
+		IP6T_ENTRY_ITERATE(entry1, newinfo->size, cleanup_entry, &i);
+		xt_free_table_info(newinfo);
+		return ret;
+	}
+
+	/* And one copy for every other CPU */
+	for_each_possible_cpu(i)
+		if (newinfo->entries[i] && newinfo->entries[i] != entry1)
+			memcpy(newinfo->entries[i], entry1, newinfo->size);
+
+	*pinfo = newinfo;
+	*pentry0 = entry1;
+	xt_free_table_info(info);
+	return 0;
+
+free_newinfo:
+	xt_free_table_info(newinfo);
+out:
+	COMPAT_IP6T_ENTRY_ITERATE(entry0, total_size, compat_release_entry, &j);
+	return ret;
+out_unlock:
+	compat_flush_offsets();
+	xt_compat_unlock(AF_INET6);
+	goto out;
+}
+
+static int
+compat_do_replace(void __user *user, unsigned int len)
+{
+	int ret;
+	struct compat_ip6t_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.size >= INT_MAX / num_possible_cpus())
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	ret = translate_compat_table(tmp.name, tmp.valid_hooks,
+				     &newinfo, &loc_cpu_entry, tmp.size,
+				     tmp.num_entries, tmp.hook_entry,
+				     tmp.underflow);
+	if (ret != 0)
+		goto free_newinfo;
+
+	duprintf("compat_do_replace: Translated table\n");
+
+	ret = __do_replace(tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, compat_ptr(tmp.counters));
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+ free_newinfo:
+	xt_free_table_info(newinfo);
+	return ret;
+}
+
+static int
+compat_do_ip6t_set_ctl(struct sock *sk,	int cmd, void __user *user,
+		       unsigned int len)
 {
 	int ret;
 
@@ -1213,11 +1921,11 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 
 	switch (cmd) {
 	case IP6T_SO_SET_REPLACE:
-		ret = do_replace(user, len);
+		ret = compat_do_replace(user, len);
 		break;
 
 	case IP6T_SO_SET_ADD_COUNTERS:
-		ret = do_add_counters(user, len);
+		ret = do_add_counters(user, len, 1);
 		break;
 
 	default:
@@ -1228,75 +1936,155 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 	return ret;
 }
 
+struct compat_ip6t_get_entries {
+	char name[IP6T_TABLE_MAXNAMELEN];
+	compat_uint_t size;
+	struct compat_ip6t_entry entrytable[0];
+};
+
 static int
-do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
+compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
+			    void __user *userptr)
+{
+	struct xt_counters *counters;
+	struct xt_table_info *private = table->private;
+	void __user *pos;
+	unsigned int size;
+	int ret = 0;
+	void *loc_cpu_entry;
+	unsigned int i = 0;
+
+	counters = alloc_counters(table);
+	if (IS_ERR(counters))
+		return PTR_ERR(counters);
+
+	/* choose the copy that is on our node/cpu, ...
+	 * This choice is lazy (because current thread is
+	 * allowed to migrate to another cpu)
+	 */
+	loc_cpu_entry = private->entries[raw_smp_processor_id()];
+	pos = userptr;
+	size = total_size;
+	ret = IP6T_ENTRY_ITERATE(loc_cpu_entry, total_size,
+				 compat_copy_entry_to_user,
+				 &pos, &size, counters, &i);
+
+	vfree(counters);
+	return ret;
+}
+
+static int
+compat_get_entries(struct compat_ip6t_get_entries __user *uptr, int *len)
 {
 	int ret;
+	struct compat_ip6t_get_entries get;
+	struct xt_table *t;
 
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
+	if (*len < sizeof(get)) {
+		duprintf("compat_get_entries: %u < %zu\n", *len, sizeof(get));
+		return -EINVAL;
+	}
 
-	switch (cmd) {
-	case IP6T_SO_GET_INFO: {
-		char name[IP6T_TABLE_MAXNAMELEN];
-		struct xt_table *t;
+	if (copy_from_user(&get, uptr, sizeof(get)) != 0)
+		return -EFAULT;
+
+	if (*len != sizeof(struct compat_ip6t_get_entries) + get.size) {
+		duprintf("compat_get_entries: %u != %zu\n",
+			 *len, sizeof(get) + get.size);
+		return -EINVAL;
+	}
 
-		if (*len != sizeof(struct ip6t_getinfo)) {
-			duprintf("length %u != %u\n", *len,
-				 sizeof(struct ip6t_getinfo));
+	xt_compat_lock(AF_INET6);
+	t = xt_find_table_lock(AF_INET6, get.name);
+	if (t && !IS_ERR(t)) {
+		struct xt_table_info *private = t->private;
+		struct xt_table_info info;
+		duprintf("t->private->number = %u\n", private->number);
+		ret = compat_table_info(private, &info);
+		if (!ret && get.size == info.size) {
+			ret = compat_copy_entries_to_user(private->size,
+							  t, uptr->entrytable);
+		} else if (!ret) {
+			duprintf("compat_get_entries: I've got %u not %u!\n",
+				 private->size, get.size);
 			ret = -EINVAL;
-			break;
 		}
+		compat_flush_offsets();
+		module_put(t->me);
+		xt_table_unlock(t);
+	} else
+		ret = t ? PTR_ERR(t) : -ENOENT;
 
-		if (copy_from_user(name, user, sizeof(name)) != 0) {
-			ret = -EFAULT;
-			break;
-		}
-		name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
-
-		t = try_then_request_module(xt_find_table_lock(AF_INET6, name),
-					    "ip6table_%s", name);
-		if (t && !IS_ERR(t)) {
-			struct ip6t_getinfo info;
-			struct xt_table_info *private = t->private;
-
-			info.valid_hooks = t->valid_hooks;
-			memcpy(info.hook_entry, private->hook_entry,
-			       sizeof(info.hook_entry));
-			memcpy(info.underflow, private->underflow,
-			       sizeof(info.underflow));
-			info.num_entries = private->number;
-			info.size = private->size;
-			memcpy(info.name, name, sizeof(info.name));
-
-			if (copy_to_user(user, &info, *len) != 0)
-				ret = -EFAULT;
-			else
-				ret = 0;
-			xt_table_unlock(t);
-			module_put(t->me);
-		} else
-			ret = t ? PTR_ERR(t) : -ENOENT;
+	xt_compat_unlock(AF_INET6);
+	return ret;
+}
+
+static int do_ip6t_get_ctl(struct sock *, int, void __user *, int *);
+
+static int
+compat_do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
+{
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case IP6T_SO_GET_INFO:
+		ret = get_info(user, len, 1);
+		break;
+	case IP6T_SO_GET_ENTRIES:
+		ret = compat_get_entries(user, len);
+		break;
+	default:
+		ret = do_ip6t_get_ctl(sk, cmd, user, len);
 	}
-	break;
+	return ret;
+}
+#endif
 
-	case IP6T_SO_GET_ENTRIES: {
-		struct ip6t_get_entries get;
+static int
+do_ip6t_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
+{
+	int ret;
 
-		if (*len < sizeof(get)) {
-			duprintf("get_entries: %u < %u\n", *len, sizeof(get));
-			ret = -EINVAL;
-		} else if (copy_from_user(&get, user, sizeof(get)) != 0) {
-			ret = -EFAULT;
-		} else if (*len != sizeof(struct ip6t_get_entries) + get.size) {
-			duprintf("get_entries: %u != %u\n", *len,
-				 sizeof(struct ip6t_get_entries) + get.size);
-			ret = -EINVAL;
-		} else
-			ret = get_entries(&get, user);
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case IP6T_SO_SET_REPLACE:
+		ret = do_replace(user, len);
 		break;
+
+	case IP6T_SO_SET_ADD_COUNTERS:
+		ret = do_add_counters(user, len, 0);
+		break;
+
+	default:
+		duprintf("do_ip6t_set_ctl:  unknown request %i\n", cmd);
+		ret = -EINVAL;
 	}
 
+	return ret;
+}
+
+static int
+do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
+{
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	switch (cmd) {
+	case IP6T_SO_GET_INFO:
+		ret = get_info(user, len, 0);
+		break;
+
+	case IP6T_SO_GET_ENTRIES:
+		ret = get_entries(user, len);
+		break;
+
 	case IP6T_SO_GET_REVISION_MATCH:
 	case IP6T_SO_GET_REVISION_TARGET: {
 		struct ip6t_get_revision rev;
@@ -1331,8 +2119,7 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	return ret;
 }
 
-int ip6t_register_table(struct xt_table *table,
-			const struct ip6t_replace *repl)
+int ip6t_register_table(struct xt_table *table, const struct ip6t_replace *repl)
 {
 	int ret;
 	struct xt_table_info *newinfo;
@@ -1344,7 +2131,7 @@ int ip6t_register_table(struct xt_table *table,
 	if (!newinfo)
 		return -ENOMEM;
 
-	/* choose the copy on our node/cpu */
+	/* choose the copy on our node/cpu, but dont care about preemption */
 	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
 	memcpy(loc_cpu_entry, repl->entries, repl->size);
 
@@ -1400,17 +2187,18 @@ icmp6_match(const struct sk_buff *skb,
 	   unsigned int protoff,
 	   bool *hotdrop)
 {
-	struct icmp6hdr _icmp, *ic;
+	struct icmp6hdr _icmph, *ic;
 	const struct ip6t_icmp *icmpinfo = matchinfo;
 
 	/* Must not be a fragment. */
 	if (offset)
 		return false;
 
-	ic = skb_header_pointer(skb, protoff, sizeof(_icmp), &_icmp);
+	ic = skb_header_pointer(skb, protoff, sizeof(_icmph), &_icmph);
 	if (ic == NULL) {
 		/* We've been asked to examine this packet, and we
-		   can't.  Hence, no choice but to drop. */
+		 * can't.  Hence, no choice but to drop.
+		 */
 		duprintf("Dropping evil ICMP tinygram.\n");
 		*hotdrop = true;
 		return false;
@@ -1442,6 +2230,11 @@ static struct xt_target ip6t_standard_target __read_mostly = {
 	.name		= IP6T_STANDARD_TARGET,
 	.targetsize	= sizeof(int),
 	.family		= AF_INET6,
+#ifdef CONFIG_COMPAT
+	.compatsize	= sizeof(compat_int_t),
+	.compat_from_user = compat_standard_from_user,
+	.compat_to_user	= compat_standard_to_user,
+#endif
 };
 
 static struct xt_target ip6t_error_target __read_mostly = {
@@ -1456,15 +2249,21 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.set_optmin	= IP6T_BASE_CTL,
 	.set_optmax	= IP6T_SO_SET_MAX+1,
 	.set		= do_ip6t_set_ctl,
+#ifdef CONFIG_COMPAT
+	.compat_set	= compat_do_ip6t_set_ctl,
+#endif
 	.get_optmin	= IP6T_BASE_CTL,
 	.get_optmax	= IP6T_SO_GET_MAX+1,
 	.get		= do_ip6t_get_ctl,
+#ifdef CONFIG_COMPAT
+	.compat_get	= compat_do_ip6t_get_ctl,
+#endif
 	.owner		= THIS_MODULE,
 };
 
 static struct xt_match icmp6_matchstruct __read_mostly = {
 	.name		= "icmp6",
-	.match		= &icmp6_match,
+	.match		= icmp6_match,
 	.matchsize	= sizeof(struct ip6t_icmp),
 	.checkentry	= icmp6_checkentry,
 	.proto		= IPPROTO_ICMPV6,
@@ -1513,6 +2312,7 @@ err1:
 static void __exit ip6_tables_fini(void)
 {
 	nf_unregister_sockopt(&ip6t_sockopts);
+
 	xt_unregister_match(&icmp6_matchstruct);
 	xt_unregister_target(&ip6t_error_target);
 	xt_unregister_target(&ip6t_standard_target);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 07bb465..b95284e 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -342,8 +342,8 @@ int xt_compat_match_offset(struct xt_match *match)
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_offset);
 
-void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
-			       int *size)
+int xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
+			      int *size)
 {
 	struct xt_match *match = m->u.kernel.match;
 	struct compat_xt_entry_match *cm = (struct compat_xt_entry_match *)m;
@@ -365,6 +365,7 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 
 	*size += off;
 	*dstptr += msize;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_compat_match_from_user);
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 0250bbe..d96ee3e 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -160,6 +160,11 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.destroy	= connmark_tg_destroy,
 		.target		= connmark_tg,
 		.targetsize	= sizeof(struct xt_connmark_target_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_target_info),
+		.compat_from_user = connmark_tg_compat_from_user,
+		.compat_to_user	= connmark_tg_compat_to_user,
+#endif
 		.me		= THIS_MODULE
 	},
 };
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index de32aa5..5bf9121 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -158,6 +158,21 @@ static struct xt_target mark_tg_reg[] __read_mostly = {
 		.table		= "mangle",
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "MARK",
+		.family		= AF_INET6,
+		.revision	= 1,
+		.checkentry	= mark_tg_check,
+		.target		= mark_tg,
+		.targetsize	= sizeof(struct xt_mark_target_info_v1),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_target_info_v1),
+		.compat_from_user = mark_tg_compat_from_user,
+		.compat_to_user	= mark_tg_compat_to_user,
+#endif
+		.table		= "mangle",
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init mark_tg_init(void)
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 7e0874a..b5c0f2f 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -126,6 +126,11 @@ static struct xt_match connmark_mt_reg[] __read_mostly = {
 		.match		= connmark_mt,
 		.destroy	= connmark_mt_destroy,
 		.matchsize	= sizeof(struct xt_connmark_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_info),
+		.compat_from_user = connmark_mt_compat_from_user,
+		.compat_to_user	= connmark_mt_compat_to_user,
+#endif
 		.me		= THIS_MODULE
 	},
 };
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index c9352db..2ef0dbf 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -187,6 +187,11 @@ static struct xt_match limit_mt_reg[] __read_mostly = {
 		.checkentry	= limit_mt_check,
 		.match		= limit_mt,
 		.matchsize	= sizeof(struct xt_rateinfo),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_rateinfo),
+		.compat_from_user = limit_mt_compat_from_user,
+		.compat_to_user	= limit_mt_compat_to_user,
+#endif
 		.me		= THIS_MODULE,
 	},
 };
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 650cdea..ce8735e 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -94,6 +94,11 @@ static struct xt_match mark_mt_reg[] __read_mostly = {
 		.checkentry	= mark_mt_check,
 		.match		= mark_mt,
 		.matchsize	= sizeof(struct xt_mark_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_mark_info),
+		.compat_from_user = mark_mt_compat_from_user,
+		.compat_to_user	= mark_mt_compat_to_user,
+#endif
 		.me		= THIS_MODULE,
 	},
 };

--------------040408020301010801070900--
