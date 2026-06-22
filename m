Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB423A48F7
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129933; cv=none; b=X4DgGzvfRG+bx1//IIcQfxsfx3uRUboGs7qu+V1yY2SfSezJoIRd/zhqWWWumeAmhsFFon1PJc3kCLyWlJdLDzo0EzbnJTO085hz0XPd3BXvWjVDp27DfJlGbx3EEVqTiQnCVdJcYjhvLX2XAiKi4DBOtHXGSFcwZgJMR1XxalA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129933; c=relaxed/simple;
	bh=RrJJ4kHJcfsWz4HTUjpAWR1W0IWNOk3Y+i/xKlPiZ0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N2mLtEvlGclMgIoK9Y/4eHtQ/39yTCgm0Sg0f/2sUB+9+fP6fnv1/ZaOLvrZ/bkQOY1fO4VbD4gm6QEiGPFhm8NA8O5GJXqoiLjePeiccujVpIfy3xrdPsiWcQiPJ8zyPgR/pY1Im4NssaHvwU7NzrLlPiaZWGDFtPLJmtHvB5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GCxFGob8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GCxFGob8"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490ac357c55so46978015e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129930; x=1782734730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j/hp2sXeZCYGc57fy2hG3nB2LTOljqofmY1Kj9NMJTo=;
        b=GCxFGob8iptogRmuayKJGgaPYbP3VV2csdx04zGf8rfu2Ix5d1zb9A38hq3caL/rIL
         baEC1dnbOQY3354V8vqe3vr3RfmI+ZfeblRaiZ4eWXGfXiTQedXqmWBL34M2T9SwBR7d
         gFhRI4kv2Xf2mmmxHTbLbdSgitysc2pG6r2hwRswEpr22HTwKdVZDbzrUVKOqj3Kr0VK
         /89lpQSDen8SDk9L/sN9rBMdxzGjqojFTu1Bygv+msoPaP7CcKyZpgXc7CBYCZcZyY2q
         Kbn8R3BIArKxW1CxdTObCFUnUJy63/Z5h9ug22oqwS8TrsEw+u6rK58iUGKc/u1sq1lM
         Vgyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129930; x=1782734730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j/hp2sXeZCYGc57fy2hG3nB2LTOljqofmY1Kj9NMJTo=;
        b=aukPnHIt+ZsZCCExGMPjf9hpxNB5u/7JDZnOf33/eyqb6z+1riL17eb6s6K77kXo3t
         +BRuLE7cUNaUxY2agU6brPHtboOoSAM3PMo6aQS3dBp3ovqk5oY/joutNi6SDXA5YqaA
         GrkpG2F8RFN8DitI8u/ZCQKr/dFk3oAj4/nKuvHc/EftM6pA/Bi5A4Ns8O+evUon/O7i
         gY+J6Fwsl6XLNNCWa5tuB0OiONliUtefOjDVDK4pRuYmjrlntvNx9akGQ0HpaTLDoD0e
         RPyAeBBrmP9W5tmGTDmkSq3ZOTHv42O0jRoCsUsvbIY9ZBw0x6EoqiGm0bVtRz36Iu1a
         VG7w==
X-Forwarded-Encrypted: i=1; AFNElJ/7HDDblcrnXLRhqGBY3K+WZ8N/RgMeG9gWoDUOBjcaMEwftsC2HE7oeibHxXZELK/n6q8qXzFNv8/LitW1/Bo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhQ8WPOSwyM5jJsqMwnG+loro/G0x7ZQUfslCKnsPama2VSCC5
	4muKU3WduwZn7AZutElz01Wsk3BFQDSzpUKEKVT7B81r9P+tpOfZzAvD
