Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68138C54EBC
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 14:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjALODM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjALODK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 09:03:10 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560866174
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 06:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BoIgTS/o5zoHImF1/xGJWOhlyOkfvbFwlgQIo8gB9qE=; b=RqmzGA8FIFRkV18ldhoC1q+bLX
        uAvzlMpob0i1qEvHCFxpofv4Mg7lhJApQ1hCqPQEcwkKz/3gKW7FJ/1riLfV8vozeSL/sr0SxZwa2
        3shiYcS4EVKvlwqKTEcFWDNvHYl6SIbqb94pqwgddrgeDm9F65oztIpRxt17Nfq8iGsPEYif+KrHn
        nXZj3A9GMYv/JGVr2bqEjj6FVKMcd3Hj9L84K8C7wf1LIUfsLv/1mZO3y4Zsmm23jTm3M4wA1P6vy
        YxQLMrXpfA4ZXTvLhAs7RuQRDjqZYd3oHo8GzEugjTTwmKK5HncAcWpHeZ1Yh08a7cy4XmEcJKNKL
        wsDoBPOQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pFyAd-0006QM-BF
        for netfilter-devel@vger.kernel.org; Thu, 12 Jan 2023 15:03:07 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: NAT: Fix for -Werror=format-security
Date:   Thu, 12 Jan 2023 15:03:03 +0100
Message-Id: <20230112140303.17986-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Have to pass either a string literal or format string to xt_xlate_add().

Fixes: f30c5edce0413 ("extensions: Merge SNAT, DNAT, REDIRECT and MASQUERADE")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_NAT.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_NAT.c b/extensions/libxt_NAT.c
index da9f22012c5d6..2a6343986d54f 100644
--- a/extensions/libxt_NAT.c
+++ b/extensions/libxt_NAT.c
@@ -424,7 +424,7 @@ __NAT_xlate(struct xt_xlate *xl, const struct nf_nat_range2 *r,
 	if (r->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		return 0;
 
-	xt_xlate_add(xl, tgt);
+	xt_xlate_add(xl, "%s", tgt);
 	if (strlen(range_str))
 		xt_xlate_add(xl, " to %s", range_str);
 	if (r->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-- 
2.38.0

