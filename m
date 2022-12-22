Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C28C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 16:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiLVQ00 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 11:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiLVQ0G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 11:26:06 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659AC201AF
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 08:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mHJJ3Ax4//fMbj9htqx98H23O+w8Xzu57DrGGMSwewg=; b=n7HfnnWFRpixXLCMCvpyeDuvA9
        7xyVTMa2HBtjf8s05sL2r0WoXAB4leTnv9wc35Uvw99crVSbnh10Bd52/bcsE7Gz7qoDP4y4UVUfa
        v8l9VY0AKOyJ4dO5jyuXVHPuuqcMhmLQt7B0z+nV8liaHX3q5ZyhO8w+33+flkXN79aB3blqIwJ7a
        CAIj0ThdcTB2XhHITm+uYYZ0m4RkqF+A1Gpa4D8QBvPolb4nnJzYiSdBoD1ANxRqShybicxPbAygM
        Xl5agLONo15X8RwZUMVW+Q4gBvrvC8ybwqOrQ1dG/ALtRhIXPYTpHDHgJxKlYXnDtBQUa9oI0J5Zn
        S+IQPIZQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p8OOJ-0007LO-PD
        for netfilter-devel@vger.kernel.org; Thu, 22 Dec 2022 17:25:55 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] gitignore: Ignore utils/nfsynproxy
Date:   Thu, 22 Dec 2022 17:25:39 +0100
Message-Id: <20221222162541.30207-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 9e6928f037823 ("utils: add nfsynproxy tool")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 utils/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/utils/.gitignore b/utils/.gitignore
index 6300812b1701b..e508bb3270c4f 100644
--- a/utils/.gitignore
+++ b/utils/.gitignore
@@ -2,3 +2,4 @@
 /nfnl_osf.8
 /nfbpf_compile
 /nfbpf_compile.8
+/nfsynproxy
-- 
2.38.0

