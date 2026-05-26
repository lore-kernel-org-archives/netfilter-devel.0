Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772BE371876
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809851; cv=none; b=qenryVcUvLgind7GoIIGexToW/EaQR20gAEOSByeh/TERRWIf5xArIDaFbfuFia1lTe58G2HSA065kc3s3bc5B0qQizCylF7BSYu5OQxXGErqkgj6OnpnW0MX106NeafyoRAuCXdhRpHrTw4ohDF+xP+5oeR7fvjvC2gnbpsQ+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809851; c=relaxed/simple;
	bh=tFSCz4AtOWLINQcetZrgZrnT8qXTOIBuX10I4aJXDJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rlpvM9nHdPO1Xb7rhOzKSSqAj4UeiG/eflyB3GXYQUVd+sQMPx6ESODtl8TI1j8FnH5XMtowiCfYuJeD4oe4y710lChhYy1L4jqDqDvrgOJ8tPmG6NRsxcXDUZpOfsgR2v861YQnqX1fVYJGTPDgWFmAdZaMJ5Xh2tSzjTNAvSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lR7UJVar; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lR7UJVar"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso43382895e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 08:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779809848; x=1780414648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqDxx5bm9W2Cm/9azO7dcZrLz7ZHWyv0ykRFZ7iztUI=;
        b=lR7UJVarvCgRQvz7aZfOTnK4kltJgBwtd4kE+znSALaFBRuIJekNLkubhS7Y6YA1Qw
         NZlmdkzdw0m9ZsPEYYWfd5RCa9L3FQ/rEpCE7+4aSI6KnyPP6VcaZ/QY8fngX17sS1Pm
         WvaDQc4JBF7Qsptp6O0ok1e+HW2Px/lxKvJPaKRKG5vKyGXEk8eMkqhydC+dVUPdLFDA
         bABqtWElF8ZO4gE9e/4uw2AKY4kDEI05oqNmq+2TKpboQ18OVBKGy+hXPtfeTpJhgejw
         iwc7oIv1xva+iXDr4iQD4EoaeGxa36LaPQNpsKTSGWYUia2hCc62PTNi2MK8nBWybgTd
         7U9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779809848; x=1780414648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sqDxx5bm9W2Cm/9azO7dcZrLz7ZHWyv0ykRFZ7iztUI=;
        b=roxhH2VSnHXU3aujU4mfe+WZInnbUgDimykkZG6cqGOS9L743kLpfUExhtJA0Ge3xO
         8hK5c+zy863+ya+OPxo88pb37NFiq25tjzHL2pp632re7qsZgOxLcB8WJSHRVUzZf+Uv
         DGzBWcqjM5cqHq0RNZYeew5tfboIeIGovcxgijoJs8hL4KsVZoClt1cbBoVh9Mb5gyKz
         ohWcVKpVGgw294iBkZBp6ccAaatVVYlA/Z0yi4tLWLuX6m220LDL/vkRwjOC5uNLbTNc
         TO2w2a2lfSzIxHv0f4pdE8UPK1KrcHq+qcg6qPMeqgbsUd56R0PPN6mYgyioKsiAqvMZ
         ysxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+qCk+t49L+eb7n/GmINoF5WBiGTzlALHhmVDG0sDBorcuhmdsWIsw2waa39SUpm9OTCLZr62TUUjNKihzhOrE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyjFXQz/Po7goC8EREx02C6KbPTJZxbHatuMtUVpEsWA2BU3Kj6
	BmOzzxuXcknCks8BGqZKZ1rh1Ct9mp3V1SM8UacYPhslqUhhOA/336yU
X-Gm-Gg: Acq92OHCL1RVO90+sf8NONHWUnXUro29Lnp8kuZeWIvPDruM3PdG6DDfMNuVQz7rEBf
	7HOgnqXRzda3d4XPBC4Fb+oKNuFdQ29WETOKgx9lV5TB5X3EtxQ/PxPknLFgmvNN2CSWMpSbEb5
	TRvQUyxIjJfTZH+2A0nYnbdSby0kRZ7/xYSgmqUimsoiJLrtDf/PLE4yEGNp8OPFRoU46M3ECSo
	9oshH6gW1LJWAHqKCGLbkUWHeyCKW9jmuqszz3iXaviYMq1DRk5ERCd54n9B1OW0phXRmUcvFHS
	CZ9B4S7QFhfX0zNnVqnUdEC9v9yILI3V/bTpsPeCyVEgRUIaLYmHkGtK241Bon/QjIq1G2JLj30
	1ds1pcBLzzTz39h+dQbYYfaY0ckN65sWHjX7+Ny9J9rY+b+1KGXI2Snl6DWqwz05XupYtWaH/e3
	MBTP6jMBsAyni2VESKLGxkM4tOTc4=
X-Received: by 2002:a05:600c:818e:b0:490:58f4:ba23 with SMTP id 5b1f17b1804b1-4905c60ef29mr185853355e9.30.1779809847812;
        Tue, 26 May 2026 08:37:27 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4907df9edeasm1083655e9.9.2026.05.26.08.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:37:27 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 4/7] selftests/bpf: add bpf_icmp_send kfunc cgroup_skb tests
Date: Tue, 26 May 2026 15:37:05 +0000
Message-Id: <20260526153708.279717-5-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526153708.279717-1-mahe.tardy@gmail.com>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
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

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_kfunc.c          | 149 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c |  38 +++++
 2 files changed, 187 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
new file mode 100644
index 000000000000..0dc6b6ceafb4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -0,0 +1,149 @@
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
+	if (!ASSERT_GE(srv_fd, 0, "start_server"))
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
+		/* The TCP stack reacts differently when asking for
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
+	close(cgroup_fd);
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

