Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.143.172.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794743166;
	b=uaPdD6/tQFCtyBm2NjYS/5cAu6I8HTYbgTVpQ22D05IIYdLpGyqUSQ6rDNx2CsipsmX2
	 IzUecoCVq9SfmeJFm/f8Er3Zs27n3I8q/ymI4njOcXd19dcJ4f2K/l1pyQrJ6w22u6+f4
	 ZxLmi/m8Gug5pPfpIrrym57ffAzI9Ofsj6xXAVRi1HLOfdVgZpIgIVqhkZtx/47bd/KEk
	 kYQHrYdCdvj5PXQ6LVh3v6GbC9KNDGv5E02D8IIBEgDq6AlZhgo8bwKpiTCJ2/06o0BgO
	 SAt7HaPmgv1kzO1ySKS3g547H/QuSbl3qm+MLIONCbBu+EAd93fhVzMHpPczQbXVDuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794743166;
	h=DMARC-Filter:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Rspamd-Bar:X-Rspamd-Report:X-Rspamd-Score:DKIM-Signature;
	bh=E2qAcR3rEBfe73Lo3oxL5x8qblh3Zs/YTkiFBzYgfAo=;
	b=0Ij3Q0RF5N9n50iQsPp0tZHbld3GFj1XalfG/0BuUuU1h74d+EQX7Ki6Fal00ptOAdlK
	 qrIPrr2yLcnNOhTMRPULH52R2nN+Fq3ZQTQ+YslOC1D6eTBZRCLfCZPi//GW1EgdIGbDl
	 9HRxnQoTwjCOv4SWf3LlLs4IQl/6SNAgxK0Zp1BtfvuaaMhRh96m3S1ikPVRQqSeLLDn4
	 A73HkuuFy5UIwZp6yJrvqKh1DE5MI09FWCJcG+HQC/PxUGBkusnO3H2t13+HVFsRPc3e0
	 mBENIldLwxeMhJfwQ492aGX4E944op9o4OfHXvKth0HQwbmBJqVydrT5Ld7zDx1KjRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lausen.nl;
	spf=pass smtp.mailfrom=lausen.nl;
	dkim=pass header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=hBMYvwQt;
	arc=none smtp.remote-ip=95.143.172.20
