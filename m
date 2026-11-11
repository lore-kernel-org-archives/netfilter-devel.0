Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423000;
	b=jyZOGboKeE+1oRyUFBcgGg7XmSHZ5aeIWguHMllng8OYoWx8hUD/9Ml/aNZxHy/UsMb4
	 /+S4E7Aye1Z9Ln8DVF2Ff/wnZ07+WsAmEeY6v4TAetGjt2if0RKROl3x0sYNpMah+QG4y
	 RgzVJbewqoN9YGx5RWpNT7Af5viwq5sclFiG8S85pUMYDfx0O4hgxT/2+gvZ4Ghc2qkYF
	 fSkyS45aGOcLUcN+J+P7fODlug9faIHKxHneQuaRwH3GSAfvJZABK4+tQAHdoxCVzE4gh
	 HhMPod62+6X3ADjlHT5lOk8ZqPPl/XiyFai+ep9T+esTLeIUl8/aCnfybLm1VMGdUuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423000;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=vPnEkZWzCBTRDcx/mx7Z9sICpPxvo0zMBZ6q/e+qRso=;
	b=X62EMiCkwKUb1PNHxnYPQxBiIKSWHSw4pT6UxZdnuFkiJRl+TgUvhrDX/Qk8d5aPD4HO
	 OWtaqF7Myyo9oxNo4XfS8pbXF5McdV1J3qtZybnPnK1qJ47F5Ph0Ples64cRpUUJNRkgG
	 zHD7AvsRjuMBbrSTujkX2CEw1T1Di3UHlXZVkvW68adg4pHwLaX/kNplq8z+a1Cbvp+jp
	 QTstLiSWB2bOmSt6JJvajCpeBPbqjZqPIyRy/o4ZkhNwhm8tJ4TO0xWunuzIkmkKgS5IO
	 fBNWa2s2/P/2f4r9WHawgjF3n7yrZ8N4MYv/OIXz7/iQViZgxL69NaYNDWcq2W9Ocpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=LYBhcJm+;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1869606A31C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 18:49:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1869606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=LYBhcJm+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vPnEkZWzCBTRDcx/mx7Z9sICpPxvo0zMBZ6q/e+qRso=; b=LYBhcJm+VapTTFHgFqxuCb2gk5
	Hssg3qG+f1xOZx1EPTDqG5anwnKcM3ZEP0ZpkDrz3lawKB3YgSLHG6JnEU0WcBhoUvE8fQBVfhgLI
	iKL1c7gem062OJ6Vrhh3phIEwghXOtn7zOR3aREkn7M2dHN1VfYfY5Nn5KPuu3gJNGiYTpe5cFLg4
	MU1xt72gAMWMeUIWui5HQUCWbmNT0SaMRTaA7KJ00ucZBxARioBbFFLDFVK0BIP3Nw9TKYN2zrGXP
	6c2HZrMCOdcfzRCZIBFaOHutEvXdVBZdtQI4i6nFqvyWqC+shY0lZm53fW8LC0LzfOinQzufcFIXc
	sZfw//VA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xRDOO-000000008IB-2sOB;
	Wed, 11 Nov 2026 19:49:56 +0100
Date: Wed, 11 Nov 2026 19:49:56 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Yaron Shragai <yshragai.firmware@gmail.com>
Subject: Re: [libmnl PATCH] include: libmnl.h: Add explicit casts to macros
 for C++
Message-ID: <avS41B80NzkdEFeu@orbyte.nwl.cc>
References: <20261111153054.44763-1-phil@nwl.cc>
 <avSzl8-2uom7Mntt@strlen.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avSzl8-2uom7Mntt@strlen.de>

On Wed, Nov 11, 2026 at 07:27:35PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > C++ does not like implicit casts of void pointers, make them explicit
> > there. After adjusting similar cases in example source files, these are
> > the only needed header adjustments needed to compile them with g++.
> 
> Reviewed-by: Florian Westphal <fw@strlen.de>

Applied after dropping the redundant "needed" up there. Thanks for your
review!
