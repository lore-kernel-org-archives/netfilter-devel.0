From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 04/43] introduces xtables match/target
Date: Sun, 15 Jul 2007 02:22:16 +0900 (JST)
Message-ID: <200707141722.l6EHMHCW025373@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


- moves lib_dir to xtables.c
- introduces struct pfinfo which has protocol family dependent infomations.
- unifies load_ip[6]tables_ko() and moves them as load_xtables_ko()
- introduces xt_{match,match_rule,target,tryload} and replaces
  ip[6]t_* with them
- unifies following functions and move them to xtables.c
        - find_{match,find_target}
        - compatible_revision, compatible_{match,target}_revision
- introduces xtables_register_{match,target} and make
  register_{match,target}[6] call them. xtables_register_* register ONLY
  matches/targets matched protocol family

Some concepts:
- source compatibility for libip[6]t_xxx.c with warning on compilation
  not binary compatibility.
- binary compatibility between 2.4/2.6 kernel and iptables/ip6tables,
  of cause.

- xtables is enough to support only one address family at runtime.
  Then xtables keeps infomations of only the focused address famiy
  in struct afinfo.

---
 include/ip6tables.h                |  142 +--------------
 include/iptables.h                 |  143 +---------------
 include/iptables_common.h          |    2 -
 include/libiptc/libxtc.h           |   35 ++++
 include/linux/netfilter/x_tables.h |  123 +++++++++++++
 include/xtables.h                  |  173 ++++++++++++++++++
 ip6tables-restore.c                |    2 +-
 ip6tables.c                        |  308 +++------------------------------
 iptables-restore.c                 |    2 +-
 iptables.c                         |  331 +++--------------------------------
 xtables.c                          |  342 ++++++++++++++++++++++++++++++++++++
 11 files changed, 728 insertions(+), 875 deletions(-)
 create mode 100644 include/libiptc/libxtc.h
 create mode 100644 include/linux/netfilter/x_tables.h

diff --git a/include/ip6tables.h b/include/ip6tables.h
index b6757a3..b9e364e 100644
--- a/include/ip6tables.h
+++ b/include/ip6tables.h
@@ -1,6 +1,8 @@
 #ifndef _IP6TABLES_USER_H
 #define _IP6TABLES_USER_H
 
+#include <xtables.h>
+
 #include "iptables_common.h"
 #include "libiptc/libip6tc.h"
 
@@ -21,129 +23,12 @@
 #ifndef IP6T_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IP6T_SO_GET_REVISION_MATCH	68
 #define IP6T_SO_GET_REVISION_TARGET	69
-
-struct ip6t_get_revision
-{
-	char name[IP6T_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-};
 #endif /* IP6T_SO_GET_REVISION_MATCH   Old kernel source */
 
-struct ip6tables_rule_match
-{
-	struct ip6tables_rule_match *next;
-
-	struct ip6tables_match *match;
-
-	/* Multiple matches of the same type: the ones before
-	   the current one are completed from parsing point of view */	
-	unsigned int completed;
-};
-
-/* Include file for additions: new matches and targets. */
-struct ip6tables_match
-{
-	struct ip6tables_match *next;
-
-	ip6t_chainlabel name;
-
-	/* Revision of match (0 by default). */
-	u_int8_t revision;
-
-	const char *version;
-
-	/* Size of match data. */
-	size_t size;
-
-	/* Size of match data relevent for userspace comparison purposes */
-	size_t userspacesize;
-
-	/* Function which prints out usage message. */
-	void (*help)(void);
-
-	/* Initialize the match. */
-	void (*init)(struct ip6t_entry_match *m, unsigned int *nfcache);
-
-	/* Function which parses command options; returns true if it
-	   ate an option */
-	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
-		     const struct ip6t_entry *entry,
-		     unsigned int *nfcache,
-		     struct ip6t_entry_match **match);
-
-	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
-
-	/* Prints out the match iff non-NULL: put space at end */
-	void (*print)(const struct ip6t_ip6 *ip,
-		      const struct ip6t_entry_match *match, int numeric);
-
-	/* Saves the union ipt_matchinfo in parsable form to stdout. */
-	void (*save)(const struct ip6t_ip6 *ip,
-		     const struct ip6t_entry_match *match);
-
-	/* Pointer to list of extra command-line options */
-	const struct option *extra_opts;
-
-	/* Ignore these men behind the curtain: */
-	unsigned int option_offset;
-	struct ip6t_entry_match *m;
-	unsigned int mflags;
-#ifdef NO_SHARED_LIBS
-	unsigned int loaded; /* simulate loading so options are merged properly */
-#endif
-};
-
-struct ip6tables_target
-{
-	struct ip6tables_target *next;
-	
-	ip6t_chainlabel name;
-
-	const char *version;
-
-	/* Size of target data. */
-	size_t size;
-
-	/* Size of target data relevent for userspace comparison purposes */
-	size_t userspacesize;
-
-	/* Function which prints out usage message. */
-	void (*help)(void);
-
-	/* Initialize the target. */
-	void (*init)(struct ip6t_entry_target *t, unsigned int *nfcache);
-
-	/* Function which parses command options; returns true if it
-	   ate an option */
-	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
-		     const struct ip6t_entry *entry,
-		     struct ip6t_entry_target **target);
-	
-	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
-
-	/* Prints out the target iff non-NULL: put space at end */
-	void (*print)(const struct ip6t_ip6 *ip,
-		      const struct ip6t_entry_target *target, int numeric);
-
-	/* Saves the targinfo in parsable form to stdout. */
-	void (*save)(const struct ip6t_ip6 *ip,
-		     const struct ip6t_entry_target *target);
-
-	/* Pointer to list of extra command-line options */
-	struct option *extra_opts;
-
-	/* Ignore these men behind the curtain: */
-	unsigned int option_offset;
-	struct ip6t_entry_target *t;
-	unsigned int tflags;
-	unsigned int used;
-#ifdef NO_SHARED_LIBS
-	unsigned int loaded; /* simulate loading so options are merged properly */
-#endif
-};
+#define ip6tables_rule_match	xtables_rule_match
+#define ip6tables_match		xtables_match
+#define ip6tables_target	xtables_target
+#define ip6t_tryload		xt_tryload
 
 extern int line;
 
@@ -155,25 +40,10 @@ extern int service_to_port(const char *name, const char *proto);
 extern u_int16_t parse_port(const char *port, const char *proto);
 extern int do_command6(int argc, char *argv[], char **table,
 		       ip6tc_handle_t *handle);
-/* Keeping track of external matches and targets: linked lists. */
-extern struct ip6tables_match *ip6tables_matches;
-extern struct ip6tables_target *ip6tables_targets;
-
-enum ip6t_tryload {
-	DONT_LOAD,
-	DURING_LOAD,
-	TRY_LOAD,
-	LOAD_MUST_SUCCEED
-};
-
-extern struct ip6tables_target *find_target(const char *name, enum ip6t_tryload);
-extern struct ip6tables_match *find_match(const char *name, enum ip6t_tryload, struct ip6tables_rule_match **match);
-
 extern void parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
-extern int load_ip6tables_ko(const char *modprobe, int quiet);
 
 #endif /*_IP6TABLES_USER_H*/
diff --git a/include/iptables.h b/include/iptables.h
index cd51428..9df1a29 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -1,6 +1,7 @@
 #ifndef _IPTABLES_USER_H
 #define _IPTABLES_USER_H
 
