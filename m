Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794867989;
	b=wka99BlYJvIy4McjoA4om8VbxtZLDmDV1EfBTLMVgyDgYkfA/tukXN7JMmDv+VY4Q6Vz
	 HuRdhElgFMtTSjzEGwDh67Iy4ku2rmcUj3FNKlucVsa6ffhLbSsY1Cpq/0GjzuElebGHu
	 dW/lNGIFKnXMXdWo69uKoeUj17LamDyN12e1kiViQnZJ6SkxGTqvdY7w5o8Cnznspxk27
	 bP3vdBn2hJiMAiOkhX5G0zEK20HyWkGbaenxrIRs28kQVZLRIPFh7fxhazj8Xp5pi7X1n
	 V2Zln/Qp4TpDyiwePAQvmegVo5lsQcDXiDvOXFERRZ4zSkvBw4HOUKulnNFyhMss+AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794867989;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=WsVmZB0UH8bgbSx0D+T0vzINQcKZFGUzB4qEYlW4WKE=;
	b=WAMJtLMtVwW8LPvYcxeh8ps8fUSZ6ykFLce/ZFME7E2eL8ocbp833+/S1psWluFcPewL
	 p/8mZcd4uXbfXnKxt1XA386yzo7YWkHz6sHGrKRnpg6WOSS8vYeYPAtSFkVplgYgyKwXU
	 b8dNGlKUsZJJR8XD9b2q8YqoxtRSE9t26Pht+gGheRl2tVEN8QOQhhbWz9+IL656qkEQa
	 K55aJvGWckRE16c8AgiU4OILdmO3qjGO0eJhqtIm302YCRHuwBO1OmbyRAKXpdL7vXkgy
	 7qnkF71rfPsCWDY29gRfsaPSeCZTlnEliOHseCaQJLu1rQNkPW6s1AzZjAL8zz/lE6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hIr7GbNK;
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87406606A338
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:26:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 87406606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hIr7GbNK
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3b0e61a4decso4418577a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794867989; x=1795472789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WsVmZB0UH8bgbSx0D+T0vzINQcKZFGUzB4qEYlW4WKE=;
        b=y8Z3p2k9KHf/caoc7qUgPee1puC9YCSTQHK1s6ZG0pSdf4ltFuAmypuOUctOa83Mis
         FCyiBamUcSMQzlH7m3nE796+sH+DGNbn/+xta+zuq4HG0wwvOR9+B+UZ0SZFOwnRxleo
         hGshORsq6Obkbj+srqvqpRRAn33fK6X9a+PEdeGgladBGannp3SjSiUt2ZJCRVwOLewk
         Jj7YmpAjH+iaqL5kcruZfYgKVcGpUlRgNx9ateXxshMWuyVLgrbcBJtKNwp04l1c/7t/
         eg559q/C2DyGzw1wChgBR+god5iMAj/OVIGh1UjSdSPUVLFsvX9otB4i1Aoh2jsUhM/0
         XQ+w==
X-Forwarded-Encrypted: i=1; AL+hErHAo8zh04Nn7NNZSVBLpD5MFnAxqKZKsGMibB35sK3dhKChwgzLU+wkGhPbLtcrF4K7YSNw1gPfLLLLsu/eOmw=@vger.kernel.org
X-Gm-Message-State: APuU4Z886jmkL9YSbdaG6twTk6hO4w8PzZOKPV/fINKndh9C/A5LryOk
	SS5XsMu0i5pBLtv6d3GZJ/7MyPjuU85DNy8uz+VjUrDM/yrz6UogvSCx7fHEGQUgtxfbTRfUUP9
	f+/uxuSNRRyQNolJ+dWCrRquR2uBoqMENAe/QTrRey+n/iiuCBeqeLXQX/40OvzEKHlo7hAcHeF
	FwSkWWg7bN3qYazhpSyowfzsIRWDKZN2GHjFCzoZXtSABGzlBDYhEaKXKEp4QexMoxjLTmAUUFk
	qFQEl6GKlEA4KfMGXFG18nZBHED
