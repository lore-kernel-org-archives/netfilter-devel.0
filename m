Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793783104;
	b=WRe8gG67Q3WngQnkowVIvCie4bfXPnsXGK1JHkh7TRdEwT9dZK6wiu5GCIs34WB3UhhJ
	 dp5kLLktng81jCyswhXKXmeOh2J3ZXP0QaGUg4ybmojuxKP5TxKRJ8qyUajFKdPDlnOz0
	 ufhxwfFGJYh5F1ytClG5MRJwzOhbb8ANr0i93GCvIZHugGPpEp+ZMPOEdSqtP10Jlzd7b
	 ZelMhJXNoFyasBUkf0cxHt3///7CWbTHcZIqTyfXFAA3f3M1daXXAamOSOrRePNoNHYT0
	 prk0mHKd24hZzH3bYdo82HQ3B6lKleC0zyZaSvRnoSVh5SAJGIOgxqCOtdmXCnzoT5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783104;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=BeJ1+ZEVQLZEJsNPtmgSzO5kLlwOm5eGbYdwldVrJkWMBD6LdvYG4k50bS2S63RpCEJa
	 pGjCY1v8umHd+sqmD9vC3Rl4AZmI2uPlmArE/hybPcAXm7QX4sDtDcEju0pcLfhvEHhas
	 nG7ZGMMPwCbkf1pP8X6751AjcoPbWIAW2AbI9Rzta3clg4w+xdrHEDF07NsawQiSf1t/j
	 eyUxIk0WSSMOsHV7Wqj9+O1ot/GpD/RuILAjPXq12EfZ3T310+GfHAseEWER5t6F48F7a
	 ZkhYydgeZW3rGvF3CKBm0l+oABrkVifA0P9HfGr7CCRXZdJ6S078nbC0k2iFtrlZHyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogdohVTD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94335606A334;
	Wed,  4 Nov 2026 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ogdohVTD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC791F000C1;
	Wed,  4 Nov 2026 09:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793783104;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ogdohVTDI0cfEuN2qgFTmiIHWT648XiMpHfL/vIfvwvcjW/ZMN6GV6Q3gH7M2c3Hx
	 QYC2Ou6ihYTksPvaOowqt3sKZpoWIARezoxtisraxJa4X6Ug29G/XpCDX4bxBQMCjq
	 Q8sCaz4rPha57nBvBkyZogpyDaWfLbd6b7ZpvZxmJH0RvotFfqbr9a2hMGu7LlJKrN
	 Fo9qhjSWleyAYz+IVcZMm1eHDD14j12KwR0qZeKatavv0u4phPHujqyoiIaNHYiA/I
	 mWKqAtj/ixP2bp+Pcr27zxzXgYmKHWBqLVzk4sAf/Zj9FKe+4LjeHxDYZ6vNB5IffR
	 beNkQe4w7v9SQ==
From: netdev-bot+sinfo@kernel.org
To: luoqing <l1138897701@163.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] netfilter: conntrack: avoid secs-to-jiffies
 overflow in SIP helper
Date: Wed, 04 Nov 2026 09:05:02 +0000
Message-ID: <179378310288.488859.5501372329923288019@kernel.org>
In-Reply-To: <20261104085925.773471-1-l1138897701@163.com>
References: <20261104085925.773471-1-l1138897701@163.com>
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
