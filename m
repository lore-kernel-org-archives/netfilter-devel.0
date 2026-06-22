Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85192281525
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 12:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782129931; cv=none; b=H7J8SDN1DE9CwOMlKAQ1mH2q9qjWDiP3Q3MPt6p/AhEhBSu4M9aGtnSKY3EcBczgSdDHKDvGBnOmfguVTeEf8a1xLhRAvTGg/HR0Y6I9ZkZ4paYuRdw5wj9Byd9IfU13xJ23DyRufdwJPcgyyPkTROQySeCBCUEZiVinHqb/034=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782129931; c=relaxed/simple;
	bh=dN1pLmbmed/NC96M/cd4Xbam1n1B1pvbnIxNHE495dY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bY1Ziqu2BQ9uqFYdLBKsI0TyBJcA+vtYCqgjdTS3hJSQWkpmlp+Ql5tmV0K6N5fYruCEF4ufM9KjA0VJwOSO0o7d4oiRWrBJzIJHvKCIuCySn2KdFvr+8KLoRC9+1A8RP3Sc/VL2Xu/fql2/+S3EP3mHE/uu8EZRTzgDuPS3i8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpgilBJt; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpgilBJt"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-46019b190b6so3360918f8f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 05:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782129928; x=1782734728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w2RuwhHXabj+ww9YZldGbi29RRzljhvrbTpiXJqZXhE=;
        b=VpgilBJtDgaddZDKBYB8FCWGyakbkOEhIeKFl4cWdHUoRscX34cbGzLCYaMH2rWQvL
         LkO4W49QJUFmXa9VyZ/uP+GigiaL9vmYFjcUGUCoLFEcTfJhwgDi6qwXEU1qGLXxBTX+
         9B3FYKorl+Y9W4LhRH9R6A0sOerHTyQECCidEQpyz4g/6QwnEfjAe5A6caj8MuxKF6aU
         AE/DqNNC1mQgH7Fcpv5njVHa2Yzq3uNitDRhZEDqBagkdcF8ovDm/iXb0wba3eVXu5NM
         7u7jZ1a0zRL+8fsFFPhGM2hrWiohsMGAzeV/6AlsJFi39FtzLn8w+3xaLcNuGh5RVtUu
         nCKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782129928; x=1782734728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2RuwhHXabj+ww9YZldGbi29RRzljhvrbTpiXJqZXhE=;
        b=WATqvv0TLvD7svEBarzz+8fX72aTd6hHMvrPBd08YIP76IL4dkRb/tKbjkMF8wvapL
         rcNv8UYYItR/1sxBA69MY5OacalXqovGxN0lz5jQHNxb+uUJGHmOz4LFQI0nANPUgZg4
         3fiTlf+XXk2HsLIdhRlBWITTnEPky3+YQ4tif9vGmRzN+gBrGjkxD6hTzQN1PgreofdR
         6yuqo1aAkrD6Aif95PHsEQO12drjXt5XGvc+GoFkYSn7Xu3phaY+bOuUl9vYASFCp9mn
         IM5vgNlhlfAkuWZOPgARsRYzBLKR4FTYMG8GZUFuoNajdjFqtlH2Csai9kVJVGYx3+Qy
         L/kw==
X-Forwarded-Encrypted: i=1; AFNElJ/RQ3DrOAH3pRRN5H7PJXE+i6+yrjcA9pFfPSt32r6icXS/bjRLJlR9IdUb6dLcf2He1EEnvzlCZ9WVF75ppsM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyh6Ykv5jx073pkGUxBjO062AGAkK+Q/BNfMINSb8P1G45eP+0j
	J3S1ngoMlZ/rgWCc07THFPH0BQ83BF6h6Ul+VJ3RRWKP6vSmp6A91hGU
