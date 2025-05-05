Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D80630C1C6;
	Mon,  5 May 2025 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488523; cv=none; b=jxehqS4BSTj8lJKBNiBkfx0LpvvuLtDA4YJwAdcUOvn1ng4SzemFw+Bo5Pg/Xk0fqCr0xXVUVaGsJkI6rZWVcnmmi3/Q4ONs4i8yASGeEf0gqhLkY3PXW69ox0gYm42tczAJvpo1w+xJlBG/2mXaFThu5qst03JgBUH3i5nZ+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488523; c=relaxed/simple;
	bh=MaMkf53SEIRP4bQtihcD1yyrGguY6LuXqAfw+XKt1/U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oVOuWLOc1L4CdMrZT5UrRbBX9ISOncLCfe0TAlNBtRXEcwqOSTgx6/IMUS6EZDbUU/CJr6LwLMAz6NSiOGIy9xpKPx5pXOw3NSm6DrPrDvvzNsqx04+X+l5eXLhlPFAKNLeppUqkqAiGPR//qObT3SCMAA53W30+xac096ydbPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nVAkFbts; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OpX7j1iA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nVAkFbts";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OpX7j1iA"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 11EF56065D; Tue,  6 May 2025 01:41:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488518;
	bh=LfiaJP+Uo+z2Z0JoRS0aywKhfv0uxsPSHVVFel78Bko=;
	h=From:To:Cc:Subject:Date:From;
	b=nVAkFbtsaPUFj3hkjJaV2O3uyeK2Gl1ksr415cZn84XZSwBj6I4r98GgT5pzxaCRe
	 mxOI1Sb1wsjAWnZGOKbXj8N5xwPql2uUfxvfr002G0L0rLUS97XXlRxnONcBOI/m+A
	 0112M96R9Bc32HWTM3n5UmpuklqvVhcXg6VNPUaPKY9oGjMGnI3YLVNe7knwm+bTku
	 A7Yryn4B8vu5nMWM3Ac7E3horgwbq5PO0jKP5ArFyTls8r1RueeQSCkrO6AFMxH1Nr
	 U+sUCtyIKQ/Ntapgj/wWQNOmT2uTlIr+c8S7WXUU1uJuONXsw0Ym3MpfBuH80NQKdb
	 ZrCl5QyVZeJIg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 684DA60654;
	Tue,  6 May 2025 01:41:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488515;
	bh=LfiaJP+Uo+z2Z0JoRS0aywKhfv0uxsPSHVVFel78Bko=;
	h=From:To:Cc:Subject:Date:From;
	b=OpX7j1iAzQvnfpDsHF28r7LeG2KouyiRK/jJTgy1Y3cFsXyHzp5SkSfteMGSBbtr+
	 qgE+7VSITVSuPbqlM020XefnXGVy/n0t5e8M2o2+FG3M+UbkKfCW0BExM1wKRUQpxh
	 v2M04BoYw/kPZE9LYwTfnnJ3Wd8PiHXzQhGmYs0S/eeLsyuvDroZDuyeIANCRoJkmO
	 LWuvN24T1KSRQObUaGeINDJ3IqBIVE26UJSNi7RBbLqaafzKK3kC70+jBhlzl6kkfC
	 d80LzY0ayKp1C8RUbqO34/hX0tNIZOOygDjnFI8rL3sXlqOh1zEH7XzshGyLuicWJy
	 Oa1k+M+wJ0Llg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 0/7] Netfilter updates for net-next
Date: Tue,  6 May 2025 01:41:44 +0200
Message-Id: <20250505234151.228057-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset contains Netfilter updates for net-next:

1) Apparently, nf_conntrack_bridge changes the way in which fragments
   are handled, dealing to packet drop. From Huajian Yang.

2) Add a selftest to stress the conntrack subsystem, from Florian Westphal.

3) nft_quota depletion is off-by-one byte, Zhongqiu Duan.

4) Rewrites the procfs to read the conntrack table to speed it up,
   from Florian Westphal.

5) Two patches to prevent overflow in nft_pipapo lookup table and to
   clamp the maximum bucket size.

6) Update nft_fib selftest to check for loopback packet bypass.
   From Florian Westphal.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-05-06

Thanks.

----------------------------------------------------------------

The following changes since commit 836b313a14a316290886dcc2ce7e78bf5ecc8658:

  ipv4: Honor "ignore_routes_with_linkdown" sysctl in nexthop selection (2025-05-03 21:52:38 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git tags/nf-next-25-05-06

for you to fetch changes up to fc91d5e6d948733773af35ef3b95504d8e588e4f:

  selftests: netfilter: nft_fib.sh: check lo packets bypass fib lookup (2025-05-05 13:17:32 +0200)

----------------------------------------------------------------
netfilter pull request 25-05-06

----------------------------------------------------------------
Florian Westphal (3):
      selftests: netfilter: add conntrack stress test
      netfilter: nf_conntrack: speed up reads from nf_conntrack proc file
      selftests: netfilter: nft_fib.sh: check lo packets bypass fib lookup

Huajian Yang (1):
      netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it

Pablo Neira Ayuso (2):
      netfilter: nft_set_pipapo: prevent overflow in lookup table allocation
      netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX

Zhongqiu Duan (1):
      netfilter: nft_quota: match correctly when the quota just depleted

 net/bridge/netfilter/nf_conntrack_bridge.c         |  12 +-
 net/ipv6/netfilter.c                               |  12 +-
 net/netfilter/nf_conntrack_standalone.c            |  88 +++--
 net/netfilter/nft_quota.c                          |  20 +-
 net/netfilter/nft_set_pipapo.c                     |  64 +++-
 tools/testing/selftests/net/netfilter/Makefile     |   1 +
 tools/testing/selftests/net/netfilter/config       |   1 +
 .../selftests/net/netfilter/conntrack_resize.sh    | 406 +++++++++++++++++++++
 tools/testing/selftests/net/netfilter/nft_fib.sh   |  23 ++
 9 files changed, 559 insertions(+), 68 deletions(-)
 create mode 100755 tools/testing/selftests/net/netfilter/conntrack_resize.sh
