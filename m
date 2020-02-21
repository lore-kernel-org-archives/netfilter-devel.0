Return-Path: <SRS0=0JUI=4J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F44C35646
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AD65208C4
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Feb 2020 14:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgBUODo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:03:44 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:57006 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgBUODo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Feb 2020 09:03:44 -0500
Received: from localhost ([::1]:41864 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1j58u7-0000gv-F4; Fri, 21 Feb 2020 15:03:43 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] xtables: Review nft_init()
Date:   Fri, 21 Feb 2020 15:03:24 +0100
Message-Id: <20200221140324.21082-3-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221140324.21082-1-phil@nwl.cc>
References: <20200221140324.21082-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Move common code into nft_init(), such as:

* initial zeroing nft_handle fields
* family ops lookup and assignment to 'ops' field
* setting of 'family' field

This requires minor adjustments in xtables_restore_main() so extra field
initialization doesn't happen before nft_init() call.

As a side-effect, this fixes segfaulting xtables-monitor binary when
printing rules for trace event as in that code-path 'ops' field wasn't
initialized.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                |  9 ++++++++-
 iptables/nft.h                |  2 +-
 iptables/xtables-arp.c        |  9 +--------
 iptables/xtables-eb.c         |  9 +--------
 iptables/xtables-monitor.c    |  2 +-
 iptables/xtables-restore.c    | 14 +++++++-------
 iptables/xtables-save.c       |  9 ++-------
 iptables/xtables-standalone.c |  6 ++----
 iptables/xtables-translate.c  |  2 +-
 iptables/xtables.c            |  4 ----
 10 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 2f0a8c4a772f7..cf3ab9fe239aa 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -789,8 +789,10 @@ int nft_restart(struct nft_handle *h)
 	return 0;
 }
 
-int nft_init(struct nft_handle *h, const struct builtin_table *t)
+int nft_init(struct nft_handle *h, int family, const struct builtin_table *t)
 {
+	memset(h, 0, sizeof(*h));
+
 	h->nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (h->nl == NULL)
 		return -1;
@@ -800,9 +802,14 @@ int nft_init(struct nft_handle *h, const struct builtin_table *t)
 		return -1;
 	}
 
+	h->ops = nft_family_ops_lookup(family);
+	if (!h->ops)
+		xtables_error(PARAMETER_PROBLEM, "Unknown family");
+
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
 	h->cache = &h->__cache[0];
+	h->family = family;
 
 	INIT_LIST_HEAD(&h->obj_list);
 	INIT_LIST_HEAD(&h->err_list);
diff --git a/iptables/nft.h b/iptables/nft.h
index 51b5660314c0c..5cf260a6d2cd3 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -80,7 +80,7 @@ extern const struct builtin_table xtables_bridge[NFT_TABLE_MAX];
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data),
 	     void *data);
-int nft_init(struct nft_handle *h, const struct builtin_table *t);
+int nft_init(struct nft_handle *h, int family, const struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 int nft_restart(struct nft_handle *h);
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 9cfad76263d32..c8196f08baa59 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -500,17 +500,10 @@ int nft_init_arp(struct nft_handle *h, const char *pname)
 	init_extensionsa();
 #endif
 
-	memset(h, 0, sizeof(*h));
-	h->family = NFPROTO_ARP;
-
-	if (nft_init(h, xtables_arp) < 0)
+	if (nft_init(h, NFPROTO_ARP, xtables_arp) < 0)
 		xtables_error(OTHER_PROBLEM,
 			      "Could not initialize nftables layer.");
 
-	h->ops = nft_family_ops_lookup(h->family);
-	if (h->ops == NULL)
-		xtables_error(PARAMETER_PROBLEM, "Unknown family");
-
 	return 0;
 }
 
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 15b971da3d425..c006bc95ac681 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -739,16 +739,9 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 	init_extensionsb();
 #endif
 
