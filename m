Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E817AC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3DE361360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhKFRRi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234660AbhKFRRh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:37 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8AFC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BiwUdH7lXOd0Rzogy1liG2GpCkaBFtDzGBsHmco0e1Y=; b=CmHadix/DCE+oKn2ZV1CHlcdLo
        VbACEZtctk8gmwZjRKGuS0HC9UVr+iqC2YmSzZQlGYHxKmTmIdF4THUlUFa9zMDoHmwLMnE5Pk9gu
        KoRJMfFzDFJIH7c+ECJ6MIq4ITQrsulanKkmeKSoiSBHt7OUGFHjhsLZodzML4D9AYma5Ziss6xcK
        H2cXtFFhnHUvl+Olr3wXvOy525JmrCs73HsLcl4jBcNGO8/HdBEpeaiTcLyFoFCTll/CJmGikEhOn
        2+BAoe5EayZoMOJJR57N3maJ/uo38wF918VfzzC33sTEI5YYrfr0hFr1vZEmbcwUIb5mmiZOtD5hu
        9SV/g8UA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtL-004m1E-BX
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 23/27] output: JSON: fix output of GMT offset
Date:   Sat,  6 Nov 2021 16:49:49 +0000
Message-Id: <20211106164953.130024-24-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`gmt_offset` is a `long int`.  Use `labs` and update the format-specifier
to match.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 6edfa902efaf..621333261733 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -303,10 +303,10 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		t = localtime_r(&now, &result);
 		if (unlikely(*opi->cached_tz = '\0' || t->tm_gmtoff != opi->cached_gmtoff)) {
 			snprintf(opi->cached_tz, sizeof(opi->cached_tz),
-				 "%c%02d%02d",
+				 "%c%02ld%02ld",
 				 t->tm_gmtoff > 0 ? '+' : '-',
-				 abs(t->tm_gmtoff) / 60 / 60,
-				 abs(t->tm_gmtoff) / 60 % 60);
+				 labs(t->tm_gmtoff) / 60 / 60,
+				 labs(t->tm_gmtoff) / 60 % 60);
 		}
 
 		if (pp_is_valid(inp, opi->usec_idx)) {
-- 
2.33.0

