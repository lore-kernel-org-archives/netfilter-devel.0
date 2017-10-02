From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [ulogd2 PATCH] ulogd2: new config behaviour: load all plugins by
 default
Date: Mon, 02 Oct 2017 15:06:49 +0200
Message-ID: <150694960948.6287.14528158818689753765.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:56687 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750957AbdJBNHE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Oct 2017 09:07:04 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id A1FA451F2BE
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 13:07:01 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EaTIVBersJ8g for <netfilter-devel@vger.kernel.org>;
        Mon,  2 Oct 2017 15:06:49 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:13::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id CCA8451F2AA
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Oct 2017 15:06:49 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new configuration behaviour option eases a bit the configuration of ulogd2
by allowing to load all plugins in one go, without having to know their full
path.

Choosing concrete plugins and using full path for them is great for some
environmnets, but I don't think it's a common case. The common case is to
load all plugins, even ignoring where do they live in the filesystem.

Even worse, the full path may be architecture-dependant, which makes copying
the ulogd.conf file between machines unnecesarily complex.

To experiment this new behaviour, don't put any 'plugin=' directive in the
config file. Plugins will be loaded from a default directory, choosen at
build/configure time (--with-ulogd2libdir). If no specified, this is something
like '/usr/local/lib/ulogd/'.

This new configuration option doesn't implement any special logic. We simply
open the dir and try to load all files ending with '.so'.

The log message level for plugins loading is increased so users can see by
default which plugins are loaded.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 configure.ac  |   30 +++++++++++++++++++++++++++---
 src/ulogd.c   |   40 +++++++++++++++++++++++++++++++++++++++-
 ulogd.conf.in |   33 +++++++++++++++++----------------
 3 files changed, 83 insertions(+), 20 deletions(-)

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
index 684444f..b8bc57c 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -404,7 +404,7 @@ void ulogd_register_plugin(struct ulogd_plugin *me)
 				  me->name);
 			exit(EXIT_FAILURE);
 		}
-		ulogd_log(ULOGD_DEBUG, "registering plugin `%s'\n", me->name);
+		ulogd_log(ULOGD_NOTICE, "registering plugin `%s'\n", me->name);
 		llist_add(&me->list, &ulogd_plugins);
 	} else {
 		get_plugin_infos(me);
@@ -728,6 +728,41 @@ static int load_plugin(const char *file)
 	return 0;
 }
 
+static int load_all_plugins(void)
+{
+	DIR *d;
+	struct dirent *dent;
+	char path[PATH_MAX];
+
+	d = opendir(ULOGD2_LIBDIR);
+	if (d == NULL) {
+		ulogd_log(ULOGD_ERROR, "load_all_plugins: opendir(%s): %s\n",
+			  ULOGD2_LIBDIR, strerror(errno));
+		return -1;
+	}
+
+	ulogd_log(ULOGD_NOTICE, "loading all plugins at %s\n", ULOGD2_LIBDIR);
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
+		snprintf(path, sizeof(path), "%s/%s", ULOGD2_LIBDIR,
+			 dent->d_name);
+		if (load_plugin(path) != 0)
+			return -1;
+	}
+	return 0;
+}
+
 /* find an output key in a given stack, starting at 'start' */
 static struct ulogd_key *
 find_okey_in_stack(char *name,
@@ -925,6 +960,9 @@ static int create_stack(const char *option)
 	char *tok;
 	int ret;
 
+	if (llist_empty(&ulogd_plugins_handle))
+		load_all_plugins();
+
 	if (!buf) {
 		ulogd_log(ULOGD_ERROR, "");
 		ret = -ENOMEM;
diff --git a/ulogd.conf.in b/ulogd.conf.in
index a987d64..62222db 100644
--- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -20,35 +20,36 @@ logfile="/var/log/ulogd.log"
 # We have to configure and load all the plugins we want to use
 
 # general rules:
+#
+# 0. don't specify any plugin for ulogd to load them all
 # 1. load the plugins _first_ from the global section
 # 2. options for each plugin in seperate section below
 
-
-plugin="@pkglibdir@/ulogd_inppkt_NFLOG.so"
+#plugin="@pkglibdir@/ulogd_inppkt_NFLOG.so"
 #plugin="@pkglibdir@/ulogd_inppkt_ULOG.so"
 #plugin="@pkglibdir@/ulogd_inppkt_UNIXSOCK.so"
-plugin="@pkglibdir@/ulogd_inpflow_NFCT.so"
-plugin="@pkglibdir@/ulogd_filter_IFINDEX.so"
-plugin="@pkglibdir@/ulogd_filter_IP2STR.so"
-plugin="@pkglibdir@/ulogd_filter_IP2BIN.so"
+#plugin="@pkglibdir@/ulogd_inpflow_NFCT.so"
+#plugin="@pkglibdir@/ulogd_filter_IFINDEX.so"
+#plugin="@pkglibdir@/ulogd_filter_IP2STR.so"
+#plugin="@pkglibdir@/ulogd_filter_IP2BIN.so"
 #plugin="@pkglibdir@/ulogd_filter_IP2HBIN.so"
-plugin="@pkglibdir@/ulogd_filter_PRINTPKT.so"
-plugin="@pkglibdir@/ulogd_filter_HWHDR.so"
-plugin="@pkglibdir@/ulogd_filter_PRINTFLOW.so"
+#plugin="@pkglibdir@/ulogd_filter_PRINTPKT.so"
+#plugin="@pkglibdir@/ulogd_filter_HWHDR.so"
+#plugin="@pkglibdir@/ulogd_filter_PRINTFLOW.so"
 #plugin="@pkglibdir@/ulogd_filter_MARK.so"
-plugin="@pkglibdir@/ulogd_output_LOGEMU.so"
-plugin="@pkglibdir@/ulogd_output_SYSLOG.so"
-plugin="@pkglibdir@/ulogd_output_XML.so"
+#plugin="@pkglibdir@/ulogd_output_LOGEMU.so"
+#plugin="@pkglibdir@/ulogd_output_SYSLOG.so"
+#plugin="@pkglibdir@/ulogd_output_XML.so"
 #plugin="@pkglibdir@/ulogd_output_SQLITE3.so"
-plugin="@pkglibdir@/ulogd_output_GPRINT.so"
+#plugin="@pkglibdir@/ulogd_output_GPRINT.so"
 #plugin="@pkglibdir@/ulogd_output_NACCT.so"
 #plugin="@pkglibdir@/ulogd_output_PCAP.so"
 #plugin="@pkglibdir@/ulogd_output_PGSQL.so"
 #plugin="@pkglibdir@/ulogd_output_MYSQL.so"
 #plugin="@pkglibdir@/ulogd_output_DBI.so"
-plugin="@pkglibdir@/ulogd_raw2packet_BASE.so"
-plugin="@pkglibdir@/ulogd_inpflow_NFACCT.so"
-plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
+#plugin="@pkglibdir@/ulogd_raw2packet_BASE.so"
+#plugin="@pkglibdir@/ulogd_inpflow_NFACCT.so"
+#plugin="@pkglibdir@/ulogd_output_GRAPHITE.so"
 #plugin="@pkglibdir@/ulogd_output_JSON.so"
 
 # this is a stack for logging packet send by system via LOGEMU

