Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C120A19E968;
	Thu, 29 May 2025 09:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748510325; cv=none; b=bL2a+tpZz9QZnqH1Imshy0gwJp1hDCiWws8wYB5I6gSCK4jBFJwhzNEDKIx/niVFhAtaUIQJkwrEckZJexkNHdSaaMHzpmcgJW5pTwUvJC1S893HZ77Cv63/9j6kdnsmk+RbmqsegoTjP6oRDZXu+aBzY9JPUHTwHfjjJTFLwtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748510325; c=relaxed/simple;
	bh=Bxi50n+i6fLfTEC4kfxjmy4Mu+WM6qkTH49bIrIqQyw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=S+BrPvWvEk57ScvDipbuY97ylCZ18eEypJtQPWgN8qKFKPhEBynKulCMpVkyIe0tRK5q4ul/+4bj8SZdH8G4Y5YG3BwVmMhXo+Pp+wpcTXDOxWZYnsDibjx3fZkvrOcptUTX3Tazh8+22nG5R0MmG/q+8I8b42bCbGqT52E6ECg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=VMvwbeFg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mSTg/UYB; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="VMvwbeFg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mSTg/UYB"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B25116074E; Thu, 29 May 2025 11:11:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509909;
	bh=0KzakS5/h8R3g4Y1T3M4IPvVMv4pzN9nP3So+cg8GJU=;
	h=From:To:Cc:Subject:Date:From;
	b=VMvwbeFgIBw6xBaVo3v/nBQcBiuQuEOQ2NiQxUZi9fyHUkwtgKasvUZu6753U1GBg
	 mQYXXM7R3w1mlkr9yANJ4ZCu17A4+v11gn5PYPQoA9ZmK9CUDROyQhGoXKDJL9yYuI
	 NwqARQ9T6fy7aVEYeFN7iqCY1zD8uAx7vE0xt7PDT6FqOxjWXpCZgwtEFur5d7oJhY
	 nbRmAUTvTNzlq6ms0F2tbac9guLuBlhd6Bh7v4k+jXkIVvJF4Q4ktXLeLA0XcUtt1u
	 St//rRFvK86XaHVmV/pxgddXDPObHti8/YLIQgujQcgm6hV7E8Wqt+MnjQcshLq+ML
	 /3ylmWumgD9IA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CDC7760747;
	Thu, 29 May 2025 11:11:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748509908;
	bh=0KzakS5/h8R3g4Y1T3M4IPvVMv4pzN9nP3So+cg8GJU=;
	h=From:To:Cc:Subject:Date:From;
	b=mSTg/UYBF0nRk0HF3a2rB1DWUh7LPBZhYwJoNiSu8gWrgiXIcmPgmfnsTI4HqF72V
	 xpP50Jx5/FRl7b2k4QkZL3o/tHnIf73P5KbbxT8AZysQTTxyZ453UZ2HHDbXGKyjOc
	 Fuyj2v4CjOj/I0AhW9xd/bpBmAUOvjtEYJSek2ECYEo7wW2T5RFm1Tb4YggkLfqQ3K
	 +FsMLSRcIWoaOZBuc5/yRb7vB+GAbTN+y6yPRFsVG027ji3zNiaruQz8LWOcIGcMTk
	 qpmoRkGCEVCcR9QY+D2sGcO13DvbF1o9DQ0qXgLqYa2709jj4nH/d0ycvhF41p434q
	 xMZgt2tASUOUQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4 0/3] Netfilter fixes for -stable
Date: Thu, 29 May 2025 11:11:41 +0200
Message-Id: <20250529091144.118355-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport fix for 5.4 -stable.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 8965d42bcf54 ("netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx")

   This is a stable dependency for the next patch.

2) c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")

3) b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")

   This is a fix-for-fix for patch 2.

These three patches are required to fix the netdevice release path for
netdev family basechains.

NOTE: -stable kernels >= 5.4 already provide these backport fixes.

Please, apply,
Thanks

** BLURB HERE ***

Florian Westphal (2):
  netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
  netfilter: nf_tables: do not defer rule destruction via call_rcu

Pablo Neira Ayuso (1):
  netfilter: nf_tables: wait for rcu grace period on net_device removal

 net/netfilter/nf_tables_api.c | 51 ++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 15 deletions(-)

-- 
2.30.2

