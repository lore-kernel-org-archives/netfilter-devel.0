Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD52331ED7
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 06:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971206; cv=none; b=BmBdiGmETaKijMeuxmcGtlAy2L7XVOb1QmZueroznQDct4tDVBRNRdF6sDW7OEsrYk3D8JuvZjTFFOP4NR6FyJYVd+0M8ToiQ2JnQRAidlKmiWk2U5iTIVgEoRpztZzGdFdSMGsvsT3TMCAIBVa3BqOaIqv7DW2GzlhwOjW7F4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971206; c=relaxed/simple;
	bh=3rTdupL47kcB7pOpSsKb4iIveq9v3F1up+yJLJR67Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XO7ww8Pli7YWN+6c6Nbx+oIbpu46n8CjpPNYx3Kz72XcRRL+8vOcANy23ITzAoNzE7FIOznk6ZNz5QfoV+voWgv76aSReODuAki+AtRKGYkYbEhycviofAZMNZIpfya9DY0VihG/r+zv2YflmM+Q11Ywo/F1c2SGbCVxJQD4fFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mp8AKF6U; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mp8AKF6U"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4ef687f5so4065265ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 23:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789971204; x=1790576004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Iu72UFRQJ+xSZSF5kBVRPs0ErHGDd1b7nGwylpaInY=;
        b=mp8AKF6UDpRPe8pzKk8sSWXePFnh+Cy516FAZ93PvX06TNACWNEUa0O1M/sBYCbg+L
         5VKtD2I09moZGpyPMQ7aLkQIuB8J4d5eJWzx1d5H8v1/m98f1K7Dte5NDzU+6tihjAEN
         OJIqNes81QMyKyUyRcdtKo00zLPK6KavI2p09gGpHqluzdfErllivtKOkhgyCimZOQia
         3GcBrMvbgUqurcq3uS1jRuw9IyzPuSiiktpF84/L0dZTwSk09uICxdBntbs/Ydk4hwlH
         Rvuz5VGKyj/I5vjhAbRjsALkGHPJ/r3QkjAT9xYKvb4cNh/G2QR0GIj7/m1cXIhwELQV
         0Dug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789971204; x=1790576004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Iu72UFRQJ+xSZSF5kBVRPs0ErHGDd1b7nGwylpaInY=;
        b=or2f4rOjzvnn7XFun3XGS5/hYi9QrrGwVDE6ar2LrUtqCdETFKGUfpwoj/UOXrylhR
         7+5fKJ3WM3/bSUojMBd70v+fwH9iSoqki6FKEiZRkLqS9A8PPWqqgDsUC3ZadBt+9z8f
         eOMX+nHfOGrIMy614DUJ17SgC9TQCnJ7h1ggQo9UStRIVqaPZSRdZHaKez8qX/GB5/FJ
         MhGpq3mGjtLrmoI9MbOm8YQn5+5xN/6/9VHgfwzVcbwP6bJ0UUngLQLE6UT1d2nlCOVm
         9F2fHBfq4bwBTofSgUrqRE0HmoaXknLXDdd1AMaGvqsEb6Zicu0NSUbEiDcMi5FFX+yG
         lypg==
X-Gm-Message-State: AFuF++kM423thQxoVDNEQCdq2NVogwg9mpcyoVtILvjxx5PSgPKtLqIN
	+d1QGH3Uh6PksU6dDz0pQ68Sk8osaxLRUl7sq2baNZYz1afHVZf4/0jh
X-Gm-Gg: AYBFou2qe87X9bn7GZtcyaJc8dUNxs/sttFQK9tccb7lHxb3xNkvbhcM7TiLzXmIeOO
	vRX7reuSnM/bZSsXTdJeCzFEHVv6be3ixuEr3RqCO63s4EsMaz3ZWeZgkHsxhFPOlq6Hf4rc8BT
	GVUAb5SaGciVkJNh7cIYscQPrZCjqLFEEiwbgQ2a+QdUalJFd7zGg20SLuDxsx3fJ7xp7uDXydp
	ngTQ/Qu1M2Qf3shAxthiXNc1U17Lcu9XBhr90hdCsLvUCKElzug5gQrsaCZvCzEw1pxgPJd/6ko
	3EAaEYvmaeixjx22/fPwCeH/zyt8vMZ7l9b1GxAhZZ5wt1Mp36umivctq1R9FksEworbGnq3HYV
	ZDoEKGGkxKhBGVBEoo7NcjZoOHKnhgN6k7NBhkbj2w2tfPiTs40AJ9RQmhaKCQnI0NDCl722w+P
	3ZkzQ5tqIj2f8T+tmTJR1biVuRbum+vXK5JtpHj5yg8hp4KwbNfmJUHTbVKcKmLk2bVN9jNzx3w
	rQa9fiz5JA=
