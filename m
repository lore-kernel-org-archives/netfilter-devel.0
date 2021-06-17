Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02527C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 15:49:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D450860FF1
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Jun 2021 15:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhFQPvd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:51:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48480 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbhFQPv0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 11:51:26 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E309D6424D
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jun 2021 17:47:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: memleak of list of timeout policies
Date:   Thu, 17 Jun 2021 17:49:15 +0200
Message-Id: <20210617154915.3828-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Release list of ct timeout policy when object is freed.

Direct leak of 160 byte(s) in 2 object(s) allocated from:
    #0 0x7fc0273ad330 in __interceptor_malloc (/usr/lib/x86_64-linux-gnu/libasan.so.5+0xe9330)
    #1 0x7fc0231377c4 in xmalloc /home/.../devel/nftables/src/utils.c:36
    #2 0x7fc023137983 in xzalloc /home/.../devel/nftables/src/utils.c:75
    #3 0x7fc0231f64d6 in nft_parse /home/.../devel/nftables/src/parser_bison.y:4448

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
After this update tests/py shows only memleaks in Python and there is still
one small string memleak in the parser that I didn't find yet.

 src/netlink.c      | 1 +
 src/parser_bison.y | 1 +
 src/rule.c         | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index f2c1a4a15dee..c5fd38044b41 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1484,6 +1484,7 @@ struct obj *netlink_delinearize_obj(struct netlink_ctx *ctx,
 		obj->ct_helper.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_HELPER_L4PROTO);
 		break;
 	case NFT_OBJECT_CT_TIMEOUT:
+		init_list_head(&obj->ct_timeout.timeout_list);
 		obj->ct_timeout.l3proto = nftnl_obj_get_u16(nlo, NFTNL_OBJ_CT_TIMEOUT_L3PROTO);
 		obj->ct_timeout.l4proto = nftnl_obj_get_u8(nlo, NFTNL_OBJ_CT_TIMEOUT_L4PROTO);
 		memcpy(obj->ct_timeout.timeout,
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 5e702a054f44..d0bbb6dedc82 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1748,6 +1748,7 @@ table_block		:	/* empty */	{ $$ = $<table>-1; }
 			{
 				$5->location = @4;
 				$5->type = NFT_OBJECT_CT_TIMEOUT;
+				init_list_head(&$5->ct_timeout.timeout_list);
 				handle_merge(&$5->handle, &$4);
 				handle_free(&$4);
 				list_add_tail(&$5->list, &$1->objs);
diff --git a/src/rule.c b/src/rule.c
index 92daf2f33b76..10569aa7875a 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1709,6 +1709,14 @@ void obj_free(struct obj *obj)
 		return;
 	xfree(obj->comment);
 	handle_free(&obj->handle);
+	if (obj->type == NFT_OBJECT_CT_TIMEOUT) {
+		struct timeout_state *ts, *next;
+
+		list_for_each_entry_safe(ts, next, &obj->ct_timeout.timeout_list, head) {
+			list_del(&ts->head);
+			xfree(ts);
+		}
+	}
 	xfree(obj);
 }
 
-- 
2.20.1