+#include "xtables.h"
 #include "iptables_common.h"
 #include "libiptc/libiptc.h"
 
@@ -21,132 +22,12 @@
 #ifndef IPT_SO_GET_REVISION_MATCH /* Old kernel source. */
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
-
-struct ipt_get_revision
-{
-	char name[IPT_FUNCTION_MAXNAMELEN-1];
-
-	u_int8_t revision;
-};
 #endif /* IPT_SO_GET_REVISION_MATCH   Old kernel source */
 
-struct iptables_rule_match
-{
-	struct iptables_rule_match *next;
-
-	struct iptables_match *match;
-
-	/* Multiple matches of the same type: the ones before
-	   the current one are completed from parsing point of view */	
-	unsigned int completed;
-};
-
-/* Include file for additions: new matches and targets. */
-struct iptables_match
-{
-	struct iptables_match *next;
-
-	ipt_chainlabel name;
-
-	/* Revision of match (0 by default). */
-	u_int8_t revision;
-
-	const char *version;
-
-	/* Size of match data. */
-	size_t size;
-
-	/* Size of match data relevent for userspace comparison purposes */
-	size_t userspacesize;
-
-	/* Function which prints out usage message. */
-	void (*help)(void);
-
-	/* Initialize the match. */
-	void (*init)(struct ipt_entry_match *m, unsigned int *nfcache);
-
-	/* Function which parses command options; returns true if it
-           ate an option */
-	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
-		     const struct ipt_entry *entry,
-		     unsigned int *nfcache,
-		     struct ipt_entry_match **match);
-
-	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
-
-	/* Prints out the match iff non-NULL: put space at end */
-	void (*print)(const struct ipt_ip *ip,
-		      const struct ipt_entry_match *match, int numeric);
-
-	/* Saves the match info in parsable form to stdout. */
-	void (*save)(const struct ipt_ip *ip,
-		     const struct ipt_entry_match *match);
-
-	/* Pointer to list of extra command-line options */
-	const struct option *extra_opts;
-
-	/* Ignore these men behind the curtain: */
-	unsigned int option_offset;
-	struct ipt_entry_match *m;
-	unsigned int mflags;
-#ifdef NO_SHARED_LIBS
-	unsigned int loaded; /* simulate loading so options are merged properly */
-#endif
-};
-
-struct iptables_target
-{
-	struct iptables_target *next;
-
-	ipt_chainlabel name;
-
-	/* Revision of target (0 by default). */
-	u_int8_t revision;
-
-	const char *version;
-
-	/* Size of target data. */
-	size_t size;
-
-	/* Size of target data relevent for userspace comparison purposes */
-	size_t userspacesize;
-
-	/* Function which prints out usage message. */
-	void (*help)(void);
-
-	/* Initialize the target. */
-	void (*init)(struct ipt_entry_target *t, unsigned int *nfcache);
-
-	/* Function which parses command options; returns true if it
-           ate an option */
-	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
-		     const struct ipt_entry *entry,
-		     struct ipt_entry_target **target);
-
-	/* Final check; exit if not ok. */
-	void (*final_check)(unsigned int flags);
-
-	/* Prints out the target iff non-NULL: put space at end */
-	void (*print)(const struct ipt_ip *ip,
-		      const struct ipt_entry_target *target, int numeric);
-
-	/* Saves the targinfo in parsable form to stdout. */
-	void (*save)(const struct ipt_ip *ip,
-		     const struct ipt_entry_target *target);
-
-	/* Pointer to list of extra command-line options */
-	struct option *extra_opts;
-
-	/* Ignore these men behind the curtain: */
-	unsigned int option_offset;
-	struct ipt_entry_target *t;
-	unsigned int tflags;
-	unsigned int used;
-#ifdef NO_SHARED_LIBS
-	unsigned int loaded; /* simulate loading so options are merged properly */
-#endif
-};
+#define iptables_rule_match	xtables_rule_match
+#define iptables_match		xtables_match
+#define iptables_target		xtables_target
+#define ipt_tryload		xt_tryload
 
 extern int line;
 
@@ -169,20 +50,6 @@ extern void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 
 extern int do_command(int argc, char *argv[], char **table,
 		      iptc_handle_t *handle);
