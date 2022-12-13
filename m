Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953A5C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Dec 2022 11:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiLMLUL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 06:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbiLMLUJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 06:20:09 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C31E000
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Dec 2022 03:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=f5gHMAd3uAOqVKvhuH06rBHzqauBpR3tOd0BpeoD474=; b=fKU+A1k6Pk86oUCkqNM7POLkfF
        lkhiGVJxG7C/DjKG+6HB+fi/7GEns4R7wdJ7/RhhC8j9UKpwKjQHgZB1RKpdvHi80Sl5jdciIoLsL
        zjuEx53/TiBI7BU00UDPsFkHt7k9OXHxwhxbkQNrRYMYbe14Vaj14ow0j7gaoP4xFr3c9EVCc9SRh
        4JvWD0XSK7NNXX/+M36GxexZhtQcFBz0RX1k/NfPqDALEUKZ9E8ezPs3JnBB7+AM4w4o2sczWpQAv
        hC0kkU3LfuVfE4iA/cd2CjPRBDuGgsKtS/HCMm6zOmilSxeFTDwLZE9B/HPFqI7uGl9nBv8jxsr3d
        ph1jOwkw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p53KL-00B0kU-7z
        for netfilter-devel@vger.kernel.org; Tue, 13 Dec 2022 11:20:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2] build: fix pgsql fall-back configuration of CFLAGS
Date:   Tue, 13 Dec 2022 11:19:51 +0000
Message-Id: <20221213111951.927552-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221211164631.812617-1-jeremy@azazel.net>
References: <20221211164631.812617-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When using mysql_config and pcap_config to configure `CFLAGS`, one
requests the actual flags:

  $mysql_config --cflags
  $pcap_config --cflags

By constrast, when using pg_config, one requests the include-directory:

  $pg_config --includedir

Therefore, the `-I` option has to be explicitly added.

Fixes: 20727ab8b9fc ("build: use pkg-config or pg_config for libpq")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
In v1, I forgot to add the `Fixes:` tag.

 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 6ee29ce321d0..70eed9dc1745 100644
--- a/configure.ac
+++ b/configure.ac
@@ -92,7 +92,7 @@ AS_IF([test "x$enable_pgsql" != "xno"], [
 
     AS_IF([command -v "$pg_config" >/dev/null], [
 
-      libpq_CFLAGS="`$pg_config --includedir`"
+      libpq_CFLAGS="-I`$pg_config --includedir`"
       libpq_LIBS="`$pg_config --libdir` -lpq"
 
       AC_SUBST([libpq_CFLAGS])
-- 
2.35.1

