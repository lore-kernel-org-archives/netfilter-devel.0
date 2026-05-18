Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923E240C5D1
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 12:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107344; cv=none; b=odAz1OiwoimKvzZhKnnYa1EsYixzwp07RuCgqafZpZhIszAIaH5sLXGc1k6hVMu9DTsyi6Elp0aLNeKhtCRsUFstHdJ6fegfW1Yt+M4KYFPJXbykvN7+C7qQaItcJ51+N0TVUgW2x1S0cnQSG1X4kk1rhPDvKTdkifiT0ZNsmbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107344; c=relaxed/simple;
	bh=jrVFuuG8SF/rQAdamiUNeU+8eIOc8vK+0Wqb9g0Eptw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ao6gn86UtqzDsk70wl/7yYy2tLjR0Hw9tZCrME/ezOyKuHP1ZQ+AOMRmBQ8ocyCjb/3oMbFICtvl2GClUB4hSSqu0hm6yxIs/AybTucO5jhWzX2HF2BNP4m9gv8f2UUDTIKKavrMlmSvU/CVheOZqNi2RC5WMU8SaxMCifC7pcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OQ0IRFvN; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OQ0IRFvN"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so33371015e9.2
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 05:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779107340; x=1779712140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xd5eOaA87Ail6o+X5N+eEZ9pfYo6rHCbdHtnpHKZOoo=;
        b=OQ0IRFvNSNk+ehqcTCL7OIPqkPcl+1ahPzgdTKC2FQz1YfnYTpOjVegAXastokW6nB
         5ZlRSRw4D89NE4q+kQSCXlMNC/r+pL4xNpAweRTSVKHNk19oe5gMHBprj8m649BtKVeT
         ww1Ts53I+JWoVWiQGPiwnbLLMIC7jyzeSRBFkzq4si3FCcH3el4nQG2/nh2RYpj0A/aV
         E/Rq/kwGRgc18auhijjrnNsiB3cxoNAVeHJ79oqw3mUZmhWm6Aydxh6vUj60W67ch9R3
         0Yj/aSwuVyCpM5tLFO8w/q1F7a5pDR7gZE5NiaxsOkcN8l0EMns7LCWX3Ugqw2UkXPFu
         2xBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107340; x=1779712140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xd5eOaA87Ail6o+X5N+eEZ9pfYo6rHCbdHtnpHKZOoo=;
        b=YpxFIjh5RtGAYPRPBTpUgQ5bCqO4Xp0UTmpxYJIuCgTm8UP5942LnAuahKxqZdvh9z
         cKCTRyLjU+WSYiAL0J2ejRVrCxpCb0UXayeTpvLZ3ZBpPVaYFaleFdOfaMXaOuDe46rn
         3KZmD83Hoyf5f6KKyRp3zZ2C8RSkY0+7hdIs70pJCJQRAGScXZ1eihBax6XcALq4x7wX
         YiiC/mq7kealdiq7FzCdu5tDHHyPdPMaTNYizvLq/XQabtaCve5XmuTh2MvLgM9TS/xv
         K9KZh7dL47WqHAUbADa9YY/EGh7wsfndDc2qAWVYT+Irl6BilIE4jysCvXvxHdCKXsdb
         WprQ==
X-Forwarded-Encrypted: i=1; AFNElJ9mI/BNFh8Nf+6Wwuc0psfJYhP9olCv6ZfvYq/ZFack19nqYebB9w1bqR8DK1kj2cp9LbK70ftk29aNcQQUteE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtSCsMVwedeqgL0iv/lbGxRcWmRG8EN8X9ctAwUpm9uoVaBXJk
	6d1b0RchN4h3g0sk1lSNw/UCpvwZOizcfXkOYHYnuLv2avtGwFhxFaYS
X-Gm-Gg: Acq92OEOAbX0y1x8ZOHHtRIMp2evS43ZZ1hbTAhWg30PpFG/yqGsRo2YqKCYC84APw1
	CIivLy69jtRPE6LixFwvXpyPI9F68bHTSacRr2IKncdNsN7vVM5382toVLg64+baeDh2aU2BqEp
	qjxdvgF5LiGpuzJhdb5/g2kTFRqIA+C83G2Eonc/aw/+JeI91a+CBA4ECrXXnzz6x6K3dYxfB7g
	6Hg3fs+xGdG164vajTXE/Lx1K6IYMJ2f/+Ss4X4o6Kt2UT6PlITDo73gsFL/7aniy5pb6eupB4A
	t4R4OtgfWwV8ZRSyQfBDZylH87CWSCNTtIhA8iMPOrGoMn30zbXsMNVDbBDv3lbSIPDG80lA0rx
	WB0nYpYbJteNdegRct+Ykwg69UVgcGkuvhgknV/hvfwstJkL6OL+e9I5CWpGGZut9HNBGh9ihaS
	qNlX02hL81KejVDs+ppdKxXIYAYPo=
X-Received: by 2002:a05:600c:c494:b0:485:4388:3492 with SMTP id 5b1f17b1804b1-48fe60ed839mr219662285e9.11.1779107339872;
        Mon, 18 May 2026 05:28:59 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48ff2cb4ae0sm104304315e9.0.2026.05.18.05.28.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:28:59 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 4/6] selftests/bpf: add bpf_icmp_send kfunc tests
Date: Mon, 18 May 2026 12:28:40 +0000
Message-Id: <20260518122842.218522-5-mahe.tardy@gmail.com>
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
 .../bpf/prog_tests/icmp_send_kfunc.c          | 152 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c |  38 +++++
 2 files changed, 190 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
new file mode 100644
index 000000000000..4f0aed8152d3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -0,0 +1,152 @@
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
+	ssize_t n;
+	struct sock_extended_err *sock_err;
+	struct cmsghdr *cm;
+	char ctrl_buf[512];
+	struct msghdr msg = {
+		.msg_control = ctrl_buf,
+		.msg_controllen = sizeof(ctrl_buf),
+	};
+	struct pollfd pfd = {
+		.fd = sockfd,
+		.events = POLLERR,
+	};
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
+		if (cm->cmsg_level != IPPROTO_IP ||
+		    cm->cmsg_type != IP_RECVERR)
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
+static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel,
+					    int code)
+{
+	int srv_fd = -1, client_fd = -1;
+	struct sockaddr_in addr;
+	socklen_t len = sizeof(addr);
+
+	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0,
+			      TIMEOUT_MS);
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
+	if (!ASSERT_GE(client_fd, 0, "client_connect_nonblock")) {
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
+void test_icmp_send_unreach(void)
+{
+	struct icmp_send *skel;
+	int cgroup_fd = -1;
+
+	skel = icmp_send__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		goto cleanup;
+
+	cgroup_fd = test__join_cgroup("/icmp_send_unreach_cgroup");
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
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

