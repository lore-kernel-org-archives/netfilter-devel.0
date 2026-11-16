Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788227;
	b=Tg4o9heZVZzJL3SZMM5m0QEtAEyh7xRN9D3S7dU1gF7YoeE1DPUz32Bx0zpvDn3VagwG
	 8y0tv93i6B9ccWblfbIzSko6F87hqjFWJ3W5Ht3DeCb4A45mE0jJ0lX2s0IGr8DL61Kr7
	 WsPFyLjO3cbXpuE+YFvYKE9hqUkXZ412xpVQlFqVN8WbYUgr/o5OKb3ZNUNYj+5b3+3aF
	 ZgFTA1yFRJiEuyCyZvlyuP+mW/ppppj9NhmomwhepGZO8gGmUnJRp8JCQDTS9ajJvkIQl
	 KDBkCM9hp538XBYXZW636e71nwWyBdopWuPOoHXBuuztxqWWwYq1Xl1PBXzsEGS9FOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788227;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=IxbUfHTuIUuXNXS9yjXAUzI5jyUz4Mx8VWxJc/reIZU=;
	b=AWmPcMTWZ60ee+BVC+io9/iwZ5DN47dXTviL5DofXDWh1r/NnlKLSQrGm6P57WYcEBXu
	 0hBuKw1c3QPuEpVUJoCxuP3ga8t07+0Q+RVoPgbW/YFZYb+Jhd6AuKcC6zw2heWHSWc9T
	 LCWKV7jrVJZLrk2AH+4LfTxG1IPoLjUEVN+qc/PLA3ghdGIcXtAeNnDlXmluCZu96LLZc
	 Cs1Ffh4IbsN14OymnEjva4DQM0BRSSCOlo2EmK6B2J1+ObGdduOs6dkxGh1PajIoD4i8E
	 +pwJdOkc6wXaWLl1B4iHC99TLuy3rZmAE4NOkn3W3GsppDxmRrE/1RIjzy3oN6GV2Tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZUiOY8eh;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FCC606A33B;
	Mon, 16 Nov 2026 00:17:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79FCC606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ZUiOY8eh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788224;
	bh=IxbUfHTuIUuXNXS9yjXAUzI5jyUz4Mx8VWxJc/reIZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUiOY8ehsVe7CNPHeX+xgqNJbaXbPCHCIO2NpS1XmdYfUfA+aTX8KGAaoXmaqWI2X
	 P8xZEyAagkr6p3YZICk1gqDAfC8cB/M35fJZOgt2AhI8bLgMfNhk5xo3lBpg8C8UBR
	 Glg7H2t4FOEKUyCYEUjXkvVdyUAExS9egniSAt++gaY/s0a/YrVl6hpUIh8Q6fqytD
	 /sR2IUjoE9wAaL68Ujwzmh4ucs4TakeVXKBHhc5f3xz7SY4t6Ejjwx+quUUho0GAer
	 N50K5gqyiyvjyDM5qTg4Jlh/yUY5xDrp82aE01Vtp8n171EKgPsVHtEVh/bJU1HLQH
	 LS39kTSanD1eQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 713D86008C;
	Mon, 16 Nov 2026 01:17:03 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net-next 12/13] netfilter: nfnetlink_queue: make skb writable before writing NFQA_L2HDR
Date: Mon, 16 Nov 2026 01:16:11 +0100
Message-ID: <20261116001612.2806263-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116001612.2806263-1-pablo@netfilter.org>
References: <20261116001612.2806263-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tamaki Yanagawa <ty@000ty.net>

nfqa_parse_bridge() copies the NFQA_L2HDR attribute over the mac header
of the queued skb in place. Bridge flooding queues clones that share
their data with the copies sent to the other ports, so the rewritten
header also shows up on frames that never went through the queue, and
is changed while those may already be in transmission. Call
skb_ensure_writable() before the copy. At the bridge hooks skb->data
points to the network header, so the mac header sits in the headroom,
which skb_clone_writable() already takes into account: a write length
of zero is enough, and a clone that owns its header area (nohdr) is
left alone instead of being copied.

Fixes: 8d45ff22f1b4 ("netfilter: bridge: nf queue verdict to use NFQA_VLAN and NFQA_L2HDR")
Signed-off-by: Tamaki Yanagawa <ty@000ty.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a8aa7ad832c3..862d2a762106 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1830,10 +1830,15 @@ static int nfqa_parse_bridge(struct nf_queue_entry *entry,
 
 		if (mac_header_len != nla_len(nfqa[NFQA_L2HDR]))
 			return -EINVAL;
-		else if (mac_header_len > 0)
+
+		if (mac_header_len > 0) {
+			if (skb_ensure_writable(entry->skb, 0))
+				return -ENOMEM;
+
 			memcpy(skb_mac_header(entry->skb),
 			       nla_data(nfqa[NFQA_L2HDR]),
 			       mac_header_len);
+		}
 	}
 
 	return 0;
-- 
2.47.3

