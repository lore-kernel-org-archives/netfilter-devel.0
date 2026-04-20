Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CF639C017
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 10:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776682717; cv=none; b=WI5fdpagQp6ttEVTbOMUxf0MUQKsiPYB65/8jVk4BkjxID882Lsy0A+t84j2jHaLgHe0pYnxkRPNdnp7T/PfknVBp9/NSsh1BtD8YoG9jnySA1Az2yVZlPieFKsOBhbw2qnB6vp107F3RzZJyCC9FFuQ9xUcpyFe2RghwyuVNqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776682717; c=relaxed/simple;
	bh=Fh6CaK0fZ1D4tkPanUSklUgF2rVts3ajN/VQbFpxIVo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eWDhvzR3r++hPqGhtg3OYEtQZUXed0gQZ11jqZWYSeuqQy5ib+qJKFP/Rx0YTAj8Tqnz/mxN6b/qmWFl3Krr7qNpTBzfM3PbA8c40BKOwquvrczZ9dHjBLUWPrttKNdJAMkrvAMpaCSaA51VrW+JozLCzolynemkPCCtT8pYF98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bFMEIcKf; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bFMEIcKf"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso28785005e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 03:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776682713; x=1777287513; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twOlZoOTygDkYCis+uEjGUkEKcF5nE7RCevCUCi1CAg=;
        b=bFMEIcKfEFDFYKHh5fcs7LMKJ4yUAEOOjzb7mIXfMGjt1iHw4woR/cln8dgwN0sVTf
         BeqwihBOqinUj2u59ntDp4VIig4yPbc+EVxD/SRfexx2x8Xf2OHRCpdt+al0P3HCwfP7
         YEA8K+pYFhLHl/wD5j5x7Ax5GyDPNQkK27AhFx2xA5gGs+GMD5o0Da7ZSJ5cl3pDjmtp
         J1rF29/8OV7Eg9A/mTOnRJzINVSpS2nBPyYGqoVFzococAHoMFS9vBs5c+RGajJtSbyC
         3DCuH0OM1McFfOL4BrSSD9b7/k8za3s1PELQRx1bdHfrQbI6uXzq9jnuNGfbED4aOiTG
         jzxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776682713; x=1777287513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=twOlZoOTygDkYCis+uEjGUkEKcF5nE7RCevCUCi1CAg=;
        b=hVFfK11YFNFumMckrlmzTqUZa2QcN3As3Dm1zozYkLBrGImwshAlgU4AOpvnmvEMQw
         CpR3IVwxvpvi09h13xT0qxSryCcIyJnoLjUllsufHzyfkfmqjpsfN6hv1/RJN1Ag/YOI
         VFQhC8ogFYTAvSuVndxE1mLH1w7bzw58RcVj63W+DoyRone0ZaIusPoqg95TBUxgqGW4
         xdOi/MDpag+8c+mcDJ2DL0wUqXiKDWuM+N4j8XF5mteXks6SXwS82M0Uukry8efH9E30
         jO4DWuElM5VuB2IrewQDCeLsQ/yc3gRwpj2vBctY9EKZtf5coYd/7wtMHn6Kp4I72U57
         scxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+cfMiNHIkL314qyrwCl1k9GUGgvPWdH9I9mFKw8EXmD1Cw5LvTTHZjTw7hyx4d7ZcDsSotSS4/x1z11Coc/Ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCC0tLce70jr5j3xBw+dHh8/FmjnSW3zYz12SZ4XNJGFWC4gAx
	oXa9rP775MG7VTHZGsgtgOwmBLJAOZ6N9orjjqMMQCgyIEUgURyLpbWQ
X-Gm-Gg: AeBDievHCff0/GaEwxwizBmBbfOY9tLGsM0KKoioYllpttOIHR7uIG5fNYo5XRFLf0d
	Lt+FVJZYsstD/dRaBqy9Ma78BcHVHhk/QlKdM12E9oVANdU7fRBMBWVtakE9pv35128tVMNEo4X
	5iV7PTsILhyd+Wh+6OHC1Qh5frlEViMriVIoJ527oCgk7vYwrfAzxw2P6m/oY+4QKtqk6oXOu2l
	ksrltV71wncqQgVgEC39pmRHsbxXKDB1BQhtEnkBt+r5meGIeYcDA/bSUxnTbRT1r1u00faqnAe
	AjIecBlR7gpwBceBJ+KCb5sXiP/koOVMVsQ2YVUiFuA5FRl0QZLnJ7i/FYMq+26qBPBZgI/99rj
	HRcQxXhoff6TOufKx6NOc22E98vfR2xR2ZEYr0jGb86ByBLwWljb3244uM6UHi0PhtUVwo60DIP
	Y+UPh4oqw4Dwem7gY2Q8fnW+oY2wKDsAjhNgjCTg==
