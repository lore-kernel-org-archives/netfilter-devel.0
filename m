Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FC33A5E7A
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129934; cv=none; b=aJ15+bKa1LnFFwaieR85+tWxt3S45+6vLaAmD/+/xpPcHnEUSVadzMGxbhGey72opete+v0AjCgGVzd6fuoDg4j8ak1tqvpOKFrSIUuR0Eh7pbLvxISCld13pM5bruVr3DHTuFH2oeL2zctkBLVbrV/Ma3CUxqU0+P6R+6HZHJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129934; c=relaxed/simple;
	bh=GR+hNBotIRD8OyHm1Y3S2xaK8PG5YrIfPRcAlRJJC3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=m4EimqInday9ZS0k7eDatjY9LT1SjCFbhd9zLKuE4K1igami/zwxbas8uCcpZ208ORMhook5h6hi8Xph9gMZ6J03UGGfM23jmlsU8dFWptTiEIkAEgqvz8g6Z/no4oWdGqWb0eibOxj6Z8fUxGxdkulwxEtrwDXnGb+MFt2i8Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4yJe89n; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4yJe89n"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4923139e940so25049775e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129931; x=1782734731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCxVsG98MajhYc/5IXUymCkjA4HPnYVhI9+5R57v1+w=;
        b=b4yJe89n9fKoB7GB9ZcVDePCJhshScT8WgS9ccMhc1kQ1BdtAi9VLga6xsfoDwZ0PX
         LWAomt2E72QQXztLbKDrM3MSOakJdr+GLUPmVXqVq2q0hoB8h5vx8JErLZ15std4J0Xp
         UKqTuqzNxjmq4FPe3P3D8jQjYozR/rCkCyhshV6x3ue1JBLeO8UWT9G5FN5PpQ5U20gN
         Rknj7w7rAa72Mz92063n6aop77Kn6HUexy4NLuxn9Uar8IlrS/rXkIdq9cfRptUr/x+U
         lNS3aLWpf/3FULOEzYuYUgngG9ZxhZlfKtL8MFk+xe4fFtyLPiOOyw1CmH6qo70HM70y
         68Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129931; x=1782734731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dCxVsG98MajhYc/5IXUymCkjA4HPnYVhI9+5R57v1+w=;
        b=n3Bz4ANPLMPNGUPQm/qTtTcEfW1qwXINHnDtjAMosHAyZczh2qdLaIumd2Rd8U/mut
         5DLwaZO6RR09LhCzvk3YCjustrB6S7OxS3+XOS5gck8Y6lz4YdJ/QgUx8kG2Oz1aDFQx
         tcxueO8WDRE36xI5SWnJ4LvCBXzd8tETVLmCqh7HSTAWH7esY8txX19dK1uWM+4uNiaT
         kWIGmIN/My3YaxiGwh9siUYZfUqvYbyAGGJ4CpqvpCPbtjSkQbFXhwBH1IFn7YwUtZZb
         sNBWZ49bPH9Zeth218rQJq9R8YM+9X97Wll1X7SU7n/aNWPJkxVIHmn5nkJPMJY4zDHm
         ADPw==
X-Forwarded-Encrypted: i=1; AFNElJ9EsR0hFLaave6qllb103ht5FPRwrE7lqcR/7Sj8tSwgATFYfeWfNm6LJxfPKp/oz9LaCesqio+UmixFsDiQsI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0+yIKQF7Xdr0f+jTp+0hnOLJtTdsa2Q9la5zvgLNkvQNfIMJo
	4gtfwk/7odRY7BSNyvn6e6QzlLIiwotKuD8BjWKJlgK4TOrB4m/3NqoAGzJcrZYe
