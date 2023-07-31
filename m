Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D246C00528
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jul 2023 11:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjGaLkq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jul 2023 07:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjGaLkm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2023 07:40:42 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE50AE68
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2023 04:40:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:To:From:Sender:Reply-To:Cc:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5vpmH/sYFwwjvjEnuFC4H57jOLb0IPMnIkPYru29M7Y=; b=UiYdGLpu76UU4r0TleG4kpsxXa
        GMWjPM2QigQv7DqT4598Ckch7jJcj+lPlmM7VeJtXZ7zW4BYmfelOa9lG7TS0153qfqUifsUfJIyh
        yynis2UVQ0qe/2qSshIG7LBedhwTTX1TbpHTZa9SMKruj4FGE+13IE/6djEfhiIztG7DiiFzLXIfx
        yxOjaX3/5bpi6qLZVn7UoWhk5w15KWf5D+Jh+cR8tGYD8kofi257mWxDYHxUgnX+VMexxoMk4UPJH
        Xl3uDCJ/dDfEN1AFGt87VFpo6sTEe3QBp5pEumyDdAVrZ0a6tMPiA22zMEjold/DOsmaE6xQfFU0p
        ZYX3m6MA==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qQRGP-0062Uw-1D
        for netfilter-devel@vger.kernel.org;
        Mon, 31 Jul 2023 12:40:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft 0/3] Python Build Modernization
Date:   Mon, 31 Jul 2023 12:40:21 +0100
Message-Id: <20230731114024.2836892-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Directly invoking setup.py to build and install a Python module is
deprecated:

  https://blog.ganssle.io/articles/2021/10/setup-py-deprecated.html

Pablo recently removed the autotooling which did this.  This patch-set
updates the Python build configuration to add support for modern
alternatives while leaving the setup.py script around for users who may
need it.

The approach I have used is described here:

  https://setuptools.pypa.io/en/latest/build_meta.html

We move the setuptools configuration out of setup.py into setup.cfg, and
then add a pyproject.toml configuration file to tell PEP-517 build tools
to use setuptools.

Setuptools also supports putting all its configuration into
pyproject.toml files:

  https://setuptools.pypa.io/en/latest/userguide/pyproject_config.html

However, this is much more recent than its setup.cfg support (2022 vs
2016), which is why I decided to stick with the approach described
above.

Jeremy Sowden (3):
  py: move package source into src directory
  py: use setup.cfg to configure setuptools
  py: add pyproject.toml to support PEP-517-compatible build-systems

 INSTALL                  |  3 ++-
 py/Makefile.am           |  2 +-
 py/pyproject.toml        |  3 +++
 py/setup.cfg             | 24 ++++++++++++++++++++++++
 py/setup.py              | 23 ++---------------------
 py/{ => src}/__init__.py |  0
 py/{ => src}/nftables.py |  0
 py/{ => src}/schema.json |  0
 8 files changed, 32 insertions(+), 23 deletions(-)
 create mode 100644 py/pyproject.toml
 create mode 100644 py/setup.cfg
 rename py/{ => src}/__init__.py (100%)
 rename py/{ => src}/nftables.py (100%)
 rename py/{ => src}/schema.json (100%)

-- 
2.40.1

