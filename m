Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E39B33EB13
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757432152; cv=none; b=TZTa58mbUIKyl20KjFeAUWjsUYMxfkC+qwBaCoKIWZAeyXBOHHSR47UstH6R+841g5epxJHzdNWK9fFHiDtDv1QGX08V+3o3P4LDx+ItIDjQs+IffQy3twAgilOt53hj5DyUSGVM1vbfOoJg4nych/MZ7ezhKDkidwd7zbQX/Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757432152; c=relaxed/simple;
	bh=E63M8finUuf/zYE8s8algOOI/rIIJi/R8ENxKWaET2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KzbOw6JL7Er+zqAcXEEq9IYZpHjSnXmajPtNvM5CMQKDjFvHgJkHwF0sQ+xaAmmAZOJCprqpHViVJacBzbgL3nPKlMURbjNenj+A8ZN397cnoKBae157cFhRTsyxRC4XKsqyEFWtLKLexc2bnLiDUzIWDVnaPM+rd2Z2RWedejM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=m/h1D/o3; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="m/h1D/o3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uSqOBRildk9dGP+KJl1VgHjs2fiSzuSDsp3cvkxHFwI=; b=m/h1D/o3dnuJLT7Lb+zDEuE1uD
	NydVKKJfa8urn02fkMv6TfePWcF7kmSgEPb8mml1RiJGSRtBkUhF0SrSJeYUmdFzAoOwrDa26E/TJ
	U/myet9jAi6VVqooM7NPFcyO3sd6pAmEIzkYI22m6hQCdGYG8a9C8noAqS+lDL6iwG4nxxX1nYrTP
	uchpZZxVwR/0r/PfbLL70lsybCNVUJOu+1XXIgkMgCbMV4M936NHOVCXz8WBf/wA3V9aWR+JLB5Nz
	+lxQwqnkHUn0rYbE+2G/SQr/mSiPNXw8vXVahaoOMSRAnDbIUGkXz5ePlJzQ/bxaEzIXaAm0Kk906
	Nuc3qZiQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uw0Nm-000000002Iw-2YEg;
	Tue, 09 Sep 2025 17:35:46 +0200
Date: Tue, 9 Sep 2025 17:35:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
Subject: Re: [conntrack-tools PATCH v2] nfct: helper: Extend error message
 for EBUSY
Message-ID: <aMBJUkWsSzyJqH-E@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Yi Chen <yiche@redhat.com>
References: <20250828123330.30625-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828123330.30625-1-phil@nwl.cc>

On Thu, Aug 28, 2025 at 02:33:02PM +0200, Phil Sutter wrote:
> Users may be not aware the user space helpers conflict with kernel space
> ones, so add a hint about the possible cause of the EBUSY code returned
> by the kernel.
> 
> Cc: Yi Chen <yiche@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