-/* Keeping track of external matches and targets: linked lists.  */
-extern struct iptables_match *iptables_matches;
-extern struct iptables_target *iptables_targets;
-
-enum ipt_tryload {
-	DONT_LOAD,
-	DURING_LOAD,
-	TRY_LOAD,
-	LOAD_MUST_SUCCEED
-};
-
-extern struct iptables_target *find_target(const char *name, enum ipt_tryload);
-extern struct iptables_match *find_match(const char *name, enum ipt_tryload, struct iptables_rule_match **match);
-
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
 			iptc_handle_t *handle);
 extern int flush_entries(const ipt_chainlabel chain, int verbose, 
diff --git a/include/iptables_common.h b/include/iptables_common.h
index 3b61e72..3e19080 100644
--- a/include/iptables_common.h
+++ b/include/iptables_common.h
@@ -27,11 +27,9 @@ extern int string_to_number_ll(const char *,
 			    unsigned long long int, 
 			    unsigned long long int,
 			    unsigned long long *);
-extern int load_iptables_ko(const char *modprobe, int quiet);
 void exit_error(enum exittype, char *, ...)__attribute__((noreturn,
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
-extern char *lib_dir;
 
 #define _init __attribute__((constructor)) my_init
 #ifdef NO_SHARED_LIBS
diff --git a/include/libiptc/libxtc.h b/include/libiptc/libxtc.h
new file mode 100644
index 0000000..031afb5
--- /dev/null
+++ b/include/libiptc/libxtc.h
@@ -0,0 +1,35 @@
+#ifndef _LIBXTC_H
+#define _LIBXTC_H
+/* Library which manipulates filtering rules. */
+
+#include <libiptc/ipt_kernel_headers.h>
+#include <linux/netfilter/x_tables.h>
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+#ifndef XT_MIN_ALIGN
+/* xt_entry has pointers and u_int64_t's in it, so if you align to
+   it, you'll also align to any crazy matches and targets someone
+   might write */
+#define XT_MIN_ALIGN (__alignof__(struct xt_entry))
+#endif
+
+#ifndef XT_ALIGN
+#define XT_ALIGN(s) (((s) + ((XT_MIN_ALIGN)-1)) & ~((XT_MIN_ALIGN)-1))
+#endif
+
+typedef char xt_chainlabel[32];
+
+#define XTC_LABEL_ACCEPT  "ACCEPT"
+#define XTC_LABEL_DROP    "DROP"
+#define XTC_LABEL_QUEUE   "QUEUE"
+#define XTC_LABEL_RETURN  "RETURN"
+
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif /* _LIBXTC_H */
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
new file mode 100644
index 0000000..69ec8ae
--- /dev/null
+++ b/include/linux/netfilter/x_tables.h
@@ -0,0 +1,123 @@
+#ifndef _X_TABLES_H
+#define _X_TABLES_H
+
+#include <sys/types.h>
+
+#define XT_FUNCTION_MAXNAMELEN 30
+#define XT_TABLE_MAXNAMELEN 32
+
+struct xt_entry_match
+{
+	union {
+		struct {
+			u_int16_t match_size;
+
+			/* Used by userspace */
+			char name[XT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t revision;
+		} user;
+		struct {
+			u_int16_t match_size;
+
+			/* Used inside the kernel */
+			struct xt_match *match;
+		} kernel;
+
+		/* Total length */
+		u_int16_t match_size;
+	} u;
+
+	unsigned char data[0];
+};
+
+struct xt_entry_target
+{
+	union {
+		struct {
+			u_int16_t target_size;
+
+			/* Used by userspace */
+			char name[XT_FUNCTION_MAXNAMELEN-1];
+
+			u_int8_t revision;
+		} user;
+		struct {
+			u_int16_t target_size;
+
+			/* Used inside the kernel */
+			struct xt_target *target;
+		} kernel;
+
+		/* Total length */
+		u_int16_t target_size;
+	} u;
+
+	unsigned char data[0];
+};
+
+struct xt_standard_target
+{
+	struct xt_entry_target target;
+	int verdict;
+};
+
+/* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
+ * kernel supports, if >= revision. */
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
+/* this is a dummy structure to find out the alignment requirement for a struct
+ * containing all the fundamental data types that are used in ipt_entry,
+ * ip6t_entry and arpt_entry.  This sucks, and it is a hack.  It will be my
+ * personal pleasure to remove it -HW
+ */
+struct _xt_align
+{
+	u_int8_t u8;
+	u_int16_t u16;
+	u_int32_t u32;
+	u_int64_t u64;
+};
+
+#define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) 	\
+			& ~(__alignof__(struct _xt_align)-1))
+
+/* Standard return verdict, or do jump. */
+#define XT_STANDARD_TARGET ""
+/* Error verdict. */
+#define XT_ERROR_TARGET "ERROR"
+
+#define SET_COUNTER(c,b,p) do { (c).bcnt = (b); (c).pcnt = (p); } while(0)
+#define ADD_COUNTER(c,b,p) do { (c).bcnt += (b); (c).pcnt += (p); } while(0)
+
+struct xt_counters
+{
+	u_int64_t pcnt, bcnt;			/* Packet and byte counters */
+};
+
+/* The argument to IPT_SO_ADD_COUNTERS. */
+struct xt_counters_info
+{
+	/* Which table. */
+	char name[XT_TABLE_MAXNAMELEN];
+
+	unsigned int num_counters;
+
+	/* The counters (actually `number' of these). */
+	struct xt_counters counters[0];
+};
+
+#define XT_INV_PROTO		0x40	/* Invert the sense of PROTO. */
+
+#endif /* _X_TABLES_H */
diff --git a/include/xtables.h b/include/xtables.h
index 97395f3..89b92c3 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -1,10 +1,183 @@
 #ifndef _XTABLES_H
 #define _XTABLES_H
 
+#include <sys/types.h>
+#include <linux/netfilter/x_tables.h>
+#include <libiptc/libxtc.h>
+
+/* protocol family dependent informations */
+struct afinfo {
+	/* protocol family */
+	int family;
+
+	/* prefix of library name (ex "libipt_" */
+	char *libprefix;
+
+	/* used by setsockopt (ex IPPROTO_IP */
+	int ipproto;
+
+	/* kernel module (ex "ip_tables" */
+	char *kmod;
+
+	/* optname to check revision support of match */
+	int so_rev_match;
+
+	/* optname to check revision support of match */
+	int so_rev_target;
+};
+
+enum xt_tryload {
+	DONT_LOAD,
+	DURING_LOAD,
+	TRY_LOAD,
+	LOAD_MUST_SUCCEED
+};
+
+struct xtables_rule_match
+{
+	struct xtables_rule_match *next;
+	struct xtables_match *match;
+	/* Multiple matches of the same type: the ones before
+	   the current one are completed from parsing point of view */
+	unsigned int completed;
+};
+
+/* Include file for additions: new matches and targets. */
+struct xtables_match
+{
+	struct xtables_match *next;
+
+	xt_chainlabel name;
+
+	/* Revision of match (0 by default). */
+	u_int8_t revision;
+
+	u_int16_t family;
+
+	const char *version;
+
+	/* Size of match data. */
+	size_t size;
+
+	/* Size of match data relevent for userspace comparison purposes */
+	size_t userspacesize;
+
+	/* Function which prints out usage message. */
+	void (*help)(void);
+
+	/* Initialize the match. */
+	void (*init)(struct xt_entry_match *m, unsigned int *nfcache);
+
+	/* Function which parses command options; returns true if it
+           ate an option */
+	/* entry is struct ipt_entry for example */
+	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
+		     const void *entry,
+		     unsigned int *nfcache,
+		     struct xt_entry_match **match);
+
+	/* Final check; exit if not ok. */
+	void (*final_check)(unsigned int flags);
+
+	/* Prints out the match iff non-NULL: put space at end */
+	/* ip is struct ipt_ip * for example */
+	void (*print)(const void *ip,
+		      const struct xt_entry_match *match, int numeric);
+
+	/* Saves the match info in parsable form to stdout. */
+	/* ip is struct ipt_ip * for example */
+	void (*save)(const void *ip, const struct xt_entry_match *match);
+
+	/* Pointer to list of extra command-line options */
+	const struct option *extra_opts;
+
+	/* Ignore these men behind the curtain: */
+	unsigned int option_offset;
+	struct xt_entry_match *m;
+	unsigned int mflags;
+#ifdef NO_SHARED_LIBS
+	unsigned int loaded; /* simulate loading so options are merged properly */
+#endif
+};
+
+struct xtables_target
+{
+	struct xtables_target *next;
+
+	xt_chainlabel name;
+
+	/* Revision of target (0 by default). */
+	u_int8_t revision;
+
+	u_int16_t family;
+
+	const char *version;
+
+	/* Size of target data. */
+	size_t size;
+
+	/* Size of target data relevent for userspace comparison purposes */
+	size_t userspacesize;
+
+	/* Function which prints out usage message. */
+	void (*help)(void);
+
+	/* Initialize the target. */
+	void (*init)(struct xt_entry_target *t, unsigned int *nfcache);
+
+	/* Function which parses command options; returns true if it
+           ate an option */
+	/* entry is struct ipt_entry for example */
+	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
+		     const void *entry,
+		     struct xt_entry_target **targetinfo);
+
+	/* Final check; exit if not ok. */
+	void (*final_check)(unsigned int flags);
+
+	/* Prints out the target iff non-NULL: put space at end */
+	void (*print)(const void *ip,
+		      const struct xt_entry_target *target, int numeric);
+
+	/* Saves the targinfo in parsable form to stdout. */
+	void (*save)(const void *ip,
+		     const struct xt_entry_target *target);
+
+	/* Pointer to list of extra command-line options */
+	struct option *extra_opts;
+
+	/* Ignore these men behind the curtain: */
+	unsigned int option_offset;
+	struct xt_entry_target *t;
+	unsigned int tflags;
+	unsigned int used;
+#ifdef NO_SHARED_LIBS
+	unsigned int loaded; /* simulate loading so options are merged properly */
+#endif
+};
+
+extern char *lib_dir;
+
 extern void *fw_calloc(size_t count, size_t size);
 extern void *fw_malloc(size_t size);
 
 extern const char *modprobe;
 extern int xtables_insmod(const char *modname, const char *modprobe, int quiet);
+extern int load_xtables_ko(const char *modprobe, int quiet);
+
+/* This is decleared in ip[6]tables.c */
+extern struct afinfo afinfo;
+
+/* Keeping track of external matches and targets: linked lists.  */
+extern struct xtables_match *xtables_matches;
+extern struct xtables_target *xtables_targets;
+
+/* Your shared library should call one of these. */
+extern void xtables_register_match(struct xtables_match *me);
+extern void xtables_register_target(struct xtables_target *me);
+
+extern struct xtables_match *find_match(const char *name, enum xt_tryload,
+					struct xtables_rule_match **match);
+extern struct xtables_target *find_target(const char *name, enum xt_tryload);
 
 #endif /* _XTABLES_H */
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 52e46ff..c281341 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -63,7 +63,7 @@ ip6tc_handle_t create_handle(const char *tablename, const char* modprobe)
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		xtables_insmod("ip6_tables", modprobe, 0);
+		load_xtables_ko(modprobe, 0);
 		handle = ip6tc_init(tablename);
 	}
 
