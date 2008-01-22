From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 03/11] moved process function pointer to
	struct local_server
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.17154.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50935 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760056AbYAVOKG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:10:06 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/local.h |   10 +++++++---
 src/local.c     |   11 +++++++----
 src/run.c       |    5 +++--
 3 files changed, 17 insertions(+), 9 deletions(-)


diff --git a/include/local.h b/include/local.h
index 55bceba..c9a57b8 100644
--- a/include/local.h
+++ b/include/local.h
@@ -14,13 +14,17 @@ struct local_conf {
 struct local_server {
 	int fd;
 	const char *path;
+
+	void *data;
+	void (*process)(int fd, void *data);
 };
 
 /* local server */
-int local_server_create(struct local_server *server, struct local_conf *conf);
+int local_server_create(struct local_server *server, struct local_conf *conf,
+			void *data,
+			void (*process)(int fd, void *data));
 void local_server_destroy(struct local_server *server);
-int do_local_server_step(struct local_server *server, void *data, 
-			 void (*process)(int fd, void *data));
+int do_local_server_step(struct local_server *server);
 
 /* local client */
 int local_client_create(struct local_conf *conf);
diff --git a/src/local.c b/src/local.c
index 6067880..7aab151 100644
--- a/src/local.c
+++ b/src/local.c
@@ -26,7 +26,9 @@
 #include <arpa/inet.h>
 #include <sys/un.h>
 
-int local_server_create(struct local_server *server, struct local_conf *conf)
+int local_server_create(struct local_server *server, struct local_conf *conf,
+			void *data,
+			void (*process)(int fd, void *data))
 {
 	int fd;
 	int len;
@@ -61,6 +63,8 @@ int local_server_create(struct local_server *server, struct local_conf *conf)
 
 	server->fd = fd;
 	server->path = conf->path;
+	server->data = data;
+	server->process = process;
 
 	return 0;
 }
@@ -71,8 +75,7 @@ void local_server_destroy(struct local_server *server)
 	close(server->fd);
 }
 
-int do_local_server_step(struct local_server *server, void *data, 
-			 void (*process)(int fd, void *data))
+int do_local_server_step(struct local_server *server)
 {
 	int rfd;
 	struct sockaddr_un local;
@@ -81,7 +84,7 @@ int do_local_server_step(struct local_server *server, void *data,
 	if ((rfd = accept(server->fd, (struct sockaddr *)&local, &sin_size)) == -1)
 		return -1;
 
-	process(rfd, data);
+	server->process(rfd, server->data);
 	close(rfd);
 
 	return 0;
diff --git a/src/run.c b/src/run.c
index 40dc2d4..fcba393 100644
--- a/src/run.c
+++ b/src/run.c
@@ -117,7 +117,8 @@ init(void)
 	}
 
 	/* local UNIX socket */
-	ret = local_server_create(&STATE(local), &CONFIG(local));
+	ret = local_server_create(&STATE(local), &CONFIG(local),
+				  NULL, local_handler);
 	if (ret == -1) {
 		dlog(LOG_ERR, "can't open unix socket!");
 		return -1;
@@ -190,7 +191,7 @@ static void __run(struct timeval *next_alarm)
 
 	/* order received via UNIX socket */
 	if (FD_ISSET(STATE(local).fd, &readfds))
-		do_local_server_step(&STATE(local), NULL, local_handler);
+		do_local_server_step(&STATE(local));
 
 	/* conntrack event has happened */
 	if (FD_ISSET(nfct_fd(STATE(event)), &readfds)) {


