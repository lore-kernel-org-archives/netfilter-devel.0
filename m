Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883043;
	b=vHJpWZ+lqP+Mz868lTKRn+xGaYspGzLTF8HGkI52AUv5pX3+INgRHoZHooRsAZV2ziOV
	 tG2T0UwQLqlE2tt5m+RCblRmqtdUoaPtFZZXuiHeZ7A8Ueho6P6CJR4klXFLgQaJ5aelm
	 WEpYkbAWwQyoZg+hf0nCnTPey4340ALHTdwPK+W+rxxtUjm5BAKpjkiGD7yqBW1Pr4mOZ
	 lHdqEeaAzKLuZwdL+2o0B7GWcB5sJHuZ76ojz8yWSV/EYzf/qavXjviGnP+jX3wO7irgw
	 d93oI0uMzwaG9t2bAh4/FMlOkb4Y8o9vxQQhb7G3pWCnMKVNhkqlznoT9c2pdDNVWuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=NTxPHCyzLgOlLvWYRdXDMG+RAVGYYKap489a3eU1n1MvNmmSM5teZ1NF2rhB+k+FcSWJ
	 dhqXCk6koUAflMMl0gr9967rtBj9gmSOxqgHad2AsiNx6cBZWWU7FItwHz1ae6GWXCMpx
	 h04CMn1vSPpKTdmZw4BGO0u4mDles5IlrdtEVg7XdlFOYLHG6PMPOpisj0tCRH0sWqBtf
	 AYDveqDBCnozxFp32ogzBjIMpO/GEo3b0KcmoCioMGw1aZZh6kYHO3jJMytD7ihXiAXSy
	 eSj4j1hcJMSNxZlHG2cQXu1DeXkMTnv1MbYCKH4lxdYwgWVS7a9K+aHsdwX1Aw9c9aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OBWvYUzq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C24606D803;
	Thu,  5 Nov 2026 12:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OBWvYUzq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCFF1F000C1;
	Thu,  5 Nov 2026 12:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793883042;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OBWvYUzqRJtM9Gz3RLG3CzMj5lFVDynHqJj8GUCk/aaonDTGORkstdgAgUj2F0f7q
	 ydDaexr9nHttbS6UhVdTHe9TdhPB1TEDMpwF5HO1hqEocZPvjJIkx7FPmTO+W9/nK4
	 neTQjDmwpd8kKTNXwNLmu0pFSdBParW7l9CeP6rpTx5kJFEDNtvhyXgi7D3gJhsHeP
	 GdCK/gdck8oENgSPOAvSkFkU2ISF6p59tuZWUCIE8ZIUsMgsfiwESvrPipotYLhDiV
	 MklVoKwFnZXHxOEfWZ0PlxD8CP5W15cdttuZqdhEtlI/TtCgjULlyeyueXaeFwH+0q
	 L9aByPlFA2QTw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/12] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Date: Thu, 05 Nov 2026 12:50:41 +0000
Message-ID: <179388304137.488859.13511108402287791390@kernel.org>
In-Reply-To: <20261105124536.1009301-2-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
 <20261105124536.1009301-2-pablo@netfilter.org>
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
