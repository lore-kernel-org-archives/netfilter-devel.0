Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521E82D59E4
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 13:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752069260; cv=none; b=TC9u2G3M/Wx9R5kZA9hGTq0wBJj/bqQg8mMUJnSAELAr58vL0hLqmHJYWuf6GkpTjZD7tVonmKsF5ccMzq5FjgT4K0RiFWIlYiXF9DDLu6Z0IWmozuZ7Q68vHwdnh7IvyOWOGQi6o5xiBikYPwL3hmJaaRJYtHyagBuD0xBNXME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752069260; c=relaxed/simple;
	bh=VBWHhNhZH+lO8H7COSvIdIiwdaAsw/06nlH5RH9/I6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgeGzBFqfP6hrs9aSfpsYYx506XQFgLdGFqlbjssktsmiGSs8DrbRU9EHKxfeP8/2KtzVc1jRP5am2NhPC72OGLCEIzwlfmO16MH/B1yaOV6TbAu/xKtol+fR2nlz8/bEXFfMYToWYZ761LEVVrE0MAqGqJ7M1zoqr0WTmsqKgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2C8EA60637; Wed,  9 Jul 2025 15:47:10 +0200 (CEST)
Date: Wed, 9 Jul 2025 15:47:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] rule: print chain and flowtable devices in quotes
Message-ID: <aG5y2M2ZbaAGG2jb@strlen.de>
References: <20250708231128.2045876-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708231128.2045876-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Print devices in quotes, for consistency with:
> 
> - the existing chain listing with single device:
> 
>   type filter hook ingress device "lo" priority filter; policy accept
> 
> - the ifname datatype used in sets.
> 
> In general, tokens that are user-defined, not coming in the datatype
> symbol list, are enclosed in quotes.

Thanks a lot Pablo.  I checked tests/py and they still pass after this
also.

Acked-by: Florian Westphal <fw@strlen.de>
