Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2104EC4320E
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 19:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0554061056
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 19:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhHITnY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235230AbhHITnX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 15:43:23 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4AD1C0613D3
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 12:43:02 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id t128so25218935oig.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 12:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x0ahJTKQXt56Pfan3cthP57Ez9jxZBk/5R/8y3923WM=;
        b=dLrKpYqsCYvNmQLE8X2dDMXFZKZ/b79ktwDFSIpsxp4WfnRTMJ+UhRInJM6Po61dBY
         BL0vi6YdaCCszfV7WWO5FRQGT7RKDMEnCCHXR/e87rNhq7FlaVq4J9Qj9DgiglWLR/xT
         3iiNovy45b0tLvbuX8ypGvSu/6iV0EbsdrRJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x0ahJTKQXt56Pfan3cthP57Ez9jxZBk/5R/8y3923WM=;
        b=peZyAJ93zNmIaIIhPzM8PHr7eAmgrU6ZtsjU0aypJlCC38xY31Biaxbq01RzZuHA1o
         o43aoahV3W3HL7pPuCD27smEHxaCCj9aHzlOGEG20Ryxf/9f+/F3F6PzsDXoU5LYDE3g
         g29cQzzLhSP5bqIHZVhZhBK2i2cUcnJtIPisFLvqs4qhgs5QQ2J6fF2yB4m5g15wH4gk
         X6q9f4zQoaUJg7R7qetF/erZggoFfXKNdhw1LYEannt9QestXbaSAK9HyE6IB7t5FKcf
         lVa99PjdAVfTmEOSppA09G36gTgomOAroiFfi1TiCxzjiUaL3JWLvlITRU2YceJSOcid
         39cA==
X-Gm-Message-State: AOAM533trV1Goh1261LoafKj4XbEDU5xS9UDXBeYNObZcYsq2VyvCF62
        Rg4uq6FC3Jumm0G+cpmenRX+AVpWmVFyfQ==
X-Google-Smtp-Source: ABdhPJwDjLYqb8hwGjBxEVyWvQuFoy300f769AO52FgLlYtpvk+TKZ4Fz1ppTzMbbEPaWLcnr3fSQA==
X-Received: by 2002:aca:1b08:: with SMTP id b8mr6208933oib.44.1628538181851;
        Mon, 09 Aug 2021 12:43:01 -0700 (PDT)
Received: from localhost.localdomain (65-36-81-87.static.grandenetworks.net. [65.36.81.87])
        by smtp.gmail.com with ESMTPSA id x60sm2647735ota.72.2021.08.09.12.43.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Aug 2021 12:43:01 -0700 (PDT)
From:   Kyle Bowman <kbowman@cloudflare.com>
To:     netfilter-devel@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Jeremy Sowden <jeremy@azazel.net>
Subject: [PATCH 3/3] extensions: libxf_NFLOG: remove `--nflog-range` Python unit-tests.
Date:   Mon,  9 Aug 2021 14:42:43 -0500
Message-Id: <20210809194243.53370-3-kbowman@cloudflare.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809194243.53370-1-kbowman@cloudflare.com>
References: <20210809194243.53370-1-kbowman@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nft has no equivalent to `--nflog-range`, so we cannot emulate it and
the Python unit-tests for it fail.  However, since `--nflog-range` is
broken and doesn't do anything, the tests are not testing anything
useful.

Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
Signed-off-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/libxt_NFLOG.t | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/extensions/libxt_NFLOG.t b/extensions/libxt_NFLOG.t
index 933fa221..33a15c06 100644
--- a/extensions/libxt_NFLOG.t
+++ b/extensions/libxt_NFLOG.t
@@ -3,10 +3,6 @@
 -j NFLOG --nflog-group 65535;=;OK
 -j NFLOG --nflog-group 65536;;FAIL
 -j NFLOG --nflog-group 0;-j NFLOG;OK
--j NFLOG --nflog-range 1;=;OK
--j NFLOG --nflog-range 4294967295;=;OK
--j NFLOG --nflog-range 4294967296;;FAIL
--j NFLOG --nflog-range -1;;FAIL
 -j NFLOG --nflog-size 0;=;OK
 -j NFLOG --nflog-size 1;=;OK
 -j NFLOG --nflog-size 4294967295;=;OK
-- 
2.20.1

