Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A2D3A718D
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129936; cv=none; b=PNxhULE+p0NyA6xebEAvWZ8X8RbJqchDuXiny1NEb5OzmnVmF9Mwv7s1eICbr/TWW+dKbPiKm5HQ+wYC5iksT1w21kSmeI0o2e9kBi9DLEd3A42ZGids9s2C1m/yyYGzqCo1/fyL3zJJDTlHNqGRGRTEuKOA8p7jia4ZfyYFeBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129936; c=relaxed/simple;
	bh=FSu+9Chj/hcZezEUNZ+dzmNr6VQvZNHYm4N7dCJ9j0M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UiLB9eMVtZLtiryrInRPjlxu3RQrtZUhltUgorgRtxSYXgUJW+y7vkTe6ORBOnIXJqQyDGRfxeLJa8ajcaDrPIOIyXVmjHgmQwesmJ4QSW7R6SL0KvYYcirsQKRXrCfO1YVPEwg1d3Rtbd4BAceYeYg8Tx3ttCoyMGn9tcR8+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mz01lDt6; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mz01lDt6"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so34895715e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129932; x=1782734732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9dtTYNSsQzYV2D9YSeH0gzpjO5SaNSVg9AhxuiVH7ko=;
        b=mz01lDt63PmYh3Z0h2D3XNU+cxdl1WJ3yzjJ/QeqJNxDvnFo7ZVrNKkBkjY9UqGot6
         P2eMPB4ANHA8xtZYO/5IyLI++nl8pgQv5iJS3OaXpTerUaXnDMYtVDUVPF15i1gZLMZ0
         1yr8kRn02fyjVAwvU9qKmz7/7GucBMR5W81IXcnfyxiczJVEUAUy0rCw+PEyCAiVQjAM
         hX9cbXDokWihQr0auMlni8PjrrwWtOIGuOOy0sfJmFHQ08Nd7iI4h7SZTRCd307DEJJj
         K3mMbNmqLr1613tuCi2X7S17RX85BJe05oEunGOweKDQ8zWFEn2fUjzSsHOIkmtnmTnK
         1OJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129932; x=1782734732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9dtTYNSsQzYV2D9YSeH0gzpjO5SaNSVg9AhxuiVH7ko=;
        b=LDvzCkgRo43KwoHebVC1qk61plm9zYUbCIHxA31KvIXd5sr/L9r4pJXzfYU4ozvy4F
         DJO5U2DUl4YchgWjTH8W0OfMeDmVpUkdKlwMl9wxhrphj/jWZfyCF6XazGw8EvnBnxd6
         2xSvIULMkDM4wq+1T/3xEjmb2i0lvT6iS042z/Qgg73zjOsn+lyG1bvecJF/CRjExCSn
         Yz+UHG6gCoDsePb+0LCevq5Iyv5lQJYc7z/3Jri2mhJCtb2Rph/gfY1LAwWZDihpEgMo
         qx3JVEXfb2/9F/eEl+oFEKv90CbRtFPfg7GBrVH0jvKchxf+baCD3dMCrS0L5FH6lVcD
         Js2Q==
X-Forwarded-Encrypted: i=1; AFNElJ8LM4MU/QVhG1ZXvE1/4aFHfjscKrukg2ofPh33fBhrGB2ImhdbHYg0Y8nr4Lsjb9/l3/K+YkghxpLe72xqV/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVUrAtAR802+pDQRUXXTz8mNtZvvsGXV8NFDEZbh8UrhAcSLBB
	InTOdeNzLJCq30aQ/qTBx68SFLFnwBTUjAScV/bt4JkgINZIZY6EV1Yb
X-Gm-Gg: AfdE7clbzpviP98OVKqy2U04QvqKVPzUhwDmYzYwT6fI/JlLJAr50g0j2YACp9qptof
	yoMN+7En51Q//u6rM89qpwCDh7TT2QisdWuFchXez4UgpLqyMjVmv5VOPAcNYltj6a4ZqDrcjQF
	dq5s6jwT8z7qzF8FPxcdcgNaks6XbJaHnncX8tPD/6VfN+G/fB0ElseFHvjXEIfUPG2Hfe8MZJT
	8610DgphAGdO5rauHDvPJ5T3MXvrcP5mw6+4LLMLVSOf2ZB9wdOehznQS7oWL1uKGzjg0/vgRXc
	0yRDS73HiaJ1OkuxvPstdP7oKsTZASODL/FYoixTxGkwGmLo2pn0ChKSb/m4RHwDgu6FYJN3Dr9
	TDUyqWw83mPHZFaG99E6M8ULgURzuysGOFFMegQVV31CGc/pRZSgf0wV9IbKK9jJ491jELBKn7g
	iH7Qt6WLbY/hqH7T/B
