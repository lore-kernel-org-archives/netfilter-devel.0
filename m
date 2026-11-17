Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794938625;
	b=eIb0i1ohG1CjZsymQdcJ1+l3P6Xj1cZrt5rVknNPSqAw9WNOusi07hPNc8dQDF1LXq0J
	 ZsA49RwRf/JfyQZAuAHmXOiwcNQkr/oU4iCWA0IIKyliLxUkfN9ZIUn8UqZyCYnycpnMS
	 n7FpHa9iOE5QiZ/ZPzAcG4BgOjLJYoVhyoKeURdRH1y+nRSJmhkuKilY+KpvVtzBd5jXp
	 Uy+ZBU+OSu1pWG4LT4HXDOffR8IIgcDtfLL0ILT2qrqzMEwpwQbK7hpsH/BXRSJNDulmK
	 N8uICJ6Dsikv6DdXKRWRcRtjG0KZ3PeQ8n9rGiXpPJ9qt4DFs+xl243b6HPVl+FxM0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794938625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	b=AETIsOPX8Pmi5GFoNcJsmyb4ABgbQmCKifmtAyGdYrxmra9KkfrlUNs+Te+YYB2nIMt/
	 hsrohSDfFQk+zElRMwTaFrBuf1XwdBz3phrFoGhmpGpfBOQvPaq66hktvqZA+Qx+lfnlx
	 ZYprVPg7aIZGwI4oeFf3kUsfOONcM8MT5Ze0AYWIDI9ug2lEZDsNH6NLF8qUgZlx7ujgz
	 w3dssWCpOlxEqZyXwWcr0UCSrS5s3tFj3+n3Ir8uslpStjLIvZBJbq/Uk+vijzXfvuw5B
	 lWvrtMBcVcSHD8VtWeojWYRhtwBqqJ3I1GaOrmj04GDNjuumrtxEeM0WUWW4DKeAN1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghti9Uop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40100606A31C;
	Tue, 17 Nov 2026 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghti9Uop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C691F000C4;
	Tue, 17 Nov 2026 18:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794938625;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghti9UophXkJFVoq0xqD8Ztb0FHBN6V61sdUVZzo+fQd7Kl3YDA0XxnK8nbMYevfZ
	 rkAckxRR2WBGE9hl3TgR04Oi95icmyT8mHQxSfTqBs2gL0VMgoYBfg33msXsFylfor
	 w6Xq2KWqqFG7CE93A59KZl459Wzf2i3/Glnd+UsAtupw4RX7tJIGi8eD/NTTE+/Rum
	 c6hyBr+JzbsgZRsvTGdNqE9Uq5TWfuIfhFpSJnOjloMW8z1aO/L9zPAbYzu4rcVqEB
	 eOtu9w1/tsIYzsSZAy7DTh+KSWt6V4Ka1avopYgFuZP0HoIpzRZOEFzkxnhJrnUIBO
	 e1YPpJxyt4Tuw==
From: netdev-bot+sinfo@kernel.org
To: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net v2 0/2] net: do not point a pskb copy's mac header
 into uninitialised headroom
Date: Tue, 17 Nov 2026 18:03:44 +0000
Message-ID: <179493862400.3291.2769900460506386590@kernel.org>
In-Reply-To: <20261117175835.745796-1-theodorlarionov@gmail.com>
References: <20261117175835.745796-1-theodorlarionov@gmail.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
