Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766DEC3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51FBB2082F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbfHTLan (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:30:43 -0400
Received: from rs07.intra2net.com ([85.214.138.66]:54380 "EHLO
        rs07.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729308AbfHTLan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 07:30:43 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id 0D047150019A;
        Tue, 20 Aug 2019 13:30:41 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id CF5DE6F9;
        Tue, 20 Aug 2019 13:30:40 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.80,VDF=8.16.21.110)
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id 2FCAC5C6;
        Tue, 20 Aug 2019 13:30:39 +0200 (CEST)
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc:     thomas.jarosch@intra2net.com
Subject: [PATCH iptables] extensions: nfacct: Fix alignment mismatch in xt_nfacct_match_info
Date:   Tue, 20 Aug 2019 13:30:39 +0200
Message-ID: <3495054.C9FayD4L8h@rocinante.m.i2n>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When running a 64-bit kernel with a 32-bit iptables binary, the
size of the xt_nfacct_match_info struct diverges.

    kernel: sizeof(struct xt_nfacct_match_info) : 40
    iptables: sizeof(struct xt_nfacct_match_info)) : 36

This patch is the userspace fix of the memory misalignment.

It introduces a v1 ABI with the correct alignment and stays
compatible with unfixed revision 0 kernels.

Signed-off-by: Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
---
Note to the maintainer:
    Please feel free to adapt the commit message to your liking.

 extensions/libxt_nfacct.c           | 40 ++++++++++++++++++++---------
 include/linux/netfilter/xt_nfacct.h |  5 ++++
 2 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/extensions/libxt_nfacct.c b/extensions/libxt_nfacct.c
index 2ad59d52..d9c0309a 100644
--- a/extensions/libxt_nfacct.c
+++ b/extensions/libxt_nfacct.c
@@ -70,20 +70,36 @@ static void nfacct_save(const void *ip, const struct xt_entry_match *match)
 	nfacct_print_name(info, "--");
 }
 
-static struct xtables_match nfacct_match = {
-	.family		= NFPROTO_UNSPEC,
-	.name		= "nfacct",
-	.version	= XTABLES_VERSION,
-	.size		= XT_ALIGN(sizeof(struct xt_nfacct_match_info)),
-	.userspacesize	= offsetof(struct xt_nfacct_match_info, nfacct),
-	.help		= nfacct_help,
-	.x6_parse	= nfacct_parse,
-	.print		= nfacct_print,
-	.save		= nfacct_save,
-	.x6_options	= nfacct_opts,
+static struct xtables_match nfacct_matches[] = {
+	{
+		.family		= NFPROTO_UNSPEC,
+		.revision	= 0,
+		.name		= "nfacct",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_nfacct_match_info)),
+		.userspacesize	= offsetof(struct xt_nfacct_match_info, nfacct),
+		.help		= nfacct_help,
+		.x6_parse	= nfacct_parse,
+		.print		= nfacct_print,
+		.save		= nfacct_save,
+		.x6_options	= nfacct_opts,
+	},
+	{
+		.family		= NFPROTO_UNSPEC,
+		.revision	= 1,
+		.name		= "nfacct",
+		.version	= XTABLES_VERSION,
+		.size		= XT_ALIGN(sizeof(struct xt_nfacct_match_info_v1)),
+		.userspacesize	= offsetof(struct xt_nfacct_match_info_v1, nfacct),
+		.help		= nfacct_help,
+		.x6_parse	= nfacct_parse,
+		.print		= nfacct_print,
+		.save		= nfacct_save,
+		.x6_options	= nfacct_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_match(&nfacct_match);
+	xtables_register_matches(nfacct_matches, ARRAY_SIZE(nfacct_matches));
 }
diff --git a/include/linux/netfilter/xt_nfacct.h b/include/linux/netfilter/xt_nfacct.h
index 59ab00dd..04ec2b04 100644
--- a/include/linux/netfilter/xt_nfacct.h
+++ b/include/linux/netfilter/xt_nfacct.h
@@ -14,4 +14,9 @@ struct xt_nfacct_match_info {
 	struct nf_acct	*nfacct;
 };
 
+struct xt_nfacct_match_info_v1 {
+	char		name[NFACCT_NAME_MAX];
+	struct nf_acct	*nfacct __attribute__((aligned(8)));
+};
+
 #endif /* _XT_NFACCT_MATCH_H */
-- 
2.20.1




