Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793945858;
	b=wyPGwdUZ6J9M7PeA0Bs5wfgGmeCzmhc3ihnimD3piTyCtquyQy4x9oXjZ567gh4uc0c3
	 W1WvMEjV6uYrJimDie8yctZSH5mVgcPtbix/LonuAUVIIShI/EkmUpi+h3gH8Le02s6eI
	 eva95CUAXmnVmbXz7dW2iRQHrfHj2dDL0HDWUm43ISNkK/ancwlDVAOsyeEpVFOty7cPK
	 eSszNrcalVoUQkjzSUX5+nCacwQKJPva7hraPi8MXg/xEclENte6KKjY05/PUuAOMcLAg
	 8xNsL4pHRjwSKRQRy7QqPbuJsPBSdowktli/yVCGIGEbi99rWmbKCk2MukvgGSL36ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793945858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=dy/d2GC7QK09QgoZlz5nxNi8qXIn97lfPrkg+wuH/2ZFWoD3d7eSIbU7X4BSUEqGIXzC
	 mGe+mHlz0OWerWyFPbGZmLVwecCiqZMJOB7XwRpfggiQJukHtbAhab9V+dYvVmIAIj8Ur
	 N93GvjxnyQo4N6p+fhdfYLDKGl0cL4uaVjfs5ZpWlXSbmA8O8n0FZk01NiU5e1cKdkwJM
	 pUAB3d7RkUAIfXxBadBbDNLx2NhOIL8Xf7VrYcZZm45zpglZRohdsog972BMKpRJNacyQ
	 pg4w/t1iwMgbdzZY5FVouR0Y7uEB2WcnnRcA2mb+cdN5CSUHl8BVh5cWxdMwlpxvjoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="S/uMwMUV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892D5606A326;
	Fri,  6 Nov 2026 06:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S/uMwMUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACE01F0089F;
	Fri,  6 Nov 2026 06:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793945858;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/uMwMUVN92cqSAfa5+mJl5DcgM+LIr/SYOqYSl7WG5zmqFrUZboJS90oWkNQVyB/
	 gp1Y3uDf8GOHDW7tFSB+VMzLPcrHZtZHseMJMLf6I/voWmSIt6KOPEU4/Uc8XaCZng
	 x3cNDi2EOKZWQYz9Vx4up/NrToAE7GvPEGUNRvKGZ3+rQ/4gbfQQPKacyv+FWY/mM/
	 wFT6fIqSynznv7T77HiP/pfmZB6iBADNCdlIO7zPHBbRHOnSYPD5vhcClxbEZ2MGXo
	 sCAPtGl8QGlMgN3V8IdMf8AGSJJdb+XN220zI+Jn/oA72K8QwJLe3dufkp8/F2XCXI
	 gz29n3KGK0oPw==
From: netdev-bot+sinfo@kernel.org
To: luoqing <l1138897701@163.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] netfilter: conntrack: avoid secs-to-jiffies
 overflow in SIP helper
Date: Fri, 06 Nov 2026 06:17:36 +0000
Message-ID: <179394585680.488859.7199354601021880079@kernel.org>
In-Reply-To: <20261106060948.540233-1-l1138897701@163.com>
References: <20261106060948.540233-1-l1138897701@163.com>
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
