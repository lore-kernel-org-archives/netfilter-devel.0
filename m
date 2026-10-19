Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792425361;
	b=URUjgakXmNMUiRolOrgYSz6rn8MYjM4UauISNJMv4N20mS2QgbcmBvDxMDA7iG9mciVa
	 6Pynqw2sDBarXWBzQLls9sia7Dy+v7sUZhgRuIesAuy1LelxxpFjv0pLBot3s2/yRK7Cn
	 +1QsRR9+Aiwi5OXnRnWHPiAgkffOvmnv9R0j8WKx+/lAxSId57MjtZk4TlQwUvVz3gJQe
	 d2G2Yu8Si615Cwxs8Epf7jQ31kV00KosX1aMDobYryEyg8tL7m4lmQ5LBSpP0QHT4fFye
	 2iNY8guwT/WFD2f/oq+cWfUVgC7GdfC2QyVB1t1l9HYdPqgCS9PDZtqu99N604vPIbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=uvFQ5aOTv0UtOOvuySazoAE5JzqAjGM3dkc+voj9yMO5GlJoV4JLkTK0NMW6oTaN1byQ
	 4r4MimbU/Fu2NWfiyyH/Ticfc6R4JaAV1sYJSyArf4cCjrfywGpJ4P7ul0L1DBco4BZSN
	 BtDv89pXDnoZPqZz0ABsNQPg1KL1+QGLG2oc7V6CAG/qmAOLHvh9KChViEp9KMJA90WDc
	 CF3SFAJOWFf5CApRTqf+dpuxORMaYr0AMr/HEPAaUmd3LoQ+ilsVw8fPPisnJt7egV35M
	 j2Hj6VFxOLJv6l3coVP8wvdVXQdlRP3Lpst8X0HI3ZRzXB56+eO16xNLDQCTx9EztDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKJDx3ed;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB59E606A336;
	Mon, 19 Oct 2026 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKJDx3ed
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1685A1F000C4;
	Mon, 19 Oct 2026 15:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425360;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HKJDx3ed5vw6eUKKRjh5bV2rSH6K1oZ/DXU8oe1/gYf/B0Ox+yNgynrxsuzoY+rPy
	 iFSekAsNwbx9Uc5mQstQindUE1VR+qKKm5GMygT6fAoWWqYGLohoQ8EmeXJTmfGubA
	 1lVNvl5llzEKYYkK0FX0X/NydOCu+tXzahLSeP5qjX3P0zXAujiKk9Hqm9x2Z572rd
	 YpWGnDNj/N+S8Y7Xg6ATtbmLXCSmL61RKw2SdYLori1PG1oBnPzbijeaxzk4Ykqvto
	 9yN7yeKQQ3+3SWCzGpTkBEkSlCrTYwwk0biHBWvBrrhzOEhpxK73/2EvW5qnEq+D1Z
	 uyGCTJxicqFEg==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/10] netfilter: nf_conntrack: avoid truncating IPv6
 nexthdr offset
Date: Mon, 19 Oct 2026 15:55:59 +0000
Message-ID: <179242535961.3290.8970179296932068352@kernel.org>
In-Reply-To: <20261019150249.1879516-2-pablo@netfilter.org>
References: <20261019150249.1879516-1-pablo@netfilter.org>
 <20261019150249.1879516-2-pablo@netfilter.org>
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
