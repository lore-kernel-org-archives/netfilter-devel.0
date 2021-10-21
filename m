Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D39CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 17:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C7A615E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 17:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhJUR4R (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 13:56:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37728 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231396AbhJUR4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 13:56:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634838840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SBEbnSZD3k9GNrI98++uqx2j0vBXYFSEk/bywyfR7V8=;
        b=EPQEaUK1swiBxhE6EGG+9CPxBeDAVe5Q2YtK/Ysc1kF37m/212QrnoxtFT5G7hZgX38q4g
        juEJ2sh4xAXNNLGo+v8bW8zZeO0vGlubIGeM4VUcvVn3T2vJ0vanVGpeB/diYBO1qR+7nf
        kz0kshjla+46nZzU7VQ0wX/UTiyKtCM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-6h2bSLDAOc-_kNHvnI7MZw-1; Thu, 21 Oct 2021 13:53:58 -0400
X-MC-Unique: 6h2bSLDAOc-_kNHvnI7MZw-1
Received: by mail-wm1-f72.google.com with SMTP id f63-20020a1c3842000000b0032a621260deso169678wma.8
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Oct 2021 10:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBEbnSZD3k9GNrI98++uqx2j0vBXYFSEk/bywyfR7V8=;
        b=j3uw3fyWOgHonU/2rTVgkgqfW2Joo/KkNjSgibZztmvbXxbltmPPEDggRsoXzCN+O8
         jXdmeGUPVSag0qNNv4NzBvqkxxBfvPvxXBbgbBRVuyavr4+ZQGLQf6NMy2JpHn3MpFHx
         eelbay7Ac50a/6+EddGxgBSfI6lK9VwvSXHqhD/+WsHU94j45gq7qI39qjN4i7wQau43
         HDYKUmckvviG60YbHHW/u2baAiqMJu525pN61y2VB5ltetAIfpcVrsltHlllQrz5YP/7
         mRH7aMpnasQRZKXLpJ9q6bHkHngPYS4YW2P+4Jrdi4AtcGaix54n3sFnwex+3LXYjw9i
         gmMg==
X-Gm-Message-State: AOAM533xG5+zQ8ATXBhG7Xdbo7a2zlEhOyCvQew6598bnHvdszK2kkQ8
        Z7KP66GXxrAPVvPpMfDB4eWy4p5W+ZOwqhga2hDArpH0qmcDByiG4gGRXfOpySUGmf/ycTS36jb
        be3kr1pUX+1kGGafwX72VjY/EsWynoIx0aN8GBvO/eWs0UxeHy3PRY1PrOedpmLQ9KneZQuTkbX
        GVUQ==
X-Received: by 2002:adf:82d6:: with SMTP id 80mr1188675wrc.346.1634838837387;
        Thu, 21 Oct 2021 10:53:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+FXiIMy4Kc8hoDdOlRycfiktZif6FHVhHN5gIkae38mRgz2XMTlOSi0Lug7D5vMHdrVA0uQ==
X-Received: by 2002:adf:82d6:: with SMTP id 80mr1188640wrc.346.1634838836980;
        Thu, 21 Oct 2021 10:53:56 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id c15sm5488576wrs.19.2021.10.21.10.53.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 10:53:56 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     phil@nwl.cc
Subject: [PATCH nft] tests: shell: $NFT needs to be invoked unquoted
Date:   Thu, 21 Oct 2021 19:54:38 +0200
Message-Id: <20211021175438.758386-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
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
The test I added (0068) is the only problematic occurrence.

This would be best applied on top of the README series (otherwise
the README still talks about $NFT being a path to a binary).

 tests/shell/README                                       | 3 +++
 tests/shell/testcases/sets/0068interval_stack_overflow_0 | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tests/shell/README b/tests/shell/README
index 07d5cc2e3e7c..2a6f224f6fc9 100644
--- a/tests/shell/README
+++ b/tests/shell/README
@@ -30,4 +30,7 @@ which contains the nft command being tested.
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

base-commit: d8ccad2a2b73c4189934eb5fd0e3d096699b5043
prerequisite-patch-id: fa363c8411ae8d859aadb73624b07008564db275
prerequisite-patch-id: 8b6016a2f32a72dacadaad08c5f48d4897adf816
prerequisite-patch-id: e2e3c6baa8d81d2da42a32bcd76d8ffd4ad24921
-- 
2.33.1

