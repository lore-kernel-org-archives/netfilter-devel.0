Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80DF483CB4;
	Thu, 13 Jun 2024 01:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718240559; cv=none; b=Y0xa12HmJb9rVP/xDsGuxJpQQjTaqpA1IXUDkJUeFnSncRF7qvdHiVISryUHqAvwX1XHC3N+uvPkeBxSWthB/aAv432chfs6twBAG7Y0ig/Pmk+tCGpYKu5ic+BHwla9Pjd7mBM1Ct66OiJbVbJY2Itrxx3uimoF27Kf1qZEzOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718240559; c=relaxed/simple;
	bh=wBPfI/H36hGTuElBVwc4XdCgoEIlpfAVqjRseEIpLBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f2zRSzSF0hwlYxPH3ESGzpfLtIYOGa2BtuH1ih+EMG5+ZHHw66DtmPLbHNh3A0g5f3WTh5NW+HNdus6/BycoW4/iKIeZsaqDcvDbDTpSXXk2HiLW3czLlhwF1NFb6/LSSu3R7KMeM/oye50yQvQRB3/Fwnnjnxu7X1S4KbzBuxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,4.19.x 31/40] netfilter: nf_tables: mark newset as dead on transaction abort
Date: Thu, 13 Jun 2024 03:02:00 +0200
Message-Id: <20240613010209.104423-32-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240613010209.104423-1-pablo@netfilter.org>
References: <20240613010209.104423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 08e4c8c5919fd405a4d709b4ba43d836894a26eb ]

If a transaction is aborted, we should mark the to-be-released NEWSET dead,
just like commit path does for DEL and DESTROYSET commands.

In both cases all remaining elements will be released via
set->ops->destroy().

The existing abort code does NOT post the actual release to the work queue.
Also the entire __nf_tables_abort() function is wrapped in gc_seq
begin/end pair.

Therefore, async gc worker will never try to release the pending set
elements, as gc sequence is always stale.

It might be possible to speed up transaction aborts via work queue too,
this would result in a race and a possible use-after-free.

So fix this before it becomes an issue.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b23d7c3455de..29a782e9ad07 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7254,6 +7254,7 @@ static int __nf_tables_abort(struct net *net)
 				nft_trans_destroy(trans);
 				break;
 			}
+			nft_trans_set(trans)->dead = 1;
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
 		case NFT_MSG_DELSET:
-- 
2.30.2

