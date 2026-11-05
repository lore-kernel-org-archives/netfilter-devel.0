Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883262;
	b=nBQxPv3+LJrtMI/6g/fZfyOKvzJJF7RVRC9l7Z54xzZKYyZjlu2sfh+QhPy/CbOSqWaK
	 8vfsL/2qmDpJmLQR+94/mai/qIOUe8TExpH+WuY6RF1wwTvbyyJ7CQHo6yVMhhp0H+o8q
	 lJ+S6x8ZmznpxTNK88zMSoiUk9QdGhVgiHhE2lB9GffOjA9aAZ6dSRYHXSQK3+BCiZPa4
	 jSQVT8A2TGjDkFs+ypV1TZqA0D2IhyEDYJJ63URXH9ghN008DTeJUV4430hAoqxwO81dr
	 5I5lwDTwrTCcU7JVfW6kxjhoLghthMoIdKcN3XfboM4Ssk1uVr3udAQzlQLHSGF+8xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883262;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=a5YfLQCqKFTYOgIigrq82QFtoB5H5wIXXdtLlLWCsIg=;
	b=hNQtmVKzAhQwst5CYwigtWQ55Ap0JvP6r/pM5igPRf/Eo6TCegh79a73w7w1E3TN151K
	 S+C4NJS6SLNvLjPigGqF+7/S2D5tPf1GDjhodeyUSK1z0uZTw66ho8GSFOQt/hyGfUM2Q
	 uYl14Wmv/06+QeV7jv41C5z7TgFznaOQP2c7kAEQWlmIuvBjsuxL9/Ue3131P41zRvFRN
	 M5NqA9OGJFhRY8HluntEtB+nl0eZl0oZKduOQsQsHUgUmASgfcys0BbN7vzlzPDo/BVKO
	 ovR4rdZElLZmO86C7LCZvsU18cOQS5s11UGg/FipC9Uqb/dPhq70Ec/z+XEiZNckE7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pfRnLvUd;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 5ECDA606A329;
	Thu,  5 Nov 2026 12:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5ECDA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=pfRnLvUd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793883260;
	bh=a5YfLQCqKFTYOgIigrq82QFtoB5H5wIXXdtLlLWCsIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfRnLvUdfgwXcS4asCDXnVFcABDHo25Q6h+cvwf5k5gLViv2qH7FVYDx9iD3wAt1G
	 NjdvvgTt4hRw61vral9Sx0qnUPdhaOQJ0LikrJQ7ROos1A/fDUT3zqKo26fYPIeHaw
	 FfEHMdtefiKhkumsVTzYgARSb7EvZVT0nnOKDNDI5myTCn+frlh+d5bq4izAcrB9iq
	 Bi9kvkPVI6p7Wd+9fxYVywpmd6Gg+2aEojQhY8C3LJR30pUjmpjGSSQNjrs6222NTP
	 QVlJNrrrXk/KILtsTSqt2lJYje1dUcXaSNkm07aGAVBde7m89oH/1jQPJ2S/fMrWyl
	 ko/PrykoNDIsQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0817260077;
	Thu,  5 Nov 2026 13:54:20 +0100 (CET)
Date: Thu, 5 Nov 2026 13:54:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/12] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Message-ID: <aux8eSGDqNFpGqyd@chamomile>
References: <20261105124536.1009301-1-pablo@netfilter.org>
 <20261105124536.1009301-2-pablo@netfilter.org>
 <179388304137.488859.13511108402287791390@kernel.org>
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
In-Reply-To: <179388304137.488859.13511108402287791390@kernel.org>

On Thu, Nov 05, 2026 at 12:50:41PM +0000, netdev-bot+sinfo@kernel.org wrote:
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
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

This series was primarily identified through LLM-assisted analysis.
 
Several issues were actively triggered and confirmed via automated
testing. This includes KASAN reports for use-after-free and
out-of-bounds access, syzbot reports for warnings and panics, and a
confirmed sleeping function call in an atomic context.  Another patch
identified via LLM and subsequently verified using a userspace ASan
harness.
 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
