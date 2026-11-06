Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793925519;
	b=imrYMNpw4R5UpxSbVZUIG7ADmriEgZg6S/ZlkvOc64vPKY8tx2XRAuO/YAvVYY49ih7z
	 VPn3JP8rkZIVF9j1X18u4meEdOFlGBVkTkXtS4+SjT8/csCnvMkLIlbcIuwmD5DzTW3QS
	 lOOaLpKehHend79SzTMD5DqtW8DRdbV40pl6QXnmc447151DAhUQIjP9odflEojY4GhDv
	 C/eV+ROIoaqPYNa93cD3F2q+bayNfREuxlLLZGOKRRNuDEt4sRYdllnPjnuQQ0jE2QAAb
	 pVbUft/38HE+hLhOTyer+hTfs1BOwXVFrlaASqxQSYStD+DqeL3oRkLYGWvjpDC61mg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925519;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=yMMgkbadXN+6MAybVVredCUmSbaqZ38m8wsXiJfpM3k=;
	b=jAd21JHEqRjCVm9rXVEKSV26NYPdrZQ1YfsNuXvNTe18/BruoF9z5zBXBK/ziQqt+PDg
	 HfDhIVgiSaDUtNEFE2xjW9MDTTt4lZwS1rZYU3MqW2Iedqv8HgqdJurN2YWFKoAeiJ2F4
	 ZQMw5tzb0kP+FJQxa7q1XLFcsd98Gnla1BLHgzxlbwVM/MXhQQg8oeZ+AzrkF+lgeogyz
	 qAUnOIGOd15FkjRW1Jl4jA4jHSbMtYB3dliAtKaEtFMpSXBlgFK1yFFdFyvQsSphjUGz5
	 Aw5F/sMmWnbiVDOjIkhvx14jO4Kpt4baZluhEnf+4oirKUuc5tSJ2HDDNoGBzzDGgmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7DXEYi8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491A2606A328;
	Fri,  6 Nov 2026 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7DXEYi8
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793925519;
	b=BOQ0i6HeKQ/FjKbKPCYLgl+H8VrHl0OxeD1PqJpkLQZ8/FdHnkM5CT4X/zajfNh8iOB2
	 iibndJQw6LNgabGMEN9nvS3o7JPgPezxKMoXxvOrOgHlCttKp7+emUn1jGUW1Vmc5KaPr
	 FmUe72p7DPoILohI7nH1+LSTHfRthhStAl+LRiWgVNPNWAAwADa1EuWx7saHtiRHkzdgZ
	 m9IzbG1OIRdilNFS3jDHnmZC0IVE09hLsvcO+JAgSwrOf5aKy5geJslO7C3PcvjT27if/
	 56Ob49Fjca2sxnZ9qolfG4nu3DxeQqfmHguSsupqYPhaVyrZ8iWQvTfGzwhwOEZJgJw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793925519;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=yMMgkbadXN+6MAybVVredCUmSbaqZ38m8wsXiJfpM3k=;
	b=UXJNsvNr4iSKk2VN0MQpQM42cSkZsf9/iROGdimF9z1w4oONp+alJzlxs95M/EL9ixh3
	 X0HvVVTYDtCnrZtTKgA4QSnzT0gqDSQO+ah5EXicVugUkhxIQhgHaXu9n8rnqB2h25zZO
	 OCPudt4xQddujNfltP5psia5Tm0C7ZQgcOKmipH5XXXKEAGMNkJE0GMlxuLEu0qQHh35o
	 A4D178TNA0uSCs2eDAhyxQ9X1lPhB323zNh/D0KBtmB4V0kI/Jl2pQltA8z11wxMZomLD
	 iCEdgz56NJubEyvIQ2E6koET1vNgnvy9dndwnPbEQBNrGO0CHxHDhnIq61rFwbZC89A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 156C21F008A2;
	Fri,  6 Nov 2026 00:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793925519;
	bh=yMMgkbadXN+6MAybVVredCUmSbaqZ38m8wsXiJfpM3k=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=A7DXEYi8uElQONdSvLxx0ZaiT5kWA7BOj4zCeZq/JZ+vad9SFlM9GZbTC9n0q+z+b
	 WZKP0A5r/VP6sClIzzDzt2QCs9vJ+39pBbDyDuirRP6pNadqcDCgThokkS94ViR+N3
	 GAjdxismgbQMLR+f2slAbz8wb2asqFlWENBU+RKO5XCDlbZOETvz1GwEzq1mGmz9yR
	 k371DVFrzCMbcTQh+yXk1eVVDufPl0XRtQYT/So80lCJen60TNyYUy45lUBqYUTclo
	 AWVDzzTJX0Y3DdTLX5hwD7xl/dBRquYqB8hiJcSR5cACMw4iNlGqn+ABd1lhXc6Dqq
	 5o8/fLhpfPX6Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 63BB345B1A;
	Fri,  6 Nov 2026 00:38:37 +0000 (UTC)
From: Alireza Asgari via B4 Relay <devnull+alireza.asgari.net@kernel.org>
Subject: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet ID
 reuse and large gaps
