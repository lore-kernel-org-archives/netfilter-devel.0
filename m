From: Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH iptables] iptables: support insisting that the lock is held
Date: Thu, 20 Apr 2017 18:23:33 +0900
Message-ID: <20170420092333.78247-1-lorenzo@google.com>
Cc: pablo@netfilter.org, jscherpelz@google.com,
        subashab@codeaurora.org, dcbw@redhat.com, lorenzo@google.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:36020 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944082AbdDTJXl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2017 05:23:41 -0400
Received: by mail-oi0-f48.google.com with SMTP id r203so41936253oib.3
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2017 02:23:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently, iptables programs will exit with an error if the
iptables lock cannot be acquired, but will silently continue if
the lock cannot be opened at all. This can cause unexpected
failures (with unhelpful error messages) in the presence of
concurrent updates.

This patch adds a compile-time option that causes iptables to
refuse to do anything if the lock cannot be acquired. It is a
compile-time option instead of a command-line flag because:

1. In order to reliably avoid concurrent modification, all
   invocations of iptables commands must follow this behaviour.
2. Whether or not the lock can be opened is typically not
   a run-time condition but is likely to be a configuration
   error.

Tested by deleting xtables.lock and observing that all commands
failed if iptables was compiled with --enable-strict-locking, but
succeeded otherwise.

By default, --enable-strict-locking is disabled for backwards
compatibility reasons. It can be enabled by default in a future
change if desired.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
---
 configure.ac                 | 12 +++++++++++-
 iptables/ip6tables-restore.c |  7 +------
 iptables/ip6tables.c         | 11 ++---------
 iptables/iptables-restore.c  |  7 +------
 iptables/iptables.c          | 11 ++---------
 iptables/xshared.c           | 26 +++++++++++++++++++++++++-
 iptables/xshared.h           |  4 ++--
 7 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/configure.ac b/configure.ac
index 221812a8f3..a301bcd0db 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,6 +71,10 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
 	[Path to the xtables lock [[/run/xtables.lock]]]),
 	[xt_lock_name="$withval"],
 	[xt_lock_name="/run/xtables.lock"])
+AC_ARG_ENABLE([strict-locking],
+	AS_HELP_STRING([--enable-strict-locking],
+	[Refuse to operate unless xtables lock was acquired]),
+	[enable_strict_locking="$enableval"], [enable_strict_locking="no"])
 
 libiptc_LDFLAGS2="";
 AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
@@ -239,6 +243,11 @@ AC_SUBST([libxtables_vmajor])
 AC_DEFINE_UNQUOTED([XT_LOCK_NAME], "${xt_lock_name}",
 	[Location of the iptables lock file])
 
+if test "x$enable_strict_locking" = "xyes" ; then
+	AC_DEFINE([ENABLE_STRICT_LOCKING], [1],
+		[Define to 1 to refuse to operate unless xtables lock is acquired])
+fi
+
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
 	iptables/iptables.8 iptables/iptables-extensions.8.tmpl
@@ -273,7 +282,8 @@ Build parameters:
   Installation prefix (--prefix):	${prefix}
   Xtables extension directory:		${e_xtlibdir}
   Pkg-config directory:			${e_pkgconfigdir}
-  Xtables lock file:			${xt_lock_name}"
+  Xtables lock file:			${xt_lock_name}
+  Enable strict locking:		${enable_strict_locking}"
 
 if [[ -n "$ksourcedir" ]]; then
 	echo "  Kernel source directory:		${ksourcedir}"
diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 39a881dfce..1e50bf0db2 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -301,12 +301,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			in_table = 0;
 		} else if ((buffer[0] == '*') && (!in_table)) {
 			/* Acquire a lock before we create a new table handle */
-			lock = xtables_lock(wait, &wait_interval);
-			if (lock == XT_LOCK_BUSY) {
-				fprintf(stderr, "Another app is currently holding the xtables lock. "
-					"Perhaps you want to use the -w option?\n");
-				exit(RESOURCE_PROBLEM);
-			}
+			lock = xtables_lock_or_exit(wait, &wait_interval);
 
 			/* New table */
 			char *table;
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 579d347b09..49bd006fb2 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1779,15 +1779,8 @@ int do_command6(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && xtables_lock(wait, &wait_interval) == XT_LOCK_BUSY) {
-		fprintf(stderr, "Another app is currently holding the xtables lock. ");
-		if (wait == 0)
-			fprintf(stderr, "Perhaps you want to use the -w option?\n");
-		else
-			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
-		xtables_free_opts(1);
-		exit(RESOURCE_PROBLEM);
-	}
+	if (!restore)
+		xtables_lock_or_exit(wait, &wait_interval);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 876fe06d7f..d79fe328cc 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -299,12 +299,7 @@ iptables_restore_main(int argc, char *argv[])
 			in_table = 0;
 		} else if ((buffer[0] == '*') && (!in_table)) {
 			/* Acquire a lock before we create a new table handle */
-			lock = xtables_lock(wait, &wait_interval);
-			if (lock == XT_LOCK_BUSY) {
-				fprintf(stderr, "Another app is currently holding the xtables lock. "
-					"Perhaps you want to use the -w option?\n");
-				exit(RESOURCE_PROBLEM);
-			}
+			lock = xtables_lock_or_exit(wait, &wait_interval);
 
 			/* New table */
 			char *table;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 97cbda91cf..69d19feca1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1765,15 +1765,8 @@ int do_command4(int argc, char *argv[], char **table,
 	generic_opt_check(command, cs.options);
 
 	/* Attempt to acquire the xtables lock */
-	if (!restore && xtables_lock(wait, &wait_interval) == XT_LOCK_BUSY) {
-		fprintf(stderr, "Another app is currently holding the xtables lock. ");
-		if (wait == 0)
-			fprintf(stderr, "Perhaps you want to use the -w option?\n");
-		else
-			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
-		xtables_free_opts(1);
-		exit(RESOURCE_PROBLEM);
-	}
+	if (!restore)
+		xtables_lock_or_exit(wait, &wait_interval);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 3fbe3b1a99..5f3a90f460 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -246,7 +246,7 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-int xtables_lock(int wait, struct timeval *wait_interval)
+static int xtables_lock(int wait, struct timeval *wait_interval)
 {
 	struct timeval time_left, wait_time;
 	int fd, i = 0;
@@ -291,6 +291,30 @@ void xtables_unlock(int lock)
 		close(lock);
 }
 
+int xtables_lock_or_exit(int wait, struct timeval *wait_interval)
+{
+	int lock = xtables_lock(wait, wait_interval);
+
+	if (lock == XT_LOCK_BUSY) {
+		fprintf(stderr, "Another app is currently holding the xtables lock. ");
+		if (wait == 0)
+			fprintf(stderr, "Perhaps you want to use the -w option?\n");
+		else
+			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
+		xtables_free_opts(1);
+		exit(RESOURCE_PROBLEM);
+#ifdef ENABLE_STRICT_LOCKING
+	} else if (lock == XT_LOCK_UNSUPPORTED) {
+		fprintf(stderr, "Failed to acquire the xtables lock: %s\n",
+			strerror(errno));
+		xtables_free_opts(1);
+		exit(RESOURCE_PROBLEM);
+#endif
+	}
+
+	return lock;
+}
+
 int parse_wait_time(int argc, char *argv[])
 {
 	int wait = -1;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 539e6c243b..63a3ab271b 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -93,7 +93,7 @@ extern void xs_init_match(struct xtables_match *);
  * A value >= 0 indicates the lock filedescriptor. Other values are:
  *
  * XT_LOCK_UNSUPPORTED : The system does not support locking, execution will
- * proceed lockless.
+ * proceed lockless unless compiled with --enable-strict-locking.
  *
  * XT_LOCK_BUSY : The lock was held by another process. xtables_lock only
  * returns this value when |wait| == false. If |wait| == true, xtables_lock
@@ -106,8 +106,8 @@ enum {
 	XT_LOCK_UNSUPPORTED  = -2,
 	XT_LOCK_NOT_ACQUIRED  = -3,
 };
-extern int xtables_lock(int wait, struct timeval *tv);
 extern void xtables_unlock(int lock);
+extern int xtables_lock_or_exit(int wait, struct timeval *tv);
 
 int parse_wait_time(int argc, char *argv[]);
 void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval);
-- 
2.12.2.816.g2cccc81164-goog

