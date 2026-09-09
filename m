Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E081E45D923;
	Wed,  9 Sep 2026 22:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788992344; cv=none; b=XTGS7vrAdwj/5MLw4xYEYucXKvoGpQjcbb076+wxMBGGpZ3xzoR256vTT5AKJk4Ilym47mmrj2rLA6SLK8GMBcJQrgbqRFm1zGnbIeOObWmnllo1ttnDQV7qa5KUjpM3JqRX7vHjqlAlnq2phluDKegTvyx3LhFEpUIHwD4HOKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788992344; c=relaxed/simple;
	bh=DmMjH+iTLesw9LgVHZ/E7PHMOBP9LGbJDNG7R4YNGn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c6n88/+HksIsy+XPWq6Rm+7Swn46Vc9/nB5KknpXFvnopHdRgTLsdEP08Qpe1ac8vYjwUT+DN/Cq7cJdvqR2LFiXEmTy6cuA0UjCDgZOdvlUB/1YI/FP/P0EQT2kLZHQOpglyktI5zl548HcCOyDMADMaLU+TbFNOhrZY3TrwMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GywKnZP7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GywKnZP7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788992328;
	bh=Gj8tedKlR/lvO/etr9fe1/rX5SEj2DXLZff1/ARHN+g=;
	h=From:To:Cc:Subject:Date:From;
	b=GywKnZP7bbmkZhl+KaWDTckX2UTDaXzGGui/xlBgmadFeTe3m7qBBeX7LOAOCoJon
	 h2hLREZ16ZrgBZAO4QaETXPWoZyvq/HSIewdqYFhONm83q6VW1RO4JCr58YWwFQdWl
	 NDDFJmESNuZc8kF226/C4hKs3MCZAMKLyQyzZgdg2UkPCQAfpvEb3zTr9aXHgSsZR6
	 MBn5MCdMbk+/m+E5YANGwb2vhvS6uhv7SrPc6Zdas+p9dkeDXoqYoZSXLwCekd30f5
	 VqvUmIGl76qhDMMPrldw4+R1y2YukbHvkpmLjBd0gV2d0e4KQQjpnM6jOjiIisZxXI
	 wGHHCIU/qjuaA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18329607BE;
	Thu, 10 Sep 2026 00:18:48 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 0/7] Netfilter/IPVS fixes for net
Date: Thu, 10 Sep 2026 00:18:37 +0200
Message-ID: <20260909221844.1650275-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset provides fixes for Netfilter/IPVS:

1) Fix KMSAN reports an uninit-value in nf_nat_setup_info() for netmap,
   from Theodor Arsenij Larionov Trichkine.

2) Restrict deletion of netdevice in basechain and flowtable to exact
   matching only, from Fernando F. Mancera.

3) Fix nf_nat_register_fn() error path allowing for a memleak.

4) Revalidate ihl before calling icmp_send() in IPVS,
   from Julian Anastasov.

5) Hold reference on ct until flow is released to address, otherwise
   access to release ct->ext or different ct due to typesafe RCU
   semantics.

6) Use kzalloc_obj() to allocate timer object in xt_IDLETIMER as
   reported by sashiko to address uninitialized access.

7) Hold reference on module during netlink for cttimeout, cthelper
   ctnetlink and nfnetlink_acct.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-10

Thanks.

----------------------------------------------------------------

The following changes since commit 1b8e56030d52cd3e52c9ad4df1985ad0440be67d:

  Merge tag 'nf-26-09-07' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2026-09-08 13:53:17 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-10

for you to fetch changes up to c56f665eeaf77cd19f0a09c8fa7628b744d5918d:

  netfilter: hold reference on module during netlink dump (2026-09-09 23:15:36 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-10

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_tables: fix device name and prefix match in hook lookup

Julian Anastasov (1):
      ipvs: revalidate ihl before icmp_send

Pablo Neira Ayuso (4):
      netfilter: nf_nat: unregister and release hooks on error
      netfilter: flowtable: hold reference on ct until flow is released
      netfilter: xt_IDLETIMER: allocate timer with kzalloc()
      netfilter: hold reference on module during netlink dump

Theodor Arsenij Larionov Trichkine (1):
      netfilter: nft_nat: fully initialise new_addr in netmap setup

 net/netfilter/ipset/ip_set_core.c    |  1 +
 net/netfilter/ipvs/ip_vs_core.c      |  9 ++++++-
 net/netfilter/nf_conntrack_netlink.c |  7 ++++++
 net/netfilter/nf_flow_table_core.c   | 11 +++++++--
 net/netfilter/nf_nat_core.c          | 46 +++++++++++++++++++++++-------------
 net/netfilter/nf_tables_api.c        | 22 ++++++++++-------
 net/netfilter/nfnetlink_acct.c       |  1 +
 net/netfilter/nfnetlink_cthelper.c   |  1 +
 net/netfilter/nfnetlink_cttimeout.c  |  1 +
 net/netfilter/nft_nat.c              |  2 +-
 net/netfilter/xt_IDLETIMER.c         |  2 +-
 11 files changed, 73 insertions(+), 30 deletions(-)
