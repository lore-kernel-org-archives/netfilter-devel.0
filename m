From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] backquote bugfixes, extension_path changes,
	command "echo"
Date: Tue, 11 Oct 2005 00:10:49 +0200
Message-ID: <20051010221049.GA32155@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Cc: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Rusty,

I have found three bugs in your changes to my backquote patches, the
following patches fix them.  Another patch eliminates extension_path
and modifies $PATH the way I proposed today, and the final one
implements an "echo" command, which is required for the "backquotes"
nfsim test (for nfsim-testsuite).

Max



--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-mk-20051011-01-typo_refer_to_line_i.patch"

Mon Oct 10 21:11:02 CEST 2005  max@duempel.org
  * typo: refer to line[i] instead of *line
diff -rN -u old-nfsim-0/core/tui.c new-nfsim-0/core/tui.c
--- old-nfsim-0/core/tui.c	2005-10-11 00:05:23.000000000 +0200
+++ new-nfsim-0/core/tui.c	2005-10-11 00:05:23.000000000 +0200
@@ -337,7 +337,7 @@
 		if (isspace(line[i])) {
 			line[i] = '\0';
 			prevspace = true;
-		} else if (*line == '`') {
+		} else if (line[i] == '`') {
 			/* FIXME: Assumes ` forms arg by itself. */
 			argv[argc++] = backquote(line, &i);
 		} else if (prevspace) {


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-mk-20051011-02-alter_env_path.patch"

Mon Oct 10 22:15:58 CEST 2005  max@duempel.org
  * remove extension_path, alter $PATH instead
diff -rN -u old-nfsim-0/core/core.c new-nfsim-0/core/core.c
--- old-nfsim-0/core/core.c	2005-10-11 00:05:39.000000000 +0200
+++ new-nfsim-0/core/core.c	2005-10-10 22:15:44.000000000 +0200
@@ -427,6 +427,27 @@
 		(*p)();
 }
 
+static void add_to_path(const char *dir) {
+	int ret;
+	struct stat st;
+	char *old_path, *new_path;
+
+	ret = stat(dir, &st);
+	if (ret == -1 || !S_ISDIR(st.st_mode))
+		return;
+
+	old_path = getenv("PATH");
+	if (old_path == NULL)
+		old_path = "";
+
+	new_path = talloc_asprintf(NULL, "%s:%s",
+				   dir, old_path);
+
+	setenv("PATH", new_path, 1);
+
+	talloc_free(new_path);
+}
+
 int main(int argc, char **argv)
 {
 	int c, input_fd = STDIN_FILENO;
@@ -454,6 +475,10 @@
 	} else if (get_failtest())
 		barf("Not clever enough to use --failtest interactively");
 
+	add_to_path(".");
+	if (getenv("NFSIM_EXTPATH"))
+		add_to_path(getenv("NFSIM_EXTPATH"));
+
 	/* Hack to make users' lives easier: set LD_LIBRARY_PATH for
 	 * fakesockopt.so, based on where we are. */
 	p = strrchr(argv[0], '/');
@@ -467,7 +492,10 @@
 		setenv("LD_LIBRARY_PATH", path, 1);
 		talloc_free(path);
 		module_path = talloc_asprintf(NULL, "%s/nfsim", LIBDIR);
-		extension_path = module_path;
+
+		path = talloc_asprintf(NULL, "%s/nfsim/extensions", LIBDIR);
+		add_to_path(path);
+		talloc_free(path);
 	} else {
 		char *oldpath, *path;
 
@@ -480,13 +508,14 @@
 		talloc_free(path);
 		module_path = talloc_asprintf(NULL, "%.*s/netfilter/ipv4",
 					      (int)(p - argv[0]), argv[0]);
-		extension_path = talloc_asprintf(NULL, "%.*s/tools/extensions",
-					      (int)(p - argv[0]), argv[0]);
+
+		path = talloc_asprintf(NULL, "%.*s/nfsim/extensions",
+				       (int)(p - argv[0]), argv[0]);
+		add_to_path(path);
+		talloc_free(path);
 	}
 	if (getenv("NFSIM_MODPATH"))
 		module_path = getenv("NFSIM_MODPATH");
-	if (getenv("NFSIM_EXTPATH"))
-		extension_path = getenv("NFSIM_EXTPATH");
 
 	/* Don't do failures during initialization. */
 	suppress_failtest++;
diff -rN -u old-nfsim-0/core/tui.c new-nfsim-0/core/tui.c
--- old-nfsim-0/core/tui.c	2005-10-11 00:05:39.000000000 +0200
+++ new-nfsim-0/core/tui.c	2005-10-11 00:05:40.000000000 +0200
@@ -37,7 +37,6 @@
 int tui_abort_on_fail;
 int tui_quiet;
 int tui_linenum = 1;
