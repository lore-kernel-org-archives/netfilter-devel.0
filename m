Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A442BE7A7;
	Sun, 13 Sep 2026 20:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789332906; cv=none; b=MLjypx4HmiKAynxXZOiQlIiHM4PIwsHxq8TFdTURQDeAdCsjsF/S0yQm2WgqUJWEZRjQk76dpUq1aZmOCJvb5G/OMnFzQsWuEkl+yFK6oQssynZNh1G/8zJDLgZadd1X9kMuqXtr0OL7X9hD6nwWKIx5tFWf14lAj8r5ZCvomF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789332906; c=relaxed/simple;
	bh=7CUK2xNPMedlOyG0R+2ejYW2k0dC8Mxe0p7RO16jGbM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k3s0cxrPUM+td9V/1oScp1RRTxzBv71TjGahSnjXORyRh1JDP2sMPL1tMLrI0bfrOlde14x6FZeX54+JgnAV0JywXbpDl8ZCAVMqFVuvWOZ5l+fe+Bydiy1NQFaH8/s3PI7N188gJjMzw4tImDRJdGW7IRkPDDQSGS83tMGlOfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=C9DEamXk; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="C9DEamXk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789332895;
	bh=O/smXKhavSLO+xNr/R94kvvc14yUBUugtF4BD4DwslU=;
	h=From:To:Cc:Subject:Date:From;
	b=C9DEamXkOjWqb5EJdTWcrL7X9uiRvzDSWL1V0PezCuT5S9ZWMkEP8UBp1bc3dmSta
	 L/iUAbL6afBAemg4fZZ7YJYAEXkxmyxSC188ntTP3247g3GHCb7SdgOThkH8PcpA24
	 vjwN3tQuF9v7ILkEEXyIAqvO3o2+M961glsbTNHgzglwHM+sHdVcw+4Z0D83R+gioy
	 l4ET5c0B+XnwPTwuon37uqA6REuW6Q99r9vGWC3LnOnm59mzSqXDJ6eLhWUSSXpKjt
	 hGMGTYb/xaitSnY+IhSQB5TBpodzlcjOURglQFUPMzPJIOpOsuN4QAU9JL6kbyt52O
	 Vy7sDyRGhfjfA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 40B9260056;
	Sun, 13 Sep 2026 22:54:55 +0200 (CEST)
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
Subject: [PATCH net,v2 0/4 RESEND] Netfilter fixes for net
Date: Sun, 13 Sep 2026 22:54:43 +0200
Message-ID: <20260913205447.1889203-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I forgot to Cc: netdev@ in this new PR.

v2: - reword the commit description of the nf_nat_register_fn() to
      explicitly refer to the memleak, so LLM does not get confused.
    - drop the xt_IDLETIMER and module = THIS_MODULE in netlink_dump.
    - keep back IPVS fix as Julian prefer to send a v2. 
-o-

Hi,

The following patchset contains Netfilter fixes for net:

1) Fix KMSAN reports an uninit-value in nf_nat_setup_info() for netmap,
   from Theodor Arsenij Larionov Trichkine.
 
2) Restrict deletion of netdevice in basechain and flowtable to exact
   matching only, from Fernando F. Mancera.
 
3) Fix nf_nat_register_fn() error path allowing for a memleak.
 
4) Hold reference on ct until flow is released to address, otherwise
   access to release ct->ext or different ct due to typesafe RCU
   semantics.
 
Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-11

Thanks.

----------------------------------------------------------------

The following changes since commit 78445023439506ebd83b86d40b1e428a3b309d4a:

  Merge tag 'net-7.3-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-09-10 14:07:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-09-11

for you to fetch changes up to e75a9fa1d44bcbd66ea02e8781bcca6ea4076e0d:

  netfilter: flowtable: hold reference on ct until flow is released (2026-09-11 13:04:15 +0200)

----------------------------------------------------------------
netfilter pull request 26-09-11

----------------------------------------------------------------
Fernando Fernandez Mancera (1):
      netfilter: nf_tables: fix device name and prefix match in hook lookup

Pablo Neira Ayuso (2):
      netfilter: nf_nat: unregister and release hooks on error
      netfilter: flowtable: hold reference on ct until flow is released

Theodor Arsenij Larionov Trichkine (1):
      netfilter: nft_nat: fully initialise new_addr in netmap setup

 net/netfilter/nf_flow_table_core.c | 12 ++++++++--
 net/netfilter/nf_nat_core.c        | 46 +++++++++++++++++++++++++-------------
 net/netfilter/nf_tables_api.c      | 22 ++++++++++--------
 net/netfilter/nft_nat.c            |  2 +-
 4 files changed, 54 insertions(+), 28 deletions(-)