diff --git a/ip6tables.c b/ip6tables.c
index 2a06bc0..d3b80cf 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -185,11 +185,6 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 
 const char *program_version;
 const char *program_name;
-char *lib_dir;
-
-/* Keeping track of external matches and targets: linked lists.  */
-struct ip6tables_match *ip6tables_matches = NULL;
-struct ip6tables_target *ip6tables_targets = NULL;
 
 /* Extra debugging from libiptc */
 extern void dump_entries6(const ip6tc_handle_t handle);
@@ -201,6 +196,15 @@ struct pprot {
 	u_int8_t num;
 };
 
+struct afinfo afinfo = {
+	.family		= AF_INET6,
+	.libprefix	= "libip6t_",
+	.ipproto	= IPPROTO_IPV6,
+	.kmod		= "ip6_tables",
+	.so_rev_match	= IP6T_SO_GET_REVISION_MATCH,
+	.so_rev_target	= IP6T_SO_GET_REVISION_TARGET,
+};
+
 /* Primitive headers... */
 /* defined in netinet/in.h */
 #if 0
@@ -387,7 +391,7 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 	/* Print out any special helps. A user might like to be able to add a --help 
 	   to the commandline, and see expected results. So we call help for all 
 	   specified matches & targets */
-	for (t = ip6tables_targets; t; t = t->next) {
+	for (t = xtables_targets; t; t = t->next) {
 		if (t->used) {
 			printf("\n");
 			t->help();
@@ -710,93 +714,6 @@ parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
 	}
 }
 
-struct ip6tables_match *
-find_match(const char *match_name, enum ip6t_tryload tryload, struct ip6tables_rule_match **matches)
-{
-	struct ip6tables_match *ptr;
- 	const char *icmp6 = "icmp6";
- 	const char *name;
-  
-	/* This is ugly as hell. Nonetheless, there is no way of changing
-	 * this without hurting backwards compatibility */
- 	if ( (strcmp(match_name,"icmpv6") == 0) ||
- 	     (strcmp(match_name,"ipv6-icmp") == 0) ||
- 	     (strcmp(match_name,"icmp6") == 0) )
- 	     	name = icmp6;
- 	else
- 		name = match_name;
- 
-	for (ptr = ip6tables_matches; ptr; ptr = ptr->next) {
- 		if (strcmp(name, ptr->name) == 0) {
-			struct ip6tables_match *clone;
-			
-			/* First match of this type: */
-			if (ptr->m == NULL)
-				break;
-
-			/* Second and subsequent clones */
-			clone = fw_malloc(sizeof(struct ip6tables_match));
-			memcpy(clone, ptr, sizeof(struct ip6tables_match));
-			clone->mflags = 0;
-			/* This is a clone: */
-			clone->next = clone;
-
-			ptr = clone;
-			break;
-		}
-	}
-
-#ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		char path[strlen(lib_dir) + sizeof("/libip6t_.so")
-			 + strlen(name)];
-		sprintf(path, "%s/libip6t_%s.so", lib_dir, name);
-		if (dlopen(path, RTLD_NOW)) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified target as match. */
-			ptr = find_match(name, DONT_LOAD, NULL);
-
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load match `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
-			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load match `%s':%s\n",
-				   name, dlerror());
-	}
-#else
-	if (ptr && !ptr->loaded) {
-		if (tryload != DONT_LOAD)
-			ptr->loaded = 1;
-		else
-			ptr = NULL;
-	}
-	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
-		exit_error(PARAMETER_PROBLEM,
-			   "Couldn't find match `%s'\n", name);
-	}
-#endif
-
-	if (ptr && matches) {
-		struct ip6tables_rule_match **i;
-		struct ip6tables_rule_match *newentry;
-
-		newentry = fw_malloc(sizeof(struct ip6tables_rule_match));
-
-		for (i = matches; *i; i = &(*i)->next) {
-			if (strcmp(name, (*i)->match->name) == 0)
-				(*i)->completed = 1;
-		}
-		newentry->match = ptr;
-		newentry->completed = 0;
-		newentry->next = NULL;
-		*i = newentry;
-	}
-
-	return ptr;
-}
-
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct ip6tables_match *
 find_proto(const char *pname, enum ip6t_tryload tryload, int nolookup, struct ip6tables_rule_match **matches)
@@ -997,61 +914,6 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	}
 }
 
-struct ip6tables_target *
-find_target(const char *name, enum ip6t_tryload tryload)
-{
-	struct ip6tables_target *ptr;
-
-	/* Standard target? */
-	if (strcmp(name, "") == 0
-	    || strcmp(name, IP6TC_LABEL_ACCEPT) == 0
-	    || strcmp(name, IP6TC_LABEL_DROP) == 0
-	    || strcmp(name, IP6TC_LABEL_QUEUE) == 0
-	    || strcmp(name, IP6TC_LABEL_RETURN) == 0)
-		name = "standard";
-
-	for (ptr = ip6tables_targets; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0)
-			break;
-	}
-
-#ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		char path[strlen(lib_dir) + sizeof("/libip6t_.so")
-			 + strlen(name)];
-		sprintf(path, "%s/libip6t_%s.so", lib_dir, name);
-		if (dlopen(path, RTLD_NOW)) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified match as a target. */
-			ptr = find_target(name, DONT_LOAD);
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load target `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
-			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load target `%s':%s\n",
-				   name, dlerror());
-	}
-#else
-	if (ptr && !ptr->loaded) {
-		if (tryload != DONT_LOAD)
-			ptr->loaded = 1;
-		else
-			ptr = NULL;
-	}
-	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
-		exit_error(PARAMETER_PROBLEM,
-			   "Couldn't find target `%s'\n", name);
-	}
-#endif
-
-	if (ptr)
-		ptr->used = 1;
-
-	return ptr;
-}
-
 static struct option *
 merge_options(struct option *oldopts, const struct option *newopts,
 	      unsigned int *option_offset)
@@ -1077,131 +939,16 @@ merge_options(struct option *oldopts, const struct option *newopts,
 	return merge;
 }
 
-static int compatible_revision(const char *name, u_int8_t revision, int opt)
+void register_match6(struct ip6tables_match *me)
 {
-	struct ip6t_get_revision rev;
-	socklen_t s = sizeof(rev);
-	int max_rev, sockfd;
-
-	sockfd = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
-	if (sockfd < 0) {
-		fprintf(stderr, "Could not open socket to kernel: %s\n",
-			strerror(errno));
-		exit(1);
-	}
-
-	strcpy(rev.name, name);
-	rev.revision = revision;
-
-	load_ip6tables_ko(modprobe, 1);
-
-	max_rev = getsockopt(sockfd, IPPROTO_IPV6, opt, &rev, &s);
-	if (max_rev < 0) {
-		/* Definitely don't support this? */
-		if (errno == ENOENT || errno == EPROTONOSUPPORT) {
-			close(sockfd);
-			return 0;
-		} else if (errno == ENOPROTOOPT) {
-			close(sockfd);
-			/* Assume only revision 0 support (old kernel) */
-			return (revision == 0);
-		} else {
-			fprintf(stderr, "getsockopt failed strangely: %s\n",
-				strerror(errno));
-			exit(1);
-		}
-	}
-	close(sockfd);
-	return 1;
+	me->family = AF_INET6;
+	xtables_register_match(me);
 }
 
