Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69790C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Apr 2022 18:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380058AbiD2Siy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 14:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380059AbiD2Siw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 14:38:52 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC1D89CE3
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Apr 2022 11:35:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nkVSl-0001tO-BI; Fri, 29 Apr 2022 20:35:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] netlink: swap byteorder for host-endian concat data
Date:   Fri, 29 Apr 2022 20:32:37 +0200
Message-Id: <20220429183239.5569-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429183239.5569-1-fw@strlen.de>
References: <20220429183239.5569-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All data must be passed in network byte order, else matching
won't work respectively kernel will reject the interval because
it thinks that start is after end

This is needed to allow use of 'ppp*' in interval sets with
concatenations.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 240c937e3ac5..89d864ed046a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -259,6 +259,10 @@ static int netlink_gen_concat_data_expr(int end, const struct expr *i,
 			mpz_t v;
 
 			mpz_init_bitmask(v, i->len - i->prefix_len);
+
+			if (i->byteorder == BYTEORDER_HOST_ENDIAN)
+				mpz_switch_byteorder(v, i->len / BITS_PER_BYTE);
+
 			mpz_add(v, i->prefix->value, v);
 			count = netlink_export_pad(data, v, i);
 			mpz_clear(v);
-- 
2.35.1

