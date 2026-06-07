Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C19F388377;
	Sun,  7 Jun 2026 09:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780825814; cv=none; b=ubdsQQLv0kRy1ac462zxIEaICVtzS/spl935uHQQ/Ez64Ockeu7/rxsdT9CQF+wO7hJa6ebX6GKQuf6jAlQJh0Z9jJQo5Ijv40gM3wIO9mlvZrsegeoyqM8hTL6DXjCp/9yq1baKjv0aZz5UR/UArQ7d477SLe/tYNUI3w6I9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780825814; c=relaxed/simple;
	bh=r6XVNNevodr/Qf5nghpUnC4KVUsgrIhmsQ5r+Ops7cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLj/GVXSZ5Ebv524UaiLylS24wwrpQoD308pMuqpWLmHqTTB3+loibHFl8y5Ns9uhOnvg4b0vIh/7j79KoPywrktARXt/cjx4h0p7+CNyAVq/alEtUX2BHQXbwSLiGjG0soTetRGlYCMQJrSeBpGJ7p+79CfkjG1844QRecK7uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YuGQE/KX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YuGQE/KX"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 458C76019F;
	Sun,  7 Jun 2026 11:50:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780825811;
	bh=LpROazS+3Hqc0LGSuu1bo1YWIbwm9n7EyzJhfF6K+u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuGQE/KX38XgyPyuzhtHqTu9y5NLsYXPnkFHETgxOY7FMy/kvq95yAgQufCvr3yoP
	 xU0eezBREC4DKV/zYV4Mbcp/oz/MPjZeoArWohJUhKrcdKTtjfYnYr+FK+brou1eRN
	 bD/w95chriUR41NM06nJRSaGA8c3r4HiGpS0waA7PPkuffifO9vIwy5P3KZo2Q0Ux3
	 2E2tT15KAc1FIkYCCqDVeSD7AYeiTWBoC33NcLSXIXZEuh5GI1En0uYqdTPHGx1mgj
	 wx6XuICijsuvHxX3zCPBiA1a7WZcPlgIcUpqM9WVovYNPNDbIqql9X2FSlCMZxJG4L
	 URDxkCglQqyxA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 07/15] netfilter: synproxy: protect nf_ct_seqadj_init() with conntrack lock
Date: Sun,  7 Jun 2026 11:49:46 +0200
Message-ID: <20260607094954.48892-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260607094954.48892-1-pablo@netfilter.org>
References: <20260607094954.48892-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

nf_ct_seqadj_init() is called without holding the ct lock. This can race
with nf_ct_seq_adjust() when a connection is in CLOSE state due to an
RST or connection reopening. In addition for SYN_RECV state, concurrent
processing of packets can trigger nf_ct_seq_adjust() too. These
situations create a read/write data race.

As synproxy is the only user of nf_ct_seqadj_init() at the moment, fix
this by holding ct->lock inside nf_ct_seqadj_init() until all is done.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_seqadj.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 7ab2b25b57bc..b7e99f34dfce 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -17,12 +17,14 @@ int nf_ct_seqadj_init(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	if (off == 0)
 		return 0;
 
+	spin_lock_bh(&ct->lock);
 	set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
 
 	seqadj = nfct_seqadj(ct);
 	this_way = &seqadj->seq[dir];
 	this_way->offset_before	 = off;
 	this_way->offset_after	 = off;
+	spin_unlock_bh(&ct->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(nf_ct_seqadj_init);
-- 
2.47.3