Received: from mailgate01.uberspace.is (mailgate01.uberspace.is [95.143.172.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC8F606A329
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 11:46:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CEC8F606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lausen.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lausen.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=lausen.nl header.i=@lausen.nl header.a=rsa-sha256 header.s=uberspace header.b=hBMYvwQt
Received: from devico.uberspace.de (devico.uberspace.de [185.26.156.185])
	by mailgate01.uberspace.is (Postfix) with ESMTPS id 331E960D41
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 12:45:56 +0100 (CET)
Received: (qmail 18858 invoked by uid 990); 15 Nov 2026 11:45:55 -0000
Authentication-Results: devico.uberspace.de;
	auth=pass (plain)
Received: from unknown (HELO unknown) (::1)
	by devico.uberspace.de (Haraka/3.1.1) with ESMTPSA; Sun, 15 Nov 2026 12:45:55 +0100
From: Leonard Lausen <leonard@lausen.nl>
To: netdev@vger.kernel.org
Cc: leonard@lausen.nl,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/2] ipv6: honor prefix-length suppression in raw FIB lookups
Date: Sun, 15 Nov 2026 11:44:30 +0000
Message-ID: <20261115114434.10343-2-leonard@lausen.nl>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: -
X-Rspamd-Report: MID_CONTAINS_FROM(1) BAYES_HAM(-2.996479) MIME_GOOD(-0.1) R_MISSING_CHARSET(0.5)
X-Rspamd-Score: -1.596479
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=lausen.nl; s=uberspace;
	h=from:to:cc:subject:date;
	bh=wAe5ZC7Fm6uGqNNB9AvG9s41KNLGeyY8d6FFjcwChUQ=;
	b=hBMYvwQtliYC27OwjBCkct5rQ5I9TOX82SHf5qDl1W8KWgAMU8Dwo3hKcwL2oSc4E4HUo0y0ZQ
	/KcaJsGFQDKhnf+Hkx+PJnhV5289P5LXk58ma+9qsebA9sEkhcEZdvQpEshq9R+mq6WrV4ZlXWLi
	evq4QHZOlv6A1AQD84xXR7UV9sX/UwYmGI3Lkb1pg/jOeufGDxvkBOgdHytO3nLGuZrQk9bWRLUa
	XVgxc40D2krSPa0VykTp6y/KGb3qjfdlATHCQnnMIFT3GW4oU31Rz/CsqC85YPtEH1oowlJba+6a
	Pr6ohGrjMwDWEz6+dH7AzUa4vxKucYWJ9FyAd52N6Yd+kwYXARZqXVFJj7XTXcyqEEd9sIA/7Pv1
	L5TZanwBKVIfYBiT5bRZEd4rKVnU+TMGx+zDFeMowNcPgDaT6uKQQMmbDpCBbutCdq/SroHWNwvE
	hHF9wW/9Ug6y1FM5Co0MLOnuOFyBDwU7Tamufr5sK+V6qQqUKzPSEwiFGs/jfe1fqOKTGWSbfdVJ
	4qtc4hMFGyfaUlGFc/yM61ya/08xigQCGrgQM77mWtv/CAnmxrCGAPTb9alG7KvTMHqIxQoq21xl
	g5bbjy93bmLZHfA1c3bfSyPT9m+eSVPgEQkQn/eIj8MeesAwS4YQTDwoGurDFoLmn1auhJOGLxWc
	M=

Following Sashiko's automated review, v2 is limited to
suppress_prefixlength. The review identified that v1 evaluated
suppress_ifgroup before final multipath selection; I reproduced the
resulting disagreement between raw and ordinary lookups. Interface-group
suppression needs separate work and is left unchanged in this revision.

Prefix suppression is sufficient for the reported VPN failure: nftables
can otherwise return a main-table default that an ordinary lookup
suppresses before continuing to the VPN table. Strict reverse-path
filtering then drops replies arriving through the VPN.

Patch 1 adds a raw prefix-length check while preserving RTF_REJECT results
and leaving dst-based handling unchanged. Patch 2 extends nft_fib.sh with
six checks using its existing topology and counter helper.

Changes since v1:
- Drop raw suppress_ifgroup support and its tests. Table lookup can return
  a different nexthop from the final multipath selection used by ordinary
  routing and BPF, so suppression cannot safely use that initial device.
- Install the router's logging RPF rules after the suppression checks and
  policy-rule cleanup. This prevents neighbour advertisements from being
  logged and dropped during intentionally different reverse-route states.
- Add a blackhole nexthop-object case, which distinguishes rejection flags
  in the lookup result from those in the FIB entry.

V1: https://lore.kernel.org/netdev/20261110131638.15004-3-leonard@lausen.nl/

Tested on the rebuilt v7.4-rc2-based kernel: all six added checks pass,
and the full nft_fib.sh run exits 0. A run with an eight-second delay also
passes, allowing neighbour discovery to complete. Separate probes confirm
that reject routes remain terminal and raw interface-group suppression
is unchanged.

OpenAI Codex assisted with investigation, reproduction, implementation,
tests and descriptions. The prompts asked it to investigate the
Wireguard VPN failure.

Leonard Lausen (2):
  ipv6: honor prefix-length suppression in raw FIB lookups
  selftests: netfilter: cover IPv6 FIB prefix suppression

 net/ipv6/fib6_rules.c                         |  9 ++-
 .../selftests/net/netfilter/nft_fib.sh        | 63 ++++++++++++++++++-
 2 files changed, 70 insertions(+), 2 deletions(-)


base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.55.0

