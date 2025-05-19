Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1005CEAD0;
	Mon, 19 May 2025 23:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747697723; cv=none; b=LqtocRgXf/HgSDEK6BuITuWCsUL6iUks3Ef1jh5zRSOxiFBAA/XlSgmYoYepyMSoq0Oyi7lu8UDMq9+ZdPm2XLx8GbTnDNRrq5KdebHgHq/lJaJCM2oPJZ0B4vKmqDusdEL11q1MZoG1GaNmXXWCIb31m5bIdWEbC1vaAwMV9nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747697723; c=relaxed/simple;
	bh=mwxvk2nS0cP0W0mQZMRAqqwKablD0yU86dGk0MyV1do=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ahK/QCFNtRmAHQu21mkfwogjWPB5Kt/KPeZRAsuS+7qdabNAJ6yLYSOolA3iPUfFcp1Czs81CixNMcNj314CF0gp9ge6Y9gRRCtGnNuxcfHQ3ilLy3RCJqTnGUt4T+Z0xbcLsRynTI77v1gF6r8SWszp2pjzCCwPAKdDVFcYrdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ML4PwS74; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ML4PwS74; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ML4PwS74";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ML4PwS74"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8CC6B602A6; Tue, 20 May 2025 01:35:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697720;
	bh=7A+pCP75L3o3d/u8r4zXIQB74I2JVg1hKg+970dAf4U=;
	h=From:To:Cc:Subject:Date:From;
	b=ML4PwS74bAb1eoUgwAZ25xWfJlexbQfJYNul+2nVozvCh89HaYqmLn84Ie57Ov1l1
	 W0dinqw2JjpGWtDhnimYxyQoqfJ1bihP8ze47qjF+rLCeLAGLVmhOP/+6yfX11Bx8q
	 jgWIOgzzcJ5IqZRk+t1qq3Rg+K4Wygo6gNJYfVDvCzUzmWAyS+MyiRL/7xH2oyZRUZ
	 N00fS2f/jsw5xd6efdl+uBktu7Vx4GY3n/B+FK+tHLeXGkj1FmvxEqZ7YEFC/30Rct
	 2YJ8mHdas5JJqk0Ote9ag8pmRmPUgFls2Xv2a5euQJSae7w0GUhewCkyM35k3bOhkS
	 1d6+KADgd+onQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id F0109602A3;
	Tue, 20 May 2025 01:35:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747697720;
	bh=7A+pCP75L3o3d/u8r4zXIQB74I2JVg1hKg+970dAf4U=;
	h=From:To:Cc:Subject:Date:From;
	b=ML4PwS74bAb1eoUgwAZ25xWfJlexbQfJYNul+2nVozvCh89HaYqmLn84Ie57Ov1l1
	 W0dinqw2JjpGWtDhnimYxyQoqfJ1bihP8ze47qjF+rLCeLAGLVmhOP/+6yfX11Bx8q
	 jgWIOgzzcJ5IqZRk+t1qq3Rg+K4Wygo6gNJYfVDvCzUzmWAyS+MyiRL/7xH2oyZRUZ
	 N00fS2f/jsw5xd6efdl+uBktu7Vx4GY3n/B+FK+tHLeXGkj1FmvxEqZ7YEFC/30Rct
	 2YJ8mHdas5JJqk0Ote9ag8pmRmPUgFls2Xv2a5euQJSae7w0GUhewCkyM35k3bOhkS
	 1d6+KADgd+onQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.15 0/3] Netfilter fixes for -stable
Date: Tue, 20 May 2025 01:35:12 +0200
Message-Id: <20250519233515.25539-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport fix for 5.15 -stable.

The following list shows the backported patches, I am using original commit
IDs for reference:

1) 8965d42bcf54 ("netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx")

   This is a stable dependency for the next patch.

2) c03d278fdf35 ("netfilter: nf_tables: wait for rcu grace period on net_device removal")

3) b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")

   This is a fix-for-fix for patch 2.

These three patches are required to fix the netdevice release path for
netdev family basechains.

Please, apply,
Thanks

Florian Westphal (2):
  netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
  netfilter: nf_tables: do not defer rule destruction via call_rcu

Pablo Neira Ayuso (1):
  netfilter: nf_tables: wait for rcu grace period on net_device removal

 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 54 ++++++++++++++++++++++---------
 net/netfilter/nft_immediate.c     |  2 +-
 3 files changed, 41 insertions(+), 17 deletions(-)

-- 
2.30.2

