Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9AE25C802
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 22:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761864902; cv=none; b=N/tSdReo+EBXlCevlnEBK3emtYK0GmesGTqJTBS5IcIrq2uzYCDtVbAiZFpdZp06aA+7Z74B2cVMmZealJfE+71/lZYmIdQD3a7D65JvNodc1fHTsv/k51SetkhTdv+1If9WAfe+PDXaZWS6Qz4WujcBdx7ZRiAm0bb0+NfWZyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761864902; c=relaxed/simple;
	bh=x/4c2UPgB8zGfwtSaDr0v1LTH0WvwWpO9K5uc3kzGeQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mlq5vy9lLH3uvr5ogglKWXHwvbgRXski+wFnQO5swQIrvx3nkTLa0uQk8tLYyulYBhPiS0sqPLu+kQE19YwGkdRjShp0SgspK+AR2bZqFulmhLgDOvcMiTjnD0Swtr7fDIea+PZHbAFiiROhxPf4j6Z/LIZ2TOnN20WIIZ1lh/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Dgm+VgPH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Dgm+VgPH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=igq1wroyPVaSn16spG07Gie66fXIl44b+7F0oyhQrVk=; b=Dgm+VgPH1EUdqOKlXcdloJR8Yk
	5FlNuBQv24TcFE9+x5859N8us2pg6hAUoXPQaurJ8nRQn1rzz/DUDmXmvHbq8KYqSZ91kKJdS958B
	rXlHlKhbJfE6aX5W45Ca2vXBGhfJThytokNg89Iywb6rgK3mCvZaP8xgNgXz2EGaK2jONM4Qn9iPj
	IVOBvEvSvGc3VLrkbMLn7jry79gV36af5frLVRlrgJyh4yqgUPFCgZEfOfKXnJTJ/XVpz8Nrr2JCP
	g3vqEChrWO1zHK+t2DF6A1zu6o0QIKgCkYfSUvS/JXWvR4s8YpCFXanhHzEfCJV6OfIuZh2oms543
	CJFLkYpQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vEbXl-000000002Cu-3FBZ;
	Thu, 30 Oct 2025 23:54:58 +0100
Date: Thu, 30 Oct 2025 23:54:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 12/28] netlink: Zero nft_data_linearize objects when
 populating
Message-ID: <aQPswXUY7r5G2xXV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <20251023161417.13228-13-phil@nwl.cc>
 <aQJe44ks8cDYQcBC@calendula>
 <aQNHJhDYPIqPMXh5@orbyte.nwl.cc>
 <aQPgcSO75pz3iCxE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQPgcSO75pz3iCxE@calendula>

On Thu, Oct 30, 2025 at 11:02:25PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 30, 2025 at 12:08:22PM +0100, Phil Sutter wrote:
> > On Wed, Oct 29, 2025 at 07:37:23PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 23, 2025 at 06:14:01PM +0200, Phil Sutter wrote:
> > > > Callers of netlink_gen_{key,data}() pass an uninitialized auto-variable,
> > > > avoid misinterpreting garbage in fields "left blank".
> > > 
> > > Is this a safety improvement or fixing something you have observed?
> > 
> > Patches 19 and 20 add fields to struct nft_data_linearize ('byteorder'
> > and 'sizes'). Having these memset() calls in place allows for setting
> > (bits in) these fields only if needed, default value becomes zero when
> > it was random before.
> > 
> > One could avoid it by making sure the new fields 'byteorder' and 'sizes'
> > are fully initialized by called functions. Are you concerned about the
> > performance impact?
> 
> No, I just was expecting you clarify in the commit message that this
> is just extra-safety initialization that is not fixing anything,
> otherwise it is not obvious what the intention with this is.

It is needed because later patches add fields to that struct which are
not always written to. In order to not break the code temporarily, I
chose to add the memset() before adding these fields. If this is too
confusing, I can fold this patch into patch 19 which introduces the
first new field.

> But it is too late to discuss this now.

Seems so, yes.

Cheers, Phil
