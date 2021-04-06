Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38825C43461
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F4F613CA
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 10:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237305AbhDFKKO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242659AbhDFKKO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 06:10:14 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA8BC06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Apr 2021 03:10:06 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id d12so21783558lfv.11
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Apr 2021 03:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ootrj0MHPzZ7u8gCpBFAcFoQ8aKA6G+ziCd0m3Nz7FQ=;
        b=B1IGAmemC4rRUa4tNqzW+gy0X4CWictAIvoXusWLVG7T08NnpbjooV/nLO9pB5DMsB
         Ug5rNF7yXc8jbs5bflj4X95W0EcsYDN74G5fAnoZoh4rG5BxJnGSevbfhJdNRWP5XscT
         fRdtY7i5XdynfJjNZ9lqs9S2Id6fDuGF5pzG1mcRTZx/qQ0weHotqlvOlvYQSUroV6VY
         bX9k9R5ny4ANWy7o6Pj1TnkDMSNWzhAR4YDnIqdlVXS5T4Mx3Mz2QFiUd5KGtIaBftvW
         VKafPSWgk5rU/2Lv1n/i5PO+2RBTCcBl6DByCocoDFTUNQmstCp/UOy7vd/OWHBD5WFW
         J5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ootrj0MHPzZ7u8gCpBFAcFoQ8aKA6G+ziCd0m3Nz7FQ=;
        b=io9VPcYPRfg1i0/cvvff0hrzaWB6unw5YFhg4y5z39HqktbwE1BjTfbfggbDBck3gN
         FIdr4lYoPaz8LRjacsUyDgLAZ94NmvCV2MldrH0W7GNwgfYpvOjPrXLRfz0npNns5xfu
         U4M9em3C1l3bfjiDS8UMcOcj4MYMs4UatPSSyti8PUQP/Qty5MLjV/Fb9YYRpfY5HKFD
         sxHeC5KKzB8nOzBM7oSyz+e2FSdE0rtOanYLFW/LmBZS+ZnrCKnKJ/htH1OKr9fE15zX
         lM2izR1ng7aKoQ63OD157BLNx8Hc0G/zGrRv7AE8xA8G2x9Yrdbjx6LrvoBfgrmfK9U5
         7W/A==
X-Gm-Message-State: AOAM530l2tOGx+iT0nHnHYfwZKZaJVXBBU14cs3EFbVof0Gz3775hcOl
        nP0IsbzOqrnZ7EyeOS3OTGPTjDcZes//1Dfx
X-Google-Smtp-Source: ABdhPJx2K50ltn8sAKvZMu24rcxkwqqMIDTdxmbdqNO85lc6ywlXWPBp31alxPQrXK5cjtE9EFqr0Q==
X-Received: by 2002:a05:6512:a95:: with SMTP id m21mr20569545lfu.59.1617703804560;
        Tue, 06 Apr 2021 03:10:04 -0700 (PDT)
Received: from msennikovskii4.fkb.profitbricks.net ([2a00:1fa1:c4fc:25fe:f165:934d:dfbd:8cd3])
        by smtp.gmail.com with ESMTPSA id l7sm2170070lje.30.2021.04.06.03.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 03:10:04 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovskii@ionos.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH v4 5/5] tests: conntrack -L/-D ip family filtering
Date:   Tue,  6 Apr 2021 12:09:47 +0200
Message-Id: <20210406100947.57579-6-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
References: <20210406100947.57579-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>

Tests to cover conntrack -L and conntrack -D with and w/o
family (-f) specfied.

conntrack -L and contnrack -D shold list/delete
both IPv4 and IPv6 entries if no family is specified,
and should ony display the corresponding entries if
the family is given.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
---
 tests/conntrack/testsuite/09dumpopt | 72 ++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/tests/conntrack/testsuite/09dumpopt b/tests/conntrack/testsuite/09dumpopt
index 0d5d9d4..447590b 100644
--- a/tests/conntrack/testsuite/09dumpopt
+++ b/tests/conntrack/testsuite/09dumpopt
@@ -74,4 +74,74 @@
 # delete v6 conntrack
 -D -w 10-s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 ; BAD
 # delete icmp ping request entry
--D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
\ No newline at end of file
+-D -w 10 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+#
+# Additional tests to check that family attribute is treated properly
+# for -L and -D commands
+# namely:
+# - if family (-f) is given - only entries of the given family are dumped/deleted
+# - if no family is given - entries of both ipv4 and ipv6 families are dumped/deleted
+# First create some ipv4 and ipv6 entries
+-I -w 10 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -w 10 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -w 10 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY -t 50 ; OK
+-I -w 10 -t 29 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump all entries to zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# ensure that both ipv4 and ipv6 entries get copied (delete for each of them should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY ; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY ; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump only ipv4 entries to zone 11
+-L -w 10 -o save -f ipv4; |s/-w 10/-w 11/g
+-R - ; OK
+# ensure that only ipv4 entries get copied (delete only for ipv4 entries should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump only ipv6 entries to zone 11
+-L -w 10 -o save -f ipv6; |s/-w 10/-w 11/g
+-R - ; OK
+# ensure that only ipv6 entries get copied (delete only for ipv6 entries should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# now test deleting w/ and /o family specified
+# for simplicity do it by re-creating entries in zone 11
+# by copying ezisting entries from zone 10 into it
+# re-create entries in ct zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# delete all entries in zone 11
+-D -w 11 ; OK
+# both ipv4 and ipv6 should be deleted
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# re-create entries in ct zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# delete only ipv4 entries in zone 11
+-D -w 11 -f ipv4 ; OK
+# ipv6 should remain
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+ # re-create entries in ct zone 11
+-L -w 10 -o save; |s/-w 10/-w 11/g
+-R - ; OK
+# delete only ipv6 entries in zone 11
+-D -w 11 -f ipv6 ; OK
+# ipv4 should remain
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# clean up after yourself
+-D -w 10 ; OK
-- 
2.25.1

