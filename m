Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333A8C432BE
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 08:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1012E61051
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Sep 2021 08:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244608AbhIBJAu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 05:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbhIBJAt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 05:00:49 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CC2C061575
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Sep 2021 01:59:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d5so910278pjx.2
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Sep 2021 01:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=56LumSd/LtVT1dfooNRXlAa2IhmhLirzjFW031hhRAk=;
        b=IYIwbIXO0nBpbNgdSMrti81QVE2n179f+ZWQ80i2iCIOem9pLN/JTTg9t7iGznTe6C
         qv79zY0svkzO2AsImiItazppXuhTtVeUQVeFtJy8QTc7CPjbP8ws9TSmNgAOQvEM6cJ/
         WDyyc3N1SbjQLXvUAh5I+LTk9zuxXhPa0sNLPG5UjCbSvA9NLhuJGKKzZfH9He5A43HB
         6uu+gHuy2UzltPcUDqwntHsgAh2fK9JtFBNbj9TUSPuRC25Il4d4DrWSmhws/1smq/eI
         zt5+ClvSsfESsp7lJ0LhOQESt0OhiMjI+hc64Q3fqlWIMh+Y1JxsBt4sRECiKknTjHAE
         ZWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=56LumSd/LtVT1dfooNRXlAa2IhmhLirzjFW031hhRAk=;
        b=Wc9JJ2iiu2DjY+3X3xUDbphqmdSRJxRs4VjB1EvSSVUflbaRJSoB61/VDAEdXqTp5q
         bDhl8d4cB9SibB5RoeH1GsKCkxWr/K5XARP9cpj51WROJpYFomep2qE47jCIx62f4Zhn
         m3pG9IlWtrsle3Zp6Ym7oQTnZffUYKbBw/R77TDJD+FxwVXGoggqRM7cz+D/x5gpyEtD
         DBU4N9MA7nRAjGidCxTUhgXDjgCGdqO1Mrh7Xbj5kgdodnB98YJOsLIlCKz6tg33CTH/
         ZS8L+BwVTAB7fcOtbcJJnTx1wSdklbSrNNypZN3AMkyrFQNYk9wGAgrHKxa43kf4X4pH
         wDYA==
X-Gm-Message-State: AOAM532AOfJok9CUy104iWxzgQtzgarn9YUfkWq73orYvAGcZ6zopILA
        lAhCjSySCexXNi9Uh5p5QeXGPqAzIXg=
X-Google-Smtp-Source: ABdhPJxEKLLS3UeIGmflIfeXCbkfTt+hWVbVYhH5jVwe426LdP7RnReMbNcLCotKI+3wB6SsdFkQgg==
X-Received: by 2002:a17:90b:120a:: with SMTP id gl10mr2660402pjb.234.1630573191409;
        Thu, 02 Sep 2021 01:59:51 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id s14sm1884719pgf.4.2021.09.02.01.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 01:59:50 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 0/1] build: doc: `make` generates requested documentation
Date:   Thu,  2 Sep 2021 18:59:44 +1000
Message-Id: <20210902085945.22099-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch mirrors all the documentation-related build changes in
libnetfilter_queue, including
https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210828033508.15618-5-duncan_roe@optusnet.com.au/
which is not yet applied at time of writing.
Because all the changes are applied at once, the diffs are cleaner, f.i.
configure.ac has one changed line and 3 blocks of insertions.

Duncan Roe (1):
  build: doc: `make` generates requested documentation

 .gitignore                               |  2 +-
 Makefile.am                              |  2 +-
 autogen.sh                               |  8 ++++
 configure.ac                             | 58 +++++++++++++++++++++++-
 doxygen/Makefile.am                      | 39 ++++++++++++++++
 doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++--
 6 files changed, 111 insertions(+), 7 deletions(-)
 create mode 100644 doxygen/Makefile.am
 rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)

-- 
2.17.5

