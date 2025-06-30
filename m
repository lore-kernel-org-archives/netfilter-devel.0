Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E178221DAD
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Jun 2025 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751298274; cv=none; b=W4FBBopOfZF9Ot6Qe/Q6zx0Mjdrli1DvJtH2SqzHhiC3W3oXW5OIflZMOIZqRSRjvgvVMxkrHN2cOKyrzaXyU2j+2UI1CZ5XKjeL3LzEudtecd3UyBEXpOGsK/37feLuThevbrx3eo304spUWgZLcT+5nWOVdmPXH14sl4MQi3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751298274; c=relaxed/simple;
	bh=Y5Xhs6g1nkcY+ZcNtV3JvIFrZP0f7+W9U1r617FP2YI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YVUkUCP/1+3iMwB2Fst/JBEnu1MQ0XebQglsUkBdV5DYEHAY7h4qiHO/AopdilIofdiGuRp0VB/edgmvGhXluMRCqGaZWSp6POC93EsgfF4lRPE6JYg3Rbyn+6JcCa8yDuGua0nydDSjypEbHpxRfDMCw6er81xO1ZlbC5bmHZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=e4g1gv+f; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=5Ijh5BXb; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="e4g1gv+f";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5Ijh5BXb"
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1751298270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1J1bP7+dJWSRt/UzeOf0Y6joFsfmST48SvQDhU1v/2E=;
	b=e4g1gv+fjUNOF1Vyl8AJ5bfW6X5HVkAlgNLy+eZG8SYOWmUBHU8N7j7JD/K3Eom+vyFMBR
	2MeNE8LQdzykFK7Od+7qtVnFZ+Ozg8Hrcvp5Fina0pipqOEb5vuEu59/IIPEeBPIH93gFf
	BMaqwd5ANRoRN1jtViiVTJMzBbwoUoZwYjn31Y2P1zHzsuoFCQCkggD/StImK6z2AqtgHD
	f688orv9SzbZ5SBtX1empuyexDUyvkITbx3vAvPQTNsTOQh4140rpaBMXSDwsr0l//wv6e
	OC3h96Me+NiX940znKgExcKWXSRH+uu9W5iBi9D5vb9UJ0KaJqD8emXNf3E1MQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1751298270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1J1bP7+dJWSRt/UzeOf0Y6joFsfmST48SvQDhU1v/2E=;
	b=5Ijh5BXbzd1SiGmfAzcWzD/Blp9DfLQNY1PfW3x6g/S/FpPZEkDRSd+yjEX606j6HhcqJr
	YDXHNC/s5m0naiBA==
To: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 0/3] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
Date: Mon, 30 Jun 2025 17:44:22 +0200
Message-ID: <20250630154425.3830665-1-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This is v5 of the "exclude legacy tables".

I retested the config fragments individually and as part of
kselftest-merge to ensure none of the requested option is lost.
The last patch in the series fixes up non-existing option which was
noticed during that exercise. The other finding has been sent to net.

Patch #2 has been split out from Florian's patch, hopefully as
requested.

Feel free to update Author: as needed/ if needed.

v4=E2=80=A6v5 https://lore.kernel.org/all/20250404152815.LilZda0r@linutroni=
x.de/
  - Changes let selftests fail, bpf required legacy iptables which were
    no longer enabled.
    Florian reworked the patch.
    Additionally Florian tweaked the config snippets.

v3=E2=80=A6v4 https://lore.kernel.org/all/20250325165832.3110004-1-bigeasy@=
linutronix.de/
  - Merge all three patches into one.
  - CONFIG_IP6_NF_MANGLE -> CONFIG_IP6_NF_IPTABLES in xt_TCPOPTSTRIP and
    + CONFIG_NFT_COMPAT_ARP xt_mark to allow the modules without LEGACY as =
per
    Florian.

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

Florian Westphal (1):
  selftests: net: Enable legacy netfilter legacy options.

Pablo Neira Ayuso (1):
  netfilter: Exclude LEGACY TABLES on PREEMPT_RT.

Sebastian Andrzej Siewior (1):
  selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG

 net/bridge/netfilter/Kconfig                  | 10 ++++----
 net/ipv4/netfilter/Kconfig                    | 24 +++++++++----------
 net/ipv6/netfilter/Kconfig                    | 19 +++++++--------
 net/netfilter/Kconfig                         | 10 ++++++++
 net/netfilter/x_tables.c                      | 16 +++++++++----
 tools/testing/selftests/bpf/config            |  1 +
 tools/testing/selftests/hid/config.common     |  1 +
 tools/testing/selftests/net/config            | 11 +++++++++
 tools/testing/selftests/net/mptcp/config      |  2 ++
 tools/testing/selftests/net/netfilter/config  |  7 +++++-
 .../selftests/wireguard/qemu/kernel.config    |  4 ++++
 11 files changed, 72 insertions(+), 33 deletions(-)

--=20
2.50.0

