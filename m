Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF3E413229
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107345; cv=none; b=BZhvScvkO3jaXXsAtrCqCbD6ieg+uf8rXTl3OPTvRAV1iHgpjLgevtDSd7lhY719LwExv8ZfEom02ZmE1qJ7RiaPdXs4/HwsRm1EhiT3S+J2UEHVsFRxG/0WE/EDgg5zzhT1yP+DcAWFh0ITscBvi9mX9r0hYKXhbhK6j+w91P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107345; c=relaxed/simple;
	bh=eJhmadjCcpjQAr9bsOjNYrpNs8J18d9cXveySIGVjgk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=if3dErjzG4EC1HkzKIiEM13OqCZNdolcQSzV4kM7u7QmlVet7bWOsHINRVSYUAj4hFShA/svGCKDgFERlw/n0UI6gTOEyAjVxXNKDpuk3JidspVmmNaOmvCxVBJP25tWdAfYZRAIZHsF2EcastWnhK1S4GND1Bhn4B1Q+CDA5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iz/Fkk51; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iz/Fkk51"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a14c31eeso13207655e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 05:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779107341; x=1779712141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=casa8DWjIOa9cP+i+8hwt/ggHd+PKlO9cEQzmI4OQZE=;
        b=Iz/Fkk51wmkaiDKzRRVhHgFHf5FnEU5Co8eHab+e2ZrQCeXZLmkciVF/n56mVNaGsn
         pTJJnOQJ0FNnqgmBm11j02pHmG9Zyo6BcdJENJrjYgEG5oAsm85D3budxsU8JAQK9jsq
         N5rFjoVxdyyUInfPnITOzPJ0e7RgVhm/SnsZU9NJwSZtrBQuohnnmNjS1SIlYrf1OSgJ
         LQ0Ac3JQe10lv4spTPjSRjUEYTr6QcMC4LW8ppt1jXwzdQUrMcE8JTNsHPwYf3Ptj9OO
         WaUjd69K+5yoCyHI94X7JZHy703pFpG8qag7YiaO6ibva6FzC+OBg0gRnmADAK2z+wgc
         cLqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107341; x=1779712141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=casa8DWjIOa9cP+i+8hwt/ggHd+PKlO9cEQzmI4OQZE=;
        b=IM4Yw4RsV/L6/sHFxDl8ADH8wFNE/lrubySMjeo4qh60qdjfrA3Wet38dZUw01PQGR
         KG7J2m/dstqnj8stM/kH/O5Zc++q9PNy1T8/DUW2Oi7/VPyst/Ux6N+58P1GBj/2R5Wj
         3diIMzjEFKfLQ1R4QP0+sFD6yiRA2lgTNUT/xHWx4r74vus5hLpfwo0HzrpYsQTD6BAg
         DlKuP+LEsJ2qK9w7vt27FNqAu8qx9OAwDnusxQDXn88eQepw0xsJgcFJ9ij4s6S1+TtO
         R0zpgavS1gP1YmzEKcV1XyQaH3NUU4bdnvFaKsBPcCFhF43oNN+N6DGo3ymZ1D70G83S
         y5LQ==
X-Forwarded-Encrypted: i=1; AFNElJ+19tKH6vJ1giZ2ZU8vtubFbuOtGG55GT/WO1gROo5K07jeN+sDujdnqWmDSsnABeoiRzSBwK+kOs6bZCldGbM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwowE4kYXKS6KG8c7jW+oFIAZZRl8Lt+ngfIPmLPG9H9ulLn0Ny
	YUMUrGBw/EV/GveBm00vNDSDPL9HBHwqUqCNcGaOxDqJMvsLEmpUK7VM
X-Gm-Gg: Acq92OFgbjnq7edD/+hoMf1QabiJd+rBM58m/Iu02SUOL5fuYlqvz9LlUVK9s39pr48
	62gqJFeIsreb6t1z2+2Q2oYYA3fMLSFCBsDL4Bf2PLo4d1Mo9N+QuoF1+kmK2O7rAz3nSJY5gy/
	CpJJLKghbdkLR+8Fm6vtoks1cAhubCjTKEe1+6tL58lKwK+xpFBbKYOEBnw2aKXF6hh/OUcDueo
	g9LXyMnHpzVEBLLJJgNyTAQQ/cffoegcIjx9PqGcFhAkHgPg8H6QwYCe3v431bRb7AsLZ34YA3Y
	vTFUknpmnOPQoG7gdj6TCCuTPpj0yBS0wj3TLUTBeGrONOyNqz3vj6d+eNDHfhX+f+96+j6y+Ie
	ZO6KRAAhOlhrQcqXj/Ly3/ioADu5D+VxRHQO50/F9CJxLeX0h+Xx54hpaZf0U9V9lJVSbPYl6aP
	UpoQnyourZ5zc1JekGzRFk5WBlFk8=
