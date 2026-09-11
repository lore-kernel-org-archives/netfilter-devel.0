Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0CC46A5F8
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 11:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125724; cv=none; b=QP9CBZlt5hVg4EkNeKFfL3XCx2OLnMS3UspB1yJ/MABuIp6H8/tKbrsHCZKHAHbCdWnn9A22fJr7HNr25ZodApOEKf/A3KhCyS7malcGtPl9hQQQjSdKzFjuWcbstGoAYJ6CL0m8npRhQr7Kgz7RDRLX/fbPIaADwx9iEaDJ2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125724; c=relaxed/simple;
	bh=zzdol0X/wHRQkVjaRHVnrC3I8DrcxoVP5RRUMpBXBBY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=InhdyjtYEkYqFKeEwNQ+3NrO6J/wJ8Sh635eIwON2DERVhwl8YqSMm7CqkM2swdm1tPW7aRf/ljPnYPGqgtxjWHMpRrgHPYMR9Zo4ec+1Uk8wwaXWy6yicd0gjID2u23wSx3kKmlgbNCpObYTAVVPYK/gBBYoYWIZ4RnOabSFt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W11ekwJ2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W11ekwJ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789125708;
	bh=ayzowO38GeqYOZso0R4sroZ8Yaa31vT6veueMfsOcVY=;
	h=From:To:Subject:Date:From;
	b=W11ekwJ2PAwverRn5w4ElP61B6YZlCfC1GL5onY2FED0Veo83L0omHM0SGkBn0Zsf
	 iCMaOpk63mrWkG+rkyV1m0CNZe5ZfkDqvip5bK95ynIREvSMAi4AzXqKuF3GAQKWy1
	 Xdg5MVp5VWe7DkFgH2CBgXh7wM0GSr/iWHNXcohORj69wFZiaTwwX/9UDC5IkCrugW
	 GXI818FBmA93RIGTxL6VURib+SaoTVDuk9aEsh76Ws4qHiTYJs+WCzXvjIstocmg6r
	 BUYGgcvfB1pUBIpFZ7A4fDGe9y9E//zI5oUjDl7mWmbbzf0Eg4rNGn38XJAEhhTzvF
	 qw3krJPiJZnbQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E810C603D4
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 13:21:47 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH net,v2 0/4] Netfilter fixes for net
Date: Fri, 11 Sep 2026 13:21:40 +0200
Message-ID: <20260911112144.1860514-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
