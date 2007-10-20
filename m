From: Peter Warasin <peter@endian.com>
Subject: [PATCH 3/3] iptables-edit: introduces iptables-edit cli tool
Date: Sat, 20 Oct 2007 02:57:16 +0200
Message-ID: <4719526C.4010401@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020808050103030901000007"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:40333 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935393AbXJTBYm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:24:42 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id F161759821C
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 02:57:20 +0200 (CEST)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mOMKvZxIlJGi for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Oct 2007 02:57:18 +0200 (CEST)
Received: from [10.139.200.200] (host92-108-dynamic.54-82-r.retail.telecomitalia.it [82.54.108.92])
	by solaria.endian.it (Postfix) with ESMTP id 7289E59821F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Oct 2007 02:57:17 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020808050103030901000007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

introduces the iptables-edit command line tool

Signed-off-by: Peter Warasin <peter@endian.com>


-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------020808050103030901000007
Content-Type: text/x-patch;
 name="iptables-1.3.8-edit-p3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.3.8-edit-p3.patch"

--- iptables-1.3.8.patch/Makefile.orig	2007-10-19 02:04:43.000000000 +0200
+++ iptables-1.3.8.patch/Makefile	2007-10-19 02:05:27.000000000 +0200
@@ -48,9 +48,9 @@
 
 # No longer experimental.
 ifneq ($(DO_MULTI), 1)
-EXTRAS+=iptables-save iptables-restore iptables-xml
+EXTRAS+=iptables-save iptables-restore iptables-xml iptables-edit
 endif
-EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/iptables-save $(DESTDIR)$(BINDIR)/iptables-restore $(DESTDIR)$(BINDIR)/iptables-xml $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8
+EXTRA_INSTALLS+=$(DESTDIR)$(BINDIR)/iptables-save $(DESTDIR)$(BINDIR)/iptables-restore $(DESTDIR)$(BINDIR)/iptables-xml $(DESTDIR)$(BINDIR)/iptables-edit $(DESTDIR)$(MANDIR)/man8/iptables-restore.8 $(DESTDIR)$(MANDIR)/man8/iptables-save.8
 
 ifeq ($(DO_IPV6), 1)
 EXTRAS+=ip6tables ip6tables.o ip6tables.8
@@ -135,7 +135,7 @@
 	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
 ifeq ($(DO_MULTI), 1)
-iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-standalone.c iptables.o iptables-save-lib.o iptables-restore-lib.o $(STATIC_LIBS) libiptc/libiptc.a
+iptables: iptables-multi.c iptables-save.c iptables-restore.c iptables-xml.c iptables-edit.c iptables-standalone.c iptables.o iptables-save-lib.o iptables-restore-lib.o $(STATIC_LIBS) libiptc/libiptc.a
 	$(CC) $(CFLAGS) -DIPTABLES_MULTI -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
 else
 iptables: iptables-standalone.c iptables.o $(STATIC_LIBS) libiptc/libiptc.a
@@ -185,6 +185,19 @@
 	cp $< $@
 endif
 
+iptables-edit: iptables-edit.c iptables-save-lib.o iptables-restore-lib.o iptables.o $(STATIC_LIBS) libiptc/libiptc.a
+	$(CC) $(CFLAGS) -DIPT_LIB_DIR=\"$(IPT_LIBDIR)\" $(LDFLAGS) -o $@ $^ $(LDLIBS)
+
+ifeq ($(DO_MULTI), 1)
+$(DESTDIR)$(BINDIR)/iptables-edit: iptables
+	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
+	ln -sf $< $@
+else
+$(DESTDIR)$(BINDIR)/iptables-edit: iptables-edit
+	@[ -d $(DESTDIR)$(BINDIR) ] || mkdir -p $(DESTDIR)$(BINDIR)
+	cp $< $@
+endif
+
 ip6tables.o: ip6tables.c
 	$(CC) $(CFLAGS) -DIP6T_LIB_DIR=\"$(IPT_LIBDIR)\" -c -o $@ $<
 
--- iptables-1.3.8.patch/iptables-multi.c.orig	2007-10-19 02:04:29.000000000 +0200
+++ iptables-1.3.8.patch/iptables-multi.c	2007-10-19 02:06:37.000000000 +0200
@@ -6,6 +6,7 @@
 int iptables_main(int argc, char **argv);
 int iptables_save_main(int argc, char **argv);
 int iptables_restore_main(int argc, char **argv);
