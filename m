From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH] Use attribute to avoid warning about unused parameter.
Date: Thu, 31 Jul 2008 15:50:38 +0200
Message-ID: <1217512238-26173-1-git-send-email-eric@inl.fr>
References: <48918F6D.8040307@trash.net>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:48884 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYGaNus (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 09:50:48 -0400
In-Reply-To: <48918F6D.8040307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Following live discussion with Pierre Chifflier, it appears that the flag
-Wno-unused-parameter is deprecated in gcc and has to be replaced by an
attribute: __attribute__ ((unused)).

The following patch fixes all warnings related to unused parameters by
correctly settings the attribute in all unused function parameters. This
is mainly the case for callback functions. It uses a macro named UNUSED
which is simply defined as __attribute__((unused)).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/ulogd_filter_IFINDEX.c     |    6 +++---
 filter/ulogd_filter_MARK.c        |    2 +-
 include/ulogd/linuxlist.h         |    2 +-
 include/ulogd/ulogd.h             |    4 ++++
 input/flow/ulogd_inpflow_NFCT.c   |   12 ++++++------
 input/packet/ulogd_inppkt_NFLOG.c |    4 ++--
 input/packet/ulogd_inppkt_ULOG.c  |    4 ++--
 output/pcap/ulogd_output_PCAP.c   |    2 +-
 output/pgsql/ulogd_output_PGSQL.c |    6 +++---
 output/ulogd_output_LOGEMU.c      |    2 +-
 output/ulogd_output_NACCT.c       |    2 +-
 output/ulogd_output_OPRINT.c      |    2 +-
 output/ulogd_output_SYSLOG.c      |    6 +++---
 util/db.c                         |    4 ++--
 14 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/filter/ulogd_filter_IFINDEX.c b/filter/ulogd_filter_IFINDEX.c
index f7571bd..21eb00f 100644
--- a/filter/ulogd_filter_IFINDEX.c
+++ b/filter/ulogd_filter_IFINDEX.c
@@ -79,7 +79,7 @@ static int interp_ifindex(struct ulogd_pluginstance *pi)
 	return ULOGD_IRET_OK;
 }
 
-static int nlif_read_cb(int fd, unsigned int what, void *param)
+static int nlif_read_cb(UNUSED int fd, unsigned int what, UNUSED void *param)
 {
 	if (!(what & ULOGD_FD_READ))
 		return 0;
@@ -87,7 +87,7 @@ static int nlif_read_cb(int fd, unsigned int what, void *param)
 	return nlif_catch(nlif_inst);
 }
 
-static int ifindex_start(struct ulogd_pluginstance *upi)
+static int ifindex_start(UNUSED struct ulogd_pluginstance *upi)
 {
 	int rc;
 
@@ -120,7 +120,7 @@ out_nlif:
 	return rc;
 }
 
-static int ifindex_fini(struct ulogd_pluginstance *upi)
+static int ifindex_fini(UNUSED struct ulogd_pluginstance *upi)
 {
 	if (--nlif_users == 0) {
 		ulogd_unregister_fd(&nlif_u_fd);
diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index 98f5dae..31f69f8 100644
--- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -90,7 +90,7 @@ static int interp_mark(struct ulogd_pluginstance *pi)
 }
 
 static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
+		     UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
 		  "plugin `%s'\n", upi->id, upi->plugin->name);
diff --git a/include/ulogd/linuxlist.h b/include/ulogd/linuxlist.h
index a89375e..8c26b10 100644
--- a/include/ulogd/linuxlist.h
+++ b/include/ulogd/linuxlist.h
@@ -7,7 +7,7 @@
 #define inline __inline__
 #endif
 
-static inline void prefetch(const void *x) {;}
+static inline void prefetch(__attribute__((unused)) const void *x) {;}
 
 /**
  * container_of - cast a member of a structure out to the containing structure
diff --git a/include/ulogd/ulogd.h b/include/ulogd/ulogd.h
index 776111a..1ca2376 100644
--- a/include/ulogd/ulogd.h
+++ b/include/ulogd/ulogd.h
@@ -266,4 +266,8 @@ int ulogd_select_main(struct timeval *tv);
 #define IPPROTO_UDPLITE 136
 #endif
 
+#ifndef UNUSED
+#define UNUSED __attribute__((unused))
+#endif
+
 #endif /* _ULOGD_H */
diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 58bb0e2..e662d19 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -703,7 +703,7 @@ static int setnlbufsiz(struct ulogd_pluginstance *upi, int size)
 	return 0;
 }
 