X-Received: by 2002:a05:600d:10:b0:489:e696:8362 with SMTP id 5b1f17b1804b1-48fe60d7882mr187662735e9.13.1779107341004;
        Mon, 18 May 2026 05:29:01 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48ff2cb4ae0sm104304315e9.0.2026.05.18.05.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:29:00 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: bpf@vger.kernel.org
Cc: martin.lau@linux.dev,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	ast@kernel.org,
	andrii@kernel.org,
	yonghong.song@linux.dev,
	jordan@jrife.io,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Mahe Tardy <mahe.tardy@gmail.com>
Subject: [PATCH bpf-next v6 6/6] selftests/bpf: add bpf_icmp_send recursion test
Date: Mon, 18 May 2026 12:28:42 +0000
Message-Id: <20260518122842.218522-7-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260518122842.218522-1-mahe.tardy@gmail.com>
References: <20260518122842.218522-1-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test is similar to test_icmp_send_unreach but checks that, in case
of recursion, meaning that the BPF program calling the kfunc was
re-triggered by the icmp_send done by the kfunc, the kfunc will stop
early and return -EBUSY.

The test attaches to the root cgroup to ensure the ICMP packet generated
by the kfunc re-triggers the BPF program. Since it's attached only for
this recursion test, it should not disrupt the whole network.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_kfunc.c          | 40 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c | 31 ++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
index d0ac0502f6df..a9e9806877cf 100644
--- a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <cgroup_helpers.h>
 #include <linux/errqueue.h>
 #include <poll.h>
 #include "icmp_send.skel.h"
@@ -10,6 +11,7 @@
 #define ICMP_DEST_UNREACH 3
 #define ICMPV6_DEST_UNREACH 1

+#define ICMP_HOST_UNREACH 1
 #define ICMP_FRAG_NEEDED 4
 #define NR_ICMP_UNREACH 15
 #define ICMPV6_REJECT_ROUTE 6
@@ -176,3 +178,41 @@ void test_icmp_send_unreach(void)
 	icmp_send__destroy(skel);
 	close(cgroup_fd);
 }
+
+void test_icmp_send_unreach_recursion(void)
+{
+	struct icmp_send *skel;
+	int cgroup_fd = -1;
+
+	skel = icmp_send__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		goto cleanup;
+
+	if (setup_cgroup_environment()) {
+		fprintf(stderr, "Failed to setup cgroup environment\n");
+		goto cleanup;
+	}
+
+	cgroup_fd = get_root_cgroup();
+	if (!ASSERT_GE(cgroup_fd, 0, "get_root_cgroup"))
+		goto cleanup;
+
+	skel->links.recursion =
+		bpf_program__attach_cgroup(skel->progs.recursion, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.recursion, "prog_attach_cgroup"))
+		goto cleanup;
+
+	trigger_prog_read_icmp_errqueue(skel, ICMP_HOST_UNREACH, AF_INET, "127.0.0.1");
+
+	/* Because there's recursion involved, the first call will return at
+	 * index 1 since it will return the second, and the second call will
+	 * return at index 0 since it will return the first.
+	 */
+	ASSERT_EQ(skel->data->rec_kfunc_rets[0], -EBUSY, "kfunc_rets[0]");
+	ASSERT_EQ(skel->data->rec_kfunc_rets[1], 0, "kfunc_rets[1]");
+
+cleanup:
+	cleanup_cgroup_environment();
+	icmp_send__destroy(skel);
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testing/selftests/bpf/progs/icmp_send.c
index 6e1ba539eeb0..7830334b747a 100644
--- a/tools/testing/selftests/bpf/progs/icmp_send.c
+++ b/tools/testing/selftests/bpf/progs/icmp_send.c
@@ -13,6 +13,9 @@ int unreach_type = 0;
 int unreach_code = 0;
 int kfunc_ret = -1;

+unsigned int rec_count = 0;
+int rec_kfunc_rets[] = { -1, -1 };
+
 SEC("cgroup_skb/egress")
 int egress(struct __sk_buff *skb)
 {
@@ -65,4 +68,32 @@ int egress(struct __sk_buff *skb)
 	return SK_DROP;
 }

+SEC("cgroup_skb/egress")
+int recursion(struct __sk_buff *skb)
+{
+	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(long)skb->data_end;
+	struct iphdr *iph;
+	int ret;
+
+	iph = data;
+	if ((void *)(iph + 1) > data_end || iph->version != 4)
+		return SK_PASS;
+
+	/* This call will provoke a recursion: the ICMP packet generated by the
+	 * kfunc will re-trigger this program since we are in the root cgroup in
+	 * which the kernel ICMP socket belongs. However when re-entering the
+	 * kfunc, it should return EBUSY.
+	 */
+	ret = bpf_icmp_send(skb, unreach_type, unreach_code);
+	rec_kfunc_rets[rec_count & 1] = ret;
+	__sync_fetch_and_add(&rec_count, 1);
+
+	/* Let the first ICMP error message pass */
+	if (iph->protocol == IPPROTO_ICMP)
+		return SK_PASS;
+
+	return SK_DROP;
+}
+
 char LICENSE[] SEC("license") = "Dual BSD/GPL";
--
2.34.1

