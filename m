Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795564436;
	b=FyrQIKRK0ZP2Pohcaatz1inuDhiFBERwrfxCdTFI8aE6XXjEc4eFRewtgmRzQXZrH2/v
	 mi7BMjZvajQQybVzP1F3cQrbrT6aCvCxgkYwBhIygWFfMGCi9hIRakJdn5iIyYpxa10c9
	 1uvcSXMnpa0oDRnyhY1lfpPMyUS0i8VPZqblfIWZOY+ptsoK3bJktC0nh5AENFPhaarAL
	 WgOjh+aM4sK4nfxNZu06Y/M/oc5N6Jqx0xpdKUe6yinNx9ptyxRq1ALLsvPO2ogd472s0
	 XK4d1x+silchm2tNeX2kaskvNEoThudgt2Uaj/Q2biyvD4U2FRKLvhnmsEaMCXnh0yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795564436;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=KICHrHoVBC5ChiNKe6AnJDa0EDKDsz+p/ePjDWX3ai8=;
	b=HLZvX3RCNMyHheX9KHxjmRugmGB2SaHjPrHgIAqIHW/go9lQrDbeFSaa4YuLODExcoKm
	 vkpFpTzX9EhCqLZV02yeUtvEVDIayV5mr6D4zymP0hkoyOhkJaj1JMMv4bOiy/gMCBz0z
	 Xs9MYcB8Xh5hyQPI+aLXs0LABxyQmKxIZBBBHfQUktWhiL00dpM9Wo8OEKeqpC0pRgczV
	 lUUZRMacIIXeutWbR1SCV3prEE7yVytBLTZSyx0rOUGXIWDdmEJ238+gnlxW3LT465E3E
	 y4TI/XDe2/jV145N5E8UTzztVy0tkvKb4vYBvkdgP21LYL3M/IGgw2UnkhhL+fAbQiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=adV8GWA9;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EAAC9606A31E;
	Tue, 24 Nov 2026 23:53:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAAC9606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=adV8GWA9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795564434;
	bh=KICHrHoVBC5ChiNKe6AnJDa0EDKDsz+p/ePjDWX3ai8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=adV8GWA9VXyZwVHUT3pbNlDYzzjahyq6rNb8VhINLP9oR2/L2yuUVi0Pbup1TLmOJ
	 xcpIwgCxvObkCvAyHU4zYsPgPLzI/gek5I/EpXf+vMCxfIeiPb12qYIT5EAAiiSUmD
	 Hr303zLHM1d5BqWg07cn+UDXsPWyAXwU92Yza0xqzhRWvQNlFiprz1DAy1PflZqZmQ
	 R8B+fYkZlZe1urVhwcErPumMSCvCDtf5R4XK2Tgn3CEFZdzGID7+a+s+mFYoo/oJJ1
	 RWK6PYmVOtTT+sL3ubXdf5c+9fxuiEBCIqDb71O/N5deP0fGqnUPjW5AkbuMPpA+hd
	 5T7r4N3X3t9Fg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 30D6E60074;
	Wed, 25 Nov 2026 00:53:54 +0100 (CET)
Date: Wed, 25 Nov 2026 00:53:51 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: don't CC netdev on netfilter patches
Message-ID: <awYjjwhty6TeH_Mr@chamomile>
References: <20261124152635.26769-1-fw@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261124152635.26769-1-fw@strlen.de>

On Tue, Nov 24, 2026 at 04:26:35PM +0100, Florian Westphal wrote:
> Netfilter patches are handled by the netfilter maintainers and the
> netfilter-devel list, yet scripts/get_maintainer.pl also suggests the
> netdev maintainers and netdev@vger.kernel.org for them, because the
> NETWORKING [GENERAL] entry matches net/ and include/net/ as a whole.
> 
> Add exclusion entries for every path already listed in the NETFILTER
> entry.  This is done to reduce the mailing list load on netdev@,
> which does not need to be Cc'd on netfilter changes. Patches merged
> into either nf or nf-next tree will still be passed on to the net
> maintainers.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
> 
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7336600952c8..8348b298e40d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -19170,21 +19170,31 @@ X:	Documentation/networking/batman-adv.rst
>  X:	Documentation/networking/mac80211-injection.rst
>  X:	Documentation/networking/mac80211_hwsim/
>  X:	Documentation/networking/regulatory.rst
> +X:	include/linux/netfilter*
> +X:	include/linux/netfilter/
>  X:	include/net/bluetooth/
>  X:	include/net/cfg80211.h
>  X:	include/net/ieee80211_radiotap.h
>  X:	include/net/iw_handler.h
>  X:	include/net/mac80211.h
> +X:	include/net/netfilter/
>  X:	include/net/wext.h
> +X:	include/uapi/linux/netfilter*
> +X:	include/uapi/linux/netfilter/
> +X:	net/*/netfilter.c
> +X:	net/*/netfilter/
>  X:	net/9p/
>  X:	net/batman-adv/
>  X:	net/bluetooth/
> +X:	net/bridge/br_netfilter*.c
>  X:	net/can/
>  X:	net/ceph/
>  X:	net/mac80211/
> +X:	net/netfilter/
>  X:	net/rfkill/
>  X:	net/wireless/
>  X:	tools/testing/selftests/net/can/
> +X:	tools/testing/selftests/net/netfilter/
>  
>  NETWORKING [IOAM]
>  M:	Justin Iurman <justin.iurman@gmail.com>
> -- 
> 2.56.1
> 
> 