-char *extension_path;
 static bool stop;
 
 struct command {
@@ -289,8 +288,8 @@
 		script_fail("no matching \"`\" found");
 
 	len = end - (line + *off);
-	cmdstr = talloc_asprintf(line, "%s/%.*s",
-				 extension_path, len, line + *off);
+	cmdstr = talloc_asprintf(line, "%.*s",
+				 len, line + *off);
 	cmdfile = popen(cmdstr, "r");
 	if (!cmdfile)
 		script_fail("failed to popen '%s': %s\n",


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-mk-20051011-03-fix_off_by_one.patch"

Mon Oct 10 22:52:09 CEST 2005  max@duempel.org
  * fix rusty's off-by-one error in backquote()
diff -rN -u old-nfsim-0/core/tui.c new-nfsim-0/core/tui.c
--- old-nfsim-0/core/tui.c	2005-10-11 00:05:51.000000000 +0200
+++ new-nfsim-0/core/tui.c	2005-10-11 00:05:51.000000000 +0200
@@ -339,6 +339,7 @@
 		} else if (line[i] == '`') {
 			/* FIXME: Assumes ` forms arg by itself. */
 			argv[argc++] = backquote(line, &i);
+			--i;
 		} else if (prevspace) {
 			/* If it is a comment, stop before we process `` */
 			if (argc == 0 && line[i] == '#')


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-mk-20051011-04-implement_echo_command.patch"

Mon Oct 10 23:45:49 CEST 2005  max@duempel.org
  * implement the echo command
diff -rN -u old-nfsim-0/tools/echo.c new-nfsim-0/tools/echo.c
--- old-nfsim-0/tools/echo.c	1970-01-01 01:00:00.000000000 +0100
+++ new-nfsim-0/tools/echo.c	2005-10-10 23:45:20.000000000 +0200
@@ -0,0 +1,81 @@
+/*
+
+Copyright (c) 2005 Max Kellermann <max@duempel.org>
+
+This file is part of nfsim.
+
+nfsim is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
+
+nfsim is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+You should have received a copy of the GNU General Public License
+along with nfsim; if not, write to the Free Software
+Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+*/
+
+#include <tui.h>
+#include <core.h>
+#include <utils.h>
+
+#include <sys/types.h>
+#include <unistd.h>
+
+static void echo_help(int argc, char **argv)
+{
+#include "echo-help:echo"
+/*** XML Help:
+    <section id="c:echo">
+     <title><command>echo</command></title>
+     <para>Print a message</para>
+     <cmdsynopsis>
+      <arg choice="req"><replaceable>text...</replaceable></arg>
+     </cmdsynopsis>
+     <cmdsynopsis>
+      <command>echo</command>
+      <arg choice="req"><replaceable>text...</replaceable></arg>
+     </cmdsynopsis>
+     <para><command>echo</command> prints a message.</para>
+    </section>
+*/
+}
+
+static bool echo(int argc, char **argv)
+{
+	char buffer[8192];
+	size_t length = 0, next_length;
+	int i;
+
+	for (i = 1; i < argc; i++) {
+		next_length = strlen(argv[i]);
+		if (length + next_length + 1 >= sizeof(buffer)) {
+			nfsim_log(LOG_ALWAYS, "Argument list too long");
+			return false;
+		}
+
+		if (length > 0)
+			buffer[length++] = ' ';
+
+		memcpy(buffer + length, argv[i], next_length);
+		length += next_length;
+	}
+
+	buffer[length] = 0;
+
+	nfsim_log(LOG_ALWAYS, "%s", buffer);
+
+	return true;
+}
+
+static void init(void)
+{
+	tui_register_command("echo", echo, echo_help);
+}
+
+init_call(init);
+


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-mk-20051011-05-handle_concatenated_backquotes.patch"

Tue Oct 11 00:03:04 CEST 2005  max@duempel.org
  * handle concatenated backquotes
diff -rN -u old-nfsim-0/core/tui.c new-nfsim-0/core/tui.c
--- old-nfsim-0/core/tui.c	2005-10-11 00:06:13.000000000 +0200
+++ new-nfsim-0/core/tui.c	2005-10-11 00:02:33.000000000 +0200
@@ -338,8 +338,45 @@
 			prevspace = true;
 		} else if (line[i] == '`') {
 			/* FIXME: Assumes ` forms arg by itself. */
-			argv[argc++] = backquote(line, &i);
-			--i;
+			unsigned old_i = i;
+			char *result;
+			size_t len1, len2;
+
+			result = backquote(line, &i);
+			len1 = strlen(result);
+
+			/* prepend last argument if there was one */
+			if (!prevspace && argc > 0) {
+				size_t old_arg_length;
+				char *new_arg;
+
+				--argc;
+
+				old_arg_length = (line + old_i) - argv[argc];
+				new_arg = talloc_array(line, char,
+						       old_arg_length + len1 + 1);
+				memcpy(new_arg, argv[argc], old_arg_length);
+				memcpy(new_arg + old_arg_length, result,
+				       len1);
+				new_arg[old_arg_length + len1] = 0;
+
+				talloc_free(result);
+				result = new_arg;
+				len1 += old_arg_length;
+			}
+
+			/* append rest of line to result .. */
+			len2 = strlen(line + i);
+			result = talloc_realloc(line, result,
+						char, len1 + len2 + 1);
+			memcpy(result + len1, line + i, len2 + 1);
+
+			/* .. because this will allow us to append
+			   directly to a backquoted string */
+			argv[argc++] = line = result;
+			i = len1 - 1;
+
+			prevspace = false;
 		} else if (prevspace) {
 			/* If it is a comment, stop before we process `` */
 			if (argc == 0 && line[i] == '#')


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-testsuite-test_backquotes.patch"

Index: 00simulator/02backquote.sim
===================================================================
--- 00simulator/02backquote.sim	(revision 0)
+++ 00simulator/02backquote.sim	(revision 0)
@@ -0,0 +1,20 @@
+expect echo foo
+echo foo
+
+expect echo bar
+echo `echo -n bar`
+
+expect echo foo bar
+echo foo `echo -n bar`
+
+expect echo foobar
+echo foo`echo -n bar`
+
+expect echo barfoo
+echo `echo -n bar`foo
+
+expect echo farboo
+echo `echo -n far``echo -n boo`
+
+expect echo far0boo
+echo `echo -n far`0`echo -n boo`

--J2SCkAp4GZ/dPZZf--