X-Gm-Gg: AfdE7cn1t+QjMRyas2RLMVHtOAyHRRCtJOZzJGAOWPmU1fvswth8oEr+J6G4LW8lIqv
	SmMVOkNuX9vUg+Z8jbWMpz8ru+KpMNqfolEutIP3TEykYJNrf+ZpGlUDDGS4PkBd8tix5eNcZK4
	O65ZPIcxquyryMvzgoP37oSmn8vaDqGMdyG0aOE5XvScKZuDiXF0mH/t6OEL4l855012dpKi5vG
	DG3VhBm+b7zWQ/guM8+Ug+CWSgGkQnzYdVU57VrwQdMy2uYX9+bOFRsy3e2dkopkYg6up7RUQEW
	0MoLeFv/QfBYu3GGEf6C+dK7+ey9KUnqSPcY4D8utPtamdqEM5f8NAFWb0mTY2ZgNGRzPkhpOIR
	qig3jP/brlVeo69Xc935W8INTdZ+vzlok6MevxvOWHRbgKpRp01lTIttavsLD1I/3HUVQ5c5rl7
	I2jilCSdh5rD74bzF6Hy2MXwyUKJQ=
X-Received: by 2002:a05:600c:3e15:b0:492:30f2:963a with SMTP id 5b1f17b1804b1-49242189520mr202307105e9.0.1782129930673;
        Mon, 22 Jun 2026 05:05:30 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 5/7] selftests/bpf: add bpf_icmp_send kfunc cgroup_skb IPv6 tests
Date: Mon, 22 Jun 2026 12:05:13 +0000
Message-Id: <20260622120515.137082-6-mahe.tardy@gmail.com>
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

This test extends the existing cgroup_skb tests with IPv6 support.

Note that we need to set IPV6_RECVERR on the socket for IPv6 in
connect_to_fd_nonblock otherwise the error will be ignored even if we
are in the middle of the TCP handshake. See in
net/ipv6/datagram.c:ipv6_icmp_error for more details.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_kfunc.c          | 77 +++++++++++++------
 tools/testing/selftests/bpf/progs/icmp_send.c | 48 +++++++++---
 2 files changed, 92 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
index f4e5b883d4c8..a5ac1a6ea77a 100644
--- a/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
@@ -8,15 +8,17 @@
 #define TIMEOUT_MS 1000

 #define ICMP_DEST_UNREACH 3
+#define ICMPV6_DEST_UNREACH 1

 #define ICMP_FRAG_NEEDED 4
 #define NR_ICMP_UNREACH 15