+int iptables_edit_main(int argc, char **argv);
 int iptables_xml_main(int argc, char **argv);
 
 int main(int argc, char **argv) {
@@ -28,6 +29,9 @@
     
     if (!strcmp(progname, "iptables-xml"))
       return iptables_xml_main(argc, argv);
+
+    if (!strcmp(progname, "iptables-edit"))
+      return iptables_edit_main(argc, argv);
     
     fprintf(stderr, "iptables multi-purpose version: unknown applet name %s\n", progname);
     exit(1);
--- iptables-1.3.8/iptables-edit.c.orig	2007-10-19 00:45:23.000000000 +0200
+++ iptables-1.3.8/iptables-edit.c	2007-10-18 02:21:47.000000000 +0200
@@ -0,0 +1,260 @@
+/* Code to edit an iptables state file generated by iptables-save. */
+/* (C) 2007 by Peter Warasin <peter@endian.com>
+ * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
+ * and Harald Welte <laforge@gnumonks.org>
+ *
+ * This code is distributed under the terms of GNU GPL v2
+ *
+ */
+#include <getopt.h>
+#include <sys/errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "libiptc/libiptc.h"
+#include "iptables.h"
+#include "iptables-restore-lib.h"
+#include "iptables-save-lib.h"
+
+int binary = 0, counters = 0, verbose = 0;
+char *modprobeparam = 0;
+char *statefile = 0;
+int commandargc = 0;
+char *commandargv[255];
+
+static struct option options[] = {
+	{ "binary", 0, 0, 'b' },
+	{ "counters", 0, 0, 'c' },
+        { "verbose", 0, 0, 'v' },
+        { "help", 0, 0, 'h' },
+        { "modprobe", 1, 0, 'M'},
+	{ "state-file", 0, 0, 'i' },
+	{ 0 }
+};
+
+struct handle_list_t {
+	char tablename[IPT_TABLE_MAXNAMELEN + 1];
+	iptc_handle_t handle;
+	struct handle_list_t *next;
+};
+struct handle_list_t *table_handles = NULL;
+
+static void print_usage(const char *name, const char *version) __attribute__((noreturn));
+
+static void print_usage(const char *name, const char *version)
+{
+        fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-h] [-M] <-i>\n"
+                        "          [ --binary ]\n"
+                        "          [ --counters ]\n"
+                        "          [ --verbose ]\n"
+                        "          [ --help ]\n"
+                        "          [ --modprobe=<command>]\n"
+                        "          [ --state-file=<STATEFILE>]\n", name);
+        exit(1);
+}
+
+void add_handle(const char *tablename, iptc_handle_t handle) {
+	struct handle_list_t *tmp;
+	tmp = (struct handle_list_t *) malloc(sizeof(struct handle_list_t));
+	strncpy(tmp->tablename, tablename, IPT_TABLE_MAXNAMELEN);
+	tmp->tablename[IPT_TABLE_MAXNAMELEN] = '\0';
+	tmp->handle = handle;
+	tmp->next = table_handles;
+	table_handles = tmp;
+}
+
+iptc_handle_t get_handle(const char *tablename) {
+	iptc_handle_t handle;
+	struct handle_list_t *i = NULL;
+	if (tablename == NULL)
+		return NULL;
+	for (i = table_handles; i; i = i->next) {
+		if (! i) break;
+		if (strcmp(i->tablename, tablename) == 0)
+			return i->handle;
+	}
+
+	handle = iptc_init(tablename);
+	add_handle(tablename, handle);
+	return handle;
+}
+
+static int for_each_table(int (*func)(const char *tablename))
+{
+        int ret = 1;
+	FILE *procfile = NULL;
+	char tablename[IPT_TABLE_MAXNAMELEN+1];
+
+	procfile = fopen("/proc/net/ip_tables_names", "r");
+	if (!procfile)
+		return 0;
+
+	while (fgets(tablename, sizeof(tablename), procfile)) {
+		if (tablename[strlen(tablename) - 1] != '\n')
+			exit_error(OTHER_PROBLEM, 
+				   "Badly formed tablename `%s'\n",
+				   tablename);
+		tablename[strlen(tablename) - 1] = '\0';
+		ret &= func(tablename);
+	}
+
+	return ret;
+}
+
+int restore_from_file(const char *tablename) {
+	iptc_handle_t handle = get_handle(tablename);
+	if (verbose)
+		fprintf(stderr, "Restoring table '%s'\n", tablename);
+
+	if (! handle) {
+		fprintf(stderr, "Could not get netfilter handle for table '%s' while restoring\n", tablename);
+		return 0;
+	}
+	return restore_state(tablename, handle, modprobeparam, statefile, binary, counters, verbose, 0, 1);
+}
+
+int save_handles(const char *tablename) {
+	iptc_handle_t handle = get_handle(tablename);
+	if (verbose)
+		fprintf(stderr, "Saving table '%s'\n", tablename);
+	if (! handle) {
+		fprintf(stderr, "Could not get netfilter handle for table '%s' while saving\n", tablename);
+		return 0;
+	}
+	return do_output(tablename, handle, binary, counters);
+}
+
+
+/* function adding one argument to newargv, updating newargc 
+ * returns true if argument added, false otherwise */
+static int add_argv(char *what) {
+	if (what && ((commandargc + 1) < sizeof(commandargv)/sizeof(char *))) {
+		commandargv[commandargc] = strdup(what);
+		commandargc++;
+		return 1;
+	} else 
+		return 0;
+}
+
+static void free_argv(void) {
+	int i;
+
+	for (i = 0; i < commandargc; i++) {
+		free(commandargv[i]);
+		commandargv[i] = NULL;
+	}
+	commandargc = 0;
+}
+
+
+#ifdef IPTABLES_MULTI
+int
+iptables_edit_main(int argc, char *argv[])
+#else
+int
+main(int argc, char *argv[])
+#endif
+{
+	int c;
+	int ret = 0;
+	char buffer[10240];
+	int i=0;
+
+	program_name = "iptables";
+	program_version = IPTABLES_VERSION;
+
+	lib_dir = getenv("IPTABLES_LIB_DIR");
+	if (!lib_dir)
+		lib_dir = IPT_LIB_DIR;
+
+#ifdef NO_SHARED_LIBS
+	init_extensions();
+#endif
+
+	while ((c = getopt_long(argc, argv, "bcvhM:i:", options, NULL)) != -1) {
+		switch (c) {
+		case 'b':
+			binary = 1;
+			break;
+
+		case 'c':
+			counters = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'h':
+			print_usage("iptables-edit",
+                        	    IPTABLES_VERSION);
+			break;
+		case 'M':
+			modprobeparam = optarg;
+                        break;
+                case 'i':
+                        statefile = optarg;
+			break;
+
+		}
+	}
+
+	if (optind < argc) {
+		fprintf(stderr, "Unknown arguments found on commandline\n");
+		exit(1);
+	}
+
+	if (! statefile) {
+		fprintf(stderr, "No statefile (-i) specified!\n");
+		exit(1);
+	}
+
+	if ((ret = for_each_table(restore_from_file)) != 0)
+	    return ret;
+
+	if (verbose)
+		fprintf(stderr, "Accept commands\n");
+
+	/* Grab standard input. */
+	while (fgets(buffer, sizeof(buffer), stdin)) {
+		char *token = "";
+		iptc_handle_t handle = NULL;
+		char *thistable = "filter";
+
+		i++;
+		buffer[strlen(buffer)-1] = '\0';
+		if (buffer[0] == '#')
+			continue;
+		if (verbose)
+			fprintf(stderr, "Line %d: Process command '%s'\n", i, buffer);
+
+		if ((token = strtok(buffer, " \t\n")) == NULL)
+			continue;
+		free_argv();
+		add_argv(token);
+		while ((token = strtok(NULL, " \t\n")) != NULL) {
+			add_argv(token);
+		}
+
+		if ((commandargv[1] != NULL) && strcmp(commandargv[1], "-t") == 0) {
+			if (commandargv[2] == NULL) {
+				fprintf(stderr, "Line %d: -t parameter needs an argument!\n", i);
+				return 1;
+			}
+			thistable = commandargv[2];
+		}
+
+		handle = get_handle(thistable);
+		if (handle == NULL) {
+			fprintf(stderr, "Line %d: Could not get netfilter handle for table '%s' while performing command\n", i, thistable);
+			return 1;
+		}
+
+		if (! do_command(commandargc, commandargv, 
+				 &thistable, &handle)) {
+
+			fprintf(stderr, "Line %d: Command failed: %s\n", i, iptc_strerror(errno));
+			return 1;
+		}
+	}
+
+	return ! for_each_table(save_handles);
+}

--------------020808050103030901000007--
