Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF7C40DFCD
	for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779107341; cv=none; b=LupyDL33Htu8XO3DWgd11Io1/iP23cMwj2sqQrpbEXGPB81pUozoS/jYFj10JuQrPzTclnZbNMyCg9ww1YTXQh0hfrwiAl7dY6bRenn24HApdpIY2sjhKryvU+opyDsaoB1ZBAngDGAfOSMbn+djiWoqsqF2aijXGmOyLKH9QJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779107341; c=relaxed/simple;
	bh=x1/KdkH948uDsLZN+TPq8Fn0u85r+3KGQ7Dz/dF0Pf0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZSkvBbksbua9A55VTTEkp0df3Pnu5iOa/dlhNKzf1gsUs+otvGM1otTeifLWc21+7LCwltccBlzzVREImkOVme8TQHQ8Up2QWhdRZJq8NdWhhP91nyNbMOR02xT/kbdjNqWhPhms7nWqbY1iyUFIEjtJZMw+g4s0e3fL2oA9KYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OXKie+Xz; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OXKie+Xz"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso15185485e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 18 May 2026 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779107338; x=1779712138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N5HZfTGxzuF7Lu+NtHZ07U4frd9hqPt9a5u2U3vDU68=;
        b=OXKie+XzykG2MIXPbyRxBwicE8xV7MoLoYj8NShGo3wuwdKfP3uFUw8qLv7O81N4gF
         UDwfDq5zbyCIo0jzXnwGJx8gG1ZKFww5mgVPEDrmjmeAj2wyluifTc4p9IcUhYE0d/hQ
         lQEWoHJyytdxY5+tF1UNjv6A7Vei7C8TkXcXzCKqRsnTGsPjIIuD/mxsHCLY4BstwKcY
         oS/TXgxQqfWZM5HDDfeNkmx4cF6/hQO10dHA85RD5UbnCSvAbACfrHfSgJ8SSdT9vZoW
         guFeakJCpUqd8Ah0vpUwpesxIWxJlQipU+rOsyaq1f2Sa/kFQEY1veQHBt76CQDB8PAs
         KjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779107338; x=1779712138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5HZfTGxzuF7Lu+NtHZ07U4frd9hqPt9a5u2U3vDU68=;
        b=TO/Mz5bFedcBTUNd0OHqRDHFC1lFu8JOYJhHCRFQRK12nfIM531lYuouwEDoKtbAy7
         qBDBynN51/LlDJAqlADZSGEOv6G797v6JztfJ6VG35x3g/W2eJWXszMUZDLvGubHj23W
         NgGZeKSoMq2mIRj1gp3hyzRssf8CjP25nQg25kUCAJvangmKZ4UqnlgPlOATTs/NnQtX
         Jhu6rCmks9ZnBSWvwU6M0ebljBpU/VhhwBor+gKVos+RoN0ejJ3Z66x3bqnbKb+8CiWX
         g1aduETAMvQvkdkZ0uMjHdBDQ7UQgVmLS22wiEbATEyc8odDY07LrbU/mJIqswhYAgUV
         p4Iw==
X-Forwarded-Encrypted: i=1; AFNElJ91+VS3W4fy4xyWKZqFURvg8G/Y15X9TGxvNCcYr+tjvh31MfXJ3IVO7drSodQ59ysXUJFuaoJoTe1cbDKQVfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAbCm4RJsMiLApXaOaw7C0AiUwjtjAKuHjm2nnw6u2+be/nY6w
	Ac7G8BHT6VVe5HjdCdQqMfOnqSWJrATOFXt/cIP34ZY1wAENr2Zk2KfE
X-Gm-Gg: Acq92OF6QRCBr31eiwg7TyQuoGEq4wq6eNNJbQninNXf3e7ySfUP8ry6Rj8vZtF5qt5
	yS8GzDw5qHOfDKEIQYdihftclGPCan+LeVb67s85/2T+9qhDDZLLhoUuH9ROWszH5QX0NZ671yQ
	jbBOxX2mfLId1hgyl/CewlqWjsxeIxwOzNBRQ6qlol7YGi9gTmk+lmLYFlVddlWuYXb8ce/xaoe
	MYenaoDxs9g+QfvdB/P1LjjIKWHs1X6z5KmqimamMeH7sXqJY7r0a7jXVEVBsEdA2JcLoz+5fnh
	MHI0LeX6jM4LdEf8+hNq5PFl/NU3M51N3hROhSCJPgAiM6HFcGuqB3kh3ZK4BUbyg/gedE/k7xb
	93Q16HjJ6sHVPOHt7/Wvt3nf5nCw/55cQQ53q+4LsHJ++i+JUS2K8AFzt+EZ4SM1Z2Fg40Rg1iU
	wk7EnLSMSuE/2G+ys6DFcUfgIzh8KNh0Bhw26ZIxwiUYNORURZ
X-Received: by 2002:a05:600c:6211:b0:48f:e230:72fc with SMTP id 5b1f17b1804b1-48fe663152cmr229712275e9.33.1779107337576;
        Mon, 18 May 2026 05:28:57 -0700 (PDT)
Received: from mtardy-friendly-lvh-runner.local ([2600:1900:4010:1a8::])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-48ff2cb4ae0sm104304315e9.0.2026.05.18.05.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 05:28:57 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 0/4] bpf: add icmp_send kfunc
Date: Mon, 18 May 2026 12:28:36 +0000
Message-Id: <20260518122842.218522-1-mahe.tardy@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

This is v6 of adding the icmp_send kfunc, as suggested during LSF/MM/BPF
2025[^1]. The goal is to allow cgroup_skb programs to actively reject
east-west traffic, similarly to what is possible to do with netfilter
reject target.

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

Initially this kfunc was named icmp_send_unreach but now the interface
accepts a type parameter to facilitate future extension to other ICMP
control message types. Only ICMP_DEST_UNREACH and ICMPV6_DEST_UNREACH
are currently supported.

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

[^1]: https://lwn.net/Articles/1022034/

Link to v5: https://lore.kernel.org/bpf/20260515194746.50920-1-mahe.tardy@gmail.com/

Mahe Tardy (6):
  net: move netfilter nf_reject_fill_skb_dst to core ipv4
  net: move netfilter nf_reject6_fill_skb_dst to core ipv6
  bpf: add bpf_icmp_send kfunc
  selftests/bpf: add bpf_icmp_send kfunc tests
  selftests/bpf: add bpf_icmp_send kfunc IPv6 tests
  selftests/bpf: add bpf_icmp_send recursion test

 include/net/ip6_route.h                       |   2 +
 include/net/route.h                           |   1 +
 net/core/filter.c                             | 118 ++++++++++
 net/ipv4/netfilter/nf_reject_ipv4.c           |  19 +-
 net/ipv4/route.c                              |  15 ++
 net/ipv6/netfilter/nf_reject_ipv6.c           |  17 +-
 net/ipv6/route.c                              |  18 ++
 .../bpf/prog_tests/icmp_send_kfunc.c          | 218 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/icmp_send.c |  99 ++++++++
 9 files changed, 474 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/icmp_send_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/progs/icmp_send.c

--
2.34.1