X-Gm-Gg: AZFdTZflHIugwvwnapgyyN1VI8UC58Hj4k+JFpdfg2LRbCZGXpSnLOqGJStRMGB+TZE
	PAiTJoB5aVNIrQaWP/HaqwjKBRW+ArWJpJg2eCI55RzcuctSricMhE/ZC/yldmfjCpoHox/LiQQ
	AijBr5INVbEGqn9VJOuOI1I8raksGW7s2owzLTFWCxTPdszEjlyx5i2k2CEwVMMNBs816NwxmCW
	muLyE0rlijT6yhBI/YY1QVa0ck8IHe4cTDP/PCIjXXjnNDATtdVKcnj8vP9zHJwJJLk2D7xTdVN
	ds4wYk/X2CcEXka8weE4m0s3T0PGWdyjJSlYcr5b6/D4XRpcax5VKxFPC8y0MnxwLDk28WL1XGZ
	/rCQhDqh9ENJL/ERO9C40kH5AchFXE5o0QXFJeKAPvT4pKJO9o57ttzGZ2d5Xiets1sXnaZPfEC
	AVrUussOAIsJWWf/BjUlWqKFQLqAqwgWaZj3w+EMl1cNM=
X-Received: by 2002:a17:90b:1f81:b0:3b0:a38a:6715 with SMTP id 98e67ed59e1d1-3b1b0d753ebmr11772524a91.59.1794867988751;
        Mon, 16 Nov 2026 14:26:28 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b1d1d744e2sm3127374a91.1.2026.11.16.14.26.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:26:28 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso5701580eec.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794867986; x=1795472786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WsVmZB0UH8bgbSx0D+T0vzINQcKZFGUzB4qEYlW4WKE=;
        b=hIr7GbNKjnkH64q1lev2y9rJOLQcydbwnhEJDdjupN7FrF65IFq5tz989yBs8FlD9d
         AabbxRwDuxspnkmJ8wZT712jZAvhMJC8PhTpx31Cxka+9lU6PftW3I5RpQOlxIOvtezQ
         FwSfVad6aXjf8Aj2VEO2p21k+taX1sctFnZz0=
X-Forwarded-Encrypted: i=1; AL+hErHZHXNIGnJZz/rQcdo9Pon7SP+cHNhB8wNisyZdrLpNBli4aW1boXrXnINhzzSVP/tCpeGV7rCZuUkRw1SJsDA=@vger.kernel.org
X-Received: by 2002:a05:7301:d185:b0:36b:fca0:80b3 with SMTP id 5a478bee46e88-37966961040mr12994356eec.22.1794867985493;
        Mon, 16 Nov 2026 14:26:25 -0800 (PST)
X-Received: by 2002:a05:7301:d185:b0:36b:fca0:80b3 with SMTP id 5a478bee46e88-37966961040mr12994310eec.22.1794867984774;
        Mon, 16 Nov 2026 14:26:24 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379560f5e06sm50176624eec.19.2026.11.16.14.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:26:24 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS),
	linux-kernel@vger.kernel.org (open list),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER)
Subject: [PATCH net-next 1/9] net: ethernet: bgmac: validate RX length against the DMA packet capacity
Date: Mon, 16 Nov 2026 14:25:11 -0800
Message-ID: <20261116222519.1416501-2-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

BGMAC_RX_ALLOC_SIZE includes skb_shared_info and alignment space beyond
the DMA receive buffer. An invalid completion length can pass that check
and reach skb_put() with more data than the skb tailroom permits.

Limit received frames to BGMAC_RX_MAX_FRAME_SIZE and reject lengths too
short for the FCS subtraction. Keep invalid DMA completions visible
through rate-limited diagnostics and RX error counters.

Fixes: 6a6c708469c9 ("bgmac: add check for oversized packets")

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 drivers/net/ethernet/broadcom/bgmac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 9ef239bc487d..1c502bd64d7d 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -457,10 +457,14 @@ static int bgmac_dma_rx_read(struct bgmac *bgmac, struct bgmac_dma_ring *ring,
 				break;
 			}
 
-			if (len > BGMAC_RX_ALLOC_SIZE) {
+			/* The allocation also contains headroom and skb_shared_info;
+			 * only the mapped packet area may be supplied by the DMA.
+			 */
+			if (unlikely(len > BGMAC_RX_MAX_FRAME_SIZE || len < ETH_FCS_LEN)) {
 				if (net_ratelimit())
-					netdev_err(bgmac->net_dev, "Found oversized packet at slot %d, DMA issue!\n",
-						   ring->start);
+					netdev_err(bgmac->net_dev,
+						   "Invalid RX length %u at slot %d (flags %#x)\n",
+						   len, ring->start, flags);
 				put_page(virt_to_head_page(buf));
 				bgmac->net_dev->stats.rx_length_errors++;
 				bgmac->net_dev->stats.rx_errors++;
-- 
2.53.0

