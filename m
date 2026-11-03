Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714888;
	b=aG6dzyWIYViUnbsghF8Jhz+NaJ0IpboQNfQbXZGboWvA+PbMUS4iQjxU+f8N0K/hcbRm
	 AaCBbLzhdB4RyfQhblE2qsXcYDltIjAfUPcgz+QTBL4pBZyIGqa+uHcWXF59lFxeG/HWG
	 M/7FrjG+2r0MoWgp07M9WZWVh+nrW/P8JHWzECnZA7Ie/PRRUVl2X73PFxv/gy/AKsL7Q
	 XbdDz5mAQAM9A/OOJ9LF+SFsdqCN1PKyWMVbs9y47dpOg3vib0SOAMSyVHBJRIdJwvjSi
	 qa/NbzjRD+UEiTx2cK0SZ1AIPzISpeauIs3dD25oz2+5S+s72WX6/NjQVFSJpFhM97A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ZCAoLYZlSrLohEk+mBrzJi43HvKosm2TxiN/tMhp9/s=;
	b=civvBWHWV/Vbm4RsagV64UKD8NzNaFB00pcxl7Eipe/DVm4KqSgKqCeyKCVIizC3yRPW
	 +2Bup6oyLVvD6mY50QLd54I4Hb//WTd3qT0SHBZyNsbHAeiIWlwrgJjKPOcZIleQj+aCz
	 NbYvpWFt1VQd35isJ+vN3BCS7V8hgqw+arD7zPXmOYKCUFVuwQsBc+gFml6+PRtptG4Ze
	 7BwpRLrtkSeoD2gg3Rl2GZVtduJi4M8jIN0bgyZvAP739KxTY8BX6j0PJMlkiPKl6Rli0
	 c+EEOgc1uBRffUbm/H2NcnrcX2LLfpvj0Jo5z3/xQEaUCK6PQYfohf5IZNWhYGskBLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTXOIyOQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E4A606A324;
	Tue,  3 Nov 2026 14:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YTXOIyOQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684291F000C1;
	Tue,  3 Nov 2026 14:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793714888;
	bh=ZCAoLYZlSrLohEk+mBrzJi43HvKosm2TxiN/tMhp9/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTXOIyOQnrvfYJZNJQkCB+DUT2dDQbJsmBOAiEt1O7kstrNH3ZZUyuZPM8BNh27xY
	 5PZFMdNoZ3dBiG3Cyn9yHmGibVWdNkv73/KKkk+wxTT7eVsga0JEQ124uzf4tWvnSZ
	 uCCIRNMnGiPm7XVnhKXKV714Gx7nH4sSMp8sRPuj0+F2xp/H94zcqUZ54fX1bsdOky
	 qAGeuJwxhFa+sPbQRE+mlqFhzsiHVasPgf7jHWAKQT8II3wyrmYFp2EiODIVoJBrJU
	 Rq3pobXL7K/e5v0VxDIdTLaoLkN4aIcAhnY5FM2ClwXB7UzFpjb7OI8MY2gXZA60qI
	 BOKFpOcicVX+w==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: 
 Re: [PATCH nf-next] netfilter: flowtable: do not scrub as crossing netns
Date: Tue, 03 Nov 2026 14:08:06 +0000
Message-ID: <179371488692.488859.8707984454002960043@kernel.org>
In-Reply-To: <20261103140308.591690-2-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
 <20261103140308.591690-2-pablo@netfilter.org>
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
