From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 10/11] use libevent
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.31445.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50257 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751888AbYAVORH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:17:07 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 include/alarm.h      |   18 +----
 include/conntrackd.h |    4 -
 include/local.h      |    5 +
 include/mcast.h      |    5 +
 src/Makefile.am      |    2 -
 src/alarm.c          |  173 +++++---------------------------------------------
 src/local.c          |   16 +++--
 src/main.c           |   12 +++
 src/mcast.c          |   19 +++++
 src/run.c            |  167 ++++++++++++++++++------------------------------
 src/stats-mode.c     |    1 
 src/sync-mode.c      |   14 ----
 12 files changed, 135 insertions(+), 301 deletions(-)


diff --git a/include/alarm.h b/include/alarm.h
index e791057..5b59994 100644
--- a/include/alarm.h
+++ b/include/alarm.h
@@ -1,21 +1,15 @@
 #ifndef _TIMER_H_
 #define _TIMER_H_
 
-#include "linux_list.h"
-
-#include <sys/time.h>
+#include <sys/types.h>
+#include <event.h>
 
 struct alarm_list {
-	struct list_head	head;
-	struct timeval		tv;
+	struct event event;
 	void			*data;
 	void			(*function)(struct alarm_list *a, void *data);
 };
 
-int init_alarm_hash(void);
-
-void destroy_alarm_hash(void);
-
 void init_alarm(struct alarm_list *t,
 		void *data,
 		void (*fcn)(struct alarm_list *a, void *data));
@@ -26,10 +20,4 @@ void del_alarm(struct alarm_list *alarm);
 
 int alarm_pending(struct alarm_list *alarm, struct timeval *tv);
 
-struct timeval *
-get_next_alarm_run(struct timeval *next_alarm);
-
-struct timeval *
-do_alarm_run(struct timeval *next_alarm);
-
 #endif
