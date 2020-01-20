Return-Path: <SRS0=8tM5=3J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64012C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 13:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3510B21835
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Jan 2020 13:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATNcM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:32:12 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:38154 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNcL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Jan 2020 08:32:11 -0500
Received: by mail-wr1-f42.google.com with SMTP id y17so29602146wrh.5
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jan 2020 05:32:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=qoYU9G5GnUft0Bhwtiyk0CMTN1t+3TmPkDgbVRXg1Ys=;
        b=k/L4E5kctJ4oaYevtakL/XCMG/sJTUQzMQRcaQH0I19OpzbnedJT4rZryaKmgZkfVD
         k/pPqLfO1vMSHQMgP6JRmTOVjeYsU6uoazp7C5QMRZ+T0dOqrIW30h/t+kyg5NB94Hhs
         6yC82coW+ESz97SMYCz6UMT0kRBoLwACJIJ/+HVCtVG6e4adjVO4sgG9MAPHoLX3TaM2
         yrDoK8E4wndr7myhs9FbaxQobs+5AMLrOPWTzxA4XB1OjZVddiCp/ARPdllOAN6G3O7+
         uoS9g+0cPyRICNQBW7LaOjFjDPefSoqegze2fCBMMyib5qZlqIBiiYB+cV0vKx1HbwlE
         IG4g==
X-Gm-Message-State: APjAAAXQE2S9yBud5NAFYfQj9SiXSA54jda2bLDZblYMOr06a+ja5Yh7
        PwesYOOhnv7Et2dHoShilTrXl1Lz
X-Google-Smtp-Source: APXvYqw1AcxSna4znY/T1dhMhfHXIpZa3PTd7ZLp2dDEy9J9QYe+nuz/LkvZKUZexZZscMSs/eu2qA==
X-Received: by 2002:adf:f052:: with SMTP id t18mr17507190wro.192.1579527129813;
        Mon, 20 Jan 2020 05:32:09 -0800 (PST)
Received: from localhost (static.68.138.194.213.ibercom.com. [213.194.138.68])
        by smtp.gmail.com with ESMTPSA id a5sm22958979wmb.37.2020.01.20.05.32.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 05:32:09 -0800 (PST)
Subject: [iptables PATCH] .gitignore: add nano/vim swap file
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Date:   Mon, 20 Jan 2020 14:32:08 +0100
Message-ID: <157952712805.68254.8601217027637177739.stgit@endurance>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Ignore swap/lock files for nano/vim. Not interested in git being aware of them.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 .gitignore |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index 92eb178a..e5595264 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,3 +22,6 @@ Makefile.in
 
 /iptables/xtables-multi
 /iptables/xtables-compat-multi
+
+# vim/nano swap file
+*.swp

