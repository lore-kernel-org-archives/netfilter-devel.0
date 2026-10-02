Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14033447806;
	Fri,  2 Oct 2026 21:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790975449; cv=none; b=d+fVY9J28oASkv1N/coR3VuL90ol6m8zj25MXcISMQajeZIDB+WHqiPlbZRYWK5WhaAanjF8pF8MBC1NeDf1Akkxn/gXETKoSCosj7pY2tl6loot5h/tx7Zc9pTX0/3qDWIRanrIX+rhIYuqTz+rxpQPEsnGDfv/KdpckepbVT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790975449; c=relaxed/simple;
	bh=uMQxJiedh5+aMpCouv/cCBo3FkLZHIU4H/N88t8Eol0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOSD6WCA7mZLikY9zBQ7nmLo+TgDEbIsHYvDjqa4Jv5/YPJBhn8z2KHnURtxDu6Nkj8n3zqym0CIf5yt5jcJSvjsColLwCKMQPgVO7AoDWSpxH3HwjMt4JVAeizsrNZKQhCKwo+6phxMPL32u0CfY7aj8kirezEx0Cfz2dO4BNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KgpUlwsO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KgpUlwsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2CF1F0089D;
	Fri,  2 Oct 2026 21:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790975447;
	bh=Xn7dPoylcas1ZooXl/0zpUpitso8fpXQksjbXJ52BZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KgpUlwsOxXQ69ZoA8Uu4jacEkvGi5bzGvkTEwwDxOURHCYSPQxAyj6rExM0YPfkZp
	 hEKrdtNepVcypbgxpi9M7MgcGyxEe41PwP7p2US6D7q4FWvo6Aydpm2GFPkAGLaqvx
	 fIXBb0B/Z1WqP/SJCZW5TaoAyYswZPQuI0hiWaPJJEe2OOb161XPIfrpvphjJGRAyX
	 xC02g5vAKqlOvwHVjeRWPqWS7XT/Yl00VQw9vczPMnzI5XGcQr7ddNHfz59qyexG+Y
	 t8W+oL2+PtuKU/UoSNOttshAh3GEv+PQZVhiv6OslcAmWGKpQX9j5bFSIS8gf+g45C
	 mVK0e/n+wUvvg==
From: Sasha Levin <sashal@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Sasha Levin <sashal@kernel.org>,
	netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ma Xinmeng <1564938642@qq.com>
Subject: Re: [PATCH 6.1 1/2] netfilter: nf_tables: allow to create netdev chain without device
Date: Fri,  2 Oct 2026 17:10:34 -0400
Message-ID: <2026-10-02-1-daily-reply-0008-re-nf-tables-netdev-chain-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <tencent_3EF2E566E214C1068698C581DE374E1E3C09@qq.com>
References: <ar4d_JbuojZJuazs@chamomile> <tencent_3EF2E566E214C1068698C581DE374E1E3C09@qq.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is a 6.1 backport of upstream commit 207296f1a03b; the hunk for
> nft_delchain_hook() is dropped since that function is not present in 6.1.

This series only brings in the prerequisites. The UAF fix itself isn't
in it:

  fc0133428e7a ("netfilter: nf_tables: Tolerate chains with no remaining hooks")
  375f222800bc ("netfilter: nf_tables: Simplify chain netdev notifier")

2/2 also adds b9703ed44ffb ("netfilter: nf_tables: support for adding
new devices to an existing netdev chain") to 6.1 without the later
fixes for it, none of which 6.1 has:

  043d2acf5722 ("netfilter: nf_tables: drop module reference after updating chain")
  7eaf837a4eb5 ("netfilter: nf_tables: Fix a memory leak in nf_tables_updchain")
  1e1fb6f00f52 ("netfilter: nf_tables: reject table flag and netdev basechain updates")
  216e7bf7402c ("netfilter: nf_tables: skip netdev hook unregistration if table is dormant")
  688c15017d5c ("netfilter: nf_tables: don't unregister hook when table is dormant")
  4ffcf5ca81c3 ("netfilter: nf_tables: use rcu chain hook list iterator from netlink dump path")

It also needs the netdev chain parts of a6134e62dba2 ("netfilter:
nf_tables: join hook list via splice_list_rcu() in commit phase") and
cf5fb87fcdaa ("netfilter: nf_tables: reject duplicate device on
updates"); 6.1 only has their flowtable parts. Without 043d2acf5722,
every base chain update that carries a hook leaks a reference on the
chain type module.

Could you send a single 6.1 series in upstream order: the two
prerequisites, the fixes above, then fc0133428e7a and 375f222800bc?
Please start each patch with its "commit <sha> upstream." line and add
a cover letter. An ack from Pablo or Florian would help too.

5.15 and 5.10 have the same UAF. Are you planning to cover them as well?

-- 
Thanks,
Sasha
