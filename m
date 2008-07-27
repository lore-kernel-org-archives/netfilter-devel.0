From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 04/11] Fix warning related to signed unsigned comparison.
Date: Sun, 27 Jul 2008 15:51:19 +0200
Message-ID: <1217166686-28508-5-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43791 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751697AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the warning related to signed and unsigned comparaison.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 filter/raw2packet/ulogd_raw2packet_BASE.c |    2 +-
 filter/ulogd_filter_MARK.c                |    4 ++--
 filter/ulogd_filter_PWSNIFF.c             |    3 ++-
 libipulog/libipulog.c                     |    2 +-
 src/conffile.c                            |    4 ++--
 src/ulogd.c                               |   10 +++++-----
 util/db.c                                 |    4 ++--
 7 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index 7c6fd26..e61d904 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -694,7 +694,7 @@ static int _interp_iphdr(struct ulogd_pluginstance *pi, u_int32_t len)
 		GET_VALUE(pi->input.keys, INKEY_RAW_PCKT).ptr;
 	void *nexthdr = (u_int32_t *)iph + iph->ihl;
 
-	if (len < sizeof(struct iphdr) || len <= iph->ihl * 4)
+	if (len < sizeof(struct iphdr) || len <= (u_int32_t)(iph->ihl * 4))
 		return ULOGD_IRET_OK;
 	len -= iph->ihl * 4;
 
diff --git a/filter/ulogd_filter_MARK.c b/filter/ulogd_filter_MARK.c
index ff31fe5..98f5dae 100644
--- a/filter/ulogd_filter_MARK.c
+++ b/filter/ulogd_filter_MARK.c
@@ -74,14 +74,14 @@ static int interp_mark(struct ulogd_pluginstance *pi)
 	if (pp_is_valid(inp, KEY_CT_MARK)) {
 		if ((GET_VALUE(inp, KEY_CT_MARK).ui32 &
 			pi->config_kset->ces[MARK_MASK].u.value) !=
-			pi->config_kset->ces[MARK_MARK].u.value
+			(u_int32_t) pi->config_kset->ces[MARK_MARK].u.value
 		   ) {
 			return ULOGD_IRET_STOP;
 		}
 	} else if (pp_is_valid(inp, KEY_OOB_MARK)) {
 		if ((GET_VALUE(inp, KEY_OOB_MARK).ui32 &
 			pi->config_kset->ces[MARK_MASK].u.value) !=
-			pi->config_kset->ces[MARK_MARK].u.value
+			(u_int32_t) pi->config_kset->ces[MARK_MARK].u.value
 		   ) {
 			return ULOGD_IRET_STOP;
 		}
diff --git a/filter/ulogd_filter_PWSNIFF.c b/filter/ulogd_filter_PWSNIFF.c
index 290e4cb..3cbafb6 100644
--- a/filter/ulogd_filter_PWSNIFF.c
+++ b/filter/ulogd_filter_PWSNIFF.c
@@ -66,7 +66,8 @@ static int interp_pwsniff(struct ulogd_pluginstance *pi)
 	struct tcphdr *tcph;	
 	unsigned int tcplen;
 	unsigned char  *ptr, *begp, *pw_begp, *endp, *pw_endp;
-	int len, pw_len, i, cont = 0;
+	int len, pw_len, cont = 0;
+	unsigned int i;
 
 	if (!IS_VALID(pi->input.keys[0]))
 		return ULOGD_IRET_STOP;
diff --git a/libipulog/libipulog.c b/libipulog/libipulog.c
index 6b7ea35..2f58ea6 100644
--- a/libipulog/libipulog.c
+++ b/libipulog/libipulog.c
@@ -96,7 +96,7 @@ ipulog_netlink_recvfrom(const struct ipulog_handle *h,
 		return -1;
 	}
 	nlh = (struct nlmsghdr *)buf;
-	if (nlh->nlmsg_flags & MSG_TRUNC || status > len) {
+	if (nlh->nlmsg_flags & MSG_TRUNC || (size_t) status > len) {
 		ipulog_errno = IPULOG_ERR_TRUNC;
 		return -1;
 	}
diff --git a/src/conffile.c b/src/conffile.c
index 72afb8e..0c1a2a4 100644
--- a/src/conffile.c
+++ b/src/conffile.c
@@ -112,7 +112,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 	char *args;
 	int err = 0;
 	int found = 0;
-	int i;
+	unsigned int i;
 	char linebuf[LINE_LEN+1];
 	char *line = linebuf;
 
@@ -147,7 +147,7 @@ int config_parse_file(const char *section, struct config_keyset *kset)
 	/* Parse this section until next section */
 	while (fgets(line, LINE_LEN, cfile))
 	{
-		int i;
+		unsigned int i;
 		char wordbuf[LINE_LEN];
 		char *wordend;
 		
diff --git a/src/ulogd.c b/src/ulogd.c
index 33d58ee..429f472 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -204,7 +204,7 @@ int ulogd_wildcard_inputkeys(struct ulogd_pluginstance *upi)
 
 	/* second pass: copy key names */
 	llist_for_each_entry(pi_cur, &stack->list, list) {
-		int i;
+		unsigned int i;
 
 		for (i = 0; i < pi_cur->plugin->output.num_keys; i++)
 			upi->input.keys[index++] = pi_cur->output.keys[i];
@@ -280,7 +280,7 @@ char *type_to_string(int type)
 
 void get_plugin_infos(struct ulogd_plugin *me)
 {
-	int i;
+	unsigned int i;
 	printf("Name: %s\n", me->name);
 	if (me->config_kset) {
 		printf("Config options:\n");
@@ -453,7 +453,7 @@ static void ulogd_clean_results(struct ulogd_pluginstance *pi)
 
 	/* iterate through plugin stack */
 	llist_for_each_entry(cur, &pi->stack->list, list) {
-		int i;
+		unsigned int i;
 		
 		/* iterate through input keys of pluginstance */
 		for (i = 0; i < cur->output.num_keys; i++) {
@@ -598,7 +598,7 @@ find_okey_in_stack(char *name,
 	struct ulogd_pluginstance *pi;
 
 	llist_for_each_entry_reverse(pi, &start->list, list) {
-		int i;
+		unsigned int i;
 
 		if ((void *)&pi->list == &stack->list)
 			return NULL;
@@ -666,7 +666,7 @@ create_stack_resolve_keys(struct ulogd_pluginstance_stack *stack)
 			}
 			/* no need to match keys */
 		} else {
-			int j;
+			unsigned int j;
 
 			/* not the last one in the stack */
 			if (!(pi_cur->plugin->input.type &
diff --git a/util/db.c b/util/db.c
index 9b4da8d..8e9dde6 100644
--- a/util/db.c
+++ b/util/db.c
@@ -63,7 +63,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *mi = (struct db_instance *) upi->private;
 	unsigned int size;
-	int i;
+	unsigned int i;
 	char *table = table_ce(upi->config_kset).u.string;
 	char *procedure = procedure_ce(upi->config_kset).u.string;
 
@@ -223,7 +223,7 @@ static int _init_db(struct ulogd_pluginstance *upi)
 static int __interp_db(struct ulogd_pluginstance *upi)
 {
 	struct db_instance *di = (struct db_instance *) &upi->private;
-	int i;
+	unsigned int i;
 
 	di->stmt_ins = di->stmt_val;
 
-- 
1.5.4.3

