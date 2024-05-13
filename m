Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CBB80C
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 00:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715559009; cv=none; b=jzKDSJpAOomblEeVI67o3LCWOF3w+KGGGP4/fECofWlfkadp4SeCRLZmSRcETMB4qg8rr+V00h1p74fBzfZEd5Z6LtTIR6P7jqXX/hml2+0JmgV/KZrkjhDFD7XwYj6yNNeTmtUd5CUqFlAQ77yVcepDpz2CeZD8EwJhJwZ70yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715559009; c=relaxed/simple;
	bh=e9MzZhYLpeEu/4EYqjX0x/UhwNdkvGsS//SHXfG2E1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qWwC+brk/+hAxzeOQKMJdJYzPvgRKobAhOVFa9h0hxarCiSoQSYVQ/t5GKyFKmSRdWkaRCTRd7AzKGRsigYUxqO2Kdz9224AaXGwC9sXkxBmUG9VX+iejUull9GDrNBucDeQpNkUZuhz6dDjuLEYzIFYeDQwaQRs42fJ6ypGQfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NBtzZQfp; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NBtzZQfp"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61510f72bb3so75565927b3.0
        for <netfilter-devel@vger.kernel.org>; Sun, 12 May 2024 17:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715559006; x=1716163806; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/T2vV+rwgF2ttDJrQAVcBOgx0bc8+qmSjEhPHlAqsDI=;
        b=NBtzZQfpJB95628sGF8q1AJWbCnl2qzHNtKgP2vx57byvuMqUVJ0hFkfwWVYxoyikk
         MwlaerjFX2+3nCHsiRK+uEVSF18tO9OC6VxEMq16gQLh2DBe2VJ6s+wLoZ2gwDYAGTjn
         3jCZO5teZATjxmP+0kEsNkRlZQQgUtdYNOZhuth/ChOwpS1jZ5aJjvjI+R0E2RdUJ1k9
         xqv6K1qCVN2Q2GPlcs29r4fAc8nt6h818zPN2is5SmNeP9cvuPfr4td/he82JL+/meeV
         jHS3kCsTrj1uC41wDNq4+B+woFo9/kIIYHzaEbMHeUSfSiGcV6YTTIXjkhFOlxM40G+P
         mHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715559006; x=1716163806;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/T2vV+rwgF2ttDJrQAVcBOgx0bc8+qmSjEhPHlAqsDI=;
        b=muiYiGTaxpBx2w7XJ/TIFK52uIJPMi4ohw4PGU2OprB3GT8A8uZ5meA2i/ZiNew33V
         WEY4eC3nEzF0xADAaXuhkitoftLfzNn5V3QMf7wGlmk22wBSw1+3eDJSLVRUMmy1ArCs
         BZpHe5QrpA355H4d95VNPr7yvtkqcl84bqfPdGtYAR67HpHNIZLD+5LDhMxYw5zqDgym
         DMwuVWFKxoRB0i4wKdcSQ3e7z3XtZFVAxcRBGCHG5p0w6VQOpo30MTZiWKfO14ZrdRbD
         2RgcK13IJH234gG3iYAiuNDYJGpXnzd4F+S4lbLkncxH9HrLe/ZIcA7x5dlohPmVyrOG
         Q5qg==
X-Gm-Message-State: AOJu0YxvjNMJdgaQjfpefMDJYS0MHIW3TDPhX+HX+9t3IigTD5rZYBBR
	4HuSv7hgJUqkXF027duUUgVkn54v0iv3xNAuSpWmH6fzhixX2UnxRnpgFv2J/XJjulOGxhRQQi5
	ud4Yg7Hm0NNA0QCpS9DkqagbLdaId5/9qlnMhuCiSKYNLzVCPHaj+jGZO5d8DfC8LN2yfsSsk9v
	MHsufaYi6c6YxWYwRWSQEoqLUP4UlJKss6TJIC1k0=
X-Google-Smtp-Source: AGHT+IGDzG4wbg11jT3K5VOBJDbY5kyDH8dSiH44cxp5NFl20jIjiyH2bf89FGXIQS8OKVJ9h+h9XZcHVw==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a0d:ea0d:0:b0:622:cd7d:fec4 with SMTP id
 00721157ae682-622cd7e0027mr11084597b3.9.1715559006092; Sun, 12 May 2024
 17:10:06 -0700 (PDT)
Date: Mon, 13 May 2024 00:09:53 +0000
In-Reply-To: <20240513000953.1458015-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240513000953.1458015-1-aojea@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240513000953.1458015-3-aojea@google.com>
Subject: [PATCH v2 2/2] selftests: net: netfilter: nft_queue.sh: sctp checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, fw@strlen.de, Antonio Ojea <aojea@google.com>
Content-Type: text/plain; charset="UTF-8"

Test that nfqueue, when using GSO, process SCTP packets
correctly.

Regression test for https://bugzilla.netfilter.org/show_bug.cgi?id=1742

Signed-off-by: Antonio Ojea <aojea@google.com>
---
 .../selftests/net/netfilter/nft_queue.sh      | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index 8538f08c64c2..5e075c7e0350 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -25,6 +25,9 @@ cleanup()
 }
 
 checktool "nft --version" "test without nft tool"
+checktool "socat -h" "run test without socat"
+
+modprobe -q sctp
 
 trap cleanup EXIT
 
@@ -375,6 +378,40 @@ EOF
 	wait 2>/dev/null
 }
 
+test_sctp_forward()
+{
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+table inet sctpq {
+        chain forward {
+        type filter hook forward priority 0; policy accept;
+                sctp dport 12345 queue num 10
+        }
+}
+EOF
+        ip netns exec "$nsrouter" ./nf_queue -q 10 -G -t "$timeout" &
+        local nfqpid=$!
+
+        timeout 5 ip netns exec "$ns2" socat -u SCTP-LISTEN:12345 STDOUT > "$TMPFILE1" &
+        local rpid=$!
+
+        # ss does not show the sctp socket?
+        busywait "$BUSYWAIT_TIMEOUT" sh -c "ps axf | grep -q SCTP-LISTEN" "$ns2"
+
+        ip netns exec "$ns1" socat -u STDIN SCTP:10.0.2.99:12345 <"$TMPINPUT" >/dev/null
+
+        if ! ip netns exec "$nsrouter" nft delete table inet sctpq; then
+                echo "FAIL:  Could not delete sctpq table"
+                exit 1
+        fi
+
+        if ! diff -u "$TMPINPUT" "$TMPFILE1" ; then
+                echo "FAIL: lost packets?!" 1>&2
+                return
+        fi
+
+        wait "$rpid" && echo "PASS: sctp and nfqueue in forward chain with GSO"
+}
+
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
@@ -413,5 +450,6 @@ test_tcp_localhost
 test_tcp_localhost_connectclose
 test_tcp_localhost_requeue
 test_icmp_vrf
+test_sctp_forward
 
 exit $ret
-- 
2.45.0.118.g7fe29c98d7-goog