X-Received: by 2002:a05:600c:820e:b0:490:d354:d151 with SMTP id 5b1f17b1804b1-49242571659mr190714355e9.18.1782129931744;
        Mon, 22 Jun 2026 05:05:31 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4923fc47720sm491083105e9.0.2026.06.22.05.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 05:05:31 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 7/7] selftests/bpf: add bpf_icmp_send recursion test
Date: Mon, 22 Jun 2026 12:05:15 +0000
Message-Id: <20260622120515.137082-8-mahe.tardy@gmail.com>
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

This test is similar to test_icmp_send_unreach_cgroup but checks that,
in case of recursion, meaning that the BPF program calling the kfunc was
re-triggered by the icmp_send done by the kfunc, the kfunc will stop
early and return -EBUSY.

The test attaches to the root cgroup to ensure the ICMP packet generated
by the kfunc re-triggers the BPF program. Since it's attached only for
this recursion test, it should not disrupt the whole network.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_kfunc.c          | 45 +++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c | 56 +++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
index 66447681f72d..fd4b8fa78a01 100644
--- a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -1,8 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <cgroup_helpers.h>
 #include <linux/errqueue.h>
 #include <poll.h>
+#include <unistd.h>
 #include "icmp_send.skel.h"

 #define TIMEOUT_MS 1000
@@ -10,6 +12,7 @@
 #define ICMP_DEST_UNREACH 3
 #define ICMPV6_DEST_UNREACH 1

+#define ICMP_HOST_UNREACH 1
 #define ICMP_FRAG_NEEDED 4
 #define NR_ICMP_UNREACH 15
 #define ICMPV6_REJECT_ROUTE 6
@@ -203,3 +206,45 @@ void test_icmp_send_unreach_tc(void)
 	bpf_link__destroy(link);
 	icmp_send__destroy(skel);
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
+	if (!ASSERT_OK_FD(cgroup_fd, "get_root_cgroup"))
+		goto cleanup;
+
+	skel->data->target_pid = getpid();
+	skel->links.recursion =
+		bpf_program__attach_cgroup(skel->progs.recursion, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.recursion, "prog_attach_cgroup"))
+		goto cleanup;
+
+	trigger_prog_read_icmp_errqueue(skel, ICMP_HOST_UNREACH, AF_INET,
+					"127.0.0.1");
+
+	/*
+	 * Because there's recursion involved, the first call will return at
+	 * index 1 since it will return the second, and the second call will
+	 * return at index 0 since it will return the first.
+	 */
+	ASSERT_EQ(skel->data->rec_kfunc_rets[0], -EBUSY, "kfunc_rets[0]");
+	ASSERT_EQ(skel->data->rec_kfunc_rets[1], 0, "kfunc_rets[1]");
+
+cleanup:
+	cleanup_cgroup_environment();
+	icmp_send__destroy(skel);
+	if (cgroup_fd >= 0)
+		close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testing/selftests/bpf/progs/icmp_send.c
index 5fa5467bdb70..fd9c7684797b 100644
--- a/tools/testing/selftests/bpf/progs/icmp_send.c
+++ b/tools/testing/selftests/bpf/progs/icmp_send.c
@@ -13,6 +13,10 @@ __u16 server_port = 0;
 int unreach_type = 0;
 int unreach_code = 0;
 int kfunc_ret = -1;
+int target_pid = -1;
+
+unsigned int rec_count = 0;
+int rec_kfunc_rets[] = { -1, -1 };

 SEC("cgroup_skb/egress")
 int egress(struct __sk_buff *skb)
@@ -125,4 +129,56 @@ int tc_egress(struct __sk_buff *skb)
 	return TCX_DROP;
 }

+SEC("cgroup_skb/egress")
+int recursion(struct __sk_buff *skb)
+{
+	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(long)skb->data_end;
+	struct icmphdr *icmph;
+	struct tcphdr *tcph;
+	struct iphdr *iph;
+	int ret;
+
+	if ((bpf_get_current_pid_tgid() >> 32) != target_pid)
+		return SK_PASS;
+
+	iph = data;
+	if ((void *)(iph + 1) > data_end || iph->version != 4)
+		return SK_PASS;
+
+	if (iph->daddr != bpf_htonl(SERVER_IP))
+		return SK_PASS;
+
+	if (iph->protocol == IPPROTO_TCP) {
+		tcph = (void *)iph + iph->ihl * 4;
+		if ((void *)(tcph + 1) > data_end ||
+		    tcph->dest != bpf_htons(server_port))
+			return SK_PASS;
+	} else if (iph->protocol == IPPROTO_ICMP) {
+		icmph = (void *)iph + iph->ihl * 4;
+		if ((void *)(icmph + 1) > data_end ||
+		    icmph->type != unreach_type ||
+		    icmph->code != unreach_code)
+			return SK_PASS;
+	} else {
+		return SK_PASS;
+	}
+
+	/*
+	 * This call will provoke a recursion: the ICMP packet generated by the
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

