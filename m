Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD000371D01
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 11:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787311158; cv=none; b=uhKZicIShPEi3LFmEqMEak5VZux4957wDTBro7S+xULHeC6rLMDVQud32MO3PFoUxXRpd0dh9m4s2o40JSkORJyzXfMrdV9llaNzjSlWbXtix3id4vWudN/Lbwb9+btnQIcLyF+EoO1JgqCiBt53UOTV/+VsT35A2x7TQTW9Dfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787311158; c=relaxed/simple;
	bh=IreK9Roa3qTn9qyD7B6IMF3KDfFTXdW8wUBnwI1/85U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nh0lMEMZ1xMUwHHU9LYJGcPL8DKoW4iYiq2t7L+ZrdF+jhNzuQZ+hI6OVBg6zjIHc0o9+AarH/f+AgQQP2rk+A1zRKMeCIqoYLH29p2MVtPb6G2aqQXZPYvGESlCv/pk3aPvfnojTgMyu7hwa+AZ22yGskO+HXVehIUx38Za9j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nQ6Mcocw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nQ6Mcocw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787311155;
	bh=eU5w8FMWnMH0/UsQmp9L+z4Y4g4eRt54MXoSghBhfuA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nQ6McocwfKmFDNZj8WFQX/zJQ5Ik5Pq/XJiIMHwk+dxlHpIwqAuYIyprwK5ZMXlNL
	 tWNGemDv/GZ1sJgZ7qAtDlr7zvHYDsCNAhoiIkFoVbYR4PtV+7CCKe3WTV/fB/MWrP
	 17Il3m7mqD5S+1YqKfqfyW9+IDsPRoMFx5HgdOqke0lJKjLItsHV3hXPtnbPZ2K3oW
	 CrGPOt8MUHv6j3eIiDmetDanIp/iAHzdV54tK5PokO6/fNCNc+OdVT/xkRFTvo3ngb
	 t8W1bouJ9IzOhMCQmis5emoQwOyu+pV+CxtFh9l0ytmcoKCto38ZTjcz+MbvberDpT
	 YDXf1Kl2CT5LQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EBE486007A
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 13:19:14 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: nf_tables: set on dead bit when performing early element removal
Date: Fri, 21 Aug 2026 13:19:08 +0200
Message-ID: <20260821111908.20422-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821111908.20422-1-pablo@netfilter.org>
References: <20260821111908.20422-1-pablo@netfilter.org>
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

