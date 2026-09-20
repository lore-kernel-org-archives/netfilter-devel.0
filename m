Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2D47207E;
	Sun, 20 Sep 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926660; cv=none; b=d8MTgHo+dmOOKswD8Y5TjFTD6WqsbTsVXRNQ84nD8N5CU83Fu1AZeBqd68sB11B4x7c5abuHAXZlaD45wj1q5NFsdGP+IpuU1nuToDDxebDnovnFw+LizkFdd49b9lcHLTx/mb0/pztN+Qhf33DgfsBE+v9s4OMePtcB4xFN3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926660; c=relaxed/simple;
	bh=YIF66qllk6GtYeJ+gCXlEew+S2dXgsn/uJ/jKw126qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lA+kEaVZ/4ABZHO6zjlQjLIpIA0KhJpQdoySIrdJKDNpUZ7R26uqBphINvTU2cNn7ujDrBd2vgWnT2r1s2e+lc7P87huwK8cyRL5cbum8cz/JezJt0tN9pvfqqhQ4/tZ0/6eVeVlZMI+IjWUpbLcn85oNkOdVrZDfL32oCrQBh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuT6B4IH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuT6B4IH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43741F00893;
	Sun, 20 Sep 2026 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926659;
	bh=WEiHJJqTfb53NKSiO3STRwLVThzo4igrI6pvysvlz2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PuT6B4IHXVNDvr43Ky7hmATBjGxsVpCN+yNdTcJ78QdbbIRxQLEwt0PZyAsRZiBKd
	 nCQabesgz4L0RuXtBBXhRyEChPu/FafWfDrLNXoCnLuphDvW8CL3e5buE4FWHMgfeM
	 +Nl7awnyaH9I/Re2o2awgM6N/fg79qJaicx4Xsp+blTjfodFK0/wIWT21DeRTt9TOz
	 pbjuwg1/QLLLNCGuRv48nTusMTe10eyNo3HjFejtFO9Yb690aRRz/opzYv48HmWXUG
	 Th/0JYHPUIaTpWKc3/nIjS6V6HBlqim9q4nYiTT6iqpsQ4d4WIb7WSf2dqSqJ0RLqx
	 Qz7mc3XU+LJFw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Florian Westphal <fw@strlen.de>
Cc: Sasha Levin <sashal@kernel.org>,
	Benjamin Robin <benjamin.robin@bootlin.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: Re: [PATCH 6.12.y 0/3] netfilter: nf_conntrack_expect: use conntrack GC to reap expectations
Date: Sun, 20 Sep 2026 13:50:40 -0400
Message-ID: <2026-09-20-daily-reply-0008-re-nf-conntrack-expect-gc@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918-cve-2026-80668-v2-v1-0-fcefceb49144@bootlin.com>
References: <20260918-cve-2026-80668-v2-v1-0-fcefceb49144@bootlin.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backported two other patches in order for the fix to apply cleanly.

Thanks for splitting this per tree, but could you respin? This applies to the
6.6.y and 6.1.y postings too.

6.18.y carries the bug and has no series, so all three are blocked behind it.
Your 6.12 patches 1/3 and 2/3 apply to 6.18 unchanged, and 3/3 fails only three
hunks, all because 6.18 spells timer_delete() and timer_container_of() where
6.12 has del_timer() and from_timer(), on
deleted lines only.

Patch 3/3 has no "[ Upstream commit b8b09dc2bf35a00d4e0556b5d6308c7b917ebda2 ]"
line, so the CVE fix would land with no upstream reference.

Patches 2/3 and 3/3 carry no Signed-off-by from you.

In 2/3 the new "return false" in nf_ct_gre_keymap_add() is wrong here:
the function returns int on these trees, where 0 is success, so the
error path reports success. It needs a negative errno.

The series is missing 4aa63842fc92 ("netfilter: nf_conntrack_expect: add
and use nf_ct_expect_related_pair()"), Fixes: b8b09dc2bf35, already in
7.1.y and 7.2. Without it the SIP and H.323 helpers re-insert
expectations they have just unexpected.

The Stable-dep-of: 979c13114c0b trailer on 1/3 and 2/3 names a commit
the series never applies.

-- 
Thanks,
Sasha