-static int compatible_match_revision(const char *name, u_int8_t revision)
+void register_target6(struct ip6tables_target *me)
 {
-	return compatible_revision(name, revision, IP6T_SO_GET_REVISION_MATCH);
-}
-
-void
-register_match6(struct ip6tables_match *me)
-{
-	struct ip6tables_match **i, *old;
-
-	if (strcmp(me->version, program_version) != 0) {
-		fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
-			program_name, me->name, me->version, program_version);
-		exit(1);
-	}
-
-	/* Revision field stole a char from name. */
-	if (strlen(me->name) >= IP6T_FUNCTION_MAXNAMELEN-1) {
-		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			program_name, me->name);
-		exit(1);
-	}
-
-	old = find_match(me->name, DURING_LOAD, NULL);
-	if (old) {
-		if (old->revision == me->revision) {
-			fprintf(stderr,
-				"%s: match `%s' already registered.\n",
-				program_name, me->name);
-			exit(1);
-		}
-
-		/* Now we have two (or more) options, check compatibility. */
-		if (compatible_match_revision(old->name, old->revision)
-		    && old->revision > me->revision)
-			return;
-
-		/* Replace if compatible. */
-		if (!compatible_match_revision(me->name, me->revision))
-			return;
-
-		/* Delete old one. */
-		for (i = &ip6tables_matches; *i!=old; i = &(*i)->next);
-		*i = old->next;
-	}
-	
-	if (me->size != IP6T_ALIGN(me->size)) {
-		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
-			program_name, me->name, (unsigned int)me->size);
-		exit(1);
-	}
-
-	/* Append to list. */
-	for (i = &ip6tables_matches; *i; i = &(*i)->next);
-	me->next = NULL;
-	*i = me;
-
-	me->m = NULL;
-	me->mflags = 0;
-}
-
-void
-register_target6(struct ip6tables_target *me)
-{
-	if (strcmp(me->version, program_version) != 0) {
-		fprintf(stderr, "%s: target `%s' v%s (I'm v%s).\n",
-			program_name, me->name, me->version, program_version);
-		exit(1);
-	}
-
-	if (find_target(me->name, DURING_LOAD)) {
-		fprintf(stderr, "%s: target `%s' already registered.\n",
-			program_name, me->name);
-		exit(1);
-	}
-
-	if (me->size != IP6T_ALIGN(me->size)) {
-		fprintf(stderr, "%s: target `%s' has invalid size %u.\n",
-			program_name, me->name, (unsigned int)me->size);
-		exit(1);
-	}
-
-	/* Prepend to list. */
-	me->next = ip6tables_targets;
-	ip6tables_targets = me;
-	me->t = NULL;
-	me->tflags = 0;
+	me->family = AF_INET6;
+	xtables_register_target(me);
 }
 
 static void
@@ -1516,7 +1263,7 @@ make_delete_mask(struct ip6t_entry *fw, struct ip6tables_rule_match *matches)
 
 	mask = fw_calloc(1, size
 			 + IP6T_ALIGN(sizeof(struct ip6t_entry_target))
-			 + ip6tables_targets->size);
+			 + xtables_targets->size);
 
 	memset(mask, 0xFF, sizeof(struct ip6t_entry));
 	mptr = mask + sizeof(struct ip6t_entry);
@@ -1530,7 +1277,7 @@ make_delete_mask(struct ip6t_entry *fw, struct ip6tables_rule_match *matches)
 
 	memset(mptr, 0xFF, 
 	       IP6T_ALIGN(sizeof(struct ip6t_entry_target))
-	       + ip6tables_targets->userspacesize);
+	       + xtables_targets->userspacesize);
 
 	return mask;
 }
@@ -1690,19 +1437,6 @@ list_entries(const ip6t_chainlabel chain, int verbose, int numeric,
 	return found;
 }
 
-int load_ip6tables_ko(const char *modprobe, int quiet)
-{
-	static int loaded = 0;
-	static int ret = -1;
-
-	if (!loaded) {
-		ret = xtables_insmod("ip6_tables", modprobe, quiet);
-		loaded = (ret == 0);
-	}
-
-	return ret;
-}
-
 static struct ip6t_entry *
 generate_entry(const struct ip6t_entry *fw,
 	       struct ip6tables_rule_match *matches,
@@ -1791,10 +1525,10 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 
 	/* clear mflags in case do_command gets called a second time
 	 * (we clear the global list of all matches for security)*/
-	for (m = ip6tables_matches; m; m = m->next)
+	for (m = xtables_matches; m; m = m->next)
 		m->mflags = 0;
 
-	for (t = ip6tables_targets; t; t = t->next) {
+	for (t = xtables_targets; t; t = t->next) {
 		t->tflags = 0;
 		t->used = 0;
 	}
@@ -2259,7 +1993,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 		*handle = ip6tc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_ip6tables_ko(modprobe, 0) != -1)
+	if (!*handle && load_xtables_ko(modprobe, 0) != -1)
 		*handle = ip6tc_init(*table);
 
 	if (!*handle)
diff --git a/iptables-restore.c b/iptables-restore.c
index dada284..0b7a07d 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -60,7 +60,7 @@ iptc_handle_t create_handle(const char *tablename, const char* modprobe )
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
-		xtables_insmod("ip_tables", modprobe, 0);
+		load_xtables_ko(modprobe, 0);
 		handle = iptc_init(tablename);
 	}
 
diff --git a/iptables.c b/iptables.c
index 39b8e01..47de864 100644
--- a/iptables.c
+++ b/iptables.c
@@ -187,15 +187,9 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 
 const char *program_version;
 const char *program_name;
-char *lib_dir;
 
 int kernel_version;
 
-/* Keeping track of external matches and targets: linked lists.  */
-struct iptables_match *iptables_matches = NULL;
-struct iptables_target *iptables_targets = NULL;
-
-/* Extra debugging from libiptc */
 extern void dump_entries(const iptc_handle_t handle);
 
 /* A few hardcoded protocols for 'all' and in case the user has no
@@ -205,6 +199,15 @@ struct pprot {
 	u_int8_t num;
 };
 
+struct afinfo afinfo = {
+	.family		= AF_INET,
+	.libprefix	= "libipt_",
+	.ipproto	= IPPROTO_IP,
+	.kmod		= "ip_tables",
+	.so_rev_match	= IPT_SO_GET_REVISION_MATCH,
+	.so_rev_target	= IPT_SO_GET_REVISION_TARGET,
+};
+
 /* Primitive headers... */
 /* defined in netinet/in.h */
 #if 0
@@ -472,7 +475,7 @@ exit_printhelp(struct iptables_rule_match *matches)
 	/* Print out any special helps. A user might like to be able
 	   to add a --help to the commandline, and see expected
 	   results. So we call help for all specified matches & targets */
