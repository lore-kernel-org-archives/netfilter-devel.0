Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0C4C56202
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 14:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4BF320786
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 14:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="sdwbUprC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbgKVOFh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 09:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbgKVOFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 09:05:36 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6F7C061A4A
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Nov 2020 06:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EFWM75OLrHGSvAh/Dx4B71kXcGMTpRV7Os23bdjXy74=; b=sdwbUprCI3sOGDXBtaP/KAh2Gk
        FxKbnvwPwbva+yIuErjbPmINvWWaJAf0/s/aVAbCP/bOY95CG1bcrvr7SQk9vdOZT4flG8TOktMOm
        U3PzOFchhOpPWPHyEG071xql1oeDL3YNNuDHAHL5pymszv/89nJJHHGS+5997v+lWCefvj3cMlfBe
        rtklMe43FkRoigie1zaxnuNQ1+9BN475Le+Pt34UoOsYavpIMNHww9cCjsI/qx6gOHg045exBUioq
        tHWHEr35W9gpBS3y/nt9tF2hc523/qUhMomoYDJMtcP1AO6Cvj+p2oJdAayJOT4e7edJCpn9TL5v3
        mUjzDDiQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kgpzg-0002wq-9X; Sun, 22 Nov 2020 14:05:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/4] geoip: remove superfluous xt_geoip_fetch_maxmind script.
Date:   Sun, 22 Nov 2020 14:05:27 +0000
Message-Id: <20201122140530.250248-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201122140530.250248-1-jeremy@azazel.net>
References: <20201122140530.250248-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xt_geoip_fetch and xt_geoip_fetch_maxmind are identical.  Remove the
latter.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 geoip/Makefile.am            |  2 +-
 geoip/xt_geoip_fetch_maxmind | 95 ------------------------------------
 2 files changed, 1 insertion(+), 96 deletions(-)
 delete mode 100755 geoip/xt_geoip_fetch_maxmind

diff --git a/geoip/Makefile.am b/geoip/Makefile.am
index 7bbf3bcf3815..5323c82eb7c4 100644
--- a/geoip/Makefile.am
+++ b/geoip/Makefile.am
@@ -1,6 +1,6 @@
 # -*- Makefile -*-
 
-bin_SCRIPTS = xt_geoip_fetch xt_geoip_fetch_maxmind
+bin_SCRIPTS = xt_geoip_fetch
 
 pkglibexec_SCRIPTS = xt_geoip_build xt_geoip_build_maxmind xt_geoip_dl xt_geoip_dl_maxmind
 
diff --git a/geoip/xt_geoip_fetch_maxmind b/geoip/xt_geoip_fetch_maxmind
deleted file mode 100755
index 06245195fb51..000000000000
--- a/geoip/xt_geoip_fetch_maxmind
+++ /dev/null
@@ -1,95 +0,0 @@
-#!/usr/bin/perl
-#
-#	Utility to query GeoIP database
-#	Copyright Philip Prindeville, 2018
-#
-use Getopt::Long;
-use Socket qw(AF_INET AF_INET6 inet_ntop);
-use warnings;
-use strict;
-
-sub AF_INET_SIZE() { 4 }
-sub AF_INET6_SIZE() { 16 }
-
-my $target_dir = ".";
-my $ipv4 = 0;
-my $ipv6 = 0;
-
-&Getopt::Long::Configure(qw(bundling));
-&GetOptions(
-	"D=s" => \$target_dir,
-	"4"   => \$ipv4,
-	"6"   => \$ipv6,
-);
-
-if (!-d $target_dir) {
-	print STDERR "Target directory $target_dir does not exit.\n";
-	exit 1;
-}
-
-# if neither specified, assume both
-if (! $ipv4 && ! $ipv6) {
-	$ipv4 = $ipv6 = 1;
-}
-
-foreach my $cc (@ARGV) {
-	if ($cc !~ m/^([a-z]{2}|a[12]|o1)$/i) {
-		print STDERR "Invalid country code '$cc'\n";
-		exit 1;
-	}
-
-	my $file = $target_dir . '/' . uc($cc) . '.iv4';
-
-	if (! -f $file) {
-		printf STDERR "Can't find data for country '$cc'\n";
-		exit 1;
-	}
-
-	my ($contents, $buffer, $bytes, $fh);
-
-	if ($ipv4) {
-		open($fh, '<', $file) || die "Couldn't open file for '$cc'\n";
-
-		binmode($fh);
-
-		while (($bytes = read($fh, $buffer, AF_INET_SIZE * 2)) == AF_INET_SIZE * 2) {
-			my ($start, $end) = unpack('a4a4', $buffer);
-			$start = inet_ntop(AF_INET, $start);
-			$end = inet_ntop(AF_INET, $end);
-			print $start, '-', $end, "\n";
-		}
-		close($fh);
-		if (! defined $bytes) {
-			printf STDERR "Error reading file for '$cc'\n";
-			exit 1;
-		} elsif ($bytes != 0) {
-			printf STDERR "Short read on file for '$cc'\n";
-			exit 1;
-		}
-	}
-
-	substr($file, -1) = '6';
-
-	if ($ipv6) {
-		open($fh, '<', $file) || die "Couldn't open file for '$cc'\n";
-
-		binmode($fh);
-
-		while (($bytes = read($fh, $buffer, AF_INET6_SIZE * 2)) == AF_INET6_SIZE * 2) {
-			my ($start, $end) = unpack('a16a16', $buffer);
-			$start = inet_ntop(AF_INET6, $start);
-			$end = inet_ntop(AF_INET6, $end);
-			print $start, '-', $end, "\n";
-		}
-		close($fh);
-		if (! defined $bytes) {
-			printf STDERR "Error reading file for '$cc'\n";
-			exit 1;
-		} elsif ($bytes != 0) {
-			printf STDERR "Short read on file for '$cc'\n";
-			exit 1;
-		}
-	}
-}
-
-exit 0;
-- 
2.29.2

