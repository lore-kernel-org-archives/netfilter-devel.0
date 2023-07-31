Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C084C001E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 11:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjGaLkp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 07:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjGaLkm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 07:40:42 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE373E66
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 04:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M+LBxTU3hMTj4ZbA4kgl9bMln3HtpV/bbucaEcYTjM4=; b=PhjzTok1Zn4O7HgA/SZZ3blIWi
        UXdvPf7ts+6Pm5omgO9nQPzeyYCEG1HB98/bDbBHS6J9svEdYzrbbZ+2QEPgTbXRhU4VnPKhKVy5s
        uQ/dxNIwgWOhrxjjXfCWWfhOXqc0DFt51SqkNKYOGUaflSIoWmdU6whJiuwBLv2mudwOJMgEHw7T/
        BQ9YzSxYtvymCN33w9E8TMYwMJaZzcqNOI+3WPUKS4wDcrLOqt225+Er5NkjdT8qrHhkt0ecLMvbP
        SCGu3KdIYMnZlG7VwBGa+rLKbm8OkKhdMdeVUl0IFoMRnv7IMd8iGZK+6SYxoz7HK4ZtjLqSPssFU
        Xev2r+ZA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qQRGP-0062Uw-1f
        for netfilter-devel@vger.kernel.org;
        Mon, 31 Jul 2023 12:40:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 3/3] py: add pyproject.toml to support PEP-517-compatible build-systems
Date:   Mon, 31 Jul 2023 12:40:24 +0100
Message-Id: <20230731114024.2836892-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230731114024.2836892-1-jeremy@azazel.net>
References: <20230731114024.2836892-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes it possible to build and install the module without directly
invoking setup.py which has been deprecated.

Retain the setup.py script for backwards-compatibility.

Update INSTALL to mention the new config-file.

Link: https://blog.ganssle.io/articles/2021/10/setup-py-deprecated.html
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 INSTALL           | 3 ++-
 py/Makefile.am    | 2 +-
 py/pyproject.toml | 3 +++
 3 files changed, 6 insertions(+), 2 deletions(-)
 create mode 100644 py/pyproject.toml

diff --git a/INSTALL b/INSTALL
index 9b626745d7a4..53021e5aafc3 100644
--- a/INSTALL
+++ b/INSTALL
@@ -86,7 +86,8 @@ Installation instructions for nftables
 
  CPython bindings are available for nftables under the py/ folder.
 
- setup.py is provided to install it.
+ A pyproject.toml config file and legacy setup.py script are provided to install
+ it.
 
  Source code
  ===========
diff --git a/py/Makefile.am b/py/Makefile.am
index 974539fd44ad..76aa082f8709 100644
--- a/py/Makefile.am
+++ b/py/Makefile.am
@@ -1 +1 @@
-EXTRA_DIST = setup.cfg setup.py src
+EXTRA_DIST = pyproject.toml setup.cfg setup.py src
diff --git a/py/pyproject.toml b/py/pyproject.toml
new file mode 100644
index 000000000000..fed528d4a7a1
--- /dev/null
+++ b/py/pyproject.toml
@@ -0,0 +1,3 @@
+[build-system]
+requires = ["setuptools"]
+build-backend = "setuptools.build_meta"
-- 
2.40.1