-	for (t = iptables_targets; t ;t = t->next) {
+	for (t = xtables_targets; t ;t = t->next) {
 		if (t->used) {
 			printf("\n");
 			t->help();
@@ -698,82 +701,6 @@ parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
 	}
 }
 
-struct iptables_match *
-find_match(const char *name, enum ipt_tryload tryload, struct iptables_rule_match **matches)
-{
-	struct iptables_match *ptr;
-
-	for (ptr = iptables_matches; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0) {
-			struct iptables_match *clone;
-			
-			/* First match of this type: */
-			if (ptr->m == NULL)
-				break;
-
-			/* Second and subsequent clones */
-			clone = fw_malloc(sizeof(struct iptables_match));
-			memcpy(clone, ptr, sizeof(struct iptables_match));
-			clone->mflags = 0;
-			/* This is a clone: */
-			clone->next = clone;
-
-			ptr = clone;
-			break;
-		}
-	}		
-
-#ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		char path[strlen(lib_dir) + sizeof("/libipt_.so")
-			 + strlen(name)];
-		sprintf(path, "%s/libipt_%s.so", lib_dir, name);
-		if (dlopen(path, RTLD_NOW)) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified target as match. */
-			ptr = find_match(name, DONT_LOAD, NULL);
-
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load match `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
-			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load match `%s':%s\n",
-				   name, dlerror());
-	}
-#else
-	if (ptr && !ptr->loaded) {
-		if (tryload != DONT_LOAD)
-			ptr->loaded = 1;
-		else
-			ptr = NULL;
-	}
-	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
-		exit_error(PARAMETER_PROBLEM,
-			   "Couldn't find match `%s'\n", name);
-	}
-#endif
-
-	if (ptr && matches) {
-		struct iptables_rule_match **i;
-		struct iptables_rule_match *newentry;
-
-		newentry = fw_malloc(sizeof(struct iptables_rule_match));
-
-		for (i = matches; *i; i = &(*i)->next) {
-			if (strcmp(name, (*i)->match->name) == 0)
-				(*i)->completed = 1;
-		}
-		newentry->match = ptr;
-		newentry->completed = 0;
-		newentry->next = NULL;
-		*i = newentry;
-	}
-
-	return ptr;
-}
-
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct iptables_match *
 find_proto(const char *pname, enum ipt_tryload tryload, int nolookup, struct iptables_rule_match **matches)
@@ -1025,61 +952,6 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	}
 }
 
-struct iptables_target *
-find_target(const char *name, enum ipt_tryload tryload)
-{
-	struct iptables_target *ptr;
-
-	/* Standard target? */
-	if (strcmp(name, "") == 0
-	    || strcmp(name, IPTC_LABEL_ACCEPT) == 0
-	    || strcmp(name, IPTC_LABEL_DROP) == 0
-	    || strcmp(name, IPTC_LABEL_QUEUE) == 0
-	    || strcmp(name, IPTC_LABEL_RETURN) == 0)
-		name = "standard";
-
-	for (ptr = iptables_targets; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0)
-			break;
-	}
-
-#ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
-		char path[strlen(lib_dir) + sizeof("/libipt_.so")
-			 + strlen(name)];
-		sprintf(path, "%s/libipt_%s.so", lib_dir, name);
-		if (dlopen(path, RTLD_NOW)) {
-			/* Found library.  If it didn't register itself,
-			   maybe they specified match as a target. */
-			ptr = find_target(name, DONT_LOAD);
-			if (!ptr)
-				exit_error(PARAMETER_PROBLEM,
-					   "Couldn't load target `%s'\n",
-					   name);
-		} else if (tryload == LOAD_MUST_SUCCEED)
-			exit_error(PARAMETER_PROBLEM,
-				   "Couldn't load target `%s':%s\n",
-				   name, dlerror());
-	}
-#else
-	if (ptr && !ptr->loaded) {
-		if (tryload != DONT_LOAD)
-			ptr->loaded = 1;
-		else
-			ptr = NULL;
-	}
-	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
-		exit_error(PARAMETER_PROBLEM,
-			   "Couldn't find target `%s'\n", name);
-	}
-#endif
-
-	if (ptr)
-		ptr->used = 1;
-
-	return ptr;
-}
-
 static struct option *
 merge_options(struct option *oldopts, const struct option *newopts,
 	      unsigned int *option_offset)
@@ -1105,164 +977,16 @@ merge_options(struct option *oldopts, const struct option *newopts,
 	return merge;
 }
 
-static int compatible_revision(const char *name, u_int8_t revision, int opt)
+void register_match(struct iptables_match *me)
 {
-	struct ipt_get_revision rev;
-	socklen_t s = sizeof(rev);
-	int max_rev, sockfd;
-
-	sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
-	if (sockfd < 0) {
-		fprintf(stderr, "Could not open socket to kernel: %s\n",
-			strerror(errno));
-		exit(1);
-	}
-
-	load_iptables_ko(modprobe, 1);
-
-	strcpy(rev.name, name);
-	rev.revision = revision;
-
-	max_rev = getsockopt(sockfd, IPPROTO_IP, opt, &rev, &s);
-	if (max_rev < 0) {
-		/* Definitely don't support this? */
-		if (errno == ENOENT || errno == EPROTONOSUPPORT) {
-			close(sockfd);
-			return 0;
-		} else if (errno == ENOPROTOOPT) {
-			close(sockfd);
-			/* Assume only revision 0 support (old kernel) */
-			return (revision == 0);
-		} else {
-			fprintf(stderr, "getsockopt failed strangely: %s\n",
-				strerror(errno));
-			exit(1);
-		}
-	}
-	close(sockfd);
-	return 1;
-}
-
-static int compatible_match_revision(const char *name, u_int8_t revision)
-{
-	return compatible_revision(name, revision, IPT_SO_GET_REVISION_MATCH);
-}
-
-static int compatible_target_revision(const char *name, u_int8_t revision)
-{
-	return compatible_revision(name, revision, IPT_SO_GET_REVISION_TARGET);
-}
-
-void
-register_match(struct iptables_match *me)
-{
-	struct iptables_match **i, *old;
-
-	if (strcmp(me->version, program_version) != 0) {
-		fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
-			program_name, me->name, me->version, program_version);
-		exit(1);
-	}
-
-	/* Revision field stole a char from name. */
-	if (strlen(me->name) >= IPT_FUNCTION_MAXNAMELEN-1) {
-		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			program_name, me->name);
-		exit(1);
-	}
-
-	old = find_match(me->name, DURING_LOAD, NULL);
-	if (old) {
-		if (old->revision == me->revision) {
-			fprintf(stderr,
-				"%s: match `%s' already registered.\n",
-				program_name, me->name);
-			exit(1);
-		}
-
-		/* Now we have two (or more) options, check compatibility. */
-		if (compatible_match_revision(old->name, old->revision)
-		    && old->revision > me->revision)
-			return;
-
-		/* Replace if compatible. */
-		if (!compatible_match_revision(me->name, me->revision))
-			return;
-
-		/* Delete old one. */
-		for (i = &iptables_matches; *i!=old; i = &(*i)->next);
-		*i = old->next;
-	}
-
-	if (me->size != IPT_ALIGN(me->size)) {
-		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
-			program_name, me->name, (unsigned int)me->size);
-		exit(1);
-	}
-
-	/* Append to list. */
-	for (i = &iptables_matches; *i; i = &(*i)->next);
-	me->next = NULL;
-	*i = me;
-
-	me->m = NULL;
-	me->mflags = 0;
+	me->family = PF_INET;
+	xtables_register_match(me);
 }
 
