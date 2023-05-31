Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D14ECC77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 12:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjEaMVM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 08:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjEaMVK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 08:21:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9990121
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 05:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=med82VaP8wDKII3FRJc9TMupWS+s5CY74HKJ6X+OxIU=; b=Au++35kuM4uFNhW9rc3Vu+qtGs
        maniCDQthKshYIiZkLEDEv22MT9vUCNGAA4mJuzeff6nWEYPielC4exBt38cwBDAcL0Z/FLqcR9Og
        +PY3HDEHd2TPxQDqjVKb8bYVCN7dIVCXoh3R2dIl21Q0AUX6ZbLMNrPnsmWqgWPrC/KosQ9Vr7NaL
        Tw176KQAGViglUwsyHH4KaYyJhMWsC5Oh07G2MTYwk9XFj+Ea/Rx+VOxXb35ogJGgC3VGVW+iRKX/
        zXvPyOiXsVLfVT/EcrlFfKboKJY7T0dY6mIm1HQyrkdBMM6kPen4l3iKgHPuDXEpWzXSF5CJjhSdk
        v3UK7UMQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1q4Kp9-0005uZ-7E; Wed, 31 May 2023 14:21:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH] set: Do not leave free'd expr_list elements in place
Date:   Wed, 31 May 2023 14:32:56 +0200
Message-Id: <20230531123256.4882-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When freeing elements, remove them also to prevent a potential UAF.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1685
Fixes: 3469f09286cee ("src: add NFTNL_SET_EXPRESSIONS")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/set.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/src/set.c b/src/set.c
index c46f8277ff687..719e59616e974 100644
--- a/src/set.c
+++ b/src/set.c
@@ -54,8 +54,10 @@ void nftnl_set_free(const struct nftnl_set *s)
 	if (s->flags & (1 << NFTNL_SET_USERDATA))
 		xfree(s->user.data);
 
-	list_for_each_entry_safe(expr, next, &s->expr_list, head)
+	list_for_each_entry_safe(expr, next, &s->expr_list, head) {
+		list_del(&expr->head);
 		nftnl_expr_free(expr);
+	}
 
 	list_for_each_entry_safe(elem, tmp, &s->element_list, head) {
 		list_del(&elem->head);
@@ -105,8 +107,10 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 		break;
 	case NFTNL_SET_EXPR:
 	case NFTNL_SET_EXPRESSIONS:
-		list_for_each_entry_safe(expr, tmp, &s->expr_list, head)
+		list_for_each_entry_safe(expr, tmp, &s->expr_list, head) {
+			list_del(&expr->head);
 			nftnl_expr_free(expr);
+		}
 		break;
 	default:
 		return;
@@ -210,8 +214,10 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		s->user.len = data_len;
 		break;
 	case NFTNL_SET_EXPR:
-		list_for_each_entry_safe(expr, tmp, &s->expr_list, head)
+		list_for_each_entry_safe(expr, tmp, &s->expr_list, head) {
+			list_del(&expr->head);
 			nftnl_expr_free(expr);
+		}
 
 		expr = (void *)data;
 		list_add(&expr->head, &s->expr_list);
@@ -742,8 +748,10 @@ int nftnl_set_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_set *s)
 
 	return 0;
 out_set_expr:
-	list_for_each_entry_safe(expr, next, &s->expr_list, head)
+	list_for_each_entry_safe(expr, next, &s->expr_list, head) {
+		list_del(&expr->head);
 		nftnl_expr_free(expr);
+	}
 
 	return -1;
 }
-- 
2.40.0