X-Gm-Gg: AfdE7cmqrK8EgAF87n9uBesg9pdT2VkKMl1YvARt5DjeGdMiR1nofJbYyv2SyMHPLUZ
	ETYJVwOr+iMvr6yc8Ec+D0d4wrsUB4AgWVSA5MbB/wnShtWBebJMVnYwfxbn1LceI5YCsZgXzEV
	ufxkjE3QjzH/WBmtCFbKAhEmhzGV94kVR9xARyyGs/KslL63cQwCk41GDiy8O6J5c8F41NiuZZh
	dAT49BOQmS+1WMJyw5kunrk46s3c0oLtXc9uPLVnMskWMNArZfZwjwcwtboT+Phat9Aupv/8994
	BVYqP8WYUsxKzvb3vzRbAl5iyFkYZ+ApEYeeWSRSD4ryORDTuy0IfXaWndMmVxxOdcan+KtGt0T
	N21I6ikiJ1ppaj6h5MxdT4DA/bofIxX7xWJf+JzJ4CcOCdDTHbRD59lDG4wvsiukvdIdTlHSnvO
	c/lRrVf1x4zKDHUsOI
X-Received: by 2002:a05:600c:5493:b0:492:1ea2:6258 with SMTP id 5b1f17b1804b1-49240e7b049mr218698195e9.33.1782129930119;
        Mon, 22 Jun 2026 05:05:30 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4923fc47720sm491083105e9.0.2026.06.22.05.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 05:05:29 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 4/7] selftests/bpf: add bpf_icmp_send kfunc cgroup_skb tests
Date: Mon, 22 Jun 2026 12:05:12 +0000
Message-Id: <20260622120515.137082-5-mahe.tardy@gmail.com>
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

This test opens a server and client, enters a new cgroup, attach a
cgroup_skb program on egress and calls the bpf_icmp_send function from
the client egress so that an ICMP unreach control message is sent back
to the client. It then fetches the message from the error queue to
confirm the correct ICMP unreach code has been sent.

Note that, for the client, we have to connect in non-blocking mode to
let the test execute faster. Otherwise, we need to wait for the TCP
three-way handshake to timeout in the kernel before reading the errno.

Also note that we don't set IP_RECVERR on the socket in
connect_to_fd_nonblock since the error will be transferred anyway in our
test because the connection is rejected at the beginning of the TCP
handshake. See in net/ipv4/tcp_ipv4.c:tcp_v4_err for more details.

Reviewed-by: Jordan Rife <jordan@jrife.io>
Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_kfunc.c          | 151 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c |  38 +++++
 2 files changed, 189 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
