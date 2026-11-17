Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958158;
	b=YcA0GcuqlIkLsoDI4QAHX4++msBZijDHpmTx10ldUlXhtsFLVxyLIQmOIgnMbfjltUNV
	 PhCyYtz1521cfw8w+2iABpj/wezrJSxtB06uq0abCuUbjIFPkol5slmvlpsWkdIYS/6f7
	 2qNoBGFfJ4521d0SF/IQFemh0ImtfRqLmkbdvrDnCw8zAiZ4hVJHXKP6ZRCAGYfKQUdLi
	 mM/zy6rIE/BA+Fj0jkrT2v5RNYVO0gbjb7pEdssLLhv5EKmvG6hUj3m43R9UflOLyU0Kr
	 OJoyy0KvNlC5NSJahtqmv/t70YbZdvOGpdNpVIXL0p10g58re8vGZ11edovZdtyTXsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958158;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=2b458MopEXa7uB2O3RLfHV+wzOt6YVuNArYwPbFLSA4=;
	b=WA6Xu47SkvH08o2/1cvi+CpPLIY26Z3yoY+1m8A0J7d8DUdpIN8vO3S0y7TkOgs8QK2n
	 xZle65ePCkVsMJ9K/xLlCDtk2Rqs2OhiUFSqTPorBoPAO+5um3uwcPWVbX9Ux53Iyb6dg
	 6ZoaHqNxmCmXHTiPfo4CVUqmpHFriBd2x8FNPh4I5aeoU1hrXMl2yN3X0sADeX4D5nMuk
	 wHB4bIS0D8ljfhtbppYb2594gd5qQlUU58GEJmNVW0H9dlg+aagYgjHochsbudeEx/7Tc
	 Ko9vaxFNsCF9ZD1JP03vt/FicC8yQLwd/POAmZfJTO2IdUsmvAo4XQc5QBXBgoSWnmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WcZqd4vr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9DF606A31C;
	Tue, 17 Nov 2026 23:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WcZqd4vr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3891F000C5;
	Tue, 17 Nov 2026 23:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958157;
	bh=2b458MopEXa7uB2O3RLfHV+wzOt6YVuNArYwPbFLSA4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WcZqd4vr7CaaogZNmgRfWRKTwEKa+bpOUUxlWfd6laABE9Yy3P52bl4jiVZ/YVqyE
	 k5Iuf97WZlNhaNkrSZAF6oVj9nb9sYpgvLrP91kVpqUrklYeKv0Vxt94AQOb3VDjhY
	 T8nZNH5hyr8VKgJLanjOxNXUGiEtHKiB2sDl1iYC9phKDaEKK24x5dV/kH79nJEdFx
	 hxLhxvPLrP3Lld0F4EMIjai1gXyq1USdkc2A4ruvKvbcsE+tXZHwE+DRgeRhRcACvW
	 BQYNX6ZJlm4NSWzCOD3rH6h6+zLRlZR4cERmF0Ek0hAdMZR2wQzTvgExYZNTKuSCt+
	 /XD5tsp2OGPAQ==
Subject: Re: [PATCH net-next 1/9] net: ethernet: bgmac: validate RX length
 against the DMA packet capacity
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, horms@kernel.org,
 corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 17 Nov 2026 23:29:15 +0000
Message-ID: <179495815587.3136.10288920701294421777@kernel.org>
In-Reply-To: <20261116222519.1416501-2-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-2-florian.fainelli@broadcom.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] In bgmac_dma_rx_read()
  (drivers/net/ethernet/broadcom/bgmac.c:463), the patch now treats…
- [Low] The commit message is accurate but leaves out the user-visible
  impact of the bugs this patch fixes in bgmac_dma_rx_read().

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is High
  severity, and the new check does not close it.

--

net: ethernet: bgmac: validate RX length against the DMA packet capacity

This patch changes the upper bound of the RX length check in
bgmac_dma_rx_read() from BGMAC_RX_ALLOC_SIZE to BGMAC_RX_MAX_FRAME_SIZE.
It also rejects lengths shorter than ETH_FCS_LEN. Invalid lengths are
reported through a rate-limited netdev_err() and counted in rx_length_errors
and rx_errors.

> BGMAC_RX_ALLOC_SIZE includes skb_shared_info and alignment space beyond
> the DMA receive buffer. An invalid completion length can pass that check
> and reach skb_put() with more data than the skb tailroom permits.
>
> Limit received frames to BGMAC_RX_MAX_FRAME_SIZE and reject lengths too
> short for the FCS subtraction.

[Severity: Low]
This isn't a bug, but could the commit message state the user-visible
impact of what is being fixed?

For len < ETH_FCS_LEN, the u16 subtraction "len -= ETH_FCS_LEN" wraps to
65532..65535. The skb_put() that follows then ends in skb_over_panic() and
BUG().

Lengths between the skb tailroom limit (about 1602 bytes with
NET_SKB_PAD=64) and BGMAC_RX_ALLOC_SIZE also reach skb_over_panic().

