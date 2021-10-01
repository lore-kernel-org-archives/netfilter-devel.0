Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D9FC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EAEC61A10
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhJARrY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355106AbhJARrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E51DC06177F
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+h56Sy0+UdoWEiItUs4F4I3Zcaqfu9wn35hlVLRMAOg=; b=BXRRXT+ROn4ewEte77K6vEgkaT
        BKlCINUz3A6oTQ7FuMPWnay1iO0MgfFnKcx6B+c1m5aVqXpSbKYaBc+r/LdKCWyW9KDXSjgymU/KK
        PAITkpa0NlWeWRN8P9iNjHbwZNxJE8SXZIIbl1YemQLWFI0sqwn67ufpcx7dSzC/DEvdsxcUlP/Q/
        xGXO+d3xrzqhO55jECHZMulIcy0SHoSXN3JRL46XszeCqxe3JWuX/DgiphTUwFzwUibHvl2bBiuGy
        sbLSV9uUvvgQw0xtwz5HV9MH+O5Hy/0pBuQfyAqtjUDE/KkkAabSAYs7w9aF8wHu27e4VthxE+GHc
        mh14ZqUA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbH-002RLP-8K; Fri, 01 Oct 2021 18:45:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 6/8] extensions: libxt_NFLOG: remove extra space when saving targets with prefixes
Date:   Fri,  1 Oct 2021 18:41:40 +0100
Message-Id: <20211001174142.1267726-7-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When printing out NFLOG targets an extra space was inserted between
`--nflog-prefix` and the prefix itself:

  $ sudo /usr/sbin/iptables -A INPUT -j NFLOG --nflog-prefix test
  $ sudo /usr/sbin/iptables-save | grep NFLOG
  -A INPUT -j NFLOG --nflog-prefix  test
                                  ^^
Fixes: 73866357e4a7 ("iptables: do not print trailing whitespaces")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.c | 2 +-
 extensions/libxt_NFLOG.t | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 2b78e27808f8..6137a68f8cd2 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -83,7 +83,7 @@ static void NFLOG_check(struct xt_fcheck_call *cb)
 static void nflog_print(const struct xt_nflog_info *info, char *prefix)
 {
 	if (info->prefix[0] != '\0') {
-		printf(" %snflog-prefix ", prefix);
+		printf(" %snflog-prefix", prefix);
 		xtables_save_string(info->prefix);
 	}
 	if (info->group)
diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 13bbf2bfc5a5..561ec8c77650 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -14,8 +14,8 @@
 -j NFLOG --nflog-size 4294967295;=;OK
 -j NFLOG --nflog-size 4294967296;;FAIL
 -j NFLOG --nflog-size -1;;FAIL
--j NFLOG --nflog-prefix  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;=;OK
--j NFLOG --nflog-prefix  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;-j NFLOG --nflog-prefix  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;OK
+-j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;=;OK
+-j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;-j NFLOG --nflog-prefix xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;OK
 -j NFLOG --nflog-threshold 1;=;OK
 # ERROR: line 13 (should fail: iptables -A INPUT -j NFLOG --nflog-threshold 0
 # -j NFLOG --nflog-threshold 0;;FAIL
-- 
2.33.0

