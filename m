Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E5339D6FB;
	Wed,  4 Mar 2026 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772622592; cv=none; b=ZABMBUFYTp7Jb6ZTZ2fwhvTgBLiDybPnSqAyT1ya4gt0NyKbT9PvVTAC8H9aFQybnPavk+nTdwDhu/0u0dlByu/UOYBaFRBux8tgjlAZbakY5fvD6I0+gi/vvhAkE9UVxTjejzbGQaCvVRGdqVBvQC4GMJjnGKJN2k98mbMTa8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772622592; c=relaxed/simple;
	bh=DZ5EpOMngdd36wqNDd4NjYzA6OxXRNV1rOnQgdUoZNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H07vgqJp3enuIVgR0B/PpCJIoostp2VOXHfc9MTXQgU4A64Y3aJDZUGbTC46rQ7QVsnEOQShWfI4FQyP6fNOoodBd81bwjAJ8Ti3g/mUoUi7ckfMMoZWQbebZwTWyL/etslNQzZIhnKVONvJSEf1O59vM6s8WJ8qM3HxeiooEbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gRJaFpb9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gRJaFpb9"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 8637B602C6;
	Wed,  4 Mar 2026 12:09:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1772622587;
	bh=gt4atHiWzBjK0uoCYrFGwaAoutjL7AQKx2Z3OuME5BE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gRJaFpb9RgWm2G1Y+nAquiLopA9BIrWHjBcW7f1wyHewAneXWa+p64Kwzy2BcTCSm
	 Cd1K+SWWUUl0EqR+CH4+FuDH3gaSTTB89xL2tStmyT8BMeaB2bnb/TWFlDA0D5j6kc
	 ZI5WrcNgjKPyV6uleytjCWJjeJRpZ/82F4nNytdsUK7mRERGJIqlFFXoBoRUNs5/Z+
	 pNCKfU3h6UW5aoTJDUK97EqaABJOPpo9DOsMEB5QSRJItKru05tcTId8oq256VO1MK
	 CqbZkthg5xt+5/lL9CwHKLqqIKWwAewajNfAcojvjUYFZUq/jV2uzjOtBN2Zvi9yaQ
	 8ale43xA9rXBQ==
Date: Wed, 4 Mar 2026 12:09:44 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Jindrich Makovicka <makovick@gmail.com>,
	Genes Lists <lists@sapience.com>,
	Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org, regressions@lists.linux.dev,
	"Kris Karas (Bug Reporting)" <bugs-a21@moonlit-rail.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
Message-ID: <aagS-IUhQwz6m3MF@chamomile>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
 <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
 <2026022755-quail-graveyard-93e8@gregkh>
 <b231fcdb6c66a7b24dcef3ee5c35c5f612d5c1a7.camel@sapience.com>
 <9d110d860c0c7e110d018ea53a7666eba275da20.camel@gmail.com>
 <aaday5NR-yfCkFVb@chamomile>
 <75a4115f-e7f3-4316-b046-525fcd87cdef@leemhuis.info>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <75a4115f-e7f3-4316-b046-525fcd87cdef@leemhuis.info>

On Wed, Mar 04, 2026 at 06:50:32AM +0100, Thorsten Leemhuis wrote:
> On 3/3/26 23:03, Pablo Neira Ayuso wrote:
>  
> > A new userspace release with this fix is required.
> 
> But a new user space should never be required for a new kernel. Find a
> few quotes from Linus on this below. And I noticed other people ran
> into this, too, so it's not a corner case:
> https://lore.kernel.org/all/aaeIDJigEVkDfrRg@chamomile/
> 
> So should this be reverted everywhere where this was applied? Or is
> there some way to do what the commit wanted to do without breaking
> userspace?

Thanks for explaining.

I kindly requested to revert in -stable:

  netfilter: nft_set_rbtree: validate open interval overlap

which amplifies the userspace bug.
