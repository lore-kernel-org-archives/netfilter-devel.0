Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A6FCA9EC8
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FD7321A49
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438247AbfJQWsq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 18:48:46 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42600 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732705AbfJQWsp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 18:48:45 -0400
Received: from localhost ([::1]:55690 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLEZY-00043J-KO; Fri, 18 Oct 2019 00:48:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/8] xtables-restore: Use xt_params->program_name
Date:   Fri, 18 Oct 2019 00:48:30 +0200
Message-Id: <20191017224836.8261-3-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191017224836.8261-1-phil@nwl.cc>
References: <20191017224836.8261-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of setting newargv[0] to argv[0]'s value, just use whatever
xt_params->program_name contains. The latter is arbitrarily defined, but
may still be more correct than real argv[0] which may simply be for
instance xtables-nft-multi. Either way, there is no practical
significance since newargv[0] is used exclusively in debug output.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h        |  3 +--
 iptables/xtables-restore.c   | 11 +++++------
 iptables/xtables-translate.c |  2 +-
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index a330aceb9785c..5c6641505f3db 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -262,8 +262,7 @@ struct nft_xt_restore_cb {
 
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p,
-			   struct nft_xt_restore_cb *cb,
-			   int argc, char *argv[]);
+			   struct nft_xt_restore_cb *cb);
 
 void nft_check_xt_legacy(int family, bool is_ipt_save);
 #endif
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index cb03104e91a7b..24bfce516d34c 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -87,8 +87,7 @@ static const struct xtc_ops xtc_ops = {
 
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p,
-			   struct nft_xt_restore_cb *cb,
-			   int argc, char *argv[])
+			   struct nft_xt_restore_cb *cb)
 {
 	const struct builtin_table *curtable = NULL;
 	char buffer[10240];
@@ -264,7 +263,7 @@ void xtables_restore_parse(struct nft_handle *h,
 				parsestart = buffer;
 			}
 
-			add_argv(argv[0], 0);
+			add_argv(xt_params->program_name, 0);
 			add_argv("-t", 0);
 			add_argv(curtable->name, 0);
 
@@ -434,7 +433,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	xtables_restore_parse(&h, &p, &restore_cb, argc, argv);
+	xtables_restore_parse(&h, &p, &restore_cb);
 
 	nft_fini(&h);
 	fclose(p.in);
@@ -500,7 +499,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 	nft_init_eb(&h, "ebtables-restore");
 	h.noflush = noflush;
-	xtables_restore_parse(&h, &p, &ebt_restore_cb, argc, argv);
+	xtables_restore_parse(&h, &p, &ebt_restore_cb);
 	nft_fini(&h);
 
 	return 0;
@@ -524,7 +523,7 @@ int xtables_arp_restore_main(int argc, char *argv[])
 	struct nft_handle h;
 
 	nft_init_arp(&h, "arptables-restore");
-	xtables_restore_parse(&h, &p, &arp_restore_cb, argc, argv);
+	xtables_restore_parse(&h, &p, &arp_restore_cb);
 	nft_fini(&h);
 
 	return 0;
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 4ae9ff57c0eb3..64e7667a253e7 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -535,7 +535,7 @@ static int xtables_restore_xlate_main(int family, const char *progname,
 
 	printf("# Translated by %s v%s on %s",
 	       argv[0], PACKAGE_VERSION, ctime(&now));
-	xtables_restore_parse(&h, &p, &cb_xlate, argc, argv);
+	xtables_restore_parse(&h, &p, &cb_xlate);
 	printf("# Completed on %s", ctime(&now));
 
 	nft_fini(&h);
-- 
2.23.0