+#define ICMPV6_REJECT_ROUTE 6

 static int connect_to_fd_nonblock(int server_fd)
 {
 	struct sockaddr_storage addr;
 	socklen_t len = sizeof(addr);
-	int fd, err;
+	int fd, err, on = 1;

 	if (getsockname(server_fd, (struct sockaddr *)&addr, &len))
 		return -1;
@@ -25,6 +27,12 @@ static int connect_to_fd_nonblock(int server_fd)
 	if (fd < 0)
 		return -1;

+	if (addr.ss_family == AF_INET6 &&
+	    setsockopt(fd, IPPROTO_IPV6, IPV6_RECVERR, &on, sizeof(on)) < 0) {
+		close(fd);
+		return -1;
+	}
+
 	err = connect(fd, (struct sockaddr *)&addr, len);
 	if (err < 0 && errno != EINPROGRESS) {
 		close(fd);
@@ -34,8 +42,14 @@ static int connect_to_fd_nonblock(int server_fd)
 	return fd;
 }

-static void read_icmp_errqueue(int sockfd, int expected_code)
+static void read_icmp_errqueue(int sockfd, int expected_code, int af)
 {
+	int expected_ee_type = (af == AF_INET) ? ICMP_DEST_UNREACH :
+						 ICMPV6_DEST_UNREACH;
+	int expected_origin = (af == AF_INET) ? SO_EE_ORIGIN_ICMP :
+						SO_EE_ORIGIN_ICMP6;
+	int expected_level = (af == AF_INET) ? IPPROTO_IP : IPPROTO_IPV6;
+	int expected_type = (af == AF_INET) ? IP_RECVERR : IPV6_RECVERR;
 	struct sock_extended_err *sock_err;
 	char ctrl_buf[512];
 	struct msghdr msg = {
@@ -61,15 +75,16 @@ static void read_icmp_errqueue(int sockfd, int expected_code)
 		return;

 	for (; cm; cm = CMSG_NXTHDR(&msg, cm)) {
-		if (cm->cmsg_level != IPPROTO_IP || cm->cmsg_type != IP_RECVERR)
+		if (cm->cmsg_level != expected_level ||
+		    cm->cmsg_type != expected_type)
 			continue;

 		sock_err = (struct sock_extended_err *)CMSG_DATA(cm);

-		if (!ASSERT_EQ(sock_err->ee_origin, SO_EE_ORIGIN_ICMP,
-			       "sock_err_origin_icmp"))
+		if (!ASSERT_EQ(sock_err->ee_origin, expected_origin,
+			       "sock_err_origin"))
 			return;
-		if (!ASSERT_EQ(sock_err->ee_type, ICMP_DEST_UNREACH,
+		if (!ASSERT_EQ(sock_err->ee_type, expected_ee_type,
 			       "sock_err_type_dest_unreach"))
 			return;
 		ASSERT_EQ(sock_err->ee_code, expected_code, "sock_err_code");
@@ -79,13 +94,14 @@ static void read_icmp_errqueue(int sockfd, int expected_code)
 	ASSERT_FAIL("no IP_RECVERR/IPV6_RECVERR control message found");
 }

-static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
+static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code,
+					    int af, const char *ip)
 {
 	int srv_fd = -1, client_fd = -1;
 	struct sockaddr_in addr;
 	socklen_t len = sizeof(addr);

-	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", 0, TIMEOUT_MS);
+	srv_fd = start_server(af, SOCK_STREAM, ip, 0, TIMEOUT_MS);
 	if (!ASSERT_OK_FD(srv_fd, "start_server"))
 		return;

@@ -94,6 +110,8 @@ static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
 		return;
 	}
 	skel->bss->server_port = ntohs(addr.sin_port);
+	skel->bss->unreach_type = (af == AF_INET) ? ICMP_DEST_UNREACH :
+						    ICMPV6_DEST_UNREACH;
 	skel->bss->unreach_code = code;

 	client_fd = connect_to_fd_nonblock(srv_fd);
@@ -103,13 +121,34 @@ static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
 	}

 	/* Skip reading ICMP error queue if code is invalid */
-	if (code >= 0 && code <= NR_ICMP_UNREACH)
-		read_icmp_errqueue(client_fd, code);
+	if (code >= 0 && ((af == AF_INET && code <= NR_ICMP_UNREACH) ||
+			  (af == AF_INET6 && code <= ICMPV6_REJECT_ROUTE)))
+		read_icmp_errqueue(client_fd, code, af);

 	close(client_fd);
 	close(srv_fd);
 }

+static void run_icmp_test(struct icmp_send *skel, int af, const char *ip,
+			  int max_code)
+{
+	for (int code = 0; code <= max_code; code++) {
+		/*
+		 * The TCP stack reacts differently when asking for
+		 * fragmentation, let's ignore it for now.
+		 */
+		if (af == AF_INET && code == ICMP_FRAG_NEEDED)
+			continue;
+
+		trigger_prog_read_icmp_errqueue(skel, code, af, ip);
+		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
+	}
+
+	/* Test an invalid code */
+	trigger_prog_read_icmp_errqueue(skel, -1, af, ip);
+	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
+}
+
 void test_icmp_send_unreach_cgroup(void)
 {
 	struct icmp_send *skel;
@@ -128,21 +167,11 @@ void test_icmp_send_unreach_cgroup(void)
 	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
 		goto cleanup;

-	for (int code = 0; code <= NR_ICMP_UNREACH; code++) {
-		/*
-		 * The TCP stack reacts differently when asking for
-		 * fragmentation, let's ignore it for now.
-		 */
-		if (code == ICMP_FRAG_NEEDED)
-			continue;
-
-		trigger_prog_read_icmp_errqueue(skel, code);
-		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
-	}
+	if (test__start_subtest("ipv4"))
+		run_icmp_test(skel, AF_INET, "127.0.0.1", NR_ICMP_UNREACH);

-	/* Test an invalid code */
-	trigger_prog_read_icmp_errqueue(skel, -1);
-	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
+	if (test__start_subtest("ipv6"))
+		run_icmp_test(skel, AF_INET6, "::1", ICMPV6_REJECT_ROUTE);

 cleanup:
 	icmp_send__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/icmp_send.c b/tools/testing/selftests/bpf/progs/icmp_send.c
index 6d0be0a9afe1..6e1ba539eeb0 100644
--- a/tools/testing/selftests/bpf/progs/icmp_send.c
+++ b/tools/testing/selftests/bpf/progs/icmp_send.c
@@ -5,10 +5,11 @@

 /* 127.0.0.1 in host byte order */
 #define SERVER_IP 0x7F000001
-
-#define ICMP_DEST_UNREACH 3
+/* ::1 in host byte order (last 32-bit word) */
+#define SERVER_IP6_LO 0x00000001

 __u16 server_port = 0;
+int unreach_type = 0;
 int unreach_code = 0;
 int kfunc_ret = -1;

@@ -18,19 +19,48 @@ int egress(struct __sk_buff *skb)
 	void *data = (void *)(long)skb->data;
 	void *data_end = (void *)(long)skb->data_end;
 	struct iphdr *iph;
+	struct ipv6hdr *ip6h;
 	struct tcphdr *tcph;
+	__u8 version;

-	iph = data;
-	if ((void *)(iph + 1) > data_end || iph->version != 4 ||
-	    iph->protocol != IPPROTO_TCP || iph->daddr != bpf_htonl(SERVER_IP))
+	if (data + 1 > data_end)
 		return SK_PASS;

-	tcph = (void *)iph + iph->ihl * 4;
-	if ((void *)(tcph + 1) > data_end ||
-	    tcph->dest != bpf_htons(server_port))
+	version = (*((__u8 *)data)) >> 4;
+
+	if (version == 4) {
+		iph = data;
+		if ((void *)(iph + 1) > data_end ||
+		    iph->protocol != IPPROTO_TCP ||
+		    iph->daddr != bpf_htonl(SERVER_IP))
+			return SK_PASS;
+
+		tcph = (void *)iph + iph->ihl * 4;
+		if ((void *)(tcph + 1) > data_end ||
+		    tcph->dest != bpf_htons(server_port))
+			return SK_PASS;
+
+	} else if (version == 6) {
+		ip6h = data;
+		if ((void *)(ip6h + 1) > data_end ||
+		    ip6h->nexthdr != IPPROTO_TCP)
+			return SK_PASS;
+
+		if (ip6h->daddr.in6_u.u6_addr32[0] != 0 ||
+		    ip6h->daddr.in6_u.u6_addr32[1] != 0 ||
+		    ip6h->daddr.in6_u.u6_addr32[2] != 0 ||
+		    ip6h->daddr.in6_u.u6_addr32[3] != bpf_htonl(SERVER_IP6_LO))
+			return SK_PASS;
+
+		tcph = (void *)(ip6h + 1);
+		if ((void *)(tcph + 1) > data_end ||
+		    tcph->dest != bpf_htons(server_port))
+			return SK_PASS;
+	} else {
 		return SK_PASS;
+	}

-	kfunc_ret = bpf_icmp_send(skb, ICMP_DEST_UNREACH, unreach_code);
+	kfunc_ret = bpf_icmp_send(skb, unreach_type, unreach_code);

 	return SK_DROP;
 }
--
2.34.1

