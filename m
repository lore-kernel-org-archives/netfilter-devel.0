Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F912126C07
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2024 08:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727686418; cv=none; b=uqr/9k6+1A/xsbUe4Jz5mGcCMjkvJzKhrWzi17+wFE43QV7IDUYtGxMmq/loQWXCQI9xh4L0h+FSNmd3ep13+K36JHkgIB3RBAJAV4A6wIRW/tRT3kAooVF+wcRNU/2sMFM/MUY99/LUkxGMZkogb+L7FNNB067rgBv5+AOpCVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727686418; c=relaxed/simple;
	bh=btSlzv4zyHp1gkjFsumioRsweh8UbirfQ1mkgqRF9ws=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CnBinxibZCDNFjsg2J5JJnItuvGGtopAtcZgU7p/9db/06vIQ9FW0NUxlO7acVvXHjyqwS8Lzn3GxSHjVsCdpdKLOx8ujEeVM5ag6DryWIg9m5jMi9G2zA+SK84r5BIYPDN6Sk6y+HBfI7xQ/JGTLz0iS+hWqeZcmIERpdbxrto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/bsYeMg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/bsYeMg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB9BC4CEC7;
	Mon, 30 Sep 2024 08:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727686417;
	bh=btSlzv4zyHp1gkjFsumioRsweh8UbirfQ1mkgqRF9ws=;
	h=From:To:Cc:Subject:Date:From;
	b=r/bsYeMgXSB4f7fV2Je971S9EazpA3fjh/kriciRScS9ceAYqiYyGaHcOFj6BT7Lw
	 hma3XuFGFpYMKJRQWDygEnBh/vB4P+5A0bHJm4ctPYGfEux5sMqiMK9ffmXGtiUt7z
	 KYAxOKKSV3vAGnb0gcJPfVVw/2Fwmgg3ACzzs6a0JIXS/hjxLsUWRKgURUVAj+7b7x
	 uWi0x8lMdk61catSCLwiAkHoX0wD5x4htmp/wDobvuOHssJYEbCrIw+wQSvKtbygL7
	 oqwXox9ULE+Wy/4E30wZ7+zczpukJ//p0oyvfjFWtfgEk0+Xpdb0Virl5EUWAVba+c
	 urkMN+ioeHvQQ==
From: Hannes Reinecke <hare@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Michal Kubecek <mkubecek@suse.de>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH] nf_conntrack_proto_udp: do not accept packets with IPS_NAT_CLASH
Date: Mon, 30 Sep 2024 10:53:26 +0200
Message-Id: <20240930085326.144396-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit c46172147ebb changed the logic when to move to ASSURED if
a NAT CLASH is detected. In particular, it moved to ASSURED even
if a NAT CLASH had been detected, with the idea that they will
time out soon (and then the state will be cleared).
However, under high load this caused the timeout to happen too
slow causing an IPVS malfunction.
This patch revert part of that patch, as for NAT CLASH we
should not move to ASSURED at all.

Fixes: c46172147ebb ("netfilter: conntrack: do not auto-delete clash entries on reply")

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 0030fbe8885c..def3e06430eb 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -116,10 +116,6 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
-		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
-		if (unlikely((status & IPS_NAT_CLASH)))
-			return NF_ACCEPT;
-
 		/* Also, more likely to be important, and not a probe */
 		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
-- 
2.35.3

