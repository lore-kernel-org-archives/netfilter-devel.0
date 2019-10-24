Return-Path: <SRS0=5AJI=YR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D479CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45BBD205C9
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Oct 2019 16:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503475AbfJXQhV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Oct 2019 12:37:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:58900 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503471AbfJXQhV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Oct 2019 12:37:21 -0400
Received: from localhost ([::1]:43758 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iNg6y-0005C4-Mm; Thu, 24 Oct 2019 18:37:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 1/7] xtables-restore: Integrate restore callbacks into struct nft_xt_restore_parse
Date:   Thu, 24 Oct 2019 18:37:06 +0200
Message-Id: <20191024163712.22405-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191024163712.22405-1-phil@nwl.cc>
References: <20191024163712.22405-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There's really no point in passing those as separate parameter. While
being at it, make them static const everywhere.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h        | 18 +++++++++---------
 iptables/xtables-restore.c   | 13 ++++++++-----
 iptables/xtables-translate.c |  6 ++++--
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 8b073b18fb0d9..3ff7251f9f7ec 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -232,13 +232,6 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args);
 
-struct nft_xt_restore_parse {
-	FILE		*in;
-	int		testing;
-	const char	*tablename;
-	bool		commit;
-};
-
 struct nftnl_chain_list;
 
 struct nft_xt_restore_cb {
@@ -258,9 +251,16 @@ struct nft_xt_restore_cb {
 	int (*abort)(struct nft_handle *h);
 };
 
+struct nft_xt_restore_parse {
+	FILE				*in;
+	int				testing;
+	const char			*tablename;
+	bool				commit;
+	const struct nft_xt_restore_cb	*cb;
+};
+
 void xtables_restore_parse(struct nft_handle *h,
-			   const struct nft_xt_restore_parse *p,
-			   const struct nft_xt_restore_cb *cb);
+			   const struct nft_xt_restore_parse *p);
 
 void nft_check_xt_legacy(int family, bool is_ipt_save);
 #endif
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 8d6cb7a97ea37..341579bd8d1c3 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -69,10 +69,10 @@ static const struct nft_xt_restore_cb restore_cb = {
 };
 
 void xtables_restore_parse(struct nft_handle *h,
-			   const struct nft_xt_restore_parse *p,
-			   const struct nft_xt_restore_cb *cb)
+			   const struct nft_xt_restore_parse *p)
 {
 	const struct builtin_table *curtable = NULL;
+	const struct nft_xt_restore_cb *cb = p->cb;
 	struct argv_store av_store = {};
 	char buffer[10240];
 	int in_table = 0;
@@ -279,6 +279,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	int c;
 	struct nft_xt_restore_parse p = {
 		.commit = true,
+		.cb = &restore_cb,
 	};
 
 	line = 0;
@@ -383,7 +384,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	xtables_restore_parse(&h, &p, &restore_cb);
+	xtables_restore_parse(&h, &p);
 
 	nft_fini(&h);
 	fclose(p.in);
@@ -427,6 +428,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 {
 	struct nft_xt_restore_parse p = {
 		.in = stdin,
+		.cb = &ebt_restore_cb,
 	};
 	bool noflush = false;
 	struct nft_handle h;
@@ -448,7 +450,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 	nft_init_eb(&h, "ebtables-restore");
 	h.noflush = noflush;
-	xtables_restore_parse(&h, &p, &ebt_restore_cb);
+	xtables_restore_parse(&h, &p);
 	nft_fini(&h);
 
 	return 0;
@@ -467,11 +469,12 @@ int xtables_arp_restore_main(int argc, char *argv[])
 {
 	struct nft_xt_restore_parse p = {
 		.in = stdin,
+		.cb = &arp_restore_cb,
 	};
 	struct nft_handle h;
 
 	nft_init_arp(&h, "arptables-restore");
-	xtables_restore_parse(&h, &p, &arp_restore_cb);
+	xtables_restore_parse(&h, &p);
 	nft_fini(&h);
 
 	return 0;
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 43607901fc62b..a42c60a3b64c6 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -498,7 +498,9 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 		.family = family,
 	};
 	const char *file = NULL;
-	struct nft_xt_restore_parse p = {};
+	struct nft_xt_restore_parse p = {
+		.cb = &cb_xlate,
+	};
 	time_t now = time(NULL);
 	int c;
 
@@ -535,7 +537,7 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 
 	printf("# Translated by %s v%s on %s",
 	       argv[0], PACKAGE_VERSION, ctime(&now));
-	xtables_restore_parse(&h, &p, &cb_xlate);
+	xtables_restore_parse(&h, &p);
 	printf("# Completed on %s", ctime(&now));
 
 	nft_fini(&h);
-- 
2.23.0

