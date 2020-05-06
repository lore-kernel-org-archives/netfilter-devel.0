Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E8DC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C759206B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgEFRdw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFRdw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:33:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551FDC061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:33:52 -0700 (PDT)
Received: from localhost ([::1]:58702 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNvb-0002iz-3k; Wed, 06 May 2020 19:33:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/15] libxtables: Introduce xtables_fini()
Date:   Wed,  6 May 2020 19:33:27 +0200
Message-Id: <20200506173331.9347-12-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Record handles of loaded shared objects in a linked list and dlclose()
them from the newly introduced function. While functionally not
necessary, this clears up valgrind's memcheck output when also
displaying reachable memory.

Since this is an extra function that doesn't change the existing API,
increment both current and age.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac                      |  4 +--
 include/xtables.h                 |  1 +
 iptables/ip6tables-standalone.c   |  2 ++
 iptables/iptables-restore.c       | 14 +++++++---
 iptables/iptables-save.c          | 14 ++++++++--
 iptables/iptables-standalone.c    |  2 ++
 iptables/xtables-arp-standalone.c |  1 +
 iptables/xtables-eb.c             |  1 +
 iptables/xtables-monitor.c        |  2 ++
 iptables/xtables-restore.c        |  2 ++
 iptables/xtables-save.c           |  1 +
 iptables/xtables-standalone.c     |  1 +
 iptables/xtables-translate.c      |  2 ++
 libxtables/xtables.c              | 44 ++++++++++++++++++++++++++++++-
 14 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 27e90703c9ada..02f6481ca52ed 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.8.4])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=14
-libxtables_vage=2
+libxtables_vcurrent=15
+libxtables_vage=3
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/xtables.h b/include/xtables.h
index 4aa084a1a2a30..5044dd08e86d3 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -448,6 +448,7 @@ extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
 
 extern void xtables_init(void);
+extern void xtables_fini(void);
 extern void xtables_set_nfproto(uint8_t);
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
diff --git a/iptables/ip6tables-standalone.c b/iptables/ip6tables-standalone.c
index 35d2d9a51f575..105b83ba54010 100644
--- a/iptables/ip6tables-standalone.c
+++ b/iptables/ip6tables-standalone.c
@@ -64,6 +64,8 @@ ip6tables_main(int argc, char *argv[])
 		ip6tc_free(handle);
 	}
 