-void
-register_target(struct iptables_target *me)
+void register_target(struct iptables_target *me)
 {
-	struct iptables_target *old;
-
-	if (strcmp(me->version, program_version) != 0) {
-		fprintf(stderr, "%s: target `%s' v%s (I'm v%s).\n",
-			program_name, me->name, me->version, program_version);
-		exit(1);
-	}
-
-	/* Revision field stole a char from name. */
-	if (strlen(me->name) >= IPT_FUNCTION_MAXNAMELEN-1) {
-		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			program_name, me->name);
-		exit(1);
-	}
-
-	old = find_target(me->name, DURING_LOAD);
-	if (old) {
-		struct iptables_target **i;
-
-		if (old->revision == me->revision) {
-			fprintf(stderr,
-				"%s: target `%s' already registered.\n",
-				program_name, me->name);
-			exit(1);
-		}
-
-		/* Now we have two (or more) options, check compatibility. */
-		if (compatible_target_revision(old->name, old->revision)
-		    && old->revision > me->revision)
-			return;
-
-		/* Replace if compatible. */
-		if (!compatible_target_revision(me->name, me->revision))
-			return;
-
-		/* Delete old one. */
-		for (i = &iptables_targets; *i!=old; i = &(*i)->next);
-		*i = old->next;
-	}
-
-	if (me->size != IPT_ALIGN(me->size)) {
-		fprintf(stderr, "%s: target `%s' has invalid size %u.\n",
-			program_name, me->name, (unsigned int)me->size);
-		exit(1);
-	}
-
-	/* Prepend to list. */
-	me->next = iptables_targets;
-	iptables_targets = me;
-	me->t = NULL;
-	me->tflags = 0;
+	me->family = PF_INET;
+	xtables_register_target(me);
 }
 
 static void
@@ -1580,7 +1304,7 @@ make_delete_mask(struct ipt_entry *fw, struct iptables_rule_match *matches)
 
 	mask = fw_calloc(1, size
 			 + IPT_ALIGN(sizeof(struct ipt_entry_target))
-			 + iptables_targets->size);
+			 + xtables_targets->size);
 
 	memset(mask, 0xFF, sizeof(struct ipt_entry));
 	mptr = mask + sizeof(struct ipt_entry);
@@ -1594,7 +1318,7 @@ make_delete_mask(struct ipt_entry *fw, struct iptables_rule_match *matches)
 
 	memset(mptr, 0xFF,
 	       IPT_ALIGN(sizeof(struct ipt_entry_target))
-	       + iptables_targets->userspacesize);
+	       + xtables_targets->userspacesize);
 
 	return mask;
 }
@@ -1754,19 +1478,6 @@ list_entries(const ipt_chainlabel chain, int verbose, int numeric,
 	return found;
 }
 
