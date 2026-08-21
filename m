Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38001376A0E
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787309372; cv=none; b=NZHu3AA1GjBJ0g+LgtOK8O9lx4G6LQbd7dJ5nya8Pjc1vkLxbYleiF4VYsr1RTfBqKdONpBmL27CCasp0YBGVFK9iAxUvLhRPUThSfGOk7qgqonwZcbsReFbv7VINwwGJEXCC6U6f1eul8JGaxVAQi7o8kkM0DMT+MqbaruDN/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787309372; c=relaxed/simple;
	bh=IreK9Roa3qTn9qyD7B6IMF3KDfFTXdW8wUBnwI1/85U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngig0ic9Ha1KxdlNM+FT+v07BIoGffEHS23P+1OiVUwzbkga5cim3B2Teqx9BmeTA52MkhI5vICiC4aScxHexzOUaWJIwhwaLBCxlgHg4HAg4BjjxoxyaVcxZyPD+RM+7+jw/iWzubIE/dFD/VLzGR770KuoswZpSHB8K4tu71Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Yuqvfj3y; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Yuqvfj3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787309362;
	bh=eU5w8FMWnMH0/UsQmp9L+z4Y4g4eRt54MXoSghBhfuA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Yuqvfj3ySnAsrCMfNauqnlSdPfKBlcZdvI1NqW9tCWZDRaO/HA5y5w9gCIObNurnf
	 5JxmS90eZYGweZaukEm2noEDLJESsC+UoWouJg0n/DT4xDcaey5zEXjWOcWSrqsFVG
	 PKfAC7PxFy2HKtdgn0J3IzZ3w8ag8ICVuWWJyXZzku3Le0CkqSRjVPBzBVr7sCJUn/
	 MUYgYOUekOdAllfVUTAHfXAqTShcs0Mv2DlvUr/xFP4nc6KKNJZseRMZEo+WwwNmCM
	 UtVTmEtQfG3VAp7O01hJuNRT+ZeHtw4mFjR6dnCIMpBXaIl4Rqg9KDPSnHWAWw9l0R
	 retrHM6UiUsgg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D3D306008D
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 12:49:21 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_tables: set on dead bit when performing early element removal
Date: Fri, 21 Aug 2026 12:49:15 +0200
Message-ID: <20260821104915.15436-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821104915.15436-1-pablo@netfilter.org>
References: <20260821104915.15436-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

.commit call for sets is skipped if set->dead flag is set on, but this
flag is set on later in the commit path.

This also reintroduces the bug fixed in commit 7315dc1e122c8
("netfilter: nf_tables: skip set commit for deleted/destroyed sets").

Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f89605e68ba1..765a92fa90d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10874,6 +10874,10 @@ static void nft_set_commit_update(struct nft_ctx *ctx,
 		nft_ctx_update(ctx, trans);
 
 		switch (trans->msg_type) {
+		case NFT_MSG_DELSET:
+		case NFT_MSG_DESTROYSET:
+			nft_trans_set(trans)->dead = 1;
+			break;
 		case NFT_MSG_DELSETELEM:
 			te = nft_trans_container_elem(trans);
 			if (!te->set->ops->commit)
-- 
2.47.3

