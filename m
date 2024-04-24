Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1588155358
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 22:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713996772; cv=none; b=HNZi9IRtH6NNuTzNnsGDyLPYjsHN90q3GhPuWkuLC553l+7sFZtJlyRRcYbpmOG4UVk7jTiW/UwdAxIowVmeP0u6IxaxOHEFSc6tlkOP4kk++FlG+T6T13+xCD7wAFxen3w6H4A3NA+nj0YZEGPnWDBObzIlSA6Asp7xYxbdpZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713996772; c=relaxed/simple;
	bh=MRaCs4ZMdgeIiNaUG7AksuwPw3f3t9ZrMtYsTkLyYpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxTFf9FIO/3LzuKAU7R9N00+V4BoBD5d7jfxM3XN6qm5/sUFV9Fa9IBxQUW/phTTJGLkvJBHQdnCW76cRl6O+5zp4vNhpdDiYq1Wha0Rdm+/ouWEfFGTtZwpjo24si25C59jEIYWgxozIuzlnt2TLOcLoO29To5y9Kns18OE9Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 25 Apr 2024 00:12:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Fix for memleak in __binop_expr_json
Message-ID: <ZimD2x6aaf29ZTyJ@calendula>
References: <20240424215821.19169-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240424215821.19169-1-phil@nwl.cc>

On Wed, Apr 24, 2024 at 11:58:21PM +0200, Phil Sutter wrote:
> When merging the JSON arrays generated for LHS and RHS of nested binop
> expressions, the emptied array objects leak if their reference is not
> decremented.
> 
> Fix this and tidy up other spots which did it right already by
> introducing a json_array_extend wrapper.

Thanks for fixing it up so quick, no more issues with tests/shell.

> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Fixes: 0ac39384fd9e4 ("json: Accept more than two operands in binary expressions")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