X-Received: by 2002:a05:600c:6296:b0:483:64b4:79da with SMTP id 5b1f17b1804b1-488fb7923a9mr178493405e9.26.1776682713015;
        Mon, 20 Apr 2026 03:58:33 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-488fc1cfbf2sm290929495e9.15.2026.04.20.03.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:58:32 -0700 (PDT)
From: Mahe Tardy <mahe.tardy@gmail.com>
To: mahe.tardy@gmail.com
Cc: alexei.starovoitov@gmail.com,
	andrii@kernel.org,
	ast@kernel.org,
	bpf@vger.kernel.org,
	coreteam@netfilter.org,
	daniel@iogearbox.net,
	fw@strlen.de,
	john.fastabend@gmail.com,
	lkp@intel.com,
	martin.lau@linux.dev,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	pablo@netfilter.org
Subject: [PATCH bpf-next v4 5/6] selftests/bpf: add icmp_send_unreach kfunc IPv6 tests
Date: Mon, 20 Apr 2026 10:58:15 +0000
Message-Id: <20260420105816.72168-6-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260420105816.72168-1-mahe.tardy@gmail.com>
References: <aI0MkNvWlE4FXMV8@gmail.com>
 <20260420105816.72168-1-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This test extend the existing IPv4 tests to IPv6.

Note that we need to set IP_RECVERR on the socket for IPv6 in
connect_to_fd_nonblock otherwise the error will be ignored even if we
are in the middle of the TCP handshake. See in
net/ipv6/datagram.c:ipv6_icmp_error line 313 for more details.

Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
---
 .../bpf/prog_tests/icmp_send_unreach_kfunc.c  | 83 ++++++++++++-------
 .../selftests/bpf/progs/icmp_send_unreach.c   | 46 ++++++++--
 2 files changed, 93 insertions(+), 36 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c b/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
index 24d5e01cfe80..047bfd4d80f7 100644
--- a/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
+++ b/tools/testing/selftests/bpf/prog_tests/icmp_send_unreach_kfunc.c
@@ -8,15 +8,17 @@
 #define SRV_PORT 54321

 #define ICMP_DEST_UNREACH 3
+#define ICMPV6_DEST_UNREACH 1

 #define ICMP_FRAG_NEEDED 4
 #define NR_ICMP_UNREACH 15
+#define NR_ICMPV6_UNREACH 6

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
@@ -34,7 +42,7 @@ static int connect_to_fd_nonblock(int server_fd)
 	return fd;
 }

-static void read_icmp_errqueue(int sockfd, int expected_code)
+static void read_icmp_errqueue(int sockfd, int expected_code, int af)
 {
 	ssize_t n;
 	struct sock_extended_err *sock_err;
@@ -44,6 +52,12 @@ static void read_icmp_errqueue(int sockfd, int expected_code)
 		.msg_control = ctrl_buf,
 		.msg_controllen = sizeof(ctrl_buf),
 	};
+	int expected_level = (af == AF_INET) ? IPPROTO_IP : IPPROTO_IPV6;
+	int expected_type = (af == AF_INET) ? IP_RECVERR : IPV6_RECVERR;
+	int expected_origin = (af == AF_INET) ? SO_EE_ORIGIN_ICMP :
+						SO_EE_ORIGIN_ICMP6;
+	int expected_ee_type = (af == AF_INET) ? ICMP_DEST_UNREACH :
+						 ICMPV6_DEST_UNREACH;

 	n = recvmsg(sockfd, &msg, MSG_ERRQUEUE);
 	if (!ASSERT_GE(n, 0, "recvmsg_errqueue"))
@@ -54,28 +68,27 @@ static void read_icmp_errqueue(int sockfd, int expected_code)
 		return;

 	for (; cm; cm = CMSG_NXTHDR(&msg, cm)) {
-		if (!ASSERT_EQ(cm->cmsg_level, IPPROTO_IP, "cmsg_type") ||
-		    !ASSERT_EQ(cm->cmsg_type, IP_RECVERR, "cmsg_level"))
+		if (!ASSERT_EQ(cm->cmsg_level, expected_level, "cmsg_level") ||
+		    !ASSERT_EQ(cm->cmsg_type, expected_type, "cmsg_type"))
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
 	}
 }

-static void trigger_prog_read_icmp_errqueue(int *code)
+static void trigger_prog_read_icmp_errqueue(int *code, int af, const char *addr)
 {
 	int srv_fd = -1, client_fd = -1;

-	srv_fd = start_server(AF_INET, SOCK_STREAM, "127.0.0.1", SRV_PORT,
-			      TIMEOUT_MS);
+	srv_fd = start_server(af, SOCK_STREAM, addr, SRV_PORT, TIMEOUT_MS);
 	if (!ASSERT_GE(srv_fd, 0, "start_server"))
 		return;

@@ -86,18 +99,40 @@ static void trigger_prog_read_icmp_errqueue(int *code)
 	}

 	/* Skip reading ICMP error queue if code is invalid */
