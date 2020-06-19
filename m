Return-Path: <SRS0=bANH=AA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D85DC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 14:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC8D2078D
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 14:29:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=average.org header.i=@average.org header.b="bEbwuhB6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgFSO3f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:29:35 -0400
Received: from dehost.average.org ([88.198.2.197]:49428 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgFSO3f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jun 2020 10:29:35 -0400
Received: from wscross.pb.local (unknown [IPv6:2001:1438:4010:2548:9a90:96ff:fea0:e2f])
        by dehost.average.org (Postfix) with ESMTPSA id C17FC354AD6D;
        Fri, 19 Jun 2020 16:29:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1592576973; bh=MTK74XKWGDzCgtQkBCSX5Ft9joaevBamL5hg0HuP/+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEbwuhB67FeDhbM9PGdyJ4vNq1DyKCKdNrg8uec/dqD+c9LAj5WjkBlFr7qKn459T
         +IPpQYEI+2hkevfEbcdIuRIN70T+i9qPW5wqoQANy/1bw0XWi1ovwbxKv6Cv65J4V7
         EsGbY+TKO4FNKx4qkoHYMOmKvTpGitGLaGbYHAyA=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Eugene Crosser <evgenii.cherkashin@cloud.ionos.com>,
        Eugene Crosser <crosser@average.org>
Subject: [PATCH] ebtables-nft: introduce '-m <match_ext>' option
Date:   Fri, 19 Jun 2020 16:29:12 +0200
Message-Id: <20200619142912.19390-2-crosser@average.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200619142912.19390-1-crosser@average.org>
References: <20200619142912.19390-1-crosser@average.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Eugene Crosser <evgenii.cherkashin@cloud.ionos.com>

`iptables` command has an option '-m' to dynamically load match
extentions (shared objects in the <lib-path>/xtables directory).
`ebtables` command has no such option, making it impossible to add new
extentions without recompiling the program.

This patch adds functionality of dynamic loading of match extentions,
bringing `ebtables` command on par with `iptables` command. (Note that
dynamic loading of _target_ extentions works in `ebtables` the same way
as in `iptables` out of the box.)

Signed-off-by: Eugene Crosser <crosser@average.org>
---
 iptables/ebtables-nft.8 | 6 +++---
 iptables/xtables-eb.c   | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/iptables/ebtables-nft.8 b/iptables/ebtables-nft.8
index 1fa5ad93..181f742d 100644
--- a/iptables/ebtables-nft.8
+++ b/iptables/ebtables-nft.8
@@ -504,9 +504,9 @@ If used with the
 .IR pcnt ", resp. " bcnt " will match."
 
 .SS MATCH EXTENSIONS
-Ebtables extensions are dynamically loaded into the userspace tool,
-there is therefore no need to explicitly load them with a
--m option like is done in iptables.
+Standard ebtables extensions are dynamically loaded into the userspace tool,
+while custom extentions need to explicitly loaded with a
+-m option like it is done in iptables.
 These extensions deal with functionality supported by kernel modules supplemental to
 the core ebtables code.
 .SS 802_3
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 6641a21a..d4bf336e 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -800,7 +800,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 
 	/* Getopt saves the day */
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
+	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:m:", opts, NULL)) != -1) {
 		cs.c = c;
 		cs.invert = ebt_invert;
 		switch (c) {
@@ -1100,6 +1100,9 @@ print_zero:
 				xtables_error(PARAMETER_PROBLEM,
 					      "Sorry, protocols have values above or equal to 0x0600");
 			break;
+		case 'm':
+			ebt_load_match(optarg);
+			break;
 		case 4  : /* Lc */
 			ebt_check_option2(&flags, LIST_C);
 			if (command != 'L')
-- 
2.25.1

