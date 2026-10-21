Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792611326;
	b=dEP0CQ5YrcP+PlE3DNpCBV3uRVVVdVG5rKQr9XM26GD/3EutAbr5uBv3Qv+eMhDfprTq
	 Me2u0/3Pwh/AvDkEbHwg/PRi11wl8RDb6vrWFfli63xnH0eikRc8ezOxwwB7DbUF/Os9h
	 6lnTUuKfMqKxMfdxBdF17kYI+l0YHnsww1K5/HRxOzSuN7rbdouYQKbwDtYyZv6Ql8s54
	 UHIf9qFpyhU3NGxj/QVkBjcGDa5sXyuu9KpvJLJkec1XodZt34xoxG8zV5jIefI8pyENy
	 +5mmd8AY6b6cL28SYBB5UY2obo2gnfBBCUw2pYR+xx9E+EQvkWpnZr+mEzDkipJ/gXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611326;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=vIq4J9MzmzYl9oQxr9an2njN9RrUmQCNsR3GT631TE0=;
	b=eC2JI7I4nExQTtD+tHR2Nt4py9hZlBg1CPLTfD5mCH4iNxG/pnQT+1Jeved/a38E/nB3
	 QyS9iLC7R8wPuyLPi6szB49qvsEFwZnQM6ldvxfovh/VWj3LxyYz1DvxJ1x+wZlX7njlN
	 +/h9MVj97OzZ5kHBIYFj6MnypkcDhRbdmV29itVd5ynWtmuiovFozkUrEkT7iMCTSNO2E
	 Y7EEO7T1BBnkzUEzlU4Kio0ToZkdeCL6QisrAoqXj/SPdT2M3WMVbe6ImpTSelf9T8pvH
	 a+D5NQMPXuhdW74qlGqtLnhmWIGCUQlMy1ya2m8gVHgc43QqA0TzMfQkakXFvGqyoAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aojea.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rPdnznH9;
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A387F606A323
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:35:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A387F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=rPdnznH9
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c293e604f0eso98887666b.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792611324; x=1793216124; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vIq4J9MzmzYl9oQxr9an2njN9RrUmQCNsR3GT631TE0=;
        b=rPdnznH97tB2T9f33KhM0QYq62lm5EwFMKafP+L6niBy5Fa8vkg37IgpXIebI9qIe9
         cs9kZmzZGA/vVRxrLbT6o02djMg9NnfE2nOvAHq86dK5biPEzGJa2RlH9zc0XIGu52tH
         GX/AeQsJpWolqNZQMvpYG6ToGFESIZu/Zl6hYXkwy8ZM9sK1fE7gKU4NHnS8r/1M2Uxu
         R3344PGyyPkQmZKJaxw7NFBV0teDraqr5ckaTc0Ql97o9ttNy5NMSZbhRA9GvrJZcWZ5
         BNNHPD4WLLwaW6QkLyGoCqLZLCey+uG8fSWVe7/SF/SuhmKcTwCwu7TkeGYWpMHIigbx
         hWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611324; x=1793216124;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vIq4J9MzmzYl9oQxr9an2njN9RrUmQCNsR3GT631TE0=;
        b=O6dNP+oBRy3E/kuhwMnXHxWXl/0Dx2gj6fC+Pq3rEocbBwvYOauBL3WxOdRvQ+e9bs
         Z3W1k8szFgjlPs5PNzzjVbV03NMOSz3Qe5LnUD979Y9LaDgWCVmpCHu2czb1m5ccX7F4
         tN6RW916y0t/O1krYsomwgrb/xnB8F1a0klz5J92QGeyLmaWiSAVL0qjSAFOGHmAS0hx
         09cIMMqg5mAFUNgNBmMc6Qe8X7LFypTjVjtVm6TtAdnlFF80BjqMrpV1Myshujepeibk
         0BlxGaY2Z48WGyVT+tZqaj98VSFW+oQ1Ap6M8RYKvmE5ekqgvMJmlI8O21VFaotI/UpN
         0TZw==
X-Gm-Message-State: AFq9FYI1evAbWKwVtJmE0UNgM/3tD5HbqVWakCWJaq87nvEwO4TWFsEW
	HHsY8RQaXtF7Qbni6aBIwXbENGmk18tASnHqqy5SeY6Zi5aC663NsqaFIYvESyznHtIJmMkQbc3
	79A==
