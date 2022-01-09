Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F89DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 03:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiAIDRI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Jan 2022 22:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiAIDRH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Jan 2022 22:17:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA4FC06173F
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Jan 2022 19:17:07 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id lr15-20020a17090b4b8f00b001b19671cbebso12300202pjb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Jan 2022 19:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+x1ok5LNAPjSurMpqX/pHENEhikzHKEenakrc/d5Skg=;
        b=RjGh50csJkt7JA/jbcinf1qo2+dBSgZGilQNUr306EiccHWNqH7bjdQLJ1IXsXJ7eO
         lZohGGKmTe8oRC0DyAzr2fxIeghzReo0ZGHlHWiUBj4F7xS832iF1q1D6w6MM4Lg+wym
         TzskZrDGoiESCY3IVsqKQSDni4N1sWa476GO6KrY1LzXFyK9rMbMwZIBf6RXrex39+K4
         j3Gxazpib9ZyRmoXz2JlMyHPnodvGP3mCMeNfxA1KurVX1LZLbZehp5U0WNiaUlPPw88
         hxX0qqrZUl246B7mMTVZwndgG7VivAtPG39N+z4lgehNnW4LolEQw9wYvj654gp2QUVu
         0OHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+x1ok5LNAPjSurMpqX/pHENEhikzHKEenakrc/d5Skg=;
        b=F7Nq+/viinp6t6LDtIyTw5bodGli1UCM834tZ831OgVXhgv5wddaHPU/jVVZyNdJ2j
         Yjr4xlTdNH0SgpO+a8XB9P7Rp+S4oUCst7gMoR16YHRb20HgYS9MI+aSg8fTrOQJ4AWr
         zhbJEG7kdCndy6hJg7mOY9a3WfqMK8Osae7DTDtuOTyK1UNDim3Qe7vSU5lEg/UhYgsl
         cxBVyiCra19gPVaRhRy77T1Q0vzE9f5BM12s+D0nqoCHA1IDvP/pGsJN0WmepfRxAOh3
         GnWjQL7+fHHbqJXt3eD5GlhZHt+dSiU9BBPTkQqajveYAPB3bqZwfUcPpjQMxAAf9xCT
         8uLQ==
X-Gm-Message-State: AOAM533JkA4/zU7e+fBBnvxCAfZoiUulrfJ1/BfhlZyuLzFnuQekYFPK
        la+4bOLdjhpFUumbirX4XHjmwbuCu4c=
X-Google-Smtp-Source: ABdhPJxFkL2Sns5pHMnX5hvD4SXnpxeYizhAe6v03aFMOkNmP7TOjzlGiArKtw/hqsxHiTq4EYz6SA==
X-Received: by 2002:a17:902:ecc6:b0:148:a65d:842d with SMTP id a6-20020a170902ecc600b00148a65d842dmr69002700plh.56.1641698226674;
        Sat, 08 Jan 2022 19:17:06 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id me18sm3881864pjb.3.2022.01.08.19.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 19:17:06 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue v3 4/5] build: doc: Eliminate doxygen warnings
Date:   Sun,  9 Jan 2022 14:16:52 +1100
Message-Id: <20220109031653.23835-5-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
References: <20220109031653.23835-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add [struct] data_carrier to EXCLUDE_SYMBOLS.
Temporarily add pktb_populate() as well:
  to be documented once function prototypes are agreed.

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
v3: New patch
 doxygen/doxygen.cfg.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/doxygen/doxygen.cfg.in b/doxygen/doxygen.cfg.in
index 14bd0cf..b0791d6 100644
--- a/doxygen/doxygen.cfg.in
+++ b/doxygen/doxygen.cfg.in
@@ -13,6 +13,8 @@ EXCLUDE_SYMBOLS        = EXPORT_SYMBOL \
                          nfq_handle \
                          nfq_data \
                          nfq_q_handle \
+                         data_carrier \
+                         pktb_populate \
                          tcp_flag_word
 EXAMPLE_PATTERNS       =
 INPUT_FILTER           = "sed 's/EXPORT_SYMBOL//g'"
-- 
2.17.5

