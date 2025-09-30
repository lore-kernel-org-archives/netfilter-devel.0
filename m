Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B42323D7F7
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Sep 2025 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759253553; cv=none; b=iRjDe01yU360mR4brRvGkZQFvPp7viSsYk+vicjKrCkJjbi2iZKCMaUu29+hQrcRiS6D8x2qudYdDJySM7oqfw4iKkgSsaAMfOJRx+8DE4DEJo+ZUL7sRBMbHhpecjT1iym1ntRHnnGamdIkKDbMerZNndUP2maaFN6d0Z/9eSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759253553; c=relaxed/simple;
	bh=O5/9oTw54Bc86A0HrDN55Ie1cddZE/QZIotqJSJsxfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DePwgwsZN4wcPUUGG64sdUQ1T5cG2KyJNyd6LCPGj6z/yNCS9cLZG2w+zs7gSMoQKQg6c2zd05zL+M7+HWVC0sBYyslo1AAfHRksEufqommdL7JJkWurik+7+sZNuXTE7mOCbih1EFkjkWEleOHlqm76+kxSRTf48etu7UX52aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=p3sBLDR3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="p3sBLDR3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jTQ4BwGeeXil8RZQLi45QLk7F5+M5FcDdjqKInvBHCQ=; b=p3sBLDR3WWwMkcM8RSZU186w+Q
	oiFC3brvVvbEt0xwbzOwnFauCIzrgfTBta/ROfeY0sP+jx7RF08w3aqxIDMP+ajeU9fQUUJrKl1IZ
	J4Ij5uhq/FLJYGY1LMMynuR1pZYm/b/zexI2IL8Df1PZ8Pyq328WJDAp6UWPjHBiGZ/WgbeCFFdpx
	bnv4T0rpND+k0tFnq4CR80lUwlfwfDoH72D1V1ppEVvaKuS5OW1KIAzH+DHp/l7TfFoFdaX2Xeo5T
	bHzciU1oTIJeILTwY93uMwSo8Ie62yDKQk8y8yt/Uo0MlEQiLdrW+XHXfEP4eeqHZer0fLUEDbW03
	pLlXOwXQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v3dva-000000001rb-2xUA;
	Tue, 30 Sep 2025 19:14:14 +0200
Date: Tue, 30 Sep 2025 19:14:14 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aNwP5t_AWr-8TaEd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250911141503.17828-1-phil@nwl.cc>
 <aMiC3xCrX_8T8rxe@calendula>
 <aMlTI4-QYkkwgTEX@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMlTI4-QYkkwgTEX@strlen.de>

On Tue, Sep 16, 2025 at 02:08:03PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Phil,
> > 
> > On Thu, Sep 11, 2025 at 04:11:45PM +0200, Phil Sutter wrote:
> > > The old code printing each field with data as u32 value is problematic
> > > in two ways:
> > > 
> > > A) Field values are printed in host byte order which may not be correct
> > >    and output for identical data will divert between machines of
> > >    different Endianness.
> > > 
> > > B) The actual data length is not clearly readable from given output.
> > > 
> > > This patch won't entirely fix for (A) given that data may be in host
> > > byte order but it solves for the common case of matching against packet
> > > data.
> > > 
> > > Fixing for (B) is crucial to see what's happening beneath the bonnet.
> > > The new output will show exactly what is used e.g. by a cmp expression.
> > 
> > Could you fix this from libnftables? ie. add print functions that have
> > access to the byteorder, so print can do accordingly.
> 
> FWIW I prefer this patch.
> 
> While it would be possible to move all printing to libnftables (and
> as you point out it has more information available wrt. to the data
> types involved, esp. byteorder), I think that printing the data
> byte-wise rather than per u32 word is sufficient for debugging a wide
> range of bugs.  In particular it will expose the true size of the
> immediate/rhs value.

Can we treat the register length fix separate from the Endian issue? I
am aware we want to reduce the amount of payload record churn, but with
this patch applied, a follow-up addressing the Endian issue should touch
only the data in host Byteorder.

Guess I'll play a bit with the suggested Byteorder fix approach to see
how straightforward it is and how much extra churn it causes.

Thanks, Phil
