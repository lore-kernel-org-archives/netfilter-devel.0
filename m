Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794539597;
	b=aHhiHS0Axnlj5y999SfrkSJAdj8is0U0l8C99u7Zou+SVyz3qt4tLAMGOe+zPfVkK4Iv
	 Rz/DZQS14gJu8sUHbxUYh+1w/wSi4t2b7ulvNOMhC4flW/tHYcv+H08xzMt/nyGVJrpRi
	 BfsN3ovJ4SJA/t2++hn/vCB9Hvf8Lhx6tOLbtC302PW8RGU5UeyyDOdBQP910Eiz9hpQH
	 vqX4WrvvFMQH/16IqORnDHRPVSXtAjVc0r6cbhC93n/cO09Je3LcgspKUy58RvJu3UFk3
	 LSHp1Uu2xe30gd0Iik6Hj1uB3AljGAkYI4/bOODBoI86KQAfyVqxi6bDYg7y5/PmYuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794539597;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=IxbUfHTuIUuXNXS9yjXAUzI5jyUz4Mx8VWxJc/reIZU=;
	b=xOLN9K5FBpqhacuHuIqwQiQrht9zLTrHLMfJqd19WxB3BRrdsMMd90Nay1GCFR4sk0tC
	 70RqX+Ngy7z20nrLh0hOovb06NaZwUGvt/cwoAwBnFcFZnbNcJbDiXBC3P/mvC2m/KbE9
	 Ql+RV12KTRbP9DHiKTZwBzIEjPe33hVVR5TdaZ1LSsqtG0tYYl5YmH+5OI6vU8FkV85qW
	 paHoXB0c1LXhlzRE28fL4wgXLKoAKw/XYaY8i7qq+sSV5baUjyqrCgy6EJ3bUUzh6f1ci
	 w/5dVddYHHmYdasRhLF0a+bz7JnRuTE2wlrmEZEff4+mhcfUNi3lvgPEVXX6gSiWyHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UwOI75+3;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BD460A3818;
	Fri, 13 Nov 2026 03:13:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 94BD460A3818
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UwOI75+3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794539595;
	bh=IxbUfHTuIUuXNXS9yjXAUzI5jyUz4Mx8VWxJc/reIZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwOI75+3MpvG+G6T4VdE0pMLvsLvfkJKwxAsruD0W8EXNrDMVAMYn/e5gFsKGJoKF
	 3/brhTqdB0rPO5PMhL0qoQtmIQHsgdQ5NNfubAkIKMbgwQPNmPL+PmzlhHWpkL8kEv
	 mpXrX2CbgpJy/YZ6F56pfWvVkdTYfg82ub181OaZjCy2b5K5aZpYbEtWMqyLZF/AxF
	 TeTwFv+Kgxlo74WUJh8j/tVcDV9l+gQKefJzpOCurFTSyGBl9uHTBEuGYQzHVPDVQf
	 5KzZ99cVQ3uU1xbcODeknYOC6hoAA9+ZFCWCV6YkoFiMs6pUqybf8+TaDYSAP8fy3C
	 /9fMHcGnTmWww==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 77E5A602A6;
	Fri, 13 Nov 2026 04:13:14 +0100 (CET)
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
Subject: [PATCH net-next 14/15] netfilter: nfnetlink_queue: make skb writable before writing NFQA_L2HDR
Date: Fri, 13 Nov 2026 04:12:50 +0100
Message-ID: <20261113031251.2437074-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113031251.2437074-1-pablo@netfilter.org>
References: <20261113031251.2437074-1-pablo@netfilter.org>
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

