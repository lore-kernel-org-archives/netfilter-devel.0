From: Harald Welte <laforge@netfilter.org>
Subject: nfsim updates
Date: Mon, 20 Sep 2004 00:34:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040919223457.GL1307@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xssso5lpTBgMxDfe"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jk@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Xssso5lpTBgMxDfe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I was actually over the last days using nfsim for useful debugging the
first time :)

Please review (+ integrate?) the following changes:

1) add open/fopen support to fakesockopt (for iptables-save)
2) block SIGCHILD in message.c (if exec()ed program dies)
3) fix wrong "((len =3D read(fd, msg, sizeof(*msg)) !=3D sizeof(*msg)))"
4) add iptables-save and iptables-restore as commands

I've also started some early (boring) ipv6 support work, but it turned
out to be more time consuming than I though :(  I'll try to finish this
at some point, though.

btw: Could you please make your current SVN tree publicly accessible at
some point?  As stated before, we could also move it to
svn.netfilter.org (which actually exists, but also has no public
interface yet).

- Harald


diff -Nru nfsim-20040907-plain/core/fakesockopt.c nfsim-20040907-laf/core/f=
akesockopt.c
--- nfsim-20040907-plain/core/fakesockopt.c	2004-03-01 07:26:37.000000000 +=
0100
+++ nfsim-20040907-laf/core/fakesockopt.c	2004-09-20 00:27:58.000000000 +02=
00
@@ -1,6 +1,6 @@
 /*
=20
-Copyright (c) 2003,2004 Jeremy Kerr & Rusty Russell
+Copyright (c) 2003,2004 Jeremy Kerr, Rusty Russell & Harald Welte
=20
 This file is part of nfsim.
=20
@@ -33,21 +33,28 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
+
 #include <dlfcn.h>
=20
 #include <assert.h>
 #include <string.h>
=20
+#include <netinet/in.h>
+
 /* pointers to the real functions */
 static int (*__socket)(int, int, int);
 static int (*__getsockopt)(int, int , int , void *, socklen_t *);
 static int (*__setsockopt)(int, int , int , void *, socklen_t *);
+static int (*__open)(const char *pathname, int flags, ...);
+FILE * (*__fopen)(const char *path, const char *mode);
 static int (*__close)(int);
=20
 static int sd;
 static void *handle;
+static char *proc_prefix =3D "/tmp/nfsim/proc";
=20
 #undef DEBUG
+#define DEBUG
=20
 /* utils expects a log function.  Give it to them. */
 void nfsim_log(enum log_type type, const char *fmt, ...)
@@ -81,6 +88,7 @@
 {
 	struct sockaddr_un unix_addr;
 	int addrlen;
+	char *prefix;
=20
 	if (!(handle =3D dlopen("libc.so.6", RTLD_LAZY))) {
 		fprintf(stderr, "%s\n", dlerror());
@@ -90,6 +98,8 @@
 	sym(handle, getsockopt);
 	sym(handle, setsockopt);
 	sym(handle, socket);
+	sym(handle, open);
+	sym(handle, fopen);
 	sym(handle, close);
=20
 	dlclose(handle);
@@ -112,6 +122,10 @@
 		exit(EXIT_FAILURE);
 	}
=20
+	prefix =3D getenv("NFSIM_PROC_PREFIX");
+	if (prefix)
+		proc_prefix =3D prefix;
+
 	return;
=20
 }
@@ -254,9 +268,100 @@
 	printf("socket(%d, %d, %d)\n", domain, type, protocol);
 #endif /* DEBUG */
=20
-	return sd;
+	/* only catch AF_INET/SOCK_RAW/IPPROTO_RAW sockets */
+	if (domain =3D=3D AF_INET && type =3D=3D SOCK_RAW && protocol =3D=3D IPPR=
OTO_RAW)
+		return sd;
+	//else if (domain =3D=3D AF_NETLINK)
+	//	return fake_netlink_socket(domain, type, protocol);
+	else
+		return __socket(domain, type, protocol);
+}
+
+
+static int file_is_proc(const char *pathname)
+{
+	if (pathname && strlen(pathname) >=3D 6=20
+	    && !strncmp(pathname, "/proc/", 6))
+		return 1;
+	else
+		return 0;
+}
+
+static char *mangle_alloc_proc_path(const char *pathname)
+{
+	char *fakepath =3D (char *) malloc(strlen(pathname)=20
+			 + strlen(proc_prefix));
+	if (!fakepath)
+		return NULL;
+
+	strcpy(fakepath, proc_prefix);
+	strcat(fakepath, pathname+5); /* 5 because '/' */
+
+	return fakepath;
 }
