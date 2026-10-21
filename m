Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792611325;
	b=oG0zQttA4oXGan1zjo+gjGVtv6B1AkbOrXhByZU93gQVxk84Wj6TpvBzk9BftcUsYYTm
	 O7H5HpoZcTJsZIoxQz/ML1e3GNKIEx0WwNX5/prENNOO/DVyljO1nhQQ9v7XfqKyyRH3U
	 VdKZ2Dv6j7Jorzb2cDF0Wwe8baDH0Kt981tKubMfnuxEBmbUW1pqLvKfw9Qqa8iARuFwt
	 Tbp8S1uTB/WAbkwk/7kiv3trmfRfSwdQmcG/gjc365aXc9liQLclUprq6r0DugB3/TD0O
	 Dye8Uy3hMyojxzI9Lz0nxpvhIid9wi4ztRqK1Sw+n1/64aCEBYuohd7gtDbg+jQd2WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792611325;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:In-Reply-To:Mime-Version:
	 References:X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=ntydpfW1d30II09RtQRM5wPDP9t6AwfW5fmKsjgca+U=;
	b=rwg2V/F6UIAYCCKIJw/4PAhWA8l8DyxTJT+uppMqLytaWoHz68VAnb6NaaZ+0uG6lbLS
	 fsXJjC6dZXzcuVsfuIxctGTewuZqs3LvXB5cf9Vw+iKQDFB9meUP4kE98gu/RJ9OxGly8
	 UJMavJMEKDx53djH9qrZugssZMLkl5KOgAn2vQaY68OBjN4rmQ30sgf0DrssxpVNymPvE
	 hZVoaOTz8EVkEVQXMAhUKUGiPPp6Vza2+k7ER+fQe+AfF2sqZPnF/mvNMrRLg1UrhscdG
	 SuijYC2cTAnB1maXo+7xhrArkT2gaOZ+H7YMn+9mo6KvsXa7YJVR9tit0jVkTOeDNhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aojea.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HL4POSx1;
	arc=none smtp.remote-ip=209.85.218.72
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5522606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 19:35:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5522606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=HL4POSx1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c210c66672eso109998366b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 12:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792611323; x=1793216123; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ntydpfW1d30II09RtQRM5wPDP9t6AwfW5fmKsjgca+U=;
        b=HL4POSx1TMuTZwBZxynHn2bbvPLNuuAK7WKulb75sX0cIyTHOnMrr+us+AIgu2Nj7F
         o98WgUGLR1Ec3RxqC22GWtnGcCqdL2pu1gu1vcArU0DeGEHjbGJ9zqD9sozymtRmmkqg
         MB4q1CDgw9qnMZUi+06AVs29qcNTHMOj5vUHTvFC91Qjk1UKYUHYEYfaXfcaksFfYIaI
         6ZCK1pB8aKWUhHMyYn3t/gayqlYmU6wX0HVEt5XtHkDr/ydH+Na0DbSrC7zDW1imTT6p
         cG2I1HUPUgsBdWZITxwtwrp/ZieQhaFVlzHthsJ95L6YymZSza8lAyuYb3TAzd7YW1kw
         LKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792611323; x=1793216123;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ntydpfW1d30II09RtQRM5wPDP9t6AwfW5fmKsjgca+U=;
        b=pzZFlnqpxeXPAUbeL0kci0EuL4bmEydQaL0+f+CDVvmGR6g+2y9CrP5llWduBpIgUf
         UDyT36VLz6RdzGFaWg1svPjOI96Leny7+42R4nmhJuq5s7MiDL+7eN20GAvoF71vZqUt
         osNM5PZr4mGbwnBwh1qeP+x6OK0hJKA7BKQ4ZfeHy0Wrm+4kpXwPZh+1cF8GT23oH75N
         fuF5YqmRXC3buZKansDAzDmxNHMVANimO/mKu/uB5cgjF1WElXra7TpGCq2yGFw05lP5
         3pEWnmeda1QlT3IpZ6MVzAmoDcEdIN4zHlErGQ0i0/JzkcSGq+JhLfTI5dCWHyIC3AqO
         KLiw==
