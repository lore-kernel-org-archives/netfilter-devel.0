Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C452C43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:44:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39859206E9
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 16:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389742AbgDAQod (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 12:44:33 -0400
Received: from correo.us.es ([193.147.175.20]:56992 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389734AbgDAQoc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B7AEED5C0
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 18:44:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E344FA52A
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 18:44:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11E9FFA525; Wed,  1 Apr 2020 18:44:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CDA3DA7B2
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 18:44:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Apr 2020 18:44:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1D2334301DE1
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2020 18:44:29 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] expect: parse_mnl: fix gcc compile warning
Date:   Wed,  1 Apr 2020 18:44:25 +0200
Message-Id: <20200401164426.249910-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

parse_mnl.c: In function ‘nfexp_nlmsg_parse’:
parse_mnl.c:142:3: warning: ‘strncpy’ specified bound 16 equals destination size [-Wstringop-truncation]
  142 |   strncpy(exp->helper_name,
      |   ^~~~~~~~~~~~~~~~~~~~~~~~~
  143 |    mnl_attr_get_str(tb[CTA_EXPECT_HELP_NAME]),
      |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  144 |    NFCT_HELPER_NAME_MAX);
      |    ~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expect/parse_mnl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/expect/parse_mnl.c b/src/expect/parse_mnl.c
index e7bbc16cadac..091a8ae0cf84 100644
--- a/src/expect/parse_mnl.c
+++ b/src/expect/parse_mnl.c
@@ -142,6 +142,7 @@ int nfexp_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_expect *exp)
 		strncpy(exp->helper_name,
 			mnl_attr_get_str(tb[CTA_EXPECT_HELP_NAME]),
 			NFCT_HELPER_NAME_MAX);
+		exp->helper_name[NFCT_HELPER_NAME_MAX - 1] = '\0';
 		set_bit(ATTR_EXP_HELPER_NAME, exp->set);
 	}
 	if (tb[CTA_EXPECT_CLASS]) {
-- 
2.11.0