=20
+
+/* open intercepts any accesses to /proc and directs them to somewhere els=
e */
+int open(const char *pathname, int flags, ...)
+{
+	int ret;
+	va_list arglist;
+	mode_t mode =3D 0;
+
+#ifdef DEBUG
+	printf("open(%s, %d)\n", pathname, flags);
+#endif
+
+	va_start(arglist, flags);
+
+	/* mode is only valid if O_CREAT was specified */
+	if (flags & O_CREAT)
+		mode =3D va_arg(arglist, mode_t);
+
+	/* if this is not a /proc open, pass it through */
+	if (!file_is_proc(pathname))
+		ret =3D __open(pathname, flags, mode);
+	else {
+		char *fakepath =3D mangle_alloc_proc_path(pathname);
+		if (!fakepath) {
+			ret =3D -ENOMEM;
+			/* need this ugly goto for va_end */
+			goto out;
+		}
+
+		/* mode will be ignored in case of no O_CRAT */
+		ret =3D __open(fakepath, flags, mode);
+
+		free(fakepath);
+	}
+out:
+	va_end(arglist);
+	return ret;
+}
+
+FILE *fopen(const char *path, const char *mode)
+{
+	FILE *ret;
+
+#ifdef DEBUG
+	printf("%s(%s, %s)\n", __FUNCTION__, path, mode);
+#endif
+
+	if (!file_is_proc(path))
+		ret =3D __fopen(path, mode);
+	else {
+		char *fakepath =3D mangle_alloc_proc_path(path);
+		if (!fakepath) {
+			errno =3D -ENOMEM;
+			return NULL;
+		}
+
+		ret =3D __fopen(fakepath, mode);
+	}
+	return ret;
+}
+
+
 int close(int fd)
 {
 	return (fd =3D=3D sd) ? 0 : (*__close)(fd);
diff -Nru nfsim-20040907-plain/core/message.c nfsim-20040907-laf/core/messa=
ge.c
--- nfsim-20040907-plain/core/message.c	2004-03-01 07:26:37.000000000 +0100
+++ nfsim-20040907-laf/core/message.c	2004-09-19 22:11:00.000000000 +0200
@@ -22,6 +22,7 @@
 #include "message.h"
 #include "utils.h"
=20
+#include <signal.h>
 #include <sys/stat.h>
 #include <sys/socket.h>
 #include <sys/un.h>
@@ -35,6 +36,7 @@
 void message_init(void)
 {
 	struct sockaddr_un unix_addr;
+	sigset_t ss;
=20
 	unlink(FAKE_SOCKET);
=20
@@ -51,11 +53,21 @@
=20
 	if (listen(sockfd, 0))
 		barf_perror("listen");
+
+	sigemptyset(&ss);
+	sigaddset(&ss, SIGPIPE);
+	sigprocmask(SIG_BLOCK, &ss, NULL);
 }
=20
 void message_cleanup(void)
 {
+	sigset_t ss;
+
 	close(sockfd);
+
+	sigemptyset(&ss);
+	sigaddset(&ss, SIGPIPE);
+	sigprocmask(SIG_UNBLOCK, &ss, NULL);
 }
=20
 int message_client_connection(int fd)
@@ -80,10 +92,12 @@
 	struct nf_userspace_message *msg;
=20
 	msg =3D new(struct nf_userspace_message);
-	if ((len =3D read(fd, msg, sizeof(*msg)) !=3D sizeof(*msg))) {
+	len =3D read(fd, msg, sizeof(*msg));
+	if (len !=3D sizeof(*msg)) {
 		free(msg);
 		return -1;
 	}
+	fprintf(stderr, "%s: received %u bytes\n", __FUNCTION__, len);
=20
 	if (msg->type =3D=3D UM_SYSCALL) {
 		switch (msg->opcode) {
@@ -122,7 +136,7 @@
 				msg->opcode);
 		}
 	} else {
-		fprintf(stderr, "Unknown message type\n");
+		fprintf(stderr, "Unknown message type %d\n", msg->type);
 	}
=20
 	free(msg);
diff -Nru nfsim-20040907-plain/tools/iptables.c nfsim-20040907-laf/tools/ip=
tables.c
--- nfsim-20040907-plain/tools/iptables.c	2004-03-01 07:26:29.000000000 +01=
00
+++ nfsim-20040907-laf/tools/iptables.c	2004-09-19 22:11:27.000000000 +0200
@@ -1,6 +1,6 @@
 /*
=20
-Copyright (c) 2003,2004 Jeremy Kerr & Rusty Russell
+Copyright (c) 2003,2004 Jeremy Kerr, Rusty Russell and Harald Welte
=20
 This file is part of nfsim.
=20
@@ -24,6 +24,7 @@
 #include <ipv4/ipv4.h>
=20
 #include <unistd.h>
+#include <stdlib.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 #include <signal.h>
@@ -31,36 +32,46 @@
 #include "message.h"
=20
 static int sigfd[2];
+static char *iptables_prefix =3D "/sbin";
=20
 static void wake_parent(int signum)
 {
 	write(sigfd[1], "", 1);
 }
=20
-static bool iptables(int argc, char **argv)
+static bool xtables_x(int argc, char **argv)
 {
 	pid_t child;
 	int status;
+	int cmdlen =3D strlen(argv[0]) + strlen(iptables_prefix) + 2;
+	char *cmd =3D malloc(cmdlen);
+
+	if (!cmd)
+		barf_perror("%s: ENOMEM", argv[0]);
+
+	strcpy(cmd, iptables_prefix);
+	strcat(cmd, "/");
+	strcat(cmd, argv[0]);
=20
 	if (pipe(sigfd) !=3D 0)
-		barf_perror("iptables pipe");
+		barf_perror("%s pipe", argv[0]);
=20
 	signal(SIGCHLD, wake_parent);
-=09
+
 	child =3D fork();
 	switch (child) {
 	case -1:
-		barf_perror("iptables fork");
+		barf_perror("%s fork", argv[0]);
 	case 0:
 		if (setenv("LD_PRELOAD", "core/fakesockopt.so.1.0", 1))
 			barf("putenv failed");
-		execv("/sbin/iptables", argv);
+		execv(cmd, argv);
 		exit(1);
 	}
=20
 	wait_for_message(sigfd[0]);
 	if (waitpid(child, &status, WNOHANG) <=3D 0)
-		barf_perror("Waiting for iptables child");
+		barf_perror("Waiting for %s child", argv[0]);
=20
 	close(sigfd[0]);
 	close(sigfd[1]);
@@ -70,16 +81,29 @@
 	return false;
 }
=20
-static void iptables_help(int argc, char **argv)
+static void xtables_x_help(int argc, char **argv)
 {
-	nfsim_log(LOG_ALWAYS, "iptables <arguments>\n"
-		"\trun iptables (on the simulated netfilter code), with the\n"
-		"\tspecified arguments");
+	nfsim_log(LOG_ALWAYS, "%s <arguments>\n"
+		"\trun %s (on the simulated netfilter code), with the\n"
+		"\tspecified arguments", argv[0]);
 }
=20
 static int init(void)
 {
-	tui_register_command("iptables", iptables, iptables_help);
+	char *prefix =3D getenv("NFSIM_IPTABLES_PREFIX");
+	if (prefix)
+		iptables_prefix =3D prefix;
+
+	tui_register_command("iptables", xtables_x, xtables_x_help);
+	tui_register_command("iptables-save", xtables_x, xtables_x_help);
+	tui_register_command("iptables-restore", xtables_x, xtables_x_help);
+
+#ifdef HAVE_IPV6
+	tui_register_command("ip6tables", xtables_x, xtables_x_help);
+	tui_register_command("ip6tables-save", xtables_x, xtables_x_help);
+	tui_register_command("ip6tables-restore", xtables_x, xtables_x_help);
+#endif
+
 	return 0;
 }
=20


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Xssso5lpTBgMxDfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBTgmRXaXGVTD0i/8RAsd4AKCmFpOiWTyFEj5VXhj1QgUD8Pp4HgCfXF26
VmQWRbLBVx3z9JSF1/lcTQk=
=+hwn
-----END PGP SIGNATURE-----

--Xssso5lpTBgMxDfe--
