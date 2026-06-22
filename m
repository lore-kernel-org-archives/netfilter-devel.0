Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228993A6EF1
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129936; cv=none; b=g/e++bvAPRwd9+Yj8AEDta5utj4h3yOByC6V87KPc1T7/6uD6l2McsvXGfGAJqGP+ZSKjEJ3jOHdVVlQysM+8+uc3d/+4ppzab5B7BRoF/iqWnTojSo0qJt/eqWQn9YzQpdTUMh6u8OjHDclbPSc5i5w6X7zWh3VdvadJS29C0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129936; c=relaxed/simple;
	bh=+XXLsYvzWy3Cx1K/Ya+/rF2zKVvfqM7an5l9XdeQbKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dq3J5As5lxGlsJjf3Rc8A6EnHAQwqBE4DB71OCDIoxL58vpMSCNeth8z7qu43/x+XX3Et61BnD3lj88xBeAsdp7Rycu4dE/s7T1GCmvYXhuaVZgylxdZkbWiaJqeOV3PwROHq2I21NrVZXLgqeKR3O/5t1dgFTOkfqwJMmlkJIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EFZvxq8V; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EFZvxq8V"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-46a0741a09bso115013f8f.0
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129932; x=1782734732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nlnP1BOraaXzt3q027zNJ40vl15H69zIaffK3Fv5n80=;
        b=EFZvxq8V0slF1A9+9wfeZnie7mlUwVT0eHLwPKzOtdYtaTBnQTcHGdpxqP4/feSU/y
         QSmuBBaT+4/hVEKTeMuBAUCBqNbNTvKoVycksAjScX0ZA+IK9NKTiuWeBuFkX59UTjQZ
         RfJv2+VSxkHRSF3VFpHpaRF3p/mvu31UZsGJULn5RocozCh025GS36JetlM2ja8arEPy
         hKxNfnz9EY85KhpVNOoFV7q75Rzc94qpqNEcFpnTzaEOP4pxXsAl+cn0n6N/JEOGl2OG
         upRMjxALwU+5qNGTHcPvNQQJiH/KgZrSrxZEE5LuvWUfB3Yq7yb629uUwnC+GKy5WRv6
         U0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129932; x=1782734732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nlnP1BOraaXzt3q027zNJ40vl15H69zIaffK3Fv5n80=;
        b=EiB+G+0/Ut6cCgR5ZynOqgeepNRQgaJDJqOuGpKqL8GlX3OBGSOOI4UjTK8aWCWBzf
         l9ADHLk0atwJb7C0ivxyDQbmS/4vbdWHs6qaPnTnkDhbG7MgmCNbMsrPxFvX8tO7YR2s
         K7Ct+RUP0CoT+YruSSSv9YFdqhiEz31jcMGe9wbXpyU4uxIJVc+nBOGq4fX8Ux9AQXo4
         9Sce4vAtjtcqaBEI6TSeYuMPVi+j4OiNba/B7miZQBn7WFq7QUEmWyQwXhFkQyR5pPba
         S6wGeMAC8FaM/zNX/9TFqaZBsWNqqJYD/SDlWTJz+tpA/69PaOT0oFRX8XA6KvXZcH1j
         sOhA==
X-Forwarded-Encrypted: i=1; AFNElJ+gsnyzEVM1Bt+ASahWye4zkcMhAikdMjMH68846GXKNgHt1xcVU839mokhJKumwSloPq3/ALBks0QbNfD2JXs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbwLaAXOhAwn7iQUV8bZFM+zB3Zge2l6nYrKDIiMGf/iYHj8n2
	imlP3o2Qjk8VLFMxrKAyhr7oNJVC6O9cl+36qb9sMU7TzN99BR2X1tWr
X-Gm-Gg: AfdE7clJKjF+IOxbCObFPPzgMwE9M/R38s0jsHJ9UgnXNAmMLxbMqCbR6bSXhhCVGVB
	Al5YCsa8brtBY+PEj7H891H3mzufR5VvcEYsSrnRbHa9jlJbzAePfV00cfwhbn6sXzwaAkbJSzr
	ZTHfH83DECJXBzGWFyoYVcFwHjN2nFji6qts3YnG9HWspD5NW8yUYUhN+V8MPW2GNIrntVcpLQ9
	+DWNH3vKsaXEDRmNHS2EKA5Pc7bRwlvMdRPS06yYO8i++b+nipGdFoBke7DxdahNozPENJgiz0m
	HZA49uNV7tYr4GJ+PyRk5Hfl50TxgeJSggXaJz4jrwIbW5F71/iZEGxMTgL8Yf0Gudwue+7DkeT
	LzL5mehiU9lgfu8Liw++HUs/q4x2/pAAdgjyi7Uv54RU0FgrOWtqiGdLqnGcK5VwyBql9oEcD7G
	py9fvDOoS7it+J0rjpQjhxqfxaVVM=
