Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55078C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B4386138B
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhJTMqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:46:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhJTMqu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yoVEqs0X+chOaruAr+WaBrmtXAzBeR0cIkgLtd+1h2U=;
        b=TUJI4NBhoVYIeWG5J29FYxRRcwfkE2THjlKwLsvnP0D8vTio4p2m7st7g3DPLd6E/MhNaj
        jzv4F5h+UFsO9Dx3iubeSvFh6N+WvR9DPe2/V7dytiO/PGx8U1bEikk5ycZ4ND7GPbz2+L
        B3T42ClG5lMWTPiHWkZUAqhFuRrsN3c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-kSkmJObiO7SW0qEirhwbpA-1; Wed, 20 Oct 2021 08:44:34 -0400
X-MC-Unique: kSkmJObiO7SW0qEirhwbpA-1
Received: by mail-wm1-f69.google.com with SMTP id f20-20020a05600c155400b0030db7b29174so3124733wmg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yoVEqs0X+chOaruAr+WaBrmtXAzBeR0cIkgLtd+1h2U=;
        b=FbvSxhCyEzQxx3jOOMcKVSEJ0H91iZslhypBB79qdqjcqJPJaeRxrri7ss4e5/vX6y
         FVo84d19KfCweYJHW3eZtpHj1Icre/MVcvdjfV9FBvGB2HoG9VLQsPZ1G6fqgc70ueb0
         U0NzdqpyggigGuz2/hFzkmTOhvkll8EI0GMBTCJ6mtJ+m3H0r4Wmo8wNoy9iPcI4tjzK
         BxTFFyAUt6xoS5UsAZjarDbUgjq7fx0NS7g4z0oxBazo5Q6Ps5iauvG4V3fB3egEgwbL
         YQxIqbqpABeCMsB3IkTbmWXqqvBCpKy46TjbIVhQjpRrvab1deJ13T4a5C8TODXjUIyD
         U4GA==
X-Gm-Message-State: AOAM530oMizrtspdr1L2Yj91d7GLnmC4sHAkbXfvykvIJcPY+1FhqKgX
        8c8D1LyHEwtC3hBGtApXKOoOIoOSrcUBNwf6Bei+5CWdN2Bi/skiaeFEUsnIG7oeCykWsE7/aTa
        qRW4uXVwf20hAIJbQ4bMg24bSCYls7p6yIqUl3mTP6ZpYoK+sNw63K6JJilSyS5eKWp6PhqVAsy
        gNHw==
X-Received: by 2002:a5d:6da9:: with SMTP id u9mr53430861wrs.84.1634733872829;
        Wed, 20 Oct 2021 05:44:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzC8w5Xtqp4tnTJn6TZ3nlmxK3CxGMDsatWEuJGk9Xbc3siXQQKW0pUOaL8TL8k6EmueA7pBQ==
X-Received: by 2002:a5d:6da9:: with SMTP id u9mr53430838wrs.84.1634733872615;
        Wed, 20 Oct 2021 05:44:32 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id n12sm2211274wms.27.2021.10.20.05.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:44:32 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 3/3] tests: shell: README: clarify test file name convention
Date:   Wed, 20 Oct 2021 14:45:12 +0200
Message-Id: <20211020124512.490288-3-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211020124512.490288-1-snemec@redhat.com>
References: <20211020124512.490288-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes: 4d26b6dd3c4c ("tests: shell: change all test scripts to return 0")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/shell/README | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/shell/README b/tests/shell/README
index 4dd595d99556..07d5cc2e3e7c 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -10,8 +10,12 @@ To run the test suite (as root):
  # ./run-tests.sh
 
 Test files are executable files matching the pattern <<name_N>>,
-where N is the expected return code of the executable. Since they
-are located with `find', test files can be put in any subdirectory.
+where N used to be the expected return code of the executable.
+(After commit 4d26b6dd3c4c, all tests should return 0 on success,
+no matter the test file name.)
+
+Since they are located with `find', test files can be put in any
+subdirectory.
 
 You can turn on a verbose execution by calling:
  # ./run-tests.sh -v
-- 
2.33.1