-	if (*code >= 0 && *code <= NR_ICMP_UNREACH)
-		read_icmp_errqueue(client_fd, *code);
+	if (*code >= 0 && ((af == AF_INET && *code <= NR_ICMP_UNREACH) ||
+			   (af == AF_INET6 && *code <= NR_ICMPV6_UNREACH)))
+		read_icmp_errqueue(client_fd, *code, af);

-	close(srv_fd);
 	close(client_fd);
+	close(srv_fd);
+}
+
+static void run_icmp_test(struct icmp_send_unreach *skel, int af,
+			  const char *addr, int max_code)
+{
+	int *code = &skel->bss->unreach_code;
+
+	for (*code = 0; *code <= max_code; (*code)++) {
+		/* The TCP stack reacts differently when asking for
+		 * fragmentation, let's ignore it for now.
+		 */
+		if (af == AF_INET && *code == ICMP_FRAG_NEEDED)
+			continue;
+
+		trigger_prog_read_icmp_errqueue(code, af, addr);
+		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
+	}
+
+	/* Test an invalid code */
+	*code = -1;
+	trigger_prog_read_icmp_errqueue(code, af, addr);
+	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
 }

 void test_icmp_send_unreach_kfunc(void)
 {
 	struct icmp_send_unreach *skel;
 	int cgroup_fd = -1;
-	int *code;

 	skel = icmp_send_unreach__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
@@ -112,23 +147,11 @@ void test_icmp_send_unreach_kfunc(void)
 	if (!ASSERT_OK_PTR(skel->links.egress, "prog_attach_cgroup"))
 		goto cleanup;

-	code = &skel->bss->unreach_code;
-
-	for (*code = 0; *code <= NR_ICMP_UNREACH; (*code)++) {
-		/* The TCP stack reacts differently when asking for
-		 * fragmentation, let's ignore it for now.
-		 */
-		if (*code == ICMP_FRAG_NEEDED)
-			continue;
-
-		trigger_prog_read_icmp_errqueue(code);
-		ASSERT_EQ(skel->data->kfunc_ret, 0, "kfunc_ret");
-	}
+	if (test__start_subtest("ipv4"))
+		run_icmp_test(skel, AF_INET, "127.0.0.1", NR_ICMP_UNREACH);

-	/* Test an invalid code */
-	*code = -1;
-	trigger_prog_read_icmp_errqueue(code);
-	ASSERT_EQ(skel->data->kfunc_ret, -EINVAL, "kfunc_ret");
+	if (test__start_subtest("ipv6"))
+		run_icmp_test(skel, AF_INET6, "::1", NR_ICMPV6_UNREACH);

 cleanup:
 	icmp_send_unreach__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/icmp_send_unreach.c b/tools/testing/selftests/bpf/progs/icmp_send_unreach.c
index 6fc5595f08aa..112b9cbfab6f 100644
--- a/tools/testing/selftests/bpf/progs/icmp_send_unreach.c
+++ b/tools/testing/selftests/bpf/progs/icmp_send_unreach.c
@@ -6,6 +6,11 @@
 #define SERVER_PORT 54321
 /* 127.0.0.1 in network byte order */
 #define SERVER_IP 0x7F000001
+/* ::1 in network byte order */
+#define SERVER_IP6_0 0x00000000
+#define SERVER_IP6_1 0x00000000
+#define SERVER_IP6_2 0x00000000
+#define SERVER_IP6_3 0x01000000

 int unreach_code = 0;
 int kfunc_ret = -1;
@@ -16,17 +21,46 @@ int egress(struct __sk_buff *skb)
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
-	    tcph->dest != bpf_htons(SERVER_PORT))
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
+		    tcph->dest != bpf_htons(SERVER_PORT))
+			return SK_PASS;
+
+	} else if (version == 6) {
+		ip6h = data;
+		if ((void *)(ip6h + 1) > data_end ||
+		    ip6h->nexthdr != IPPROTO_TCP)
+			return SK_PASS;
+
+		if (ip6h->daddr.in6_u.u6_addr32[0] != SERVER_IP6_0 ||
+		    ip6h->daddr.in6_u.u6_addr32[1] != SERVER_IP6_1 ||
+		    ip6h->daddr.in6_u.u6_addr32[2] != SERVER_IP6_2 ||
+		    ip6h->daddr.in6_u.u6_addr32[3] != SERVER_IP6_3)
+			return SK_PASS;
+
+		tcph = (void *)(ip6h + 1);
+		if ((void *)(tcph + 1) > data_end ||
+		    tcph->dest != bpf_htons(SERVER_PORT))
+			return SK_PASS;
+	} else {
 		return SK_PASS;
+	}

 	kfunc_ret = bpf_icmp_send_unreach(skb, unreach_code);

--
2.34.1

