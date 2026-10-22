Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792706820;
	b=4/3Y3pmebX8tQ79gKx3ZMCvldOTPvXKcyjTKkzoK+EMSOlsRabx/tgejCp1sx8MnTESp
	 a9XpR9Jx6odQGIRhFNGUJToUDspdhIXHRdINKAmgKRcSaegMXf//GTx8zjHaPUe/dZcVZ
	 DiOAi0IAhZrq5yTczjLxOGktce2NrnmvmzY9uXiKqe2d3h5DR+SarS78xvlaKVxHLxspP
	 KggcZaBW7zFV4qe8jWYSrgQweKMleNqcjKTLBlBpKwAB6Zx9Q2kMPRIevG9RXmeMiLdZ0
	 Qd+U4JMfNB+JpvBsHQKxQHGRoSSofc1qI93S1Z03b9+AlPoOu+5YLsSbZs8D0iMUBdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792706820;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=t+Fb6hjXOY9iGi+2yInOelGCCfpn0F6ruO8Xi1D8ydg=;
	b=RS5/7Xy5qYKvfk/c37PSGGXoAnvvgRBhq3lXuBRoiIyil13Vow7601ixbTIMJXH9uo9R
	 nLEkjJgbmtqrfRYs9oFawX/kg4OuJgLoeqMYFbArpusqY24Fmgq0MogW5bgobI9c/OEE5
	 EohAWjyFBFIDASg92glwE1iLxS4lYvcu/aDMQFeHwL4vpSD0wf4IuNcVkR4u0kWuZhCXn
	 POa/kFaidVl9ooTun1+Gefl+wv8Aq7sVyvgvcEDTyLX0aLAGz3Y2FMGgy5SSMgldMvfyI
	 0XlIsff9zVlxVwc7+fkB+Sum7wilTUHv2OU2R+7XfSz0EJhHthcoZpgcBEtcJLyozvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ur1LU+KW;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 363E2606A334
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2026 22:06:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 363E2606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ur1LU+KW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792706811;
	bh=t+Fb6hjXOY9iGi+2yInOelGCCfpn0F6ruO8Xi1D8ydg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ur1LU+KWBh1laqmjXpmzSKk2QGr7BegGUOvm5VbadUPk/YRs4dhp9pDLWtIJL6GIb
	 fUNgvNaU3MQZD01chJKv5m8yWL68zVFsmSBDC1WSa1D3Pk4SDG7YBTUrnJvZSCvsuK
	 bUjGsxGVyIfHhjwufP4A1gQlHhJ166sGOtoEoKDamvSl8sBh1iLVLqRArSRDC/KAFW
	 T/ueP8LM1w5Tjz5eH6JmDvVKwW6SplOcgpaaAtQ0K6TFTK9rmPG+OwtzVHXyGqpjsR
	 Ea1TrmRlh8uzmE7gQQKxoXbbs5H/2mep3i0MqEbq84EpJrhJ7c3BKAg9bZta+vxCJw
	 ZFu3oTLehDtfA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 2178B60056;
	Fri, 23 Oct 2026 00:06:51 +0200 (CEST)
Date: Fri, 23 Oct 2026 00:06:47 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH nf v3] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
Message-ID: <atqI9-LCU1xgpfmF@chamomile>
References: <20260924201328.6323-1-fmancera@suse.de>
 <33f02ffd-0b32-44a8-8169-1f1c936e83ca@suse.de>
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
In-Reply-To: <33f02ffd-0b32-44a8-8169-1f1c936e83ca@suse.de>

On Thu, Oct 22, 2026 at 08:32:50PM +0200, Fernando Fernandez Mancera wrote:
> On 9/24/26 10:13 PM, Fernando Fernandez Mancera wrote:
> > nftables payload-mangling rules can rewrite packet contents (such as TCP
> > flags) before they are evaluated by reject targets. This defeats the
> > content-based loop guards, allowing unbounded hook recursion that leads
> > to kernel stack exhaustion and panics.
> > 
> > Fix this by extracting the per-CPU xmit recursion limit previously used
> > by the netdev duplication/forwarding paths into a shared header, and
> > apply it to the inet and inet6 reject transmit functions. It disables BH
> > while transmitting the skb to address a possible migration to different
> > CPU leading to imbalanced decrementation of the recursion counters.
> > 
> > Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
> > enabled does not require this recursion guard. In that scenario, the
> > generated reset packet is transmitted directly at Layer 2. Because the
> > packet egresses from a different hook, it cannot synchronously loop. In
> > addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
> > transmit functions are protected against recursion by the
> > icmp_xmit_lock() and icmpv6_xmit_lock() guards.
> > 
> > Reported-by: Yu Junzhe <junzheyu1@gmail.com>
> > Closes: https://lore.kernel.org/netfilter-devel/20260921061320.543-1-junzheyu1@gmail.com/
> > Fixes: bee11dc78fc8 ("netfilter: nft_reject: support for IPv6 and TCP reset")
> > Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> > ---
> > v3: fixed build robot errors due to the struct member being guarded by
> > CONFIG_NF_DUP_NETDEV instead of CONFIG_NETFILTER and renamed the struct
> > member too.
> 
> Is there something missing for this patch? It would be nice if we can get
> this in the next nf.git since it was discover by a real user (or it looks
> like so).

I will include this in the next nf.git batch.
