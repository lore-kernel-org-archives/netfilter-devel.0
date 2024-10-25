Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0760A21219A
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Oct 2024 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729867232; cv=none; b=W0FR2NmqWvqyod9YXNdnK/pyg0PSo6pS3Od4IXdv6perl55zI27hi6DLj3aJDBCMYqiV9u6sC28Y9wln70VkrJL3pz2A9UwH8RQK2cYySqEb/lf2IBV5fLSTh9G7mgAq3HE7TWQNtwRkARpel8zu33YLeVILXr/YYG8FoLgbyWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729867232; c=relaxed/simple;
	bh=ZPipQH97JSupkWlxP6jajYFs6WlyrAD6p6NGB0OVGUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dwan4+tnrUr4kd/9RYzpSx7fRuZpEFEjpT0rxY4BL0awQesXs9e7aokZapEqqznfc0prl2Vav7uNP10MgTtRTBWgH0wcvnJGSHL/5KAOAfSnGP0gxGXqXuYP2GKjp/eR34hBLmw/7FmYHAmLxA4yjk7wZUGcYT116eLgPNvGP6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iDkmTXgl; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iDkmTXgl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZPipQH97JSupkWlxP6jajYFs6WlyrAD6p6NGB0OVGUQ=; b=iDkmTXglD0pBYFguJu1nuuM1EN
	kQJJmnhdh557ManjR2xtETzfP8RTJoL3tUQvysaffjh6ZfKHT6ICqJDywYWdqghOm7tChi5Nd/rsF
	2+8c74fvEYjKWZq8PJlF+m0Ys6oO3Of18a8PYEs7XUwAxvdRSBk7EalBOKyf1KRWusNbSccfnonge
	9M7v4+bKiECgwtaS4801EerXMcqgahePnvJNb1548lTCWOUEWqTa4tYOxATAp2ilcRqr0581NBUNQ
	38nl1YJXuGg9gZaVsU9QIZCoow5hSV6f8qq01tj7Qk+XlH37tDh4gJV/EUeZeLo9QkQQUbHm5NKq2
	Mr2NVTjQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t4LUI-000000004zL-2gx3;
	Fri, 25 Oct 2024 16:40:26 +0200
Date: Fri, 25 Oct 2024 16:40:26 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 5/7] netfilter: nf_tables: avoid false-positive
 lockdep splats with basechain hook
Message-ID: <Zxut2rDLPtsjCEE6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241025133230.22491-1-fw@strlen.de>
 <20241025133230.22491-6-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025133230.22491-6-fw@strlen.de>

On Fri, Oct 25, 2024 at 03:32:22PM +0200, Florian Westphal wrote:
> Like previous patches: iteration is ok if the lost cannot be altered in

Typo: lost -> list

