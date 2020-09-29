Return-Path: <SRS0=rcIs=DG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3494C4727F
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6816620789
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Sep 2020 12:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="AWaap1bl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgI2Mhf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 08:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729517AbgI2LU6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 07:20:58 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CF3C0613D1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2020 04:20:55 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id o8so14424778ejb.10
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2020 04:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QoPv8XYWxDoMx0Zmv/JMGyNdESVh718xUrha3oLy9jQ=;
        b=AWaap1blNNblOO3YMP3IgsRLaEK/hbPcYEBxRzQYQ7kozXYiPx9UQpZP/WnbEkOUij
         KJPoos73KQqvbw4s44J4VpmZXXnVam+oSBlQvqixqSKBzFDZ1R+8aTj6jpn6XC0tnuOC
         En5yvdB2vTalElDMieoiYlh/vXKADI0gZkVfdEXmpBFwpuFwy2TflJ4PkXgQjCOcXLnu
         Qose/au0Lfq25sMvHaKTFKe3UiDXuR8ikUakmYuQhuoPiGUveHChxBZnpiRZm1ikGggd
         MpU6H2zEHacYDjRJ+xfdEI1AiTXCJnpD2z5B5rRMMhJfmOR7PiP2jmGhNZ0JN17cGNyS
         86hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QoPv8XYWxDoMx0Zmv/JMGyNdESVh718xUrha3oLy9jQ=;
        b=OQPTspRVP7zdCXXKmiGb95ftDv11kiYUn5Z6ksMrk1P8AytwPdNMtZ28DSmkNLavfp
         t9zAAj+XjD/EMGg2Jd/rySwwCV6+g0N84y44jehzeWGlnRsfZ5JPivxdUvx1wxraGEEh
         2euhZYI0eMbUcynNEu9twJa6hnFjTKWkTGWbYs9grNMuzhMcBnRroVLsOv3NUEmHLqN4
         wuNmMel24waTqVrydtT6cbJtajeNlOCzyONU4KhQ06KfaMsuTuNFlllo9EYgLVJma/df
         9esq1iZU9Idq0qy8oZeLBHKsfCnJr4vDqAQyhtuBFWoH73S+eIUrRITVopx5P4OtEoCy
         z1EA==
X-Gm-Message-State: AOAM531Co0sCG/6p/VG9mFvS1+KQG6TfZPGt+thi+NNBKKOFWcGEmbp1
        upTGr3q86B8LfewE7z2wWebcu0pwOs1S6Q==
X-Google-Smtp-Source: ABdhPJz/eJJYRcbXfa8IdLCZ6mKTmDpQXpeLZwrJZ5qqRzC6Uc/UqMB794RLf1PFeB2XUvFp5fbo8Q==
X-Received: by 2002:a17:906:1d08:: with SMTP id n8mr3464009ejh.236.1601378452233;
        Tue, 29 Sep 2020 04:20:52 -0700 (PDT)
Received: from localhost.localdomain (ip5f5af5ad.dynamic.kabel-deutschland.de. [95.90.245.173])
        by smtp.gmail.com with ESMTPSA id bn2sm1999761ejb.48.2020.09.29.04.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 04:20:51 -0700 (PDT)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Subject: [PATCH 2/2] tests: conntrack -L/-D ip family filtering
Date:   Tue, 29 Sep 2020 13:20:17 +0200
Message-Id: <20200929112017.18582-3-mikhail.sennikovskii@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929112017.18582-1-mikhail.sennikovskii@cloud.ionos.com>
References: <20200926181928.GA3598@salvia>
 <20200929112017.18582-1-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

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
index 0e3c649..9c5121d 100644
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
+-L -w 10 -o opt; |s/-w 10/-w 11/g
+-I - ; OK
+# ensure that both ipv4 and ipv6 entries get copied (delete for each of them should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY ; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY ; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump only ipv4 entries to zone 11
+-L -w 10 -o opt -f ipv4; |s/-w 10/-w 11/g
+-I - ; OK
+# ensure that only ipv4 entries get copied (delete only for ipv4 entries should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# dump only ipv6 entries to zone 11
+-L -w 10 -o opt -f ipv6; |s/-w 10/-w 11/g
+-I - ; OK
+# ensure that only ipv6 entries get copied (delete only for ipv6 entries should succeed)
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# now test deleting w/ and /o family specified
+# for simplicity do it by re-creating entries in zone 11
+# by copying ezisting entries from zone 10 into it
+# re-create entries in ct zone 11
+-L -w 10 -o opt; |s/-w 10/-w 11/g
+-I - ; OK
+# delete all entries in zone 11
+-D -w 11 ; OK
+# both ipv4 and ipv6 should be deleted
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+# re-create entries in ct zone 11
+-L -w 10 -o opt; |s/-w 10/-w 11/g
+-I - ; OK
+# delete only ipv4 entries in zone 11
+-D -w 11 -f ipv4 ; OK
+# ipv6 should remain
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; BAD
+ # re-create entries in ct zone 11
+-L -w 10 -o opt; |s/-w 10/-w 11/g
+-I - ; OK
+# delete only ipv6 entries in zone 11
+-D -w 11 -f ipv6 ; OK
+# ipv4 should remain
+-D -w 11 -s 1.1.1.1 -d 2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -r 2.2.2.2 -q 1.1.1.1 -p tcp --reply-port-src 11 --reply-port-dst 21 --state LISTEN -u SEEN_REPLY; OK
+-D -w 11 -s 2001:DB8::1.1.1.1 -d 2001:DB8::2.2.2.2 -p tcp --sport 10 --dport 20 --state LISTEN -u SEEN_REPLY; BAD
+-D -w 11 -u SEEN_REPLY -s 1.1.1.1 -d 2.2.2.2 -r 2.2.2.2 -q 1.1.1.1 -p icmp --icmp-type 8 --icmp-code 0 --icmp-id 1226 ; OK
+# clean up after yourself
+ -D -w 10 ; OK
\ No newline at end of file
-- 
2.25.1

