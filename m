Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E59C32771
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 01:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B98BF20723
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 01:41:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=campus-fct-unl-pt.20150623.gappssmtp.com header.i=@campus-fct-unl-pt.20150623.gappssmtp.com header.b="FrV2uUdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgAPBlE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 20:41:04 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55932 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729615AbgAPBlD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 20:41:03 -0500
Received: by mail-wm1-f67.google.com with SMTP id q9so2035947wmj.5
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 17:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=campus-fct-unl-pt.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cxhNaw9OI1Bjzxn9H+oX0YGLRWBp01fxMWK+FbrFUwA=;
        b=FrV2uUdnjjR655s08WnBoN9uHFZ4F9JY4y7X373qm/2a59whiIiqHGeBde26/UeuRN
         5Kn42nt8fPmPA3juRz3lTn7E6cINK52EOhHcXE6rJ637fThiYw7OY53BKnANSyV23xzm
         kdzNbZCO27BtJNfVHwZYGPHWluMdH6rrGdJ2Xn3djDnGOcVui69R37VhZmGBwzytpEq6
         Cz7bFLLG6CeB6fZQvc6bP6jtnMN5EJ3PRqVaXZUBFs3YuLQyjhQ2fmTs0QbxBY/GzH36
         9KcKvtRP2ix9IK6gH4SOQOB+7nPy5fIb6eaomR7jBUHbdeSpDoVle8qKJ4MAlJKYZF+C
         K96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cxhNaw9OI1Bjzxn9H+oX0YGLRWBp01fxMWK+FbrFUwA=;
        b=FiD4KcPPn1HUsgXrAIEA7kE2Zbk+dpPoUy4Mdj5/U0YfHAQU6VXIJR3Sd1MXZrQuUw
         ue3qY2viF1x1FATF12PchPLZ6IohLOHn61sVcjuYOM+WiSB1nmW6KTmsAHhTylxNIDQ2
         acwOuDXzYHbAHDMSROoXSipyYVWz4wCazmt4tE136+l+qrot1T6RLsBksS5PAjn4V9fK
         iymj0Fe6WwA20L2LuCw0luflsbDI9E5W6ftWbQdcFKEL2wzU/932+CUCEbIeUTZF8I7w
         PqiWr7hxQUbXYgkQi2mpd647heZWeL5WxIB9qyKLDmdX2PxUO+Oa1X6rywOc1mijyXOC
         cdkQ==
X-Gm-Message-State: APjAAAXA0whn0V2UqhzXgvdmriyApmjItmN4bcQ5ojFIp7uQsfHRahwZ
        GCOEjMwypEoSEse7W05Oe7P9FTiHYKw=
X-Google-Smtp-Source: APXvYqzUjTJucKnz0zNNywrSoDeXBjvoSI1R97ncOVNusNPrNBUaS3+lc4/gmDPOx6lGlod8ldIsDA==
X-Received: by 2002:a1c:5a0a:: with SMTP id o10mr3115821wmb.114.1579138861269;
        Wed, 15 Jan 2020 17:41:01 -0800 (PST)
Received: from penguin-box.pdoc.di.fct.unl.pt ([217.129.34.12])
        by smtp.gmail.com with ESMTPSA id y22sm2196212wma.35.2020.01.15.17.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 17:41:00 -0800 (PST)
From:   aa.santos@campus.fct.unl.pt
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Santos?= <aa.santos@campus.fct.unl.pt>
Subject: [PATCH] Fixed some man pages typos ('This modules' -> 'This module')
Date:   Thu, 16 Jan 2020 01:40:57 +0000
Message-Id: <20200116014057.25897-1-aa.santos@campus.fct.unl.pt>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Álvaro Santos <aa.santos@campus.fct.unl.pt>

---
 extensions/libxt_osf.man    | 2 +-
 extensions/libxt_policy.man | 2 +-
 extensions/libxt_string.man | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_osf.man b/extensions/libxt_osf.man
index ecb6ee5f..41103f29 100644
--- a/extensions/libxt_osf.man
+++ b/extensions/libxt_osf.man
@@ -1,4 +1,4 @@
-The osf module does passive operating system fingerprinting. This modules
+The osf module does passive operating system fingerprinting. This module
 compares some data (Window Size, MSS, options and their order, TTL, DF,
 and others) from packets with the SYN bit set. 
 .TP
diff --git a/extensions/libxt_policy.man b/extensions/libxt_policy.man
index 1b834fa0..12c01b43 100644
--- a/extensions/libxt_policy.man
+++ b/extensions/libxt_policy.man
@@ -1,4 +1,4 @@
-This modules matches the policy used by IPsec for handling a packet.
+This module matches the policy used by IPsec for handling a packet.
 .TP
 \fB\-\-dir\fP {\fBin\fP|\fBout\fP}
 Used to select whether to match the policy used for decapsulation or the
diff --git a/extensions/libxt_string.man b/extensions/libxt_string.man
index 54c03a3a..5f1a993c 100644
--- a/extensions/libxt_string.man
+++ b/extensions/libxt_string.man
@@ -1,4 +1,4 @@
-This modules matches a given string by using some pattern matching strategy. It requires a linux kernel >= 2.6.14.
+This module matches a given string by using some pattern matching strategy. It requires a linux kernel >= 2.6.14.
 .TP
 \fB\-\-algo\fP {\fBbm\fP|\fBkmp\fP}
 Select the pattern matching strategy. (bm = Boyer-Moore, kmp = Knuth-Pratt-Morris)
-- 
2.17.1

