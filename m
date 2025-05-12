Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F5C255250
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2025 10:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747045734; cv=none; b=jcOqCC3c7nYaKvK/EwtV1DmILHNSX9957Smuq1ulAYxFe6V2W1pHFnIx1PhuXrwztUXV5h57Ip/e4QsG6DAQZ1CrXHxcq5UEWBGF1B0FjOPqHkrGsJ7XIwFIMG0/gFlGNHn02ICY41Q5oUgze+I7bG8NOfJhtKdE/yhmswNG6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747045734; c=relaxed/simple;
	bh=OJRCGagqab4zHuoCt2O1vZ93G1rkw4fB7SYyrI8B07s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oT4uZGnQKYXTyjT6gE6MZE99OYCFZqmxnvgMc+2tKChC57ETxkcSCce+ZvnbrGRBe/4bND/LmpuyUSg5MQQICq5C6iDRYOUyNpGjzuvK/WqO+Ih0jYGBQ00/U8opqUyGvSY6jjhKHujw+I7hI9WnUg20ou1GcQ8UkjRWTpRvyos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QruhBU9Q; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xYsQhc51; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QruhBU9Q";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xYsQhc51"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1747045730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zfUXiTNZXr8cVx9t4UZL90lhwrU2i31fwxwdhJdvdeY=;
	b=QruhBU9QmTF0ifnaB/OERFubtt6d7DVyZV89CmisPvc8ipmscMiFRyUaWfCREXhUY8gdoR
	/q6tqjTDpHochp1Ola7VOM1uxLFh4k1MyyzJDmZ2Zr400Wu/s2IOnyZPCt12/7RbbFc6tX
	RV9lHgB+C0zzAiH3+bJqPi9f+z53Er+8yheWyrYA1iJhqTJjbGUh7Vwof8uX2laTTnLmdZ
	dTCHqJCSjj5YWMzEnx6M01u18mJo6kCnQiw38vn97Yzpljn4dlIaKYavlsn+vMPz3jzV6p
	Ev4dif90xVCLxplPE3RmnPOgFKchqq0yYjkQyX8+NKlOizfcIJ1EcsHnVqmf0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1747045730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zfUXiTNZXr8cVx9t4UZL90lhwrU2i31fwxwdhJdvdeY=;
	b=xYsQhc510L3yTHNjxfyqmuH5JUdLjBtafSzBdjuyaeuwS+ffTtvbRffNEM2W1VlmyG+kMC
	CqGEMreAowFu7UAg==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH nf-next v1 0/3] netfilter: Cover more per-CPU storage with local nested BH locking.
Date: Mon, 12 May 2025 12:28:43 +0200
Message-ID: <20250512102846.234111-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

I was looking at the build-time defined per-CPU variables in netfilter
and added the needed local-BH-locks in order to be able to remove the
current per-CPU lock in local_bh_disable() on PREMPT_RT.
NF wise nft_set_pipapo is missing but this requires some core changes so
I need to postspone it for now.

This has been split out of the networking series which was sent earlier.
Therefore the last patch (nf_dup_netdev) will likely clash with net-next
due to changes in include/linux/netdevice_xmit.h (both add an entry).

Sebastian Andrzej Siewior (3):
  netfilter: nf_dup{4, 6}: Move duplication check to task_struct
  netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx
  netfilter: nf_dup_netdev: Move the recursion counter struct
    netdev_xmit

 include/linux/netdevice_xmit.h   |  3 +++
 include/linux/netfilter.h        | 11 -----------
 include/linux/sched.h            |  1 +
 net/ipv4/netfilter/ip_tables.c   |  2 +-
 net/ipv4/netfilter/nf_dup_ipv4.c |  6 +++---
 net/ipv6/netfilter/ip6_tables.c  |  2 +-
 net/ipv6/netfilter/nf_dup_ipv6.c |  6 +++---
 net/netfilter/core.c             |  3 ---
 net/netfilter/nf_dup_netdev.c    | 22 ++++++++++++++++++----
 net/netfilter/nft_inner.c        | 18 +++++++++++++++---
 10 files changed, 45 insertions(+), 29 deletions(-)

--=20
2.49.0

