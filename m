Received: from a3.inai.de (a3.inai.de [88.198.85.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7759B823A3
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=88.198.85.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715178917; cv=none; b=C75+BOcPvjBpXnO7wbow2cEcNjECNZxVLLASxrGuId/fJAR1HEAYR29+qV6um+2wb+4chZj8cK6d5QXFBnP1RGBrs6BEUytytR6dYXEzhvWqPVzvvJabFJhw7GmWUPfb67BGsL1blkU0hL+4c9yjzxPV9Smc5Y3zjDFyYj37VjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715178917; c=relaxed/simple;
	bh=DirP/3PZI02gNrGFQ1EwRCUvQgC8gfBTvL9Alk9oEWE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=LUFCBs+3fiHGpOQbzSNJkny90uguGex5o7mErAS+UzFUU5lHt7B4m/qxDfRRJeqFX5APTBIef8IZ7MEjx1Bqk+nKef6O5iSccWP/Rdp7X0lKjSGQAxBRHaaB4AVoqLZlySWi+kcAHBth7er1jlRStUM+H0Dxypo8wn5xh8YyupQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=pass smtp.mailfrom=inai.de; arc=none smtp.client-ip=88.198.85.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id A4E8D587264C0; Wed,  8 May 2024 16:25:43 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A1D8160C28F40;
	Wed,  8 May 2024 16:25:43 +0200 (CEST)
Date: Wed, 8 May 2024 16:25:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Florian Westphal <fw@strlen.de>
cc: Sven Auhagen <sven.auhagen@voleatech.de>, netfilter-devel@vger.kernel.org, 
    pablo@netfilter.org
Subject: Re: Could not process rule: Cannot allocate memory
In-Reply-To: <20240508140820.GB28190@breakpoint.cc>
Message-ID: <69277n7n-6966-9021-96op-n9nqpn5nnoso@vanv.qr>
References: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw> <20240508140820.GB28190@breakpoint.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2024-05-08 16:08, Florian Westphal wrote:
>Sven Auhagen <sven.auhagen@voleatech.de> wrote:
>> When the sets are larger I now always get an error:
>> ./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
>> destroy table inet filter
>> ^^^^^^^^^^^^^^^^^^^^^^^^^^
>> along with the kernel message
>> percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left
>
>This specific pcpu allocation failure aside, I think we need to reduce
>memory waste with flush op.
>
>Flushing a set with 1m elements will need >100Mbyte worth of memory for
>the delsetelem transactional log.

Whoa. Isn't there a way to just switch out the set/ruleset
and then forget the old set as a whole?

(I'm thinking of something in the sense of `btrfs sub del /subvol` vs.
the-slow-way `rm -Rf /subvol`)
