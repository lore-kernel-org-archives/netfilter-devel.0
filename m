Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1BDC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jan 2022 22:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiAZWdZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 17:33:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58152 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiAZWdY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 17:33:24 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 41BF260256
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:30:20 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables 4/4] optimize: do not merge raw payload expressions
Date:   Wed, 26 Jan 2022 23:33:14 +0100
Message-Id: <20220126223314.297735-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126223314.297735-1-pablo@netfilter.org>
References: <20220126223314.297735-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merging raw expressions results in a valid concatenation which throws:

 Error: can not use variable sized data types (integer) in concat expressions

Disable merging raw expressions until this is supported by skipping raw
expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/optimize.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/optimize.c b/src/optimize.c
index 5882f3bd005d..04523edb795b 100644
--- a/src/optimize.c
+++ b/src/optimize.c
@@ -40,6 +40,9 @@ static bool __expr_cmp(const struct expr *expr_a, const struct expr *expr_b)
 
 	switch (expr_a->etype) {
 	case EXPR_PAYLOAD:
+		/* disable until concatenation with integer works. */
+		if (expr_a->payload.is_raw || expr_b->payload.is_raw)
+			return false;
 		if (expr_a->payload.base != expr_b->payload.base)
 			return false;
 		if (expr_a->payload.offset != expr_b->payload.offset)
-- 
2.30.2

