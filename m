Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1599436EA8C
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 08:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773910605; cv=none; b=qCbv/abMGpByo+1WxZYDyStpNOmE/Ca5lAxesG8Xi90rGhJd2yDSVHtIlUWKb5kzfMEd0i1AJ+uairVu8Lvp8A3dD2Wn7Uw0agahzGw9oowqDQgFMECgmIhE2hq8ieEtwLUzbSF46bJRN5HFxW45+IAZ5if9MmK19igXK3xSFNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773910605; c=relaxed/simple;
	bh=HPoXnmS8UefZPURYIDqtu/pKRKWygCSk0bYBc7rP7Tw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FBpN6ZEOpY8rrxdVF8xR1kFyrGT5bQ4qnb4vBoIN+B6oHAgQgaatLud4caYo/nQZZXN2jpiQmPnBfwdnmUPuyS1ojo3Xk75GLGWpopQuS65Lj4sIwKv9MahAqQvlCAmscEvKFIF0dLdqra5/74S/k21+F0Z+HzZQYOPEY98rfeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=as64b8Co; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="as64b8Co"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HPoXnmS8UefZPURYIDqtu/pKRKWygCSk0bYBc7rP7Tw=; b=as64b8CoXVXO2R6UAb86DtQGLy
	FU1q54a2GHSzIdNUp60x54lXjZ19JUuNeZSqwAsj+ErsGAlyL8s5ASd49sUYnM9/eRusabqc8x8OO
	AVmjkN+/8BO1ulYwFO+cIqzTMT/rh+z/309pualw1MHEh0tQwL7BxltiyAfSHxZPZkMpnNb04bkHE
	AlpPsDCW4GLW0n+1BoiQV1GWI1RJFBjWb2gxDCz8odCbpJGhKrBjvKhngORSNItUvqkx0fBCUU3Ru
	EpF5U4mAvLWjMiCzFWODdO17NPbwesn3tGx1hwCm2LnUYrXtxVFMNbDy0jN307hT0VkUTnpa1BtIo
	ldbho81Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w39BI-000000000NS-2860;
	Thu, 19 Mar 2026 09:56:40 +0100
Date: Thu, 19 Mar 2026 09:56:40 +0100
From: Phil Sutter <phil@nwl.cc>
To: Chloro Dose <chlorodose@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: Export nftnl_set_clone symbol
Message-ID: <abu6SAYnM6SJfXMv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Chloro Dose <chlorodose@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20260318025651.151116-1-chlorodose@gmail.com>
 <abqCdqPLJyKmBQc-@orbyte.nwl.cc>
 <abra_o50miSi49Aw@chamomile>
 <abr0mqg2A0V0DiWb@orbyte.nwl.cc>
 <CALUf4NpY__xsCa4=RHw-D+Hixvnj_1yuS7K_qJ6WJ0qSoTyRDg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALUf4NpY__xsCa4=RHw-D+Hixvnj_1yuS7K_qJ6WJ0qSoTyRDg@mail.gmail.com>

Hi Chloro,

On Thu, Mar 19, 2026 at 08:15:35AM +0800, Chloro Dose wrote:
> I have a use case where I want to construct a daemon that keeps a
> reference to an nft_set and repeatedly uses it to handle requests to
> add elems. I assume I must clone the nft_set from a clean copy each
> time, otherwise I'll resend all previous elements to the kernel. But
> I'm just starting to learn nftables, so I'm not sure my understanding
> is correct. Am I misunderstanding something here?

All you need to keep record of is the set's name and that of the table
it belongs to as well as the latter's family. With this data you may
generate a NFT_MSG_NEWSETELEM-type message for the kernel to add one or
many elements to an existing set. For reference, mnl_nft_setelem_batch()
in nftables.git/src/mnl.c should be a good example of how to do this
using libnftnl and libmnl.

Cheers, Phil
