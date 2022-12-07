Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C861C63708
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 17:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiLGRpB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 12:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbiLGRo5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 12:44:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D97528AB
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 09:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hu9Fqapqq+o/g+t8Ydyy/0DjgvMo1RRUc82z1HJKEFE=; b=Demg6LBL9bquKlLkUylONsldTp
        xQ3WGhGISfbAjlzKP2zhNaeifqViOE4iZoUt9RjbednzNvjMpBYhYbxZ76Mg69+MBcapoXUdQWPhn
        mtt++ZVRkO9uUrqLDngkVuLhzC4pzdb3gHfGPHPiOzJKzv80iXcSgHGc+hPRLbx1Umw11xOI5q6MH
        zD1YQN6Q9ISEpj6/jTyrIBPOvLEqcE9BNpceHm3d66/yWlhOPEtR40uGKqx/Y9G4zJmcp7q8U11ri
        tosLldybwC5FWTWHUdX2NsrI5/NsK8bA9UX4Ojn19SUM9kdQHN5UTP/Q8jxElK/rx5vnvO4KNDKwS
        mHCyUwUA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p2yTX-0000fV-Bj
        for netfilter-devel@vger.kernel.org; Wed, 07 Dec 2022 18:44:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/11] Makefile: Generate .tar.bz2 archive with 'make dist'
Date:   Wed,  7 Dec 2022 18:44:27 +0100
Message-Id: <20221207174430.4335-9-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221207174430.4335-1-phil@nwl.cc>
References: <20221207174430.4335-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of the default .tar.gz one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 1292f4b7065f4..4a5c6fd41e8fd 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 ACLOCAL_AMFLAGS  = -I m4
-AUTOMAKE_OPTIONS = foreign subdir-objects
+AUTOMAKE_OPTIONS = foreign subdir-objects dist-bzip2 no-dist-gzip
 
 SUBDIRS          = libiptc libxtables
 if ENABLE_DEVEL
-- 
2.38.0

