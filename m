Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F836921E
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779809848; cv=none; b=s+5bdnVKI4NrmQEqjEr25/XRjikfKW+U/nStTE+ne1736PKWzIX7kOvebfkh7CHgopvZVl2+8PpChwfXrLso2pIoTKaetXQhkfjP51S47cwFe2ut2mtufbHbIrQinW2QBBbhbtrUSNTTwVxqg3806sp4qnezaweYZpwzIq82ybQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779809848; c=relaxed/simple;
	bh=SuNCKboR9/qMnKV199RmrKzsF4XnE5gzMhvdzv4lxUk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nvpLAC7P816dNqwfN4AXAhRzGRnYxT5729ORIvykp9FUMr6kXW/4oVVdOigpWhSP9IwRxoOBt2MKAy1j8Or7Egd2N5G+hZumvdNI9/1cO8iHk6PXYLLciteskkAXXZbHMeD+d7KH4fZRD6SqUlYxqTFNubWTmH9GgdWy9jqTcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THwnRz23; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THwnRz23"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48d146705b4so113745245e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2026 08:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779809845; x=1780414645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mEu5haSOg9MswhbLQuLwhfuoJ04JYV0iIkWmF1VBvMA=;
        b=THwnRz23QIb8MlYwi5JtG5bkdDs9Bb1cegJXxDqRk0E6fzuwcgwhOlrRwFvYh8vP4x
         m97WkxMQRiMvArFFI2hH14L6OaPYPHYacb+EydXMq784G9v0pfvZH877tUizrEz9esGV
         qtPTHnIGVoIGgpIXnLWG7FXCb4kZCMnXvC4uy1FCx6sB/bg8tUVlxIOWmeBY9/+T/KHi
         ilKrqekNGIAS/U2m7vIzCIJkkIgl0X8bSlwwkPzd2eh1FFOR8XKHRl1+YV5OexCw/ae1
         b8H1Nk+oRS/hbNAikxPFY0vKOlzlfx7p24qaUcycR1oxzHn75s0PmYRLcBw+/Dtg6rYp
         rGkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779809845; x=1780414645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mEu5haSOg9MswhbLQuLwhfuoJ04JYV0iIkWmF1VBvMA=;
        b=svxkLbf22nCOtVfz+o/HjUGtz6TMiNN9VxoyqkDmP6nSX5v6MyzP6i+l+HTcVflsaJ
         bgTfK5ZWmfb2YJ5G2Ep6dHcpgEqJQaOeGMjztgUgEPgYdzigpx6ecyW9XS1gmFY/qDZe
         zwdzR+bofg2Y5NOgDSipfvKzUN+IoG1BBAn4Xd5p9WtaIgJOQ31leIWPomORJgU7MLg9
         cglSPguFR9u5V6T3r/w66p5CQ0aF4TptEvFVpxvWXdgY/skXu7l6i1X8wZ9+b3NzDwZf
         zAdGmqiSNt/ZoV/3cB7IJVogTyiGS/oi9kIKDHbpOojDvZLN2it4vj7jP1X+SB9eSWSq
         Qqrw==
X-Forwarded-Encrypted: i=1; AFNElJ+qVHedcsiplNMMnyZQ5dA1+fF21JTQ6hfopvljC5GimlOMpklHCNPiKqRlZ0ovTiyOL/xRlAabEtWRn7SIiY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKqDTRJn5tHiGQt3gGfAPu4dQSZ3AnmbY70x3zThsGxzkdPCjZ
	vt7CcP90exf6nKxZ5lHONPEkw8nSEIOMDf/KmM3Vaf+tUJZgGe5XmQtK
X-Gm-Gg: Acq92OFSqT/vCGZCOZo6TkNI8CzcxlMFIVy+yuLp7L3xwPcW1dmshJNqocaPnursNId
	zTBlvANybX0ykIRdOCdH/huj1voUFK2YVq7XsRqIu0166u3XGW2sd5fmC2jwnGuJb2qpF4zfTEt
	AyXkloMOpSg8Nvoh81dF8hfKzXcIaUM0oB5aMZPMpGA85nfaYsf23Iew2XcrNQeDOiGLmQojTFx
	WFXVvWDcJFOmEtXHiSAbp/dX6CasyqjlTk2fNgrd82Ja8ktvhH4I+lAXHnhTeyjwiNCbztHji0z
	zkEy3t5k4znYWmSrPMOTXVTEwbs++kwta47Q5xyAI9k+1nB29JsrEJ7CAydm3gAZf7CNk6bBv3v
	EyOPh6hvTWaYXXKAqwLYhNuvRQx9CERQeTyRd0fuigqQl0gAh54GKvMD5DQhm5SZBHWqmghlzGp
	bdysAlV6YFbhd9WZ4w7ZwFL7kpIP4=
X-Received: by 2002:a05:600c:8484:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-490426cd8c4mr338065445e9.20.1779809844415;
        Tue, 26 May 2026 08:37:24 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4907df9edeasm1083655e9.9.2026.05.26.08.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:37:23 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 0/7] bpf: add icmp_send kfunc
Date: Tue, 26 May 2026 15:37:01 +0000
Message-Id: <20260526153708.279717-1-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This is v7 of adding the icmp_send kfunc, as suggested during LSF/MM/BPF
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

[^1]: https://lwn.net/Articles/1022034/

Link to v6: https://lore.kernel.org/bpf/20260518122842.218522-1-mahe.tardy@gmail.com/

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
 .../bpf/prog_tests/icmp_send_kfunc.c          | 243 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c | 172 +++++++++++++
 9 files changed, 563 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

--
2.34.1

