Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788837;
	b=bbnk0iO4rJvcw+RxJwaXp2NPYW3Ct++g/r1X7lI3iJs3++6a0qkAZO7N1vF6Hy9SY0I4
	 dsn4aLknN0QI6XJdJ8CvdKbcq9OgW6mNBX++olTtWJm9L5Ss6Ba9Cex8PdXz2vHkN4A9z
	 KjijtZp6GXfBhtSKbgR9v6Cw62emuaJLIZVQJ54o0rKYRpL4NdrcAXrkpshKbdd4K6/O6
	 vfie/MsEWYkiTF4zOIqjHA1yjlH16+e4MXKuVa/sVKuj8QbQzPduzpe/5g/vCJVfeb8XG
	 vNYo/vFVD3wtINMAVdM8CVOlW86oZZMv4VECVyTHbAlGyDJG88yU9poNi5vcxKtRUiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788837;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=pBkZdgNQYkYE9EXe9873Pjk/j86oHA5lh49rx623yIU=;
	b=kev3AvX49JzyvePbInc6tPPweAi8BO84rwfm4FhxCouecCQD0Hs/AvH0NQojPGjY83ic
	 XAkmRi7YGVsbnCJzcfUyv9eRBR8zbHu4q0ApV2u8jxiVoLxbHP1EfIkvnPU1QlXgWxg5K
	 jfvIqt00Lsdjf91urEBaXXly3UvBNuCXiYf47heo+/lQ0+l9mf3hzByXEAMCtXuhd56tx
	 79k5pbA+aua5rBiCVmYLP9dt8Rg/w+fsX+JXh6bk5uzgtyMlSPML6eV9FNeqgSvQFrQU2
	 xmt5YR1yjqFDIc4OJf9wiMPs1h/rNqVs4L4uyM5mYmm/bnAXTEMPUkkQPx4kGlUP4Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Am1R9oOD;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 02800606A323;
	Mon, 16 Nov 2026 00:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02800606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Am1R9oOD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794788835;
	bh=pBkZdgNQYkYE9EXe9873Pjk/j86oHA5lh49rx623yIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Am1R9oODQ97rY8MSknZxBSTVGFpA0OLCkw3Kmph23lxrjWDuAGsUNTgWMgeHJx9c0
	 XKkcxp9sVyxkl0xsG2m5ZE8nU/eTXqmJhASwuwmD4S4i5idP7ZD7D5LOvwOCfYSzFb
	 cio3KIkjtTlAWm8q04oqHlneWL8oh/ANggJEn42YYoEkuQSnolfc80CK1d+TZW+b3t
	 b5F8qZJt7u395tBnkiO3o1Vdq/iWEVo6Wtw1NJ2X2bXn8BpJI8gNeK8ZKrZR4qbtH3
	 DVQ6UNVitfcUdcPy0LioWHUEevut7smKiGgzbFuYQ9MWv75KbsloanQiS+j79udK0U
	 ICl/9ILH4nhoQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id DA28D6005A;
	Mon, 16 Nov 2026 01:27:14 +0100 (CET)
Date: Mon, 16 Nov 2026 01:27:11 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload
 flows in teardown state
Message-ID: <avpN3z_rOyriSHp7@chamomile>
References: <20261116001612.2806263-1-pablo@netfilter.org>
 <20261116001612.2806263-2-pablo@netfilter.org>
 <179478860710.3291.6553894600819959606@kernel.org>
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
In-Reply-To: <179478860710.3291.6553894600819959606@kernel.org>

On Mon, Nov 16, 2026 at 12:23:27AM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.
> 
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by LLM and not proven at runtime). If it was triggered
>    please include the symptoms, like the stack trace or kernel messages.
> 
>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account.

This is a v2 pull request for nf-next.

I am keeping back two patches that need more work from the previous v1.

> *IMPORTANT*: If you do repost (for other reasons) - please include
> the relevant info in the cover letter or commit messages.
> -- 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
