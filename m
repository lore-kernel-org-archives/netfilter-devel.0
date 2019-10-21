Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE556CA9EB0
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 21:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5BAC20659
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 21:49:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="qwa5WqIo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfJUVtZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 17:49:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:38478 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729869AbfJUVtY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 17:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SG7nkDhGRv5muRs9l+Mkv2ORqsXxx5DnxQEH8zWBnqg=; b=qwa5WqIo/+TBdQh39CG+CFI6aJ
        A112dZO6HbIIOWejgLvXqDGXh3I3vemv8hR29QU9Ty5VtIEOF5gKUllhuBFTMNRFuaTwXD/B5pBNq
        WN3bq7qCqXbUoxQ/HOUBnS9FfRQBokXS/7WbuymSpIeR1iEc4KoEXeZzeXl1aMLLK7ZWo4DGKfs0M
        c3ddmQ2Zrnxh79Ggm+E1qmSqCEqkBgG4WR4JZiN+LpI2vIvcB//FV+fpyeBhpc15AZeEIjKcLOCx1
        bigie+Ziy3y9KcLgUlhkrTI951BSt78TzIOzjcUdTjXsmyNXcL3aX8dCTfVObqneRvssxJqYkkN6/
        2qKJvNuA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iMfYI-00047s-SF; Mon, 21 Oct 2019 22:49:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 1/2] src: use `-T` as the short option for `--numeric-time`.
Date:   Mon, 21 Oct 2019 22:49:21 +0100
Message-Id: <20191021214922.8943-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021214922.8943-1-jeremy@azazel.net>
References: <20191021214922.8943-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A new `--terse` option will be introduced in a later patch.  Change the
short option used for `--numeric-time` from `-t` to `-T` in order to
leave `-t` free.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/nft.txt | 2 +-
 src/main.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/nft.txt b/doc/nft.txt
index 9bc5986b6416..616640a84c94 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -93,7 +93,7 @@ For a full summary of options, run *nft --help*.
 	Read input from an interactive readline CLI. You can use quit to exit, or use the EOF marker,
 	normally this is CTRL-D.
 
-*-t*::
+*-T*::
 *--numeric-time*::
 	Show time, day and hour values in numeric format.
 
diff --git a/src/main.c b/src/main.c
index 577850e54f68..238c5e0bf9ef 100644
--- a/src/main.c
+++ b/src/main.c
@@ -42,10 +42,10 @@ enum opt_vals {
 	OPT_GUID		= 'u',
 	OPT_NUMERIC_PRIO	= 'y',
 	OPT_NUMERIC_PROTO	= 'p',
-	OPT_NUMERIC_TIME	= 't',
+	OPT_NUMERIC_TIME	= 'T',
 	OPT_INVALID		= '?',
 };
-#define OPTSTRING	"+hvcf:iI:jvnsNaeSupypt"
+#define OPTSTRING	"+hvcf:iI:jvnsNaeSupypT"
 
 static const struct option options[] = {
 	{
@@ -145,7 +145,7 @@ static void show_help(const char *name)
 "  -S, --service			Translate ports to service names as described in /etc/services.\n"
 "  -p, --numeric-protocol	Print layer 4 protocols numerically.\n"
 "  -y, --numeric-priority	Print chain priority numerically.\n"
-"  -t, --numeric-time		Print time values numerically.\n"
+"  -T, --numeric-time		Print time values numerically.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -e, --echo			Echo what has been added, inserted or replaced.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
-- 
2.23.0

