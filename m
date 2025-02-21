Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDE920C49F
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Feb 2025 13:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740144711; cv=none; b=OKK5iOXzbzl6GkMOQCnCcebIBhTTotSrzi1XNH9pTZprp4aV4xBlIvLYIRGDUKhwEx1SOj15/lDFDeRhY6x4EMvDBiyADiC4JA3/eLUHTRvrllbVlE5RTO/d2bd94WZtemtsj6SSLz2ZEkX5WaxgrUdZ/aJcgoHniFg/ZMuCebs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740144711; c=relaxed/simple;
	bh=T/JI6N+wJWnMwCjet6idlFzHJP88pCV5BYriH3RGQLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=M/8t/A+5uU1jvBpzMTk3t/pvwxNu5MqgWY8B5VKmo9UVbGUKqZ4fb6kJ/eHaQ3lQsNB/s9QNYve7mRJ58K10eC2VI9ZD63LrE2hRcVh7x2lmeMqnEXP0+NJ5d+OVvHm8wo6Kat36c3Krr9xtomtYesrQC7xxIeEYqDOsNojLvUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=hHOwWxEs; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=akWI++qi; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="hHOwWxEs";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="akWI++qi"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1740144707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jlFO+1Ig3M6oTFmlo1Mm4e4xVMuPZpb7PgMBP2Isgyo=;
	b=hHOwWxEs0zwo6GFAXXv7B/THqFZuDiTLvNIwZBwog+CzK7G/PsOwnIOzKcc4mXv+uqW2WU
	ghg/QVh7NqA9oQ4R+Pu9BjyEGGYb7iAHKz6WsDVc3i/yUlZcPZU3hitBsvbuzus6Rz/ptL
	+tDIDYPKivhrLzvaRpoING9c/7j++tOXMYyjf4KVN2St++gTO8xriiOvq5dtIw3NROZB0d
	Za/hhyUlgYRsEIpGVnwksR6m2Rwh6fBc7eT/NVdPERS6tq7dkL/Q7wgimdILftaBZc1zbw
	CD2RI1CEqxD9b6+hVpGtrhPgANjNylV+QGR+xKeTopKOVprptoWLwamI3Aofew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1740144707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jlFO+1Ig3M6oTFmlo1Mm4e4xVMuPZpb7PgMBP2Isgyo=;
	b=akWI++qi7veKI/BrOiWcN5mTfKqIwfvkPPsUq7+lXF3p9pktfiW2PygvKlTtu+YhBuZ8VC
	J78uRtvogXHoWGCw==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH net-next v2 0/3] Replace xt_recseq with u64_stats.
Date: Fri, 21 Feb 2025 14:31:40 +0100
Message-ID: <20250221133143.5058-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
in patch #2 I tried to split the regular u64 access and the "internal=20=20=
=20
access" which treats the struct either as two counter or a per-CPU
pointer. In order not to expose u64_stats_t to userland I added a "pad"
which is cast to the internal type. I hoped that this makes it obvious
that a function like xt_get_this_cpu_counter() expects the possible
per-CPU type but mark_source_chains() or get_counters() expect the u64
type without pointers.

v1=E2=80=A6v2 https://lore.kernel.org/all/20250216125135.3037967-1-bigeasy@=
linutronix.de/
  - Updated kerneldoc in 2/3 so that the renamed parameter is part of
    it.
  - Updated description 1/3 in case there are complains regarding the
    synchronize_rcu(). The suggested course of action is to motivate
    people to move away from "legacy" towards "nft" tooling. Last resort
    is not to wait for the in-flight counter and just copy what is
    there.

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
 net/netfilter/x_tables.c                      |  79 ++++++------
 9 files changed, 192 insertions(+), 214 deletions(-)

--=20
2.47.2

