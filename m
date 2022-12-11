Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F648C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 11 Dec 2022 16:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiLKQqu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Dec 2022 11:46:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiLKQqu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2022 11:46:50 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A02BBC33
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2022 08:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OwR5ThgoPVrWlEjqXmdEoVPj1W+l0A59d9opBf5+UGk=; b=ZBjBJ5MoJmALwm+Ljub0AVC53i
        3t2n6b/CFg5UBG48JfYEqgAClFaESPYcG55oyew85c1Sh/Sx/nbV84ESnTI2Tk85QEGAM1M10r9Bw
        SAfrpLiCI5wevequ+aW9WyPGZz4sw4ql8wnjHFNShZtqtQEUeG7kwxjjdMLXF+ii7vGjsy+6CZeNT
        M/38nM7I1a/cnv+FiBY1cj6s9ynILkbvbaAhno/zLNFrfHFOSfJVD598ucGBGGKZfol4R9P4iPG/0
        OkIX7rvY8uXpSY80clpNIksANyDuz+NKiQTVO96iNJwtzprEtXt6x+pfugbFMojCzeeIYy5dU1haN
        n0k+2cLw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p4PTN-008tm0-44
        for netfilter-devel@vger.kernel.org; Sun, 11 Dec 2022 16:46:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2] build: fix pgsql fall-back configuration of CFLAGS
Date:   Sun, 11 Dec 2022 16:46:31 +0000
Message-Id: <20221211164631.812617-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
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

