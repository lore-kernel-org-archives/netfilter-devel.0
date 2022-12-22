Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FF4C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 16:26:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235438AbiLVQ0g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 11:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiLVQ0V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 11:26:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BA825C53
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 08:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wJ8SiLAR5Mq12BzFVR69/Q04Ex7XiWJE2b4CK74smpk=; b=Ts4D4cH7yUkKS9Nutg8dBWhar0
        LfDUxPqzDwsTYfkIfN+G7/DNkjkh369ZM0/XM9b1rZclR2AvRSy5f4VTTi6dTWekte8zVG4tpkSCR
        ZoRCgpP2gaxI3KfKo1wE991K5/y1yaNjqD0TJqLRViF1Slwr2h5zu7Dg8HY6/2EaK3k0TQY4NGLzU
        GoRoRDZXMVVRTZj5tXbiVpqOnZF3cLpOAu/0vo10pvA8Q/SE7q59znoeVKmUZ/r4VSA0uoWpbcKI5
        tinXkSe3BLKYmG81jxBA70heBl1t+WKjY8zdOep2JlNrQmGLOGcgieL15NTKZduNOy+EaoONz5/HM
        QvENWSYw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p8OOP-0007LS-23
        for netfilter-devel@vger.kernel.org; Thu, 22 Dec 2022 17:26:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] gitignore: Ignore generated ip6tables man pages
Date:   Thu, 22 Dec 2022 17:25:40 +0100
Message-Id: <20221222162541.30207-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221222162541.30207-1-phil@nwl.cc>
References: <20221222162541.30207-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 127eadee563e4 ("Makefile: Generate ip6tables man pages on the fly")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/.gitignore | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/iptables/.gitignore b/iptables/.gitignore
index cd7d87b127ae6..245e1245727bd 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -1,6 +1,10 @@
 /ip6tables
+/ip6tables.8
+/ip6tables-apply.8
 /ip6tables-save
+/ip6tables-save.8
 /ip6tables-restore
+/ip6tables-restore.8
 /ip6tables-static
 /ip6tables-translate.8
 /ip6tables-restore-translate.8
-- 
2.38.0

