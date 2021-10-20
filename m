Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE43CC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952A76135E
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhJTMqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:46:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhJTMqt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pa2LKXSooiIQ+HcGUIqS+XYS3QcGVUwLfppkL3xPIy4=;
        b=EtL7aPqGps0Y8Us6lfGDEoQtBJp1nHZvGdForgWE3w2OAWV9MaS4F2e356hzIDTmpIGmET
        Kr9SXBLh4LJHWQdlsNYIkKNaNmTvPArriB7qhCvxtnmUbJ5ArFBUPtGA9TZPBzBYFS2+nM
        eX9CFfOyUYgqpel1UZN4jR3YPKIaeCI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-ZzBiouX0NUSwC3RnHmojOw-1; Wed, 20 Oct 2021 08:44:33 -0400
X-MC-Unique: ZzBiouX0NUSwC3RnHmojOw-1
Received: by mail-wm1-f69.google.com with SMTP id u14-20020a05600c19ce00b0030d8549d49aso2149503wmq.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pa2LKXSooiIQ+HcGUIqS+XYS3QcGVUwLfppkL3xPIy4=;
        b=ne/0HfBDKUARmvE6yMAznAcHvscNQ4cQzk4wWqqWLLrNV3ggECnNWlXbfC2mV976f6
         zuv/2dI5LhxKbrvyYo/ryl95aTBrvUkufxLAUaufsQQ+zqm4KHUZhEu6JzORdqPaXsMh
         KMgMq4UbTPKtKiRMC3e5XQkTVpq+jA+cT7rz2RPD95cclKXbl28L1Rdsv5gJBqHHhvQU
         byxuNN4W0Jr+I8gNnxCcQfTdHBWeDiGi9jQto1H0X/r90QmJY7PYy/wI0zaxgJkPBuES
         35P6SNSkhnSOW8C+X1VQXvGg8+nN3g4qFHOw/mIO898CjX2cBl9I7G6hZzoQiCca+SnG
         m/Xw==
X-Gm-Message-State: AOAM532soVX3lv930d6N1L9d9+czD25wo1AG2hwls2iCGUw0B+NCqAXG
        XRFtk0XHI8kJQ5UTGGUAbeCGQeYyxn23OXccSztwptxBqTSowX3aLbRl7gOQXQZ8xe1UvMgToHs
        odnrZWJAHhkkYi/GCwEwzUIXm6qXEGCzVC3a3JZ6fi9yY+QB/wcwpqM+tIuGcJmB/T/B58ZHUga
        OKnw==
X-Received: by 2002:a1c:a1c2:: with SMTP id k185mr13688990wme.144.1634733871875;
        Wed, 20 Oct 2021 05:44:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEe8tSe3tGhA6u4BiytzrXX9NVjzVEN0CNIcayEoATHudezsvI7AYR+SLRkfQ9JNuEOrX0gg==
X-Received: by 2002:a1c:a1c2:: with SMTP id k185mr13688974wme.144.1634733871635;
        Wed, 20 Oct 2021 05:44:31 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id e9sm1933448wrn.2.2021.10.20.05.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:44:31 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/3] tests: shell: README: $NFT does not have to be a path to a binary
Date:   Wed, 20 Oct 2021 14:45:11 +0200
Message-Id: <20211020124512.490288-2-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020124512.490288-1-snemec@redhat.com>
References: <20211020124512.490288-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 7c8a44b25c22 ("tests: shell: Allow wrappers to be passed as nft command")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/shell/README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/shell/README b/tests/shell/README
index 35f6e3785f0e..4dd595d99556 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -21,7 +21,7 @@ And generate missing dump files with:
 
 Before each test file invocation, `nft flush ruleset' will be called.
 Also, test file process environment will include the variable $NFT
-which contains the path to the nft binary being tested.
+which contains the nft command being tested.
 
 You can pass an arbitrary $NFT value as well:
  # NFT=/usr/local/sbin/nft ./run-tests.sh
-- 
2.33.1