Lengths from 1537 up to that tailroom limit got through skb_put(). They
delivered bytes past the 1536-byte DMA-mapped frame area. Those bytes come
from the non-zeroed netdev_alloc_frag() buffer, and the device never wrote
them.

The message names the tailroom and FCS cases. It does not say that they
end in a kernel BUG(), and it does not mention the stale data delivery.

> diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
> index 9ef239bc487d7..1c502bd64d7df 100644
> --- a/drivers/net/ethernet/broadcom/bgmac.c
> +++ b/drivers/net/ethernet/broadcom/bgmac.c
> @@ -457,10 +457,14 @@ static int bgmac_dma_rx_read(struct bgmac *bgmac, struct bgmac_dma_ring *ring,
>  				break;
>  			}
>  
> -			if (len > BGMAC_RX_ALLOC_SIZE) {
> +			/* The allocation also contains headroom and skb_shared_info;
> +			 * only the mapped packet area may be supplied by the DMA.
> +			 */
> +			if (unlikely(len > BGMAC_RX_MAX_FRAME_SIZE || len < ETH_FCS_LEN)) {
>  				if (net_ratelimit())
> -					netdev_err(bgmac->net_dev, "Found oversized packet at slot %d, DMA issue!\n",
> -						   ring->start);
> +					netdev_err(bgmac->net_dev,
> +						   "Invalid RX length %u at slot %d (flags %#x)\n",
> +						   len, ring->start, flags);

[Severity: Medium]
Does this new bound drop frames that the driver itself tells the MAC to
accept, and whose MTU it advertises?

bgmac_chip_init() sets the MAC max frame length to 1550:

	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + ETHER_MAX_LEN);

bgmac_change_mtu() sets it to 32 + mtu, which can be as large as 1564:

	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + mtu);

bgmac_enet_probe() sets max_mtu without subtracting ETH_HLEN or VLAN_HLEN:

	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;

The driver accepts any MTU from 1519 to 1532. At those MTUs a full-sized
frame can be up to 14 + 1532 + 4 = 1550 bytes. Such a frame is now always
dropped, logged as an invalid RX length, and counted in rx_length_errors.

Before this patch these frames were delivered with stale tail bytes, so
dropping them is safer. However, the new comment and the commit message
assume that len > BGMAC_RX_MAX_FRAME_SIZE can only come from a DMA error.

Should max_mtu and/or UMAC_MAX_FRAME_LEN also be clamped to the
per-descriptor capacity? One option for max_mtu is
BGMAC_RX_MAX_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN, possibly minus VLAN_HLEN.
Could the commit message also mention that these frames are now dropped?

[Severity: High]
This is a pre-existing issue, and the new check does not appear to close
it. Can a remote sender get stale buffer contents delivered as a received
frame through an overflow-continue slot?

bgmac_dma_rx_ring_enable() turns on overflow-continue:

	ctl |= BGMAC_DMA_RX_OVERFLOW_CONT;

Each descriptor holds only BGMAC_RX_BUF_SIZE, which is 30 + 1536 bytes.
The MAC accepts frames up to 1550 bytes by default, and up to 1564 bytes
after an MTU change.

With overflow-continue, the DMA64 engine writes the rest of an oversized
frame as raw data at offset 0 of the next descriptor's buffer. That buffer
has no RX status header. brcmsmac's dma_rx() drives the same engine with
the same 0x400 bit, and it handles these continuation buffers explicitly:

	resid = len - (di->rxbufsize - di->rxoffset);
	...
	while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
		pkt_len = min_t(uint, resid, di->rxbufsize);

bgmac_dma_rx_read() treats every slot as an independent frame. The new
check drops the first slot when len > 1536. The next slot is then parsed
as a fresh frame:

	len = le16_to_cpu(rx->len);
	flags = le16_to_cpu(rx->flags);

In that slot, rx->len and rx->flags are frame bytes 1536..1539, which the
sender controls. A value in [4, 1536] passes both the poison check and the
new bound. build_skb() and skb_put() then deliver up to about 1532 bytes
starting at buffer offset 30.

DMA wrote only the first (frame_len - 1536) bytes of that buffer in this
round, which is at most 28 bytes. The rest is stale netdev_alloc_frag()
memory, because bgmac_dma_rx_skb_for_slot() only writes the poison header.
The resulting skb goes to eth_type_trans() and napi_gro_receive(). From
there it can be processed locally, bridged, or forwarded.

The old BGMAC_RX_ALLOC_SIZE check let through an even wider range of
lengths. This patch narrows that range but does not remove it.

Could multi-descriptor frames be tracked so the continuation slots are
dropped too? Alternatively, could UMAC_MAX_FRAME_LEN and max_mtu be capped
at the single-buffer capacity?

>  				put_page(virt_to_head_page(buf));
>  				bgmac->net_dev->stats.rx_length_errors++;
>  				bgmac->net_dev->stats.rx_errors++;

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
