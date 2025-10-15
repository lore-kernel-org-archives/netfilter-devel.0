Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1253741C71
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2025 20:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760560352; cv=none; b=p/OHPhFhB+mNTHT+mebk26KAMM76AnqH5B4HRH5xsHkqvj9TNyNnq62mGtUt7X3Wblpf+0wl7PIICoMg/RQKL8S8yKiY8x/6RgXS5UrfWpXT39dXuzQ1sINjpPKaKsuoLN+dz3za4aTKydAANdwJ8G6SQJ+S3RnAUlclFJU7M/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760560352; c=relaxed/simple;
	bh=6uPde6Sx9N+mTLVMpOwRa4gdrP6pLnYvxBu8HbuG9MU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NBhQfZZE78t1NegzhnIW1uTh4l2P4C+flE1EmhFUU6+Si8pO14Y0lU4+JlfXVAYouUjIbKrQ/C8ZJeEalt2Nm6jVatJb+q6cCb2QqhtpKtgK9N1m39bf3F7INQrpZcdJrvot/rpHlX/4ZHJzMXyDyurODKSAOkeVcQ9xkmz98ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Yl9oyvQE; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Yl9oyvQE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LLKbCXQNgHrmpAerMBrxBSuScl6zDl1iGmhqgeXKL0o=; b=Yl9oyvQEr9554hLSr0i7UBrrFE
	z7kqprUvih2xP46nBStkcf33Cqy/tIuZWbms37z0OOgVliUvHh1z7lRMknFggnp9eShZR7YAPr+Aw
	9OS3cKs9gVDX95gPMb4oXh6mq37u/F5QtzB5RXoizGjjVoonuPf5JO5ZDTRuQiUtm62gH6UXIlfHw
	T5Y69mpfGM+QDj6Zm/R8sQ41sHJBNJutc2AWH0Eo4kAj3IORehrw2t0pynSNSNofPun8OLMq2DoEW
	XftlRu1ZiySVVYxkUsKuGvWD5T6x1DIMZPGZElvk3dh6u6ELqi7cyug4uDB3mE3rqiSz+0DxmPWRE
	/nStUaRg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1v97nj-000000000AF-3pUk;
	Wed, 15 Oct 2025 22:08:48 +0200
Date: Wed, 15 Oct 2025 22:08:47 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Drop asterisk from end of
 NFTA_DEVICE_PREFIX strings
Message-ID: <aO__T5yX3xkD0djO@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251007155935.1324-1-phil@nwl.cc>
 <aOWJLfLGdbT5eDST@calendula>
 <aOWOwaCWV1SXpdg6@orbyte.nwl.cc>
 <aO7PyNgUnGxg7qHt@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO7PyNgUnGxg7qHt@calendula>

On Wed, Oct 15, 2025 at 12:33:44AM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 08, 2025 at 12:05:53AM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Oct 07, 2025 at 11:42:05PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 07, 2025 at 05:58:26PM +0200, Phil Sutter wrote:
> > > > The asterisk left in place becomes part of the prefix by accident and is thus
> > > > both included when matching interface names as well as dumped back to user
> > > > space.
> > > > 
> > > > Fixes: f30eae26d813e ("utils: Add helpers for interface name wildcards")
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > > This code is currently unused by nftables at least since it builds the
> > > > netlink message itself.
> > > 
> > > This was moved to nftables, and no release was made to include it?
> > > Would it possible to remove it from libnftnl?
> > 
> > The code layout is a bit inconsistent in this regard: While nftables
> > does the serialization itself (to record offsets for extack), it relies
> > upon libnftnl to perform the deserialization. Therefore parts of the
> > wildcard interface feature will have to be spread over the two projects.
> > And since this is the case, I decided to keep libnftnl's serialization
> > code "maintained" in this regard, i.e. enable it to perform the netlink
> > message building for wildcard interface names as well even though there
> > is no known user for it.
> > 
> > I'd prefer to keep it, also because I see us eventually returning to
> > libnftnl's serialization code once there is a mechanism to extract the
> > offsets for extack. You have the last word though (as always)! :)
> 
> LGTM, thanks for explaining.

Patch applied, thanks!
