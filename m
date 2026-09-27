Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EA33C1090;
	Sun, 27 Sep 2026 22:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548847; cv=none; b=Sa+5JxEcCodsBudITTqPV9iObhICgKMXyjxs36rVQKjxjzdEozQpbaov4SWzJgAdVrCsRGQL+bR9MfRbMIK0nBzfiBP8Gcsjrw7CJuVUZJXRW/GLc+WYrZrDHSBlf4gOKqjTTR4A0aC9uDesbZv67veHWbyULzIxcZa93lcFA/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548847; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V3aPWTAVkI3cZbsfm2HJT3K2nfI0l7xhMb9Sjg7gRY9XangNVFvjDvmvgvWsVN/6qag6QTh6yHCi01LGWekSyIOsCn1sksEixIBwd80izrafqnmBRqQwPZJTdOSiP0/ul0oHNW0ipSXoZyns9Z82F0R2Ne4+bvb0j/jF8YUXiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vwr4xsni; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vwr4xsni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D3E1F000FF;
	Sun, 27 Sep 2026 22:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790548845;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vwr4xsniMHg0i/zr6217KURbpc4K+f+AcPavYegbCcCnytYXnNI6onBhZVphjUU53
	 YjUCRlluMvAzu+7ct6cGUwf6anLjVi61BK4D0Sa7tUXmrblVOkKwlgNtN278JUOvQ4
	 cB5mbUSqXHafmHiAi5nO3PJS8OwFIJyMhuVb6d+QECRNb1gE8Xpm4kBFlJTeI96mRH
	 1AZX/LwtfoExSl+/+hNg07l5Z3IWSKsx5PP/dX55EwUy4jHLLoZ0Z46ZSl6SBGpXv3
	 DtNeh0RE/HNy8BptfrIKn1IOgghuNO0Bn8Z9ZMs2hrOBCkMNhouWHz4BGU84UjNhNN
	 yUV2aLz5f2tWw==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net-next 01/11] netfilter: synproxy: fix reset of ct
 seqadj when reopening a connection
Date: Sun, 27 Sep 2026 22:40:44 +0000
Message-ID: <179054884482.31693.9985445366421543993@kernel.org>
In-Reply-To: <20260927223436.269024-2-pablo@netfilter.org>
References: <20260927223436.269024-1-pablo@netfilter.org>
 <20260927223436.269024-2-pablo@netfilter.org>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
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
