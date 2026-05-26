Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B37372B3C
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809852; cv=none; b=i0D5BUIacDL/g4uvmIT/lmExKycmTE9XeFNB+ov1Mb3VRNFCFm/qU7QMO9o0C/+Wi7RZm0b48WlcFw1zTX+QFTMJLeEXIElf6s2o00dJCjnL82fZ0jd/QCr/AxaUJKtzzzoji4VYjYcqLdsP3hbIKC99QOmBuhVQJQ/wiJ8ufuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809852; c=relaxed/simple;
	bh=1pjlie0SZbihJhm/H8HkIsvHkQvq7UuDSVIPyjk1gqw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OLp1U9/eIZ3fUy5GHXVhyaNVqjk/dYGioKRzu+Id3yc7evJSu6DBdnbcZFI5gY0OgSm+9tD9FBp15zta6c77e1gtqsR4X43LlSOoyk44S7xv9yAN3Un3hcTmTOFlj35aLBDxyw51/eKxylrn/CeGTbYnZbY7Z8L7xRjzCfDyz8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JCgoEo7f; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JCgoEo7f"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490426d72f7so40950475e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 08:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779809848; x=1780414648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkEuidHNkvKdjtXgm8w9hW6ayaG6am8ME4nrnhrHgGE=;
        b=JCgoEo7fmOBJJrk4I08STeSSOCw8yULmuVpmee4m69MUguLLooGYmVAhFhXsW31J+c
         12VgaW9aI1JDzQSJ8Mfx2ACf5K8uu+o0tlzzxmIJvItTFZy0f+jrjqFDMJXfGTznndDq
         mcPf+944MN6aADnXT8R9itMN+elmef5l6L4ikK2/35aBeaPciXuNvQNSFQuA/Jb+fkrj
         i9OLm+M+fQA9eq+HrKJyYSshYCv3bfbwlLAUR6UMPnUGzICpe4OqeCE6YHPebB6ZS9Be
         ma/iNIrT9a4f31bixOx1WFA1YrcxACmxLFtbqnJ9WZGcb0xnkVUuys3o9uWDuvBSmwuE
         GFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779809848; x=1780414648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qkEuidHNkvKdjtXgm8w9hW6ayaG6am8ME4nrnhrHgGE=;
        b=YJN+det/PYgX992EnudOUQBeJICPpGjhFHVnqPRkEZRWv55ZH9ek513T5mKCwqShEb
         UsotHtVcHM/vpVOTEy0YkvyNRZOqb0bI594Wc4vGm/GqGsMWb9NX2Rc/jPfeWSEc75+E
         TFn1ReWGHkyvYLUjpQ/LnPlImbJYnH73VmiIOWJSmArFesgvbBWLDVCrHhNGAphPcOYI
         rnR3fdopOUR8JYIgGtiTk5PxH7/EmX74filB/+4/nWy68u6ZrUVD+mMTkNieQQiz9737
         5hwuQN6gjNLip33N9VI9/IGNdlC7zeKMZWBppmCjIvN9IdKVYE+G+CEU7C2ooZhe26v7
         20Pg==
X-Forwarded-Encrypted: i=1; AFNElJ/xjfJhxosdS3mYyDZKJWfML4f/VR41j9XTeotIviZgawmsKixFKiQ/LIjb3x9bdCjsEc/Vzk5mBnyVo/8pK2o=@vger.kernel.org
X-Gm-Message-State: AOJu0YyatmKfGRSovEYJ2PGtO7Ay9KwrBW9dMzcVRdJXr7uP7CsuZn1E
	xjCvtA2VJ/SG8br6Qotk3Vpqn+wXM032NZjc13ZOk7R1fDXagAb2gzpz
X-Gm-Gg: Acq92OG9s30rWuCulfbGSgF+GFITU+gB6LT/zXYozHkEya7eeE/W1Hdde7kmUIF+kIC
	pt1Js4UlrptOJfLrIUHh9mknDF1FTV82puZIqzhU7fB8XHvZfAafGlj18Tz5FJWsyx4P6DeakMv
	oiwfFcsfyKHQ7yFOrszJxu/GTFoMfWXdtqWhtLAQqK2Bmy8A6RXKphaBpTS8qFLupitBkRcOIp0
	4kFR0ySJ3o98BMxlJDiD6df/LmUOThQ3dfcbC7jgIejroGXP5fEeW3AQgQCCcK79FBwqK439+pI
	1FRtKA9/YfQyGJ1VWjuc/zsZ5pWQfYc0WY8I0DrhUsz0EL9U3/jzksNi1BMpmEtUwB6AIla0oXi
	E0vBsbmisIyfitgy5sBz+eubO6KCil7seIiGtgXWuXtLTxpIY5iLIqDfFvbJd/pcbXfgdcVUKln
	H0tddXDN5B1Mauy8bE4iTUvWoueCs=
X-Received: by 2002:a05:600c:4ecc:b0:48a:557e:6b4f with SMTP id 5b1f17b1804b1-490426d2805mr289728565e9.23.1779809848372;
        Tue, 26 May 2026 08:37:28 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4907df9edeasm1083655e9.9.2026.05.26.08.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:37:28 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 5/7] selftests/bpf: add bpf_icmp_send kfunc cgroup_skb IPv6 tests
Date: Tue, 26 May 2026 15:37:06 +0000
Message-Id: <20260526153708.279717-6-mahe.tardy@gmail.com>
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
index 0dc6b6ceafb4..1d6900d6a8f8 100644
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
@@ -79,14 +94,15 @@ static void read_icmp_errqueue(int sockfd, int expected_code)
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
-	if (!ASSERT_GE(srv_fd, 0, "start_server"))
+	srv_fd = start_server(af, SOCK_STREAM, ip, 0, TIMEOUT_MS);
+	if (!ASSERT_OK_FD(srv_fd, "start_server"))
 		return;

 	if (getsockname(srv_fd, (struct sockaddr *)&addr, &len)) {
@@ -94,6 +110,8 @@ static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
 		return;
 	}
 	skel->bss->server_port = ntohs(addr.sin_port);
+	skel->bss->unreach_type = (af == AF_INET) ? ICMP_DEST_UNREACH :
+						    ICMPV6_DEST_UNREACH;
 	skel->bss->unreach_code = code;

 	client_fd = connect_to_fd_nonblock(srv_fd);
@@ -103,13 +121,33 @@ static void trigger_prog_read_icmp_errqueue(struct icmp_send *skel, int code)
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
+		/* The TCP stack reacts differently when asking for
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
@@ -128,20 +166,11 @@ void test_icmp_send_unreach_cgroup(void)
 	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
 		goto cleanup;

-	for (int code = 0; code <= NR_ICMP_UNREACH; code++) {
-		/* The TCP stack reacts differently when asking for
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

