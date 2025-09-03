Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150B41E5206
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 10:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756894424; cv=none; b=Kbk8KId3cEd3vR7F/B4VY61w3bBfMf0dsjPjmgzqNS5HX3S8BSviOwaMT7un6j4ySmxeWeVarW5et0uZ7odvmt3B56xB4vQx2FugJIhno7fS5gVZ9w7fWuV58kZwY6+lgWOs/mcOHAJFOcf6tusqF1egTeGBq+sae6cSpXmKBW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756894424; c=relaxed/simple;
	bh=s6iMrX+cMPby9I/2qEzTy3SG6FEHkmKBORof5EK8j8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CgyxUHE3in9eFRx09qJSt63CQi0mpLl8jwDHvX43Go6X7i3NU4fBk+opux/LTuaqd1jrvoLZ2NbteDPJImAUWJuv0JDlSDE9nW2+d/lDOTWr7rCg7LdTBgqJDybFQu813uSz0+rZZ+vH9u12dDdR2l7Q90SkxPlQqaEGeUvdXK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 84CC3606DC; Wed,  3 Sep 2025 12:13:38 +0200 (CEST)
Date: Wed, 3 Sep 2025 12:13:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Nick Garlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
Message-ID: <aLgUyGSwIBjFPh82@strlen.de>
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
 <20250902215433.75568-1-nickgarlis@gmail.com>
 <aLdt7XRHLBtgPlwA@strlen.de>
 <CA+jwDR=zv++WiiGXTjp3pMrev2UPxx9KY1Y-bCFxDbOV7uvjbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+jwDR=zv++WiiGXTjp3pMrev2UPxx9KY1Y-bCFxDbOV7uvjbQ@mail.gmail.com>

Nick Garlis <nickgarlis@gmail.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Thats a userspace bug; userspace that makes use of NFT_CT_SRC/DST must
> > provide the dependency.
> 
> Yes I guess that makes sense, garbage in, garbage out. I was just used
> to seeing some kind of errno being returned from any other invalid input
> and I assumed that it might have been a bug in the validation.
> 
> > But why?  As far as I can see nothing is broken.
> 
> Honestly, I am not really sure whether it is an issue or not and this
> was mostly driven by the assumption that the kernel shouldn't trust the
> userspace to properly validate its input.

Its simply not possible to validate it in kernel.

Consider e.g. 'tcp dort 80'.  nftables will insert the 'its tcp' check.

But userspace can also do
'meta l4proto { 6, 17, 132} th dport { 22, 23, 80}'.

The 'read 2 bytes from start of transport header' is the same.
So kernel cannot 'force' anything.

It will make sure that 2 bytes could be read from the given
offset.  But it can't make sure that those bytes have a particular
meaning (port for instance).

> There is probably no strong enough reason to. Was the decision to not
> force dependencies intentional or something that was left as a TODO?

Its fully intentional, see above example.

> Thanks for taking the time to explain. Let me know if you'd like any
> more info about this or another patch involving nft_ctx instead.
> Otherwise, I’m fine leaving this here.

You could submit a patch for nftables userspace to no longer
emit NFT_CT_SRC/DST, I think there is no need to support kernels < 4.17
anymore.
