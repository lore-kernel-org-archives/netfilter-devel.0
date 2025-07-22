Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902662BEFE8
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 08:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753173294; cv=none; b=r+vpimz3KZ4DUXNIBQricFO/4odXdLKHvl6joKBRDbVlM9mUIVRTUdpZH3RJCwtGTJtTDVuzR/M9TJ2XD40aJRGBkTENBpWrCeB9mp2dgoLN3Epk+JCybnmx6RmjkYoLdQ4vIuXnTIbg8ZoWj/J3wqrT/OCIPK8sCzYmJOJzHe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753173294; c=relaxed/simple;
	bh=PoDFRtuGU2LyHjhRkvXZbrRCHSdvfdVu0r/jNAsXiqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b2OzUrzpxitb00O3CJEEf/vXzIfNikB0aUqhYFQHTKiFFAmbXJ0kMUtrNusYdtSioESYDAZphCcRNfZv8Z602GxjdobVK2mi0gSUJn2jF4hSi5SI+SBF+VYsFmpSqeDfF4H15SszPZ8C4Vnx431KGg0fhzjktNWe/+5MmOAIiIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Z0dY/DNg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Z0dY/DNg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XuR9XcCreWAE0WdzjFC1yjnXtLFiZNIoHeT5XRd/JrE=; b=Z0dY/DNg4TucksNgIyAwPnuKIr
	N1uViK8flTpfhdKgOTbzYHm6z0DhQngFdCZjgdOLQzZ/V9+U8moMbTu+FEVlPG+COv1sJpBBGOqOz
	h5EpuLnFQ2Cu7MMmZyDwKGunH2o7a1c2KvboJvttwejQgf0OfKCcQ4u9d18tCJu2nSNKbqiE7ex/x
	maW6ZoT0wxzg2pKy3MVfs4/+NLxVIavXIxyBFbFnN1qJdM4+W4LTg/YR8PWZT910EROYnmndKoziF
	fL2cHV2rU89U4TFPulyThwQyy9V8odBuEI/TOKFTJjOgm8jTZXQ1412i60oa/DQLfBcF4hNqxfHN7
	xbQl6RgA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ue8SY-000000006Wn-43tJ;
	Tue, 22 Jul 2025 10:34:50 +0200
Date: Tue, 22 Jul 2025 10:34:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] libxtables: Promote xtopt_esize_by_type() as
 xtopt_psize getter
Message-ID: <aH9NKvp_VWvzBgCo@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250718160032.30444-1-phil@nwl.cc>
 <aH5_pGe_3_OQO6YH@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH5_pGe_3_OQO6YH@strlen.de>

On Mon, Jul 21, 2025 at 07:57:56PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Apart from supporting range-types, this getter is convenient to sanitize
> > array out of bounds access. Use it in xtables_option_metavalidate() to
> > simplify the code a bit.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Patch applied, thanks!
