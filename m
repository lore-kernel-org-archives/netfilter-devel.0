Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2C7152502
	for <netfilter-devel@vger.kernel.org>; Fri,  3 May 2024 11:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714736150; cv=none; b=Pv8+Er2toOLTy794Dl57TdN2muFFZn5u9unPQL/Qu7FQkDORRyPPY5hvuNIgOVPWc+yZiJABL5SEXWqEGJnPJXaGb59hgo/s0OpRCuSFjFbXaTbcCJ4KCPnauSXB9lQojEEsRfkCiQQbLkWzYdgazq69FbOeJJFSB78nFET+ADE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714736150; c=relaxed/simple;
	bh=35Xa6yJROGX4ZmFGPeJ7rL1Nkv0RBvnW3P5O1kNn/Wo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P1lVtIIBrWmOFYL7P6RHSgwWIEGkTAJh7po6CHvCi6SXzRLaC1E4/yGRjs1PbBBybS5zP/EQD2cZWEvAJjUGzuKx8xj7ThvCepn3AlhUMpGNbfkPHjOf7EUmzie0fltYzlXtsm9VpZlZXAqskbuh6ATJmmGQIvQohwBwfGbvRVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GlvAqBfH; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aojea.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GlvAqBfH"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-572baf39435so1720325a12.1
        for <netfilter-devel@vger.kernel.org>; Fri, 03 May 2024 04:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714736147; x=1715340947; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJS0fh4sZybANlRmi6RKVi+YetAq4rKaKyK4u4wBgOU=;
        b=GlvAqBfH6XfiX64P+aylHFbpNT5LypR81xYmMQJZ28EE9rtSFa2pkic5K2bAIZJEnP
         E5EH+/fwpmlYByobPaYwKQ4HtgmoQ/Lytr3c+BM8ySxgvEMjLB/wObqsw8pZKvv6zGnG
         wXrblT8PHfPR4snN+q+Q9hqplKSsSf18erS3QGxLKQ55XlEi0Vmnd89MVf+p4oKyUeWZ
         kNCUpKsXby7WiCFaYh6sLcKC49yI4EoLn1zYik3FgnZf4PztQJJc7OvPKpxLXm4yHufh
         TqG039ItISz0ZNQAd+gZ8GL+OrM4brpWlLR1QllBQazv8j3U8e8XfR5E5uVuPsb4QHFc
         jmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714736147; x=1715340947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qJS0fh4sZybANlRmi6RKVi+YetAq4rKaKyK4u4wBgOU=;
        b=DEbo7h7kdE91AvyeofhZo6Njumug8HxuAjoWfM9AIYtKiru6G+PBizsyDUof9S/HN8
         86CnPG73jPwmJUzU8Jv+hJmUhGDaiqAZ7ADleLxgRoxQiiLkdMAFgb9SxEmQ4UIBrE/y
         iNnS8PQEPMdB284l2jyKL85+QSWGsiS/WUaz2n771NS8Ko6F9t1JgjLv1PqOHZOrtNUa
         Vg60xvPVh6BD9QG0lsZ+E784Kby3Yp4E4BhWYO1Ta/GXq+gRSoTORsGsV8wGvDTydtEu
         tiZbebRmfp4eO0wJmGueQiwT4plB8cHdYrObiopbvrls57Ir3Qwy2u9g59VaS4lk4Ev6
         WO4w==
X-Gm-Message-State: AOJu0YxsnPsccyWKmGqs5TEavwue1CzMzEaNaDs9RqtvH+mrOhtHyBx9
	Salu+M+vfH/BJdJRwFMvVInmVwWHwUZqbhjYNJ6K3FdEuq1wNncreLTtZ45IZczHamS0O6SEURR
	gud94zGbRBaCxON9tPlVRUaW9+aY2Wx3z+Y8FEL8NDcWoLPjIRtWOjttyIdYi4iB0g9YU8IzBpu
	IAEXT8GaDOvE1bwgt6iUU6CBpA5epNpr2PpxN4rq4=
X-Google-Smtp-Source: AGHT+IF8wQo/z3M6JGaPALhYfTW3EXwYM0ViosOdqmHTdPKXeOF6VjcKFEzZ9+4wyVHHG10XOJwRtU4Utw==
X-Received: from aojea.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:b3d])
 (user=aojea job=sendgmr) by 2002:a05:6402:1caf:b0:572:b0a8:65ff with SMTP id
 cz15-20020a0564021caf00b00572b0a865ffmr7009edb.1.1714736145216; Fri, 03 May
 2024 04:35:45 -0700 (PDT)
Date: Fri,  3 May 2024 11:34:55 +0000
In-Reply-To: <20240503113456.864063-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503113456.864063-1-aojea@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240503113456.864063-3-aojea@google.com>
Subject: [PATCH net-next 2/2] selftests: net: netfilter: nft_queue.sh: sctp checksum
From: Antonio Ojea <aojea@google.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org, willemb@google.com, edumazet@google.com, 
	Antonio Ojea <aojea@google.com>
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
2.45.0.rc1.225.g2a3ae87e7f-goog

