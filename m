Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A23E1C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 23:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjKDXCI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Nov 2023 19:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbjKDXCH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2023 19:02:07 -0400
Received: from mx3.azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D290FB
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2023 16:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VNFPpk76Qepamv4EzRsUc2T24KE3bTVTgkX64w47ocA=; b=HChFr6rND8d3qZ4KWunOK59m9z
        KKBqUzvLz3l8EHNUus5gmoGFuZSm7Ck1Ay+qlAQIeAV3hpWEVFxmpgNt18o1P8O3fH5bBAhOhSy+s
        9riQaqMDYvLZ4FLCkb2Vp81NKXiScg73C5UrzPvNESSjoWKkGrQYG0QQAx6YMTVLyJ2clfw6M3UZq
        EpP/mBNHk+FpD3ZTHVJrmhOmUXNShuwP0UO1yoLHTxoGrCWjmK7/vLedr8dhfTpWf2H0tCJaS/+r4
        ZXW2JOJo71mUq+Accc3bhVRx8VyqdiQSF5USwN6yBdMLJoDNnMAc3uUJ+Jc5LdH5N6SwNDyslMUvD
        QVx+67fg==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qzPeT-009Wz7-0B
        for netfilter-devel@vger.kernel.org;
        Sat, 04 Nov 2023 23:02:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libmnl v2] nlmsg: fix false positives when validating buffer sizes
Date:   Sat,  4 Nov 2023 23:01:54 +0000
Message-ID: <20231104230154.2006144-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `len` parameter of `mnl_nlmsg_ok`, which holds the buffer length and
is compared to the size of the object expected to fit into the buffer,
is signed because the function validates the length, and it can be
negative in the case of malformed messages.  Comparing it to unsigned
operands used to lead to compiler warnings:

  msg.c: In function 'mnl_nlmsg_ok':
  msg.c:136: warning: comparison between signed and unsigned
  msg.c:138: warning: comparison between signed and unsigned

and so commit 73661922bc3b ("fix warning in compilation due to different
signess") added casts of the unsigned operands to `int`.  However, the
comparison to `nlh->nlmsg_len`:

  (int)nlh->nlmsg_len <= len

is problematic, since `nlh->nlmsg_len` is of type `__u32` and so may
hold values greater than `INT_MAX`.  In the case where `len` is positive
and `nlh->nlmsg_len` is greater than `INT_MAX`, the cast will yield a
negative value and `mnl_nlmsg_ok` will incorrectly return true.

Instead, assign `len` to an unsigned local variable, check for a
negative value first, then use the unsigned local for the other
comparisons, and remove the casts.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1691
Fixes: 73661922bc3b ("fix warning in compilation due to different signess")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
Changes since v1

 * Dropped changes to `mnl_attr_ok` which is not affected by the overflow bug.
 * Reworded the commit message to make it (hopefully) easier to parse (if not
   shorter :-)).

 src/nlmsg.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index c63450174c67..30a7e639fad6 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -152,9 +152,14 @@ EXPORT_SYMBOL void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh,
  */
 EXPORT_SYMBOL bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
-	return len >= (int)sizeof(struct nlmsghdr) &&
+	size_t ulen = len;
+
+	if (len < 0)
+		return false;
+
+	return ulen           >= sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
-	       (int)nlh->nlmsg_len <= len;
+	       nlh->nlmsg_len <= ulen;
 }
 
 /**
-- 
2.42.0

