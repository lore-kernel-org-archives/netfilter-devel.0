Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD85C001DE
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 11:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjGaLko (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 07:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbjGaLkm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 07:40:42 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE17AE65
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 04:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
        In-Reply-To:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yrchKUk/1hXK3xXqXzTY3d88OeDabLg41TSuvL5ZJwg=; b=OG9u986Xoe2SZ2WyXI/BlKJtrD
        aVclpsozdoiF7KeTA5Jkqtq4tGKvw7FbFtFjoCpyZcRE/DB+TOlPcmA/ksul6wAbq+4BhNA0/sNeZ
        xFXEgxQ/MDmFY4KDbSJuTU4Q4qeWzbIwXJ4j/4BFyMXu6KRLHYVrDEqR9+Ga8IGEXLTW7NgbEeMQ0
        jd4RnyZp7TGYjoFoTepJCTE27M0kFukgzYx8ZQf4EqZohaeW5hgqFcdXv4hqeUf76Ju+P7rG67OBg
        oOxwW2aMpe8IgKcm2LcwUrCYiSbPUekf05wY7JeiBQ361LAXmjc+8H50/tMFvDwJAWg758jAVt2C2
        2klEFaGw==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qQRGP-0062Uw-1W
        for netfilter-devel@vger.kernel.org;
        Mon, 31 Jul 2023 12:40:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 2/3] py: use setup.cfg to configure setuptools
Date:   Mon, 31 Jul 2023 12:40:23 +0100
Message-Id: <20230731114024.2836892-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230731114024.2836892-1-jeremy@azazel.net>
References: <20230731114024.2836892-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Setuptools has had support for declarative configuration for several
years.  To quote their documentation:

  Setuptools allows using configuration files (usually setup.cfg) to
  define a package’s metadata and other options that are normally
  supplied to the setup() function (declarative config).

  This approach not only allows automation scenarios but also reduces
  boilerplate code in some cases.

Additionally, this allows us to introduce support for PEP-517-compatible
build-systems.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 py/Makefile.am |  2 +-
 py/setup.cfg   | 24 ++++++++++++++++++++++++
 py/setup.py    | 23 ++---------------------
 3 files changed, 27 insertions(+), 22 deletions(-)
 create mode 100644 py/setup.cfg

diff --git a/py/Makefile.am b/py/Makefile.am
index 4056aa61f820..974539fd44ad 100644
--- a/py/Makefile.am
+++ b/py/Makefile.am
@@ -1 +1 @@
-EXTRA_DIST = setup.py src
+EXTRA_DIST = setup.cfg setup.py src
diff --git a/py/setup.cfg b/py/setup.cfg
new file mode 100644
index 000000000000..953b7f4164b4
--- /dev/null
+++ b/py/setup.cfg
@@ -0,0 +1,24 @@
+[metadata]
+name = nftables
+version = attr: nftables.NFTABLES_VERSION
+description = Libnftables binding
+author = Netfilter project
+author_email = coreteam@netfilter.org
+url = https://netfilter.org/projects/nftables/index.html
+provides = nftables
+classifiers =
+  Development Status :: 4 - Beta
+  Environment :: Console
+  Intended Audience :: Developers
+  License :: OSI Approved :: GNU General Public License v2 (GPLv2)
+  Operating System :: POSIX :: Linux
+  Programming Language :: Python
+  Topic :: System :: Networking :: Firewalls
+
+[options]
+packages = nftables
+package_dir =
+  nftables = src
+
+[options.package_data]
+nftables = schema.json
diff --git a/py/setup.py b/py/setup.py
index d08b8b129a81..beda28e82166 100755
--- a/py/setup.py
+++ b/py/setup.py
@@ -1,24 +1,5 @@
 #!/usr/bin/env python
+
 from setuptools import setup
-from nftables import NFTABLES_VERSION
 
-setup(name='nftables',
-      version=NFTABLES_VERSION,
-      description='Libnftables binding',
-      author='Netfilter project',
-      author_email='coreteam@netfilter.org',
-      url='https://netfilter.org/projects/nftables/index.html',
-      packages=['nftables'],
-      provides=['nftables'],
-      package_dir={'nftables':'src'},
-      package_data={'nftables':['schema.json']},
-      classifiers=[
-          'Development Status :: 4 - Beta',
-          'Environment :: Console',
-          'Intended Audience :: Developers',
-          'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
-          'Operating System :: POSIX :: Linux',
-          'Programming Language :: Python',
-          'Topic :: System :: Networking :: Firewalls',
-          ],
-      )
+setup()
-- 
2.40.1

