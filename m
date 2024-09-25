Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3CE1991BA;
	Wed, 25 Sep 2024 11:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264302; cv=none; b=BGL56fTpL6Il2l2yXt/jPVmrg5Lr7RjbMwKlH6JtWTpZMsumRCYWgV+e2TNc2vPd+sT1h2wNL61+yusULmkuQ+PmoRZSWl0W8p/JiQojbEQeVHk/BY//bChkEPs5AhuiMDlbhICExevlK5VFraB5Co/f89InraFvA6QMi8x3yow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264302; c=relaxed/simple;
	bh=IGkEYTcWB1iSZayrlGRyGBAcMDd3GmfLmIovV+2stys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQ5u8gCN61UBZHp4/hZePrXCOm6g4y0i3joi9fcB78wEAAiv2W5c4qtHHFGUMQ0vhjaLkSl4WDoX6C1Z+6wVykZJiPeb5swCIH5t5O0cwvtIdj8JsMGMXIR7jH1nG3VanS6DL6MxhqvIy6Xqf57q2zdOKhPx5CJwWPR5xc/2H3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHqJ3UH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHqJ3UH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E76C4CECD;
	Wed, 25 Sep 2024 11:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264302;
	bh=IGkEYTcWB1iSZayrlGRyGBAcMDd3GmfLmIovV+2stys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHqJ3UH0cFxtTQVhbgUwW/70/cnrr2D7U57hp8/KriuSu3KinkCK8ptP/IvYHFD/d
	 80swnT/IXD8VvSVh4eOsm3hT0nu5j25jZJSmJxVeL05C2lQJSvHed1pP2g7eLYoEBD
	 0S0gUZYmUWre0AEWxwd2GpHogvE+MZRfAimj5VFzVqlA7APPdWAc4bz+mm1aQXJOjX
	 Sjc3YBXtNYsj+Ekde4ozQR8kumVfIpCG1lBz0eHZ5q/wjLCWdTsm3cTL2R6P4zhigL
	 93MsBw370CLaFRQjvRSGpo7t4q1dtee7pNNBZ+DsePi2qW7C/H8klZB71P95Vu/ZPM
	 Db8RHj7DZ77LA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 048/244] netfilter: nf_tables: do not remove elements if set backend implements .abort
Date: Wed, 25 Sep 2024 07:24:29 -0400
Message-ID: <20240925113641.1297102-48-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c9526aeb4998393171d85225ff540e28c7d4ab86 ]

pipapo set backend maintains two copies of the datastructure, removing
the elements from the copy that is going to be discarded slows down
the abort path significantly, from several minutes to few seconds after
this patch.

This patch was previously reverted by

  f86fb94011ae ("netfilter: nf_tables: revert do not remove elements if set backend implements .abort")

but it is now possible since recent work by Florian Westphal to perform
on-demand clone from insert/remove path:

  532aec7e878b ("netfilter: nft_set_pipapo: remove dirty flag")
  3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
  a238106703ab ("netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone")
  c5444786d0ea ("netfilter: nft_set_pipapo: merge deactivate helper into caller")
  6c108d9bee44 ("netfilter: nft_set_pipapo: prepare walk function for on-demand clone")
  8b8a2417558c ("netfilter: nft_set_pipapo: prepare destroy function for on-demand clone")
  80efd2997fb9 ("netfilter: nft_set_pipapo: make pipapo_clone helper return NULL")
  a590f4760922 ("netfilter: nft_set_pipapo: move prove_locking helper around")

after this series, the clone is fully released once aborted, no need to
take it back to previous state. Thus, no stale reference to elements can
occur.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0a2f793469589..ee428997a0731 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10782,7 +10782,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = nft_trans_container_elem(trans);
-			nft_setelem_remove(net, te->set, te->elem_priv);
+			if (!te->set->ops->abort ||
+			    nft_setelem_is_catchall(te->set, te->elem_priv))
+				nft_setelem_remove(net, te->set, te->elem_priv);
+
 			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				atomic_dec(&te->set->nelems);
 
-- 
2.43.0

