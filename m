Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E1403B16
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786374666; cv=none; b=SCmqfJsp2OZj3VhONOoqF9iaOih5ulHE/Vglgc9Po+y9G5yt6hZL9HAyEPP0jA+ZVe1tEdTL4aWZ3HzINqmRn5LQ8ltW+D1xnVlzGBdYcb0viB8yMqWI5LRBgWsU7QtmQl5FcnBe7AukpPMG3ZuGlIa/N+mHaURvYgazumwNctQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786374666; c=relaxed/simple;
	bh=55EWUy2u7pA7pUwkK0viiWjoz0QiUvsMy6bw/sJ4Ec8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fXRp1UDqHBGay/9gnWiOGHrOV5Ow/oeiPs1Lm3WLOmbeICTiAwXtqzCQDvhdOY2Ap+OBpB/gqVPdPlQIUeLEPuWwTFDKXTY9U5xYsQBfrMMq4EaQ81O4CnvvB3/EnzObAjDDtGkTSSPQ9aJ2jtPwLeDy9gzC32dLjqhZsDxfr/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=YYkzQSf5; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="YYkzQSf5"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4hJdVk4lx8z3sb2P;
	Mon, 10 Aug 2026 17:10:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1786374652; x=1788189053; bh=OCjV3bf53r
	6Cqgza/XZdD4f8StDLgqcPeGXtNHjlcPE=; b=YYkzQSf5nzZirF8gtgGg0jlWZ0
	CduAxEZUnUf0bd6w2hnMidzGnDDx4wI98kA3ISNeWcCIH90RxvneKZFOwihZE6ge
	FyJavH2NJo7i3hdnrFH67eIrESiBGixmCQbi9uk5TdP3X8wbGVIZAVNW3XoOnRyU
	kgzZVMpTk1h7GtdzA=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id C4vOXnjeXNMt; Mon, 10 Aug 2026 17:10:52 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4hJdVh4r8Rz3sb2M;
	Mon, 10 Aug 2026 17:10:52 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 9658534317F; Mon, 10 Aug 2026 17:10:52 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 9456E34317E;
	Mon, 10 Aug 2026 17:10:52 +0200 (CEST)
Date: Mon, 10 Aug 2026 17:10:52 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Florian Westphal <fw@strlen.de>
cc: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: ipset: remove need to allocate memory on
 delete operations
In-Reply-To: <aniNjO71_0Bv2UMI@strlen.de>
Message-ID: <902ca062-a9be-9a30-99b3-d98cd4941e3b@blackhole.kfki.hu>
References: <20260804170214.27237-1-fw@strlen.de> <abb4fda6-444f-2c79-573a-740529e468c9@netfilter.org> <aniNjO71_0Bv2UMI@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi Florian,

On Sun, 9 Aug 2026, Florian Westphal wrote:

>> 2**24 is a lot but still a reachable limit.
>
> Hmm. 16m entries...  I guess its possible for very small prefix
> lengths?  We could use BITS_PER_LONG == 64 but it gets more ugly then.

I was thinking on IPv6 where it's more possible. But hash:ip has no such 
limitation with same-size prefixes so there are other solutions to store 
large number of same-size prefixes.

Best regards,
Jozsef

