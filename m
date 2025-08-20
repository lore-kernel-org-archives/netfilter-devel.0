Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119512D8762;
	Wed, 20 Aug 2025 13:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755696058; cv=none; b=j/gJos0yIyazJda/twfXZnMfIdCVkzEvBm4caQbUXfEA9piH+LEGpEmq02ntTCdJvbWgE+nnjKzWHVlw9UeZsAC4kpLSO2Q0eO3rpdEST8tvQcJ+pspgFxouakm6Cpaf8u/s/aVEqFczMfJLBFRVZGPRydKNMH5+snrNu+wQxgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755696058; c=relaxed/simple;
	bh=m/jigQWe5Z4LT6UdB5nbt+38Dcm3Yors/+leD70tsu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtOFFNeiRCEh1lisDSuOk1jNSj0oRfoObmIcIdLAc1HobUDzLoVr1GMYOjGMUymhnBCFr4ssIQYeMaVRdMM1XxP9/w/Py4GNYSe+yCtFkXZDN4Y+zbQrzrBY903GN91jY0M5UtdgJ7ZKRxRTuQIemihM/ILhECls9EpAxPbv6AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QFIDn2CE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lMhzo0/L; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QFIDn2CE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lMhzo0/L"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 89E0160278; Wed, 20 Aug 2025 15:20:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755696055;
	bh=+WqaoKixAdq/Jh8XhAQbtY9xC8+8J5W3jP9ZSbjOcvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QFIDn2CE6WrLXTp3YYfrC5C0pf0MYZWHrHMTNH0GooGggHkJddvNl91gz/uSMD4ky
	 pU/5WaB0NgD4r5r0PaCLSGG/thSg3lqKesJkNhq16SRIRCKB1XU2kZPWycUa7Rjq6U
	 a2ZS7Y7ytWM3i17+aB+cwEFSXTfiMqe00q6MP4pDBhHVzxLNZTMCBU32OI2qOKtCO8
	 gps/BrX04d2heGg6d0O1e7Hl1A5tq8eHuHTtwrSz+R6bRrIGDzaAzfRGNE7nDN92pT
	 4IcwW0sypk496c+UN0gity/Z04OYpnhAoIDfMK56NeetaiMgqmPqzDyVRsu1x8Cyrv
	 PHI6CPAiNxKxg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E6F116026C;
	Wed, 20 Aug 2025 15:20:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755696054;
	bh=+WqaoKixAdq/Jh8XhAQbtY9xC8+8J5W3jP9ZSbjOcvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lMhzo0/LED0i5kFschS2uZeiWMKY3pfs9gwVAl0zHAKdbmrITjd8mTa7jWmIuOuZ5
	 jcXiQZUHRxcpKtNw0IfSB7kNbuhOnjxhsIGaM4BLDu4Uot5mswLRDm6xBrJUkGD62d
	 FdhHzu3Y699GZ9PNxdFtbI/2jECJ/k8K2DfaEHZ0Ro9YfeKKdjPHNWF5DyNrrf74yF
	 bg7l1qVYLxuv9bXP/r8EIA0ga95eTKHIxqqi1BWsEbM5dKCxV4e5KDKhBNZyQkWOQg
	 XdFrYNsjMqnfcWmbJGrUg0nG1eh7Ek5GzXM3MPuMNPI789iusXJLjiuw7v01jZ2Otw
	 4E6PXW9TUqzxw==
Date: Wed, 20 Aug 2025 15:20:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_reject: don't leak dst refcount for
 loopback packets
Message-ID: <aKXLsoLkSdnEU_at@calendula>
References: <20250820123707.10671-1-fw@strlen.de>
 <aKXKpE35H7KBzdBa@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aKXKpE35H7KBzdBa@calendula>

On Wed, Aug 20, 2025 at 03:16:23PM +0200, Pablo Neira Ayuso wrote:
> Hi Florian,
> 
> On Wed, Aug 20, 2025 at 02:37:07PM +0200, Florian Westphal wrote:
> > recent patches to add a WARN() when replacing skb dst entry found an
> > old bug:
> > 
> > WARNING: include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
> > WARNING: include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
> > WARNING: include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
> > [..]
> > Call Trace:
> >  nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
> >  nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
> >  expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
> >  ..
> > 
> > This is because blamed commit forgot about loopback packets.
> > Such packets already have a dst_entry attached, even at PRE_ROUTING stage.
> > 
> > Instead of checking hook just check if the skb already has a route
> > attached to it.
> 
> Quick question: does inconditional route lookup work for br_netfilter?

Never mind, it should be fine, the fake dst get attached to the skb.
