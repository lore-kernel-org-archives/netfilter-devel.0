Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964671;
	b=O0DVndbairnNqDAhE+n/Vt6hAa4nt1FjSqZddJOFNadIVd19YBgg28v2ljFWcqSAcGZO
	 W0TMsc1Yerr+xDNu9DsvfYVdmVHFf0ieA9O9iJXnN8lg2Q9PoiXGj3XLojRbTjPl7cmej
	 W1AdflW6/6LE75zY2le0SQgIvv33kRO1jcZrIOWNzn3Ak5FXk4AsGG0Glj6pKA/qbn4Sb
	 Qq19P2xhEbjR5yUdemPu0hT6uoyjtQX/P4EAgISzNnrOfnlzhEOodOao9ew+h2TYBGlCr
	 /qOr2ZX6tmHnvkM4VUzlWbsIhIfSp6p851p8FzDFf3fH8PM9AOjvaYMguUMMFloLtOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964671;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=XDTg5pCTIlloQy/QX/iQjE9/EBF5LQIZzLwDejiqtvg=;
	b=5OLCYEdIlev7Gz8UEjQcyKsJCyVyGEbWMMDOpujBQrqt/LgXURK4+0dUQpZqymp4XhLN
	 paN0QxmsUdvdh/6zMcv6NSZtUIZBrMdFYKmWV9lKPGGLcbNBhBcD3yX4dnHzdkz9QBt4J
	 Ri+ZsdfeOz8T66sGoNUmzg+t0pvqYh9sID8RTFRWQp164zd3lrl1enmL9znhB3QOiiUtO
	 uR5EWUi2HnMi0g5d+p3A0ocdikhM+TtXta4DV6vV0qZj8+i2RL/wqR2q9OMOQHxJtLUAp
	 osQlZ/v83qZfOX0frdgnf2lgaqGI+MeSDAYgwpqqg7W0cvTP8HofQpcEi78O2GYfHiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FBBG1c9W;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id B130C606D816;
	Fri,  6 Nov 2026 11:31:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B130C606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=FBBG1c9W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793964661;
	bh=XDTg5pCTIlloQy/QX/iQjE9/EBF5LQIZzLwDejiqtvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FBBG1c9WIjc45rJWGBZC9xYXAeOgMaiDyLHzpFlzoBtVpar08udkJwtyJ70XDUAJ2
	 yH5PqPB2FzWpGF90BwxVQtCWRS85dv04hFVFBLtxavG+0KPtKjT/52s265GkOK5xDn
	 Y2733QcBmwHuNmOC6xUugZdtqgA1ywhbkbj7aNa7oX6fWxpUyn1MvPwirJ070zdy3g
	 QFll7J6PrYb7PuI7evFLjNC4xM05nzUhvDAqUDd1nGmU6ArHnrGrQJkDybZMpL1/lk
	 8ULm1+fFd4gUkguGbPuSXbghiHYGuddJUtJWBe+7YsSfSpvIBEGPMST6spYyLxJi6I
	 W0qJBQgBVKeaA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4C89C60709;
	Fri,  6 Nov 2026 12:31:01 +0100 (CET)
Date: Fri, 6 Nov 2026 12:30:59 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net,v4 00/12] Netfilter/IPVS fixes
Message-ID: <au26c2NFsX6gCCPo@chamomile>
References: <20261105124536.1009301-1-pablo@netfilter.org>
 <20261105154808.48fa2a97@kernel.org>
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
In-Reply-To: <20261105154808.48fa2a97@kernel.org>

On Thu, Nov 05, 2026 at 03:48:08PM -0800, Jakub Kicinski wrote:
> On Thu,  5 Nov 2026 13:45:24 +0100 Pablo Neira Ayuso wrote:
> > v4: - Drop "ipvs: do not create conns from packets with port 0".
> > 
> >       This PR was already reviewed in its v2 by netdev-ai-bots.
> >       I have dropped all the patches that LLM flagged as needing
> >       more work even since.
> > 
> >       But I really think v3 was good enough and a follow up for
> >       "ipvs: do not create conns from packets with port 0"
> >       was just fine to proceed.
> > 
> >       Maybe patchbot will ban this pull request again, v3 was
> >       blocklisted for not fulfulling the 24 hours rule, that is
> >       why it was not reviewed.
> > 
> >       But, as said, this was all reviewed in PR v2 already, this
> >       is just keeping back 3 patches included in PR v1 needing
> >       more work.
> 
> netdev CI keeps hitting a kmemleak since this morning, lines up with
> this series, tho TBH I have done 0 investigating...
> 
> $ cat /sys/kernel/debug/kmemleak
> unreferenced object (percpu) 0xc0ffff86522458 (size 12):
>   comm "modprobe", pid 17854, jiffies 4295218150
>   hex dump (first 12 bytes on cpu 0):
>     00 00 00 00 00 00 00 00 00 00 00 00              ............
>   backtrace (crc 0):
>     pcpu_alloc_noprof+0x76b/0xd70
>     nf_flow_table_pernet_init+0x46/0x90 [nf_flow_table]

This is not handled by this PR.

I will submit a patch for this asap.

>     ops_init+0x187/0x570
>     register_pernet_operations+0x395/0x8e0
>     register_pernet_subsys+0x28/0x40
>     nft_masq_dump+0x66/0x190 [nft_masq]
>     do_one_initcall+0x124/0x4f0
>     do_init_module+0x2ad/0x8a0
>     load_module+0x154b/0x1d60
>     init_module_from_file+0x11f/0x1a0
>     idempotent_init_module+0x37b/0x7c0
>     __x64_sys_finit_module+0xdf/0x190
>     do_syscall_64+0x10e/0x570
>     entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
