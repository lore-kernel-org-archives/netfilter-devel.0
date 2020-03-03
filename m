Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636C4C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 23:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B71020716
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 23:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgCCXXv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:23:51 -0500
Received: from correo.us.es ([193.147.175.20]:34280 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbgCCXXv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 18:23:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE4DA81403
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 00:23:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DDE60DA7B6
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 00:23:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D3352DA7B2; Wed,  4 Mar 2020 00:23:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B74B2DA736;
        Wed,  4 Mar 2020 00:23:33 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Mar 2020 00:23:33 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9B604426CCB9;
        Wed,  4 Mar 2020 00:23:33 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net
Subject: [PATCH nft] main: add more information to `nft -V`.
Date:   Wed,  4 Mar 2020 00:23:41 +0100
Message-Id: <20200303232341.25786-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

In addition to the package-version and release-name, output the CLI
implementation (if any) and whether mini-gmp was used, e.g.:

    $ ./src/nft -V
    nftables v0.9.3 (Topsy)
      cli:          linenoise
      minigmp:      no

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Jeremy et al.

I'm revisiting this one, it's basically your patch with a few mangling.

I wonder if it's probably a good idea to introduce a long version mode.
I have seen other tools providing more verbose information about all
build information.

The idea would be to leave -v/--version as it is, and introduce -V
which would be more verbose.

Thanks.

 src/Makefile.am |  3 +++
 src/main.c      | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 9142ab4484f2..b4b9142bf6b0 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -13,6 +13,9 @@ endif
 if BUILD_XTABLES
 AM_CPPFLAGS += ${XTABLES_CFLAGS}
 endif
+if BUILD_MINIGMP
+AM_CPPFLAGS += -DHAVE_MINIGMP
+endif
 
 AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
diff --git a/src/main.c b/src/main.c
index 6ab1b89f4dd5..6a88e777cc1f 100644
--- a/src/main.c
+++ b/src/main.c
@@ -27,6 +27,7 @@ static struct nft_ctx *nft;
 enum opt_vals {
 	OPT_HELP		= 'h',
 	OPT_VERSION		= 'v',
+	OPT_VERSION_LONG	= 'V',
 	OPT_CHECK		= 'c',
 	OPT_FILE		= 'f',
 	OPT_INTERACTIVE		= 'i',
@@ -46,7 +47,7 @@ enum opt_vals {
 	OPT_TERSE		= 't',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"+hvd:cf:iI:jvnsNaeSupypTt"
+#define OPTSTRING	"+hvVd:cf:iI:jvnsNaeSupypTt"
 
 static const struct option options[] = {
 	{
@@ -141,6 +142,7 @@ static void show_help(const char *name)
 "Options:\n"
 "  -h, --help			Show this help\n"
 "  -v, --version			Show version information\n"
+"  -V				Show extended version information\n"
 "\n"
 "  -c, --check			Check commands validity without actually applying the changes.\n"
 "  -f, --file <filename>		Read input from <filename>\n"
@@ -164,6 +166,31 @@ static void show_help(const char *name)
 	name, DEFAULT_INCLUDE_PATH);
 }
 
+static void show_version(void)
+{
+	const char *cli, *minigmp;
+
+#if defined(HAVE_LIBREADLINE)
+	cli = "readline";
+#elif defined(HAVE_LIBLINENOISE)
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
@@ -272,6 +299,9 @@ int main(int argc, char * const *argv)
 			printf("%s v%s (%s)\n",
 			       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME);
 			exit(EXIT_SUCCESS);
+		case OPT_VERSION_LONG:
+			show_version();
+			exit(EXIT_SUCCESS);
 		case OPT_CHECK:
 			nft_ctx_set_dry_run(nft, true);
 			break;
-- 
2.11.0

