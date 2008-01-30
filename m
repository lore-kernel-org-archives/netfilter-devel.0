From: heitzenberger@astaro.com
Subject: [ULOGD RFC 05/30] Add signalling subsystem
Date: Wed, 30 Jan 2008 19:58:52 +0100
Message-ID: <20080130190127.013311819@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-28.dex002.intermedia.net ([64.78.21.113]:20892 "EHLO
	dhost002-28.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbYA3TBl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:41 -0500
Content-Disposition: inline; filename=ulogd-fix-signal-handling.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the concept of synchronous and asynchronous signal
handlers to ulogd, where 'synchronous' just means to be synchronous to
the underlying IO multiplexer.

Will later be used by plugins like SQLITE3 and NFCT.

One of the changes herein is the usage of the pthread library.  This
is strictly necessary because some plugins might (and SQLITE3 *does*)
use pthreads.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/src/Makefile.am
===================================================================
--- ulogd-netfilter.orig/src/Makefile.am
+++ ulogd-netfilter/src/Makefile.am
@@ -5,5 +5,5 @@ AM_CPPFLAGS = $(all_includes) -I$(top_sr
 
 sbin_PROGRAMS = ulogd
 
-ulogd_SOURCES = ulogd.c ifi.c select.c timer.c conffile.c
-ulogd_LDFLAGS = -export-dynamic
+ulogd_SOURCES = ulogd.c ifi.c select.c timer.c signal.c conffile.c
+ulogd_LDFLAGS = -export-dynamic -lpthread
Index: ulogd-netfilter/src/select.c
===================================================================
--- ulogd-netfilter.orig/src/select.c
+++ ulogd-netfilter/src/select.c
@@ -23,6 +23,7 @@
 
 #include <fcntl.h>
 #include <ulogd/ulogd.h>
+#include <ulogd/common.h>
 #include <ulogd/linuxlist.h>
 
 static int maxfd = 0;
@@ -59,6 +60,7 @@ int ulogd_select_main()
 {
 	struct ulogd_fd *ufd;
 	fd_set readset, writeset, exceptset;
+	struct timeval tv = { .tv_sec = 1, };
 	int i;
 
 	FD_ZERO(&readset);
@@ -77,7 +79,13 @@ int ulogd_select_main()
 			FD_SET(ufd->fd, &exceptset);
 	}
 
-	i = select(maxfd+1, &readset, &writeset, &exceptset, NULL);
+ again:
+	i = select(maxfd+1, &readset, &writeset, &exceptset, &tv);
+	if (i < 0) {
+		if (errno == EINTR)
+			goto again;
+	}
+
 	if (i > 0) {
 		/* call registered callback functions */
 		llist_for_each_entry(ufd, &ulogd_fds, list) {
@@ -96,5 +104,6 @@ int ulogd_select_main()
 				ufd->cb(ufd->fd, flags, ufd->data);
 		}
 	}
+
 	return i;
 }
Index: ulogd-netfilter/src/ulogd.c
===================================================================
--- ulogd-netfilter.orig/src/ulogd.c
+++ ulogd-netfilter/src/ulogd.c
@@ -53,16 +53,19 @@
 #include <errno.h>
 #include <time.h>
 #include <ctype.h>
-#include <signal.h>
 #include <dlfcn.h>
 #include <sys/types.h>
 #include <dirent.h>
 #include <getopt.h>
 #include <pwd.h>
 #include <grp.h>
+#include <pthread.h>
 #include <syslog.h>
-#include <ulogd/conffile.h>
+
 #include <ulogd/ulogd.h>
+#include <ulogd/common.h>
+#include <ulogd/conffile.h>
+#include <ulogd/signal.h>
 #include <ulogd/ifi.h>
 
 
@@ -204,7 +207,6 @@ int ulogd_wildcard_inputkeys(struct ulog
 
 	/* second pass: copy key names */
 	llist_for_each_entry(pi_cur, &stack->list, list) {
-		struct ulogd_key *cur;
 		int i;
 
 		for (i = 0; i < pi_cur->plugin->output.num_keys; i++)
@@ -298,7 +300,7 @@ void __ulogd_log(int level, char *file, 
 		vsyslog(ulogd2syslog_level(level), format, ap);
 		va_end(ap);
 	} else {
-		if (logfile)
+  		if (logfile)
 			outfd = logfile;
 		else
 			outfd = stderr;
@@ -711,21 +713,22 @@ out_buf:
 
 static int ulogd_main_loop(void)
 {
+	sigset_t curr;
 	int ret = 0;
 
-	while (1) {
+	ulogd_get_sigset(&curr);
+
+	pthread_sigmask(SIG_UNBLOCK, &curr, NULL);
+
+	for (;;) {
 		ret = ulogd_select_main();
 		if (ret == 0) 
 			continue;
 
 		if (ret < 0) {
-			if (errno == -EINTR)
-				continue;
-			else {
-				ulogd_log(ULOGD_ERROR, "select returned %s\n",
+			ulogd_log(ULOGD_ERROR, "select returned %s\n",
 					  strerror(errno));
-				break;
-			}
+			break;
 		}
 	}
 
@@ -736,7 +739,7 @@ static int ulogd_main_loop(void)
 static int logfile_open(const char *name)
 {
 	if (name)
-		ulogd_logfile = name;
+		ulogd_logfile = (char *)name;
 
 	if (!strcmp(name, "stdout")) {
 		logfile = stdout;
@@ -794,54 +797,83 @@ static int parse_conffile(const char *se
 	return 1;
 }
 
-static void deliver_signal_pluginstances(int signal)
+static int
+for_each_pluginstance(int (* cb)(struct ulogd_pluginstance *,
+								 struct ulogd_pluginstance_stack *,
+								 void *), void *arg)
 {
 	struct ulogd_pluginstance_stack *stack;
-	struct ulogd_pluginstance *pi;
+	int sum = 0;
+
+	pr_debug("%s: cb=%p\n", __func__, cb);
 
 	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
+		struct ulogd_pluginstance *pi;
+
 		llist_for_each_entry(pi, &stack->list, list) {
-			if (pi->plugin->signal)
-				(*pi->plugin->signal)(pi, signal);
+			int ret;
+
+			if ((ret = cb(pi, stack, arg)) < 0)
+				return -1;
+
+			sum += ret;
 		}
 	}
+
+	return sum;
 }
 
-static void sigterm_handler(int signal)
+static int
+_do_signal(struct ulogd_pluginstance *pi,
+		   struct ulogd_pluginstance_stack *stack, void *arg)
 {
-	
-	ulogd_log(ULOGD_NOTICE, "sigterm received, exiting\n");
+	int signo = (int) arg;
 
-	deliver_signal_pluginstances(signal);
+	if (pi->plugin->signal) {
+		pi->plugin->signal(pi, signo);
 
-	if (logfile != stdout)
-		fclose(logfile);
+		return 1;
+	}
 
-	exit(0);
+	return 0;
 }
 
-static void signal_handler(int signal)
+static void
+sync_sig_handler(int signo)
 {
-	ulogd_log(ULOGD_NOTICE, "signal received, calling pluginstances\n");
-	
-	switch (signal) {
+	pr_debug("%s: signal '%d' received\n", __func__, signo);
+
+	switch (signo) {
 	case SIGHUP:
-		/* reopen logfile */
-		if (logfile != stdout && logfile != &syslog_dummy) {
-			fclose(logfile);
-			logfile = fopen(ulogd_logfile, "a");
-			if (!logfile)
-				sigterm_handler(signal);
-		}
 		break;
+
 	case SIGALRM:
-		ulogd_timer_check_n_run();
+		ulogd_timer_handle();
+		break;
+
+	case SIGTERM:
 		break;
+
 	default:
 		break;
 	}
 
-	deliver_signal_pluginstances(signal);
+	for_each_pluginstance(_do_signal, (void *) signo);
+}
+
+static void
+sig_handler(int signo)
+{
+	pr_debug("%s: signal '%d' received\n", __func__, signo);
+
+	switch (signo) {
+	case SIGINT:
+		exit(0);
+		break;
+
+	default:
+		break;
+	}
 }
 
 static void print_usage(void)
@@ -867,7 +899,8 @@ static struct option opts[] = {
 	{ 0 }
 };
 
-int main(int argc, char* argv[])
+int
+main(int argc, char* argv[])
 {
 	int argch;
 	int daemonize = 0;
@@ -922,6 +955,11 @@ int main(int argc, char* argv[])
 		}
 	}
 
+	if (ulogd_signal_init() < 0)
+		exit(EXIT_FAILURE);
+
+	ulogd_timer_init();
+
 	if (config_register_file(ulogd_configfile)) {
 		ulogd_log(ULOGD_FATAL, "error registering configfile \"%s\"\n",
 			  ulogd_configfile);
@@ -977,21 +1015,21 @@ int main(int argc, char* argv[])
 		setsid();
 	}
 
-	signal(SIGTERM, &sigterm_handler);
-	signal(SIGHUP, &signal_handler);
-	signal(SIGALRM, &signal_handler);
-	signal(SIGUSR1, &signal_handler);
-	signal(SIGUSR2, &signal_handler);
-
-	ulogd_log(ULOGD_INFO, 
-		  "initialization finished, entering main loop\n");
+	ulogd_register_signal(SIGTERM, sync_sig_handler, ULOGD_SIGF_SYNC);
+	ulogd_register_signal(SIGINT, sig_handler, 0);
+	ulogd_register_signal(SIGHUP, sync_sig_handler, ULOGD_SIGF_SYNC);
+	ulogd_register_signal(SIGALRM, sync_sig_handler, ULOGD_SIGF_SYNC);
+	ulogd_register_signal(SIGUSR1, sync_sig_handler, ULOGD_SIGF_SYNC);
+	ulogd_register_signal(SIGUSR2, sync_sig_handler, ULOGD_SIGF_SYNC);
 
 	if (ifi_init() < 0)
 		exit(EXIT_FAILURE);
 
+	ulogd_timer_run();
+
+	ulogd_log(ULOGD_INFO, "entering main loop\n");
+
 	ulogd_main_loop();
 
-	/* hackish, but result is the same */
-	sigterm_handler(SIGTERM);	
-	return(0);
+	return 0;
 }
Index: ulogd-netfilter/include/ulogd/signal.h
===================================================================
--- /dev/null
+++ ulogd-netfilter/include/ulogd/signal.h
@@ -0,0 +1,46 @@
+/*
+ * signal.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ *
+ * Holger Eitzenberger <holger@eitzenberger.org>  Astaro AG, 2007.
+ */
+#ifndef SIGNAL_H
+#define SIGNAL_H
+
+#include <signal.h>
+#include <ulogd/linuxlist.h>
+
+
+/* signal flags */
+#define ULOGD_SIGF_SYNC		0x00000001 /* signal is synchronous */
+
+
+struct ulogd_signal {
+	struct llist_head link;
+	int signo;
+	unsigned flags;
+	void (* handler)(int);
+};
+
+
+struct ulogd_signal *ulogd_register_signal(int, void (*)(int), unsigned);
+int ulogd_unregister_signal(struct ulogd_signal *);
+int ulogd_sigaddset(int);
+int ulogd_get_sigset(sigset_t *);
+int ulogd_deliver_signal(int signo);
+int ulogd_signal_init(void);
+
+#endif /* SIGNAL_H */
Index: ulogd-netfilter/src/signal.c
===================================================================
--- /dev/null
+++ ulogd-netfilter/src/signal.c
@@ -0,0 +1,193 @@
+/*
+ * signal.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Holger Eitzenberger <holger@eitzenberger.org  Astaro AG, 2007.
+ */
+#include <ulogd/ulogd.h>
+#include <ulogd/common.h>
+#include <ulogd/signal.h>
+#include <unistd.h>
+
+#define SIG_F_USED		0x00000001
+
+
+static struct sig_state {
+	struct llist_head head;
+	struct llist_head async_head;
+	unsigned flags;
+	unsigned cnt;
+} sig_state[NSIG];
+static sigset_t currset;
+static int sig_pipe[2] = { -1, -1 };
+static struct ulogd_fd sig_pipe_fd;
+
+
+static void
+sig_handler(int signo)
+{
+	struct ulogd_signal *sig;
+	sigset_t sigset;
+
+	assert(sig_pipe[1] >= 0);
+
+	pr_debug("%s: received signal '%d'\n", __func__, signo);
+
+	sigemptyset(&sigset);
+	sigaddset(&sigset, signo);
+
+	pthread_sigmask(SIG_BLOCK, &sigset, NULL);
+
+	llist_for_each_entry(sig, &sig_state[signo].async_head, link)
+		sig->handler(signo);
+
+	pthread_sigmask(SIG_UNBLOCK, &sigset, NULL);
+
+	if (!llist_empty(&sig_state[signo].head))
+		write(sig_pipe[1], &signo, sizeof(signo));
+}
+
+struct ulogd_signal *
+ulogd_register_signal(int signo, void (* sigh)(int), unsigned flags)
+{
+	struct ulogd_signal *sig;
+
+	if (signo < 0 || signo > NSIG || sigh == NULL)
+		return NULL;
+
+	/* TODO check signo for values which may not be used synchronous */
+
+	pr_debug("%s: registering handler %p for signal '%d'\n", __func__,
+			 sigh, signo);
+
+	if ((sig = calloc(1, sizeof(struct ulogd_signal))) == NULL)
+		return NULL;
+
+	sig->signo = signo;
+	sig->flags = flags;
+	sig->handler = sigh;
+
+	sig_state[signo].cnt++;
+
+	/* add real signal handler */
+	if ((sig_state[signo].flags & SIG_F_USED) == 0) {
+		signal(signo, sig_handler);
+
+		sig_state[signo].flags |= SIG_F_USED;
+	}
+
+	if (flags & ULOGD_SIGF_SYNC)
+		llist_add_tail(&sig->link, &sig_state[signo].head);
+	else
+		llist_add_tail(&sig->link, &sig_state[signo].async_head);
+
+	ulogd_sigaddset(signo);
+
+	return sig;
+}
+
+int
+ulogd_unregister_signal(struct ulogd_signal *sig)
+{
+	if (sig == NULL || sig->signo < 0 || sig->signo >= NSIG)
+		return -1;
+
+	pr_debug("%s: unregistering handler %p\n", __func__, sig);
+
+	if (--sig_state[sig->signo].cnt == 0)
+		signal(sig->signo, SIG_DFL);
+
+	llist_del(&sig->link);
+
+	free(sig);
+
+	return 0;
+}
+
+int
+ulogd_sigaddset(int signo)
+{
+	return sigaddset(&currset, signo);
+}
+
+int
+ulogd_get_sigset(sigset_t *sigset)
+{
+	assert(sigset != NULL);
+
+	memcpy(sigset, &currset, sizeof(sigset_t));
+
+	return 0;
+}
+
+static int
+sig_pipe_cb(int fd, unsigned what, void *arg)
+{
+	struct ulogd_signal *sig;
+	sigset_t sigset;
+	int signo, nbytes;
+
+	assert(what == ULOGD_FD_READ);
+
+	nbytes = read(fd, &signo, sizeof(signo));
+
+	pr_debug("%s: signo=%d\n", __func__, signo);
+
+	assert(nbytes == sizeof(signo));
+
+	if (signo < 0 || signo > NSIG)
+		abort();
+
+	sigemptyset(&sigset);
+	sigaddset(&sigset, signo);
+
+	pthread_sigmask(SIG_BLOCK, &sigset, NULL);
+
+	llist_for_each_entry(sig, &sig_state[signo].head, link)
+		sig->handler(signo);
+
+	pthread_sigmask(SIG_UNBLOCK, &sigset, NULL);
+
+	return 0;
+}
+
+int
+ulogd_signal_init(void)
+{
+	int i;
+	sigset_t fullset;
+
+	sigfillset(&fullset);
+	pthread_sigmask(SIG_SETMASK, &fullset, NULL);
+
+	sigemptyset(&currset);
+
+	for (i = 0; i < NSIG; i++) {
+		INIT_LLIST_HEAD(&sig_state[i].head);
+		INIT_LLIST_HEAD(&sig_state[i].async_head);
+	}
+
+	/* init signal pipe */
+	if (pipe(sig_pipe) < 0) {
+		ulogd_log(ULOGD_FATAL, "unable to initialize signal pipe\n");
+		return -1;
+	}
+
+	sig_pipe_fd.fd = sig_pipe[0];
+	sig_pipe_fd.cb = sig_pipe_cb;
+	sig_pipe_fd.when = ULOGD_FD_READ;
+
+	return ulogd_register_fd(&sig_pipe_fd);
+}

-- 