X-Received: by 2002:a17:903:b87:b0:2d8:d29b:c1e5 with SMTP id d9443c01a7336-2ddb644f014mr176238725ad.0.1789971204182;
        Sun, 20 Sep 2026 23:13:24 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc16b4a8dsm27497765ad.12.2026.09.20.23.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 23:13:23 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [BUG] netfilter: unbounded nftables reject recursion on inet OUTPUT
Date: Mon, 21 Sep 2026 06:13:20 +0000
Message-ID: <20260921061320.543-1-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

I am reporting unbounded hook recursion on inet OUTPUT: an nftables
output chain that does a TCP flags payload-set followed by
"reject with tcp reset" makes nf_send_reset() re-enter the same
NF_INET_LOCAL_OUT hook until the kernel stack is exhausted.

Summary
=======

nft_reject_inet_eval() calls nf_send_reset(), which builds a RST skb
and transmits it with ip_local_out(). That walks the same OUTPUT
hooks again.

The only loop guard in nf_reject_ip_tcphdr_get() is the packet-content
check:

  /* No RST for RST. */
  if (oth->rst)
          return NULL;

If a payload-set runs first and rewrites the TCP flags byte to SYN,
that guard never sees RST, so another RST is generated. The cycle is:

  nft_do_chain
    -> nft_reject_inet_eval
      -> nf_send_reset
        -> ip_local_out
          -> nf_hook_slow
            -> nft_do_chain

nft_reject_inet_validate() allows NF_INET_LOCAL_OUT.

This is a legal nftables configuration (payload set + reject with tcp
reset on an output base chain), including with CAP_NET_ADMIN in a
network namespace. I do not claim privilege escalation; the result we
see is local DoS (stack overflow, then panic).

I am aware of the existing recursion bound on the netdev fwd/neigh
xmit path. nf_send_reset() via ip_local_out() does not use it.

Affected
========

- Confirmed on Linux 6.6.144, KASAN guest (CONFIG_VMAP_STACK not set).
  On that config the overflowing SP walks into adjacent slab; KASAN
  first reports a write in __unwind_start while tracking __alloc_skb
  from the next RST. Those frames are collateral. The defect is
  unbounded hook recursion.
- Source review of torvalds/linux master as of 2026-09-21:
  nf_send_reset() still calls ip_local_out(); the only loop guard is
  still if (oth->rst); nft_reject_inet_validate() still allows
  NF_INET_LOCAL_OUT. The PoC was not re-run on tip.
- Files: net/ipv4/netfilter/nf_reject_ipv4.c,
  net/netfilter/nft_reject_inet.c
- Config: CONFIG_NF_TABLES=y, CONFIG_NF_TABLES_INET=y,
  CONFIG_NFT_REJECT_INET=y (KASAN used for the report)

Ruleset that triggers it
========================

  table inet t {
          chain out {
                  type filter hook output priority 0;
                  tcp flags set syn
                  reject with tcp reset
          }
  }

Then connect() to 127.0.0.1 in that netns (a SYN on lo).

Crash excerpt (minimized PoC, Linux 6.6.144 KASAN)
==================================================

BUG: KASAN: use-after-free in __unwind_start+0x36/0x840
Write of size 112 at addr ff1100000659ff88 by task repro/221
CPU: 1 PID: 221 Comm: repro Not tainted 6.6.144 #1
Call Trace:
  __alloc_skb
  nf_send_reset
  nft_reject_inet_eval
  nft_do_chain
  nft_do_chain_inet
  nf_hook_slow
  __ip_local_out
  ip_local_out
  nf_send_reset
  nft_reject_inet_eval
  nft_do_chain
  ... (repeats until stack exhaustion; then GPF / panic)

Reproducer
==========

A self-contained C PoC (raw NETLINK_NETFILTER batch, no nft binary)
and a Docker/QEMU package are available on request. VM-only: the
program overflows the guest kernel stack. Please do not run it on a
host kernel.

I am happy to test patches or send the reproducer.

Thanks,
Yu Junzhe
FuzzAnything <fuzzanything@gmail.com>