-int load_iptables_ko(const char *modprobe, int quiet)
-{
-	static int loaded = 0;
-	static int ret = -1;
-
-	if (!loaded) {
-		ret = xtables_insmod("ip_tables", modprobe, quiet);
-		loaded = (ret == 0);
-	}
-
-	return ret;
-}
-
 static struct ipt_entry *
 generate_entry(const struct ipt_entry *fw,
 	       struct iptables_rule_match *matches,
@@ -1870,10 +1581,10 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 
 	/* clear mflags in case do_command gets called a second time
 	 * (we clear the global list of all matches for security)*/
-	for (m = iptables_matches; m; m = m->next)
+	for (m = xtables_matches; m; m = m->next)
 		m->mflags = 0;
 
-	for (t = iptables_targets; t; t = t->next) {
+	for (t = xtables_targets; t; t = t->next) {
 		t->tflags = 0;
 		t->used = 0;
 	}
@@ -2347,7 +2058,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 		*handle = iptc_init(*table);
 
 	/* try to insmod the module if iptc_init failed */
-	if (!*handle && load_iptables_ko(modprobe, 0) != -1)
+	if (!*handle && load_xtables_ko(modprobe, 0) != -1)
 		*handle = iptc_init(*table);
 
 	if (!*handle)
diff --git a/xtables.c b/xtables.c
index 1b65b95..f00531c 100644
--- a/xtables.c
+++ b/xtables.c
@@ -23,6 +23,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/wait.h>
@@ -30,13 +31,21 @@
 #include <iptables_common.h>
 #include <xtables.h>
 
+#define NPROTO	255
+
 #ifndef PROC_SYS_MODPROBE
 #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
 #endif
 
+char *lib_dir;
+
 /* the path to command to load kernel module */
 const char *modprobe = NULL;
 
+/* Keeping track of external matches and targets: linked lists.  */
+struct xtables_match *xtables_matches;
+struct xtables_target *xtables_targets;
+
 void *fw_calloc(size_t count, size_t size)
 {
 	void *p;
@@ -131,3 +140,336 @@ int xtables_insmod(const char *modname, const char *modprobe, int quiet)
 	return -1;
 }
 
+int load_xtables_ko(const char *modprobe, int quiet)
+{
+	static int loaded = 0;
+	static int ret = -1;
+
+	if (!loaded) {
+		ret = xtables_insmod(afinfo.kmod, modprobe, quiet);
+		loaded = (ret == 0);
+	}
+
+	return ret;
+}
+
+struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
+				 struct xtables_rule_match **matches)
+{
+	struct xtables_match *ptr;
+	const char *icmp6 = "icmp6";
+
+	/* This is ugly as hell. Nonetheless, there is no way of changing
+	 * this without hurting backwards compatibility */
+	if ( (strcmp(name,"icmpv6") == 0) ||
+	     (strcmp(name,"ipv6-icmp") == 0) ||
+	     (strcmp(name,"icmp6") == 0) )
+		name = icmp6;
+
+	for (ptr = xtables_matches; ptr; ptr = ptr->next) {
+		if (strcmp(name, ptr->name) == 0) {
+			struct xtables_match *clone;
+
+			/* First match of this type: */
+			if (ptr->m == NULL)
+				break;
+
+			/* Second and subsequent clones */
+			clone = fw_malloc(sizeof(struct xtables_match));
+			memcpy(clone, ptr, sizeof(struct xtables_match));
+			clone->mflags = 0;
+			/* This is a clone: */
+			clone->next = clone;
+
+			ptr = clone;
+			break;
+		}
+	}
+
+#ifndef NO_SHARED_LIBS
+	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
+		char path[strlen(lib_dir) + sizeof("/.so")
+			  + strlen(afinfo.libprefix) + strlen(name)];
+		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
+			name);
+		if (dlopen(path, RTLD_NOW)) {
+			/* Found library.  If it didn't register itself,
+			   maybe they specified target as match. */
+			ptr = find_match(name, DONT_LOAD, NULL);
+
+			if (!ptr)
+				exit_error(PARAMETER_PROBLEM,
+					   "Couldn't load match `%s'\n",
+					   name);
+		} else if (tryload == LOAD_MUST_SUCCEED)
+			exit_error(PARAMETER_PROBLEM,
+				   "Couldn't load match `%s':%s\n",
+				   name, dlerror());
+	}
+#else
+	if (ptr && !ptr->loaded) {
+		if (tryload != DONT_LOAD)
+			ptr->loaded = 1;
+		else
+			ptr = NULL;
+	}
+	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
+		exit_error(PARAMETER_PROBLEM,
+			   "Couldn't find match `%s'\n", name);
+	}
+#endif
+
+	if (ptr && matches) {
+		struct xtables_rule_match **i;
+		struct xtables_rule_match *newentry;
+
+		newentry = fw_malloc(sizeof(struct xtables_rule_match));
+
+		for (i = matches; *i; i = &(*i)->next) {
+			if (strcmp(name, (*i)->match->name) == 0)
+				(*i)->completed = 1;
+		}
+		newentry->match = ptr;
+		newentry->completed = 0;
+		newentry->next = NULL;
+		*i = newentry;
+	}
+
+	return ptr;
+}
+
+
+struct xtables_target *find_target(const char *name, enum xt_tryload tryload)
+{
+	struct xtables_target *ptr;
+
+	/* Standard target? */
+	if (strcmp(name, "") == 0
+	    || strcmp(name, XTC_LABEL_ACCEPT) == 0
+	    || strcmp(name, XTC_LABEL_DROP) == 0
+	    || strcmp(name, XTC_LABEL_QUEUE) == 0
+	    || strcmp(name, XTC_LABEL_RETURN) == 0)
+		name = "standard";
+
+	for (ptr = xtables_targets; ptr; ptr = ptr->next) {
+		if (strcmp(name, ptr->name) == 0)
+			break;
+	}
+
+#ifndef NO_SHARED_LIBS
+	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
+		char path[strlen(lib_dir) + sizeof("/.so")
+			  + strlen(afinfo.libprefix) + strlen(name)];
+		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix, name);
+		if (dlopen(path, RTLD_NOW)) {
+			/* Found library.  If it didn't register itself,
+			   maybe they specified match as a target. */
+			ptr = find_target(name, DONT_LOAD);
+			if (!ptr)
+				exit_error(PARAMETER_PROBLEM,
+					   "Couldn't load target `%s'\n",
+					   name);
+		} else if (tryload == LOAD_MUST_SUCCEED)
+			exit_error(PARAMETER_PROBLEM,
+				   "Couldn't load target `%s':%s\n",
+				   name, dlerror());
+	}
+#else
+	if (ptr && !ptr->loaded) {
+		if (tryload != DONT_LOAD)
+			ptr->loaded = 1;
+		else
+			ptr = NULL;
+	}
+	if(!ptr && (tryload == LOAD_MUST_SUCCEED)) {
+		exit_error(PARAMETER_PROBLEM,
+			   "Couldn't find target `%s'\n", name);
+	}
+#endif
+
+	if (ptr)
+		ptr->used = 1;
+
+	return ptr;
+}
+
+static int compatible_revision(const char *name, u_int8_t revision, int opt)
+{
+	struct xt_get_revision rev;
+	socklen_t s = sizeof(rev);
+	int max_rev, sockfd;
+
+	sockfd = socket(afinfo.family, SOCK_RAW, IPPROTO_RAW);
+	if (sockfd < 0) {
+		fprintf(stderr, "Could not open socket to kernel: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+
+	load_xtables_ko(modprobe, 1);
+
+	strcpy(rev.name, name);
+	rev.revision = revision;
+
+	max_rev = getsockopt(sockfd, afinfo.ipproto, opt, &rev, &s);
+	if (max_rev < 0) {
+		/* Definitely don't support this? */
+		if (errno == ENOENT || errno == EPROTONOSUPPORT) {
+			close(sockfd);
+			return 0;
+		} else if (errno == ENOPROTOOPT) {
+			close(sockfd);
+			/* Assume only revision 0 support (old kernel) */
+			return (revision == 0);
+		} else {
+			fprintf(stderr, "getsockopt failed strangely: %s\n",
+				strerror(errno));
+			exit(1);
+		}
+	}
+	close(sockfd);
+	return 1;
+}
+
+
+static int compatible_match_revision(const char *name, u_int8_t revision)
+{
+	return compatible_revision(name, revision, afinfo.so_rev_match);
+}
+
+static int compatible_target_revision(const char *name, u_int8_t revision)
+{
+	return compatible_revision(name, revision, afinfo.so_rev_target);
+}
+
+void xtables_register_match(struct xtables_match *me)
+{
+	struct xtables_match **i, *old;
+
+	if (strcmp(me->version, program_version) != 0) {
+		fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
+			program_name, me->name, me->version, program_version);
+		exit(1);
+	}
+
+	/* Revision field stole a char from name. */
+	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
+		fprintf(stderr, "%s: target `%s' has invalid name\n",
+			program_name, me->name);
+		exit(1);
+	}
+
+	if (me->family >= NPROTO) {
+		fprintf(stderr,
+			"%s: BUG: match %s has invalid protocol family\n",
+			program_name, me->name);
+		exit(1);
+	}
+
+	/* ignore not interested match */
+	if (me->family != afinfo.family)
+		return;
+
+	old = find_match(me->name, DURING_LOAD, NULL);
+	if (old) {
+		if (old->revision == me->revision) {
+			fprintf(stderr,
+				"%s: match `%s' already registered.\n",
+				program_name, me->name);
+			exit(1);
+		}
+
+		/* Now we have two (or more) options, check compatibility. */
+		if (compatible_match_revision(old->name, old->revision)
+		    && old->revision > me->revision)
+			return;
+
+		/* Replace if compatible. */
+		if (!compatible_match_revision(me->name, me->revision))
+			return;
+
+		/* Delete old one. */
+		for (i = &xtables_matches; *i!=old; i = &(*i)->next);
+		*i = old->next;
+	}
+
+	if (me->size != XT_ALIGN(me->size)) {
+		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
+			program_name, me->name, (unsigned int)me->size);
+		exit(1);
+	}
+
+	/* Append to list. */
+	for (i = &xtables_matches; *i; i = &(*i)->next);
+	me->next = NULL;
+	*i = me;
+
+	me->m = NULL;
+	me->mflags = 0;
+}
+
+void xtables_register_target(struct xtables_target *me)
+{
+	struct xtables_target *old;
+
+	if (strcmp(me->version, program_version) != 0) {
+		fprintf(stderr, "%s: target `%s' v%s (I'm v%s).\n",
+			program_name, me->name, me->version, program_version);
+		exit(1);
+	}
+
+	/* Revision field stole a char from name. */
+	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
+		fprintf(stderr, "%s: target `%s' has invalid name\n",
+			program_name, me->name);
+		exit(1);
+	}
+
+	if (me->family >= NPROTO) {
+		fprintf(stderr,
+			"%s: BUG: target %s has invalid protocol family\n",
+			program_name, me->name);
+		exit(1);
+	}
+
+	/* ignore not interested target */
+	if (me->family != afinfo.family)
+		return;
+
+	old = find_target(me->name, DURING_LOAD);
+	if (old) {
+		struct xtables_target **i;
+
+		if (old->revision == me->revision) {
+			fprintf(stderr,
+				"%s: target `%s' already registered.\n",
+				program_name, me->name);
+			exit(1);
+		}
+
+		/* Now we have two (or more) options, check compatibility. */
+		if (compatible_target_revision(old->name, old->revision)
+		    && old->revision > me->revision)
+			return;
+
+		/* Replace if compatible. */
+		if (!compatible_target_revision(me->name, me->revision))
+			return;
+
+		/* Delete old one. */
+		for (i = &xtables_targets; *i!=old; i = &(*i)->next);
+		*i = old->next;
+	}
+
+	if (me->size != XT_ALIGN(me->size)) {
+		fprintf(stderr, "%s: target `%s' has invalid size %u.\n",
+			program_name, me->name, (unsigned int)me->size);
+		exit(1);
+	}
+
+	/* Prepend to list. */
+	me->next = xtables_targets;
+	xtables_targets = me;
+	me->t = NULL;
+	me->tflags = 0;
+}
-- 
1.5.2.2
