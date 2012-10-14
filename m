From: Ansis Atteka <aatteka@nicira.com>
Subject: [RFC] Multi-namespace support (Request for comments)
Date: Sat, 13 Oct 2012 20:12:56 -0700
Message-ID: <1350184376-7957-1-git-send-email-aatteka@nicira.com>
Cc: Ansis Atteka <aatteka@nicira.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:41813 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751419Ab2JNDNI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Oct 2012 23:13:08 -0400
Received: by mail-yh0-f70.google.com with SMTP id o21so6509788yho.1
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Oct 2012 20:13:05 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch should not be considered complete! It was sent out with intention
to propose feature and receive further comments.

It enables single conntrackd process to synchronize state among multiple
namespaces. To test this patch apply it on the top of this one:

http://markmail.org/thread/npxklk4p6g4y3rup

And use following conntrackd.conf on both hosts:

Sync {
        Mode NOTRACK {
                DisableInternalCache On
                DisableExternalCache On
        }
        UDP {
                IPv4_Destination_Address <host[1|2]>
                Interface breth0
                SndSocketBuffer 1249280
                Checksum on
                Port 3781
        }
}
General {
        Nice -20
        LogFile on
        LockFile /var/lock/conntrack.lock
        UNIX {
                Path /var/run/conntrackd.ctl
                Backlog 20
        }
        NetlinkBufferSize 2097152
        NetlinkBufferSizeMaxGrowth 8388608
}

The configuration above is used as template when instantiating
the actual configuration for every namespace. Use following
commands to do that:

host1: conntrackd -A namespace1 /var/run/netns/namespace1
host1: conntrackd -A namespace2 /var/run/netns/namespace2
host2: conntrackd -A namespace1 /var/run/netns/namespace1
host2: conntrackd -A namespace2 /var/run/netns/namespace2

The first argument is the namespace identifier and second
is the path to the actual namespace mount point.

This patch doesn't work correctly yet with:
1. caches
2. FTFW or ALARM modes
3. filters (it seems a little bit tricky to unglobalize it)
4. expectations
5. and it even breaks the current conntrackd usage (it does
not create state object for the current namespace)

Currently I am protoyping another patch that will allow
to synchronize different namespace subsets between more
than two hosts (i.e. each ns_state will reference the
right multichannel structure and use it).
---
 include/cache.h       |    5 +-
 include/conntrackd.h  |   35 +++++-
 include/external.h    |   12 +-
 include/internal.h    |   21 +++-
 include/local.h       |    3 +-
 include/namespace.h   |    2 +
 include/netlink.h     |    2 +-
 include/network.h     |   18 +--
 src/build.c           |    7 +-
 src/cache-ct.c        |    4 +-
 src/cache-exp.c       |    4 +-
 src/ctnl.c            |  291 ++++++++++++++++++++++++++++++++++---------------
 src/external_cache.c  |   12 +-
 src/external_inject.c |   50 ++++-----
 src/internal_bypass.c |   42 ++++---
 src/internal_cache.c  |   18 ++-
 src/local.c           |   10 +-
 src/main.c            |   45 +++++++-
 src/namespace.c       |   35 ++++--
 src/netlink.c         |    5 +-
 src/parse.c           |   19 +++-
 src/stats-mode.c      |    6 +-
 src/sync-alarm.c      |    2 +-
 src/sync-ftfw.c       |    3 +-
 src/sync-mode.c       |   64 ++++++-----
 src/sync-notrack.c    |    5 +-
 26 files changed, 495 insertions(+), 225 deletions(-)

diff --git a/include/cache.h b/include/cache.h
index 3af2741..8a9d550 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -4,6 +4,7 @@
 #include <stdint.h>
 #include <stddef.h>
 #include "hash.h"
+#include "conntrackd.h"
 #include "date.h"
 
 /* cache features */
