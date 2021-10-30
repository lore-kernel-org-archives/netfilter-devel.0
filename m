Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88453C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EF5A603E8
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJ3RNh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJ3RNh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:37 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D612C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BiwUdH7lXOd0Rzogy1liG2GpCkaBFtDzGBsHmco0e1Y=; b=TgTEq9xvhpT6bANTxFhyFALDOL
        lWd1/rjIm/IpQmxs4AXFsOawft2pnJAdcMoY8RvKR7fUMblbZdYEw98qTjzQ2OvvZYUUWUYCl3d2p
        fgyHmJZ5d4XJDkvNzN8jCCDGWbsS2GMqPYcC9JuSITqQWBT/SofRQ6SS28PL8cHyvgPbh8Tr0YI0F
        VOy4ix8nffuFazWW4eijjvtZBuncd9F2grcHJHdvKo0a1eavvWe+SRkLiSs3yx5/GygsLeyjCsq0R
        rD8YIwK+HNEJmmkqU2Q25HVbUJ9v+3Y55guIjdM+N6r4+xQkzwairDjavpZhA7qwb8BhHO8aWbCLW
        KQbkghDQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTB-00AFgT-28
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 23/26] output: JSON: fix output of GMT offset.
Date:   Sat, 30 Oct 2021 17:44:29 +0100
Message-Id: <20211030164432.1140896-24-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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

