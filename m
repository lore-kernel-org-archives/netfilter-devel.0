From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 02/11] added struct local_server
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.5800.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50930 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753811AbYAVOJL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:09:11 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/conntrackd.h |    2 +-
 include/local.h      |   11 ++++++++---
 src/local.c          |   17 ++++++++++-------
 src/run.c            |   16 +++++++++-------
 4 files changed, 28 insertions(+), 18 deletions(-)


diff --git a/include/conntrackd.h b/include/conntrackd.h
index b223a17..47898e2 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -98,7 +98,7 @@ struct ct_general_state {
 	sigset_t 			block;
 	FILE 				*log;
 	FILE				*stats_log;
-	int 				local;
+	struct local_server		local;
 	struct ct_mode 			*mode;
 	struct ignore_pool		*ignore_pool;
 
diff --git a/include/local.h b/include/local.h
index be77d35..55bceba 100644
--- a/include/local.h
+++ b/include/local.h
@@ -11,10 +11,15 @@ struct local_conf {
 	char path[UNIX_PATH_MAX];
 };
 
+struct local_server {
+	int fd;
+	const char *path;
+};
+
 /* local server */
-int local_server_create(struct local_conf *conf);
-void local_server_destroy(int fd, const char *);
-int do_local_server_step(int fd, void *data, 
+int local_server_create(struct local_server *server, struct local_conf *conf);
+void local_server_destroy(struct local_server *server);
+int do_local_server_step(struct local_server *server, void *data, 
 			 void (*process)(int fd, void *data));
 
 /* local client */
diff --git a/src/local.c b/src/local.c
index f0aba1c..6067880 100644
--- a/src/local.c
+++ b/src/local.c
@@ -26,7 +26,7 @@
 #include <arpa/inet.h>
 #include <sys/un.h>
 
-int local_server_create(struct local_conf *conf)
+int local_server_create(struct local_server *server, struct local_conf *conf)
 {
 	int fd;
 	int len;
@@ -59,23 +59,26 @@ int local_server_create(struct local_conf *conf)
 		return -1;
 	}
 
-	return fd;
+	server->fd = fd;
+	server->path = conf->path;
+
+	return 0;
 }
 
-void local_server_destroy(int fd, const char *path)
+void local_server_destroy(struct local_server *server)
 {
-	unlink(path);
-	close(fd);
+	unlink(server->path);
+	close(server->fd);
 }
 
-int do_local_server_step(int fd, void *data, 
+int do_local_server_step(struct local_server *server, void *data, 
 			 void (*process)(int fd, void *data))
 {
 	int rfd;
 	struct sockaddr_un local;
 	socklen_t sin_size = sizeof(struct sockaddr_un);
 	
-	if ((rfd = accept(fd, (struct sockaddr *)&local, &sin_size)) == -1)
+	if ((rfd = accept(server->fd, (struct sockaddr *)&local, &sin_size)) == -1)
 		return -1;
 
 	process(rfd, data);
diff --git a/src/run.c b/src/run.c
index bdf6b0b..40dc2d4 100644
--- a/src/run.c
+++ b/src/run.c
@@ -40,7 +40,7 @@ void killer(int foo)
 	nfct_close(STATE(dump));
 
 	ignore_pool_destroy(STATE(ignore_pool));
-	local_server_destroy(STATE(local), CONFIG(local).path);
+	local_server_destroy(&STATE(local));
 	STATE(mode)->kill();
 	destroy_alarm_hash();
 	unlink(CONFIG(lockfile));
@@ -92,6 +92,8 @@ void local_handler(int fd, void *data)
 int
 init(void)
 {
+	int ret;
+
 	if (CONFIG(flags) & CTD_STATS_MODE)
 		STATE(mode) = &stats_mode;
 	else if (CONFIG(flags) & CTD_SYNC_MODE)
@@ -115,8 +117,8 @@ init(void)
 	}
 
 	/* local UNIX socket */
-	STATE(local) = local_server_create(&CONFIG(local));
-	if (STATE(local) == -1) {
+	ret = local_server_create(&STATE(local), &CONFIG(local));
+	if (ret == -1) {
 		dlog(LOG_ERR, "can't open unix socket!");
 		return -1;
 	}
@@ -165,10 +167,10 @@ static void __run(struct timeval *next_alarm)
 	fd_set readfds;
 
 	FD_ZERO(&readfds);
-	FD_SET(STATE(local), &readfds);
+	FD_SET(STATE(local).fd, &readfds);
 	FD_SET(nfct_fd(STATE(event)), &readfds);
 
-	max = MAX(STATE(local), nfct_fd(STATE(event)));
+	max = MAX(STATE(local).fd, nfct_fd(STATE(event)));
 
 	if (STATE(mode)->add_fds_to_set)
 		max = MAX(max, STATE(mode)->add_fds_to_set(&readfds));
@@ -187,8 +189,8 @@ static void __run(struct timeval *next_alarm)
 	sigprocmask(SIG_BLOCK, &STATE(block), NULL);		
 
 	/* order received via UNIX socket */
-	if (FD_ISSET(STATE(local), &readfds))
-		do_local_server_step(STATE(local), NULL, local_handler);
+	if (FD_ISSET(STATE(local).fd, &readfds))
+		do_local_server_step(&STATE(local), NULL, local_handler);
 
 	/* conntrack event has happened */
 	if (FD_ISSET(nfct_fd(STATE(event)), &readfds)) {