Date: Fri, 06 Nov 2026 00:37:03 +0000
Message-Id: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC8h7WoC/yWMvQrCMBSFX6Xc2WAStIibFMRRxE0ckvbERvCqS
 aNC6bub6HT4zt9IEcEj0roaKeDlo79zBjWrqO0NXyB8l5m01LVSshbsngkJopTxFmq1kFhqGNd
 ZyqNHgPOf3+GJ9ptjsyvuYdsUYQx0/pdisle0Q7kuiTURwgbDbV8sdvOb8UzT9AUz8xZioQAAA
 A==
X-Change-ID: 20261106-nfqueue-review-1840e52eafdb
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
 netdev@vger.kernel.org, kunit-dev@googlegroups.com, 
 Alireza Asgari <alireza@asgari.net>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793925516; l=4056;
 i=alireza@asgari.net; s=nfqueue-20261106-d5b860a0;
 h=from:subject:message-id;
 bh=tuCkgFrwK5f7smUTKpW5TAvqKyfXSKAYkonELYpnhDw=;
 b=wBYL/NIh5Us2wzgUM7gomOy1wCItO0ebDh6oLGZUDtQsHLvS8QOpdBRYWg16BQwIudtD1SA2f
 1qREgCu1rmZBdXOp+P7aKVie8N+YHCEDrXmVUuEEjlUa6tLrchyYTtX
X-Developer-Key: i=alireza@asgari.net; a=ed25519;
 pk=zQFqyM4zwBHzads8dtEOnNQiQQ1pktgndpKPB3TI+AE=
X-Endpoint-Received: by B4 Relay for
 alireza@asgari.net/nfqueue-20261106-d5b860a0 with auth_id=1424
X-Original-From: Alireza Asgari <alireza@asgari.net>
Reply-To: alireza@asgari.net

This series addresses packet-ID reuse and batch-verdict ordering in
NFQUEUE. I am posting it as an RFC to discuss the handling of ambiguous
batch boundaries and the additional sequence state used to resolve them.

An old packet can remain queued while newer packets receive individual
verdicts. Queue length therefore does not bound the distance between
pending packet IDs. After a complete 32-bit ID cycle, two pending packets
can have the same ID, making verdict lookup ambiguous. Even before reuse,
the signed 32-bit comparison in the batch handler can select the wrong
FIFO prefix when IDs are separated by half an ID cycle or more.

For example, with pending IDs [1, 0x80000002], a batch verdict through 1
currently selects both packets instead of only the first. If the queue
contains [1, 2, 0x80000003], removing 2 individually and then batching
through 2 also selects both remaining packets instead of only 1. These
cases are covered by synthetic KUnit tests that seed the sequence values
directly.

Patch 1 rejects an incoming duplicate ID before list insertion or userspace
notification, preserving the existing pending packet. The incoming packet
follows the existing enqueue-failure policy: drop by default, or accept
with FAIL_OPEN.

Patch 2 uses an exact queued boundary to select the FIFO prefix. For a
boundary no longer queued, it uses a 64-bit queue sequence and a per-entry
32-bit epoch to recover issuance order. Ambiguous missing boundaries
return -ERANGE without changing the queue. The wire format is unchanged,
but the rejection behavior is userspace-visible. This does not distinguish
stale verdicts after an ID has been released and reused.

Patch 3 adds 45 KUnit cases covering ordering, wraparound, missing
boundaries, collisions and the actual enqueue path. Each case uses a
private network namespace.

I would appreciate feedback on:

  - Whether -ERANGE with the queue unchanged is the appropriate response
    for an ambiguous missing batch boundary.
  - Whether the per-entry epoch and widened queue counter are appropriate
    for handling boundaries that have already been removed.
  - Whether the existing drop/FAIL_OPEN policy is the preferred way to
    handle an incoming packet whose ID is still pending.

Validation:

  - Focused UML KUnit run: 45 cases passed with GCC 13.3 and W=1.
  - Kconfig dependency checks with NFQUEUE built in: tests enabled with
    KUNIT=y and NET_NS=y, and disabled with KUNIT=m or NET_NS=n.
  - Full x86-64 allmodconfig with GCC 13.3 and allyesconfig with Clang
    18.1.3: both passed with W=1 and CONFIG_WERROR=n.
  - Separate GCC builds of NFQUEUE and all eight other direct users of
    nf_queue.h passed in both configurations with W=1 and
    CONFIG_WERROR=y, without compiler diagnostics.

The full builds disabled WERROR after unrelated failures were reproduced
on the unpatched base. GCC allyesconfig also encountered an unrelated
MCTP KUnit static assertion failure on that base; the full allyesconfig
build therefore used Clang. Runtime coverage is the focused KUnit suite;
no throughput or latency measurements are included.

Codex assisted with developing and reviewing this series, fixing the
KUnit dependencies and namespace isolation, running validation, and
preparing the submission text.

---
Alireza Asgari (3):
      netfilter: nfnetlink_queue: reject duplicate pending packet IDs
      netfilter: nfnetlink_queue: fix batch verdict ordering across large ID gaps
      netfilter: nfnetlink_queue: test packet ID ordering and collisions

 include/net/netfilter/nf_queue.h         |   1 +
 net/netfilter/Kconfig                    |  12 +
 net/netfilter/nfnetlink_queue.c          |  78 ++-
 net/netfilter/nfnetlink_queue_gap_test.c | 906 +++++++++++++++++++++++++++++++
 4 files changed, 988 insertions(+), 9 deletions(-)
---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261106-nfqueue-review-1840e52eafdb

Best regards,
--  
Alireza Asgari <alireza@asgari.net>