-static int read_cb_nfct(int fd, unsigned int what, void *param)
+static int read_cb_nfct(UNUSED int fd, unsigned int what, void *param)
 {
 	struct nfct_pluginstance *cpi = (struct nfct_pluginstance *) param;
 	struct ulogd_pluginstance *upi = container_of(param,
@@ -764,7 +764,7 @@ static int do_purge(void *data1, void *data2)
 	return 0;
 }
 
-static int overrun_handler(enum nf_conntrack_msg_type type,
+static int overrun_handler(UNUSED enum nf_conntrack_msg_type type,
 			   struct nf_conntrack *ct,
 			   void *data)
 {
@@ -785,7 +785,7 @@ static int overrun_handler(enum nf_conntrack_msg_type type,
 	return NFCT_CB_CONTINUE;
 }
 
-static int read_cb_ovh(int fd, unsigned int what, void *param)
+static int read_cb_ovh(UNUSED int fd, unsigned int what, void *param)
 {
 	struct nfct_pluginstance *cpi = (struct nfct_pluginstance *) param;
 	struct ulogd_pluginstance *upi = container_of(param,
@@ -822,7 +822,7 @@ static int get_ctr_zero(struct ulogd_pluginstance *upi)
 	return nfct_query(cpi->cth, NFCT_Q_DUMP_RESET, &family);
 }
 
-static void getctr_timer_cb(struct ulogd_timer *t, void *data)
+static void getctr_timer_cb(UNUSED struct ulogd_timer *t, void *data)
 {
 	struct ulogd_pluginstance *upi = data;
 	struct nfct_pluginstance *cpi =
@@ -833,7 +833,7 @@ static void getctr_timer_cb(struct ulogd_timer *t, void *data)
 }
 
 static int configure_nfct(struct ulogd_pluginstance *upi,
-			  struct ulogd_pluginstance_stack *stack)
+			  UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	struct nfct_pluginstance *cpi =
 			(struct nfct_pluginstance *)upi->private;
@@ -851,7 +851,7 @@ static int configure_nfct(struct ulogd_pluginstance *upi,
 	return 0;
 }
 
-static void overrun_timeout(struct ulogd_timer *a, void *data)
+static void overrun_timeout(UNUSED struct ulogd_timer *a, void *data)
 {
 	int family = AF_UNSPEC;
 	struct ulogd_pluginstance *upi = data;
diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index ed01f04..a2e8625 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -480,7 +480,7 @@ static int nful_read_cb(int fd, unsigned int what, void *param)
 }
 
 /* callback called by libnfnetlink* for every nlmsg */
-static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
+static int msg_cb(UNUSED struct nflog_g_handle *gh, UNUSED struct nfgenmsg *nfmsg,
 		  struct nflog_data *nfa, void *data)
 {
 	struct ulogd_pluginstance *upi = data;
@@ -498,7 +498,7 @@ static int msg_cb(struct nflog_g_handle *gh, struct nfgenmsg *nfmsg,
 }
 
 static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
+		     UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	ulogd_log(ULOGD_DEBUG, "parsing config file section `%s', "
 		  "plugin `%s'\n", upi->id, upi->plugin->name);
diff --git a/input/packet/ulogd_inppkt_ULOG.c b/input/packet/ulogd_inppkt_ULOG.c
index 3fdb42e..b742532 100644
--- a/input/packet/ulogd_inppkt_ULOG.c
+++ b/input/packet/ulogd_inppkt_ULOG.c
@@ -243,7 +243,7 @@ static int interp_packet(struct ulogd_pluginstance *ip, ulog_packet_msg_t *pkt)
 	return 0;
 }
 
-static int ulog_read_cb(int fd, unsigned int what, void *param)
+static int ulog_read_cb(UNUSED int fd, unsigned int what, void *param)
 {
 	struct ulogd_pluginstance *upi = (struct ulogd_pluginstance *)param;
 	struct ulogd_pluginstance *npi = NULL;
@@ -282,7 +282,7 @@ static int ulog_read_cb(int fd, unsigned int what, void *param)
 }
 
 static int configure(struct ulogd_pluginstance *upi,
-		     struct ulogd_pluginstance_stack *stack)
+		     UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	return config_parse_file(upi->id, upi->config_kset);
 }
diff --git a/output/pcap/ulogd_output_PCAP.c b/output/pcap/ulogd_output_PCAP.c
index ce4393c..988f025 100644
--- a/output/pcap/ulogd_output_PCAP.c
+++ b/output/pcap/ulogd_output_PCAP.c
@@ -243,7 +243,7 @@ static void signal_pcap(struct ulogd_pluginstance *upi, int signal)
 }
 
 static int configure_pcap(struct ulogd_pluginstance *upi,
-			  struct ulogd_pluginstance_stack *stack)
+			  UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	return config_parse_file(upi->id, upi->config_kset);
 }
diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index afab2cc..a8c201d 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -276,14 +276,14 @@ static int open_db_pgsql(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-static int escape_string_pgsql(struct ulogd_pluginstance *upi,
-			       char *dst, const char *src, unsigned int len)
+static int escape_string_pgsql(UNUSED struct ulogd_pluginstance *upi,
+			       char *dst, const char *src, UNUSED unsigned int len)
 {
 	return PQescapeString(dst, src, strlen(src)); 
 }
 
 static int execute_pgsql(struct ulogd_pluginstance *upi,
-			 const char *stmt, unsigned int len)
+			 const char *stmt, UNUSED unsigned int len)
 {
 	struct pgsql_instance *pi = (struct pgsql_instance *) upi->private;
 
diff --git a/output/ulogd_output_LOGEMU.c b/output/ulogd_output_LOGEMU.c
index edee86f..1604d83 100644
--- a/output/ulogd_output_LOGEMU.c
+++ b/output/ulogd_output_LOGEMU.c
@@ -177,7 +177,7 @@ static int fini_logemu(struct ulogd_pluginstance *pi) {
 }
 
 static int configure_logemu(struct ulogd_pluginstance *pi,
-			    struct ulogd_pluginstance_stack *stack)
+			    UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	/* FIXME: error handling */
 	ulogd_log(ULOGD_DEBUG, "parsing config file section %s\n", pi->id);
diff --git a/output/ulogd_output_NACCT.c b/output/ulogd_output_NACCT.c
index 0ab2be4..8fce403 100644
--- a/output/ulogd_output_NACCT.c
+++ b/output/ulogd_output_NACCT.c
@@ -199,7 +199,7 @@ sighup_handler_print(struct ulogd_pluginstance *pi, int signal)
 
 static int
 nacct_conf(struct ulogd_pluginstance *pi,
-		   struct ulogd_pluginstance_stack *stack)
+		   UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	int ret;
 
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c
index c2fce38..705694c 100644
--- a/output/ulogd_output_OPRINT.c
+++ b/output/ulogd_output_OPRINT.c
@@ -138,7 +138,7 @@ static void sighup_handler_print(struct ulogd_pluginstance *upi, int signal)
 }
 
 static int oprint_configure(struct ulogd_pluginstance *upi,
-			    struct ulogd_pluginstance_stack *stack)
+			    UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	int ret;
 
diff --git a/output/ulogd_output_SYSLOG.c b/output/ulogd_output_SYSLOG.c
index 1812cb0..3098c78 100644
--- a/output/ulogd_output_SYSLOG.c
+++ b/output/ulogd_output_SYSLOG.c
@@ -83,7 +83,7 @@ static int _output_syslog(struct ulogd_pluginstance *upi)
 }
 		
 static int syslog_configure(struct ulogd_pluginstance *pi,
-			    struct ulogd_pluginstance_stack *stack)
+			    UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	int syslog_facility, syslog_level;
 	char *facility, *level;
