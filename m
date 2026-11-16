Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794790046;
	b=pArismPeglzbedQKmbdRtnexKrI4iz/f3d9RFhq8xdM6suLNyFmFqZ/CpwzEmnxN57NJ
	 YpO0/13y5HUCaap8nilqMDZ87lXeI6WEc4F3kMhpgTL07RPM0CJLCU7ub4NXW2glXUHxo
	 SUzvTEuO297YekaPolKZWiZAadkUxY4wKv+CEG9yfurxksAMAa9LUaMrpUxOs7qO7vw6v
	 UGoR85tKgJEEzowk6QP4p9TpdswDZSC8yXFQAwf2c0JrEHZCzPMRyunnqLZziXWcgjYWO
	 IbRfvOGYa0GbUPKvcoV/YE5my9Z/I+fN6zCOFfNouzhj4ZTH9nQLIdnrOceTVsbIiTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794790046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	b=j1u0l54HO/bBMAabWi6WSh7KQthz8CXCRbwqGFzlXht+UKAC4zBxWpD6/v5Y5X9Li+u6
	 f4WQFmTqkY8IKXBScuOP6143gBoPYCnPDLL33pXXUHblM8RZsTXQDMlYfGeNInbCPYP7i
	 nC5AEnkDHauwkXluFOe9/OMIhg8k/O8zlyG+SzCz+Qt/pOb2/f04jGpp4xNRtSd9QVpOi
	 Wf9zn9/HtxZlf/zaG5/RXanRgKvUjD4rDVVq6tpvtV0o+0otuYEnw+vsSHH8CCP2BIf3i
	 E2PtprpULDTNgaUw8JGOGr8jVtN80KDP1kzRpayLYOth3Eji9syT2h1DQVhSyqj1pAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Rmmdg/2c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10A1606A323;
	Mon, 16 Nov 2026 00:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rmmdg/2c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A081F000C4;
	Mon, 16 Nov 2026 00:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794790045;
	bh=oj2zs7YpNjut+Fle9NDI2/nVbuq1xcuWOh/20pAlrQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rmmdg/2cdXH+pAgR7nA07z+reB1j5pEpGzPrR2DoSKQVBEdC7kyLqOG+wFN7WA5pF
	 okcBZE2Qrwmr6nsZ9yzAF/H2TLMk/zkRzkbJgxl2k1n3GzR7iNrZUVDniDkPWmY32I
	 Kn4JhjPm8atSaMmCuvfnPcWtiKGU8t0y3OG3to7F1gXF6am1JmCg8xYnUup51VHYJX
	 u+zAnr+bO5TXb8Hhx6GkcCwzUXVu53yTaHFf7EvsZo+eQaJ1lIH4LeiO1oHo+5Dz2H
	 NpJyWeKcaBrrAjmgvloARcsf2QNMqb5UeF/xAnT5ec5OV3FyiQWO8shLfYAspB1CQd
	 8BpaGhJbiiLzw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/11] ipvs: fix problems during connection deletion
Date: Mon, 16 Nov 2026 00:47:24 +0000
Message-ID: <179479004454.3291.8322282390265057876@kernel.org>
In-Reply-To: <20261116004404.2821183-2-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
 <20261116004404.2821183-2-pablo@netfilter.org>
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
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
