Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699962;
	b=1GVORxVVehlW1UG6y6JvhzLFq4CXNN6w18kHYtKSUSAcFla8RRmgSVbghr9WFM5VvGbp
	 //pUuKfI7ToR6rWbnoarCPGcGG1IpPs0/RG/DK+w4C5UAcAIr4s3l0TmPjSy4xbOiTkVm
	 Cg5GP0iU12Qwxr4nlYbkL/gn/uO7w5eQ75I1VPfsPOpjT5F1VmCJK6pTp5bIbeR5aNgRW
	 LhgHRGwskhIFJxI0Vs0jkSjazYgL2te5bED1kuJ4vycIQsCKAaffDt6TaMm8SatFk5/jU
	 JZi5w+2iHYwem0JEK9sa+qL2b2AKhsghCYXSnoSoOj3ag0FOLiqFBX0rX+m7Eji3ehQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=unNLrtRsLoEGpFgoanmKliCly/4Cb8Nih+czK6hyPdyEK3wqrmPgWug0pAj8CH2XQhPe
	 Msbo85o2qkgF8BDaOjC8dqCKjf6V09X9SVUJ+0J8CoWLmHg6BHubINgz94KmAYzQ/HqK6
	 QVvSG0CppE5FfV6o5lMQe9DLUf+LXmDcElPZwRtTqdaAbYgQZTFu/cEh1YAtxO9Ydmniv
	 nyU3mNPxMmzJBOBmDhR5rHA+284Naq8uCsxWwy+0BTlaaPPZQTC5g6LI1FdGie8OWXrJ1
	 LKO/49WoGXERMQxC/lMJLKP5W510JVdlPTg0QCaxAbTaj7ZYTXH/MVCHVcLKO4Tij3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ekpGyn/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5112A606D80A;
	Tue,  3 Nov 2026 09:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ekpGyn/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A9D1F00919;
	Tue,  3 Nov 2026 09:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699962;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekpGyn/RMXBJluqauiXadcjEGPHyxEYiE1L4EKHUbFTOtLPclumaiYTEXeTJqhM1q
	 gAYg9lGO1LThWiHn2KYeLrqHSA2I5t8kCfHyNPjxxcugzPuyeWtZl9HU7mdt0yWW7d
	 NCVabrpODzb2+x3hWw7r8gcf47qYHkuBqALGcBOggJHYZU6CFb/YK/azxbDeAdzB+B
	 tubpY1Fse5+L4tXNJ+bDOqVwjL6RslbYy4ZvaRTLDzCqhmLXaAnixeNUF8q/vpdnDG
	 k574nKf5x116zGqoQo4csqTFLvEqg0iI6bAdTuHDmhLafj64KQRj2vmvl760foLD2E
	 18rn0Uhn4n55A==
From: netdev-bot+sinfo@kernel.org
To: =?utf-8?q?Jo=C3=A3o?= Silva <jgc3silva@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Sven Auhagen <sven.auhagen@voleatech.de>, Oz Shlomo <ozsh@nvidia.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 
 Re: [PATCH nf] netfilter: flowtable: do not clear the offload bit twice
Date: Tue, 03 Nov 2026 09:59:20 +0000
Message-ID: <179369996085.488859.11933291398858368008@kernel.org>
In-Reply-To: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
References: <20261103-flowtable-offload-bit-v1-1-20f5952c00a1@gmail.com>
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
