Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7BCC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C2860E05
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238782AbhJOM3V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238905AbhJOM2s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 08:28:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB896C06176E
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 05:26:39 -0700 (PDT)
Received: from localhost ([::1]:33848 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mbMII-0002UA-BX; Fri, 15 Oct 2021 14:26:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 06/13] xtables-standalone: Drop version number from init errors
Date:   Fri, 15 Oct 2021 14:26:01 +0200
Message-Id: <20211015122608.12474-7-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211015122608.12474-1-phil@nwl.cc>
References: <20211015122608.12474-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Aside from the rather unconventional formatting, if those initialization
functions fail we've either released a completely broken iptables or
the wrong libraries are chosen by the loader. In both cases, the version
number is not really interesting.

While being at it, fix indenting of the first exit() call.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-standalone.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index f4d40cda6ae43..54c70c5429766 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -49,10 +49,8 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 	xtables_globals.program_name = progname;
 	ret = xtables_init_all(&xtables_globals, family);
 	if (ret < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version);
-				exit(1);
+		fprintf(stderr, "%s: Failed to initialize xtables\n", progname);
+		exit(1);
 	}
 #if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
 	init_extensions();
@@ -61,10 +59,8 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 #endif
 
 	if (nft_init(&h, family) < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version,
-				strerror(errno));
+		fprintf(stderr, "%s: Failed to initialize nft: %s\n",
+			xtables_globals.program_name, strerror(errno));
 		exit(EXIT_FAILURE);
 	}
 
-- 
2.33.0

