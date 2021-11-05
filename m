Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E50C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09EAE61215
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Nov 2021 11:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbhKELlJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Nov 2021 07:41:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232628AbhKELlJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Nov 2021 07:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636112309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qD7Nkfw/UXP8v24x0lVs8jNIFAdBuTVhHQ0oRZZPd4s=;
        b=Pvet5MzRcHwo59vzIOrerKtmWMGIcK0O71bRQzChMdzHHu2fJ+TEyY+/s8Ht/9gzJFqH6F
        cs/y+JGWELGOba040YbsKowfoDCi8zyOCOcB2LOsvsTVQxmQflJJrxyyaBXqYmjBeU3icM
        vaPxhPECqJEJfotjCv6JE0vXRTPyeUM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-4bY-xk68N_qoDKXu_tULCQ-1; Fri, 05 Nov 2021 07:38:27 -0400
X-MC-Unique: 4bY-xk68N_qoDKXu_tULCQ-1
Received: by mail-wr1-f69.google.com with SMTP id p17-20020adff211000000b0017b902a7701so2224327wro.19
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Nov 2021 04:38:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qD7Nkfw/UXP8v24x0lVs8jNIFAdBuTVhHQ0oRZZPd4s=;
        b=xu0kCyt9ggWo9S1y3870uOsnd7k4begiMZ6qPC/NVHbzEBmrtVg67N8v9/UrZFh3Ez
         y9enfQiJZ1ksLOSg5aZ+Cx51eY6cmHxdrETSDt/M2BOqM25CGT9dnTj5Zk3U2I7MpUa6
         GvF5nt4RMRLUNpt50K/e6ZSgbFJJOptIoaHlANa13Aov+Kxz/Gb9iVNy0+JJBuRQOMqW
         j9HAd2W3rWnyVnnD8itngZ99phZtS+JDYBMBwQXnhHf9CUzsxf57S85agHZKHJNgLyDB
         f9NXpQic5CqJm9/jMWqLQf3eJ6xVVPfEjA8gheAJOVxpX3AlnmzoLX6gjUO8CxSWtcn3
         +bIQ==
X-Gm-Message-State: AOAM5309NINmeG+pHINTMx6Aw1EmoAjvADuidTHFii1fy+qvAKGkXsSm
        QeHixfdxRBFuKWFwRoXOMRkcPM6grdHgKgmRq1CmkCT5plkh/0Ac99f25K2oa62741kNzb61gG2
        uBMXCQHlX0As1ZOWY9fBft9a8NrNo2xLGFS3fe41h84MVltqLXxIWph0oTa60ANl1N/bvr5M9ZX
        5xhA==
X-Received: by 2002:a5d:6dab:: with SMTP id u11mr8279639wrs.46.1636112306582;
        Fri, 05 Nov 2021 04:38:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrISQ67Ww7Dv0E30rkYmuQfm389Zffta7PIYPS59dHxmEPAVSvHmDvbH/DsBXq9IHqhINmOw==
X-Received: by 2002:a5d:6dab:: with SMTP id u11mr8279617wrs.46.1636112306399;
        Fri, 05 Nov 2021 04:38:26 -0700 (PDT)
Received: from localhost ([185.112.167.34])
        by smtp.gmail.com with ESMTPSA id c6sm8322694wmq.46.2021.11.05.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 04:38:26 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     phil@nwl.cc
Subject: [PATCH nft v2 4/4] tests: shell: $NFT needs to be invoked unquoted
Date:   Fri,  5 Nov 2021 12:39:11 +0100
Message-Id: <20211105113911.153006-4-snemec@redhat.com>
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

The variable has to undergo word splitting, otherwise the shell tries
to find the variable value as an executable, which breaks in cases that
7c8a44b25c22 ("tests: shell: Allow wrappers to be passed as nft command")
intends to support.

Mention this in the shell tests README.

Fixes: d8ccad2a2b73 ("tests: cover baecd1cf2685 ("segtree: Fix segfault when restoring a huge interval set")")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
 tests/shell/README                                       | 3 +++
 tests/shell/testcases/sets/0068interval_stack_overflow_0 | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/shell/README b/tests/shell/README
index ea2b0b98f95f..3af17a9e72ca 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -29,4 +29,7 @@ which contains the nft command being tested.
 You can pass an arbitrary $NFT value as well:
  # NFT=/usr/local/sbin/nft ./run-tests.sh
 
+Note that, to support usage such as NFT='valgrind nft', tests must
+invoke $NFT unquoted.
+
 By default, the tests are run with the nft binary at '../../src/nft'
diff --git a/tests/shell/testcases/sets/0068interval_stack_overflow_0 b/tests/shell/testcases/sets/0068interval_stack_overflow_0
index 134282de2826..6620572449c3 100755
--- a/tests/shell/testcases/sets/0068interval_stack_overflow_0
+++ b/tests/shell/testcases/sets/0068interval_stack_overflow_0
@@ -26,4 +26,4 @@ table inet test68_table {
 }
 EOF
 
-( ulimit -s 128 && "$NFT" -f "$ruleset_file" )
+( ulimit -s 128 && $NFT -f "$ruleset_file" )
-- 
2.33.1