@@ -58,6 +59,7 @@ enum cache_type {
 
 struct cache {
 	char name[CACHE_MAX_NAMELEN];
+	char nsid[NAMESPACE_ID_MAXLEN];
 	enum cache_type type;
 	struct hashtable *h;
 
@@ -122,7 +124,8 @@ struct cache_ops {
 	int (*commit)(struct cache *c, struct nfct_handle *h, int clientfd);
 
 	/* build network message from object. */
-	struct nethdr *(*build_msg)(const struct cache_object *obj, int type);
+	struct nethdr *(*build_msg)(const struct cache_object *obj, int type,
+				    const char *nsid);
 };
 
 /* templates to configure conntrack caching. */
diff --git a/include/conntrackd.h b/include/conntrackd.h
index a069793..a51159c 100644
--- a/include/conntrackd.h
+++ b/include/conntrackd.h
@@ -49,6 +49,8 @@
 #define ALL_COMMIT		46	/* commit all tables		*/
 #define EXP_DUMP_INT_XML	47	/* dump internal cache in XML	*/
 #define EXP_DUMP_EXT_XML	48	/* dump external cache in XML	*/
+#define ADD_NAMESPACE		49	/* add namespace to the config  */
+#define DEL_NAMESPACE		50	/* add namespace to the config  */
 
 #define DEFAULT_CONFIGFILE	"/etc/conntrackd/conntrackd.conf"
 #define DEFAULT_LOCKFILE	"/var/lock/conntrackd.lock"
@@ -76,6 +78,8 @@
 #define FILENAME_MAXLEN 256
 #endif
 
+#define NAMESPACE_ID_MAXLEN 40
+
 union inet_address {
 	uint32_t ipv4;
 	uint32_t ipv6[4];
@@ -84,6 +88,11 @@ union inet_address {
 
 #define CONFIG(x) conf.x
 
+struct ns_conf {
+	char namespace_id[NAMESPACE_ID_MAXLEN];
+	char netlink_namespace[FILENAME_MAXLEN];
+};
+
 struct ct_conf {
 	char logfile[FILENAME_MAXLEN];
 	int syslog_facility;
@@ -143,6 +152,28 @@ struct ct_conf {
 
 #define STATE(x) st.x
 
+struct ns_state {
+	struct	hashtable_node hashnode;
+
+	char nsid[NAMESPACE_ID_MAXLEN];
+	struct {
+		int cur_fd;				/* conntrack */
+		int root_fd;				/* channel*/
+	} ns;
+	struct nfct_handle		*event;		/* event handler */
+	struct nfct_handle 		*inject;
+
+	struct nfct_handle		*dump;		/* dump handler */
+	struct nfct_handle		*resync;	/* resync handler */
+	struct nfct_handle		*get;		/* get handler */
+	struct nfct_handle		*flush;		/* flusher */
+
+	/* I guess STATE(filter) should be unglobalized here too */
+
+	struct multichannel	*channel;
+
+};
+
 struct ct_general_state {
 	sigset_t 			block;
 	FILE 				*log;
@@ -157,7 +188,6 @@ struct ct_general_state {
 		int cur_fd;				/* conntrack */
 		int root_fd;				/* channel*/
 	} ns;
-	struct nfct_handle		*event;         /* event handler */
 	struct nfct_filter		*filter;	/* event filter */
 	int				event_iterations_limit;
 
@@ -291,6 +321,9 @@ void ctnl_kill(void);
 int ctnl_local(int fd, int type, void *data);
 int ctnl_init(void);
 
+void destroy_state(const char *namespace_id);
+void create_state(struct ns_conf ns);
+
 /* basic cthelper functions */
 void cthelper_kill(void);
 int cthelper_local(int fd, int type, void *data);
diff --git a/include/external.h b/include/external.h
index 70f0c5c..c361860 100644
--- a/include/external.h
+++ b/include/external.h
@@ -8,9 +8,9 @@ struct external_handler {
 	void	(*close)(void);
 
 	struct {
-		void	(*new)(struct nf_conntrack *ct);
-		void	(*upd)(struct nf_conntrack *ct);
-		void	(*del)(struct nf_conntrack *ct);
+		void	(*new)(struct nf_conntrack *ct, struct ns_state *ns);
+		void	(*upd)(struct nf_conntrack *ct, struct ns_state *ns);
+		void	(*del)(struct nf_conntrack *ct, struct ns_state *ns);
 
 		void	(*dump)(int fd, int type);
 		void	(*flush)(void);
@@ -19,9 +19,9 @@ struct external_handler {
 		void	(*stats_ext)(int fd);
 	} ct;
 	struct {
-		void	(*new)(struct nf_expect *exp);
-		void	(*upd)(struct nf_expect *exp);
-		void	(*del)(struct nf_expect *exp);
+		void	(*new)(struct nf_expect *exp, struct ns_state *ns);
+		void	(*upd)(struct nf_expect *exp, struct ns_state *ns);
+		void	(*del)(struct nf_expect *exp, struct ns_state *ns);
 
 		void	(*dump)(int fd, int type);
 		void	(*flush)(void);
diff --git a/include/internal.h b/include/internal.h
index 2ba9714..abd9d01 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -3,6 +3,9 @@
 
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
+#include "conntrackd.h"
+
+struct ns_state; /* But why do I need this here??*/
 struct nf_conntrack;
 
 enum {
@@ -20,9 +23,12 @@ struct internal_handler {
 	struct {
 		void	*data;
 
-		void	(*new)(struct nf_conntrack *ct, int origin_type);
-		void	(*upd)(struct nf_conntrack *ct, int origin_type);
-		int	(*del)(struct nf_conntrack *ct, int origin_type);
+		void	(*new)(struct nf_conntrack *ct, int origin_type,
+			       struct ns_state *s);
+		void	(*upd)(struct nf_conntrack *ct, int origin_type,
+			       struct ns_state *s);
+		int	(*del)(struct nf_conntrack *ct, int origin_type,
+			       struct ns_state *s);
 
 		void	(*dump)(int fd, int type);
 		void	(*populate)(struct nf_conntrack *ct);
@@ -37,9 +43,12 @@ struct internal_handler {
 	struct {
 		void	*data;
 
-		void	(*new)(struct nf_expect *exp, int origin_type);
-		void	(*upd)(struct nf_expect *exp, int origin_type);
-		int	(*del)(struct nf_expect *exp, int origin_type);
+		void	(*new)(struct nf_expect *exp, int origin_type,
+			       struct ns_state *s);
+		void	(*upd)(struct nf_expect *exp, int origin_type,
+			       struct ns_state *s);
+		int	(*del)(struct nf_expect *exp, int origin_type,
+			       struct ns_state *s);
 
 		void	(*dump)(int fd, int type);
 		void	(*populate)(struct nf_expect *exp);
diff --git a/include/local.h b/include/local.h
index f9121b1..0efc619 100644
--- a/include/local.h
+++ b/include/local.h
@@ -31,7 +31,8 @@ int do_local_server_step(struct local_server *server, void *data,
 int local_client_create(struct local_conf *conf);
 void local_client_destroy(int fd);
 int do_local_client_step(int fd, void (*process)(char *buf));
-int do_local_request(int, struct local_conf *,void (*step)(char *buf));
+int do_local_request(int, struct local_conf *,void (*step)(char *buf),
+		     const char *buffer, int buflen);
 void local_step(char *buf);
 
 #endif
diff --git a/include/namespace.h b/include/namespace.h
index ae8cca0..4adb859 100644
--- a/include/namespace.h
+++ b/include/namespace.h
@@ -10,4 +10,6 @@ int ns_init(void);
 struct nfct_handle *ns_nfct_open(u_int8_t, unsigned, int);
 struct mnl_socket *ns_mnl_socket_open(int, int);
 
+extern struct hashtable *ns_table;
+
 #endif
diff --git a/include/netlink.h b/include/netlink.h
index 9a33083..9d7cd01 100644
--- a/include/netlink.h
+++ b/include/netlink.h
@@ -6,7 +6,7 @@
 struct nf_conntrack;
 struct nfct_handle;
 
-struct nfct_handle *nl_init_event_handler(void);
+struct nfct_handle *nl_init_event_handler(int);
 struct nlif_handle *nl_init_interface_handler(void);
 
 int nl_send_resync(struct nfct_handle *h);
diff --git a/include/network.h b/include/network.h
index 41c35af..bafb7f7 100644
--- a/include/network.h
+++ b/include/network.h
@@ -85,24 +85,24 @@ enum {
 	MSG_BAD,
 };
 
-#define BUILD_NETMSG_FROM_CT(ct, query)				\
+#define BUILD_NETMSG_FROM_CT(ct, query, ns)			\
 ({								\
 	static char __net[4096];				\
 	struct nethdr *__hdr = (struct nethdr *) __net;		\
 	memset(__hdr, 0, NETHDR_SIZ);				\
 	nethdr_set(__hdr, query);				\
-	ct2msg(ct, __hdr);					\
+	ct2msg(ct, __hdr, ns);					\
 	HDR_HOST2NETWORK(__hdr);				\
 	__hdr;							\
 })
 
-#define BUILD_NETMSG_FROM_EXP(exp, query)			\
+#define BUILD_NETMSG_FROM_EXP(exp, query, ns)			\
 ({								\
 	static char __net[4096];				\
 	struct nethdr *__hdr = (struct nethdr *) __net;		\
 	memset(__hdr, 0, NETHDR_SIZ);				\
 	nethdr_set(__hdr, query);				\
-	exp2msg(exp, __hdr);					\
+	exp2msg(exp, __hdr, ns);				\
 	HDR_HOST2NETWORK(__hdr);				\
 	__hdr;							\
 })
@@ -240,6 +240,7 @@ enum nta_attr {
 	NTA_TCP_WSCALE_ORIG,	/* uint8_t */
 	NTA_TCP_WSCALE_REPL,	/* uint8_t */
 	NTA_HELPER_NAME,	/* string (variable length) */
+	NTA_NAMESPACE,		/* string (variable length) */
 	NTA_MAX
 };
 
@@ -252,8 +253,8 @@ struct nta_attr_natseqadj {
 	uint32_t repl_seq_offset_after;
 };
 
-void ct2msg(const struct nf_conntrack *ct, struct nethdr *n);
-int msg2ct(struct nf_conntrack *ct, struct nethdr *n, size_t remain);
+void ct2msg(const struct nf_conntrack *ct, struct nethdr *n, const char *ns);
+int msg2ct(struct nf_conntrack *ct, struct nethdr *n, size_t remain, char *ns);
 
 enum nta_exp_attr {
 	NTA_EXP_MASTER_IPV4 = 0,	/* struct nfct_attr_grp_ipv4 */
@@ -277,10 +278,11 @@ enum nta_exp_attr {
 	NTA_EXP_NAT_DIR,		/* uint32_t */
 	NTA_EXP_HELPER_NAME,		/* string (variable length) */
 	NTA_EXP_FN,			/* string (variable length) */
+	NTA_EXP_NAMESPACE,		/* string (variable length) */
 	NTA_EXP_MAX
 };
 
-void exp2msg(const struct nf_expect *exp, struct nethdr *n);
-int msg2exp(struct nf_expect *exp, struct nethdr *n, size_t remain);
+void exp2msg(const struct nf_expect *exp, struct nethdr *n, const char *ns);
+int msg2exp(struct nf_expect *exp, struct nethdr *n, size_t remain, char *ns);
 
 #endif
diff --git a/src/build.c b/src/build.c
index e15eb4f..d905de7 100644
--- a/src/build.c
+++ b/src/build.c
@@ -173,7 +173,7 @@ static struct build_l4proto {
 	[IPPROTO_UDP]		= { .build = build_l4proto_udp },
 };
 
-void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
+void ct2msg(const struct nf_conntrack *ct, struct nethdr *n, const char *ns)
 {
 	uint8_t l4proto = nfct_get_attr_u8(ct, ATTR_L4PROTO);
 
@@ -233,6 +233,9 @@ void ct2msg(const struct nf_conntrack *ct, struct nethdr *n)
 
 	if (nfct_attr_is_set(ct, ATTR_HELPER_NAME))
 		ct_build_str(ct, ATTR_HELPER_NAME, n, NTA_HELPER_NAME);
+
+	if (ns[0])
+		addattr(n, NTA_NAMESPACE, ns, strlen(ns) + 1);
 }
 
 static void
@@ -287,7 +290,7 @@ exp_build_str(const struct nf_expect *exp, int a, struct nethdr *n, int b)
 	addattr(n, b, data, strlen(data)+1);
 }
 
-void exp2msg(const struct nf_expect *exp, struct nethdr *n)
+void exp2msg(const struct nf_expect *exp, struct nethdr *n, const char *ns)
 {
 	const struct nf_conntrack *ct = nfexp_get_attr(exp, ATTR_EXP_MASTER);
 	uint8_t l4proto = nfct_get_attr_u8(ct, ATTR_L4PROTO);
diff --git a/src/cache-ct.c b/src/cache-ct.c
index 0ad8d2a..b241052 100644
--- a/src/cache-ct.c
+++ b/src/cache-ct.c
@@ -314,9 +314,9 @@ static int cache_ct_commit(struct cache *c, struct nfct_handle *h, int clientfd)
 }
 
 static struct nethdr *
-cache_ct_build_msg(const struct cache_object *obj, int type)
+cache_ct_build_msg(const struct cache_object *obj, int type, const char *nsid)
 {
-	return BUILD_NETMSG_FROM_CT(obj->ptr, type);
+	return BUILD_NETMSG_FROM_CT(obj->ptr, type, nsid);
 }
 
 /* template to cache conntracks coming from the kernel. */
diff --git a/src/cache-exp.c b/src/cache-exp.c
index e88877a..e2344c3 100644
--- a/src/cache-exp.c
+++ b/src/cache-exp.c
@@ -278,9 +278,9 @@ cache_exp_commit(struct cache *c, struct nfct_handle *h, int clientfd)
 }
 
 static struct nethdr *
-cache_exp_build_msg(const struct cache_object *obj, int type)
+cache_exp_build_msg(const struct cache_object *obj, int type, const char *nsid)
 {
-	return BUILD_NETMSG_FROM_EXP(obj->ptr, type);
+	return BUILD_NETMSG_FROM_EXP(obj->ptr, type, nsid);
 }
 
 /* template to cache expectations coming from the kernel. */
diff --git a/src/ctnl.c b/src/ctnl.c
index cf65a1b..704521e 100644
--- a/src/ctnl.c
+++ b/src/ctnl.c
@@ -40,23 +40,16 @@
 #include <time.h>
 #include <fcntl.h>
 
-void ctnl_kill(void)
+static int destroy_namespace_iterate(void *data1, void *n)
 {
-	if (!(CONFIG(flags) & CTD_POLL))
-		nfct_close(STATE(event));
-
-	nfct_close(STATE(resync));
-	nfct_close(STATE(get));
-	origin_unregister(STATE(flush));
-	nfct_close(STATE(flush));
-
-	if (STATE(us_filter))
-		ct_filter_destroy(STATE(us_filter));
-	STATE(mode)->kill();
+	struct ns_state *s = n;
+	destroy_state(s->nsid);
+	return 0;
+}
 
-	if (STATE(mode)->internal->flags & INTERNAL_F_POPULATE) {
-		nfct_close(STATE(dump));
-	}
+void ctnl_kill(void)
+{
+	hashtable_iterate(ns_table , NULL, destroy_namespace_iterate);
 }
 
 static void local_flush_master(void)
@@ -118,6 +111,7 @@ static void local_exp_resync_master(void)
 int ctnl_local(int fd, int type, void *data)
 {
 	int ret = LOCAL_RET_OK;
+	struct ns_conf c;
 
 	switch(type) {
 	case CT_FLUSH_MASTER:
@@ -140,6 +134,18 @@ int ctnl_local(int fd, int type, void *data)
 		local_resync_master();
 		local_exp_resync_master();
 		break;
+	case ADD_NAMESPACE:
+		if (read(fd, &c, sizeof(c)) <= 0)
+			dlog(LOG_ERR, "Could not read configuration");
+		create_state(c);
+		/* TODO: Encapsulate return value over UNIX socket */
+		break;
+	case DEL_NAMESPACE:
+		if (read(fd, &c, sizeof(c)) <= 0)
+			dlog(LOG_ERR, "Could not read configuration");
+		destroy_state(c.namespace_id);
+		/* TODO: Encapsulate return value over UNIX socket */
+		break;
 	}
 
 	ret = STATE(mode)->local(fd, type, data);
@@ -177,7 +183,8 @@ static int event_handler(const struct nlmsghdr *nlh,
 			 void *data)
 {
 	int origin_type;
-
+	struct ns_state *s = data;
+	dlog(LOG_ERR, "event_handler on %s", s->nsid);
 	STATE(stats).nl_events_received++;
 
 	/* skip user-space filtering if already do it in the kernel */
@@ -190,13 +197,13 @@ static int event_handler(const struct nlmsghdr *nlh,
 
 	switch(type) {
 	case NFCT_T_NEW:
-		STATE(mode)->internal->ct.new(ct, origin_type);
+		STATE(mode)->internal->ct.new(ct, origin_type, s);
 		break;
 	case NFCT_T_UPDATE:
-		STATE(mode)->internal->ct.upd(ct, origin_type);
+		STATE(mode)->internal->ct.upd(ct, origin_type, s);
 		break;
 	case NFCT_T_DESTROY:
-		if (STATE(mode)->internal->ct.del(ct, origin_type))
+		if (STATE(mode)->internal->ct.del(ct, origin_type, s))
 			update_traffic_stats(ct);
 		break;
 	default:
@@ -220,6 +227,7 @@ static int exp_event_handler(const struct nlmsghdr *nlh,
 	int origin_type;
 	const struct nf_conntrack *master =
 		nfexp_get_attr(exp, ATTR_EXP_MASTER);
+	struct ns_state *s = data;
 
 	STATE(stats).nl_events_received++;
 
@@ -234,13 +242,13 @@ static int exp_event_handler(const struct nlmsghdr *nlh,
 
 	switch(type) {
 	case NFCT_T_NEW:
-		STATE(mode)->internal->exp.new(exp, origin_type);
+		STATE(mode)->internal->exp.new(exp, origin_type, s);
 		break;
 	case NFCT_T_UPDATE:
-		STATE(mode)->internal->exp.upd(exp, origin_type);
+		STATE(mode)->internal->exp.upd(exp, origin_type, s);
 		break;
 	case NFCT_T_DESTROY:
-		STATE(mode)->internal->exp.del(exp, origin_type);
+		STATE(mode)->internal->exp.del(exp, origin_type, s);
 		break;
 	default:
 		STATE(stats).nl_events_unknown_type++;
@@ -327,8 +335,9 @@ static int exp_get_handler(enum nf_conntrack_msg_type type,
 static void event_cb(void *data)
 {
 	int ret;
+	struct ns_state *s = data;
 
-	ret = nfct_catch(STATE(event));
+	ret = nfct_catch(s->event);
 	/* reset event iteration limit counter */
 	STATE(event_iterations_limit) = CONFIG(event_iterations_limit);
 	if (ret == -1) {
@@ -359,7 +368,7 @@ static void event_cb(void *data)
 			 *    If workload lowers at some point,
 			 *    we resync ourselves.
 			 */
-			nl_resize_socket_buffer(STATE(event));
+			nl_resize_socket_buffer(s->event);
 			if (CONFIG(nl_overrun_resync) > 0 &&
 			    STATE(mode)->internal->flags & INTERNAL_F_RESYNC) {
 				add_alarm(&STATE(resync_alarm),
@@ -398,104 +407,168 @@ static void poll_cb(void *data)
 	nfct_catch(STATE(resync));
 }
 
-int ctnl_init(void)
+void destroy_state(const char *namespace_id)
 {
-	if (ns_init() == -1)
-		return -1;
+	int ns_id;
+	struct ns_state *s;
+
+	ns_id = hashtable_hash(ns_table, namespace_id);
+	s = (struct ns_state *)hashtable_find(ns_table, namespace_id, ns_id);
+	if (!s) {
+		dlog(LOG_ERR, "namespace '%s' not found. Can't delete",
+		     namespace_id);
+		return;
+	}
+	hashtable_del(ns_table, &s->hashnode);
 
-	if (CONFIG(flags) & CTD_STATS_MODE)
-		STATE(mode) = &stats_mode;
-	else if (CONFIG(flags) & CTD_SYNC_MODE)
-		STATE(mode) = &sync_mode;
-	else {
-		fprintf(stderr, "WARNING: No running mode specified. "
-				"Defaulting to statistics mode.\n");
-		CONFIG(flags) |= CTD_STATS_MODE;
-		STATE(mode) = &stats_mode;
+	if (s->ns.cur_fd >= 0) {
+		close(s->ns.cur_fd);
+		s->ns.cur_fd = -1;
 	}
 
-	/* Initialization */
-	if (STATE(mode)->init() == -1) {
-		dlog(LOG_ERR, "initialization failed");
-		return -1;
+	if (s->resync) {
+		unregister_fd(nfct_fd(s->resync), STATE(fds));
+		nfct_callback_unregister(s->resync);
+		nfct_close(s->resync);
+	}
+
+	if (s->dump) {
+		if (CONFIG(flags) & CTD_EXPECT)
+			nfexp_callback_unregister(s->dump);
+		nfct_callback_unregister(s->dump);
+		nfct_close(s->dump);
+	}
+
+	if (s->get) {
+		if (CONFIG(flags) & CTD_EXPECT)
+			nfexp_callback_unregister(s->get);
+		nfct_callback_unregister(s->get);
+		nfct_close(s->get);
+	}
+
+	if (s->flush) {
+		origin_unregister(s->flush);
+		nfct_close(s->flush);
+	}
+
+	if (s->inject) {
+		origin_unregister(s->inject);
+		nfct_close(s->inject);
+	}
+
+	if (!(CONFIG(flags) & CTD_POLL)) {
+		unregister_fd(nfct_fd(s->event), STATE(fds));
+		nfct_callback_unregister2(s->event);
+		if (CONFIG(flags) & CTD_EXPECT)
+			nfexp_callback_unregister2(s->event);
+		nfct_close(s->event);
 	}
 
+
+//	STATE(mode)->kill();
+
+
+}
+
+void create_state(struct ns_conf ns)
+{
+	int ns_id;
+	struct ns_state *s;
+
+	ns_id = hashtable_hash(ns_table, &ns.namespace_id);
+	if (hashtable_find(ns_table, ns.namespace_id, ns_id)) {
+		dlog(LOG_ERR, "namespace '%s' already present. Can't add",
+		     ns.namespace_id);
+		return;
+	}
+
+	s = calloc(1, sizeof(struct ns_state));
+	if (!s)
+		return;
+
+	strncpy(s->nsid, ns.namespace_id, NAMESPACE_ID_MAXLEN);
+	if (hashtable_add(ns_table, &s->hashnode, ns_id) == -1) {
+		dlog(LOG_ERR, "could not add '%s' to hashtable");
+		goto free_mem;
+	}
+
+	/* namespace, where all CT netlink sockets will be opened */
+	s->ns.cur_fd = open(ns.netlink_namespace, O_RDONLY);
+	if (s->ns.cur_fd == -1)
+		goto err;
+
 	/* resynchronize (like 'dump' socket) but it also purges old entries */
-	STATE(resync) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
-				     STATE(ns).cur_fd);
-	if (STATE(resync)== NULL) {
+	s->resync = ns_nfct_open(CONFIG(netlink).subsys_id, 0, s->ns.cur_fd);
+	if (s->resync == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
 		dlog(LOG_ERR, "no ctnetlink kernel support?");
-		return -1;
+		goto err;
 	}
-	nfct_callback_register(STATE(resync),
+	nfct_callback_register(s->resync,
 			       NFCT_T_ALL,
 			       STATE(mode)->internal->ct.resync,
-			       NULL);
-	if (CONFIG(flags) & CTD_POLL) {
-		register_fd(nfct_fd(STATE(resync)), poll_cb,
-				NULL, STATE(fds));
-	} else {
-		register_fd(nfct_fd(STATE(resync)), resync_cb,
-				NULL, STATE(fds));
-	}
-	fcntl(nfct_fd(STATE(resync)), F_SETFL, O_NONBLOCK);
+			       s);
+	if (CONFIG(flags) & CTD_POLL)
+		register_fd(nfct_fd(s->resync), poll_cb, NULL, STATE(fds));
+	else
+		register_fd(nfct_fd(s->resync), resync_cb, NULL, STATE(fds));
+	fcntl(nfct_fd(s->resync), F_SETFL, O_NONBLOCK);
 
 	if (STATE(mode)->internal->flags & INTERNAL_F_POPULATE) {
-		STATE(dump) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
-					   STATE(ns).cur_fd);
-		if (STATE(dump) == NULL) {
+		s->dump = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+					   s->ns.cur_fd);
+		if (s->dump == NULL) {
 			dlog(LOG_ERR, "can't open netlink handler: %s",
 			     strerror(errno));
 			dlog(LOG_ERR, "no ctnetlink kernel support?");
-			return -1;
+			goto err;
 		}
-		nfct_callback_register(STATE(dump), NFCT_T_ALL,
-				       dump_handler, NULL);
+		nfct_callback_register(s->dump, NFCT_T_ALL, dump_handler,
+				       NULL);
 
 		if (CONFIG(flags) & CTD_EXPECT) {
-			nfexp_callback_register(STATE(dump), NFCT_T_ALL,
+			nfexp_callback_register(s->dump, NFCT_T_ALL,
 						exp_dump_handler, NULL);
 		}
 
-		if (nl_dump_conntrack_table(STATE(dump)) == -1) {
+		if (nl_dump_conntrack_table(s->dump) == -1) {
 			dlog(LOG_ERR, "can't get kernel conntrack table");
-			return -1;
+			goto err;
 		}
 
 		if (CONFIG(flags) & CTD_EXPECT) {
-			if (nl_dump_expect_table(STATE(dump)) == -1) {
+			if (nl_dump_expect_table(s->dump) == -1) {
 				dlog(LOG_ERR, "can't get kernel "
 					      "expect table");
-				return -1;
+				goto err;
 			}
 		}
 	}
 
-	STATE(get) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
-				  STATE(ns).cur_fd);
-	if (STATE(get) == NULL) {
+	s->get = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+				  s->ns.cur_fd);
+	if (s->get == NULL) {
 		dlog(LOG_ERR, "can't open netlink handler: %s",
 		     strerror(errno));
 		dlog(LOG_ERR, "no ctnetlink kernel support?");
-		return -1;
+		goto err;
 	}
-	nfct_callback_register(STATE(get), NFCT_T_ALL, get_handler, NULL);
+	nfct_callback_register(s->get, NFCT_T_ALL, get_handler, s);
 
 	if (CONFIG(flags) & CTD_EXPECT) {
-		nfexp_callback_register(STATE(get), NFCT_T_ALL,
-					exp_get_handler, NULL);
+		nfexp_callback_register(s->get, NFCT_T_ALL,
+					exp_get_handler, s);
 	}
 
-	STATE(flush) = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
-				    STATE(ns).cur_fd);
-	if (STATE(flush) == NULL) {
+	s->flush = ns_nfct_open(CONFIG(netlink).subsys_id, 0,
+				    s->ns.cur_fd);
+	if (s->flush == NULL) {
 		dlog(LOG_ERR, "cannot open flusher handler");
-		return -1;
+		goto err;
 	}
 	/* register this handler as the origin of a flush operation */
-	origin_register(STATE(flush), CTD_ORIGIN_FLUSH);
+	origin_register(s->flush, CTD_ORIGIN_FLUSH);
 
 	if (CONFIG(flags) & CTD_POLL) {
 		init_alarm(&STATE(polling_alarm), NULL, do_polling_alarm);
@@ -511,22 +584,70 @@ int ctnl_init(void)
 		 * populating the internal cache, we may still lose events
 		 * that have occured during the population.
 		 */
-		STATE(event) = nl_init_event_handler();
-		if (STATE(event) == NULL) {
+		s->event = nl_init_event_handler(s->ns.cur_fd);
+		if (s->event == NULL) {
 			dlog(LOG_ERR, "can't open netlink handler: %s",
 			     strerror(errno));
 			dlog(LOG_ERR, "no ctnetlink kernel support?");
-			return -1;
+			goto err;
 		}
-		nfct_callback_register2(STATE(event), NFCT_T_ALL,
-				        event_handler, NULL);
+		nfct_callback_register2(s->event, NFCT_T_ALL,
+				        event_handler, s);
 
 		if (CONFIG(flags) & CTD_EXPECT) {
-			nfexp_callback_register2(STATE(event), NFCT_T_ALL,
-						 exp_event_handler, NULL);
+			nfexp_callback_register2(s->event, NFCT_T_ALL,
+						 exp_event_handler, s);
 		}
-		register_fd(nfct_fd(STATE(event)), event_cb, NULL, STATE(fds));
+		register_fd(nfct_fd(s->event), event_cb, s, STATE(fds));
+	}
+
+
+
+
+
+	/* handler to directly inject conntracks into kernel-space */
+	s->inject = ns_nfct_open(CONFIG(netlink).subsys_id, 0, s->ns.cur_fd);
+	if (s->inject == NULL) {
+		dlog(LOG_ERR, "can't open netlink handler: %s",
+		     strerror(errno));
+		dlog(LOG_ERR, "no ctnetlink kernel support?");
+		goto err;
+	}
+	/* we are directly injecting the entries into the kernel */
+	origin_register(s->inject, CTD_ORIGIN_INJECT);
+
+	s->channel = STATE_SYNC(channel);
+
+	return;
+err:
+	destroy_state(s->nsid);
+free_mem:
+	free(s);
+}
+
+int ctnl_init(void)
+{
+	if (ns_init() == -1)
+		return -1;
+
+	if (CONFIG(flags) & CTD_STATS_MODE)
+		STATE(mode) = &stats_mode;
+	else if (CONFIG(flags) & CTD_SYNC_MODE)
+		STATE(mode) = &sync_mode;
+	else {
+		fprintf(stderr, "WARNING: No running mode specified. "
+				"Defaulting to statistics mode.\n");
+		CONFIG(flags) |= CTD_STATS_MODE;
+		STATE(mode) = &stats_mode;
+	}
+
+	/* Initialization */
+	if (STATE(mode)->init() == -1) {
+		dlog(LOG_ERR, "initialization failed");
+		return -1;
 	}
 
+	//create_state();
+
 	return 0;
 }
diff --git a/src/external_cache.c b/src/external_cache.c
index e290249..202766d 100644
--- a/src/external_cache.c
+++ b/src/external_cache.c
@@ -54,7 +54,7 @@ static void external_cache_close(void)
 	cache_destroy(external_exp);
 }
 
-static void external_cache_ct_new(struct nf_conntrack *ct)
+static void external_cache_ct_new(struct nf_conntrack *ct, struct ns_state *ns)
 {
 	struct cache_object *obj;
 	int id;
@@ -77,12 +77,12 @@ retry:
 	}
 }
 
-static void external_cache_ct_upd(struct nf_conntrack *ct)
+static void external_cache_ct_upd(struct nf_conntrack *ct, struct ns_state *ns)
 {
 	cache_update_force(external, ct);
 }
 
-static void external_cache_ct_del(struct nf_conntrack *ct)
+static void external_cache_ct_del(struct nf_conntrack *ct, struct ns_state *ns)
 {
 	struct cache_object *obj;
 	int id;
@@ -119,7 +119,7 @@ static void external_cache_ct_stats_ext(int fd)
 	cache_stats_extended(external, fd);
 }
 
-static void external_cache_exp_new(struct nf_expect *exp)
+static void external_cache_exp_new(struct nf_expect *exp, struct ns_state *ns)
 {
 	struct cache_object *obj;
 	int id;
@@ -142,12 +142,12 @@ retry:
 	}
 }
 
-static void external_cache_exp_upd(struct nf_expect *exp)
+static void external_cache_exp_upd(struct nf_expect *exp, struct ns_state *ns)
 {
 	cache_update_force(external_exp, exp);
 }
 
-static void external_cache_exp_del(struct nf_expect *exp)
+static void external_cache_exp_del(struct nf_expect *exp, struct ns_state *ns)
 {
 	struct cache_object *obj;
 	int id;
diff --git a/src/external_inject.c b/src/external_inject.c
index 1a65fa3..3d8c4b9 100644
--- a/src/external_inject.c
+++ b/src/external_inject.c
@@ -29,8 +29,6 @@
 #include <errno.h>
 #include <stdlib.h>
 
-static struct nfct_handle *inject;
-
 struct {
 	uint32_t	add_ok;
 	uint32_t	add_fail;
@@ -42,34 +40,22 @@ struct {
 
 static int external_inject_init(void)
 {
-	/* handler to directly inject conntracks into kernel-space */
-	inject = ns_nfct_open(CONFIG(netlink).subsys_id, 0, STATE(ns).cur_fd);
-	if (inject == NULL) {
-		dlog(LOG_ERR, "can't open netlink handler: %s",
-		     strerror(errno));
-		dlog(LOG_ERR, "no ctnetlink kernel support?");
-		return -1;
-	}
-	/* we are directly injecting the entries into the kernel */
-	origin_register(inject, CTD_ORIGIN_INJECT);
 	return 0;
 }
 
 static void external_inject_close(void)
 {
-	origin_unregister(inject);
-	nfct_close(inject);
 }
 
-static void external_inject_ct_new(struct nf_conntrack *ct)
+static void external_inject_ct_new(struct nf_conntrack *ct,
+				   struct ns_state *ns)
 {
 	int ret, retry = 1;
-
 retry:
-	if (nl_create_conntrack(inject, ct, 0) == -1) {
+	if (nl_create_conntrack(ns->inject, ct, 0) == -1) {
 		/* if the state entry exists, we delete and try again */
 		if (errno == EEXIST && retry == 1) {
-			ret = nl_destroy_conntrack(inject, ct);
+			ret = nl_destroy_conntrack(ns->inject, ct);
 			if (ret == 0 || (ret == -1 && errno == ENOENT)) {
 				if (retry) {
 					retry = 0;
@@ -89,19 +75,20 @@ retry:
 	}
 }
 
-static void external_inject_ct_upd(struct nf_conntrack *ct)
+static void external_inject_ct_upd(struct nf_conntrack *ct,
+				   struct ns_state *ns)
 {
 	int ret;
 
 	/* if we successfully update the entry, everything is OK */
-	if (nl_update_conntrack(inject, ct, 0) != -1) {
+	if (nl_update_conntrack(ns->inject, ct, 0) != -1) {
 		external_inject_stat.upd_ok++;
 		return;
 	}
 
 	/* state entries does not exist, we have to create it */
 	if (errno == ENOENT) {
-		if (nl_create_conntrack(inject, ct, 0) == -1) {
+		if (nl_create_conntrack(ns->inject, ct, 0) == -1) {
 			external_inject_stat.upd_fail++;
 			dlog(LOG_ERR, "inject-upd1: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
@@ -114,9 +101,9 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 	/* we failed to update the entry, there are some operations that
 	 * may trigger this error, eg. unset some status bits. Try harder,
 	 * delete the existing entry and create a new one. */
-	ret = nl_destroy_conntrack(inject, ct);
+	ret = nl_destroy_conntrack(ns->inject, ct);
 	if (ret == 0 || (ret == -1 && errno == ENOENT)) {
-		if (nl_create_conntrack(inject, ct, 0) == -1) {
+		if (nl_create_conntrack(ns->inject, ct, 0) == -1) {
 			external_inject_stat.upd_fail++;
 			dlog(LOG_ERR, "inject-upd2: %s", strerror(errno));
 			dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
@@ -130,9 +117,10 @@ static void external_inject_ct_upd(struct nf_conntrack *ct)
 	dlog_ct(STATE(log), ct, NFCT_O_PLAIN);
 }
 
-static void external_inject_ct_del(struct nf_conntrack *ct)
+static void external_inject_ct_del(struct nf_conntrack *ct,
+				   struct ns_state *ns)
 {
-	if (nl_destroy_conntrack(inject, ct) == -1) {
+	if (nl_destroy_conntrack(ns->inject, ct) == -1) {
 		if (errno != ENOENT) {
 			external_inject_stat.del_fail++;
 			dlog(LOG_ERR, "inject-del: %s", strerror(errno));
@@ -185,15 +173,16 @@ struct {
 	uint32_t	del_fail;
 } exp_external_inject_stat;
 
-static void external_inject_exp_new(struct nf_expect *exp)
+static void external_inject_exp_new(struct nf_expect *exp,
+				    struct ns_state *ns)
 {
 	int ret, retry = 1;
 
 retry:
-	if (nl_create_expect(inject, exp, 0) == -1) {
+	if (nl_create_expect(ns->inject, exp, 0) == -1) {
 		/* if the state entry exists, we delete and try again */
 		if (errno == EEXIST && retry == 1) {
-			ret = nl_destroy_expect(inject, exp);
+			ret = nl_destroy_expect(ns->inject, exp);
 			if (ret == 0 || (ret == -1 && errno == ENOENT)) {
 				if (retry) {
 					retry = 0;
@@ -213,9 +202,10 @@ retry:
 	}
 }
 
-static void external_inject_exp_del(struct nf_expect *exp)
+static void external_inject_exp_del(struct nf_expect *exp,
+				    struct ns_state *ns)
 {
-	if (nl_destroy_expect(inject, exp) == -1) {
+	if (nl_destroy_expect(ns->inject, exp) == -1) {
 		if (errno != ENOENT) {
 			exp_external_inject_stat.del_fail++;
 			dlog(LOG_ERR, "inject-del: %s", strerror(errno));
diff --git a/src/internal_bypass.c b/src/internal_bypass.c
index 5768d7b..73d23fa 100644
--- a/src/internal_bypass.c
+++ b/src/internal_bypass.c
@@ -111,7 +111,8 @@ internal_bypass_ct_resync(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
-static void internal_bypass_ct_event_new(struct nf_conntrack *ct, int origin)
+static void internal_bypass_ct_event_new(struct nf_conntrack *ct, int origin,
+					 struct ns_state *s)
 {
 	struct nethdr *net;
 
@@ -119,12 +120,13 @@ static void internal_bypass_ct_event_new(struct nf_conntrack *ct, int origin)
 	if (origin != CTD_ORIGIN_NOT_ME)
 		return;
 
-	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_NEW);
-	multichannel_send(STATE_SYNC(channel), net);
+	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_NEW, s->nsid);
+	multichannel_send(s->channel, net);
 	internal_bypass_stats.new++;
 }
 
-static void internal_bypass_ct_event_upd(struct nf_conntrack *ct, int origin)
+static void internal_bypass_ct_event_upd(struct nf_conntrack *ct, int origin,
+					 struct ns_state *s)
 {
 	struct nethdr *net;
 
@@ -132,12 +134,13 @@ static void internal_bypass_ct_event_upd(struct nf_conntrack *ct, int origin)
 	if (origin != CTD_ORIGIN_NOT_ME)
 		return;
 
-	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_UPD);
-	multichannel_send(STATE_SYNC(channel), net);
+	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_UPD, s->nsid);
+	multichannel_send(s->channel, net);
 	internal_bypass_stats.upd++;
 }
 
-static int internal_bypass_ct_event_del(struct nf_conntrack *ct, int origin)
+static int internal_bypass_ct_event_del(struct nf_conntrack *ct, int origin,
+					struct ns_state *s)
 {
 	struct nethdr *net;
 
@@ -145,8 +148,8 @@ static int internal_bypass_ct_event_del(struct nf_conntrack *ct, int origin)
 	if (origin != CTD_ORIGIN_NOT_ME)
 		return 1;
 
-	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_DEL);
-	multichannel_send(STATE_SYNC(channel), net);
+	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_DEL, s->nsid);
+	multichannel_send(s->channel, net);
 	internal_bypass_stats.del++;
 
 	return 1;
@@ -243,7 +246,8 @@ internal_bypass_exp_resync(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
-static void internal_bypass_exp_event_new(struct nf_expect *exp, int origin)
+static void internal_bypass_exp_event_new(struct nf_expect *exp, int origin,
+					  struct ns_state *s)
 {
 	struct nethdr *net;
 
@@ -251,12 +255,13 @@ static void internal_bypass_exp_event_new(struct nf_expect *exp, int origin)
 	if (origin != CTD_ORIGIN_NOT_ME)
 		return;
 
-	net = BUILD_NETMSG_FROM_EXP(exp, NET_T_STATE_EXP_NEW);
-	multichannel_send(STATE_SYNC(channel), net);
+	net = BUILD_NETMSG_FROM_EXP(exp, NET_T_STATE_EXP_NEW, s->nsid);
+	multichannel_send(s->channel, net);
 	exp_internal_bypass_stats.new++;
 }
 
-static void internal_bypass_exp_event_upd(struct nf_expect *exp, int origin)
+static void internal_bypass_exp_event_upd(struct nf_expect *exp, int origin,
+					  struct ns_state *s)
 {
 	struct nethdr *net;
 
@@ -264,12 +269,13 @@ static void internal_bypass_exp_event_upd(struct nf_expect *exp, int origin)
 	if (origin != CTD_ORIGIN_NOT_ME)
 		return;
 
-	net = BUILD_NETMSG_FROM_EXP(exp, NET_T_STATE_EXP_UPD);
-	multichannel_send(STATE_SYNC(channel), net);
+	net = BUILD_NETMSG_FROM_EXP(exp, NET_T_STATE_EXP_UPD, s->nsid);
+	multichannel_send(s->channel, net);
 	exp_internal_bypass_stats.upd++;
 }
 
-static int internal_bypass_exp_event_del(struct nf_expect *exp, int origin)
+static int internal_bypass_exp_event_del(struct nf_expect *exp, int origin,
+					 struct ns_state *s)
 {
 	struct nethdr *net;
 
@@ -277,8 +283,8 @@ static int internal_bypass_exp_event_del(struct nf_expect *exp, int origin)
 	if (origin != CTD_ORIGIN_NOT_ME)
 		return 1;
 
-	net = BUILD_NETMSG_FROM_EXP(exp, NET_T_STATE_EXP_DEL);
-	multichannel_send(STATE_SYNC(channel), net);
+	net = BUILD_NETMSG_FROM_EXP(exp, NET_T_STATE_EXP_DEL, s->nsid);
+	multichannel_send(s->channel, net);
 	exp_internal_bypass_stats.del++;
 
 	return 1;
diff --git a/src/internal_cache.c b/src/internal_cache.c
index ba2d74b..c3e10f6 100644
--- a/src/internal_cache.c
+++ b/src/internal_cache.c
@@ -139,7 +139,8 @@ internal_cache_ct_resync(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
-static void internal_cache_ct_event_new(struct nf_conntrack *ct, int origin)
+static void internal_cache_ct_event_new(struct nf_conntrack *ct, int origin,
+					struct ns_state *s)
 {
 	struct cache_object *obj;
 	int id;
@@ -176,7 +177,8 @@ retry:
 	}
 }
 
-static void internal_cache_ct_event_upd(struct nf_conntrack *ct, int origin)
+static void internal_cache_ct_event_upd(struct nf_conntrack *ct, int origin,
+					struct ns_state *s)
 {
 	struct cache_object *obj;
 
@@ -192,7 +194,8 @@ static void internal_cache_ct_event_upd(struct nf_conntrack *ct, int origin)
 		sync_send(obj, NET_T_STATE_CT_UPD);
 }
 
-static int internal_cache_ct_event_del(struct nf_conntrack *ct, int origin)
+static int internal_cache_ct_event_del(struct nf_conntrack *ct, int origin,
+				       struct ns_state *s)
 {
 	struct cache_object *obj;
 	int id;
@@ -293,7 +296,8 @@ internal_cache_exp_resync(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
-static void internal_cache_exp_event_new(struct nf_expect *exp, int origin)
+static void internal_cache_exp_event_new(struct nf_expect *exp, int origin,
+					 struct ns_state *s)
 {
 	struct cache_object *obj;
 	int id;
@@ -324,7 +328,8 @@ retry:
 	}
 }
 
-static void internal_cache_exp_event_upd(struct nf_expect *exp, int origin)
+static void internal_cache_exp_event_upd(struct nf_expect *exp, int origin,
+					 struct ns_state *s)
 {
 	struct cache_object *obj;
 
@@ -340,7 +345,8 @@ static void internal_cache_exp_event_upd(struct nf_expect *exp, int origin)
 		sync_send(obj, NET_T_STATE_EXP_UPD);
 }
 
-static int internal_cache_exp_event_del(struct nf_expect *exp, int origin)
+static int internal_cache_exp_event_del(struct nf_expect *exp, int origin,
+					struct ns_state *s)
 {
 	struct cache_object *obj;
 	int id;
diff --git a/src/local.c b/src/local.c
index feff608..09cc2d2 100644
--- a/src/local.c
+++ b/src/local.c
@@ -138,7 +138,9 @@ void local_step(char *buf)
 
 int do_local_request(int request,
 		     struct local_conf *conf,
-		     void (*step)(char *buf))
+		     void (*step)(char *buf),
+		     const char *buffer,
+		     int buflen)
 {
 	int fd, ret;
 
@@ -149,7 +151,11 @@ int do_local_request(int request,
 	ret = send(fd, &request, sizeof(int), 0);
 	if (ret == -1)
 		return -1;
-
+	if (buflen) {
+		ret = send(fd, buffer, buflen, 0);
+		if (ret == -1)
+			return -1;
+	}
 	do_local_client_step(fd, step);
 
 	local_client_destroy(fd);
diff --git a/src/main.c b/src/main.c
index 831a3c2..1593784 100644
--- a/src/main.c
+++ b/src/main.c
@@ -119,6 +119,9 @@ int main(int argc, char *argv[])
 	int type = 0;
 	struct utsname u;
 	int version, major, minor;
+	const char *buffer = NULL;
+	int buflen = 0;
+	struct ns_conf c;
 
 	/* Check kernel version: it must be >= 2.6.18 */
 	if (uname(&u) == -1) {
@@ -133,6 +136,45 @@ int main(int argc, char *argv[])
 
 	for (i=1; i<argc; i++) {
 		switch(argv[i][1]) {
+		case 'A':
+			set_operation_mode(&type, REQUEST, argv);
+			action = ADD_NAMESPACE;
+			if (i + 2 >= argc) {
+				fprintf(stderr, "Not enough parameters to "
+					"create namespace");
+				exit(EXIT_FAILURE);
+			}
+			if (strlen(argv[i+1]) >= NAMESPACE_ID_MAXLEN) {
+				fprintf(stderr, "Namespace ID too long");
+				exit(EXIT_FAILURE);
+			}
+			strncpy(c.namespace_id, argv[i+1], FILENAME_MAXLEN);
+			if (strlen(argv[i+2]) >= FILENAME_MAXLEN) {
+				fprintf(stderr, "Path to namespace too long");
+				exit(EXIT_FAILURE);
+			}
+			strncpy(c.netlink_namespace, argv[i+2], FILENAME_MAXLEN);
+			i += 2;
+			buffer = (const char *) &c;
+			buflen = sizeof(struct ns_conf);
+			break;
+		case 'D':
+			set_operation_mode(&type, REQUEST, argv);
+			action = DEL_NAMESPACE;
+			if (i + 1 >= argc) {
+				fprintf(stderr, "Not enough parameters to "
+					"delete namespace");
+				exit(EXIT_FAILURE);
+			}
+			if (strlen(argv[i+1]) >= NAMESPACE_ID_MAXLEN) {
+				fprintf(stderr, "Namespace ID too long");
+				exit(EXIT_FAILURE);
+			}
+			strncpy(c.namespace_id, argv[i+1], FILENAME_MAXLEN);
+			i += 1;
+			buffer = (const char *) &c;
+			buflen = sizeof(struct ns_conf);
+			break;
 		case 'd':
 			set_operation_mode(&type, DAEMON, argv);
 			break;
@@ -328,7 +370,8 @@ int main(int argc, char *argv[])
 	}
 
 	if (type == REQUEST) {
-		if (do_local_request(action, &conf.local, local_step) == -1) {
+		if (do_local_request(action, &conf.local, local_step, buffer,
+				     buflen) == -1) {
 			fprintf(stderr, "can't connect: is conntrackd "
 					"running? appropriate permissions?\n");
 			exit(EXIT_FAILURE);
diff --git a/src/namespace.c b/src/namespace.c
index 3a79364..ac6ef4a 100644
--- a/src/namespace.c
+++ b/src/namespace.c
@@ -30,8 +30,11 @@
 #include <sys/stat.h>
 #include <unistd.h>
 
+#include "jhash.h"
 #include "log.h"
 
+struct hashtable *ns_table;
+
 #ifndef HAVE_SETNS
 static int setns(int fd, int nstype) {
 #ifdef __NR_setns
@@ -43,6 +46,19 @@ static int setns(int fd, int nstype) {
 }
 #endif /* HAVE_SETNS */
 
+
+static uint32_t ns_hash(const void *data, const struct hashtable *table)
+{
+	const char *f = data;
+	return jhash(f, strlen(f), 0) % table->hashsize;
+}
+
+static int ns_cmp(const void *data1, const void *data2)
+{
+	const struct ns_state *f1 = data1;
+	return !strcmp(f1->nsid, data2);
+}
+
 static int
 ctd_change_namespace(int fd)
 {
@@ -67,12 +83,6 @@ static int do_ns_init(void)
 				strerror(errno));
 		return -1;
 	}
-	STATE(ns).root_fd = open("/proc/self/ns/net", O_RDONLY);
-	if (STATE(ns).root_fd == -1) {
-		dlog(LOG_WARNING, "couldn't open root namespace: %s",
-				strerror(errno));
-		return -1;
-	}
 	return 0;
 }
 
@@ -83,6 +93,15 @@ int ns_init(void)
 	STATE(ns).root_fd = -1;
 	STATE(ns).cur_fd = -1;
 
+	STATE(ns).root_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (STATE(ns).root_fd == -1) {
+		dlog(LOG_WARNING, "couldn't open root namespace: %s",
+				strerror(errno));
+		return -1;
+	}
+
+	ns_table = hashtable_create(1024, 4096, ns_hash, ns_cmp);
+
 	if (!CONFIG(netlink_namespace)[0])
 		return 0;
 #ifndef HAVE_SETNS
@@ -103,7 +122,7 @@ struct nfct_handle *ns_nfct_open(u_int8_t subsys_id, unsigned subscriptions,
 		return NULL;
 
 	handle = nfct_open(subsys_id, subscriptions);
-	if (ctd_change_namespace(STATE(ns).root_fd) < 0) {
+	if (ns_fd != -1 && ctd_change_namespace(STATE(ns).root_fd) < 0) {
 		if (handle)
 			nfct_close(handle);
 		return NULL;
@@ -118,7 +137,7 @@ struct mnl_socket *ns_mnl_socket_open(int bus, int ns_fd)
 	if (ctd_change_namespace(ns_fd) < 0)
 		return NULL;
 	handle = mnl_socket_open(bus);
-	if (ctd_change_namespace(STATE(ns).root_fd) < 0) {
+	if (ns_fd != -1 && ctd_change_namespace(STATE(ns).root_fd) < 0) {
 		if (handle)
 			mnl_socket_close(handle);
 		return NULL;
diff --git a/src/netlink.c b/src/netlink.c
index cd8fcb4..5e88cdb 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -30,12 +30,11 @@
 #include <sys/fcntl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack_tcp.h>
 
-struct nfct_handle *nl_init_event_handler(void)
+struct nfct_handle *nl_init_event_handler(int fd)
 {
 	struct nfct_handle *h;
 
-	h = ns_nfct_open(CONFIG(netlink).subsys_id, CONFIG(netlink).groups,
-			 STATE(ns).cur_fd);
+	h = ns_nfct_open(CONFIG(netlink).subsys_id, CONFIG(netlink).groups, fd);
 	if (h == NULL)
 		return NULL;
 
diff --git a/src/parse.c b/src/parse.c
index 8ce4495..2e8b015 100644
--- a/src/parse.c
+++ b/src/parse.c
@@ -17,9 +17,11 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "conntrackd.h"
 #include "network.h"
 
 #include <stdlib.h>
+#include <string.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 #ifndef ssizeof
@@ -180,6 +182,11 @@ static struct ct_parser h[NTA_MAX] = {
 		.attr	= ATTR_HELPER_NAME,
 		.max_size = NFCT_HELPER_NAME_MAX,
 	},
+	[NTA_NAMESPACE] = {
+		.parse	= ct_parse_str,
+		.attr	= 0,
+		.max_size = NAMESPACE_ID_MAXLEN,
+	},
 };
 
 static void
@@ -233,11 +240,12 @@ ct_parse_nat_seq_adj(struct nf_conntrack *ct, int attr, void *data)
 			  ntohl(this->repl_seq_offset_after));
 }
 
-int msg2ct(struct nf_conntrack *ct, struct nethdr *net, size_t remain)
+int msg2ct(struct nf_conntrack *ct, struct nethdr *net, size_t remain, char *ns)
 {
 	int len;
 	struct netattr *attr;
 
+	ns[0] = 0;
 	if (remain < net->len)
 		return -1;
 
@@ -260,7 +268,11 @@ int msg2ct(struct nf_conntrack *ct, struct nethdr *net, size_t remain)
 			attr = NTA_NEXT(attr, len);
 			continue;
 		}
-		h[attr->nta_attr].parse(ct, attr->nta_attr, NTA_DATA(attr));
+		if (attr->nta_attr == NTA_NAMESPACE)
+			strncpy(ns, (char*)NTA_DATA(attr), NAMESPACE_ID_MAXLEN);
+		else
+			h[attr->nta_attr].parse(ct, attr->nta_attr,
+						NTA_DATA(attr));
 		attr = NTA_NEXT(attr, len);
 	}
 
@@ -423,12 +435,13 @@ static void exp_parse_str(void *exp, int attr, void *data)
 	nfexp_set_attr(exp, exp_h[attr].exp_attr, data);
 }
 
-int msg2exp(struct nf_expect *exp, struct nethdr *net, size_t remain)
+int msg2exp(struct nf_expect *exp, struct nethdr *net, size_t remain, char *ns)
 {
 	int len;
 	struct netattr *attr;
 	struct nf_conntrack *master, *expected, *mask, *nat;
 
+	ns[0] = 0;
 	if (remain < net->len)
 		return -1;
 
diff --git a/src/stats-mode.c b/src/stats-mode.c
index 6b7f08d..5e5b3d9 100644
--- a/src/stats-mode.c
+++ b/src/stats-mode.c
@@ -143,7 +143,7 @@ static void stats_purge(void)
 	cache_iterate(STATE_STATS(cache), NULL, purge_step);
 }
 
-static void stats_event_new(struct nf_conntrack *ct, int origin)
+static void stats_event_new(struct nf_conntrack *ct, int origin, struct ns_state *s)
 {
 	int id;
 	struct cache_object *obj;
@@ -164,13 +164,13 @@ static void stats_event_new(struct nf_conntrack *ct, int origin)
 	return;
 }
 
-static void stats_event_upd(struct nf_conntrack *ct, int origin)
+static void stats_event_upd(struct nf_conntrack *ct, int origin, struct ns_state *s)
 {
 	nfct_attr_unset(ct, ATTR_TIMEOUT);
 	cache_update_force(STATE_STATS(cache), ct);
 }
 
-static int stats_event_del(struct nf_conntrack *ct, int origin)
+static int stats_event_del(struct nf_conntrack *ct, int origin, struct ns_state *s)
 {
 	int id;
 	struct cache_object *obj;
diff --git a/src/sync-alarm.c b/src/sync-alarm.c
index acaf5e6..ef449d7 100644
--- a/src/sync-alarm.c
+++ b/src/sync-alarm.c
@@ -137,7 +137,7 @@ static int tx_queue_xmit(struct queue_node *n, const void *data)
 
 		ca = (struct cache_alarm *)n;
 		type = object_status_to_network_type(ca->obj);
-		net = ca->obj->cache->ops->build_msg(ca->obj, type);
+		net = ca->obj->cache->ops->build_msg(ca->obj, type, "BUG");
 		multichannel_send(STATE_SYNC(channel), net);
 		cache_object_put(ca->obj);
 		break;
diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index 1bc2d9f..7e5236d 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -57,6 +57,7 @@ struct cache_ftfw {
 	struct queue_node	qnode;
 	struct cache_object	*obj;
 	uint32_t 		seq;
+	uint32_t		nsid;
 };
 
 static void cache_ftfw_add(struct cache_object *obj, void *data)
@@ -518,7 +519,7 @@ static int tx_queue_xmit(struct queue_node *n, const void *data)
 
 		cn = (struct cache_ftfw *)n;
 		type = object_status_to_network_type(cn->obj);
-		net = cn->obj->cache->ops->build_msg(cn->obj, type);
+		net = cn->obj->cache->ops->build_msg(cn->obj, type, "BUG");
 		nethdr_set_hello(net);
 
 		dp("tx_list sq: %u fl:%u len:%u\n",
diff --git a/src/sync-mode.c b/src/sync-mode.c
index a7cd283..bcda4c2 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -42,7 +42,7 @@
 #include <net/if.h>
 #include <fcntl.h>
 
-static struct nf_conntrack *msg2ct_alloc(struct nethdr *net, size_t remain)
+static struct nf_conntrack *msg2ct_alloc(struct nethdr *net, size_t remain, char *ns)
 {
 	struct nf_conntrack *ct;
 
@@ -51,7 +51,9 @@ static struct nf_conntrack *msg2ct_alloc(struct nethdr *net, size_t remain)
 	if (ct == NULL)
 		return NULL;
 
-	if (msg2ct(ct, net, remain) == -1) {
+	if (msg2ct(ct, net, remain, ns) == -1) {
+		dlog(LOG_ERR, ">>>?1.75");
+
 		STATE_SYNC(error).msg_rcv_malformed++;
 		STATE_SYNC(error).msg_rcv_bad_payload++;
 		nfct_destroy(ct);
@@ -60,7 +62,7 @@ static struct nf_conntrack *msg2ct_alloc(struct nethdr *net, size_t remain)
 	return ct;
 }
 
-static struct nf_expect *msg2exp_alloc(struct nethdr *net, size_t remain)
+static struct nf_expect *msg2exp_alloc(struct nethdr *net, size_t remain, char *ns)
 {
 	struct nf_expect *exp;
 
@@ -69,7 +71,7 @@ static struct nf_expect *msg2exp_alloc(struct nethdr *net, size_t remain)
 	if (exp == NULL)
 		return NULL;
 
-	if (msg2exp(exp, net, remain) == -1) {
+	if (msg2exp(exp, net, remain, ns) == -1) {
 		STATE_SYNC(error).msg_rcv_malformed++;
 		STATE_SYNC(error).msg_rcv_bad_payload++;
 		nfexp_destroy(exp);
@@ -83,6 +85,9 @@ do_channel_handler_step(struct channel *c, struct nethdr *net, size_t remain)
 {
 	struct nf_conntrack *ct = NULL;
 	struct nf_expect *exp = NULL;
+	char ns[NAMESPACE_ID_MAXLEN];
+	int ns_id;
+	struct	ns_state *ns_s;
 
 	if (net->version != CONNTRACKD_PROTOCOL_VERSION) {
 		STATE_SYNC(error).msg_rcv_malformed++;
@@ -115,46 +120,53 @@ do_channel_handler_step(struct channel *c, struct nethdr *net, size_t remain)
 
 	switch(net->type) {
 	case NET_T_STATE_CT_NEW:
-		ct = msg2ct_alloc(net, remain);
-		if (ct == NULL)
-			return;
-		STATE_SYNC(external)->ct.new(ct);
-		break;
 	case NET_T_STATE_CT_UPD:
-		ct = msg2ct_alloc(net, remain);
-		if (ct == NULL)
-			return;
-		STATE_SYNC(external)->ct.upd(ct);
-		break;
 	case NET_T_STATE_CT_DEL:
-		ct = msg2ct_alloc(net, remain);
+		ct = msg2ct_alloc(net, remain, ns);
 		if (ct == NULL)
 			return;
-		STATE_SYNC(external)->ct.del(ct);
 		break;
 	case NET_T_STATE_EXP_NEW:
-		exp = msg2exp_alloc(net, remain);
+	case NET_T_STATE_EXP_UPD:
+	case NET_T_STATE_EXP_DEL:
+		exp = msg2exp_alloc(net, remain, ns);
 		if (exp == NULL)
 			return;
-		STATE_SYNC(external)->exp.new(exp);
+		break;
+	}
+	ns_id = hashtable_hash(ns_table, &ns);
+	ns_s = (struct ns_state *) hashtable_find(ns_table, &ns, ns_id);
+
+	if (!ns_s) {
+		dlog(LOG_ERR, "namespace %s not found in hashtable", ns);
+		return;
+	}
+
+	switch(net->type) {
+	case NET_T_STATE_CT_NEW:
+		STATE_SYNC(external)->ct.new(ct, ns_s);
+		break;
+	case NET_T_STATE_CT_UPD:
+		STATE_SYNC(external)->ct.upd(ct, ns_s);
+		break;
+	case NET_T_STATE_CT_DEL:
+		STATE_SYNC(external)->ct.del(ct, ns_s);
+		break;
+	case NET_T_STATE_EXP_NEW:
+		STATE_SYNC(external)->exp.new(exp, ns_s);
 		break;
 	case NET_T_STATE_EXP_UPD:
-		exp = msg2exp_alloc(net, remain);
-		if (exp == NULL)
-			return;
-		STATE_SYNC(external)->exp.upd(exp);
+		STATE_SYNC(external)->exp.upd(exp, ns_s);
 		break;
 	case NET_T_STATE_EXP_DEL:
-		exp = msg2exp_alloc(net, remain);
-		if (exp == NULL)
-			return;
-		STATE_SYNC(external)->exp.del(exp);
+		STATE_SYNC(external)->exp.del(exp, ns_s);
 		break;
 	default:
 		STATE_SYNC(error).msg_rcv_malformed++;
 		STATE_SYNC(error).msg_rcv_bad_type++;
 		break;
 	}
+
 	if (ct != NULL)
 		nfct_destroy(ct);
 	if (exp != NULL)
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index 1cc0aac..5ed18fb 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -90,7 +90,7 @@ static int kernel_resync_cb(enum nf_conntrack_msg_type type,
 {
 	struct nethdr *net;
 
-	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_NEW);
+	net = BUILD_NETMSG_FROM_CT(ct, NET_T_STATE_CT_NEW, "BUG");
 	multichannel_send(STATE_SYNC(channel), net);
 
 	return NFCT_CB_CONTINUE;
@@ -204,7 +204,7 @@ static int tx_queue_xmit(struct queue_node *n, const void *data2)
 
 		cn = (struct cache_notrack *)n;
 		type = object_status_to_network_type(cn->obj);
-		net = cn->obj->cache->ops->build_msg(cn->obj, type);
+		net = cn->obj->cache->ops->build_msg(cn->obj, type, "BUG");
 
 		multichannel_send(STATE_SYNC(channel), net);
 		queue_del(n);
@@ -247,6 +247,7 @@ static void tx_queue_add_ctlmsg2(uint32_t flags)
 
 static void do_alive_alarm(struct alarm_block *a, void *data)
 {
+	/* Here we put the keepalive message */
 	tx_queue_add_ctlmsg2(NET_F_ALIVE);
 	add_alarm(&alive_alarm, ALIVE_INT, 0);
 }
-- 
1.7.9.5

