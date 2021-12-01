Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7810C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 11:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhLALO3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 06:14:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33262 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348863AbhLALO2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 06:14:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638357068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AJTlc3c3nDz8ckbaWR9A9aYVczqagufCbN0HgvKkoSk=;
        b=PhBZ8dYer5BjYJN17Q2fQLI07+zw0nz+xz+sa7YsOJan8aCWR8vQDblXeCIlalF6ehJt1u
        8ofZnE01U9FpTlRwv75x+tIrazk9U/31sgeVd4RZn7uVBY5YazAS4RwqSvpMwyoOHfCBqY
        eYv96eSCXZGGzPNxjoqjHbcc2rgBxrg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-460-Pu_l9dQpMmu6ii4sRGdQRA-1; Wed, 01 Dec 2021 06:11:06 -0500
X-MC-Unique: Pu_l9dQpMmu6ii4sRGdQRA-1
Received: by mail-ed1-f72.google.com with SMTP id l15-20020a056402124f00b003e57269ab87so19920295edw.6
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 03:11:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJTlc3c3nDz8ckbaWR9A9aYVczqagufCbN0HgvKkoSk=;
        b=HcMA13TtuCc3XZafmeNv8SrMGjSIRI0t67HsDO8KmeN0Yjcc4mjOa0GrlAGpeDBKkm
         J9XVAU1AREwc70w1MADDcvkw/DZKKXN4J/kCcnUoZXI23f+uqbYexhHY5/wmiimx3qN7
         kW1wC55zyIaxxfRBRtDsQDo3w3Q2v+kVy8GohtD2xYheOM9rsViv6AgdxGHfxullzkou
         mERbIay1MO9L096Q4YFTh6qod1jhQ58+QeQH/kDlE+ym3737JBOjHntLbZWpI7JvVbkh
         W4ItVcZdJ2sni4sKDW6mPPHqUUm+4yRIMJVARSrmWG6eyitS+cd4juq1PUIc0GM6agVq
         d5XA==
X-Gm-Message-State: AOAM530ilajPM5FF5oYA233UvRINst+dMk3b3aK6kjHMeybJvqh0mDI2
        G2Nd8TPMoUvHVbAHjzUEkccpGh9yvD2J+8gORUI91rU301Zf3lnZqN94FwS795tEE7JSQ6uWaKZ
        +mbzpyxELOCDgUp3Npni9aMJdPPtH/Se9FEZ8O5tJ6IhB3ZjwgonFxVMLvIRuYt0R9Xjz6JsU8x
        8MNw==
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr7568378ede.57.1638357064777;
        Wed, 01 Dec 2021 03:11:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwliC74YZaLvgHZuwgY2Z8whDnl56XQMw35EOXvror2O36MegN/04x0xnMu/2WJ8M84QpFODA==
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr7568336ede.57.1638357064463;
        Wed, 01 Dec 2021 03:11:04 -0800 (PST)
Received: from localhost ([185.112.167.59])
        by smtp.gmail.com with ESMTPSA id s4sm11226897ejn.25.2021.12.01.03.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 03:11:04 -0800 (PST)
From:   =?UTF-8?q?=C5=A0t=C4=9Bp=C3=A1n=20N=C4=9Bmec?= <snemec@redhat.com>
To:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     phil@nwl.cc
Subject: [PATCH nft] tests: shell: better parameters for the interval stack overflow test
Date:   Wed,  1 Dec 2021 12:12:00 +0100
Message-Id: <20211201111200.424375-1-snemec@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wider testing has shown that 128 kB stack is too low (e.g. for systems
with 64 kB page size), leading to false failures in some environments.

Based on results from a matrix of RHEL 8 and RHEL 9 systems across
x86_64, aarch64, ppc64le and s390x architectures as well as some
anecdotal testing of other Linux distros on x86_64 machines, 400 kB
seems safe: the normal nft stack (which should stay constant during
this test) on all tested systems doesn't exceed 200 kB (stays around
100 kB on typical systems with 4 kB page size), while always growing
beyond 500 kB in the failing case (nftables before baecd1cf2685) with
the increased set size.