new file mode 100644
index 000000000000..f4e5b883d4c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <linux/errqueue.h>
+#include <poll.h>
+#include "icmp_send.skel.h"
+
+#define TIMEOUT_MS 1000
+
+#define ICMP_DEST_UNREACH 3
+
+#define ICMP_FRAG_NEEDED 4
+#define NR_ICMP_UNREACH 15
+
+static int connect_to_fd_nonblock(int server_fd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int fd, err;
+
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &len))
+		return -1;
+
+	fd = socket(addr.ss_family, SOCK_STREAM | SOCK_NONBLOCK, 0);
+	if (fd < 0)
+		return -1;
+
+	err = connect(fd, (struct sockaddr *)&addr, len);
+	if (err < 0 && errno != EINPROGRESS) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static void read_icmp_errqueue(int sockfd, int expected_code)
+{
+	struct sock_extended_err *sock_err;
+	char ctrl_buf[512];
+	struct msghdr msg = {
+		.msg_control = ctrl_buf,
+		.msg_controllen = sizeof(ctrl_buf),
+	};
+	struct pollfd pfd = {
+		.fd = sockfd,
+		.events = POLLERR,
+	};
+	struct cmsghdr *cm;
+	ssize_t n;
+
+	if (!ASSERT_GE(poll(&pfd, 1, TIMEOUT_MS), 1, "poll_errqueue"))
+		return;
+
+	n = recvmsg(sockfd, &msg, MSG_ERRQUEUE);
+	if (!ASSERT_GE(n, 0, "recvmsg_errqueue"))
+		return;
+
+	cm = CMSG_FIRSTHDR(&msg);
+	if (!ASSERT_NEQ(cm, NULL, "cm_firsthdr_null"))
+		return;
+
+	for (; cm; cm = CMSG_NXTHDR(&msg, cm)) {
+		if (cm->cmsg_level != IPPROTO_IP || cm->cmsg_type != IP_RECVERR)
+			continue;
+
+		sock_err = (struct sock_extended_err *)CMSG_DATA(cm);
+
+		if (!ASSERT_EQ(sock_err->ee_origin, SO_EE_ORIGIN_ICMP,
+			       "sock_err_origin_icmp"))
+			return;
+		if (!ASSERT_EQ(sock_err->ee_type, ICMP_DEST_UNREACH,
+			       "sock_err_type_dest_unreach"))
+			return;
+		ASSERT_EQ(sock_err->ee_code, expected_code, "sock_err_code");
+		return;
+	}
+
+	ASSERT_FAIL("no IP_RECVERR/IPV6_RECVERR control message found");
+}
+
+static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
+{
+	int srv_fd = -1, client_fd = -1;
+	struct sockaddr_in addr;
+	socklen_t len = sizeof(addr);
+
+	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0, TIMEOUT_MS);
+	if (!ASSERT_OK_FD(srv_fd, "start_server"))
+		return;
+
+	if (getsockname(srv_fd, (struct sockaddr *)&addr, &len)) {
+		close(srv_fd);
+		return;
+	}
+	skel->bss->server_port = ntohs(addr.sin_port);
+	skel->bss->unreach_code = code;
+
+	client_fd = connect_to_fd_nonblock(srv_fd);
+	if (!ASSERT_OK_FD(client_fd, "client_connect_nonblock")) {
+		close(srv_fd);
+		return;
+	}
+
+	/* Skip reading ICMP error queue if code is invalid */
+	if (code >= 0 && code <= NR_ICMP_UNREACH)
+		read_icmp_errqueue(client_fd, code);
+
+	close(client_fd);
+	close(srv_fd);
+}
+
+void test_icmp_send_unreach_cgroup(void)
+{
+	struct icmp_send *skel;
+	int cgroup_fd = -1;
+
+	skel = icmp_send__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		goto cleanup;
+
+	cgroup_fd = test__join_cgroup("/icmp_send_unreach_cgroup");
+	if (!ASSERT_OK_FD(cgroup_fd, "join_cgroup"))
+		goto cleanup;
+
+	skel->links.egress =
+		bpf_program__attach_cgroup(skel->progs.egress, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
+		goto cleanup;
+
+	for (int code = 0; code <= NR_ICMP_UNREACH; code++) {
+		/*
+		 * The TCP stack reacts differently when asking for
+		 * fragmentation, let's ignore it for now.
+		 */
+		if (code == ICMP_FRAG_NEEDED)
+			continue;
+
+		trigger_prog_read_icmp_errqueue(skel, code);
+		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
+	}
+
+	/* Test an invalid code */
+	trigger_prog_read_icmp_errqueue(skel, -1);
+	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
+
+cleanup:
+	icmp_send__destroy(skel);
+	if (cgroup_fd >= 0)
+		close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testing/selftests/bpf/progs/icmp_send.c
new file mode 100644
index 000000000000..6d0be0a9afe1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/icmp_send.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+/* 127.0.0.1 in host byte order */
+#define SERVER_IP 0x7F000001
+
+#define ICMP_DEST_UNREACH 3
+
+__u16 server_port = 0;
+int unreach_code = 0;
+int kfunc_ret = -1;
+
+SEC("cgroup_skb/egress")
+int egress(struct __sk_buff *skb)
+{
+	void *data = (void *)(long)skb->data;
+	void *data_end = (void *)(long)skb->data_end;
+	struct iphdr *iph;
+	struct tcphdr *tcph;
+
+	iph = data;
+	if ((void *)(iph + 1) > data_end || iph->version != 4 ||
+	    iph->protocol != IPPROTO_TCP || iph->daddr != bpf_htonl(SERVER_IP))
+		return SK_PASS;
+
+	tcph = (void *)iph + iph->ihl * 4;
+	if ((void *)(tcph + 1) > data_end ||
+	    tcph->dest != bpf_htons(server_port))
+		return SK_PASS;
+
+	kfunc_ret = bpf_icmp_send(skb, ICMP_DEST_UNREACH, unreach_code);
+
+	return SK_DROP;
+}
+
+char LICENSE[] SEC("license") = "Dual BSD/GPL";
--
2.34.1

