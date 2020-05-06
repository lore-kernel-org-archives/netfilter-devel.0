Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BFEC28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBAC8208DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 17:34:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728681AbgEFReN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 13:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgEFReN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 13:34:13 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7433FC061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 10:34:13 -0700 (PDT)
Received: from localhost ([::1]:58726 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jWNvw-0002ky-Aj; Wed, 06 May 2020 19:34:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/15] ebtables: Free statically loaded extensions again
Date:   Wed,  6 May 2020 19:33:26 +0200
Message-Id: <20200506173331.9347-11-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200506173331.9347-1-phil@nwl.cc>
References: <20200506173331.9347-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All ebtables extensions are loaded upon program start as due to the lack
of '-m' parameters, loading on demand is not possible. Introduce
nft_fini_eb() to counteract nft_init_eb() and free dynamic memory in
matches and targets from there.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.h                   |  1 +
 iptables/xtables-eb-standalone.c |  2 +-
 iptables/xtables-eb.c            | 17 +++++++++++++++++
 iptables/xtables-restore.c       |  2 +-
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.h b/iptables/nft.h
index aeacc608fcb9f..bd783231156b7 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -225,6 +225,7 @@ int nft_init_arp(struct nft_handle *h, const char *pname);
 int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table, bool restore);
 /* For xtables-eb.c */
 int nft_init_eb(struct nft_handle *h, const char *pname);
+void nft_fini_eb(struct nft_handle *h);
 int ebt_get_current_chain(const char *chain);
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table, bool restore);
 
diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
index ff74ddbb37334..181cf2d0cbe11 100644
--- a/iptables/xtables-eb-standalone.c
+++ b/iptables/xtables-eb-standalone.c
@@ -53,7 +53,7 @@ int xtables_eb_main(int argc, char *argv[])
 	if (ret)
 		ret = nft_bridge_commit(&h);
 
-	nft_fini(&h);
+	nft_fini_eb(&h);
 
 	if (!ret)
 		fprintf(stderr, "ebtables: %s\n", nft_strerror(errno));
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 07ed651370913..0df1345ae5cd3 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -752,6 +752,23 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 	return 0;
 }
 
+void nft_fini_eb(struct nft_handle *h)
+{
+	struct xtables_match *match;
+	struct xtables_target *target;
+
+	for (match = xtables_matches; match; match = match->next) {
+		free(match->m);
+	}
+	for (target = xtables_targets; target; target = target->next) {
+		free(target->t);
+	}
+
+	free(opts);
+
+	nft_fini(h);
+}
+
 int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 		 bool restore)
 {
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 44eaf8ab6c483..f1ffcbe246217 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -446,7 +446,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 	nft_init_eb(&h, "ebtables-restore");
 	h.noflush = noflush;
 	xtables_restore_parse(&h, &p);
-	nft_fini(&h);
+	nft_fini_eb(&h);
 
 	return 0;
 }
-- 
2.25.1

