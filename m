Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738C7C04AA9
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 12:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D5FA2075E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 12:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEBMNq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 08:13:46 -0400
Received: from mail.us.es ([193.147.175.20]:60258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfEBMNq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 08:13:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C9CB2EFEB4
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CD9DDA704
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52848DA703; Thu,  2 May 2019 14:13:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46D76DA70B
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 02 May 2019 14:13:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2B9754265A5B
        for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2019 14:13:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack 2/3] expect: add missing handling for CTA_EXPECT_* attributes
Date:   Thu,  2 May 2019 14:13:36 +0200
Message-Id: <20190502121337.4880-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190502121337.4880-1-pablo@netfilter.org>
References: <20190502121337.4880-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing code to handle CTA_EXPECT_CLASS, CTA_EXPECT_NAT and
CTA_EXPECT_FN from libmnl parser.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expect/parse_mnl.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 3 deletions(-)

diff --git a/src/expect/parse_mnl.c b/src/expect/parse_mnl.c
index 69feef5379b0..e7bbc16cadac 100644
--- a/src/expect/parse_mnl.c
+++ b/src/expect/parse_mnl.c
@@ -47,6 +47,53 @@ static int nlmsg_parse_expection_attr_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
+static int nfexp_nlmsg_parse_nat_attr_cb(const struct nlattr *attr, void *data)
+{
+	int type = mnl_attr_get_type(attr);
+	const struct nlattr **tb = data;
+
+	if (mnl_attr_type_valid(attr, CTA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case CTA_EXPECT_NAT_TUPLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+			abi_breakage();
+		break;
+	case CTA_EXPECT_NAT_DIR:
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+			abi_breakage();
+		break;
+	}
+
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static void nfexp_nlmsg_parse_nat(struct nfgenmsg *nfg,
+				  const struct nlattr *attr,
+				  struct nf_expect *exp)
+{
+	struct nlattr *tb[CTA_EXPECT_NAT_MAX + 1] = {};
+
+	if (mnl_attr_parse_nested(attr, nfexp_nlmsg_parse_nat_attr_cb, tb) < 0)
+		return;
+
+	exp->nat.orig.l3protonum = nfg->nfgen_family;
+	set_bit(ATTR_ORIG_L3PROTO, exp->nat.set);
+
+	if (tb[CTA_EXPECT_NAT_TUPLE]) {
+		nfct_parse_tuple(tb[CTA_EXPECT_NAT_TUPLE], &exp->nat.orig,
+				 __DIR_ORIG, exp->nat.set);
+		set_bit(ATTR_EXP_NAT_TUPLE, exp->set);
+	}
+	if (tb[CTA_EXPECT_NAT_DIR]) {
+		exp->nat_dir =
+			ntohl(mnl_attr_get_u32(tb[CTA_EXPECT_NAT_DIR]));
+		set_bit(ATTR_EXP_NAT_DIR, exp->set);
+	}
+}
+
 int nfexp_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_expect *exp)
 {
 	struct nlattr *tb[CTA_EXPECT_MAX+1] = {};
@@ -83,22 +130,33 @@ int nfexp_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_expect *exp)
 		exp->timeout = ntohl(mnl_attr_get_u32(tb[CTA_EXPECT_TIMEOUT]));
 		set_bit(ATTR_EXP_TIMEOUT, exp->set);
 	}
-
 	if (tb[CTA_EXPECT_ZONE]) {
 		exp->zone = ntohs(mnl_attr_get_u16(tb[CTA_EXPECT_ZONE]));
 		set_bit(ATTR_EXP_ZONE, exp->set);
 	}
-
 	if (tb[CTA_EXPECT_FLAGS]) {
 		exp->flags = ntohl(mnl_attr_get_u32(tb[CTA_EXPECT_FLAGS]));
 		set_bit(ATTR_EXP_FLAGS, exp->set);
 	}
-
 	if (tb[CTA_EXPECT_HELP_NAME]) {
 		strncpy(exp->helper_name,
 			mnl_attr_get_str(tb[CTA_EXPECT_HELP_NAME]),
 			NFCT_HELPER_NAME_MAX);
 		set_bit(ATTR_EXP_HELPER_NAME, exp->set);
 	}
+	if (tb[CTA_EXPECT_CLASS]) {
+		exp->class = ntohl(mnl_attr_get_u32(tb[CTA_EXPECT_CLASS]));
+		set_bit(ATTR_EXP_CLASS, exp->set);
+	}
+	if (tb[CTA_EXPECT_NAT])
+		nfexp_nlmsg_parse_nat(nfg, tb[CTA_EXPECT_NAT], exp);
+
+	if (tb[CTA_EXPECT_FN]) {
+		strncpy(exp->expectfn, mnl_attr_get_payload(tb[CTA_EXPECT_FN]),
+			__NFCT_EXPECTFN_MAX);
+		exp->expectfn[__NFCT_EXPECTFN_MAX - 1] = '\0';
+		set_bit(ATTR_EXP_FN, exp->set);
+	}
+
 	return 0;
 }
-- 
2.11.0

