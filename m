Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7990C24C08A;
	Thu,  3 Apr 2025 11:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743681486; cv=none; b=aGLLyjTJS5b+aUvllyaKDYCCQMgyeOiUqRT8lUHs7qXbnYH+Vy3nylMCBnNhNfBahCDfO2Y9Lr7mbf6GZO8Vm9PKE5ZJ0LUz1bUgPGB/HFsAinYzQ0xI5/nw/uePi5XkM+GCN93V4edD8yXaBuPevs2x8p17bYCbwO6UabEZsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743681486; c=relaxed/simple;
	bh=BZSEIcPDVgue+kWdhRGkx7XFNZAIaTtxTIT3Ou6jJGs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oYhBikg6wFv3+NWWMjj9rYleyERK40aWiUA0koR2VJ+pwl4qhRfBuaJf2TmUsmQiQWb+MWbTVRQI0OtnhzGxFI5ZEbVPS40pz7uAdKMqi3VlSVERIGXb3tN3EtU8dLuPSAUlSSRVRc+8Hn804LywiuFeKJ3fE+CCxEbeBEj7fDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FuxlYov5; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qDvpy8UF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FuxlYov5";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qDvpy8UF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7B6C860645; Thu,  3 Apr 2025 13:58:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681481;
	bh=gRcqbrxOs8E+UCpi55/AKva5s6oFFzo3AKH//MIjJMs=;
	h=From:To:Cc:Subject:Date:From;
	b=FuxlYov57hHtXo7xTOOLiQyrpiaqfEbf8yOjXjKBXdpbzM55cbFAnEN2gBo/embCD
	 M4BEYsuwXXHABRXWpuvvfd2eserOeMOciOUiihMgfPtZ9PCeZITesc1Cu5HXG3w8ju
	 VrPUEgmdy47shvnwtfz1KH5VvQmI9InwvTesoBkCFHW8QedtCKHvtz2QT+a2yStlDK
	 qrxfUfdf3QwEdFVtgz6EOmrIzrh0MtzEljdBPz8c7nKDbGPutsjUfku2jPAqKMWYf6
	 n5QoViLW9lvbilYEoVNK+x0Bbtxaq/YttnjHmT4svsEERlcdh2XlOdjkNTtftvkRLh
	 Iro3Va4QzaDIQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 58B2D60639;
	Thu,  3 Apr 2025 13:57:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681479;
	bh=gRcqbrxOs8E+UCpi55/AKva5s6oFFzo3AKH//MIjJMs=;
	h=From:To:Cc:Subject:Date:From;
	b=qDvpy8UFnMI02gn5+sW+VeqAVWesT6z/cUQRkIz24XvYq9f3hfwlq/jvSvHco7L8E
	 YNTTDg8p63YmSoKGn7Ug7SNUsYp2I7qo4146KIU6CIh6KbVRl3GwCoKLoBY+bsPEPC
	 6uEr8jR1onHJOdTvkOALQ8S165vLaSVGxR3AWk5k6UPEeI37UKCr29k/7EhJT3zkbd
	 RSMG+Iq2IUXijzUIV6j0/vtIZOQ8KaVS5/L1BCupnCBnaRt+tISf7musSETZbM9KJJ
	 sjmXgNP4dHu1rjoH4Smlc2XwCiGU9TGWZtiJH/LAoxI2xvtluQaipBB5lh+ehslFiO
	 f3kJylYTFrLig==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 0/3] Netfilter fixes for net
Date: Thu,  3 Apr 2025 13:57:49 +0200
Message-Id: <20250403115752.19608-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following batch contains Netfilter fixes for net:

1) conncount incorrectly removes element for non-dynamic sets,
   these elements represent a static control plane configuration,
   leave them in place.

2) syzbot found a way to unregister a basechain that has been never
   registered from the chain update path, fix from Florian Westphal.

3) Fix incorrect pointer arithmetics in geneve support for tunnel,
   from Lin Ma.

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-25-04-03

Thanks.

----------------------------------------------------------------

The following changes since commit ed3ba9b6e280e14cc3148c1b226ba453f02fa76c:

  net: Remove RTNL dance for SIOCBRADDIF and SIOCBRDELIF. (2025-03-21 22:10:06 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git tags/nf-25-04-03

for you to fetch changes up to 1b755d8eb1ace3870789d48fbd94f386ad6e30be:

  netfilter: nft_tunnel: fix geneve_opt type confusion addition (2025-04-03 13:32:03 +0200)

----------------------------------------------------------------
netfilter pull request 25-04-03

----------------------------------------------------------------
Florian Westphal (1):
      netfilter: nf_tables: don't unregister hook when table is dormant

Lin Ma (1):
      netfilter: nft_tunnel: fix geneve_opt type confusion addition

Pablo Neira Ayuso (1):
      netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only

 net/netfilter/nf_tables_api.c | 4 ++--
 net/netfilter/nft_set_hash.c  | 3 ++-
 net/netfilter/nft_tunnel.c    | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)
