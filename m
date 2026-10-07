Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D0B3CC323;
	Wed,  7 Oct 2026 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791387045; cv=none; b=LyFmmScvgPwi3cltm0nz3lq9DkvfKZHA69eNCCiJGwOlsgMAv3ZBR3jq2VhKs+XJ4YacYD4SZQx7ddJlxW3V8WwybdpxsUi7ItfdTzwo0c7O6/0/w3rZjh1otIZ8epWxlQ6mrJzBtIIq64mhayJAl7/JEfQ6fwx8FfruPcmd3L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791387045; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VyeFjIo/UtCNALMGX2m3wpnNgr3ITQSN5HfiNXUOAZCmOsbj8zdEpYtqMIUtPrLWtJmURox07VRhkCbV7chC/tTpfJl5bgaQAFxVtqJuokHQWtywRERjtRcXri/VWZqB2C8RiKO5GVgc3IJ5K0PFN/OXUx7qhZ+ncc4Lj1MooB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KJ38fo6F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KJ38fo6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632A71F000FF;
	Wed,  7 Oct 2026 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791387038;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KJ38fo6FHnnSE2QfTiry5bfT/lGqON1/PRhrPVnXsi+p35yn36vaJoLmq8CZ5gkT1
	 5dTUnpZeANwR5y/cClPYYFu7EtH6R76JJ14DB/UZg3DmF4aYes3sbR0hPJ8lrHGH4h
	 GCorK6e8a+zXPeljRYaZ6P1b5DeA2RaONggC6RP3uS14zBf5h5pHeYnlLXQ1rHxXsM
	 VPVqFbjyCLlvJwJ6y8YQ2d9LcyYiYFgjuo82AFyjnV7flKGFNBq65E+jbRb0DPRtUy
	 RjwSKIMv2WKRawUMDBQOIIhiIzWeRraGLVhFhL5zWwBRMP6EP8vmrHBLCp3rWz8aX4
	 TWjzuTFOs/p7g==
From: netdev-bot+sinfo@kernel.org
To: Joas Antonio dos Santos <joasantonio108@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_conntrack_sip: only honour Via: port in
 original direction
Date: Wed, 07 Oct 2026 15:30:37 +0000
Message-ID: <179138703794.2527009.12321622169213831789@kernel.org>
In-Reply-To: <179138670045.80227.4002052840715926590@gmail.com>
References: <179138670045.80227.4002052840715926590@gmail.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
