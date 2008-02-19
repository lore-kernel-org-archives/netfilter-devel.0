From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD 10/15] Improve select performance
Date: Tue, 19 Feb 2008 20:58:00 +0100
Message-ID: <47BB34C8.9080902@netfilter.org>
References: <20080202204826.267107164@astaro.com> <20080202205108.605422040@astaro.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060209050509000101000907"
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37477 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754864AbYBST6G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:58:06 -0500
In-Reply-To: <20080202205108.605422040@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060209050509000101000907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

heitzenberger@astaro.com wrote:
> The previous code consumed quite lots of CPU cycles because of 
> inefficiently handling fd_sets.

I have applied the following patch which is based on your improvement.

I'll check the other patches that are targeted to make plugins
reconfigurable as soon as I have some spare time, whatever help in the
merge process with current SVN would be appreciated and would surely
speed up the development. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------060209050509000101000907
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: src/select.c
===================================================================
--- src/select.c	(revisión: 7377)
+++ src/select.c	(copia de trabajo)
@@ -26,6 +26,7 @@
 #include <ulogd/linuxlist.h>
 
 static int maxfd = 0;
+static fd_set readset, writeset, exceptset;
 static LLIST_HEAD(ulogd_fds);
 
 int ulogd_register_fd(struct ulogd_fd *fd)
@@ -41,6 +42,15 @@
 	if (flags < 0)
 		return -1;
 
+	if (fd->when & ULOGD_FD_READ)
+		FD_SET(fd->fd, &readset);
+
+	if (fd->when & ULOGD_FD_WRITE)
+		FD_SET(fd->fd, &writeset);
+
+	if (fd->when & ULOGD_FD_EXCEPT)
+		FD_SET(fd->fd, &exceptset);
+
 	/* Register FD */
 	if (fd->fd > maxfd)
 		maxfd = fd->fd;
@@ -52,44 +62,48 @@
 
 void ulogd_unregister_fd(struct ulogd_fd *fd)
 {
+	if (fd->when & ULOGD_FD_READ)
+		FD_CLR(fd->fd, &readset);
+
+	if (fd->when & ULOGD_FD_WRITE)
+		FD_CLR(fd->fd, &writeset);
+
+	if (fd->when & ULOGD_FD_EXCEPT)
+		FD_CLR(fd->fd, &exceptset);
+
 	llist_del(&fd->list);
+
+	/* Improvement: recalculate maxfd iif fd->fd == maxfd */
+	maxfd = -1;
+	llist_for_each_entry(fd, &ulogd_fds, list) {
+		if (fd->fd > maxfd)
+			maxfd = fd->fd;
+	}
 }
 
 int ulogd_select_main(struct timeval *tv)
 {
 	struct ulogd_fd *ufd;
-	fd_set readset, writeset, exceptset;
+	fd_set rds_tmp, wrs_tmp, exs_tmp;
 	int i;
 
-	FD_ZERO(&readset);
-	FD_ZERO(&writeset);
-	FD_ZERO(&exceptset);
+	rds_tmp = readset;
+	wrs_tmp = writeset;
+	exs_tmp = exceptset;
 
-	/* prepare read and write fdsets */
-	llist_for_each_entry(ufd, &ulogd_fds, list) {
-		if (ufd->when & ULOGD_FD_READ)
-			FD_SET(ufd->fd, &readset);
-
-		if (ufd->when & ULOGD_FD_WRITE)
-			FD_SET(ufd->fd, &writeset);
-
-		if (ufd->when & ULOGD_FD_EXCEPT)
-			FD_SET(ufd->fd, &exceptset);
-	}
-
-	i = select(maxfd+1, &readset, &writeset, &exceptset, tv);
+	i = select(maxfd+1, &rds_tmp, &wrs_tmp, &exs_tmp, tv);
 	if (i > 0) {
 		/* call registered callback functions */
 		llist_for_each_entry(ufd, &ulogd_fds, list) {
 			int flags = 0;
 
-			if (FD_ISSET(ufd->fd, &readset))
+			if (FD_ISSET(ufd->fd, &rds_tmp))
 				flags |= ULOGD_FD_READ;
 
-			if (FD_ISSET(ufd->fd, &writeset))
+			if (FD_ISSET(ufd->fd, &wrs_tmp))
 				flags |= ULOGD_FD_WRITE;
 
-			if (FD_ISSET(ufd->fd, &exceptset))
+			if (FD_ISSET(ufd->fd, &exs_tmp))
 				flags |= ULOGD_FD_EXCEPT;
 
 			if (flags)

--------------060209050509000101000907--
