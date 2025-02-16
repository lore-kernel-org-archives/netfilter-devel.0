Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0232A197A7E
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739710767; cv=none; b=BgcILuVCYmhZktm7qyaIenMgWROGzbaymeaIlHHiFsJCQCZGrpVUHRLBZKz0Eh/tC7QJ5yelv14snO6NnMsOx/rO7cM2mHXSvXv4+xGohDcqyF7HAy3Mo0et7YTbywsKMC+7Ip7deksvrbdsuNcgH73WelylvxoVDaSa1unCt8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739710767; c=relaxed/simple;
	bh=RlEB+NVG8/uB0rtWjrTcqjAuEU6epRoe2PwVfW2AWh0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JoAoaHQKb/d2Ytpog04Cp5BxNwXY5XBfzlTx8Wrl+PBareghMliFC5H9rN50H1x6FZ8HCW/yqqglh1b/z7K0Qabdv/ax+RgwcbuUNRGi+KmNEeko/WAOoXKMwylP/SHdsvrEmylCLDBHNDVKt8GRTG78mY1tsPkSvjP8bdIWLmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RKr/7ctj; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=cpeuwHyW; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RKr/7ctj";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="cpeuwHyW"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1739710301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Akn4nExVN3r+71LnBH5lIbF6wgz+pSMMJd3tnsP/Y2k=;
	b=RKr/7ctj2IOVd0QyBfao2Au/T2c7v0g+7NDpaJ8ssHVLgjOKQmw+peIONeVlP6UuBbA+nG
	UgGsff2V3L/JhwGagwfIq+I7JjVnN8WkdW70lthZCcYsMGxQLoUn5kITg8g83RCujhF8+7
	/teSfRK26CPbtyiQExHsF2vZ3i3/E62Dpnqx+OCB6CYA29kkSprM9kwAVOzqw0ZexGd3+7
	+70CEcVHl6lP+TcOpJ6B5ZIcFZI9oiLsRIEKGGOlFL4GiZcHN5bpngVIJVtalIzSg0BW1n
	aIJ94dSkGFZrUBXOQ/cCec8s7gWHx0JfFo2TElaB5Am6jJitC/mm1akzAbF7XQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1739710301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Akn4nExVN3r+71LnBH5lIbF6wgz+pSMMJd3tnsP/Y2k=;
	b=cpeuwHyWvPsFmm+eIDvm+301g1l+MMuwA1le3w/rZiJesRFwDvrYnt1Izsr8kFd0/V7OEI
	8LubCSoomOK1i6CA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next 0/3] Replace xt_recseq with u64_stats.
Date: Sun, 16 Feb 2025 13:51:32 +0100
Message-ID: <20250216125135.3037967-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The per-CPU xt_recseq is a custom netfilter seqcount. It provides
synchronisation for the replacement of the xt_table::private pointer and
ensures that the two counter in xt_counters are properly observed during
an update on 32bit architectures. xt_recseq also supports recursion.

This construct is less than optimal on PREMPT_RT because the lack of an
associated lock (with the seqcount) can lead to a deadlock if a high
priority reader interrupts a writter. Also xt_recseq relies on locking
with BH-disable which becomes problematic if the lock, currently part of
local_bh_disable() on PREEMPT_RT, gets removed.

This can be optimized unrelated to PREEMPT_RT:
- Use RCU for synchronisation. This means ipt_do_table() (and the two
  other) access xt_table::private within a RCU section.
  xt_replace_table() replaces the pointer with rcu_assign_pointer() and
  uses synchronize_rcu() to wait until each reader left RCU section.

- Use u64_stats_t for the statistics. The advantage here is that
  u64_stats_sync which is use a seqcount is optimized away on 64bit
  architectures. The increment becomes just an add, the read just a read
  of the variable without a loop. On 32bit architectures the seqcount
  remains but the scope is smaller.

The struct xt_counters is defined in a user exported header (uapi). So
in patch #2 I tried to split the regular u64 access and the "internal
access" which treats the struct either as two counter or a per-CPU
pointer. In order not to expose u64_stats_t to userland I added a "pad"
which is cast to the internal type. I hoped that this makes it obvious
that a function like xt_get_this_cpu_counter() expects the possible
per-CPU type but mark_source_chains() or get_counters() expect the u64
type without pointers.

Sebastian Andrzej Siewior (3):
  netfilter: Make xt_table::private RCU protected.
  netfilter: Split the xt_counters type between kernel and user.
  netfilter: Use u64_stats for counters in xt_counters_k.

 include/linux/netfilter/x_tables.h            | 113 +++++++-----------
 include/uapi/linux/netfilter/x_tables.h       |   4 +
 include/uapi/linux/netfilter_arp/arp_tables.h |   5 +-
 include/uapi/linux/netfilter_ipv4/ip_tables.h |   5 +-
 .../uapi/linux/netfilter_ipv6/ip6_tables.h    |   5 +-
 net/ipv4/netfilter/arp_tables.c               |  65 +++++-----
 net/ipv4/netfilter/ip_tables.c                |  65 +++++-----
 net/ipv6/netfilter/ip6_tables.c               |  65 +++++-----
 net/netfilter/x_tables.c                      |  77 ++++++------
 9 files changed, 191 insertions(+), 213 deletions(-)

Sebastian