@@ -151,14 +151,14 @@ static int syslog_configure(struct ulogd_pluginstance *pi,
 	return 0;
 }
 
-static int syslog_fini(struct ulogd_pluginstance *pi)
+static int syslog_fini(UNUSED struct ulogd_pluginstance *pi)
 {
 	closelog();
 
 	return 0;
 }
 
-static int syslog_start(struct ulogd_pluginstance *pi)
+static int syslog_start(UNUSED struct ulogd_pluginstance *pi)
 {
 	openlog("ulogd", LOG_NDELAY|LOG_PID, LOG_DAEMON);
 
diff --git a/util/db.c b/util/db.c
index 61c31a3..dea0adb 100644
--- a/util/db.c
+++ b/util/db.c
@@ -51,7 +51,7 @@ int ulogd_db_interp(struct ulogd_pluginstance *upi)
 }
 
 /* no connection, plugin disabled */
-static int disabled_interp_db(struct ulogd_pluginstance *upi)
+static int disabled_interp_db(UNUSED struct ulogd_pluginstance *upi)
 {
 	return 0;
 }
@@ -103,7 +103,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 static int _init_db(struct ulogd_pluginstance *upi);
 
 int ulogd_db_configure(struct ulogd_pluginstance *upi,
-			struct ulogd_pluginstance_stack *stack)
+			UNUSED struct ulogd_pluginstance_stack *stack)
 {
 	struct db_instance *di = (struct db_instance *) upi->private;
 	int ret;
-- 
1.5.6.2

