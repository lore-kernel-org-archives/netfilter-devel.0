Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF86C19F2D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Aug 2022 02:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiHECe0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 22:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235846AbiHECeZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 22:34:25 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B6D6FA29
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 19:34:23 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id x23so1461113pll.7
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Aug 2022 19:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc;
        bh=DqNzRhaPmQhssRmXMNtY7JKunBlTPRaZjnMbn1AT4eM=;
        b=gx2Az1wLSqCmMfTKUFKK3eBRlbCArzqTkCOm9SNsGwqGS66HCilWOhU4KMu4/UWwy4
         YTGh3eVCO6zT6cfngBRuxkW39hgjIqZD+76ll45s1f1OMOV7rCtlrcqvhlwZAlK7aFmv
         B39z3g36eDx3vVYLu5zuE7mj+L+SR3Vy5o9WuVT4eH97IHFOuik4G+hFtGfMtjmL7YaX
         I0GdknG5GZXFvzfpCUeVHErat50Vqsx3oqQPjZRBUM1yZ3RnUCFfK9yrtjIOCUCR0D71
         jBOy5jUgJMp6SfFQbfNzUMrVFXCAKf87xm03VzG9ZVZ4F3eDIuI6VkJG/5HWqQLaR67u
         EDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc;
        bh=DqNzRhaPmQhssRmXMNtY7JKunBlTPRaZjnMbn1AT4eM=;
        b=nB8ov6cSQFe9xcGZOo8ijqgNM553CPP1Q3lA540lzWi0XrzVbQAC9CetTUsG8F030w
         tW4JDAc1+pmxaAOdNN9PK9b+gARczg5XmI7D1+tiYqS7OwIguph7/vbpXZKhv9zV6EMj
         4wn7pU765P0jHkpl3NQYM6nooiwLpjiMp17/Sdzi2j6jSEMy6yM6YxoEVrblWCxKygxV
         OSA9qOl7KUc3VVLi2XjCdDuzzqDtdbj1UspB+czy5Hsm7mHPkFNhxYuHuE1j013cURL1
         u0BdwVGz9aQhJ6sNR6MIQoNUpsFL5FYRekZ/1YC44fSbu8SYOW3FoLyMmgdBQ3ij1zvY
         g7BA==
X-Gm-Message-State: ACgBeo1Ys5YHgAC3wKoKQEYy2+ZxS6sAPgpEX/WpGI91mP613zSgg4P+
        AvHggy+Bm+hpqVia4BKAzbOS2vLmOLY=
X-Google-Smtp-Source: AA6agR5ce3fMyi43qt97QrVA4cnrm1zZN86Wy1vJZKyXqThG30yBvFDE3K+M8uLisYPMRBui0gznWg==
X-Received: by 2002:a17:90b:3e86:b0:1f5:2b4f:7460 with SMTP id rj6-20020a17090b3e8600b001f52b4f7460mr13669957pjb.97.1659666862445;
        Thu, 04 Aug 2022 19:34:22 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id g5-20020a17090a4b0500b001f31e91200asm4354937pjh.44.2022.08.04.19.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 19:34:21 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue] build: doc: Update build_man.sh to find bash in PATH
Date:   Fri,  5 Aug 2022 12:34:17 +1000
Message-Id: <20220805023417.14100-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The use of /bin/bash has been reported as a problem during a cross build of
libmnl with a build system running macOS or BSD.

build_man.sh is intended to be usable in a libmnl build, so don't start
with #!/bin/bash.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/build_man.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/doxygen/build_man.sh b/doxygen/build_man.sh
index c68876c..0d3be4c 100755
--- a/doxygen/build_man.sh
+++ b/doxygen/build_man.sh
@@ -1,4 +1,5 @@
-#!/bin/bash -p
+#!/bin/sh
+[ -n "$BASH" ] || exec bash -p $0
 
 # Script to process man pages output by doxygen.
 # We need to use bash for its associative array facility.
-- 
2.35.1

