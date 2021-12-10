Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9223AC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:21:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbhLJLZC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:25:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:45154 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237672AbhLJLZC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:25:02 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B8B7660022
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Dec 2021 12:19:01 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_conntrack] conntrack: don't cancel nest on unknown layer 4 protocols
Date:   Fri, 10 Dec 2021 12:21:20 +0100
Message-Id: <20211210112120.148063-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It is valid to specify CTA_PROTO_NUM with a protocol that is not
natively supported by conntrack. Do not cancel the CTA_TUPLE_PROTO
nest in this case.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack/build_mnl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index c3198c57cdcd..af5d0e7ce290 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -73,8 +73,7 @@ nfct_build_tuple_proto(struct nlmsghdr *nlh, const struct __nfct_tuple *t)
 		mnl_attr_put_u16(nlh, CTA_PROTO_ICMPV6_ID, t->l4src.icmp.id);
 		break;
 	default:
-		mnl_attr_nest_cancel(nlh, nest);
-		return -1;
+		break;
 	}
 	mnl_attr_nest_end(nlh, nest);
 	return 0;
-- 
2.30.2

