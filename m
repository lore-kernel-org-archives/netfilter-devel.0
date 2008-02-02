From: heitzenberger@astaro.com
Subject: [ULOGD 10/15] Improve select performance
Date: Sat, 02 Feb 2008 21:48:36 +0100
Message-ID: <20080202205108.605422040@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-1.dex002.intermedia.net ([64.78.21.6]:39951 "EHLO
	dhost002-1.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932076AbYBBUvY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-select-performance-improvement.diff

The previous code consumed quite lots of CPU cycles because of 
inefficiently handling fd_sets.

This patch corrects that.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/src/select.c
===================================================================
--- ulogd-netfilter.orig/src/select.c
+++ ulogd-netfilter/src/select.c
@@ -24,86 +24,125 @@
 #include <fcntl.h>
 #include <ulogd/ulogd.h>
 #include <ulogd/common.h>
+#include <ulogd/signal.h>
 #include <ulogd/linuxlist.h>
 
-static int maxfd = 0;
+static fd_set readset, writeset, exceptset;
+static int maxfd = -1;
 static LLIST_HEAD(ulogd_fds);
 
-int ulogd_register_fd(struct ulogd_fd *fd)
+
+static int
+set_nonblock(int fd)
 {
 	int flags;
 
-	/* make FD nonblocking */
-	flags = fcntl(fd->fd, F_GETFL);
-	if (flags < 0)
+	if ((flags = fcntl(fd, F_GETFL)) < 0)
 		return -1;
+
 	flags |= O_NONBLOCK;
-	flags = fcntl(fd->fd, F_SETFL, flags);
-	if (flags < 0)
+
+	if ((flags = fcntl(fd, F_SETFL, flags)) < 0)
+		return -1;
+
+	return 0;
+}
+
+int
+ulogd_register_fd(struct ulogd_fd *ufd)
+{
+	if (set_nonblock(ufd->fd) < 0)
 		return -1;
 
-	/* Register FD */
-	if (fd->fd > maxfd)
-		maxfd = fd->fd;
+	if (ufd->when & ULOGD_FD_READ)
+		FD_SET(ufd->fd, &readset);
+	
+	if (ufd->when & ULOGD_FD_WRITE)
+		FD_SET(ufd->fd, &writeset);
+	
+	if (ufd->when & ULOGD_FD_EXCEPT)
+		FD_SET(ufd->fd, &exceptset);
+
+	if (ufd->fd > maxfd)
+		maxfd = ufd->fd;
 
-	llist_add_tail(&fd->list, &ulogd_fds);
+	llist_add_tail(&ufd->list, &ulogd_fds);
 
 	return 0;
 }
 
-void ulogd_unregister_fd(struct ulogd_fd *fd)
+void
+ulogd_unregister_fd(struct ulogd_fd *ufd)
 {
-	llist_del(&fd->list);
+	if (ufd->when & ULOGD_FD_READ)
+		FD_CLR(ufd->fd, &readset);
+	
+	if (ufd->when & ULOGD_FD_WRITE)
+		FD_CLR(ufd->fd, &writeset);
+	
+	if (ufd->when & ULOGD_FD_EXCEPT)
+		FD_CLR(ufd->fd, &exceptset);
+
+	llist_del(&ufd->list);
+
+	maxfd = -1;
+	llist_for_each_entry(ufd, &ulogd_fds, list) {
+		assert(ufd->fd >= 0);
+
+		if (ufd->fd > maxfd)
+			maxfd = ufd->fd;
+	}
 }
 
-int ulogd_select_main()
+/* ulogd_dispatch() - dispatch events */
+int
+ulogd_dispatch(void)
 {
-	struct ulogd_fd *ufd;
-	fd_set readset, writeset, exceptset;
-	struct timeval tv = { .tv_sec = 1, };
-	int i;
-
-	FD_ZERO(&readset);
-	FD_ZERO(&writeset);
-	FD_ZERO(&exceptset);
+	fd_set rds_tmp, wrs_tmp, exs_tmp;
+	sigset_t curr_ss;
 
-	/* prepare read and write fdsets */
-	llist_for_each_entry(ufd, &ulogd_fds, list) {
-		if (ufd->when & ULOGD_FD_READ)
-			FD_SET(ufd->fd, &readset);
+	ulogd_get_sigset(&curr_ss);
 
-		if (ufd->when & ULOGD_FD_WRITE)
-			FD_SET(ufd->fd, &writeset);
+	pthread_sigmask(SIG_UNBLOCK, &curr_ss, NULL);
 
-		if (ufd->when & ULOGD_FD_EXCEPT)
-			FD_SET(ufd->fd, &exceptset);
-	}
+	for (;;) {
+		struct ulogd_fd *ufd;
+		int n;
 
- again:
-	i = select(maxfd+1, &readset, &writeset, &exceptset, &tv);
-	if (i < 0) {
-		if (errno == EINTR)
-			goto again;
-	}
+	again:
+		rds_tmp = readset;
+		wrs_tmp = writeset;
+		exs_tmp = exceptset;
 
-	if (i > 0) {
-		/* call registered callback functions */
-		llist_for_each_entry(ufd, &ulogd_fds, list) {
-			int flags = 0;
-
-			if (FD_ISSET(ufd->fd, &readset))
-				flags |= ULOGD_FD_READ;
+		n = select(maxfd+1, &rds_tmp, &wrs_tmp, &exs_tmp, NULL);
+		if (n < 0) {
+			if (errno == EINTR)
+				goto again;
 
-			if (FD_ISSET(ufd->fd, &writeset))
-				flags |= ULOGD_FD_WRITE;
+			ulogd_log(ULOGD_FATAL, "select: %m\n");
 
-			if (FD_ISSET(ufd->fd, &exceptset))
-				flags |= ULOGD_FD_EXCEPT;
+			break;
+		}
 
-			if (flags)
-				ufd->cb(ufd->fd, flags, ufd->data);
+		if (n > 0) {
+			/* call registered callback functions */
+			llist_for_each_entry(ufd, &ulogd_fds, list) {
+				int flags = 0;
+
+				if (FD_ISSET(ufd->fd, &rds_tmp))
+					flags |= ULOGD_FD_READ;
+
+				if (FD_ISSET(ufd->fd, &wrs_tmp))
+					flags |= ULOGD_FD_WRITE;
+
+				if (FD_ISSET(ufd->fd, &exs_tmp))
+					flags |= ULOGD_FD_EXCEPT;
+
+				if (flags)
+					ufd->cb(ufd->fd, flags, ufd->data);
+			}
 		}
 	}
 
-	return i;
+	return 0;
 }
Index: ulogd-netfilter/src/ulogd.c
===================================================================
--- ulogd-netfilter.orig/src/ulogd.c
+++ ulogd-netfilter/src/ulogd.c
@@ -727,32 +727,6 @@ out_buf:
 	return ret;
 }
 	
-
-static int ulogd_main_loop(void)
-{
-	sigset_t curr;
-	int ret = 0;
-
-	ulogd_get_sigset(&curr);
-
-	pthread_sigmask(SIG_UNBLOCK, &curr, NULL);
-
-	for (;;) {
-		ret = ulogd_select_main();
-		if (ret == 0) 
-			continue;
-
-		if (ret < 0) {
-			ulogd_log(ULOGD_ERROR, "select returned %s\n",
-					  strerror(errno));
-			break;
-		}
-	}
-
-	return ret;
-}
-
-/* open the logfile */
 static int logfile_open(const char *name)
 {
 	if (name)
@@ -1112,7 +1086,7 @@ main(int argc, char* argv[])
 
 	ulogd_log(ULOGD_INFO, "entering main loop\n");
 
-	ulogd_main_loop();
+	ulogd_dispatch();
 
 	return 0;
 }
Index: ulogd-netfilter/include/ulogd/ulogd.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/ulogd.h
+++ ulogd-netfilter/include/ulogd/ulogd.h
@@ -243,7 +243,7 @@ struct ulogd_fd {
 
 int ulogd_register_fd(struct ulogd_fd *ufd);
 void ulogd_unregister_fd(struct ulogd_fd *ufd);
-int ulogd_select_main();
+int ulogd_dispatch(void);
 
 /***********************************************************************
  * timer handling (timer.c)

-- 
