From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Wed, 1 Jan 2003 21:32:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030101213205.A27131@linux.karinthy.hu>
References: <20030101171654.B25870@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Cc: "David S . Miller" <davem@redhat.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030101171654.B25870@linux.karinthy.hu>; from valko@linux.karinthy.hu on Wed, Jan 01, 2003 at 05:16:54PM +0100
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Improved version follows.
Both patches had something to improve.

Laszlo
e-mail: <valko@linux.karinthy.hu>

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="diff-2.4.20-netfilter-sparc64-2"

--- linux-2.4.20/arch/sparc64/kernel/sys_sparc32.c	2002-12-09 16:50:51.000000000 +0100
+++ linux-2.4.20-my/arch/sparc64/kernel/sys_sparc32.c	2003-01-01 20:33:05.000000000 +0100
@@ -50,6 +50,7 @@
 #include <linux/icmpv6.h>
 #include <linux/sysctl.h>
 #include <linux/dnotify.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
 
 #include <asm/types.h>
 #include <asm/ipc.h>
@@ -2777,6 +2778,78 @@
 extern asmlinkage int sys_setsockopt(int fd, int level, int optname,
 				     char *optval, int optlen);
 
+static int do_netfilter_replace(int fd, int level, int optname,
+				char *optval, int optlen)
+{
+	struct ipt_replace32 {
+		char name[IPT_TABLE_MAXNAMELEN];
+		__u32 valid_hooks;
+		__u32 num_entries;
+		__u32 size;
+		__u32 hook_entry[NF_IP_NUMHOOKS];
+		__u32 underflow[NF_IP_NUMHOOKS];
+		__u32 num_counters;
+		__u32 counters;
+		struct ipt_entry entries[0];
+	} *repl32 = (struct ipt_replace32 *)optval;
+	struct ipt_replace *krepl;
+	struct ipt_counters *counters32;
+	__u32 origsize;
+	unsigned int kreplsize, kcountersize;
+	mm_segment_t old_fs;
+	int ret;
+
+	if (optlen < sizeof(repl32))
+		return -EINVAL;
+
+	if (copy_from_user(&origsize,
+			&repl32->size,
+			sizeof(origsize)))
+		return -EFAULT;
+
+	kreplsize = sizeof(*krepl) + origsize;
+	kcountersize = krepl->num_counters * sizeof(struct ipt_counters);
+
+	/* Hack: Causes ipchains to give correct error msg --RR */
+	if (optlen != kreplsize)
+		return -ENOPROTOOPT;
+
+	krepl = (struct ipt_replace *)kmalloc(kreplsize, GFP_KERNEL);
+	if (krepl == NULL)
+		return -ENOMEM;
+
+	if (copy_from_user(krepl, optval, kreplsize)) {
+		kfree(krepl);
+		return -EFAULT;
+	}
+
+	counters32 = (struct ipt_counters *)AA(
+		((struct ipt_replace32 *)krepl)->counters);
+
+	kcountersize = krepl->num_counters * sizeof(struct ipt_counters);
+	krepl->counters = (struct ipt_counters *)kmalloc(
+					kcountersize, GFP_KERNEL);
+	if (krepl->counters == NULL) {
+		kfree(krepl);
+		return -ENOMEM;
+	}
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	ret = sys_setsockopt(fd, level, optname,
+			     (char *)krepl, kreplsize);
+	set_fs(old_fs);
+
+	if (ret == 0 &&
+		copy_to_user(counters32, krepl->counters, kcountersize))
+			ret = -EFAULT;
+
+	kfree(krepl->counters);
+	kfree(krepl);
+
+	return ret;
+}
+
 static int do_set_attach_filter(int fd, int level, int optname,
 				char *optval, int optlen)
 {
@@ -2870,6 +2943,9 @@
 asmlinkage int sys32_setsockopt(int fd, int level, int optname,
 				char *optval, int optlen)
 {
+	if (optname == IPT_SO_SET_REPLACE)
+		return do_netfilter_replace(fd, level, optname,
+					    optval, optlen);
 	if (optname == SO_ATTACH_FILTER)
 		return do_set_attach_filter(fd, level, optname,
 					    optval, optlen);

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="diff-iptables-1.2.7a-sparc64-2"

diff -Naur iptables-1.2.7a/Makefile iptables-1.2.7a-my/Makefile
--- iptables-1.2.7a/Makefile	2002-08-26 15:04:39.000000000 +0200
+++ iptables-1.2.7a-my/Makefile	2003-01-01 21:16:41.000000000 +0100
@@ -35,6 +35,18 @@
 CFLAGS += -DNO_SHARED_LIBS=1
 endif
 
+# Sparc64 hack
+ifeq ($(shell uname -m),sparc64)
+# The kernel is 64-bit, even though userspace is 32.
+CFLAGS+=-DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
+endif
+
+# HPPA hack
+ifeq ($(shell uname -m),parisc64)
+# The kernel is 64-bit, even though userspace is 32.
+CFLAGS+=-DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
+endif
+
 ifndef NO_SHARED_LIBS
 DEPFILES = $(SHARED_LIBS:%.so=%.d)
 SH_CFLAGS:=$(CFLAGS) -fPIC
@@ -64,18 +76,6 @@
 EXTRA_INSTALLS_EXP+=$(DESTDIR)$(BINDIR)/ip6tables-save $(DESTDIR)$(BINDIR)/ip6tables-restore # $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-save.8 $(DESTDIR)$(MANDIR)/man8/ip6tables-restore.8
 endif
 
-# Sparc64 hack
-ifeq ($(shell uname -m),sparc64)
-# The kernel is 64-bit, even though userspace is 32.
-CFLAGS+=-DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
-endif
-
-# HPPA hack
-ifeq ($(shell uname -m),parisc64)
-# The kernel is 64-bit, even though userspace is 32.
-CFLAGS+=-DIPT_MIN_ALIGN=8 -DKERNEL_64_USERSPACE_32
-endif
-
 ifndef IPT_LIBDIR
 IPT_LIBDIR:=$(LIBDIR)/iptables
 endif
diff -Naur iptables-1.2.7a/extensions/libipt_limit.c iptables-1.2.7a-my/extensions/libipt_limit.c
--- iptables-1.2.7a/extensions/libipt_limit.c	2002-05-29 15:08:16.000000000 +0200
+++ iptables-1.2.7a-my/extensions/libipt_limit.c	2003-01-01 21:16:25.000000000 +0100
@@ -13,6 +13,20 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_limit.h>
 
+#if defined(KERNEL_64_USERSPACE_32)
+struct ipt_rateinfo_compat {
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+
+	u_int64_t prev;
+	u_int32_t credit;
+	u_int32_t credit_cap, cost;
+	u_int64_t master;
+};
+
+#define	ipt_rateinfo	ipt_rateinfo_compat
+#endif
+
 #define IPT_LIMIT_AVG	"3/hour"
 #define IPT_LIMIT_BURST	5
 
diff -Naur iptables-1.2.7a/libiptc/libiptc.c iptables-1.2.7a-my/libiptc/libiptc.c
--- iptables-1.2.7a/libiptc/libiptc.c	2002-05-29 15:08:16.000000000 +0200
+++ iptables-1.2.7a-my/libiptc/libiptc.c	2003-01-01 21:16:25.000000000 +0100
@@ -1690,13 +1690,11 @@
 		/* Kernel will think that pointer should be 64-bits, and get
 		   padding.  So we accomodate here (assumption: alignment of
 		   `counters' is on 64-bit boundary). */
-		u_int64_t *kernptr = (u_int64_t *)&newcounters->counters;
 		if ((unsigned long)&newcounters->counters % 8 != 0) {
 			fprintf(stderr,
 				"counters alignment incorrect! Mail rusty!\n");
 			abort();
 		}
-		*kernptr = newcounters->counters;
 	}
 #endif /* KERNEL_64_USERSPACE_32 */
 

--pf9I7BMVVzbSWLtt--
