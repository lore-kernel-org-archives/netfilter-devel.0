Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6106FC4CEC9
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 12:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 367E52070C
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 12:21:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="UXXaCXGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437857AbfIUMVD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 08:21:03 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33112 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437852AbfIUMVC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 08:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gdRzOZfspBFi3ANtm5ZgTrZWrWCSFu7gx9e8XOa752Q=; b=UXXaCXGpwGgMYc3yAPDGeHsHhF
        YLvzVT2M9oMIavvk9/IzSP7UcFqLm1vo/uyaPVhWtPoZM2iOtBEIKjnHCJZQMR1CKYmH357/vmcrw
        ATp1C2GQOpnOICaZyAO7mmXRSqnZbJKFowE+SlpO1AakYNaqcBZNGCKWQYTJeC3bhXWOidTWEU7jO
        8hVbQB5Ic20cM+CCl+yJMmkeKOmFxrBSAY1//NLal3kY2et6r/7l/1GMH5gv3ftqtjr08wvKlUyMX
        x6fZ7dAsyTvieRi0a5+XwpBzKfQfCJ2p8pFY6BP9KjOt2YLK5eC0c37yKWYa3gUZWyni8pafw8WxM
        KJTypQzw==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBeNp-0000qr-G9; Sat, 21 Sep 2019 13:21:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH nftables 3/3] main: add more information to `nft -v`.
Date:   Sat, 21 Sep 2019 13:21:00 +0100
Message-Id: <20190921122100.3740-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190921122100.3740-1-jeremy@azazel.net>
References: <20190921122100.3740-1-jeremy@azazel.net>
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

