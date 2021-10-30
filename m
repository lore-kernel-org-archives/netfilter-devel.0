Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7A8C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3FC160F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhJ3RNf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbhJ3RNe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:34 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F98C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MqDvVoiZI8PVBB61Ko9vmd2jEB2twzPs5hpOz3mB/ys=; b=LUyy6N5RtOlulMWpQvZ6tzj4s9
        KiA7nu/KuvXVCskNontJsxycpEmJrLgGNMRZIg251GiUMQEWaigVH9o+UFT1IkBtLtDSB7JtGK8jp
        6+5rdPsydrLgiKCKhUsipDNbL7YHboRR4xwWA49YvJoyxQ4J5Nj6gH0UdPXO+P8S6WpvZBXS45zbG
        2e+y1xm8itMTNuYTorBA4lrHgmP80OUPG0OL2ZASZvxBkZ9Y9zUDMGQm6JMqLbmCssBAFUX+yOWpJ
        IQ3ETpkd8DRjhVQO0wzQn4+quW8vOi16qPrBOiGFcwgTPKJc0fYsjWJJCjXw9z8ZZbFtqewa4erMH
        aY92u4UA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT9-00AFgT-16
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 10/26] filter: HWHDR: remove zero-initialization of MAC type.
Date:   Sat, 30 Oct 2021 17:44:16 +0100
Message-Id: <20211030164432.1140896-11-jeremy@azazel.net>
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

We don't need to initialize `type`, and even if we did the right
value would be `ARPHDR_VOID`, not `0` which is a valid MAC type
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

