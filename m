Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793577707;
	b=3IVQn6pCpkhcphULZB+O9SeWA/vJ69+lUZ/wfuDuFhmF1zPAw3qpFGGMPYiePxKi3KlO
	 e8hMN7KjUhNIl7Vnl4e7dSc6YmiuY63O/o/S8G+MKisnUb0ffHTw1v3TUPkkbr17vR7Yy
	 DY90P5HvihhsGeC0oK6KSOnWmQ8vGvWrAU2eyzaxoyXcWViZ9Ua9nWi0RHGPXly9oiUoH
	 vUoDEmNMs6IZY9B9gmpzxSg1LxWvYQ6K6isWjd1NLj2Rz+B3lvp+0Lp13+7W1E558LNNv
	 mi/Wskk6AoZGfZC8WTKg275tAl2VMIro+Dn34hteDmKS1fglkA94FNRhh+DSVdsaBbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793577707;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=x1KJF9mfcDQpoU3XH6Ww0jom9mAhVJBxTy/juMVYG/g=;
	b=SFtT/qlpH6Lzj08XqFwxMqIcFtJ/jSkx5wP+Gixnm92eO1MlE3ew+0qiAjwkKw72MZuE
	 6gcO3fYJuAQ24g0qw+dzeW4eJJepwX9h50Z5QMyDVZGQsrZ8qjlqFjjz0D7uxIlKif9SM
	 JyZIGMndQ8AOKZsrnSuJGT3YPLMdO06+a6wV9a49rmvfPpr1TKFTYTUY5tAuOP9743sqY
	 s9WwRJSK76Q5uSpkc4av2ikeXEOdOu1A486fpZRU+39GLrnMDJBuibsSsvG1Qz4RnBavg
	 8/ZAMS0xGJbONaWyf/fnr6ou9Pym2zAEmaKM0MMzhsDjzhSade5cyZJQ36vPxm2glNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bnmaOkKm;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 3CE92606A324
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2026 00:01:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3CE92606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=bnmaOkKm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793577702;
	bh=x1KJF9mfcDQpoU3XH6Ww0jom9mAhVJBxTy/juMVYG/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bnmaOkKm9sF/KJFEdgdkDAh3FXWTlBRSmTFs2nDDxJgcMLVpDi51tMkpYIKwmztUH
	 9n4y2f7kTNXMVewWFCWvH85i4YEoq2v+2ZCUy+FrqIcJbElkiSnhdOzr+WOPDfWwsL
	 JMNdsPanOPGLE1M7obHvh35IXICsy/H5OO7H1I06+STK4Dss3G3F3PF4tgafb0Ji2D
	 UyN4liXRWMeipZ+TSmlVQLSom3VPvXqP4Z/0rdiR+7tvuD2AKTnAV8UwcFbgZPZQrw
	 IICG+1GsHLatbpCWLXiLZAfqD0VSiOLD7kbdGlLwvkRg5CYS213zmkUlOxGlswG2ft
	 /RdRFfAgNAvIQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B6E6760056;
	Mon,  2 Nov 2026 01:01:42 +0100 (CET)
Date: Mon, 2 Nov 2026 01:01:40 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de,
	phil@nwl.cc, Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH nf v3] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
Message-ID: <aufS5GcCmM590Q45@chamomile>
References: <20260924201328.6323-1-fmancera@suse.de>
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
In-Reply-To: <20260924201328.6323-1-fmancera@suse.de>

On Thu, Sep 24, 2026 at 10:13:28PM +0200, Fernando Fernandez Mancera wrote:
> nftables payload-mangling rules can rewrite packet contents (such as TCP
> flags) before they are evaluated by reject targets. This defeats the
> content-based loop guards, allowing unbounded hook recursion that leads
> to kernel stack exhaustion and panics.
> 
> Fix this by extracting the per-CPU xmit recursion limit previously used
> by the netdev duplication/forwarding paths into a shared header, and
> apply it to the inet and inet6 reject transmit functions. It disables BH
> while transmitting the skb to address a possible migration to different
> CPU leading to imbalanced decrementation of the recursion counters.
> 
> Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
> enabled does not require this recursion guard. In that scenario, the
> generated reset packet is transmitted directly at Layer 2. Because the
> packet egresses from a different hook, it cannot synchronously loop. In
> addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
> transmit functions are protected against recursion by the
> icmp_xmit_lock() and icmpv6_xmit_lock() guards.

Unrelated to this patch, but should ip_local_out() call in
synproxy_send_tcp() be tracked by the recursion counter too?