X-Received: by 2002:a05:600c:3b99:b0:490:e5c1:b897 with SMTP id 5b1f17b1804b1-49242572367mr225762215e9.20.1782129931181;
        Mon, 22 Jun 2026 05:05:31 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4923fc47720sm491083105e9.0.2026.06.22.05.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 05:05:30 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bpf@vger.kernel.org
Cc: andrii@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	edumazet@google.com,
	john.fastabend@gmail.com,
	jordan@jrife.io,
	kuba@kernel.org,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	yonghong.song@linux.dev,
	Mahe Tardy <mahe.tardy@gmail.com>
Subject: [PATCH bpf-next v8 6/7] selftests/bpf: add bpf_icmp_send kfunc tc tests
Date: Mon, 22 Jun 2026 12:05:14 +0000
Message-Id: <20260622120515.137082-7-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260622120515.137082-1-mahe.tardy@gmail.com>
References: <20260622120515.137082-1-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test is similar to the one with cgroup_skb programs but uses tc
egress instead.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_kfunc.c          | 25 ++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c | 60 +++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
index a5ac1a6ea77a..66447681f72d 100644
--- a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -178,3 +178,28 @@ void test_icmp_send_unreach_cgroup(void)
 	if (cgroup_fd >= 0)
 		close(cgroup_fd);
 }
+
+void test_icmp_send_unreach_tc(void)
+{
+	LIBBPF_OPTS(bpf_tcx_opts, opts);
+	struct icmp_send *skel;
+	struct bpf_link *link = NULL;
+
+	skel = icmp_send__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		goto cleanup;
+
+	link = bpf_program__attach_tcx(skel->progs.tc_egress, 1, &opts);
+	if (!ASSERT_OK_PTR(link, "prog_attach"))
+		goto cleanup;
+
+	if (test__start_subtest("ipv4"))
+		run_icmp_test(skel, AF_INET, "127.0.0.1", NR_ICMP_UNREACH);
+
+	if (test__start_subtest("ipv6"))
+		run_icmp_test(skel, AF_INET6, "::1", ICMPV6_REJECT_ROUTE);
+
+cleanup:
+	bpf_link__destroy(link);
+	icmp_send__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testing/selftests/bpf/progs/icmp_send.c
index 6e1ba539eeb0..5fa5467bdb70 100644
--- a/tools/testing/selftests/bpf/progs/icmp_send.c
+++ b/tools/testing/selftests/bpf/progs/icmp_send.c
@@ -2,6 +2,7 @@
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
+#include "bpf_tracing_net.h"

 /* 127.0.0.1 in host byte order */
 #define SERVER_IP 0x7F000001
@@ -65,4 +66,63 @@ int egress(struct __sk_buff *skb)
 	return SK_DROP;
 }

+SEC("tc/egress")
+int tc_egress(struct __sk_buff *skb)
+{
+	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(long)skb->data_end;
+	struct ethhdr *eth;
+	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
+	struct tcphdr *tcph;
+
+	eth = data;
+	if ((void *)(eth + 1) > data_end)
+		return TCX_PASS;
+
+	if (eth->h_proto == bpf_htons(ETH_P_IP)) {
+		iph = (void *)(eth + 1);
+		if ((void *)(iph + 1) > data_end)
+			return TCX_PASS;
+
+		if (iph->protocol != IPPROTO_TCP ||
+		    iph->daddr != bpf_htonl(SERVER_IP))
+			return TCX_PASS;
+
+		tcph = (void *)iph + iph->ihl * 4;
+		if ((void *)(tcph + 1) > data_end)
+			return TCX_PASS;
+
+		if (tcph->dest != bpf_htons(server_port))
+			return TCX_PASS;
+
+	} else if (eth->h_proto == bpf_htons(ETH_P_IPV6)) {
+		ip6h = (void *)(eth + 1);
+		if ((void *)(ip6h + 1) > data_end)
+			return TCX_PASS;
+
+		if (ip6h->nexthdr != IPPROTO_TCP)
+			return TCX_PASS;
+
+		if (ip6h->daddr.in6_u.u6_addr32[0] != 0 ||
+		    ip6h->daddr.in6_u.u6_addr32[1] != 0 ||
+		    ip6h->daddr.in6_u.u6_addr32[2] != 0 ||
+		    ip6h->daddr.in6_u.u6_addr32[3] != bpf_htonl(SERVER_IP6_LO))
+			return TCX_PASS;
+
+		tcph = (void *)(ip6h + 1);
+		if ((void *)(tcph + 1) > data_end)
+			return TCX_PASS;
+
+		if (tcph->dest != bpf_htons(server_port))
+			return TCX_PASS;
+	} else {
+		return TCX_PASS;
+	}
+
+	kfunc_ret = bpf_icmp_send(skb, unreach_type, unreach_code);
+
+	return TCX_DROP;
+}
+
 char LICENSE[] SEC("license") = "Dual BSD/GPL";
--
2.34.1

