Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795726185;
	b=elMzDoon7yZG7bPEQi46INb8/w03EdCHGRlyAVuPTTSZJRoXwK6zj7z2x+MDjGawJbkP
	 Xlj2HBtPBctwCC3k9RULtA8vC0ho6CABhOtfxtEge7jMw4RIdbVgc9nJRP2STr64bzQzz
	 KBecnd1xCg5Cnwdbtix2Q/J7MIea5Q9yDjr1nS5s/28FiLogwGoPK709GNnbuTS4lWuHv
	 q2BHGJZXCsdaJgIW1yrd+/huRcibtxwRX46a1/TbOi1DKCBoifHLo9OGvldl4/BziLgkp
	 WrFfG6VzdqxqP6KBhV4sJm/cNU+Fz+zn4NNsu1HXIfmM4NvwQj+c7OOk8jUpd65OYYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795726185;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=vqcBL0lmJyGZPFS/MAsKFzh9EFxYcPwwb2r8+NXkIgE=;
	b=EA4WwtpVYrOgAWMYlXPAqLjAbGegf5q1G4W0WoWpTOxnpE4yS3zwKBHUKyTz7aK1dXPP
	 isegSo+09Gs/Uoc/XGBM8pbtweLzt6t3qhsvkBLf35CX4M78JBCU8UV1SGzzzDh/3jyDX
	 lsk6+l8DYXiFWnCDoAbubqwk1R/fmn5ox4HpQDHxaOqciHOMuucjb4r/+gFHTPOuM+OmE
	 X+3cMM/tgsfdawR80evUtSVexQzJEhj760fxp8+ZVHLGT7RyMii9ILWonunDDUYu2DIfL
	 uXI4xo8YJchVLnV+3Z3S0/iPc/ji+ga5MQvS6+wA3M+Et6la8QbpEQYRD+4dqgyto3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=RuextKx9;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263C3606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 20:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 263C3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=RuextKx9
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vqcBL0lmJyGZPFS/MAsKFzh9EFxYcPwwb2r8+NXkIgE=; b=RuextKx9Vkj3R5TX6FDDWuDCSu
	FY5PFEUd7qgQc6bZtDGEKogvUqMzm3quh1yMFny86FlTqm/ycX+1Rz/IdRriZTLwWHhxLUu/7EjET
	2l58prpbYBP2y/k7/R9NePA/HGAJsjb6oFdJRc2ZcPe///6GKdoEYMLe28mPLHK3chzV6BYUpFDBV
	PTCFia6+b7cMK3BHmxDfLqgSSruyXb/bKdfh/RNM0ttn7iRzjtwIRFkjhPMossJ2Hk87lM6hLK25r
	VeXaB1mA4ZvNGb3p04pK9lpNiHr8w6aVOeeoR+01k1O9HW7EgKfwlmkAIq2qju4y2bxLAl2Mhcpgu
	jEwwBl2w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xWgPP-000000003E8-326L;
	Thu, 26 Nov 2026 21:49:35 +0100
Date: Thu, 26 Nov 2026 21:49:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Rohit Geetha Bal <rohitgbal@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
Subject: Re: [PATCH] trace: Fix incorrect ICMP code representation
Message-ID: <awibX916hTQGJi81@orbyte.nwl.cc>
References: <20261125195405.2279-1-rohit.geetha-bal@telenor.se>
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
In-Reply-To: <20261125195405.2279-1-rohit.geetha-bal@telenor.se>

Hi Rohit,

On Wed, Nov 25, 2026 at 07:54:05PM +0000, Rohit Geetha Bal wrote:
> Fix incorrect ICMP code representation in packet trace output.

The description is a bit meager given the elaborate bug report you're
linking to.

> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=222272

This is the wrong bugzilla. Correct link is:

https://bugzilla.kernel.org/show_bug.cgi?id=222272

Please keep in mind that links to external web sites should not replace
commit descriptions since they are prone to go 404 sooner or later.

> Signed-off-by: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>
> Tested-by: Rohit Geetha Bal <rohit.geetha-bal@telenor.se>

A bit redundant, one may expect that an author did test their code. :)

BTW: How did you test it? I'm failing to do so, using a simple rule 'oif
"test0" meta nftrace set 1'. Pinging from both sides gives me:

| # nft monitor trace
| trace id 058e9d40 ip t c packet: oif "test0" ip saddr 10.0.0.1 ip daddr 10.0.0.2 ip dscp cs0 ip ecn not-ect ip ttl 64 ip id 14699 ip length 84 icmp type echo-request icmp code 0 icmp id 52743 icmp sequence 1 
| trace id 058e9d40 ip t c rule oif "test0" meta nftrace set 1 (verdict continue)
| trace id 058e9d40 ip t c policy accept 
| trace id 81be10a5 ip t c packet: oif "test0" ip saddr 10.0.0.1 ip daddr 10.0.0.2 ip dscp cs0 ip ecn not-ect ip ttl 64 ip id 23411 ip length 84 icmp type echo-reply icmp code 0 icmp id 17703 icmp sequence 1 
| trace id 81be10a5 ip t c rule oif "test0" meta nftrace set 1 (verdict continue)
| trace id 81be10a5 ip t c policy accept

Having 'icmp code 0' in there is fine, I guess.

Cheers, Phil
