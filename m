From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 2/2] Fix (improve) deadlock condition on module removal netfilter socket option removal
Date: Tue, 4 Sep 2007 16:30:53 -0400
Message-ID: <20070904203053.GC19083@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com
To: rusty@rustcorp.com.au, adam@yggdrasil.com, jcm@jonmasters.org,
	kaber@trash.net, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755891AbXIDUst@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hey-
	2nd of two patches.  This patch enhances modprobe to operate like rmmod
in non-blocking mode.  It also adds a -w option to allow for explicit blocking
operation.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 modprobe.8 |    9 +++++++++
 modprobe.c |   21 ++++++++++++++-------
 2 files changed, 23 insertions(+), 7 deletions(-)


diff --git a/modprobe.8 b/modprobe.8
index 6910b5a..83f3229 100644
--- a/modprobe.8
+++ b/modprobe.8
@@ -109,6 +109,15 @@ sense to specify module parameters when removing modules).
 There is usually no reason to remove modules, but some
 buggy modules require it.  Your kernel may not support
 removal of modules.
+
+.TP
+\fB-w --wait \fR
+This option is applicable only with the -r or --remove option.
+It causes modprobe to block in the kernel waiting for the specified
+modules reference count to reach zero.  Default operation is for
+modprobe to operate like rmmod, which exits with EWOULDBLOCK if the 
+modules reference count is non-zero.
+
 .TP
 \fB-V --version \fR
 Show version of program, and exit.  See below for caveats when run on older kernels.
diff --git a/modprobe.c b/modprobe.c
index ea8de74..c9bd6af 100644
--- a/modprobe.c
+++ b/modprobe.c
@@ -913,7 +913,8 @@ static void rmmod(struct list_head *list,
 		  struct module_command *commands,
 		  int ignore_commands,
 		  int ignore_inuse,
-		  const char *cmdline_opts)
+		  const char *cmdline_opts,
+		  int flags)
 {
 	const char *command;
 	unsigned int usecount = 0;
@@ -967,7 +968,7 @@ static void rmmod(struct list_head *list,
 	/* Now do things we depend. */
 	if (!list_empty(list))
 		rmmod(list, NULL, 0, warn, dry_run, verbose, commands,
-		      0, 1, cmdline_opts);
+		      0, 1, cmdline_opts, flags);
 	return;
 
 nonexistent_module:
@@ -1333,7 +1334,8 @@ static void handle_module(const char *modname,
 			  int strip_vermagic,
 			  int strip_modversion,
 			  int unknown_silent,
-			  const char *cmdline_opts)
+			  const char *cmdline_opts,
+			  int flags)
 {
 	if (list_empty(todo_list)) {
 		const char *command;
@@ -1355,7 +1357,7 @@ static void handle_module(const char *modname,
 
 	if (remove)
 		rmmod(todo_list, newname, first_time, error, dry_run, verbose,
-		      commands, ignore_commands, 0, cmdline_opts);
+		      commands, ignore_commands, 0, cmdline_opts, flags);
 	else
 		insmod(todo_list, NOFAIL(strdup(options)), newname,
 		       first_time, error, dry_run, verbose, modoptions,
@@ -1368,6 +1370,7 @@ static struct option options[] = { { "verbose", 0, NULL, 'v' },
 				   { "config", 1, NULL, 'C' },
 				   { "name", 1, NULL, 'o' },
 				   { "remove", 0, NULL, 'r' },
+				   { "wait", 0, NULL, 'w' },
 				   { "showconfig", 0, NULL, 'c' },
 				   { "autoclean", 0, NULL, 'k' },
 				   { "quiet", 0, NULL, 'q' },
@@ -1430,6 +1433,7 @@ int main(int argc, char *argv[])
 	char *newname = NULL;
 	char *aliasfilename, *symfilename;
 	errfn_t error = fatal;
+	int flags = O_NONBLOCK|O_EXCL;
 
 	/* Prepend options from environment. */
 	argv = merge_args(getenv("MODPROBE_OPTIONS"), argv, &argc);
@@ -1444,7 +1448,7 @@ int main(int argc, char *argv[])
 		try_old_version("modprobe", argv);
 
 	uname(&buf);
-	while ((opt = getopt_long(argc, argv, "vVC:o:rknqQsclt:aifb", options, NULL)) != -1){
+	while ((opt = getopt_long(argc, argv, "vVC:o:rknqQsclt:aifbw", options, NULL)) != -1){
 		switch (opt) {
 		case 'v':
 			add_to_env_var("-v");
@@ -1529,6 +1533,9 @@ int main(int argc, char *argv[])
 		case 'b':
 			use_blacklist = 1;
 			break;
+		case 'w':
+			flags &= ~O_NONBLOCK;
+			break;
 		case 1:
 			strip_vermagic = 1;
 			break;
@@ -1651,7 +1658,7 @@ int main(int argc, char *argv[])
 					      ignore_proc, strip_vermagic,
 					      strip_modversion,
 					      unknown_silent,
-					      optstring);
+					      optstring, flags);
 
 				aliases = aliases->next;
 				INIT_LIST_HEAD(&list);
@@ -1666,7 +1673,7 @@ int main(int argc, char *argv[])
 				      verbose, modoptions, commands,
 				      ignore_commands, ignore_proc,
 				      strip_vermagic, strip_modversion,
-				      unknown_silent, optstring);
+				      unknown_silent, optstring, flags);
 		}
 	}
 	if (log)
-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
