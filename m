Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A42D3C10F27
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:14:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 761E921D7E
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgCKOOA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:14:00 -0400
Received: from correo.us.es ([193.147.175.20]:59930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgCKOOA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:14:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B12CCDA381
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A342DDA736
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:36 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 98E76DA788; Wed, 11 Mar 2020 15:13:36 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E170BDA736
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:34 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:13:34 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C3C0E42EF42B
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:13:34 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] set_elem: missing set and build for NFTNL_SET_ELEM_EXPR
Date:   Wed, 11 Mar 2020 15:13:53 +0100
Message-Id: <20200311141353.3720-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend nftnl_set_elem_set() and nftnl_set_elem_nlmsg_build_payload() to
support for the NFTNL_SET_ELEM_EXPR attribute.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set_elem.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index 22031938ebbc..44213228d827 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -162,6 +162,12 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 		if (!s->objref)
 			return -1;
 		break;
+	case NFTNL_SET_ELEM_EXPR:
+		if (s->flags & (1 << NFTNL_SET_ELEM_EXPR))
+			nftnl_expr_free(s->expr);
+
+		s->expr = (void *)data;
+		break;
 	}
 	s->flags |= (1 << attr);
 	return 0;
@@ -326,6 +332,13 @@ void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put(nlh, NFTA_SET_ELEM_USERDATA, e->user.len, e->user.data);
 	if (e->flags & (1 << NFTNL_SET_ELEM_OBJREF))
 		mnl_attr_put_strz(nlh, NFTA_SET_ELEM_OBJREF, e->objref);
+	if (e->flags & (1 << NFTNL_SET_ELEM_EXPR)) {
+		struct nlattr *nest1;
+
+		nest1 = mnl_attr_nest_start(nlh, NFTA_SET_ELEM_EXPR);
+		nftnl_expr_build_payload(nlh, e->expr);
+		mnl_attr_nest_end(nlh, nest1);
+	}
 }
 
 static void nftnl_set_elem_nlmsg_build_def(struct nlmsghdr *nlh,
-- 
2.11.0

