Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB806137C32
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Apr 2024 17:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713547389; cv=none; b=Cx4I+Rfs5yIhOO6KF7ln5zwMFEb+8Wmg0asDJ8iXWzHuvGBn/JdgdFvuAumHq1CmVmHbPjvVpI4lrNW27msrYTu5ZOCCGKMDzxqDjgVTxkwEGE+i1HxdvyxP0Jy9l2bBgFUGv5wR8s+SeF9Vq0tAHrcgcAl821XwuwRFvAhtJ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713547389; c=relaxed/simple;
	bh=eoVvLdWapBlDLCfmqUPYdTbMerbo2Gn3ptdhdNoyzRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UI7a0tSKaQZcf1RA1Oh6B76DqUPsjfVStxbQdPm08NEePMy2kb+lSs7LP5cXV05uVf7JXJ+j/SoMcbg7NigIdp/1FYk6aBJngNWf28XHEi9phJGsnWzxn3oDVxoPs9/hxam8MNFvth1dCNeCz9xms+gjeAGzx1kr6TfYg+koIsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Fz5TNZDA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Fz5TNZDA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7aEtQlijc5eGYwUqbG/8su3BQeDiS7oFskbf3rIVQaY=; b=Fz5TNZDAiFUarzG1kpr0dMyKZM
	N9K9kkiQbkimUhHtObjFm2x07i1qRlFD1s+gN11GBX90u75ui9k+bgSHdkNLCyS/9phtgj0meeLm7
	ouvacWZjY22QqXML9wK0LRAnHNE3E7/j9ORr2CL3RpjbSv/f0zAbYbZDwwBQu6rwlL3NYqzawcFd4
	jLOr9ohF5kEXi6Ka5kjTqOvV3YRO4I8i6Bp7dog/QR6vnJykxT4/3KKg4UJ9eQdw+ppPu2gm8IwoV
	spAKkWizD2A/e7nJ9nAPGUvRSDEDtpL0lOfEFOkfkT8Re9l3tQF2ByimzulGjXoTC9xDhijR27A0k
	Sb4loKxQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rxrwx-0000000014t-0GCM;
	Fri, 19 Apr 2024 19:22:59 +0200
Date: Fri, 19 Apr 2024 19:22:58 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3] Add support for table's persist flag
Message-ID: <ZiKocqY8RbYztfU3@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240412113017.31073-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412113017.31073-1-phil@nwl.cc>

On Fri, Apr 12, 2024 at 01:30:17PM +0200, Phil Sutter wrote:
> Bison parser lacked support for passing multiple flags, JSON parser
> did not support table flags at all.
> 
> Document also 'owner' flag (and describe their relationship in nft.8.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
