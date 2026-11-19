Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078110;
	b=SeVCOELBrGnXlZYnWXjBKOT3mZUrYfKzoU7YX9G/MmleaLzHPhOLZdbYrAgPv1wpa3nW
	 aVS9yKuDhY+elgujS/6mSgRM3d2Pt40OfjXdc5iI19yDekNlzH8WMXurzx+Y8dLFLMUyM
	 tcCROmhjeL41iwJs6GaAXWVChNw1CEp1togKC1H0M5fS9ChWh2XRqDWn2oCk0p65CM9h/
	 fUS3OfYxMiIkT2wreZpdNmWg8msFzxgHqVtpEPLUbjIYAoVTHkaQzc8FE+yDOGs0vgho2
	 PMgbNhQ3+kogqBHQ4+8XB+KulPqC+YdhQ73EyqEDQ7cmQfOQjh/EnS5BAh63k2NtpCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078110;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=33GYwwHy5bFpbYEe8FzT+nFzFJKkroS1MSXjsWGMd9c=;
	b=lev3i4NUBWJEqcRCp25nRyM+7jzBjAfoH8Z6ag2vQmlneY9Hlp2wVbwufaMDDqF22Iup
	 IGDtPvA4o8D3gjCYONVlFfq/xtr64cT5SevKC6a21ppcXpaQktp9lXtqHRXZmGb2oiLEd
	 ET8RQHJVLmKX2kxwFVS9c2wifq0+G7tk9eCC7kbcJ2as6n9x9IPjprz0u1MlRs2AsVW9O
	 gWCyMseeQkoKbMBFLDjChMZLJsRK/pm1vrZgTHCNsoUSeA5/SIiKwg3hcdMmimORg6Sqr
	 1FfJc2Tjxukz9F3Ytl/3YmGPhfcKjbXJHEvHA7Td1YgxEGKMkrjYxqeSkarpaVWUebg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A102606A338;
	Thu, 19 Nov 2026 08:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A102606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6A49560341; Thu, 19 Nov 2026 09:48:26 +0100 (CET)
Date: Thu, 19 Nov 2026 09:48:26 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev-bot+sashiko@kernel.org
Cc: theodorlarionov@gmail.com, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	pablo@netfilter.org, phil@nwl.cc, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net v2 2/2] net: unset the mac header of a pskb copy that
 points into headroom
Message-ID: <av63w6kQryQqWP_y@strlen.de>
References: <20261117175835.745796-3-theodorlarionov@gmail.com>
 <179506802393.3136.3490105838474942994@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179506802393.3136.3490105838474942994@kernel.org>

netdev-bot+sashiko@kernel.org <netdev-bot+sashiko@kernel.org> wrote:
> [Severity: High]
> Does this turn the uninitialised read into an out-of-bounds read for
> bridged packets? The copy still carries SKB_EXT_BRIDGE_NF, because
> skb_copy_header() -> __copy_skb_header() -> __skb_ext_copy() duplicates
> the extensions. After this change, though, n->mac_header is ~0U.
> nf_dup_ipv4() and nf_dup_ipv6() hand that copy to ip_local_out() and
> ip6_local_out(), so it goes through NF_INET_LOCAL_OUT before any
> link-layer header is pushed. Suppose a reject with tcp reset rule
> matches there. nf_send_reset() and nf_send_reset6() only test
> nf_bridge_info_exists(oldskb) before calling eth_hdr(oldskb). They then
> pass oeth->h_source and oeth->h_dest to dev_hard_header().
> 
> With the mac header unset, that trips the DEBUG_NET_WARN_ON_ONCE() in
> skb_mac_header(). It then reads 12 bytes at oldskb->head + 0xffff,
> well past the end of the head buffer. Those bytes end up in the
> Ethernet header of the RST sent out the bridge port, or the access
> faults if the address is unmapped.
> 
> Before this patch the same path read uninitialised headroom inside the
> buffer, which is the leak being fixed here. So the reject helpers
> probably need a skb_mac_header_was_set() check, the same way
> nf_bridge_adjust_skb_data() in nfnetlink_queue.c has one. Or would you
> rather drop the bridge extension on the dup path? Either way, it looks
> like that has to go in together with this change, especially with the
> stable tag.

I think we should disable dup or fwd of skbs coming from br_netfilter
(i.e. with SKB_EXT_BRIDGE_NF extension set).

It would also make sense to disable/remove nf_queue support for
br_netfilter in nf-next (this is independent of this work).