-	memset(h, 0, sizeof(*h));
-
-	h->family = NFPROTO_BRIDGE;
-
-	if (nft_init(h, xtables_bridge) < 0)
+	if (nft_init(h, NFPROTO_BRIDGE, xtables_bridge) < 0)
 		xtables_error(OTHER_PROBLEM,
 			      "Could not initialize nftables layer.");
-	h->ops = nft_family_ops_lookup(h->family);
-	if (!h->ops)
-		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
 	/* manually registering ebt matches, given the original ebtables parser
 	 * don't use '-m matchname' and the match can't be loaded dynamically when
diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index a5245d1422af9..c2b31dbaa0795 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -615,7 +615,7 @@ int xtables_monitor_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h, xtables_ipv4)) {
+	if (nft_init(&h, AF_INET, xtables_ipv4)) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 			xtables_globals.program_name,
 			xtables_globals.program_version,
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 61a3c92001615..c472ac9bf651b 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -360,15 +360,13 @@ static int
 xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 {
 	const struct builtin_table *tables;
-	struct nft_handle h = {
-		.family = family,
-		.restore = true,
-	};
-	int c;
 	struct nft_xt_restore_parse p = {
 		.commit = true,
 		.cb = &restore_cb,
 	};
+	bool noflush = false;
+	struct nft_handle h;
+	int c;
 
 	line = 0;
 
@@ -402,7 +400,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				print_usage(prog_name, PACKAGE_VERSION);
 				exit(0);
 			case 'n':
-				h.noflush = 1;
+				noflush = true;
 				break;
 			case 'M':
 				xtables_modprobe_program = optarg;
@@ -457,13 +455,15 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		return 1;
 	}
 
-	if (nft_init(&h, tables) < 0) {
+	if (nft_init(&h, family, tables) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
 				strerror(errno));
 		exit(EXIT_FAILURE);
 	}
+	h.noflush = noflush;
+	h.restore = true;
 
 	xtables_restore_parse(&h, &p);
 
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 1b6c363bef7c1..28f7490275ce5 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -137,10 +137,8 @@ xtables_save_main(int family, int argc, char *argv[],
 	struct do_output_data d = {
 		.format = FMT_NOCOUNTS,
 	};
+	struct nft_handle h;
 	bool dump = false;
-	struct nft_handle h = {
-		.family	= family,
-	};
 	FILE *file = NULL;
 	int ret, c;
 
@@ -233,16 +231,13 @@ xtables_save_main(int family, int argc, char *argv[],
 		return 1;
 	}
 
-	if (nft_init(&h, tables) < 0) {
+	if (nft_init(&h, family, tables) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
 				strerror(errno));
 		exit(EXIT_FAILURE);
 	}
-	h.ops = nft_family_ops_lookup(h.family);
-	if (!h.ops)
-		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
 	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 1a28c5480629f..022d5dd44abbf 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -44,9 +44,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	struct nft_handle h = {
-		.family = family,
-	};
+	struct nft_handle h;
 
 	xtables_globals.program_name = progname;
 	ret = xtables_init_all(&xtables_globals, family);
@@ -61,7 +59,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h, xtables_ipv4) < 0) {
+	if (nft_init(&h, family, xtables_ipv4) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 0f95855b41aa4..76ad7eb69eca9 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -480,7 +480,7 @@ static int xtables_xlate_main_common(struct nft_handle *h,
 		return 1;
 	}
 
-	if (nft_init(h, tables) < 0) {
+	if (nft_init(h, family, tables) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 3d75a1ddacae2..8c2d21d42b7d2 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -571,10 +571,6 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	   demand-load a protocol. */
 	opterr = 0;
 
-	h->ops = nft_family_ops_lookup(h->family);
-	if (h->ops == NULL)
-		xtables_error(PARAMETER_PROBLEM, "Unknown family");
-
 	opts = xt_params->orig_opts;
 	while ((cs->c = getopt_long(argc, argv,
 	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvw::W::nt:m:xc:g:46",
-- 
2.25.1