X-Received: from ejdq8.prod.google.com ([2002:a17:906:3888:b0:c3f:6152:2d8])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:9f85:b0:c40:bbd2:62f3
 with SMTP id a640c23a62f3a-c4679b9d976mr267535966b.49.1792611323850; Wed, 21
 Oct 2026 12:35:23 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:35:12 +0000
In-Reply-To: <20261021193512.2302587-1-aojea@google.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261021193512.2302587-1-aojea@google.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021193512.2302587-5-aojea@google.com>
Subject: [PATCH nf-next 4/4] selftests: netfilter: nft_queue.sh: harden test_hook_drop_scope
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, bridge@lists.linux.dev, Antonio Ojea <aojea@google.com>, 
	"Sashiko (nipa)" <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

hook_drop_case() ignored two outcomes that make its result meaningless:
when the 20 packets do not all reach the queue before the timeout, the
drop case still passes with an empty queue, and when the nft command
under test fails, nothing is unregistered and the keep case still
passes. Report both as failures.

The keep case deleted an ip6 prerouting chain, which differs from the
ipv4 output packets in both the family and the hook number, so a
nf_hook_cmp() that compared only one of the two would still pass. Add
a keep case for each: an ip6 output chain and an ip prerouting chain.

Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/179237288374.3135.9473018103688224106@kernel.org/
Assisted-by: LLM
Signed-off-by: Antonio Ojea <aojea@google.com>
---
 .../selftests/net/netfilter/nft_queue.sh      | 30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 516d9012d2e4..954b7bc4d789 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -912,10 +912,18 @@ table inet nfqscope {
 	}
 	counter delivered {}
 }
+table ip unrelated {
+	chain prerouting {
+		type filter hook prerouting priority 0; policy accept;
+	}
+}
 table ip6 unrelated {
 	chain prerouting {
 		type filter hook prerouting priority 0; policy accept;
 	}
+	chain output {
+		type filter hook output priority 0; policy accept;
+	}
 }
 EOF
 	ip netns exec "$ns1" ./nf_queue -c -q 1 -H -t "$timeout" > "$TMPFILE1" 2>&1 &
@@ -926,13 +934,19 @@ EOF
 	ip netns exec "$ns1" bash -c \
 		"for i in \$(seq $packets); do echo x > /dev/udp/127.0.0.1/12345; done"
 
-	busywait "$BUSYWAIT_TIMEOUT" hook_drop_all_queued "$packets"
-
-	ip netns exec "$ns1" nft "$@"
-	queued=$(hook_drop_queued)
+	if ! busywait "$BUSYWAIT_TIMEOUT" hook_drop_all_queued "$packets"; then
+		echo "FAIL: $desc: $(hook_drop_queued) of $packets packets queued" 1>&2
+		ret=1
+	elif ! ip netns exec "$ns1" nft "$@"; then
+		echo "FAIL: $desc: nft $* failed" 1>&2
+		ret=1
+	else
+		queued=$(hook_drop_queued)
+	fi
 
 	kill -USR1 "$nfqpid"
 	wait "$nfqpid"
+	[ -z "$queued" ] && return
 	delivered=$(hook_drop_delivered)
 
 	if [ "$queued" = "$packets" ] && [ "$delivered" = "$packets" ] &&
@@ -955,9 +969,15 @@ EOF
 
 test_hook_drop_scope()
 {
-	# the hook array of another hook point changes, queued packets stay
+	# the hook array of another hook point changes, queued packets stay.
+	# The packets are ipv4 at output; cover a chain that differs in both
+	# family and hook, in the family only and in the hook only.
 	hook_drop_case keep "base chain removed at another hook point" \
 		delete chain ip6 unrelated prerouting
+	hook_drop_case keep "base chain removed at the same hook of another family" \
+		delete chain ip6 unrelated output
+	hook_drop_case keep "base chain removed at another hook of the same family" \
+		delete chain ip unrelated prerouting
 
 	# the hook array of the queueing hook point changes, the position of
 	# the queued packets in it is stale, they are dropped
-- 
2.56.0.218.g1ec904b173-goog

