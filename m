Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783351;
	b=ywPorA+TCn4+qaDr8hVS+WAmHJelqii9/tdf+r8/XMdQMhrI2sQ2E9q5JXYQn7XJ7qLv
	 kXy4uw7/oO005JhUTqON3EL5ms87Wirpo1i9gOtDW6lEvUVBwWcrG814YbUaAuE8Uaoyk
	 gZx10UEMDXVuhX5hbs42JYGcR0HtEURisPzeaN1ky06YCHDSJr495HiWdvX2MiOc/0fz9
	 8LcC8dcj0xkGboy0YV/IerTn+ibji7kel/9qdUrGgvrk+JeRXukYYUR69M9qn72kIsKFN
	 4nLX+Q/uSZ/b93DD95Go5zPnMaRCGobNiaxBhuh2n8VBL/jNqDQRZ1PyE1NsvL+jFPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=pVhc/GWmam4S+Db8ucioq37lfjx4UvAKjNoevi2U+gYYNho9gcLECcE5W+clXF0Dch3Z
	 TCBLGmUYAYB87DZlk+1iyyaXLTjEfi7ZHL4ygiyBVNIkWQlxTZU3r1hkqVDc2ET8MwMmM
	 HH4iq5x/DaOaFhlqm7+Qht/YExdUbjDJieURVaUgzw2clbjjydUH1ZEdo4KrR3gy7/V3i
	 9mPW2v8OwAwPKIHbrnCnVJQimAq4wor6UH6gtHbZ/5LAOgs3YLBxdjw9mBXdvsIU4UIYn
	 0cYwnKRpvAX55WVg4QDbajrg4eEKcPOJ0hDW0J/x8pDkxonLCJmacPc4ch1Z4uiL3Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQoJ7B1D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A5606A337;
	Wed,  4 Nov 2026 09:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XQoJ7B1D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5571F00A16;
	Wed,  4 Nov 2026 09:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783350;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQoJ7B1D1kOWsNZMCcaZwagivaRjUdWt2dgmGZEUdWuGM3HvAKfIn30D0LvtHvhPC
	 x/1bMFGNKlGPYamKYQXV7+LFW91kcxKRBBDxTbDtDYJdkJRpxLsNgxNL4KHEvb3qhM
	 zySgaTziTU2r7GL/NlUmGCzwZbdaNYh8IARSc7QmPnXjOdgvH1AGRBPuuYk1L/02u7
	 Ch6AzJqptO5S574IwvUpTP3G57rqv4l1r0eadqcMuffaGTzJ9lGRYFC6XKQQd59cCS
	 LErqw9PsBHZ3Ind7H3HcfRyuJfocKynDS4RcjqLO3A7RTGVm0RJWnv9gqJZxLm7QYP
	 vCtBP88hS1ylw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/13] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Date: Wed, 04 Nov 2026 09:09:09 +0000
Message-ID: <179378334968.488859.12612038847819403251@kernel.org>
In-Reply-To: <20261104090224.750548-2-pablo@netfilter.org>
References: <20261104090224.750548-1-pablo@netfilter.org>
 <20261104090224.750548-2-pablo@netfilter.org>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
