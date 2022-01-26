Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EDBC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 22:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiAZWdW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:33:22 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58150 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiAZWdW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 17:33:22 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 88C0A60256
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:30:18 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 3/4] optimize: check for payload base and offset when searching for mergers
Date:   Wed, 26 Jan 2022 23:33:13 +0100
Message-Id: <20220126223314.297735-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126223314.297735-1-pablo@netfilter.org>
References: <20220126223314.297735-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend the existing checks to cover the payload base and offset.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 9a93e3b8d296..5882f3bd005d 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -40,6 +40,10 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 
 	switch (expr_a->etype) {
 	case EXPR_PAYLOAD:
+		if (expr_a->payload.base != expr_b->payload.base)
+			return false;
+		if (expr_a->payload.offset != expr_b->payload.offset)
+			return false;
 		if (expr_a->payload.desc != expr_b->payload.desc)
 			return false;
 		if (expr_a->payload.tmpl != expr_b->payload.tmpl)
-- 
2.30.2

