Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9EA4BC02C
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334893; cv=none; b=Y1QI3TD1sy97On01z9BBiNbFGhD+nsegsT3iIzsI47bImiFMkhKVGmlzC6kDxSdL7kh87R1f86AfqBoDA8zQ7HRGXxuNOq1EEfaWANCa5A15AZsZqUkKtJlYpj2raEClA7cSfgDyanvoujXO3jTMSKFClDP4Y8L27QNvHoTHIts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334893; c=relaxed/simple;
	bh=Whj4N+dpS2xaq2EBj5w3lErN/GtDZiWjIvJxc0unklY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1tHkPYj/j8i0u+FwlHar1AU8hcwu3wQhc2kZxm33PDMCMea8OURgIC2mQr+An3vpZ9W61DDFN94jSeocFRw0/FYpGFf3iU4GRdsSsaqnBJY1jR4rk3OXwDXO57/qtiCzgML01kFXIsW5ecCuKScjX2Nmli0SUznhV2AQhYppVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bRjl7qZf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bRjl7qZf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=S3XG/QPb4AvlrJ1MEswsHDzDlP0JJXD3x2cAK9i5rZQ=; b=bRjl7qZfU7/yQfDxIyBFr+rLPx
	wN3tIxWQcWD7Q+RMNMiw7JDeJkxoB5BdBDDgexAy+m04MT+YLAPet3R15yhG/YfC5BaDmbyG0L9sU
	C+KtViTMwUNT9hctFmHj6fv11VQW7ae0H6EnoQJxweG4nq5GtuqL7VV3hSiQvViHrl29i7VRgrkky
	+52gV/AB4/v+IFgYgtc3KIXi7IhrztbOGLSIuyRued5PHkpI15DCxz3YlRWLPIQk5ZD4K54GS0KOA
	P9TFwa6hiIOBuqhuYS6LSCRil6m/D1kF9cgBec9seomEYIkEdV10B7Q+Bm8cJaTrMHuRBWIsx5VqT
	5pPmM2Sw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wp5A0-000000002Nu-43M3;
	Wed, 29 Jul 2026 16:21:29 +0200
Date: Wed, 29 Jul 2026 16:21:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/2] gitignore: Only ignore top level *.m4
Message-ID: <amoMaIVP021_syPX@orbyte.nwl.cc>
References: <20260728101038.1213031-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728101038.1213031-1-phil@nwl.cc>

On Tue, Jul 28, 2026 at 12:10:37PM +0200, Phil Sutter wrote:
> This covered files in m4 subdirectory by accident. Assuming it is meant
> to catch auto-generated aclocal.m4, reduce its scope to non-subfolders.
> 
> Fixes: 5fa8e494ca240 ("build: autotools conversion")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
