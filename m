Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F940C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66F1A60EB4
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Oct 2021 12:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJTMoT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:44:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51904 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230174AbhJTMoT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Oct 2021 08:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634733724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CvPu+swzgsHgkaX+BbyuNIXwzDUHOqOknSziqmol1wk=;
        b=Sj6j8AijnbAeigOr7s1xVkDENIKE33pFq+71GnnD40qK7lr7IBYXFOgx01DlMOjeM7TQ87
        xw9oJCf4kaQzddXigL4hJu5gFpjqFBmuWvt6/j6YzIKLiunYkxl+C4AtHnbmNlbHhXG17W
        vngdF50bIMvHAD070f/df6V+NSC9uDA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-L1-1driTMVqt8GqB6P2vGQ-1; Wed, 20 Oct 2021 08:42:03 -0400
X-MC-Unique: L1-1driTMVqt8GqB6P2vGQ-1
Received: by mail-wm1-f69.google.com with SMTP id d16-20020a1c1d10000000b0030d738feddfso3128277wmd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Oct 2021 05:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CvPu+swzgsHgkaX+BbyuNIXwzDUHOqOknSziqmol1wk=;
        b=MyJ8Ki2C+EgPLWyUPooD85Owm2A5WS3j/0D+6CUrmTtkcRCzUCmKG/rmxYxGR5EpAn
         3A6VNcD4GR4rz0LnYKK+nsygqWmOt6b+SKi5xadD0lmyzaTkt2GFvUzoowRZb4L2fw9C
         xuPejEdizyM9xJDi76KB5i3enPiOOY1lyh3j5OH/3GzQBDpmbgmzWIYRExzcy2HSzi90
         hTjO+AvQcF3ASvarn1J/EZMaPaMRrPDxWCTMV+bHLhcVKh1WcHW628YQWLccID4XvBFc
         RMtWkpfHjdDPzYKv9VDT+5JXwcujAa2CDX3eCCC4Q0RL8k5NCvUelCT1v/eMd6iSDlbY
         p0XQ==
X-Gm-Message-State: AOAM530ytcxKm49Hiucqj5w0rFu4lSyXUxWSF6pf2DbSbSP8eJlevyIQ
        2dkylVUNWi5Ts8D33FTuRftX/3Cmqgvanhpn/2EhCLEiyvS2/CZ3EDgJVeY/XlYk9RvhR/QPH3N
        p6xxp9A4lQu2Qf+XrsaFOLZIOuWbQAecwRDTQqOh5oqf00R5PCzKOIzxgZbB9O2n1+4WYZKEk/Q
        Z3jw==
X-Received: by 2002:a1c:2b85:: with SMTP id r127mr13455061wmr.134.1634733721905;
        Wed, 20 Oct 2021 05:42:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxDUkMZhzhnLlPdQ1+Sub75clnNcfYjWIdBUoy9v7epjpp75UNMU0SYfnOXOV+h4SwA7XLI5g==
X-Received: by 2002:a1c:2b85:: with SMTP id r127mr13455044wmr.134.1634733721710;
        Wed, 20 Oct 2021 05:42:01 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id y8sm1808794wmi.43.2021.10.20.05.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:42:01 -0700 (PDT)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft] tests: cover baecd1cf2685 ("segtree: Fix segfault when restoring a huge interval set")
Date:   Wed, 20 Oct 2021 14:42:20 +0200
Message-Id: <20211020124220.489260-1-snemec@redhat.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Test inspired by [1] with both the set and stack size reduced by the
same power of 2, to preserve the (pre-baecd1cf2685) segfault on one
hand, and make the test successfully complete (post-baecd1cf2685) in a
few seconds even on weaker hardware on the other.

(The reason I stopped at 128kB stack size is that with 64kB I was
getting segfaults even with baecd1cf2685 applied.)

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1908127

Signed-off-by: Štěpán Němec <snemec@redhat.com>
Helped-by: Phil Sutter <phil@nwl.cc>
---
 .../sets/0068interval_stack_overflow_0        | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100755 tests/shell/testcases/sets/0068interval_stack_overflow_0

diff --git a/tests/shell/testcases/sets/0068interval_stack_overflow_0 b/tests/shell/testcases/sets/0068interval_stack_overflow_0
new file mode 100755
index 000000000000..134282de2826
--- /dev/null
+++ b/tests/shell/testcases/sets/0068interval_stack_overflow_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
+
+ruleset_file=$(mktemp)
+
+trap 'rm -f "$ruleset_file"' EXIT
+
+{
+	echo 'define big_set = {'
+	for ((i = 1; i < 255; i++)); do
+		for ((j = 1; j < 80; j++)); do
+			echo "10.0.$i.$j,"
+		done
+	done
+	echo '10.1.0.0/24 }'
+} >"$ruleset_file"
+
+cat >>"$ruleset_file" <<\EOF
+table inet test68_table {
+	set test68_set {
+		type ipv4_addr
+		flags interval
+		elements = { $big_set }
+	}
+}
+EOF
+
+( ulimit -s 128 && "$NFT" -f "$ruleset_file" )

base-commit: 2139913694a9850c9160920b2c638aac4828f9bb
-- 
2.33.1

