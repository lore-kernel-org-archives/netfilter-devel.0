Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581168;
	b=nO9aBFnVKuQcY3kjw6JDYhMYovMKd/OTzFDff6c/SoiWFitCg3JjEPDxDNJ+Qaksx7tH
	 DxrLoDBWfGhquLZOdn7DyqtghyD4Yj1a8JSl8lp65Y1eINNFW6GfYjxrg6rHgbm0aBbvs
	 QZVomC48z1LbPtR2MoisinQHVGeE9raYqULc/ZRbJ2lg+JuulwB07k4YhpwqajD3CWWie
	 lAgZ5SO/J/oRJzn2iU60FV3zvexzreo/oJp4KrljGVM+v5Rob3oksDqrLG0w88zQrxuUZ
	 Y3qUaYfWGYKonnhKRabAZDrRhPWIJpcLE62uTX96WhXd5rTqBZrh4L6ExXCUQtvJfUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=ghmT0G33ItcHIPHurqROoOfH1GlAVqtCJOo5wHV665r8033q6E6BDxpctZIHnjcu2cJr
	 PLXpNNvEaZPFYoU8//p183lxZvS+5EX4/lXJ6SVzt2dclX3xLQWiEBUVa+lzk0fCgdPeU
	 kvOstWXgw1Kxf54QTiNlQQRV7ziK1dmyreqXp8c7P7xOSF4GByWKqILjt5waNxVkFTsXv
	 FEDlCs9rKT34t+aFMiT65Qhux1/JEOJVvgzMZTEmY36IK31+4XoIgveGjSW4PgpFCsFVh
	 UnwyU6E1Zc3V3asmEH/vkDdyRt5XoPkNI9dNmWEjlPPps4Wa8bJzupPUXSvsEBKfkQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNqP0Npd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB87606A324;
	Mon,  2 Nov 2026 00:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aNqP0Npd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A7F1F000C1;
	Mon,  2 Nov 2026 00:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793581167;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNqP0NpdWdBZHEnwX/xsdBX1tsQAOtoeqoL1gb57Daqn61DXwkRqJEbrqSw8Em9pp
	 4xx2KGNuByW5bCkF98khxnCAbAK8Pv+dT3RCYsaIHuZtRRVQHTd5Hk9TrAhZAJtjxr
	 ZtuVD0HujGzpoJKQssG+XDZ2a+8qpR+0jG9DoSomzXj+/MWdhP6qS1bQtF2F5Bl+ko
	 BJ/eLXVtFJSAq50+kKhjjcUowLSIQWLehvDyJ3WSFCZ+m4IfzqSn7AJIFkbEt4Jpbs
	 8Nxe0bLYg7WAoRNnMIR9Q3xDln1hfccKc3NfK4nFeT0meQ6DDl5nbCvqW6Njyh5tkm
	 n+/7JvKaAIqAw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 01/15] netfilter: nft_reject: prevent unbounded
 recursion in output hooks
Date: Mon, 02 Nov 2026 00:59:26 +0000
Message-ID: <179358116673.3286.17229865634602635672@kernel.org>
In-Reply-To: <20261102005654.532438-2-pablo@netfilter.org>
References: <20261102005654.532438-1-pablo@netfilter.org>
 <20261102005654.532438-2-pablo@netfilter.org>
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
