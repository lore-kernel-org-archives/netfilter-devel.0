Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EB2C3A5A7
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 15:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLHPrI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 10:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbiLHPrH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 10:47:07 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679AB63D7D
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 07:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4laufm7ea+oo9Mw8hqjCrZsc1QL5bDY8G7oyW/Cj5sM=; b=kwGwd2b5Xb/sEalx8jZ8+f7+yp
        oIRnZ39zQ0tSD824XgXW3QI87JdfNAXLWCMV7cmcpQfa4IWneagI0Q4z/WXsR0jOK9vkaByHdbCrf
        y3kGQ01WgQarZlP64ZggEG4PR4Z3pNAJdma9NWqlekomUWgHCIBQnpOUqb9jclDEq6YoUQm3XB5ix
        YD1CagLOgR1i0B0Swwj6oCJdB4NGG6i3+QFuuxsLVgpQspVYhH1RS4eXnKM6amfQMjr/yZQYT4iJ7
        rWf1HGWWROglVplur4Ro5cZkOkf1HU4OC55Hm6unfg0FrI5Hvuncn7WGgkuoAxebf2e03mGa6Neu9
        1PpJIMVA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p3J71-0005g4-0U; Thu, 08 Dec 2022 16:47:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH v2 08/11] Makefile: Generate .tar.xz archive with 'make dist'
Date:   Thu,  8 Dec 2022 16:46:13 +0100
Message-Id: <20221208154616.14622-9-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221208154616.14622-1-phil@nwl.cc>
References: <20221208154616.14622-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Instead of the default .tar.gz one.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Generate .tar.xz instead of .tar.bz2, suggested by Jan and Pablo.
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 1292f4b7065f4..dc3552067a67f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,7 +1,7 @@
 # -*- Makefile -*-
 
 ACLOCAL_AMFLAGS  = -I m4
-AUTOMAKE_OPTIONS = foreign subdir-objects
+AUTOMAKE_OPTIONS = foreign subdir-objects dist-xz no-dist-gzip
 
 SUBDIRS          = libiptc libxtables
 if ENABLE_DEVEL
-- 
2.38.0

