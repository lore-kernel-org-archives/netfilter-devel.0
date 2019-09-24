Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0271EC432C2
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 07:40:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD065214D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 07:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="OaUWOoP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438411AbfIXHkg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:40:36 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33506 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394667AbfIXHkg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 03:40:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gdRzOZfspBFi3ANtm5ZgTrZWrWCSFu7gx9e8XOa752Q=; b=OaUWOoP1s+hWOJmD3J7crEKq6q
        RYZQW5IsoMV5eckVjSrLJeRdxOZWtATQsk4M77vqq/tQt4N2Ld/Y/bXF89Mvv12XVFTkQsvuaNc3b
        qffAYJTUlX2IukSvTS2jTOi49UHqbsv1kqGudS+1zx13sehYgVBF7QsMgXdaxfEMe3Bc7WkcjCHWa
        a08qlKlfY4HzKooqHBM16CD7uG5QTDzpFt/6ICP7zVblVhbH2gz/+gRZEGAzoL/McRNNm7tJAOumj
        RNF03ebpHe42yYk6wrOjMNxoDFAiesHxpF82/W22jvucI/Za/bJMtJ6lfSVg0YlY3QnyVQYnFc0BF
        wWnbpfTQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iCfR5-0001Re-1t; Tue, 24 Sep 2019 08:40:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH nftables 3/3] main: add more information to `nft -v`.
Date:   Tue, 24 Sep 2019 08:40:34 +0100
Message-Id: <20190924074034.4099-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190924074034.4099-1-jeremy@azazel.net>
References: <20190924074034.4099-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In addition to the package-version and release-name, output the CLI
implementation (if any) and whether mini-gmp was used, e.g.:

    $ ./src/nft -v
    nftables v0.9.2 (Scram)
      cli:          linenoise
      minigmp:      no

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am |  3 +++
 src/main.c      | 28 ++++++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 5c2ecbd87288..780f8c6b2b0b 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -16,6 +16,9 @@ endif
 if BUILD_CLI_LINENOISE
 AM_CPPFLAGS += -DHAVE_LINENOISE
 endif
+if BUILD_MINIGMP
+AM_CPPFLAGS += -DHAVE_MINIGMP
+endif
 
 AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
diff --git a/src/main.c b/src/main.c
index f77d8a820a02..866f66e288e2 100644
--- a/src/main.c
+++ b/src/main.c
@@ -154,6 +154,31 @@ static void show_help(const char *name)
 	name, DEFAULT_INCLUDE_PATH);
 }
 
+static void show_version(void)
+{
+	const char *cli, *minigmp;
+
+#if defined(HAVE_LIBREADLINE)
+	cli = "readline";
+#elif defined(HAVE_LINENOISE)
+	cli = "linenoise";
+#else
+	cli = "no";
+#endif
+
+#if defined(HAVE_MINIGMP)
+	minigmp = "yes";
+#else
+	minigmp = "no";
+#endif
+
+	printf("%s v%s (%s)\n"
+	       "  cli:		%s\n"
+	       "  minigmp:	%s\n",
+	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
+	       cli, minigmp);
+}
+
 static const struct {
 	const char		*name;
 	enum nft_debug_level	level;
@@ -213,8 +238,7 @@ int main(int argc, char * const *argv)
 			show_help(argv[0]);
 			exit(EXIT_SUCCESS);
 		case OPT_VERSION:
-			printf("%s v%s (%s)\n",
-			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
+			show_version();
 			exit(EXIT_SUCCESS);
 		case OPT_CHECK:
 			nft_ctx_set_dry_run(nft, true);
-- 
2.23.0

