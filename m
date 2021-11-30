Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C577C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbhK3K73 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbhK3K71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:27 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2738C061757
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 02:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZItIju5mzti6My9dIyh+yumlniUXn39Z/ny1wmTWSZk=; b=fedOiN6Zor2BRvO/jJ+fdtiETM
        FCYE8CXs5mDK2wapMiXhUtJLHtu3Hs5TkKOfdCPk28auFNmndYLyF8RpTOLCMYpZ1s2LH6DEWTjay
        1VFgV1bUcouNbb0sbDDDNM0FplWjJ5HxZfR4gsqyJkpHbjczxJMKCms4ws6aZid1NDswgfrM2elwG
        2ae+6PQYGTh3M6tgqEK3Uc30mSbgHV3wOLPmlIm+QCbEHKdicGBFpraXTKoQA1RNw/z6vbU308ad+
        YCKAnX37GbyE0Z6RYy7p6TynOcVYlBG5Lqz63/noaVb5U4Jou1NQs6bfURLnv/WObFdCV16rC9vQ0
        x4DjQqvQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-Cq
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 05/32] filter: HWHDR: remove zero-initialization of MAC type
Date:   Tue, 30 Nov 2021 10:55:33 +0000
Message-Id: <20211130105600.3103609-6-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We don't need to initialize `type`, and even if we did the right value
would be `ARPHDR_VOID`, not `0`, which is a valid MAC type
(`ARPHDR_NETROM`).

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 filter/ulogd_filter_HWHDR.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/filter/ulogd_filter_HWHDR.c b/filter/ulogd_filter_HWHDR.c
index 015121511b08..bbca5e9b92f2 100644
--- a/filter/ulogd_filter_HWHDR.c
+++ b/filter/ulogd_filter_HWHDR.c
@@ -171,7 +171,7 @@ static int interp_mac2str(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
-	uint16_t type = 0;
+	uint16_t type;
 
 	if (pp_is_valid(inp, KEY_OOB_PROTOCOL))
 		okey_set_u16(&ret[KEY_MAC_PROTOCOL],
-- 
2.33.0

