Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95467C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74F9B205ED
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 18:18:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbfLDSST (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 13:18:19 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53281 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731293AbfLDSSS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 13:18:18 -0500
Received: by mail-wm1-f67.google.com with SMTP id n9so221878wmd.3
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Dec 2019 10:18:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4HDSGGuPesIPLvWhJswJE0fxMFFv2VfyytVgDyM0n6A=;
        b=Nuz003Yj/EWc3Ed11Et4+nAzglUoBNBzsMF4v/7i92RClNOnqoTOe8gADqd6BqerCO
         DyDCLe8wYxaCV+43jN5gpiQ1sNtuMF+GdgP8+2UKWbUa8kRLkdEJERu5kodzRYWCFzDg
         FiF0KF6cBqzUpL9sg+0jMQOzt+hbVAYNK7vFDqG3pUNQmSjYsyhYjmbCAoC2tO5LyuTb
         1RHoDJRKocvuCkT96nN14AjWcSNDlg1WoXgZIZFQHiOsC41qSOv8t2/i9FWDvnurijoq
         uiGr5MZwy5BaweFS5ibx8hgBySsiEjUYuXzsy8WloNn4z6xkSPhVeROm3MccoT0GG0d8
         P3Gg==
X-Gm-Message-State: APjAAAXp8CYzGeWZ25P6p6Vi2WcZvnGP0N7INuCpl+fGumRtztjKhx2Z
        gdMmEL7W4jFqT4ODqLZAWsGYcX3SsEw=
X-Google-Smtp-Source: APXvYqxQdOZGF6GREPZULEDiIYY+OqY40r3oFClmcdPJWTcFCyjGApjUoLzxDxaAhMWMFiqJuhyxPA==
X-Received: by 2002:a1c:7c18:: with SMTP id x24mr1022092wmc.21.1575483496060;
        Wed, 04 Dec 2019 10:18:16 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id n3sm7933700wmc.27.2019.12.04.10.18.15
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 10:18:15 -0800 (PST)
Subject: [iptables PATCH 4/7] libipq: fix spelling in manpage
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Wed, 04 Dec 2019 19:18:14 +0100
Message-ID: <157548349453.125234.3389864626043056658.stgit@endurance>
In-Reply-To: <157548347377.125234.12163057581146113349.stgit@endurance>
References: <157548347377.125234.12163057581146113349.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Laurence J. Lane <ljlane@debian.org>

Fix spelling in this sentence.

Arturo says:
 This patch is forwarded from the iptables Debian package, where it has been
 around for many years now.

Signed-off-by: Laurence J. Lane <ljlane@debian.org>
Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 libipq/ipq_set_verdict.3 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libipq/ipq_set_verdict.3 b/libipq/ipq_set_verdict.3
index 7771ed6a..a6172b30 100644
--- a/libipq/ipq_set_verdict.3
+++ b/libipq/ipq_set_verdict.3
@@ -30,7 +30,7 @@ The
 .B ipq_set_verdict
 function issues a verdict on a packet previously obtained with
 .BR ipq_read ,
-specifing the intended disposition of the packet, and optionally
+specifying the intended disposition of the packet, and optionally
 supplying a modified version of the payload data.
 .PP
 The

