From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [ulogd2 PATCH] ulogd2: add new config option: load_all_plugins
Date: Mon, 25 Sep 2017 13:19:27 +0200
Message-ID: <150633836700.6370.2675458398740561976.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34512 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751336AbdIYLTg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Sep 2017 07:19:36 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 5371151F1FD
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2017 11:19:33 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5hzXG8o0BwMQ for <netfilter-devel@vger.kernel.org>;
        Mon, 25 Sep 2017 13:19:27 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:13::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 3154D51F1A0
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Sep 2017 13:19:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new configuration option eases a bit the configuration of ulogd2 by
allowing to load all plugins in one go, without having to know their full path.

Choosing concrete plugins and using full path for them is great for some
environmnets, but I don't think it's a common case. The common case is to
load all plugins, even ignoring where do they live in the filesystem.

Even worse, the full path may be architecture-dependant, which makes copying
the ulogd.conf file between machines unnecesarily complex.

There are two ways of using this new config directive:

1) leave it empty	(i.e. 'load_all_plugins=')
2) use a path		(i.e. 'load_all_plugins='/usr/local/lib/mydir/')

In the first case, plugins will be loaded from a default directory, choosen at
build/configure time (--with-ulogd2libdir). If no specified, this is something
like '/usr/local/lib/ulogd/'.

In the second case, the user is responsible of providing a sensible path.

The 'load_all_plugins' directive may be combined with the old 'plugin'
directive to load other custom-made plugins elsewhere, like always.
The 'plugin' directive is keep unchanged.

This new configuration option doesn't implement any special logic. We simply
open the dir and try to load all files ending with '.so'.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 configure.ac  |   30 +++++++++++++++++++++++++++---
 src/ulogd.c   |   49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 ulogd.conf.in |   10 ++++++++++
 3 files changed, 85 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index e661981..b3441e4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -36,9 +36,6 @@ dnl Checks for library functions.
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
-regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
-AC_SUBST([regular_CFLAGS])
-
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libpthread_LIBS])
 
@@ -153,6 +150,16 @@ else
 	enable_jansson="no"
 fi
 
+AC_ARG_WITH([ulogd2libdir],
+	AS_HELP_STRING([--with-ulogd2libdir=PATH],
+        [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]]),
+        [ulogd2libdir="$withval"],
+        [ulogd2libdir="${libdir}/ulogd"])
+AC_SUBST([ulogd2libdir])
+
+regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter -DULOGD2_LIBDIR=\\\"\${ulogd2libdir}\\\"";
+AC_SUBST([regular_CFLAGS])
+
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
 dnl AC_SUBST(DATABASE_LIB_DIR)
@@ -176,8 +183,25 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
 	  src/Makefile Makefile Rules.make)
 AC_OUTPUT
 
+define([EXPAND_VARIABLE],
+[$2=[$]$1
+if test $prefix = 'NONE'; then
+        prefix="/usr/local"
+fi
+while true; do
+  case "[$]$2" in
+    *\[$]* ) eval "$2=[$]$2" ;;
+    *) break ;;
+  esac
+done
+eval "$2=[$]$2"
+])dnl EXPAND_VARIABLE
+
+EXPAND_VARIABLE(ulogd2libdir, e_ulogd2libdir)
+
 echo "
 Ulogd configuration:
+  Default plugins directory:		${e_ulogd2libdir}
   Input plugins:
     NFLOG plugin:			${enable_nflog}
     NFCT plugin:			${enable_nfct}
diff --git a/src/ulogd.c b/src/ulogd.c
index 684444f..5ae8498 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -124,10 +124,11 @@ static LLIST_HEAD(ulogd_pi_stacks);
 static int load_plugin(const char *file);
 static int create_stack(const char *file);
 static int logfile_open(const char *name);
+static int load_all_plugins();
 static void cleanup_pidfile();
 
 static struct config_keyset ulogd_kset = {
-	.num_ces = 4,
+	.num_ces = 5,
 	.ces = {
 		{
 			.key = "logfile",
@@ -153,6 +154,12 @@ static struct config_keyset ulogd_kset = {
 			.options = CONFIG_OPT_MULTI,
 			.u.parser = &create_stack,
 		},
+		{
+			.key = "load_all_plugins",
+			.type = CONFIG_TYPE_CALLBACK,
+			.options = CONFIG_OPT_NONE,
+			.u.parser = &load_all_plugins,
+		},
 	},
 };
 
@@ -728,6 +735,46 @@ static int load_plugin(const char *file)
 	return 0;
 }
 
+static int load_all_plugins(const char *arg)
+{
+	DIR *d;
+	struct dirent *dent;
+	char path[PATH_MAX];
+	const char *dir;
+
+	if (strcmp(arg, "load_all_plugins") == 0) /* no argument in conf */
+		dir = ULOGD2_LIBDIR;
+	else
+		dir = arg;
+
+	d = opendir(dir);
+	if (d == NULL) {
+		ulogd_log(ULOGD_ERROR, "load_all_plugins: opendir(%s): %s\n",
+			  dir, strerror(errno));
+		return -1;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "loading all plugins at %s\n", dir);
+
+	while ((dent = readdir(d)) != NULL) {
+		if (strcmp(dent->d_name, ".") == 0 ||
+		    strcmp(dent->d_name, "..") == 0)
+			continue;
+
+		int len = strlen(dent->d_name);
+		if (len < 3)
+			continue;
+
+		if (strcmp(&dent->d_name[len - 3], ".so") != 0)
+			continue;
+
+		snprintf(path, sizeof(path), "%s/%s", dir, dent->d_name);
+		if (load_plugin(path) != 0)
+			return -1;
+	}
+	return 0;
+}
+
 /* find an output key in a given stack, starting at 'start' */
 static struct ulogd_key *
 find_okey_in_stack(char *name,
diff --git a/ulogd.conf.in b/ulogd.conf.in
index a987d64..fe54420 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -24,6 +24,16 @@ logfile="/var/log/ulogd.log"
 # 2. options for each plugin in seperate section below
 
 
+# load all the plugins in one go. Then, there is no need to specify each
+# plugin individually. There are two ways of using this clause, by leaving it
+# blank (default) or by using a filesystem path. If blank a default directory
+# configured at build time will be used (--with-ulogd2libdir).
+#
+# Examples:
+#
+# load_all_plugins=
+# load_all_plugins=/usr/local/lib/ulogd/
+
 plugin="@pkglibdir@/ulogd_inppkt_NFLOG.so"
 #plugin="@pkglibdir@/ulogd_inppkt_ULOG.so"
 #plugin="@pkglibdir@/ulogd_inppkt_UNIXSOCK.so"