X-Gm-Gg: AfdE7cmtBdVBJREvdCRMHgI9SrkHd2VM6lDiUofmbcHF719QdESM/Lq5mhWIFrtgN0P
	CEXA3MFH+d+kH9FksaTPI50bceaRfgCsT8aqjEuiPN7BINW/WspT0EaxNZaWmKS5CDNufB8jIvK
	YvPG0Pnuf/RJYgiAOBljRBek1W0Ama5XADdmYvhBYR21HqT/HmcaFesTFEtjo7AcQModp5/EL0u
	XD0nGe3fPBRJN59DeTLqnGhGAZd7VlcjIFS8Kt4WSXxouQvdP4pILOt1YxyvqBFf0KoG6dkJove
	Z5x8kBIcAthmyJJ7RN+uPigubhkN68sDJ07tRvn0ADr168djSZgo3KeYImBVi97HdzYbODkCWpp
	fe2cbqn3Bi5UzQoRgm7TsIjKAqW0wd3+WmSaHp/omSRIVcq3OAzybfZ23hNhkQ6TWtES9I7WRbK
	NIMVgigKPK1cOJAD0E
X-Received: by 2002:a05:600c:6386:b0:492:3763:aeb9 with SMTP id 5b1f17b1804b1-4923f6d2ff1mr234328755e9.21.1782129927618;
        Mon, 22 Jun 2026 05:05:27 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4923fc47720sm491083105e9.0.2026.06.22.05.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 05:05:27 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 0/7] bpf: add icmp_send kfunc
Date: Mon, 22 Jun 2026 12:05:08 +0000
Message-Id: <20260622120515.137082-1-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This is v8 of adding the icmp_send kfunc, as suggested during LSF/MM/BPF
2025[^1]. The goal is to allow cgroup_skb programs to actively reject
east-west traffic, similarly to what is possible to do with netfilter
reject target. Applications can receive early feedback that something
went wrong during the TCP handshake.

The first step to implement this is using ICMP control messages, with
the ICMP_DEST_UNREACH type with various code ICMP_NET_UNREACH,
ICMP_HOST_UNREACH, ICMP_PROT_UNREACH, etc. This is easier to implement
than a TCP RST reply and will already hint the client TCP stack to abort
the connection and not retry extensively.

Note that this is different than the sock_destroy kfunc, that along
calls tcp_abort and thus sends a reset, destroying the underlying
socket.

Caveats of this kfunc design are that a program can call this function N
times, thus send N ICMP unreach control messages and that the program
can return from the BPF filter with pass leading to a potential
confusing situation where the TCP connection was established while the
client received ICMP_DEST_UNREACH messages.

v2 updates:
- fix a build error from a missing function call rename;
- avoid changing return line in bpf_kfunc_init;
- return SK_DROP from the kfunc (similarly to bpf_redirect);
- check the return value in the selftest.

v3 update:
- fix an undefined reference build error.

v4 updates:
- prevent the kfunc to be called recursively and add a test (thanks to
  Martin).
- do not fetch dst route when unnecessary (thanks to Martin).
- extend the test for IPv6 (thanks to Martin).
- use SK_DROP in examples and use non blocking sockets for testing
  (thanks to Martin).
- test when the kfunc returns -EINVAL (thanks to Jordan).
- add the kfunc to bpf_kfunc_set_skb as suggested by Alexei.
- guard the IPv4 parts with IS_ENABLED(CONFIG_INET).
- fix a wrong initial value for client_fd (thanks to Yonghong).
- add documentation to the kfunc.
- to Jordan: I couldn't include <linux/icmp.h> because of redefines from
  <network_helpers.h>.

v5 updates:
- kfunc name is now icmp_send and takes the control message type as
  parameter for future potential extension (daniel)
- drop the net patches to route packet since now the kfunc is limited to
  cgroup_skb and tc progs (daniel & martin)