X-Gm-Message-State: AFq9FYJRJtRtQRJVUPo2MFPchx7pFMzcuJAW/Cw62XeIFx2xh9oNguMp
	0RC5OHKYnSzBcEE0016XYwgqOB0CER9497WkopHRzJ/+wc6CtvuBkTgIA/teqfyRhANtXBQ7kf/
	GQQ==
X-Received: from ejcwz4-n1.prod.google.com ([2002:a17:907:b044:10b0:c3f:54fa:21fa])
 (user=aojea job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3d88:b0:c29:f5d8:9c75
 with SMTP id a640c23a62f3a-c46797aef75mr271703066b.36.1792611322773; Wed, 21
 Oct 2026 12:35:22 -0700 (PDT)
Date: Wed, 21 Oct 2026 19:35:11 +0000
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
Message-ID: <20261021193512.2302587-4-aojea@google.com>
Subject: [PATCH nf-next 3/4] selftests: netfilter: nft_queue.sh: fix the exit
 status on failure
From: Antonio Ojea <aojea@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>, 
	Ido Schimmel <idosch@nvidia.com>, bridge@lists.linux.dev, Antonio Ojea <aojea@google.com>, 
	"Sashiko (nipa)" <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Tests record a failure by setting the global ret=1 and the script ends
with exit $ret. test_queue() overwrites that flag with the status of a
bare wait, which is always 0. test_queue_bridge() runs last and calls
test_queue() twice, so a failure recorded by any earlier test is lost
and the script exits 0. Drop the assignment: test_queue() checks the
listener output itself and exits on a mismatch.

Three connectivity checks exit with $ret after printing FAIL; ret is
still 0 when nothing has failed before, so the script exits 0 there as
well. Exit with 1.

Replacing the test_hook_drop_scope call with ret=1 shows the difference:
the script exited 0 before this patch and exits 1 with it.

Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netfilter-devel/179237288374.3135.9473018103688224106@kernel.org/
Assisted-by: LLM
Signed-off-by: Antonio Ojea <aojea@google.com>
---
 .../testing/selftests/net/netfilter/nft_queue.sh  | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index a07652813a4b..516d9012d2e4 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -240,17 +240,16 @@ test_queue()
 	busywait "$BUSYWAIT_TIMEOUT" nf_queue_wait "$nsrouter" 1
 
 	if ! test_ping;then
-		echo "FAIL: netns routing/connectivity with active listener on queues 0 and 1: $ret" 1>&2
-		exit $ret
+		echo "FAIL: netns routing/connectivity with active listener on queues 0 and 1" 1>&2
+		exit 1
 	fi
 
 	if ! test_ping_router;then
-		echo "FAIL: netns router unreachable listener on queue 0 and 1: $ret" 1>&2
-		exit $ret
+		echo "FAIL: netns router unreachable listener on queue 0 and 1" 1>&2
+		exit 1
 	fi
 
 	wait
-	ret=$?
 
 	for file in $TMPFILE0 $TMPFILE1; do
 		last=$(tail -n1 "$file")
@@ -851,7 +850,7 @@ test_queue_bridge()
 
 	if ! test_ping;then
 		echo "FAIL: netns bridge connectivity" 1>&2
-		exit $ret
+		exit 1
 	fi
 
 	load_ruleset "bridge" "filter" 10
@@ -979,8 +978,8 @@ if test_ping; then
 	# queue bypass works (rules were skipped, no listener)
 	echo "PASS: ${ns1} can reach ${ns2}"
 else
-	echo "FAIL: ${ns1} cannot reach ${ns2}: $ret" 1>&2
-	exit $ret
+	echo "FAIL: ${ns1} cannot reach ${ns2}" 1>&2
+	exit 1
 fi
 
 test_queue_blackhole ip
-- 
2.56.0.218.g1ec904b173-goog

