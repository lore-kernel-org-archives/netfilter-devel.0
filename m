Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3A384A4D
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 22:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715637645; cv=none; b=MMA1ioMhp6XV/RSc+HGAlWtAuEkHdniBJJZMYLmUkDph61mvqigZMmJtz1kAvYMLXxQOd+bQr1aXAyexj+BTmFuKajHli0Gnx/IYPDDMjb+z289znfOyzrVdc1AOHk00/Exu0r3OzJLhvTTb6P4slljS2vOczV4z0lZquGKpIjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715637645; c=relaxed/simple;
	bh=e9MzZhYLpeEu/4EYqjX0x/UhwNdkvGsS//SHXfG2E1c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X1Dn7PD3VWXPA6lDaGnDxrxVPzJnOSwYrv7MG1w6+z17i8c0v2YVD+sxsHkC+tRmlDOSlib3aaxW7sp25smW03G5rG99+VUmxmKOkFu4+GBLm4APOgsuYw7RkBHv+UYhspl1km4jTXGwVQHyDSGxlS7USYsakSfVydu4/JFGQyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=meT7waSC; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="meT7waSC"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-572b0a23d55so155320a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 15:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715637642; x=1716242442; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/T2vV+rwgF2ttDJrQAVcBOgx0bc8+qmSjEhPHlAqsDI=;
        b=meT7waSCUDdGckgVQrpvLcXjOkOp0rXBNJqikvlFdFC+VlN45UfnNhESzfWtsNSBeW
         hm2XEkENvlJVj/GcdAZfmu9Hia6oups/OgTJMEWVv0QeRcMneHz/ypE6bbqnQAA5GA9L
         X2WBD8sm8wZoHRzrSkX2GJatlScYlBRDWFPdlbrTXRVVliSLyp3/1GlEp5VbiHcmdAV0
         J92p0Zks4xl1v+ePHv37Dycrd74ikMXEzm5PhLnsVNubBV2C5FLFYeUXvhxfrB8cehb/
         P/KiNEaMIkM93KmDTb1uvaBSPGmHowI8vnbvPj9yAZGixm31SYQJHSJUpgPCAkHzadYB
         Cj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715637642; x=1716242442;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/T2vV+rwgF2ttDJrQAVcBOgx0bc8+qmSjEhPHlAqsDI=;
        b=Q1Id6+9s2v0YQZbXXRv77476lPE7YYIEoFl5c/Kxu1RUZHU7LtJH3Yvxo8705URFP4
         4i/QZciccfnNuuU2Zf8NBnaKJ87oZdoLdBFjlR7oQHiC2MhjulPJ92d63zQpFANs7WE9
         xoQbbGxogF2Dq8mUk95Vv/KsW9KJfD3wJ6HZNvGb4mSG6rHM9T0w5cpvGmWyNW6UnUt3
         x/nBxfUcv5UjjtmoPIv1vh/uq91HzokfwJOSPf3aiup8pwn5ij+UNpKMH4JoXYTC5vFo
         rOdnPgU3gABdDEg+yIAhBJCrCZ49dN1Z+RyUGAU+jNN3N5EsaSskfEk12UwNM+oNS2vW
         mQrw==
X-Gm-Message-State: AOJu0Yzlm10SdSOcIk42nB6Azx/MxT8I1JeEUDzfVphTKV88YsvcK9Tx
	qLfjdjl1/v+E2R3AlNlyRhRqZBls4ph0jSLlFytzQmNKpkaUEvBYtmmUIetUfEVNSQ2no7G+agu
	iyqbtRS/7aoYuYuLTBCVksvFT99sAgUxVYhL9pNpRnBn9MBiTRwy7xZ+9JRw8RRij15EDEt932L
	fBVgC7YsYIT/DvYlWvLkqaq5doeJPywp3zxxDjgzY=
X-Google-Smtp-Source: AGHT+IE5tgOPVM4jcW261QssoXZ60dxQ8zE//eA+jbbhlQ5Kkb1xymISVL9mv0kDXbuqSOC8pb+xYfH4mQ==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:aa7:c0ce:0:b0:573:6e6:df32 with SMTP id
 4fb4d7f45d1cf-5734d43e8d4mr13603a12.0.1715637641949; Mon, 13 May 2024
 15:00:41 -0700 (PDT)
Date: Mon, 13 May 2024 22:00:33 +0000
In-Reply-To: <20240513220033.2874981-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240513220033.2874981-1-aojea@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240513220033.2874981-3-aojea@google.com>
Subject: [PATCH v3 2/2] selftests: net: netfilter: nft_queue.sh: sctp checksum
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