- linearize skb headers (sashiko)
- zero SKB control block (sashiko)
- bind to port 0 instead of fixed port (sashiko)
- poll to wait for POLLERR event (sashiko)
- do not use ASSERT_EQ in CMSG_NXTHDR loop (sashiko)
- fix comment about byte order (sashiko)
- fix endianness IP address issue (sashiko)
- add forgotten cleanup_cgroup_environment (sashiko)
- let packets pass in recursion test (sashiko)
- clarify evaluation order for recursion test (sashiko)

v6 updates (all from sashiko):
- bring back the net patches to route packet since tc ingress needs it.
- rename the ip_route_reply helpers from fetch to fill.
- call pskb_network_may_pull on the cloned pkt.
- check explicitly that we received one and only one ICMP err ctrl msg.

v7 updates:
- use consume_skb on success path (stanislav)
- replace recursion protection with CPU_ARRAY by checking the nature of
  the sk (daniel, offline)
- use reverse xmas tree in read_icmp_errqueue (jordan)
- use ASSERT_OK_FD instead of ASSERT_GE whenever possible (jordan)
- add a test for tc (jordan)
- better filtering from host cgroup test progs (sashiko)

v8 updates:
- mostly a resend as it's been sitting as "New" in the queue for almost
  one month, fixed a few nits.
- on new bpf_icmp_send kfunc cgroup_skb test (patch 4/7):
  - guard a close fd with fd >= 0 (jordan)
  - use ASSERT_OK_FD instead of ASSERT_GE (jordan)
  - fixed comment style (sashiko)
- on recursion test (patch 7/7):
  - guard a close fd with fd >= 0 (jordan)
  - fixed comments style (sashiko)
  - filter bpf prog on pid and ICMP message types (sashiko)

[^1]: https://lwn.net/Articles/1022034/

Link to v7: https://lore.kernel.org/bpf/20260526153708.279717-1-mahe.tardy@gmail.com/

Mahe Tardy (7):
  net: move netfilter nf_reject_fill_skb_dst to core ipv4
  net: move netfilter nf_reject6_fill_skb_dst to core ipv6
  bpf: add bpf_icmp_send kfunc
  selftests/bpf: add bpf_icmp_send kfunc cgroup_skb tests
  selftests/bpf: add bpf_icmp_send kfunc cgroup_skb IPv6 tests
  selftests/bpf: add bpf_icmp_send kfunc tc tests
  selftests/bpf: add bpf_icmp_send recursion test

 include/net/ip6_route.h                       |   2 +
 include/net/route.h                           |   1 +
 net/core/filter.c                             | 109 ++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c           |  19 +-
 net/ipv4/route.c                              |  15 ++
 net/ipv6/netfilter/nf_reject_ipv6.c           |  17 +-
 net/ipv6/route.c                              |  18 ++
 .../bpf/prog_tests/icmp_send_kfunc.c          | 248 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c | 184 +++++++++++++
 9 files changed, 580 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

--
2.34.1


Mahe Tardy (7):
  net: move netfilter nf_reject_fill_skb_dst to core ipv4
  net: move netfilter nf_reject6_fill_skb_dst to core ipv6
  bpf: add bpf_icmp_send kfunc
  selftests/bpf: add bpf_icmp_send kfunc cgroup_skb tests
  selftests/bpf: add bpf_icmp_send kfunc cgroup_skb IPv6 tests
  selftests/bpf: add bpf_icmp_send kfunc tc tests
  selftests/bpf: add bpf_icmp_send recursion test

 include/net/ip6_route.h                       |   2 +
 include/net/route.h                           |   1 +
 net/core/filter.c                             | 109 ++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c           |  19 +-
 net/ipv4/route.c                              |  15 ++
 net/ipv6/netfilter/nf_reject_ipv6.c           |  17 +-
 net/ipv6/route.c                              |  18 ++
 .../bpf/prog_tests/icmp_send_kfunc.c          | 250 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c | 184 +++++++++++++
 9 files changed, 582 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

--
2.34.1