+	xtables_fini();
+
 	if (!ret) {
 		if (errno == EINVAL) {
 			fprintf(stderr, "ip6tables: %s. "
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index b0a51d491c508..1edad82fc8842 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -370,7 +370,7 @@ static const struct iptables_restore_cb ipt_restore_cb = {
 int
 iptables_restore_main(int argc, char *argv[])
 {
-	int c;
+	int c, ret;
 
 	iptables_globals.program_name = "iptables-restore";
 	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
@@ -385,7 +385,10 @@ iptables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	return ip46tables_restore_main(&ipt_restore_cb, argc, argv);
+	ret = ip46tables_restore_main(&ipt_restore_cb, argc, argv);
+
+	xtables_fini();
+	return ret;
 }
 #endif
 
@@ -401,7 +404,7 @@ static const struct iptables_restore_cb ip6t_restore_cb = {
 int
 ip6tables_restore_main(int argc, char *argv[])
 {
-	int c;
+	int c, ret;
 
 	ip6tables_globals.program_name = "ip6tables-restore";
 	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
@@ -416,6 +419,9 @@ ip6tables_restore_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	return ip46tables_restore_main(&ip6t_restore_cb, argc, argv);
+	ret = ip46tables_restore_main(&ip6t_restore_cb, argc, argv);
+
+	xtables_fini();
+	return ret;
 }
 #endif
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index c7251e35ad763..4efd66673f5de 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -218,6 +218,8 @@ struct iptables_save_cb ipt_save_cb = {
 int
 iptables_save_main(int argc, char *argv[])
 {
+	int ret;
+
 	iptables_globals.program_name = "iptables-save";
 	if (xtables_init_all(&iptables_globals, NFPROTO_IPV4) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
@@ -230,7 +232,10 @@ iptables_save_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	return do_iptables_save(&ipt_save_cb, argc, argv);
+	ret = do_iptables_save(&ipt_save_cb, argc, argv);
+
+	xtables_fini();
+	return ret;
 }
 #endif /* ENABLE_IPV4 */
 
@@ -259,6 +264,8 @@ struct iptables_save_cb ip6t_save_cb = {
 int
 ip6tables_save_main(int argc, char *argv[])
 {
+	int ret;
+
 	ip6tables_globals.program_name = "ip6tables-save";
 	if (xtables_init_all(&ip6tables_globals, NFPROTO_IPV6) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
@@ -271,6 +278,9 @@ ip6tables_save_main(int argc, char *argv[])
 	init_extensions6();
 #endif
 
-	return do_iptables_save(&ip6t_save_cb, argc, argv);
+	ret = do_iptables_save(&ip6t_save_cb, argc, argv);
+
+	xtables_fini();
+	return ret;
 }
 #endif /* ENABLE_IPV6 */
diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index c211fb7399dac..8c67ea4d9a2fb 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -64,6 +64,8 @@ iptables_main(int argc, char *argv[])
 		iptc_free(handle);
 	}
 
+	xtables_fini();
+
 	if (!ret) {
 		if (errno == EINVAL) {
 			fprintf(stderr, "iptables: %s. "
diff --git a/iptables/xtables-arp-standalone.c b/iptables/xtables-arp-standalone.c
index eca7bb979b967..04cf7dccc8206 100644
--- a/iptables/xtables-arp-standalone.c
+++ b/iptables/xtables-arp-standalone.c
@@ -56,6 +56,7 @@ int xtables_arp_main(int argc, char *argv[])
 		ret = nft_commit(&h);
 
 	nft_fini(&h);
+	xtables_fini();
 
 	if (!ret)
 		fprintf(stderr, "arptables: %s\n", nft_strerror(errno));
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 0df1345ae5cd3..5764d1803cba7 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -767,6 +767,7 @@ void nft_fini_eb(struct nft_handle *h)
 	free(opts);
 
 	nft_fini(h);
+	xtables_fini();
 }
 
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index c2b31dbaa0795..57def83e2eea0 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -688,6 +688,8 @@ int xtables_monitor_main(int argc, char *argv[])
 	}
 	mnl_socket_close(nl);
 
+	xtables_fini();
+
 	return EXIT_SUCCESS;
 }
 
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index f1ffcbe246217..573597ab3a2de 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -389,6 +389,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	xtables_restore_parse(&h, &p);
 
 	nft_fini(&h);
+	xtables_fini();
 	fclose(p.in);
 	return 0;
 }
@@ -471,6 +472,7 @@ int xtables_arp_restore_main(int argc, char *argv[])
 	nft_init_arp(&h, "arptables-restore");
 	xtables_restore_parse(&h, &p);
 	nft_fini(&h);
+	xtables_fini();
 
 	return 0;
 }
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 0ce66e5d15cee..bb3d8cd336c38 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -244,6 +244,7 @@ xtables_save_main(int family, int argc, char *argv[],
 
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
+	xtables_fini();
 	if (dump)
 		exit(0);
 
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 022d5dd44abbf..dd6fb7919d2e1 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -72,6 +72,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 		ret = nft_commit(&h);
 
 	nft_fini(&h);
+	xtables_fini();
 
 	if (!ret) {
 		if (errno == EINVAL) {
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 76ad7eb69eca9..5aa42496b5a48 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -509,6 +509,7 @@ static int xtables_xlate_main(int family, const char *progname, int argc,
 		fprintf(stderr, "Translation not implemented\n");
 
 	nft_fini(&h);
+	xtables_fini();
 	exit(!ret);
 }
 
@@ -563,6 +564,7 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 	printf("# Completed on %s", ctime(&now));
 
 	nft_fini(&h);
+	xtables_fini();
 	fclose(p.in);
 	exit(0);
 }
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 777c2b08e9896..7fe42580f9b70 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -206,6 +206,38 @@ struct xtables_target *xtables_targets;
 static bool xtables_fully_register_pending_match(struct xtables_match *me);
 static bool xtables_fully_register_pending_target(struct xtables_target *me);
 
+/* registry for loaded shared objects to close later */
+struct dlreg {
+	struct dlreg *next;
+	void *handle;
+};
+static struct dlreg *dlreg = NULL;
+
+static int dlreg_add(void *handle)
+{
+	struct dlreg *new = malloc(sizeof(*new));
+
+	if (!new)
+		return -1;
+
+	new->handle = handle;
+	new->next = dlreg;
+	dlreg = new;
+	return 0;
+}
+
+static void dlreg_free(void)
+{
+	struct dlreg *next;
+
+	while (dlreg) {
+		next = dlreg->next;
+		dlclose(dlreg->handle);
+		free(dlreg);
+		dlreg = next;
+	}
+}
+
 void xtables_init(void)
 {
 	xtables_libdir = getenv("XTABLES_LIBDIR");
@@ -233,6 +265,11 @@ void xtables_init(void)
 	xtables_libdir = XTABLES_LIBDIR;
 }
 
+void xtables_fini(void)
+{
+	dlreg_free();
+}
+
 void xtables_set_nfproto(uint8_t nfproto)
 {
 	switch (nfproto) {
@@ -567,6 +604,8 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 			next = dir + strlen(dir);
 
 		for (prefix = all_prefixes; *prefix != NULL; ++prefix) {
+			void *handle;
+
 			snprintf(path, sizeof(path), "%.*s/%s%s.so",
 			         (unsigned int)(next - dir), dir,
 			         *prefix, name);
@@ -578,11 +617,14 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 					strerror(errno));
 				return NULL;
 			}
-			if (dlopen(path, RTLD_NOW) == NULL) {
+			handle = dlopen(path, RTLD_NOW);
+			if (handle == NULL) {
 				fprintf(stderr, "%s: %s\n", path, dlerror());
 				break;
 			}
 
+			dlreg_add(handle);
+
 			if (is_target)
 				ptr = xtables_find_target(name, XTF_DONT_LOAD);
 			else
-- 
2.25.1

