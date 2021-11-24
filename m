Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A93C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347800AbhKXWsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346037AbhKXWsd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:33 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5EDC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QAaVH8Bv6AvhYDfKHiw3jNqfN3emI88hEll8l1Laocc=; b=AlkbUPxSRcZ7FblEkl5nRR65dc
        JyE5QGg4Ea8dJ92kxWFrC34GgR+pZa8lDclFW7NkKBoV4q3Cpw+djmlfFFgQlmZGgpJVswnii2o8U
        n/pT2cKQ77YOmG6O0KwfaCtenpzAyuotY26I22jDwwZWrvV6wHw4FFq0MuJWOtFXoD1JGlz5BptNm
        Ud4lqtEpCH+ymXMhSfiuB7SUleqfY/THYtAHiKGL7rXHzHzpfx1S/hwBtTZdbHCpgdCP7BnbDbsvO
        Rs3zLHf15P/AXwJQDpLk+4aNHHKhH7CiKufoLYPQYswV9QjmwrTzLdaxjdEya5NXkIQsu05ULQTZs
        FN05pfCg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hB-00563U-79
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:53 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 30/32] output: JSON: optimize appending of newline to output
Date:   Wed, 24 Nov 2021 22:24:42 +0000
Message-Id: <20211124222444.2597311-48-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We have `buflen` available.  We can remove `strncat` and assign the characters
directly, without traversing the whole buffer.

Fixes a compiler warning:

  logd_output_JSON.c:407:9: warning: `strncat` specified bound 1 equals source length

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 6af872c64391..f60bd6ea51da 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -404,8 +404,8 @@ static int json_interp(struct ulogd_pluginstance *upi)
 		return ULOGD_IRET_ERR;
 	}
 	buf = tmp;
-	strncat(buf, "\n", 1);
-	buflen++;
+	buf[buflen++] = '\n';
+	buf[buflen]   = '\0';
 
 	if (opi->mode == JSON_MODE_FILE)
 		return json_interp_file(upi, buf);
-- 
2.33.0