diff --git a/include/conntrackd.h b/include/conntrackd.h
index 47898e2..beeea9e 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -95,7 +95,6 @@ struct ct_conf {
 #define STATE(x) st.x
 
 struct ct_general_state {
-	sigset_t 			block;
 	FILE 				*log;
 	FILE				*stats_log;
 	struct local_server		local;
@@ -151,8 +150,7 @@ extern struct ct_general_state st;
 
 struct ct_mode {
 	int (*init)(void);
-	int (*add_fds_to_set)(fd_set *readfds);
-	void (*run)(fd_set *readfds);
+	void (*run)(void);
 	int (*local)(int fd, int type, void *data);
 	void (*kill)(void);
 	void (*dump)(struct nf_conntrack *ct);
diff --git a/include/local.h b/include/local.h
index c9a57b8..65346f4 100644
--- a/include/local.h
+++ b/include/local.h
@@ -1,6 +1,9 @@
 #ifndef _LOCAL_SOCKET_H_
 #define _LOCAL_SOCKET_H_
 
+#include <sys/types.h>
+#include <event.h>
+
 #ifndef UNIX_PATH_MAX
 #define UNIX_PATH_MAX   108
 #endif
@@ -13,6 +16,7 @@ struct local_conf {
 
 struct local_server {
 	int fd;
+	struct event event;
 	const char *path;
 
 	void *data;
@@ -24,7 +28,6 @@ int local_server_create(struct local_server *server, struct local_conf *conf,
 			void *data,
 			void (*process)(int fd, void *data));
 void local_server_destroy(struct local_server *server);
-int do_local_server_step(struct local_server *server);
 
 /* local client */
 int local_client_create(struct local_conf *conf);
diff --git a/include/mcast.h b/include/mcast.h
index 4d4124f..cd0324b 100644
--- a/include/mcast.h
+++ b/include/mcast.h
@@ -4,6 +4,8 @@
 #include <stdint.h>
 #include <netinet/in.h>
 #include <net/if.h>
+#include <sys/types.h>
+#include <event.h>
 
 struct nethdr;
 
@@ -32,6 +34,7 @@ struct mcast_stats {
 
 struct mcast_sock {
 	int fd;
+	struct event event;
 	union {
 		struct sockaddr_in ipv4;
 		struct sockaddr_in6 ipv6;
@@ -53,8 +56,6 @@ void mcast_client_destroy(struct mcast_sock *m);
 ssize_t mcast_send(struct mcast_sock *m, void *data, int size);
 ssize_t mcast_recv(struct mcast_sock *m, void *data, int size);
 
-int mcast_run(struct mcast_sock *m);
-
 struct mcast_stats *mcast_get_stats(struct mcast_sock *m);
 void mcast_dump_stats(int fd, struct mcast_sock *s, struct mcast_sock *r);
 
diff --git a/src/Makefile.am b/src/Makefile.am
index 15628b7..d71cd55 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -25,6 +25,6 @@ conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c \
 # yacc and lex generate dirty code
 read_config_yy.o read_config_lex.o: AM_CFLAGS += -Wno-missing-prototypes -Wno-missing-declarations -Wno-implicit-function-declaration -Wno-nested-externs -Wno-undef -Wno-redundant-decls
 
-conntrackd_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
+conntrackd_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@ -levent
 
 EXTRA_DIST = read_config_yy.h
diff --git a/src/alarm.c b/src/alarm.c
index 7cbae10..b0fd28f 100644
--- a/src/alarm.c
+++ b/src/alarm.c
@@ -17,185 +17,44 @@
  */
 
 #include "alarm.h"
-#include "jhash.h"
+
 #include <stdlib.h>
-#include <limits.h>
 
-#define ALARM_HASH_SIZE		2048
+static void
+alarm_event_callback(int fd, short event, void *ctx)
+{
+	struct alarm_list *alarm = ctx;
 
-static struct list_head *alarm_hash;
+	alarm->function(alarm, alarm->data);
+}
 
 void init_alarm(struct alarm_list *t,
 		void *data,
 		void (*fcn)(struct alarm_list *a, void *data))
 {
-	/* initialize the head to check whether a node is inserted */
-	INIT_LIST_HEAD(&t->head);
-	timerclear(&t->tv);
+	evtimer_set(&t->event, alarm_event_callback, t);
 	t->data = data;
 	t->function = fcn;
 }
 
-static void
-__add_alarm(struct alarm_list *alarm)
-{
-	struct alarm_list *t;
-	int i = jhash(alarm, sizeof(alarm), 0) % ALARM_HASH_SIZE;
-
-	list_for_each_entry(t, &alarm_hash[i], head) {
-		if (timercmp(&alarm->tv, &t->tv, <)) {
-			list_add_tail(&alarm->head, &t->head);
-			return;
-		}
-	}
-	list_add_tail(&alarm->head, &alarm_hash[i]);
-}
-
 void add_alarm(struct alarm_list *alarm, unsigned long sc, unsigned long usc)
 {
 	struct timeval tv;
 
-	del_alarm(alarm);
-	alarm->tv.tv_sec = sc;
-	alarm->tv.tv_usec = usc;
-	gettimeofday(&tv, NULL);
-	timeradd(&alarm->tv, &tv, &alarm->tv);
-	__add_alarm(alarm);
-}
-
-void del_alarm(struct alarm_list *alarm)
-{
-	/* don't remove a non-inserted node */
-	if (!list_empty(&alarm->head))
-		list_del_init(&alarm->head);
-}
-
-int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
-{
-	if (list_empty(&alarm->head))
-		return 0;
-
-	if (tv != NULL)
-		*tv = alarm->tv;
-	return 1;
-}
-
-static struct timeval *
-calculate_next_run(struct timeval *cand,
-		   struct timeval *tv, 
-		   struct timeval *next_run)
-{
-	if (cand->tv_sec != LONG_MAX) {
-		if (timercmp(cand, tv, >))
-			timersub(cand, tv, next_run);
-		else {
-			/* loop again inmediately */
-			next_run->tv_sec = 0;
-			next_run->tv_usec = 0;
-		}
-		return next_run;
-	}
-	return NULL;
-}
-
-struct timeval *
-get_next_alarm_run(struct timeval *next_run)
-{
-	int i;
-	struct alarm_list *t;
-	struct timeval tv;
-	struct timeval cand = {
-		.tv_sec = LONG_MAX,
-		.tv_usec = LONG_MAX
-	};
-
-	gettimeofday(&tv, NULL);
-
-	for (i=0; i<ALARM_HASH_SIZE; i++) {
-		if (!list_empty(&alarm_hash[i])) {
-			t = list_entry(alarm_hash[i].next, 
-				       struct alarm_list,
-				       head);
-			if (timercmp(&t->tv, &cand, <)) {
-				cand.tv_sec = t->tv.tv_sec;
-				cand.tv_usec = t->tv.tv_usec;
-			}
-		}
-	}
-
-	return calculate_next_run(&cand, &tv, next_run);
-}
-
-static inline int 
-tv_compare(struct alarm_list *a, struct timeval *cur, struct timeval *cand)
-{
-	if (timercmp(&a->tv, cur, >)) {
-		/* select the next alarm candidate */
-		if (timercmp(&a->tv, cand, <)) {
-			cand->tv_sec = a->tv.tv_sec;
-			cand->tv_usec = a->tv.tv_usec;
-		}
-		return 1;
-	}
-	return 0;
-}
-
-struct timeval *
-do_alarm_run(struct timeval *next_run)
-{
-	int i;
-	struct alarm_list *t, *next, *prev;
-	struct timeval tv;
-	struct timeval cand = {
-		.tv_sec = LONG_MAX,
-		.tv_usec = LONG_MAX
-	};
-
-	gettimeofday(&tv, NULL);
-
-	for (i=0; i<ALARM_HASH_SIZE; i++) {
-		list_for_each_entry_safe(t, next, &alarm_hash[i], head) {
-			if (tv_compare(t, &tv, &cand))
-				break;
-
-			/* annotate previous alarm */
-			prev = list_entry(next->head.prev,
-					  struct alarm_list,
-					  head);
-
-			del_alarm(t);
-			t->function(t, t->data);
+	evtimer_del(&alarm->event);
 
-			/* Special case: One deleted node is inserted 
-			 * again in the same place */
-			if (next->head.prev == &prev->head) {
-				t = list_entry(next->head.prev,
-					       struct alarm_list,
-					       head);
-				if (tv_compare(t, &tv, &cand))
-					break;
-			}
-		}
-	}
+	tv.tv_sec = sc;
+	tv.tv_usec = usc;
 
-	return calculate_next_run(&cand, &tv, next_run);
+	evtimer_add(&alarm->event, &tv);
 }
 
-int init_alarm_hash(void)
+void del_alarm(struct alarm_list *alarm)
 {
-	int i;
-
-	alarm_hash = malloc(sizeof(struct list_head) * ALARM_HASH_SIZE);
-	if (alarm_hash == NULL)
-		return -1;
-
-	for (i=0; i<ALARM_HASH_SIZE; i++)
-		INIT_LIST_HEAD(&alarm_hash[i]);
-
-	return 0;
+	evtimer_del(&alarm->event);
 }
 
-void destroy_alarm_hash(void)
+int alarm_pending(struct alarm_list *alarm, struct timeval *tv)
 {
-	free(alarm_hash);
+	return evtimer_pending(&alarm->event, tv) != 0;
 }
diff --git a/src/local.c b/src/local.c
index f054c0a..7bec5ab 100644
--- a/src/local.c
+++ b/src/local.c
@@ -26,6 +26,9 @@
 #include <arpa/inet.h>
 #include <sys/un.h>
 
+static void
+local_server_event_callback(int fd, short event, void *ctx);
+
 int local_server_create(struct local_server *server, struct local_conf *conf,
 			void *data,
 			void (*process)(int fd, void *data))
@@ -66,28 +69,33 @@ int local_server_create(struct local_server *server, struct local_conf *conf,
 	server->data = data;
 	server->process = process;
 
+	event_set(&server->event, server->fd,
+		  EV_READ|EV_PERSIST, local_server_event_callback, server);
+	event_add(&server->event, NULL);
+
 	return 0;
 }
 
 void local_server_destroy(struct local_server *server)
 {
 	unlink(server->path);
+	event_del(&server->event);
 	close(server->fd);
 }
 
-int do_local_server_step(struct local_server *server)
+static void
+local_server_event_callback(int fd, short event, void *ctx)
 {
+	struct local_server *server = ctx;
 	int rfd;
 	struct sockaddr_un local;
 	socklen_t sin_size = sizeof(struct sockaddr_un);
 	
 	if ((rfd = accept(server->fd, (struct sockaddr *)&local, &sin_size)) == -1)
-		return -1;
+		return;
 
 	server->process(rfd, server->data);
 	close(rfd);
-
-	return 0;
 }
 
 int local_client_create(struct local_conf *conf)
diff --git a/src/main.c b/src/main.c
index 8221564..062a4cb 100644
--- a/src/main.c
+++ b/src/main.c
@@ -26,6 +26,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <unistd.h>
+#include <event.h>
 
 struct ct_general_state st;
 union ct_state state;
@@ -82,6 +83,7 @@ int main(int argc, char *argv[])
 	int type = 0;
 	struct utsname u;
 	int version, major, minor;
+	struct event_base *event_base;
 
 	/* Check kernel version: it must be >= 2.6.18 */
 	if (uname(&u) == -1) {
@@ -224,6 +226,8 @@ int main(int argc, char *argv[])
 	 * initialization process
 	 */
 
+	event_base = event_init();
+
 	if (init() == -1) {
 		close_log();
 		fprintf(stderr, "ERROR: conntrackd cannot start, please "
@@ -257,6 +261,14 @@ int main(int argc, char *argv[])
 	/*
 	 * run main process
 	 */
+
 	run();
+
+	/*
+	 * cleanup
+	 */
+
+	event_base_free(event_base);
+
 	return 0;
 }
diff --git a/src/mcast.c b/src/mcast.c
index 86de962..eed8652 100644
--- a/src/mcast.c
+++ b/src/mcast.c
@@ -32,6 +32,16 @@
 #include <sys/ioctl.h>
 #include <net/if.h>
 
+static int mcast_run(struct mcast_sock *m);
+
+static void
+mcast_server_event_callback(int fd, short event, void *ctx)
+{
+	struct mcast_sock *m = ctx;
+
+	mcast_run(m);
+}
+
 struct mcast_sock *mcast_server_create(struct mcast_conf *conf,
 				       void *data,
 				       int (*handler)(struct nethdr *net, void *data))
@@ -130,11 +140,18 @@ struct mcast_sock *mcast_server_create(struct mcast_conf *conf,
 	m->data = data;
 	m->handler = handler;
 
+	event_set(&m->event, m->fd,
+		  EV_READ|EV_PERSIST, mcast_server_event_callback, m);
+	event_add(&m->event, NULL);
+
+	m->handler = handler;
+
 	return m;
 }
 
 void mcast_server_destroy(struct mcast_sock *m)
 {
+	event_del(&m->event);
 	close(m->fd);
 	free(m);
 }
@@ -291,7 +308,7 @@ ssize_t mcast_recv(struct mcast_sock *m, void *data, int size)
 	return ret;
 }
 
-int mcast_run(struct mcast_sock *m)
+static int mcast_run(struct mcast_sock *m)
 {
 	ssize_t numbytes;
 	size_t remain;
diff --git a/src/run.c b/src/run.c
index fcba393..9631481 100644
--- a/src/run.c
+++ b/src/run.c
@@ -30,33 +30,71 @@
 #include <unistd.h>
 #include <sys/wait.h>
 #include <string.h>
+#include <event.h>
 
 void killer(int foo)
 {
-	/* no signals while handling signals */
-	sigprocmask(SIG_BLOCK, &STATE(block), NULL);
-
 	nfct_close(STATE(event));
 	nfct_close(STATE(dump));
 
 	ignore_pool_destroy(STATE(ignore_pool));
 	local_server_destroy(&STATE(local));
 	STATE(mode)->kill();
-	destroy_alarm_hash();
 	unlink(CONFIG(lockfile));
 	dlog(LOG_NOTICE, "---- shutdown received ----");
 	close_log();
 
-	sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
-
 	exit(0);			
 }
 
-static void child(int foo)
+static void
+exit_event_callback(int fd, short event, void *ctx)
+{
+	killer(0);
+}
+
+static void
+child_event_callback(int fd, short event, void *ctx)
 {
 	while(wait(NULL) > 0);
 }
 
+static void
+nfct_event_callback(int fd, short event, void *ctx)
+{
+	int ret;
+
+	while ((ret = nfct_catch(STATE(event))) != -1);
+	if (ret == -1) {
+		switch(errno) {
+		case ENOBUFS:
+			/*
+			 * It seems that ctnetlink can't back off,
+			 * it's likely that we're losing events.
+			 * Solution: duplicate the socket buffer
+			 * size and resync with master conntrack table.
+			 */
+			nl_resize_socket_buffer(STATE(event));
+			/* XXX: schedule overrun call via alarm */
+			STATE(mode)->overrun();
+			break;
+		case ENOENT:
+			/*
+			 * We received a message from another
+			 * netfilter subsystem that we are not
+			 * interested in. Just ignore it.
+			 */
+			break;
+		case EAGAIN:
+			break;
+		default:
+			dlog(LOG_WARNING,
+			     "event catch says: %s", strerror(errno));
+			break;
+		}
+	}
+}
+
 void local_handler(int fd, void *data)
 {
 	int ret;
@@ -92,6 +130,8 @@ void local_handler(int fd, void *data)
 int
 init(void)
 {
+	static struct event nfct_event;
+	static struct event sigint_event, sigterm_event, sigchld_event;
 	int ret;
 
 	if (CONFIG(flags) & CTD_STATS_MODE)
@@ -105,11 +145,6 @@ init(void)
 		STATE(mode) = &stats_mode;
 	}
 
-	if (init_alarm_hash() == -1) {
-		dlog(LOG_ERR, "can't initialize alarm hash");
-		return -1;
-	}
-
 	/* Initialization */
 	if (STATE(mode)->init() == -1) {
 		dlog(LOG_ERR, "initialization failed");
@@ -131,6 +166,10 @@ init(void)
 		return -1;
 	}
 
+	event_set(&nfct_event, nfct_fd(STATE(event)),
+		  EV_READ|EV_PERSIST, nfct_event_callback, NULL);
+	event_add(&nfct_event, NULL);
+
 	if (nl_init_dump_handler() == -1) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
@@ -139,113 +178,35 @@ init(void)
 	}
 
         /* Signals handling */
-	sigemptyset(&STATE(block));
-	sigaddset(&STATE(block), SIGTERM);
-	sigaddset(&STATE(block), SIGINT);
-	sigaddset(&STATE(block), SIGCHLD);
 
-	if (signal(SIGINT, killer) == SIG_ERR)
-		return -1;
+	event_set(&sigint_event, SIGTERM, EV_SIGNAL|EV_PERSIST,
+		  exit_event_callback, NULL);
+	event_add(&sigint_event, NULL);
 
-	if (signal(SIGTERM, killer) == SIG_ERR)
-		return -1;
+	event_set(&sigterm_event, SIGTERM, EV_SIGNAL|EV_PERSIST,
+		  exit_event_callback, NULL);
+	event_add(&sigterm_event, NULL);
 
 	/* ignore connection reset by peer */
 	if (signal(SIGPIPE, SIG_IGN) == SIG_ERR)
 		return -1;
 
-	if (signal(SIGCHLD, child) == SIG_ERR)
-		return -1;
+	event_set(&sigchld_event, SIGCHLD, EV_SIGNAL|EV_PERSIST,
+		  child_event_callback, NULL);
+	event_add(&sigchld_event, NULL);
 
 	dlog(LOG_NOTICE, "initialization completed");
 
 	return 0;
 }
 
-static void __run(struct timeval *next_alarm)
-{
-	int max, ret;
-	fd_set readfds;
-
-	FD_ZERO(&readfds);
-	FD_SET(STATE(local).fd, &readfds);
-	FD_SET(nfct_fd(STATE(event)), &readfds);
-
-	max = MAX(STATE(local).fd, nfct_fd(STATE(event)));
-
-	if (STATE(mode)->add_fds_to_set)
-		max = MAX(max, STATE(mode)->add_fds_to_set(&readfds));
-
-	ret = select(max+1, &readfds, NULL, NULL, next_alarm);
-	if (ret == -1) {
-		/* interrupted syscall, retry */
-		if (errno == EINTR)
-			return;
-
-		dlog(LOG_WARNING, "select failed: %s", strerror(errno));
-		return;
-	}
-
-	/* signals are racy */
-	sigprocmask(SIG_BLOCK, &STATE(block), NULL);		
-
-	/* order received via UNIX socket */
-	if (FD_ISSET(STATE(local).fd, &readfds))
-		do_local_server_step(&STATE(local));
-
-	/* conntrack event has happened */
-	if (FD_ISSET(nfct_fd(STATE(event)), &readfds)) {
-		while ((ret = nfct_catch(STATE(event))) != -1);
-		if (ret == -1) {
-			switch(errno) {
-			case ENOBUFS:
-                		/*
-		 		 * It seems that ctnetlink can't back off,
-				 * it's likely that we're losing events.
-				 * Solution: duplicate the socket buffer
-				 * size and resync with master conntrack table.
-				 */
-				nl_resize_socket_buffer(STATE(event));
-				/* XXX: schedule overrun call via alarm */
-				STATE(mode)->overrun();
-				break;
-			case ENOENT:
-				/*
-				 * We received a message from another
-				 * netfilter subsystem that we are not
-				 * interested in. Just ignore it.
-				 */
-				break;
-			case EAGAIN:
-				break;
-			default:
-				dlog(LOG_WARNING,
-				     "event catch says: %s", strerror(errno));
-				break;
-			}
-		}
-	}
-
-	if (STATE(mode)->run)
-		STATE(mode)->run(&readfds);
-
-	sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
-}
-
 void __attribute__((noreturn))
 run(void)
 {
-	struct timeval next_alarm; 
-	struct timeval *next = NULL;
-
 	while(1) {
-		sigprocmask(SIG_BLOCK, &STATE(block), NULL);
-		if (next != NULL && !timerisset(next))
-			next = do_alarm_run(&next_alarm);
-		else
-			next = get_next_alarm_run(&next_alarm);
-		sigprocmask(SIG_UNBLOCK, &STATE(block), NULL);
-
-		__run(next);
+		event_loop(EVLOOP_ONCE);
+
+		if (STATE(mode)->run)
+			STATE(mode)->run();
 	}
 }
diff --git a/src/stats-mode.c b/src/stats-mode.c
index 9e6089c..de9f146 100644
--- a/src/stats-mode.c
+++ b/src/stats-mode.c
@@ -182,7 +182,6 @@ static int event_destroy_stats(struct nf_conntrack *ct)
 
 struct ct_mode stats_mode = {
 	.init 			= init_stats,
-	.add_fds_to_set 	= NULL,
 	.run			= NULL,
 	.local			= local_handler_stats,
 	.kill			= kill_stats,
diff --git a/src/sync-mode.c b/src/sync-mode.c
index 7811d3d..60960da 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -177,19 +177,8 @@ static int init_sync(void)
 	return 0;
 }
 
-static int add_fds_to_set_sync(fd_set *readfds) 
+static void run_sync(void)
 {
-	FD_SET(STATE_SYNC(mcast_server->fd), readfds);
-
-	return STATE_SYNC(mcast_server->fd);
-}
-
-static void run_sync(fd_set *readfds)
-{
-	/* multicast packet has been received */
-	if (FD_ISSET(STATE_SYNC(mcast_server->fd), readfds))
-		mcast_run(STATE_SYNC(mcast_server));
-
 	if (STATE_SYNC(sync)->run)
 		STATE_SYNC(sync)->run();
 
@@ -475,7 +464,6 @@ static int event_destroy_sync(struct nf_conntrack *ct)
 
 struct ct_mode sync_mode = {
 	.init 			= init_sync,
-	.add_fds_to_set 	= add_fds_to_set_sync,
 	.run			= run_sync,
 	.local			= local_handler_sync,
 	.kill			= kill_sync,


