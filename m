Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B931F78F39
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 16:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742921933; cv=none; b=Q9apkdjtUHWtEF6coyeZVjrd5VU2Gc2Vv1bmpubxrG7g9M/JjsGX/TFJq2KCnUYHU7l3F7J18ftreNTPfif1cKHPUeTXwszyujqiQoFoOlvXUFBQjWuzlfS7RxHeKAEtlvJXLCqFv/DEWa8SOKhVpo1fEdfVxGqewT9EiQN/e7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742921933; c=relaxed/simple;
	bh=HsyQOqO/ZUaWmLeqm0Cu5w1iedY0tgvP52k3ffnPnFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=awCYhbyBOWZM4KdL15jAcqflJkvsqoBIpqV/cUWkzEkWoj1upDaBsmC71w9Y6HaU5vHFun2CQ0P//chDkLwkoEXOPVYTqJK7y8FHY+uVJhFRrGv/9L6JUDuhc3oLML7eQ4ntRG0Trd4UKEEPbA0ulEOqdmXdap+prHJfeloHx2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=koG3ucBz; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=/lEzBtRF; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="koG3ucBz";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="/lEzBtRF"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DPXWaaJGm0Bnu+Dn4NFf3r2IOONcOqxrMf17GIhXFGE=;
	b=koG3ucBzTqt4m0aVzvcZ3l0VBjX6OILZ+UeQ2UftIEGOlQ4shHIg2IbPWDBLm0wVR4V9MV
	s9y03De/vfByuZdZQDOfh7EXsjpMhdxQTMPGWPVCQ6emZRr28ANIICemJ+YZcBTl7kckWB
	mhGTcW/MSAOgXBJrT5oH3HxrIcrrewkRnLDHTVGcUkSLUgsehwVSNHEkQmVrgDiCsZ3RnY
	6cI0QaaYXmMdRSJ4xR6nz2FQrH2Fe+/gPTbDLiPcM0tZDgWMAAlRn7d80ZaV1ydOQgBbc6
	zKbTKv2vx5nom8GfwqTikpElDXDnNJkDx4xGEu6/hGa4qEWaOvEJ42KxmBnYZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742921923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DPXWaaJGm0Bnu+Dn4NFf3r2IOONcOqxrMf17GIhXFGE=;
	b=/lEzBtRF+1H6Rdqd+LD7p/4OyrP/ySCdK2Q1x6e/dsiX2GYQG3/LYPUI4h/mlRSwxdCj6j
	FreXJYyeuhSH4NAw==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [net-next v3 0/3] Disable LEGACY iptables on PREEMPT_RT
Date: Tue, 25 Mar 2025 17:58:29 +0100
Message-ID: <20250325165832.3110004-1-bigeasy@linutronix.de>
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
priority reader interrupts a writer. Also xt_recseq relies on locking
with BH-disable which becomes problematic if the lock, currently part of
local_bh_disable() on PREEMPT_RT, gets removed.

Based on discussion with Pablo and Florian the legacy code is disabled
on PREEMPT_RT. I picked up the patches referenced by Florian and tried
to fix them up as suggested plus the bits we talked about.

v2=E2=80=A6v3 https://lore.kernel.org/all/20250221133143.5058-1-bigeasy@lin=
utronix.de/
  - Instead of getting LEGACY code to work for PREEMPT_RT the code is
    now disabled on PREEMPT_RT. Since the long term plan is to get rid of
    it anyway, it might be less painful for everyone.

v1=E2=80=A6v2 https://lore.kernel.org/all/20250216125135.3037967-1-bigeasy@=
linutronix.de/
  - Updated kerneldoc in 2/3 so that the renamed parameter is part of
    it.
  - Updated description 1/3 in case there are complains regarding the
    synchronize_rcu(). The suggested course of action is to motivate
    people to move away from "legacy" towards "nft" tooling. Last resort
    is not to wait for the in-flight counter and just copy what is
    there.

Pablo Neira Ayuso (1):
  netfilter: replace select by depends on for IP{6}_NF_IPTABLES_LEGACY

Sebastian Andrzej Siewior (2):
  netfilter: Let IP6_NF_IPTABLES_LEGACY select IP6_NF_IPTABLES.
  netfilter: Introduce NETFILTER_LEGACY to group all legacy code.

 net/Kconfig                  | 10 ++++++++++
 net/bridge/netfilter/Kconfig |  8 ++++----
 net/ipv4/netfilter/Kconfig   | 15 ++++++++-------
 net/ipv6/netfilter/Kconfig   | 13 +++++++------
 net/netfilter/x_tables.c     | 16 +++++++++++-----
 5 files changed, 40 insertions(+), 22 deletions(-)

--=20
2.49.0

