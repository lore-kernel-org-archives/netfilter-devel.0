Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7881CD17
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2024 23:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707261951; cv=none; b=qNImc3OAPTjsGSjQl/rVt8W7U7nwj+jjk1/EwneHWMmXEUMx5tNLUl3cD+wa4NpzPKhsV95CYWxtQMFy9IWfXDoXXVUwSakPFDmtMOMTmRYaMifapj+gvjH6Qo9elkc4Fr5TULx+xXz7opYzpGUu5K8CCNU/hyH2ukqu1sZEQwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707261951; c=relaxed/simple;
	bh=OS+SNm6rQEisE0AwhakX9S4t/3uVV2WaoSbUmyGm3SE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hi7bwQ1LBPCtdVbGjC3+hRr53KtDZHaybxxQk2b8E8DuaYfK5f93DwS6PbD0Gy7q7i62TSYovbpmKGNei4fIAWVcAurxp/ji05oKVdsD2DXUgNMSPjWD8Uy137qowhNjxUkZ0TlkApPXPiCMBDnPPBWgVZkN+wEHPHJhA0g8acU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YLUVsu/2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YLUVsu/2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zi27l3uUGDW4tEC7JDjCj2H3D4WkVP4Jqp46EGZy/wk=; b=YLUVsu/2fI6gdOhnvq2E5Vz7S0
	bHJQu9DMLBHwcJUJfd5I1lj+IMdrJRV1ZSZTZK4vfIMsMP0xTuZuhFxvLnSFgxmCst3K7dzRk6Hpa
	G5KxOnsg7DMyfjf8bAjRckZSyTFosLwV5zQdKNcvlyHuk6saDc8NypDGqCHH8mj+uEPCvHsVHO2mg
	XIvo/ybyy1+Fm3n2C3TyJWmdO1lQnCN8P8Ma8t9qNhg4gkV6TDko9ihRUVMiFR3SxZl8btm6wA/9n
	3uI48hh622pGda8ZPVVkRGZHCA0lmT/+1EensPPNFhvQ3SdYvFAQbrWtBtTQIFp5DxLQUb04we+cq
	A57u0Xkw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXUp1-000000004F2-1Auc;
	Wed, 07 Feb 2024 00:25:47 +0100
Date: Wed, 7 Feb 2024 00:25:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: Re: [iptables PATCH v2 0/3] iptables-save: Avoid /etc/protocols
 lookups
Message-ID: <ZcK_-zo6mVQN4liC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20240110224136.11211-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240110224136.11211-1-phil@nwl.cc>

On Wed, Jan 10, 2024 at 11:41:33PM +0100, Phil Sutter wrote:
> V1 was a tad too simple: The revert is fine, but the (now) third patch
> changes iptables-save output and thus potentially breaks test cases. To
> avoid that, add patch 2 which enables "dccp" and "ipcomp" protocol names
> in output. Apart from that, a single shell test case expected '-p gre'
> in the dump. Replace the actually printed '-p 47' using sed in there.
> 
> Phil Sutter (3):
>   Revert "xshared: Print protocol numbers if --numeric was given"
>   libxtables: Add dccp and ipcomp to xtables_chain_protos
>   iptables-save: Avoid /etc/protocols lookups

Series applied.
