Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87D6C61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Feb 2023 10:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjBVKVa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Feb 2023 05:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBVKV3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Feb 2023 05:21:29 -0500
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718C34F7C
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 02:21:22 -0800 (PST)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4PMByV0twGzDqFV
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Feb 2023 10:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1677061282; bh=tzkxQQqjE9QTThziZepYtodPkyuICqQk7OD4Q6voKMU=;
        h=From:To:Cc:Subject:Date:From;
        b=bV5oTaIQ323y9VNNuZ29WXgDWaojFbnJVUcB/7RHooK4NeEMjknLnHoHU68cNiZKe
         RTmTzFUUgv1ZDPQdvLMUcgABa/Ci8dD7zt0mJoSb0H+swqYjZncrhZSx5scaO7/GPI
         dEWVXOYIWbbb0Wsx+d2MPaDZcTmdml+DbQn14VUs=
X-Riseup-User-ID: 3EDDC884C590D90C9F7066EB852F3200DD75742B8E97CCF2A711C8E652F5BCE9
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4PMByT2b87z1y8Z;
        Wed, 22 Feb 2023 10:21:21 +0000 (UTC)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     ffmancera@riseup.net
Subject: [PATCH nft] py: replace distutils with setuptools
Date:   Wed, 22 Feb 2023 11:20:55 +0100
Message-Id: <20230222102055.20099-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Removes a deprecation warning when using distutils and python >=3.10.

Python distutils module is formally marked as deprecated since python
3.10 and will be removed from the standard library from Python 3.12.
(https://peps.python.org/pep-0632/)

From https://setuptools.pypa.io/en/latest/setuptools.html

"""
Packages built and distributed using setuptools look to the user like
ordinary Python packages based on the distutils.
"""

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 py/setup.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/py/setup.py b/py/setup.py
index 72fc8fd9..8ad73e7b 100755
--- a/py/setup.py
+++ b/py/setup.py
@@ -1,5 +1,5 @@
 #!/usr/bin/env python
-from distutils.core import setup
+from setuptools import setup
 from nftables import NFTABLES_VERSION
 
 setup(name='nftables',
-- 
2.39.2

