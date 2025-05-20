Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BAC1C8605;
	Tue, 20 May 2025 00:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747700564; cv=none; b=RbbFaB+0UM6kMC4D25WJK2MIKfXOEjcy7GntmbDmueRBxHXq6E3DCycnP+HqhVJ3KAE5vfsPxkW5DsedKy2SmJ5DZ8llGyRaubvHV1COsUWPGjF6mqds9X2M1AZYEe4mzMtetQ8uuodFlHTUORoULA6S1f8ZikOWCxWrjdxqIVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747700564; c=relaxed/simple;
	bh=7huG+DwndT5dDctAE4kYkhfL5AkeMIKBNAE7f+axJ10=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EXsLqmXQ0Zneynp5R0p/H5uJzUWZbp+TL6fkl7crdMBMh0e0FLu+8PdC+oqR30LlkzZrlH0zgLRKm5QxthVfv0aNl/YTS9JpxF4XhRrcJN6UcIkvQ2wYoFY3+4OV56vUwhBhxPgtb8embGfQ9QWw9WMMnEG+qnW1NiVRCvm7tIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SLFsbUqT; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=G31sW2hY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SLFsbUqT";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="G31sW2hY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A285A60278; Tue, 20 May 2025 02:22:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700560;
	bh=snGqMuIW9QEdQli9iO5h2weWedMmUrppgBtoQMlPYJo=;
	h=From:To:Cc:Subject:Date:From;
	b=SLFsbUqTCHTGFdT/UZoHC51+We5hzyI+1vjk/8RyuV2Cj8RcGyb2+AYhSycRVOxwP
	 fRfnjNH2MlC4OTTykMipuo+QiWi9uJud4TNDB2JR8BVjQSBJpijnrs1XXwgyxapOON
	 wwZj1A9DAu80HxqcGAp1yEfl+ZpuDOj0RmbAutx/qNYxk1uIa/hyZcQjv9yUTwRcKz
	 Jmd8l09RlTGcUXCCdEaQOe8YAqIsArgkSAp3jW6MlxQ+GXa6fuTTmykLW9NFWpN3O4
	 4bDpm9XXCFD5uA7tvoVUlf6xWYy1Rx5WZIYExQ7GjE+5PpR+KD4LFdvvCGoBze5OF6
	 52vSenMUNyZmA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B67F960264;
	Tue, 20 May 2025 02:22:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747700559;
	bh=snGqMuIW9QEdQli9iO5h2weWedMmUrppgBtoQMlPYJo=;
	h=From:To:Cc:Subject:Date:From;
	b=G31sW2hY4mbzUcuJxAWiqMxhy8vIQZhPJlR8X3iAQcTcyVtf/bxpceTkVyQReL6+H
	 q0ylN8sbeJzH8coNFu2Hul9b5d+jGQOMP9FE2MLd2XqSSD7vC3GIW5BKKzDNSr53xO
	 HmfXpvFtxezlueSHlgxX27GRnPCTw35sFq6Bysxm/OqKPCyhH935BS9ln4llrgdDPT
	 r5huynocQnxxWM8oSerkf5RlFc3EbQZwz0hHv6biF5AcDn/nYw3DDJsyUM6UPY/kDW
	 OnTqAtzHfVdfq2ksh8AJSNYkSj4C7YdQmsNpuUX4njkiYtfshEDdlyqSUo0Cf5sUql
	 801pD+No5SU4w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 0/3] Netfilter fixes for -stable
Date: Tue, 20 May 2025 02:22:33 +0200
Message-Id: <20250520002236.185365-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha,

This batch contains a backport fix for 5.10 -stable.

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

