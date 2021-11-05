Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D546CC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAF4661245
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhKELlI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 07:41:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232536AbhKELlH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 07:41:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636112307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=79pZNcJSS4IwQ7nWnnL4mRXLF1MGX+/MqEvgxLHXlkI=;
        b=NFMzbA2UZ8FaMSs26kQ9vnUB+a13rYlTi8z666Vbw2s8DSrLPC4tQ48jOqI+tZ1xA5vErt
        9fo029IImU0apvkcmACATwhsJtO3Nzk7wFW6B25GIPZNNsIx5RwW0umQiakrXfTaPui2S7
        zc30aHcqmM2gqq1ehHJgadOZeKr4XoQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-QXlPRbH_OG-jBbfne7FYug-1; Fri, 05 Nov 2021 07:38:26 -0400
X-MC-Unique: QXlPRbH_OG-jBbfne7FYug-1
Received: by mail-wm1-f71.google.com with SMTP id r6-20020a1c4406000000b0033119c22fdbso3188606wma.4
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Nov 2021 04:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=79pZNcJSS4IwQ7nWnnL4mRXLF1MGX+/MqEvgxLHXlkI=;
        b=Id2KNSJTnhqXAre5fveTg2+LOQ268Xf3i+jI3WYvINxEi/b9LoH84Z4JAMD8tBU6Yq
         erFABP+KxUb1T4SfRZLaOc8e6Wk53isTn99GPy2Ok2UwMvMv+2CFeFO54KaIJOMVn9+C
         sdlyaPKFvozHZRJchfthGuGHcUDCbdJa9hZny+j3vdeaH7/jnpAK14zckCfmy8X5IC8n
         imjNv2r/IcOcaQ3yJAT+aA6N4IFLyW/29NVdafd8LDvx7qDic703rRmrYOwNfUVaF4RH
         BFvF9Tb/xku0QDHMSnQKrIJwJKg0JHpFiDhL0Tae84g0K42eIhXfkNqGZwuHJqihxUVT
         fbZA==
X-Gm-Message-State: AOAM531+rkNJayOMFeGl8n4shQR23ZeXJH1BtWG9TIKpWf6bDYbGMUjh
        KNGDxi33YclrR+6EEBZtewSqp1hK1EsiWdyuy2AydXE0NH5+C6jTq6sQR6vMri7X9ZtUB6NkJlM
        lDcJrZiLdD/ZzgpPebUW+cFmWj0b7JKn06b+jgJIn5tzmTq56mQ1IZBPiqjmakecpwkSHPnv6s+
        zNKg==
X-Received: by 2002:a05:6000:1010:: with SMTP id a16mr61021002wrx.155.1636112305513;
        Fri, 05 Nov 2021 04:38:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPqp21Pvbl3nPQtK6A+z19LO8Yz9LPuQbMrI4BN2OKsIF02nNttTGGT3ExHFYqO1OWOoJ3oQ==
X-Received: by 2002:a05:6000:1010:: with SMTP id a16mr61020965wrx.155.1636112305294;
        Fri, 05 Nov 2021 04:38:25 -0700 (PDT)
Received: from localhost ([185.112.167.34])
        by smtp.gmail.com with ESMTPSA id p13sm11996423wmi.0.2021.11.05.04.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 04:38:24 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     phil@nwl.cc
Subject: [PATCH nft v2 3/4] tests: shell: README: clarify test file name convention
Date:   Fri,  5 Nov 2021 12:39:10 +0100
Message-Id: <20211105113911.153006-3-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211105113911.153006-1-snemec@redhat.com>
References: <YXmjii3KR7nyrK8u@salvia>
 <20211105113911.153006-1-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since commit 4d26b6dd3c4c, test file name suffix no longer reflects
expected exit code in all cases.

Move the sentence "Since they are located with `find', test files can
be put in any subdirectory." to a separate paragraph.

Fixes: 4d26b6dd3c4c ("tests: shell: change all test scripts to return 0")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/shell/README | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/shell/README b/tests/shell/README
index 4dd595d99556..ea2b0b98f95f 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -10,8 +10,11 @@ To run the test suite (as root):
  # ./run-tests.sh
 
 Test files are executable files matching the pattern <<name_N>>,
-where N is the expected return code of the executable. Since they
-are located with `find', test files can be put in any subdirectory.
+where N should be 0 in all new tests. All tests should return 0 on
+success.
+
+Since they are located with `find', test files can be put in any
+subdirectory.
 
 You can turn on a verbose execution by calling:
  # ./run-tests.sh -v
-- 
2.33.1

