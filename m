Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794790104;
	b=xTiHesqXIqQCjZaxzTRlhZJw4NgyXjfWpeA+rxY1A/kGfUvzbjwSsIjfBKyamAqBiTPY
	 dzwX6gce1X3yWBKCY2IDo9wFrQswvLOo0va1sJkNBz0diPkAzSXrhk9w3XOY2DSPZP7Wj
	 5kPRtC1akFgNjqE/VTHE80MEMQqGQE7V+0oNr6oFrWkzLJfUw/XdLmMyxYjbZeqKrXJWb
	 8s5Uzn1qJ25XLwKso7ZT7yIOR6JGaFltQx1Xh9ggCnOtCBbBsK7itOBECw+v7GElNEAmS
	 NfRKBLdflKnvHK88OUg8A1BYrQFaU0GQrWv9eMFxMGEwSQkX4vTFC0z1IjAKZRSuG1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794790104;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=j4z437CErRttFgDcoek0QE3JQHKL0bnc1M3lMGTwYzs=;
	b=4rmZNuf8jIZO+nOWwncuyNl5XW3KoqCQ77SQzYiR656x/qBSIJvUS70vKtOhx+AmfVpV
	 5WLqIv/jDugvP4WWY3vlOfXDyvZeY0Roc3RaD7KS5DWf7DmijMLAqXmGOjH94kFBzhJqI
	 iNVx5WKv1eKUiitXcorDtVbqNer2QdsrFiupJGlpxUtwJ5M0gl9teoDsINlF25WLFx+YI
	 4szekJnyZ6+m6o9o49K69xREri7YRNAyzLk6uEFE0JizLdClLYnig+0qdlvrMoYN3w/rX
	 HWVtY/BYALAICr4SR8D/G6Pr9hj/E68D+fVxp2s2XUS9GvS2JQWQOZQNUwctoemVRLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QqKn2xtk;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 00149606A31F;
	Mon, 16 Nov 2026 00:48:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00149606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QqKn2xtk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794790101;
	bh=j4z437CErRttFgDcoek0QE3JQHKL0bnc1M3lMGTwYzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QqKn2xtkeaLHha9RNfEep8NK1dwP1eLp+riSyUscfauxWrfHs3gah65iwLKGgfJ9y
	 eqSQbZ/fJNPIKpKzeDZhJqhrUsB4D6uEyUbsWX3NfBrwQi/uo1QR1W33oY7lAs/mlZ
	 qYpYK1pt4w9MIw7KqijnWxJGNlFzKDRB1YPOOdbBEeax/xEZWa2KCSdFXq9CvRBtz/
	 xlB8eukCOFcVimRtium66Je688fvbgafeA2Lg/zOSzdArETjRFyw+htAs2VEkPmi4E
	 7Ei7N8M/Q7Y0JocqYt57gzQUOE46B3PhSJACvNuBOxosz85Yin0rL5nvoQSznRiztx
	 g07VNfSB+9StA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id A7EF76005F;
	Mon, 16 Nov 2026 01:48:21 +0100 (CET)
Date: Mon, 16 Nov 2026 01:48:18 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/11] ipvs: fix problems during connection deletion
Message-ID: <avpS0jsi8HEby7Xh@chamomile>
References: <20261116004404.2821183-1-pablo@netfilter.org>
 <20261116004404.2821183-2-pablo@netfilter.org>
 <179479004454.3291.8322282390265057876@kernel.org>
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
In-Reply-To: <179479004454.3291.8322282390265057876@kernel.org>

On Mon, Nov 16, 2026 at 12:47:24AM +0000, netdev-bot+sinfo@kernel.org wrote:
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
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account.

This is v2 of this PR for IPVS.

Keeping back the patches 1, 2, 7 and 15 coming in the previous batch
as discussed with Julian Anastasov.

> 
> *IMPORTANT*: If you do repost (for other reasons) - please include
> the relevant info in the cover letter or commit messages.
> -- 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
