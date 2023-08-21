Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B667EE4996
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 11:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbjHUL2s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 07:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232252AbjHUL2r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 07:28:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 36469DC
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 04:28:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net
Subject: [PATCH nft,v2] INSTALL: provide examples to install python bindings
Date:   Mon, 21 Aug 2023 13:28:40 +0200
Message-Id: <20230821112840.27221-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Provide examples to install python bindings with legacy setup.py and pip
with .toml file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add Jeremy's feedback.

 INSTALL | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/INSTALL b/INSTALL
index 53021e5aafc3..6539ebdd6457 100644
--- a/INSTALL
+++ b/INSTALL
@@ -84,10 +84,14 @@ Installation instructions for nftables
  Python support
  ==============
 
- CPython bindings are available for nftables under the py/ folder.
+ CPython bindings are available for nftables under the py/ folder.  They can be
+ installed using pip:
 
- A pyproject.toml config file and legacy setup.py script are provided to install
- it.
+    python -m pip install py/
+
+ Alternatively, legacy setup.py script is also provided to install it:
+
+	python setup.py install
 
  Source code
  ===========
-- 
2.30.2

