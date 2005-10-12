From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] escape backquote characters
Date: Wed, 12 Oct 2005 13:55:08 +0200
Message-ID: <20051012115508.GA15770@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

due to problems introduced by my backquote patches, I have changed
nfsim to escape backquotes in its escape() function.  Additionally,
process_line() does not interpret a character after a backslash.  That
allows you to write backquotes (escaped with backslash) in nfsim
tests, which are not executed by the shell.

Max


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfsim-01-escape_backquote.patch"

Wed Oct 12 13:50:19 CEST 2005  max@duempel.org
  * escape backquote character
diff -rN -u old-nfsim-0/core/tui.c new-nfsim-0/core/tui.c
--- old-nfsim-0/core/tui.c	2005-10-12 13:53:28.000000000 +0200
+++ new-nfsim-0/core/tui.c	2005-10-12 13:50:07.000000000 +0200
@@ -258,9 +258,9 @@
 		} else if (src[i] == '\t') {
 			*p++ = '\\';
 			*p++ = 't';
-		} else if (src[i] == '\\') {
-			*p++ = '\\';
+		} else if (src[i] == '\\' || src[i] == '`') {
 			*p++ = '\\';
+			*p++ = src[i];
 		} else if (src[i] & 0x80 || (src[i] & 0xe0) == 0) {
 			*p++ = '\\';
 			*p++ = 'x';
@@ -354,6 +354,9 @@
 		} else if (line[i] == '`') {
 			char *inside = backquote(line, &i);
 			argv[argc] = append_string(argv, argc, inside);
+		} else if (line[i] == '\\' && line[i + 1]) {
+			argv[argc] = append_char(argv, argc, line[i]);
+			argv[argc] = append_char(argv, argc, line[++i]);
 		} else {
 			/* If it is a comment, stop before we process `` */
 			if (!argv[0] && line[i] == '#')


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="nfsim-02-test_escaped_backquote.patch"

Wed Oct 12 13:51:53 CEST 2005  max@duempel.org
  * add test for escaped backquote
diff -rN -u old-nfsim-0/testsuite/backquote.sim new-nfsim-0/testsuite/backquote.sim
--- old-nfsim-0/testsuite/backquote.sim	2005-10-12 13:54:22.000000000 +0200
+++ new-nfsim-0/testsuite/backquote.sim	2005-10-12 13:51:29.000000000 +0200
@@ -18,3 +18,12 @@
 
 expect echo far0boo
 echo `echo -n far`0`echo -n boo`
+
+expect echo `echo -n \\`
+echo \\
+
+expect echo `echo -en "\x60"`
+echo \`
+
+expect echo \\foo
+echo \\`echo -n foo`


--C7zPtVaVf+AK4Oqc--
