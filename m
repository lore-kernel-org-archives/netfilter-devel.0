Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715102;
	b=Grew1+uiMAZ+K559JodSLnRC//oExoqliGYnbwJJzPpMrSEYGA1tsTHHDVQXrCFFGGhI
	 f+w3IoPhD9tcYmEiiYEGuFzj5rTpJz4mMpMmMzGq45Kd0jplfFyaBCs+mmJVLNXROUOLH
	 4wO+5Ff6NqlnPCau+h+DV6OXh7VlBM/9KusmDMqcjPT9n+0oSc6VYUkid/Uu2xSo5gPxT
	 G4jGFkNy4Q9TRpgAfhuh977jDSI8RpsL/hzblWLFgKkcVt1jaCD3W33SPMkn6LZSf/KYJ
	 PTq3o+3H+8aWw/yuCwFE4vl/wpuxurWy4UyIrGgF+7g+J3DvZ9YydJw5iGSgQ+hBtSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715102;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=9DET/uzVc46zJaT0X6OLGMdVlG71BZl9kF0qp53v96s=;
	b=Ue+H2KY1vnfPWwtnxys0FX3HOA92fM7NtQFTB+1kFSbPKzu9rB2uRVWhIlfWwEwY9Vgq
	 N9UMA78EDPV59zs+5WMnE3jEg3v3MePMqHij1FUVKrQj2S5oIPOkAGg2+MC2F0WJjnT8Z
	 +w/go1ssBPMrwcS14STMZf6GMHAxBSepRSAeD+D3vWfX6GehmCurIfro4+IfgbmIgNFWw
	 EWxBfkyVUrDEvICqboXhoDZony8j8JI6YBuD7Ptz2bx8pO5V7mNOgwFlEsXsrnklshvnn
	 5mCmNkYyfLuALKbBOuOPPWnKblo7YnosMsen6WNEooaFFfaKukPXzMMmDgzfD97BdNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mmCq49kg;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id BEE8B606A327;
	Tue,  3 Nov 2026 14:11:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEE8B606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mmCq49kg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793715100;
	bh=9DET/uzVc46zJaT0X6OLGMdVlG71BZl9kF0qp53v96s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mmCq49kgaVxwsrOonkjFkk2tnoxgPZBWswNwYbNY5Wrf53qJiIApnARlfmAyZkSKr
	 VLoZK+Z3TX47SX9mM8u96Grv7vNOcd8V9CCqze2fqzc/iLZ13KpGV9dB1x7jUj7N/G
	 TBlBSo4J8hlgEzC+tBvhzyh0EV6pxwVKdJ9OqYmtmUKoqkm92DlmCZ+JJw+ZesBWUQ
	 gF6PUK7nGXWvphLrqJ+/dX2NPTndtj1EG/1eS1ShbgYHXlExxGI9N8sNt5IajIqUTo
	 NeIyO8odBpwAhPWhK3AMOpQCEgH7E31AJ8yb36z8lRSDDi02iSzQCyTsBUX+7Im/Ms
	 0XC6Uxwi01XfA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0284760090;
	Tue,  3 Nov 2026 15:11:40 +0100 (CET)
Date: Tue, 3 Nov 2026 15:11:37 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sinfo@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/15] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Message-ID: <aunrmWjwz3BMQmf5@chamomile>
References: <20261103140308.591690-1-pablo@netfilter.org>
 <20261103140308.591690-3-pablo@netfilter.org>
 <179371490251.488859.10524309340047922861@kernel.org>
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
In-Reply-To: <179371490251.488859.10524309340047922861@kernel.org>

On Tue, Nov 03, 2026 at 02:08:22PM +0000, netdev-bot+sinfo@kernel.org wrote:
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

Regarding the automated request, this series was primarily identified
through LLM-assisted analysis.
 
A summary of the discovery and triggering status follows:
 
Issues triggered and verified: Several issues were actively triggered
and confirmed via automated testing. This includes KASAN reports for
use-after-free and out-of-bounds access (patches 3, 4, 11), syzbot
reports for warnings and panics (patches 8 and 10), and a confirmed
sleeping function call in an atomic context (patch 14). Patch 12 was
identified via LLM and subsequently verified using a userspace ASan
harness.
 
Issues identified via LLM (Preventative):
The remaining patches were identified via LLM-assisted review. These
address edge cases to prevent future issues such as unbounded recursion
(patch 1), infinite loops (patch 2), stale connection growth (commit
5), chain depth exhaustion (patch 6), guard loss of recursive count
during reinjection (patch 7), NULL pointer dereferences (patch 9),
memory leaks (patch 13), and uninitialized stack data (patch 15).
 
This is a LLM answer to this automated message, with a few edits.

> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.
