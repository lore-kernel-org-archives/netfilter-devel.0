Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793925682;
	b=ewRihQKSn9NExCw3jteq8sVlcLMO/FgQQ6rq/EcRVWVllsKY+vEH2vhcnseZaUamD8FY
	 716r7RRwscylNUsU9raJdD2UDtcpMcK1OyiAATnylaOIaLBlbjRVgH4LI5aSRfc4jx4ic
	 fW3JaUxR1ZcmS9Iv6lORKQcw+r2fAZjGw5nQxmzyuBfe0ULAImwXWRRzNE9TlhxpXtJsi
	 jABmqsyf0kKFMWg71HgoVCvLTCEH3l+aEPQajDLRxyFR/YBE7VZncKI2G1bMzHz8KFspe
	 IvwxgiPEdSoP5GGHxdGNGmirwlrB5LmLe0ycTagzCMAqwfjVHcw2LUaltMC1EmFzncA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925682;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=FQaVjs4v70n+bS3vcX4oAwE1bNgr2EOseGURkgoTqdLnRnHD4beWwbVJqozzCPAf8Xil
	 ld1ymd6FaLVoR6JxmZe1ZNbRk8Ia50WSw6RoUayGM2HPwdZIcCdq83fgnF9MGUqvxKo9Y
	 bwt1If6+Q3/41MHqauddPnGTEO6zzhfBTV5mUFe7eSh5E98wfzK6KBsStjuNlLpabzJgO
	 Q1+kO8uEjVNLW5kdp3emiBbn6E3IEcvGLOwzbmJ0DIxr4Bf8GVP3g6i+qEPmXqVUlhhaE
	 wpF7bjzWgfrLzQ2kEmwNo67vxPtea5klTuFlc7eSGtUFNtps2NUyhycDTvrA9v0v4YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I20IEdUd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96D3606A326;
	Fri,  6 Nov 2026 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I20IEdUd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305EB1F008A1;
	Fri,  6 Nov 2026 00:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793925681;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I20IEdUdk3YBQo8Pk5BIWm8+qQcp+RYlqIQLRcGi1T3WsxpOoml+A5yWgioV0ZNhD
	 3F7kVfaVizzlxevZqhOxi1qNcgcdiucV5CL9TMsfmkEmZT1/UVx63Eo3tuAxlHuQ5H
	 AsRVYTkXGzKttmIDqWj0gw1L20nR+MyO1CUPRVoYcr9ipzj88p51gE/biPjR2ouvH3
	 dmsCIqyyHSeXWVQ6t/ya+4SsqfWlIf1u+uyKet/SS6uesko0ioMaFPcpa//1Zxjl6B
	 fgnPTcygnaqbI0U//Mol0r7GpIR+tdo4ArUtBeQtoL/Sof6XWU3KtdFlguhE9jFD2b
	 UQsGFjAc5h/ag==
From: netdev-bot+sinfo@kernel.org
To: alireza@asgari.net
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, kunit-dev@googlegroups.com
Subject: Re: [PATCH RFC net 0/3] netfilter: nfnetlink_queue: handle packet ID
 reuse and large gaps
Date: Fri, 06 Nov 2026 00:41:20 +0000
Message-ID: <179392568074.488859.5206432862209354305@kernel.org>
In-Reply-To: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
References: <20261106-nfqueue-review-v1-0-b6c933f44943@asgari.net>
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
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
