Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9E262FFF
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753774094; cv=none; b=dPYyIskAA6gFTBtFpJ97lTOyyndpPgQEgj4YVlFkYRd5UNQ8trcJAFRBBSRRcmDAry1OlBiNkaSg7BJcLi+zJKPZl2+rv/TDBcSpZ8+3By8P7NkaUXxZBIyH0pEPlCACVqakxO60/EiCdX551ZxkNZ3ufXiadXnXnSlBatE0mRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753774094; c=relaxed/simple;
	bh=gdVeXBXrDhgI1sjMjEiKkncP1tIbLtSZ+7PrC+YXLss=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=QOCA5qAMtEvJazLFVfclwAScFO+E0uzuOyzzZxBs0y1ZkFC81+YkNJ5W8hIa+GESLuDZSfS2m2nCRkdkQfbd12/AOkFm60v0LQYQHG7WydK7UQPPDcYsqRxm28qAAlTrySjNgyJ8bS+9QPWdpNVPc6JrsmJ5+qEqdg2PHI0q+jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=dNwXg+ij; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="dNwXg+ij"
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4brmyc2LHnz7s84J;
	Tue, 29 Jul 2025 09:22:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1753773766; x=1755588167; bh=1Wm7zKCrXT
	bgLvMf0tzZM0nP8EHwVA2cK9FlgTSqNMw=; b=dNwXg+ijyAIB08PtTiADG1obM5
	XE9tjZtv2drxAPxHC9Xw31Gxu4gpna9tVFNqZhRbWowJRloHySZbE1639s7gsH1P
	wOV2KX+dEUxMLEOUNsgCGFTCTn+wlbiZ7jKl25YvFb4JeM9S6JcFbGqu4MhYnGP0
	Q8Eina9hTBF72N+F8=
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id PCTDUCfsRZWZ; Tue, 29 Jul 2025 09:22:46 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4brmyZ2kpcz7s845;
	Tue, 29 Jul 2025 09:22:46 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 594AF34316A; Tue, 29 Jul 2025 09:22:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 5799E343169;
	Tue, 29 Jul 2025 09:22:46 +0200 (CEST)
Date: Tue, 29 Jul 2025 09:22:46 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
    netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more resistant
 to memory pressure
In-Reply-To: <aIfrktUYzla8f9dw@strlen.de>
Message-ID: <6f32ec06-31bf-f765-5fae-5525336900c5@blackhole.kfki.hu>
References: <20250704123024.59099-1-fw@strlen.de> <aIK_aSCR67ge5q7s@calendula> <aILOpGOJhR5xQCrc@strlen.de> <aINYGACMGoNL77Ct@calendula> <aINnTy_Ifu66N8dp@strlen.de> <aIOcq2sdP17aYgAE@calendula> <aIfrktUYzla8f9dw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Mon, 28 Jul 2025, Florian Westphal wrote:

> Another option might be to replace a flush with delset+newset
> internally, but this will get tricky because the set/map still being
> referenced by other rules, we'd have to fixup the ruleset internally to
> use the new/empty set while still being able to roll back.

If "data" of struct nft_set would be a pointer to an allocated memory 
area, then there'd be no need to fixup the references in the rules: it 
would be enough to create-delete the data part. (All non-static, set data 
related attributes could be move to the "data" as well, like nelems, 
ndeact.) But it'd mean a serious redesign.

Best regards,
Jozsef