Fixes: d8ccad2a2b73 ("tests: cover baecd1cf2685 ("segtree: Fix segfault when restoring a huge interval set")")
Signed-off-by: Štěpán Němec <snemec@redhat.com>
---
I haven't been able to find an answer to the question of how much
stack size can vary across different systems (particularly those
nftables is likely to run on), so more testing might be useful,
especially on systems not listed above.

In an attempt to avoid depending on a particular stack size and
instead fail the test in case the stack continues to grow, I also
successfully tested the following (across the same range of systems as
the above), but don't think the possible gain is worth the clunkiness.
At least with the current version there is only one assumption (the
stack limit) that might be wrong.

--8<---------------cut here---------------start------------->8---
#!/bin/bash

ruleset_file=$(mktemp) || exit 1

trap 'rm -f "$ruleset_file"' EXIT

{
	echo 'define big_set = {'
	for ((i = 1; i < 255; i++)); do
		for ((j = 1; j < 255; j++)); do
			echo "10.0.$i.$j,"
		done
	done
	echo '10.1.0.0/24 }'
} >"$ruleset_file" || exit 1

cat >>"$ruleset_file" <<\EOF || exit 1
table inet test68_table {
	set test68_set {
		type ipv4_addr
		flags interval
		elements = { $big_set }
	}
}
EOF

report() {
	printf 'Initial stack: %dkB\nCurrent stack: %dkB\n' \
	       "$initial" "$current"
	exit "$1"
}

get_stack() {
	# Going by 'Size:' rather than 'Rss:'; the latter seemed
	# too precise (e.g., it sometimes also catched the
	# initial bump from a few kB to the usual stack size).
	awk '
		found && /^Size:/ { print $2; exit }
		/\[stack\]/ { found = 1 }
	    ' /proc/"$nft_pid"/smaps
}

watch_stack() {
	local interval initial current
	interval=$1
	# discard two initial samples (even with Size: instead of Rss:, it
	# did happen once (in more than 100 runs) that the initial sample
	# was 0kB)
	get_stack; get_stack
	initial=$(get_stack) || { echo This should never happen; exit 1; }

	while true; do
		if stack=$(get_stack); then
			current=$stack
			printf '%d\n' "$stack"

			# failure: stack size more than doubled
			# (should be ~constant)
			((current - initial > initial)) && report 1
		else
			# success?: /proc/$nft_pid/smaps gone means that
			# $nft_pid exited
			wait "$nft_pid"
			report $?
		fi

		sleep "$interval"
	done
}

$NFT -f "$ruleset_file" &
nft_pid=$!

trap 'rm -f "$ruleset_file"; kill "$nft_pid" && wait "$nft_pid"' EXIT

watch_stack 0.01
--8<---------------cut here---------------end--------------->8---

 tests/shell/testcases/sets/0068interval_stack_overflow_0 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0068interval_stack_overflow_0 b/tests/shell/testcases/sets/0068interval_stack_overflow_0
index 6620572449c3..2cbc98680264 100755
--- a/tests/shell/testcases/sets/0068interval_stack_overflow_0
+++ b/tests/shell/testcases/sets/0068interval_stack_overflow_0
@@ -9,7 +9,7 @@ trap 'rm -f "$ruleset_file"' EXIT
 {
 	echo 'define big_set = {'
 	for ((i = 1; i < 255; i++)); do
-		for ((j = 1; j < 80; j++)); do
+		for ((j = 1; j < 255; j++)); do
 			echo "10.0.$i.$j,"
 		done
 	done
@@ -26,4 +26,4 @@ table inet test68_table {
 }
 EOF
 
-( ulimit -s 128 && $NFT -f "$ruleset_file" )
+( ulimit -s 400 && $NFT -f "$ruleset_file" )

base-commit: 247eb3c7a102ce184ca203978e74351d01cee79d
-- 
2.34.1

