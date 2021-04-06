Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA618C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4435613C4
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhDFKKI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhDFKKH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 06:10:07 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FCEC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 03:10:00 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u9so15810795ljd.11
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2021 03:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0zXdU4hDwFRmzg9XkwGIAchyTMLZmTp0ICkYnT/dqbw=;
        b=RPPdU+2fOdfhNFc9RAYDQl4i2JRvoaYPiwwt4bbwHx8zZ9eUfStgzV0RHAXQJgdPaF
         aeN3IJxfQ9lRZ8r6N3l+TzC3OxW2fNtSZ9wo+IB4C3K9jtbhD5mfGzrHpwK5jOLAGfsd
         L6/m7JoS90Z3x4hOb5xYJsK9KgDKYS0XI8R9tlaClhU5Qi9GQLybpHiCjlyqQRrBLtpD
         4XaGNiLvrYvEl1VdlWEHrBkJZsik2/Y9mwlzMYzwPGhEncZL7nWarC7qgDS/6pZsScFe
         lZgUUO5wD5o5YdAGVQF/vTegcCSv46YrOBPhcLUgEfprFiB5A6SvFuSR8JOOIE9XKd+p
         MrzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0zXdU4hDwFRmzg9XkwGIAchyTMLZmTp0ICkYnT/dqbw=;
        b=GNPRWwWWS4phDz8GeYrMZFygMb7w0R5SpX9NRbByCISQNxvHABTBqXIJx/Kwm8/Yft
         zforzixUh/9J3gUHH4HXoZAXvkcrJdIrDCyT45bJCurHI+eU3rfKARoqrKJLVQ18ukjC
         T1m+2opLoS3LgfhMZcDkV8H/yx3v9Pxv72Z8byTFtkjZGW9MpKMBVs7V8Ib/b0nV/oZL
         oolFCyygaoN1N3mlq2noKcq4VBkGITNxiXLJFj6JLxLdNgWujhJSfDHOhiW4+blbV/d1
         21E3j3ef2sGCXkO2hfOypOvqo/nZHIcvQCJ/8wiW3A/9uRD4WeHwdgqjeYXeK1BcNJMX
         27cw==
X-Gm-Message-State: AOAM532euZUt6m8B56vixjmR9lQPut+WrtnrMxvwGJs92wyw1ky5xHFO
        0UzRgGWHQ+wF6TDUhaO2HdqFYuRy+p8DxqHE
X-Google-Smtp-Source: ABdhPJylqnyHyo20Z6SIJkK3m1ywAiSsvjkzt4ys0fXRNaanwpfv2VT8jqZKknh3C094sIAlCLv5Gg==
X-Received: by 2002:a2e:810a:: with SMTP id d10mr18209906ljg.304.1617703798540;
        Tue, 06 Apr 2021 03:09:58 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a00:1fa1:c4fc:25fe:f165:934d:dfbd:8cd3])
        by smtp.gmail.com with ESMTPSA id l7sm2170070lje.30.2021.04.06.03.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:09:58 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovskii@ionos.com
Subject: [PATCH v4 0/5] conntrack: save output format
Date:   Tue,  6 Apr 2021 12:09:42 +0200
Message-Id: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo & all,

Here is the updated version of the "save output format"
patches adjusted in accordance with our latest discussion with Pablo.

Thanks & regards,
Mikhail


Mikhail Sennikovsky (5):
  conntrack: introduce ct_cmd_list
  conntrack: accept commands from file
  conntrack.8: man update for --load-file support
  tests: saving and loading ct entries, save format
  tests: conntrack -L/-D ip family filtering

 conntrack.8                         |   8 +
 src/conntrack.c                     | 250 +++++++++++++++++++++++++++-
 tests/conntrack/test-conntrack.c    |  84 ++++++++--
 tests/conntrack/testsuite/08stdin   |  80 +++++++++
 tests/conntrack/testsuite/09dumpopt | 147 ++++++++++++++++
 5 files changed, 552 insertions(+), 17 deletions(-)
 create mode 100644 tests/conntrack/testsuite/08stdin
 create mode 100644 tests/conntrack/testsuite/09dumpopt

-- 
2.25.1

